# Push Notifications

When notifications are enabled, Swiftcam devices automatically register with the push server at `https://push.swiftcam.app` and receive a static 256-bit `USER_ID` token.

Use that `USER_ID` to send notifications to: `https://push.swiftcam.app/api/push/notify`


## Device mapping

Each `USER_ID` maps to exactly one APNs device token.
If another device registers with the same `USER_ID`, the new token replaces the previous one.


## Send Notification from command line

A notification has two independent parts:

- `snapshot`: the image attached to the alert (`type`: `live`, `frigate_event`, `frigate_review`, or `url`).
- `open`: what Swiftcam shows when the notification is tapped (`type`: `live`, `frigate_event`, or `frigate_review`).

### Live snapshot
The following curl command attaches a live snapshot from the configured snapshot provider for the camera named "Garden". Tapping the notification opens the live stream for that camera.

```bash
curl -X POST "https://push.swiftcam.app/api/push/notify" \
  -H "Content-Type: application/json" \
  -d '{
    "user_id": "YOUR_USER_ID",
    "title": "Bird detected",
    "body": "Garden",
    "snapshot": { "type": "live" },
    "open": { "type": "live", "camera_name": "Garden" }
  }'
```

The live snapshot uses the camera referenced by `open` (`camera_name` or `camera_id`).

### Frigate NVR event snapshot
Attaches the Frigate event snapshot and opens the event details when tapped.

```bash
curl -X POST "https://push.swiftcam.app/api/push/notify" \
  -H "Content-Type: application/json" \
  -d '{
    "user_id": "YOUR_USER_ID",
    "title": "Person detected",
    "body": "Front Door",
    "snapshot": { "type": "frigate_event", "id": "1739987.123-abcdef" },
    "open": { "type": "frigate_event", "id": "1739987.123-abcdef" }
  }'
```

### Frigate NVR review snapshot
Loads the review record, attaches its Frigate thumbnail, and opens the Review tab when tapped.

```bash
curl -X POST "https://push.swiftcam.app/api/push/notify" \
  -H "Content-Type: application/json" \
  -d '{
    "user_id": "YOUR_USER_ID",
    "title": "Review item detected",
    "body": "Front Door",
    "notification_id": "review-123",
    "snapshot": { "type": "frigate_review", "id": "review-123" },
    "open": { "type": "frigate_review", "id": "review-123" }
  }'
```

## Send Notification from Home Assistant 

### Home Assistant `rest_command`
The following rest_command provides a shared command that can be used as action in Home Assistant. It forwards the nested `snapshot` and `open` objects as-is, so the same command works for live, event, and review notifications.

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
        "notification_id": "{{ notification_id | default('') }}",
        "snapshot": {{ snapshot | tojson }},
        "open": {{ open | tojson }}
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
          snapshot:
            type: live
          open:
            type: live
            camera_name: "Garden"
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
          snapshot:
            type: frigate_event
            id: "{{ event_id }}"
          open:
            type: frigate_event
            id: "{{ event_id }}"
```

### Home Assistant Frigate NVR Review Notification
Below is an example automation to send a notification for a Frigate NVR review item to Swiftcam.
The app loads the review record, attaches its Frigate thumbnail, and opens the Review tab when tapped.

```yaml
automation:
  - alias: "Swiftcam push from Frigate NVR MQTT reviews"
    mode: parallel
    trigger:
      - platform: mqtt
        topic: frigate/reviews
    condition:
      # Send only when a new review item is created.
      - condition: template
        value_template: "{{ trigger.payload_json.type == 'new' }}"
    action:
      - variables:
          review: "{{ trigger.payload_json.after }}"
          camera: "{{ review.camera }}"
          review_id: "{{ review.id }}"
      - service: rest_command.swiftcam_notify
        data:
          user_id: "YOUR_USER_ID"
          title: "Review item detected"
          body: "{{ camera }}"
          notification_id: "{{ review_id }}"
          snapshot:
            type: frigate_review
            id: "{{ review_id }}"
          open:
            type: frigate_review
            id: "{{ review_id }}"
```

## API: `/api/push/notify`

`POST https://push.swiftcam.app/api/push/notify`

### Request Body

```json
{
  "user_id": "64-char-hex-user-id",
  "title": "Review item detected",
  "body": "Front Door",
  "notification_id": "review-123",
  "snapshot": { "type": "frigate_review", "id": "review-123" },
  "open": { "type": "frigate_review", "id": "review-123" }
}
```

### Fields

- `user_id` (string, required): static 256-bit user token as 64 hex chars.
- `title` (string, required): push title.
- `body` (string, required): push body text.
- `notification_id` (string, optional): stable notification identifier. It is added to the iOS payload and used as the APNs collapse ID.
- `snapshot` (object, optional): the image attached to the alert.
  - `snapshot.type` (string): `live`, `frigate_event`, `frigate_review`, or `url`.
  - `snapshot.id` (string, required when `snapshot.type` is `frigate_event` or `frigate_review`): Frigate event/review identifier.
  - `snapshot.url` (string, required when `snapshot.type=url`): direct image URL.
  - For `snapshot.type=live`, the snapshot is fetched for the camera referenced by `open`.
- `open` (object, optional): the destination opened when the notification is tapped.
  - `open.type` (string): `live`, `frigate_event`, or `frigate_review`.
  - `open.camera_id` / `open.camera_name` (string, one required when `open.type=live`): camera to open live.
  - `open.id` (string, required when `open.type` is `frigate_event` or `frigate_review`): Frigate event/review identifier.

### Updating a notification

Send another request with the same `notification_id` and its new title/body. The gateway uses that ID as APNs' collapse ID, so APNs keeps only the latest pending notification and updates an already displayed one in place — silently, and without moving it to the top of Notification Center.
