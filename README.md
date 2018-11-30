Batch Re-Container video files.

Examples:

convert all video files in the current directory to "video/mp4", using ffmpeg.
```
2mp4.sh
```
all video files in current directory to "video/x-flv".
```
2mp4.sh flv
```
Notes

* what files are videos is determined by the operating systems mime types.

* the codec in the source file must be compatible with the target container.

* the container(s) must be supported by the conversion program. 

