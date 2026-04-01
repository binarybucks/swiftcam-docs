# Advanced camera settings

This page explains advanced camera settings. 

## Availability

- Multi-server configuration is available in Swiftcam Pro.
- Without Pro, Swiftcam keeps a single active server setup (`Default`).
- Existing saved advanced values are preserved but not applied when Pro is inactive and become active again when Pro is enabled.

## Getting started

Open an existing camera, then `Advanced Camera Settings` to configure the following settings. 

Main and Sub Stream: 

- `Rotation`: Rotates the main stream in the applied direction
- `Mirro`r: Mirrors the stream
- `Fit horizontally`: stretches the stream to fill the viewport in horizontal direction, mainaining aspect ratio
- `Fit verticall`: stretches the stream to fill the viewport in vertical direction, mainaining aspect ratio
- `Fit horizontally` & `Fit vertically`: stretches the steam to fill the whole viewport, ignoring aspect ratio
- `Foce aspect ratio`: Override received stream aspect ratio, e.g. turn a 4:3 stream into a 16:9 stream 
  
Snapshot Format:

- `Foce aspect ratio`: Override received snapshot aspect ratio, e.g. turn a 4:3 snapshot image into a 16:9 snapshot image 

WebRTC:

  - `Transport`: Select transport protocl used for WebRTC. `Automatic` (default), `UDP` or `TCP`

Fullscreen:

  - `Disable rotate to fullscreen`. Usefull when having a 9:16 hallway mode camera stretched to fullscreen already with `fit` settings. 

