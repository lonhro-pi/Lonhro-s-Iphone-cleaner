# iPhone Duplicate Cleaner for Linux

A simple bash script to remove duplicate photos, videos, and files from your iPhone using Linux.

## Features

- 🧹 Automatically removes duplicate photos and videos
- 📱 Works with any iPhone model
- 🐧 Linux-only solution (Debian/Ubuntu-based distros)
- 🔒 Safe: keeps one copy of each duplicate
- ⚡ Fast and lightweight

## Why Use This?

If you've forgotten your iPhone passcode and need to recover your device, Apple's official recovery process requires erasing your iPhone. Before doing that, you should:

1. **Check if your photos are backed up** to iCloud or Google Photos
2. If they are, proceed with Apple's recovery process
3. After recovery, your photos will sync back automatically
4. Use this tool to clean up any duplicates

## Prerequisites

- Linux (Debian/Ubuntu-based: Ubuntu, Debian, Parrot OS, Kali, etc.)
- iPhone connected via USB cable
- USB cable to connect your iPhone

## Installation

1. Clone this repository:
```bash
git clone https://github.com/lonhro-pi/iphone-cleaner.git
cd iphone-cleaner
```

2. Make the script executable:
```bash
chmod +x clean-iphone.sh
```

## Usage

1. **Connect your iPhone** to your computer via USB cable

2. **Unlock your iPhone** and tap **"Trust This Computer"** when prompted

3. **Run the script**:
```bash
./clean-iphone.sh
```

The script will:
- Automatically install required tools if missing
- Detect your iPhone
- Mount the iPhone filesystem
- Scan for duplicate files
- Remove duplicates (keeping one copy of each)
- Safely unmount your iPhone

## What Gets Cleaned?

The script scans and removes duplicates from:
- **DCIM folder**: Photos and videos taken with your camera
- **Downloads folder**: Files downloaded on your iPhone

## How It Works

The script uses these tools:
- **libimobiledevice**: Communicates with iOS devices
- **ifuse**: Mounts iPhone filesystem via USB
- **fdupes**: Finds and removes duplicate files

### Technical Details

1. Detects iPhone using `idevice_id`
2. Mounts iPhone at `~/iphone_mount` using `ifuse`
3. Scans for duplicates using `fdupes` (compares file contents, not just names)
4. Removes duplicates automatically (keeps the first occurrence)
5. Safely unmounts the device

## Safety

- ✅ The script only removes **exact duplicates** (identical file content)
- ✅ Always keeps **one copy** of each file
- ✅ Does not modify original files
- ✅ Safely unmounts iPhone before exit

**Recommendation**: Before running, back up your iPhone to iCloud or make a local backup just to be safe.

## Troubleshooting

### iPhone not detected
- Make sure your iPhone is unlocked
- Ensure you tapped "Trust This Computer"
- Try unplugging and reconnecting the USB cable
- Check if `idevice_id -l` shows your device

### Permission denied
- Don't run the script with `sudo`
- The script will ask for sudo password only when installing packages

### Mount fails
- Unplug and reconnect your iPhone
- Restart the `usbmuxd` service: `sudo systemctl restart usbmuxd`
- Reboot your computer if issues persist

## Alternative: Built-in iOS Feature

If you prefer not to use command-line tools, iOS has a built-in duplicate detector:

1. Open **Photos** app on iPhone
2. Go to **Albums** tab
3. Scroll down to **Utilities** section
4. Tap **Duplicates**
5. Review and tap **Merge** for each duplicate

## Supported Distributions

Tested on:
- Ubuntu 20.04+
- Debian 11+
- Parrot Security OS
- Kali Linux
- Linux Mint
- Pop!_OS

Should work on any Debian/Ubuntu-based distribution.

## License

MIT License - feel free to use and modify.

## Contributing

Pull requests welcome! Feel free to:
- Add support for other Linux distributions
- Improve error handling
- Add more cleaning options

  
## A Debt of Gratitude 

- A huge thank you goes out to my brother Dallas without him I wouldn't had this chance to do this and never turning his back when the chips are down love you brother !

## Disclaimer

This tool modifies files on your iPhone. While it's designed to be safe, **always backup your data before use**. The authors are not responsible for any data loss.

## Resources

- [Apple Support - Forgot iPhone passcode](https://support.apple.com/en-us/HT204306)
- [libimobiledevice documentation](https://libimobiledevice.org/)
- [Check iCloud backups](https://www.icloud.com/)
