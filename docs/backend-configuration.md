# Backend Configuration

This is the first step in Swiftcam setup.

Swiftcam needs a configured go2rtc instance for live streaming cameras.
The go2rtc API (typically at `:1984/api`), WebRTC signaling websocket (typically at `:1984/api/ws`) and WebRTC streaming port (typically at `:8555`) needs to be reachable. 
When using Frigate NVR, the bundled go2rtc installation can be used without issues. 

## Minimal `go2rtc` config example

```yaml
api:
  listen: ":1984"

webrtc:
  listen: :8555

streams:
  front_door_main: rtsp://user:pass@192.168.1.20:554/stream1
  front_door_sub: rtsp://user:pass@192.168.1.20:554/stream2
```

## Verify go2rtc connection

```bash
curl -sS http://GO2RTC_HOST:1984/api/streams
curl -sS "http://GO2RTC_HOST:1984/api/frame.jpeg?src=front_door_main" -o /tmp/front_door.jpg
```

## Required matching in camera settings

The stream names configured per camera in Swiftcam must exactly match your keys under `go2rtc` `streams:`.

Example:

- `Main` stream in Swiftcam: `front_door_main`
- `Sub` stream in Swiftcam: `front_door_sub`

## Next step

Continue with: [Connection configuration](app-connection-configuration.md)
