# Live streaming

Live streaming turns your iPhone into a temporary camera source for `go2rtc`.

When you press `Start` on the `Live` tab, Swiftcam captures the selected phone camera and publishes it to `go2rtc` with WebRTC WHIP. The stream then becomes available in go2rtc under the configured stream name, so it can be viewed from go2rtc, reused by other clients, or referenced like any other go2rtc stream while Swiftcam is broadcasting.

## Required `go2rtc` configuration

Create an empty stream in `go2rtc` for the phone broadcast. The stream key must match the `Stream Name` shown in Swiftcam.

Minimal example:

```yaml
api:
  listen: ":1984"

webrtc:
  listen: ":8555"

streams:
  swiftcam-mobile:
```

In Swiftcam:

- Open the `Live` tab.
- Open `Stream`.
- Select the destination server.
- Set `Stream Name` to `swiftcam-mobile`, or use another stream name that exists in `go2rtc`.

Swiftcam sends the WHIP publish request to:

```text
http://GO2RTC_HOST:1984/api/webrtc?dst=swiftcam-mobile
```

If your `go2rtc API URL` is proxied, Swiftcam preserves that base path. For example, `https://example.com/proxy/go2rtc/api` becomes:

```text
https://example.com/proxy/go2rtc/api/webrtc?dst=swiftcam-mobile
```

## Stream name rules

Swiftcam normalizes the stream name before publishing:

- Letters are lowercased.
- Spaces and unsupported characters become `-`.
- Only letters, numbers, `-`, and `_` are kept.
- Empty values use `swiftcam-mobile`.

For example, `Swiftcam Phone` becomes `swiftcam-phone`.

## Network requirements

The iPhone must be able to reach the configured `go2rtc API URL`.

For local network use:

- The go2rtc API is usually TCP `1984`.
- The WebRTC listener is usually TCP/UDP `8555`.
- If go2rtc runs in Docker, expose the WebRTC port as both TCP and UDP.
- If go2rtc runs inside Frigate, host networking is usually the simplest setup.



## Swiftcam settings

The `Stream` sheet lets you configure:

- Destination server if multiple are configured
- Stream name
- Resolution
- Maximum video bitrate 
- Color or black/white mode.
- Max Audio bitrate from 96 to 320 Kbps.

## Viewing the phone stream

While Swiftcam is streaming, open the stream in go2rtc using the same stream name:

```text
http://GO2RTC_HOST:1984/stream.html?src=swiftcam-mobile
```

You can also use `swiftcam-mobile` as a go2rtc source name anywhere another go2rtc stream key is accepted.
