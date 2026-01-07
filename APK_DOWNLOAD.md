# APK Download & Installation Guide

## 📱 Download Links

Your Skill Link app APK (v1.0.0) is ready for download!

### Direct Download Option
Since the APK file (55.7 MB) is too large for GitHub's release assets, here are your options:

#### Option 1: Clone & Build Locally (Recommended for testing)
```bash
git clone https://github.com/novvvv09/Skill-Link.git
cd Skill-Link
flutter build apk --release
```
The APK will be at: `build/app/outputs/flutter-apk/app-release.apk`

#### Option 2: Download from GitHub (via Web)
1. Go to: https://github.com/novvvv09/Skill-Link/releases/tag/v1.0.0
2. Look for the "Releases" section
3. Download the APK file

#### Option 3: Use File Sharing Service
Upload the APK (55.7 MB) to a cloud service:
- **Google Drive**: https://drive.google.com
- **Dropbox**: https://www.dropbox.com
- **WeTransfer**: https://wetransfer.com
- **Firebase Hosting**: For auto-updates

## 🚀 Installation Instructions

### Method 1: USB Cable (Easiest)
1. Connect Android phone to PC with USB cable
2. Enable "USB Debugging" on phone:
   - Settings → Developer Options → USB Debugging
3. Run in terminal:
   ```bash
   adb install -r build/app/outputs/flutter-apk/app-release.apk
   ```

### Method 2: Direct APK File Transfer
1. Copy `app-release.apk` to your phone via:
   - USB file transfer
   - Email
   - Cloud storage (Google Drive, Dropbox, etc.)
2. On your phone, open the Files app
3. Navigate to the APK file location
4. Tap the file to install
5. Grant permissions when prompted
6. Tap "Install"

### Method 3: QR Code Link
Share this QR code or link with your phone to download:
```
Repository: https://github.com/novvvv09/Skill-Link
Release Tag: v1.0.0
```

## ⚙️ Prerequisites for Installation

- **Android Version**: 5.0 (API 21) or higher
- **Storage Space**: At least 100 MB free space
- **Internet Connection**: Required for Firebase features
- **Google Account**: Optional (for enhanced features)

## 📋 Device Setup

Before installing, ensure your Android device allows unknown sources:

1. Go to **Settings**
2. Search for "Unknown sources" or "Install unknown apps"
3. Enable the option for your file manager/browser app
4. (This setting varies by Android version and manufacturer)

## ✅ Verification

After installation, verify the app works:

1. **Launch the app**: Find "skill_link" on your home screen
2. **Check Firebase connection**: App should load data from Firestore
3. **Test login**: Use your test credentials
4. **Verify features**:
   - ✓ Authentication (sign up/login)
   - ✓ View events/projects
   - ✓ Create new content
   - ✓ Notifications

## 🔧 Troubleshooting

### Issue: "App not installed"
**Solution**:
- Uninstall any previous versions first: `adb uninstall com.nuebe.skilllink`
- Check device has at least 100 MB free space
- Try again with: `adb install -r app-release.apk`

### Issue: "Installation blocked"
**Solution**:
- Enable "Unknown sources" in Settings
- Disable any antivirus scanning temporarily
- Try installing via different method

### Issue: "Cannot connect to Firebase"
**Solution**:
- Check internet connection (WiFi or mobile data)
- Verify Firebase project is active
- Check app has internet permission

### Issue: "Wrong package name error"
**Solution**:
- Ensure you're installing the correct APK
- Package name should be: `com.nuebe.skilllink`

## 📊 App Information

| Property | Value |
|----------|-------|
| **Package Name** | com.nuebe.skilllink |
| **Version** | 1.0.0 |
| **Build Number** | 1 |
| **APK Size** | 55.7 MB |
| **Minimum SDK** | 21 (Android 5.0) |
| **Target SDK** | 34 (Android 14) |
| **Architecture** | ARM64-v8a, armeabi-v7a, x86, x86_64 |

## 🔐 Security Notes

- The APK is signed with a development keystore
- For production/Play Store release, a proper release key is recommended
- Keep your login credentials secure
- Never share Firebase credentials or keys
- Report security issues privately

## 📞 Support

For installation issues:
1. Check the [DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md)
2. Visit Flutter documentation: https://flutter.dev/docs/deployment/android
3. Check Firebase setup: https://firebase.google.com/docs
4. Create an issue on GitHub: https://github.com/novvvv09/Skill-Link/issues

## 🎯 Next Steps

1. **Download** the APK
2. **Install** using your preferred method
3. **Test** the app thoroughly
4. **Report** any bugs or issues
5. **Share** feedback

---

**Version**: 1.0.0  
**Release Date**: January 8, 2026  
**Status**: Production Ready ✅
