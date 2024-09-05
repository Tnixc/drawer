# Drawer

Drawer is a lightweight, customizable notification system for macOS. It displays elegant, non-intrusive notifications on your screen with various customization options.

## Features

- Displays notifications on top of all windows
- Customizable message, icon(SF Icon), and duration
- Configurable colors for icon, text, and background
- Automatically disappears after a customizable duration
- Based on command-line arguments for easy integration with scripts

## Screenshots

<img width="400" alt="Screenshot 2024-09-04 at 22 04 44" src="https://github.com/user-attachments/assets/4ff3feaf-7f8e-458f-b300-8e313b2e2d80">
<img width="400" alt="Screenshot 2024-09-04 at 22 05 29" src="https://github.com/user-attachments/assets/876eaaf4-8334-4df6-a956-2bf659b42f6f">
<img width="411" alt="image" src="https://github.com/user-attachments/assets/191d7b8e-6697-436b-b0f6-df402f9bbe3c">

## Usage

To use Drawer, download the .app, and take out `drawer` from `drawer.app/Contents/MacOS/drawer`, and run the application from the command line with the following options:

```
drawer --message "Your message here" [options]
```

### Options

- `--message`: The message to display (default: "No message provided")
- `--icon`: The SF Symbol name for the icon (default: "slash.circle.fill")
- `--duration`: How long the notification should stay visible in seconds (default: 2.0)
- `--icon-color`: The color of the icon in hex format (default: "#5DA5FF")
- `--fg-color`: The color of the text in hex format (default: "#BCCAFD")
- `--bg-color`: The background color in hex format (default: "#24273C")

### Example

```
drawer --message "Hello, World\!" --icon "snowflake" --duration 3 --icon-color "#6188AC" --fg-color "#FFFFFF" --bg-color "#000000"`
```
<img width="426" alt="image" src="https://github.com/user-attachments/assets/0b1fb9bb-0c33-4baf-8687-bb4eef777499">

This will display a notification with the message "Hello, World!", a cyan snowflake icon, that lasts for 3 seconds, white text, and a black background.
