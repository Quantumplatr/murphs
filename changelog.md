# Changelog

<!-- mtoc-start -->

- [v0.0.2-alpha - 2025-02-21](#v002-alpha---2025-02-21)
  - [Features](#features)
  - [Changes](#changes)
  - [Fixes](#fixes)
- [v0.0.1-alpha - 2025-02-19](#v001-alpha---2025-02-19)
  - [Features](#features-1)
  - [Fixes](#fixes-1)

<!-- mtoc-end -->

## Unreleased

### Features

- Links in credits work
- L stat affects Murphsweeper
- L stat affects Calibration

## v0.2.0-alpha - 2025-02-22

### Features

- Calibration app and tasks added

## v0.1.3-alpha - 2025-02-22

### Changes

- Improved task lines and modal

## v0.1.2-alpha - 2025-02-22

### Features

- Inline task change indicators

### Fixes

- Fix failed app modal bug

## v0.1.1-alpha - 2025-02-22

### Features

- Task info modal

## v0.1.0-alpha - 2025-02-22

### Features

- Basic tasks implemented

## v0.0.6-alpha - 2025-02-22

### Features

- cat alias for read
- Click SFX
- Secret phrase in stats window
- Hidden final app placeholder
- Game over SFX loop
- Murphsweeper win screen

### Fixed

- Fixed read files bug
- Fixed some text file wrapping
- Fixed cursor not hidden on restart

## v0.0.5-alpha - 2025-02-22

### Features

- Spooky ambient noise as HSLA decreases
- Game over screen
- dev_lose hidden command

## v0.0.4-alpha - 2025-02-22

### Fixes

- Fix default settings values
- Removed unused audio files (decreased export size)

### Changes

- Decrease HSLA change

## v0.0.3-alpha - 2025-02-22

### Features

- Settings app functional
- Music and ambient audio
- Archive log files

## v0.0.2-alpha - 2025-02-21

### Features

- Don't start dHSLA until welcome modal closed
- Typing just a file name will use the read command on it
- Murphsweeper app mostly implemented
- Failed app modal implemented
- Stat bars animate changes

### Changes

- Improved H effect curve
- CRT effect changes now animate to value

### Fixes

- Fix restart command not resetting HSLA values
- Cursor is now re-affected by CRT shader. Last "fix" for this was wrong.

## v0.0.1-alpha - 2025-02-19

### Features

- Murphsweeper app framework
- `~/BASICS.txt` added
- `~/archive/data/art/*` and `~/archive/data/tfx/*` files
- `TaskData` class and random task generation
- `~/README.txt` improved
- All `~/archive/data/partitions` files changed to have \_ prefix
- Refiner app improved to react visually to cursor
- `dev_restart` command added

### Fixes

- Fixed cursor affected by CRT shader. This improves cursor accuracy.
