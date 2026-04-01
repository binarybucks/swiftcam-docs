# Adding Cameras

This page explains how camera configuration in Swiftcam maps to `go2rtc`, Frigate NVR, and Swiftcam Server.

## Open Camera Settings

In the app:

1. Open `Settings`.
2. Open `Cameras`.
3. Tap `+` to add a camera, or open an existing camera to edit it.

## Streams

Swiftcam does not discover stream names automatically at runtime for playback. The values you enter must match stream keys in your `go2rtc` config.

Example `go2rtc` config:

```yaml
streams:
  front_door_main: rtsp://user:pass@192.168.1.20:554/stream1
  front_door_sub: rtsp://user:pass@192.168.1.20:554/stream2
```

Matching Swiftcam camera config:

- `Main` stream name: `front_door_main`(required)
- `Sub` stream name: `front_door_sub` (optional)


## Snapshot sources

The snapshot source specifies from where the low bandwith snapshots of the list views are loaded

### Go2rtc

Uses `Main` stream name with `go2rtc` frame endpoint (`/api/frame.jpeg?src=<main_stream_name>`)
Go2rtc frame.jpeg API is lazy and tends to time out or take long to response, especially on cameras with long I-frame intervals.

### Frigate NVR

Uses Frigate NVR latest snapshot endpoint for one camera (`/api/<camera>/latest.webp`).
Name resolution:
- Camera `Name` with spaces replaced by `_`
- If the camera name you set in Swiftcam differs from the one configured in Frigate NVR, use the `Name` override

### Swiftcam Server

Uses Swiftcam Server snapshot websocket stream subscription.
Name resolution:
- Camera `Name` with spaces replaced by `_`
- If the camera name you set in Swiftcam differs from the one configured in Swiftcam Server, use the `Name` override

### Custom URL

Directly fetches a JPEG Image from the configured URL (e.g. directly from the camera)
- Uses the exact URL from `URL`.
- Must be a valid `http://` or `https://` URL.


## Quick troubleshooting

- Stream not loading:
  - Verify `Main`/`Sub` names exactly match `go2rtc` stream keys.
- Snapshot missing with `go2rtc` source:
  - Verify `Main` stream is set and resolves in `go2rtc`.
- Snapshot missing with `Frigate NVR` source:
  - Verify Frigate NVR base URL/auth and camera name override.
- Snapshot missing with `Swiftcam Server` source:
  - Verify server URL/auth, Pro status, and override/default stream name.
