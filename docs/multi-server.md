# Multi Server

Swiftcam supports multiple servers, so cameras from different locations can be added. 

## Availability

- Multi-server configuration is available in Swiftcam Pro.
- Without Pro, Swiftcam keeps a single active server setup (`Default`).

## Getting started

In the app:

1. Open `Settings`.
2. Open `Servers`.
3. Tap `+` to create another server account.

Each server can have its own go2rtc, Frigate NVR and Swiftcam Server endpoints. 

## Connection mode per server

Each server also has a `Connection Mode`:

- `Global`: one endpoint profile for all networks
- `Split`: uses `Global` normally, switches to `Wi-FI` profile when current Wi-Fi matches
- `Wi-Fi only`: Only connect when current Wi-Fi matches one of the configured SSIDs.  

For `Split` and `Wi-Fi only`, add one or more Wi-Fi names in the server settings.

Cameras from `Wi-Fi only`servers are not available when outside of the configured networks. 
They can optionally be hidden in the `Apperance` settings. 

## Assign cameras to servers

In camera settings (`Settings` -> `Cameras` -> add/edit camera):

- Use the `Server` picker to select which server account that camera uses.
- API calls for stream playback, snapshots, and events are resolved from the selected server endpoints depending on the connection mode.

This allows mixed setups, for example:

- Home cameras on one server account
- Vacation home cameras on a second server account
- Office cameras only shown when at the office

When you delete a server or if the Swiftcam Pro subscription expires, the cameras can be reassigned by using the server picker.

## Recommended setup flow

1. Create all required server accounts in `Settings` -> `Servers`.
2. Configure endpoint URLs/auth for each account.
3. Run connection tests in each server account.
4. Assign every camera to the correct `Server` in camera settings.

## Troubleshooting

- A server does not work on mobile data:
  - Use `Global` or `Split` mode and configure a reachable `Global` endpoint profile.
- A Wi-Fi-only server appears unavailable:
  - Confirm current SSID is listed exactly in the server's Wi-Fi list.
- Camera cannot load stream/snapshots:
  - Confirm the camera is assigned to the intended server account.
  - Re-run endpoint tests in that server account.
