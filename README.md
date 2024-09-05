# Drawer

Drawer is a lightweight, customizable notification system for macOS. It displays elegant, non-intrusive notifications on your screen with various customization options.

## Features

- Displays notifications on top of all windows
- Customizable message, icon(SF Icon), and duration
- Configurable colors for icon, text, and background
- Automatically disappears after a customizable duration
- Supports command-line arguments for easy integration with scripts

## Screenshots


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

This will display a notification with the message "Hello, World!", a cyan snowflake icon, that lasts for 3 seconds, with a gold icon, white text, and a black background.
