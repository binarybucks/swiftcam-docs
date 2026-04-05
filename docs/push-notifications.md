# Push Notifications

When notifications are enabled, Swiftcam devices automatically register with the push server at `https://push.swiftcam.app` and receive a static 256-bit `USER_ID` token.

Use that `USER_ID` to send notifications to: `https://push.swiftcam.app/api/push/notify`


## Device mapping

Each `USER_ID` maps to exactly one APNs device token.
If another device registers with the same `USER_ID`, the new token replaces the previous one.


## Send Notification from command line
The following curl command sends a notification and a live snapshot from the configured snapshot provider for the camera named "Garden" is attached. Tapping the notifications directly opens the live stream for the camera. 


```bash
curl -X POST "https://push.swiftcam.app/api/push/notify" \
  -H "Content-Type: application/json" \
  -d '{
    "user_id": "YOUR_USER_ID",
    "title": "Bird detected",
    "body": "Garden",
    "camera_name": "Garden",
    "snapshot_kind": "live",
    "open": "live"
  }'
```

## Send Notification from Home Assistant 

### Home Assistant `rest_command`
The following rest_command provides a shared command that can be used as action in Home Assistant. 

```yaml
rest_command:
  swiftcam_notify:
    url: "https://push.swiftcam.app/api/push/notify"
    method: post
    content_type: "application/json"
    payload: >
      {
        "user_id": "{{ user_id }}",
        "title": "{{ title }}",
        "body": "{{ body }}",
        "camera_name": "{{ camera_name }}",
        "event_id": "{{ event_id }}",
        "playback_timestamp": "{{ playback_timestamp }}",
        "snapshot_kind": "{{ snapshot_kind }}",
        "open": "{{ open }}"
      }
```


### Home Assistant Live Snapshot Notification
Below is an example automation to send a notification if a binary_sensor changes to on.
The app will show a fresh snapshot from the configured snapshot provider and directly open the camera live stream, if the notification is tapped. 

```yaml
automation:
  - alias: "Swiftcam live snapshot on garden motion"
    trigger:
      - platform: state
        entity_id: binary_sensor.garden_motion
        to: "on"
    action:
      - service: rest_command.swiftcam_notify
        data:
          user_id: "YOUR_USER_ID"
          title: "Motion detected"
          body: "Garden"
          camera_name: "Garden"
          snapshot_kind: "live"
          open: "live"
```

### Home Assistant Frigate NVR Event Notification
Below is an example automation to send a notification for a Frigate NVR event snapshot to Swiftcam. 
The app connects to Frigate NVR server and loads the event snapshot. 
Tapping the notification opens the Frigate NVR event details. 

```yaml
automation:
  - alias: "Swiftcam push from Frigate NVR MQTT events"
    mode: parallel
    trigger:
      - platform: mqtt
        topic: frigate/events
    condition:
      # Send only on new tracked object events.
      - condition: template
        value_template: "{{ trigger.payload_json.type == 'new' }}"
      # Optional: only notify for selected labels.
      - condition: template
        value_template: "{{ trigger.payload_json.after.label in ['person', 'car', 'dog', 'cat', 'bird'] }}"
    action:
      - variables:
          event: "{{ trigger.payload_json.after }}"
          camera: "{{ event.camera }}"
          label: "{{ event.label | title }}"
          event_id: "{{ event.id }}"
      - service: rest_command.swiftcam_notify
        data:
          user_id: "YOUR_USER_ID"
          title: "{{ label }} detected"
          body: "{{ camera }}"
          camera_name: "{{ camera }}"
          event_id: "{{ event_id }}"
          snapshot_kind: "frigate_event"
          open: "event"
```

### Home Assistant Frigate NVR Event Notification (Open Playback At Event Timestamp)
Below is an example automation that opens Swiftcam camera playback directly at the Frigate NVR event timestamp.  
It still uses the Frigate NVR event snapshot for the notification image.

```yaml
automation:
  - alias: "Swiftcam playback from Frigate NVR MQTT events"
    mode: parallel
    trigger:
      - platform: mqtt
        topic: frigate/events
    condition:
      - condition: template
        value_template: "{{ trigger.payload_json.type == 'new' }}"
    action:
      - variables:
          event: "{{ trigger.payload_json.after }}"
          camera: "{{ event.camera }}"
          label: "{{ event.label | title }}"
          event_id: "{{ event.id }}"
          event_start: "{{ event.start_time }}"
      - service: rest_command.swiftcam_notify
        data:
          user_id: "YOUR_USER_ID"
          title: "{{ label }} detected"
          body: "{{ camera }}"
          camera_name: "{{ camera }}"
          event_id: "{{ event_id }}"
          playback_timestamp: "{{ event_start }}"
          snapshot_kind: "frigate_event"
          open: "playback"
```



## API: `/api/push/notify`

`POST https://push.swiftcam.app/api/push/notify`

### Request Body

```json
{
  "user_id": "64-char-hex-user-id",
  "title": "Bird detected",
  "body": "Front Door",
  "camera_name": "Front Door",
  "event_id": "1739987.123",
  "playback_timestamp": 1739987123.456,
  "snapshot_kind": "frigate_event",
  "open": "playback"
}
```

### Fields

- `user_id` (string, required): static 256-bit user token as 64 hex chars.
- `title` (string, required): push title.
- `body` (string, required): push body text.
- `snapshot_kind` (string, optional): `live`, `frigate_event`, or `url`.
- `open` (string, optional): `live` (default), `event`, or `playback`.
- `event_id` (string, required when `snapshot_kind=frigate_event`).
- `playback_timestamp` (number|string, required when `open=playback`): Unix timestamp (seconds; milliseconds also supported).
- `camera_id` (string, optional): camera identifier.
- `camera_name` (string, optional): camera name.
- `camera` (string, optional): compatibility alias for camera name.
- `snapshot_url` (string, required when `snapshot_kind=url`).
- `badge` (integer, optional).
- `sound` (string, optional).
- `payload` (object, optional): custom payload values.
- `collapse_id` (string, optional).
- `thread_id` (string, optional).
- `expires_in_seconds` (integer, optional).

### Validation Rules

- `title` and `body` must be present.
- `open=event` requires `snapshot_kind=frigate_event`.
- `open=playback` requires `camera_id` or `camera_name` (or `camera`) and `playback_timestamp`.
- `snapshot_kind=live` requires `camera_id` or `camera_name` (or `camera`).
- `snapshot_kind=url` requires `snapshot_url`.
- Unsupported `snapshot_kind` values are rejected.
- Registering a new device token for an existing `user_id` replaces the previous token for that user.

### Responses

- `200 OK`: delivered to the registered device (`status: "sent"` with counts).
- `202 Accepted`: user unknown (accepted response, no user existence leak).
- `400 Bad Request`: invalid JSON or validation failure.
- `409 Conflict`: no devices currently registered for the user.
- `410 Gone`: all device tokens became unregistered.
- `429 Too Many Requests`: rate limit exceeded.
- `502 Bad Gateway`: APNs delivery failed for all devices.
