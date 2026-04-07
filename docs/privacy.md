# Privacy Policy

## Swiftcam App

The Swiftcam app itself does not collect any user data besides what is automatically sent to Apple by the operating system and Apple platform services.

## Push Notifications

The Swiftcam Push Gateway server stores only the following information:

- Device-specific APNS token
- Timestamps (`created_at` and `updated_at`, `last_used_at`) for the `user_id` to APNS token association 

User IDs that are not used might be deleted after 60 days. 

The push notification API is designed so that no identifiable data is transferred besides the notification title, notification body, and camera name (unless camera UUID is used).

Notification attachments are requested by the device itself after a notification is received and are not transferred through the Swiftcam Push Gateway Server. 
