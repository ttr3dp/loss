# loss

Split and transcode lossless image files in a blink of an eye.

## Build

Creating an executable binary can be done with:

`crystal build --release ./loss.cr`

## Usage

Just provide a directory path containing lossless image files with
appropriate CUE sheets. loss will scan the whole directory tree in order to
(firstly) split and then convert the separate tracks to mp3 format.

```sh
loss down/Gary\ Moore\ -\ 2021\ -\ How\ Blue\ Can\ You\ Get\ \(Limited\ Edition\ Boxset\)\ \[CD-FLAC\]

Processing /home/ttr3dp/down/Gary Moore - 2021 - How Blue Can You Get (Limited Edition Boxset) [CD-FLAC]/Gary Moore - How Blue Can You Get.cue
Creating output directory --> /home/ttr3dp/down/Gary Moore - 2021 - How Blue Can You Get (Limited Edition Boxset) [CD-FLAC]/transcoded
Spliting /home/ttr3dp/down/Gary Moore - 2021 - How Blue Can You Get (Limited Edition Boxset) [CD-FLAC]/Gary Moore - How Blue Can You Get.flac...

Transcoding [/home/ttr3dp/down/Gary Moore - 2021 - How Blue Can You Get (Limited Edition Boxset) [CD-FLAC]/transcoded/07.Done Somebody Wrong.flac] -->
[/home/ttr3dp/down/Gary Moore - 2021 - How Blue Can You Get (Limited Edition Boxset) [CD-FLAC]/transcoded/07.Done Somebody Wrong.mp3]
Transcoding [/home/ttr3dp/down/Gary Moore - 2021 - How Blue Can You Get (Limited Edition Boxset) [CD-FLAC]/transcoded/02.Steppin' Out.flac] --> [/home/ttr3dp/down/Gary Moore - 2021 - How Blue Can You Get (Limited Edition Boxset) [CD-FLAC]/transcoded/02.Steppin' Out.mp3]
Transcoding [/home/ttr3dp/down/Gary Moore - 2021 - How Blue Can You Get (Limited Edition Boxset) [CD-FLAC]/transcoded/05.Looking At Your Picture.flac]
--> [/home/ttr3dp/down/Gary Moore - 2021 - How Blue Can You Get (Limited Edition Boxset) [CD-FLAC]/transcoded/05.Looking At Your Picture.mp3]
Transcoding [/home/ttr3dp/down/Gary Moore - 2021 - How Blue Can You Get (Limited Edition Boxset) [CD-FLAC]/transcoded/03.In My Dreams.flac] --> [/home/ttr3dp/down/Gary Moore - 2021 - How Blue Can You Get (Limited Edition Boxset) [CD-FLAC]/transcoded/03.In My Dreams.mp3]
Transcoding [/home/ttr3dp/down/Gary Moore - 2021 - How Blue Can You Get (Limited Edition Boxset) [CD-FLAC]/transcoded/06.Love Can Make A Fool Of You.flac] --> [/home/ttr3dp/down/Gary Moore - 2021 - How Blue Can You Get (Limited Edition Boxset) [CD-FLAC]/transcoded/06.Love Can Make A Fool Of You.mp3]
Transcoding [/home/ttr3dp/down/Gary Moore - 2021 - How Blue Can You Get (Limited Edition Boxset) [CD-FLAC]/transcoded/08.Living With The Blues.flac] --> [/home/ttr3dp/down/Gary Moore - 2021 - How Blue Can You Get (Limited Edition Boxset) [CD-FLAC]/transcoded/08.Living With The Blues.mp3]
Transcoding [/home/ttr3dp/down/Gary Moore - 2021 - How Blue Can You Get (Limited Edition Boxset) [CD-FLAC]/transcoded/01.I'm Tore Down.flac] --> [/home/ttr3dp/down/Gary Moore - 2021 - How Blue Can You Get (Limited Edition Boxset) [CD-FLAC]/transcoded/01.I'm Tore Down.mp3]
Transcoding [/home/ttr3dp/down/Gary Moore - 2021 - How Blue Can You Get (Limited Edition Boxset) [CD-FLAC]/transcoded/04.How Blue Can You Get.flac] --> [/home/ttr3dp/down/Gary Moore - 2021 - How Blue Can You Get (Limited Edition Boxset) [CD-FLAC]/transcoded/04.How Blue Can You Get.mp3]

Removing [/home/ttr3dp/down/Gary Moore - 2021 - How Blue Can You Get (Limited Edition Boxset) [CD-FLAC]/transcoded/01.I'm Tore Down.flac]
Removing [/home/ttr3dp/down/Gary Moore - 2021 - How Blue Can You Get (Limited Edition Boxset) [CD-FLAC]/transcoded/02.Steppin' Out.flac]
Removing [/home/ttr3dp/down/Gary Moore - 2021 - How Blue Can You Get (Limited Edition Boxset) [CD-FLAC]/transcoded/03.In My Dreams.flac]
Removing [/home/ttr3dp/down/Gary Moore - 2021 - How Blue Can You Get (Limited Edition Boxset) [CD-FLAC]/transcoded/04.How Blue Can You Get.flac]
Removing [/home/ttr3dp/down/Gary Moore - 2021 - How Blue Can You Get (Limited Edition Boxset) [CD-FLAC]/transcoded/05.Looking At Your Picture.flac]
Removing [/home/ttr3dp/down/Gary Moore - 2021 - How Blue Can You Get (Limited Edition Boxset) [CD-FLAC]/transcoded/06.Love Can Make A Fool Of You.flac]
Removing [/home/ttr3dp/down/Gary Moore - 2021 - How Blue Can You Get (Limited Edition Boxset) [CD-FLAC]/transcoded/07.Done Somebody Wrong.flac]
Removing [/home/ttr3dp/down/Gary Moore - 2021 - How Blue Can You Get (Limited Edition Boxset) [CD-FLAC]/transcoded/08.Living With The Blues.flac]

Tagging [/home/ttr3dp/down/Gary Moore - 2021 - How Blue Can You Get (Limited Edition Boxset) [CD-FLAC]/transcoded/01.I'm Tore Down.mp3]
Tagging [/home/ttr3dp/down/Gary Moore - 2021 - How Blue Can You Get (Limited Edition Boxset) [CD-FLAC]/transcoded/02.Steppin' Out.mp3]
Tagging [/home/ttr3dp/down/Gary Moore - 2021 - How Blue Can You Get (Limited Edition Boxset) [CD-FLAC]/transcoded/03.In My Dreams.mp3]
Tagging [/home/ttr3dp/down/Gary Moore - 2021 - How Blue Can You Get (Limited Edition Boxset) [CD-FLAC]/transcoded/04.How Blue Can You Get.mp3]
Tagging [/home/ttr3dp/down/Gary Moore - 2021 - How Blue Can You Get (Limited Edition Boxset) [CD-FLAC]/transcoded/05.Looking At Your Picture.mp3]
Tagging [/home/ttr3dp/down/Gary Moore - 2021 - How Blue Can You Get (Limited Edition Boxset) [CD-FLAC]/transcoded/06.Love Can Make A Fool Of You.mp3]
Tagging [/home/ttr3dp/down/Gary Moore - 2021 - How Blue Can You Get (Limited Edition Boxset) [CD-FLAC]/transcoded/07.Done Somebody Wrong.mp3]
Tagging [/home/ttr3dp/down/Gary Moore - 2021 - How Blue Can You Get (Limited Edition Boxset) [CD-FLAC]/transcoded/08.Living With The Blues.mp3]

```

## Notes

- Matching cue sheet file (if there is one) is found automaticaly
- loss will take info from CUE sheet and create IDv2 tags to mp3 files
- loss is spliting and transcoding files concurently in order to speed up the
process (this can lead to high CPU usage if there is a massive number of image files)
- "Gap files" are automaticaly removed (`pregap.mp3, postgap.mp3`)
- There are still some bugs when it comes to log output (will be fixed in the future)
