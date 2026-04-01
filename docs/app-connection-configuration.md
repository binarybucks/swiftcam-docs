# Swiftcam App Connection Configuration

This is the second step in setup, after configuring `go2rtc`.

In Swiftcam, open `Settings` -> `Server`.

## Go2rtc API

- Set `go2rtc API URL` to `http(s)://GO2RTC_HOST:1984/api`.
- Change protocol, port and `/api` paths as required when using a reverse proxy 
- Configure go2rtc authentication in Swiftcam if enabled on your server.
- Use the connection test button next to the field to verify access.

## Frigate NVR API (optional)

Frigate NVR is optional, but required for events and Frigate NVR snapshot source.

- When using unauthenticated access, set `Frigate NVR API URL` to `http(s)://FRIGATE_HOST:5000/api`
- When using authenticate access, set `Frigate NVR API URL` to `http(s)://FRIGATE_HOST:8971/api`
- Change protocol, port and `/api` paths as required when using a reverse proxy 
- Choose auth mode configured in Frigate NVR : `None`, `Basic`, or `Bearer` and fill credentials as required
- Check if connection succeeds using the connection test button.

## Swiftcam Server API (optional)

Swiftcam Server is optional and can be used for:

- Low-latency snapshot streaming.
- Proxying go2rtc and Frigate NVR through one endpoint.

Configure:

- Set `Swiftcam Server API URL` to `http://SWIFTCAM_SERVER_HOST:8090/api`.
- Configure Swiftcam Server auth in Swiftcam if enabled (`auth_username` / `auth_password`).
- Run the connection test button.

Install/configure server details: [Swiftcam Server](swiftcam-server.md)

### Optional proxy toggles

If Swiftcam Server is configured accordingly, you can enable:

- `Proxy go2rtc`
- `Proxy Frigate NVR`

Use this when:

- iPhone should only access one backend endpoint.
- You want centralized auth at Swiftcam Server.
- go2rtc/Frigate NVR are not directly reachable from the phone network.

Note: go2rtc WebRTC port reachability still matters for live stream playback.

## Troubleshooting checklist

- `go2rtc` not reachable:
  - Confirm URL points to `/api` and not the plain go2rtc web interface.
  - Confirm the app can reach host and port from phone network
- WebRTC not starting:
  - Confirm go2rtc WebRTC port exposure/routing.
  - Confirm stream names are correct in camera settings.
  - When runnign go2rtc from Frigate NVR or Docker, host networking is reccomended 
  - Check if go2rtc needs explicit webrtc listen adressses and candidates for WebRTC conection 
  
- Frigate NVR events missing:
  - Confirm Frigate NVR auth mode.
  - Confirm Frigate NVR API URL and `/api` path.

- Proxy mode failing:
  - Confirm Swiftcam Server `go2rtc_base_url` and `frigate_base_url`. 
  - When using Docker networking, confirm that Swiftcam Server can reach go2rtc and/or Frigate NVR containers 
