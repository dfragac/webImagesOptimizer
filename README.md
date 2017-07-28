# Image Optimizer Shell Script

A bunch of shell lines I frecuently use to optimize images for web.

## Requisites:
 - convert: Imagemagick
 - jpegoptim: To compress and optimize JPEGs
 - optipng: To optimize PNGs

## Installation of requisites (Ubuntu/Debian):
Install them as usually on your distro:
```sudo apt-get install imagemagick jpegoptim optipng -y```

## Use:
Simply copy your folder of images you want to process (Script is recursive so it will climb up all the folders) to keep originals safe. Execute script passing the folder you want to process:

```./optimizeImages.sh FOLDER_TO_PROCESS```
