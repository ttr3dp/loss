require "file_utils"

LOSS_EXTS = [
  "flac",
  "ape",
  "wav",
  "wv"
]

struct Cue
  property path : Path
  property info : Hash(String, String)
  property tracks : Array(Hash(String, String))

  def initialize(path, info, tracks)
    @path = path
    @info = info
    @tracks = tracks
  end

  def split?
    info.["file"].nil? && tracks.all? { |t| t.has_key?("file") }
  end

  def dir
    path.parent
  end

  def needs_splitting?
    !split? && tracks.size > 1
  end
end

def msg(txt : String)
  puts "INFO: #{txt}"
end

def warning(txt : String)
  puts "WARNING: #{txt}"
end

def err(msg : String)
  puts "ERROR: #{msg}"
end

def err(msg : String, code : Int32)
  err(msg)
  exit code
end

# FILE "Artist - ReleaseName.flac" WAVE
FILE = /^FILE /

# FILE "Artist - ReleaseName.flac" WAVE
# |-> Artist - RelaseName.flac
FILE_NAME = /^FILE "(.*)" WAVE/

#  TRACK 01 AUDIO
TRACK = /^\s{2}TRACK /

#    TITLE "Track title"
#    PERFORMER "Artist"
#    REM COMPOSER ""
#    INDEX 01 00:00:00
TRACK_INFO = /^\s{4}(?!INDEX)/

# REM GENRE "Gothic Metal"
# REM DATE 2021
# REM DISCID 9D0DFA0B
# REM COMMENT "ExactAudioCopy v1.3"
# PERFORMER "Performer"
# TITLE "Album title"
# REM COMPOSER ""
ALBUM_INFO = /^\w/

def parse_cue_file(file : String)
  lines = File.read_lines(file)
  info = {} of String => String
  tracks = [] of Hash(String, String)
  current_track_nr = 0

  lines.each do |line|
    # Remove REM(ark) prefix
    sanitized = line.gsub(/^REM /, "")

    case sanitized
    when FILE
      # FILE "Artist - ReleaseName.flac" WAVE
      # |-> { "file": "file/path/dir/Artist - ReleaseName.flac" }
      info["file"] = Path[file].parent.join(line[FILE_NAME, 1]).to_s
    when ALBUM_INFO
      # PERFORMER "Performer"
      # |-> { "performer": "Performer" }
      split = sanitized.strip(" ").split(" ")
      key = split[0].downcase
      val = split[1..-1].join(" ").strip(" \"")
      info[key] = val if !val.empty?
    when TRACK
      #  TRACK 01 AUDIO
      # |-> { "nr": "1 }
      tracks << {} of String => String
      current_track_nr += 1
      tracks[-1]["nr"] = current_track_nr.to_s
    when TRACK_INFO
      #    TITLE "Track title"
      # |-> { "title": "Track title" }
      split = sanitized.strip(" ").split(" ")
      key = split[0].downcase
      val = split[1..-1].join(" ").strip(" \"")
      tracks[-1][key] = val if !val.empty?
    else
      # skip
    end
  end

  Cue.new(Path[file], info, tracks)
end

def split(cue : Cue, outdir : Path)
  if !Dir.exists?(outdir)
    puts "Creating output directory --> #{outdir}\n"
    Dir.mkdir(outdir)
  end

  lossless_file = cue.info["file"]

  args : Array(String) = [
    "-f", cue.path.to_s,
    "-t", "%n.%t",
    "-d", outdir.to_s,
    "-o", "flac",
    lossless_file,
  ]

  puts "Spliting #{lossless_file}..."
  Process.run("shnsplit", args, error: STDOUT)
  puts
end

def transcode(files : Array(String))
  channel = Channel(Array(String)).new(capacity: files.size)
  files.each do |file|
    spawn do
      outfile_dir = Path[file].parent
      outfile_name = Path[file].stem

      outfile = "#{outfile_dir.join(outfile_name)}.mp3"
      args : Array(String) = [
        "-stats",
        "-i", file,
        "-vn",
        "-ar", "44100",
        "-q:a", "0",
        outfile
      ]

      Process.run("ffmpeg", args, error: STDOUT)
      channel.send([file, outfile])
    end
  end

  files.each do |_|
    file, outfile = channel.receive
    puts "Transcoding [#{file}] --> [#{outfile}]"
  end

  puts
end

def remove_files(files : Array(Path) | Array(String))
  files.each do |flac_file|
    puts "Removing [#{flac_file}]"
    FileUtils.rm(flac_file.to_s)
  end

  puts
end

def remove_gapfiles(dir : Path)
  gapfiles = Dir.glob(dir.join("*{pregap,postgap}.mp3")).map { |d| Path[d] }
  if gapfiles.any?
    remove_files(gapfiles)
    puts
  end
end

def tag(dir : Path, cue : Cue)
  mp3s = Dir.glob(dir.join("*.mp3")).sort

  if mp3s.size != cue.tracks.size
    err("There is a mismatch between the number of mp3 files and cue tracks #{dir}")
  end

  tracks = mp3s.zip(cue.tracks)
  total_tracks = mp3s.size

  tracks.each do |mp3, info|
    puts "Tagging [#{mp3}]"
    args = [
      "-a", info["performer"]? || cue.info["performer"],
      "-A", cue.info["title"],
      "-t", info["title"],
      "-T", "#{info["nr"]}/#{total_tracks}",
      "-y", info["date"]? || cue.info["date"]? || "",
      mp3
    ]

    Process.run("id3v2", args, input: STDIN, output: STDOUT, error: STDOUT)
  end

  puts
end

def process(dir : Path, fpaths : Array(Path))
  cue_files = Dir.glob(dir.join("*.cue")).sort

  if cue_files.none?
    # no cue
  else
    processed_files = {} of String => Nil

    cue_files.each do |cue_file|
      puts "Processing #{cue_file}"
      outdir = Path[cue_file].normalize.parent.join("transcoded")
      cue = parse_cue_file(cue_file)

      if !File.exists?(cue.info["file"])
        warning("#{cue.info["file"]} does not exist. Skipping...")
        next
      end

      if processed_files.any?
        next if processed_files.has_key?(cue.info["file"])

        if processed_files.size == 1
          prev_outdir = outdir.join("CD 1")
          puts "Creating directory [#{prev_outdir}]"
          FileUtils.mkdir(prev_outdir.to_s)

          flacs = Dir.glob(outdir.join("*.{flac,mp3}")).sort
          flacs.each do |f|
            dest = prev_outdir.join(Path[f].basename)
            puts "Moving [#{f}] --> [#{dest}]"
            FileUtils.mv(f, dest.to_s)
          end
        end

        outdir = outdir.join("CD #{processed_files.size + 1}")
        FileUtils.mkdir(outdir.to_s)
      end

      if cue.needs_splitting? # multi-track release
        split(cue, outdir)
        lossless_files = Dir.glob(outdir.join("*.flac")).sort
      elsif cue.tracks.size == 1 # single-track release (no need for splitting)
        track = cue.tracks[0]
        file = outdir.join(
          "#{sprintf("%02d", track["nr"].to_i)}.#{track["title"]}#{Path[cue.info["file"]].extension}"
        )

        Dir.mkdir(outdir.to_s)
        FileUtils.cp(cue.info["file"], file.to_s)
        lossless_files = [file.to_s]
      else # already split
        lossless_files = cue.tracks.map { |t| cue.dir.join(t["file"]).to_s }
      end

      transcode(lossless_files)
      remove_files(lossless_files)
      remove_gapfiles(outdir)
      tag(outdir, cue)

      processed_files[cue.info["file"]] = nil
    end
  end
end

def main(input : String)
  dir = Path[input].expand(home: true).normalize

  if !Dir.exists?(dir)
    err("directory '#{dir}' not found!", 1)
  end

  loss_globs = LOSS_EXTS.map { |ext| dir.join("**", "*.#{ext}") }
  loss_dirs = Hash(Path, Array(Path)).new

  Dir.glob(loss_globs).sort.each do |loss_file|
    file_path = Path[loss_file]
    path = file_path.parent

    loss_dirs[path] ||= [] of Path
    loss_dirs[path] << file_path
  end

  if loss_dirs.size == 0
    err("no lossless files found!", 1)
  end

  channel = Channel(Path).new

  loss_dirs.each do |k, v|
    spawn do
      process(k, v)
      channel.send(k)
    end
  end

  loss_dirs.each do |_|
    channel.receive
  end
end

main(ARGV[0])
