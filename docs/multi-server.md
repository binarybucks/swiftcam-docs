# Multi Server

Swiftcam supports multiple servers, so cameras from different locations can be added. 

## Availability

- Multi-server configuration is available in Swiftcam Pro.
- Without Pro, Swiftcam keeps a single active server setup (`Default`).
- The default server cannot be deleted. All others can be deleted by swiping the list item. 

## Getting started

In the app:

1. Open `Settings`.
2. Open `Servers`.
3. Tap `+` to create another server.

Each server can have its own go2rtc, Frigate NVR and Swiftcam Server endpoints. 

## Connection mode per server

Each server can have a `Global` and a `Wi-Fi` endpoint configuration set.

- `Wi-Fi`: Only used when current Wi-Fi matches one of the configured SSIDs.  
- `Global`: Used for all other networks. 

Cameras from servers that only have a `Wi-Fi` endpoint, are not available when outside of the configured network. 
They can optionally be hidden in the `Apperance` settings. 

## Assign cameras to servers

In camera settings (`Settings` -> `Cameras` -> add/edit camera):

- Use the `Server` picker to select which server  that camera uses.
- API calls for stream playback, snapshots, and events are resolved from the selected server endpoints depending on the connection mode.

This allows mixed setups, for example:

- Home cameras on one server 
- Vacation home cameras on a second server 
- Office cameras only shown when at the office

When you delete a server or if the Swiftcam Pro subscription expires, the cameras can be reassigned by using the server picker.


## Troubleshooting

- A Wi-Fi-only server appears unavailable:
  - Confirm current SSID is listed exactly in the server's Wi-Fi list.
- Camera cannot load stream/snapshots:
  - Confirm the camera is assigned to the intended server.
  - Re-run endpoint tests in that server .
