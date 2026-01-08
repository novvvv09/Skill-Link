import 'package:flutter/material.dart';

/// Responsive design utilities for multi-screen support
class ResponsiveUtil {
  /// Get responsive width based on screen width
  static double getResponsiveWidth(BuildContext context, double width) {
    double screenWidth = MediaQuery.of(context).size.width;

    // Phone: < 600dp
    // Tablet: 600-1024dp
    // Desktop: > 1024dp

    if (screenWidth < 600) {
      return width * 0.9; // 90% for phones
    } else if (screenWidth < 1024) {
      return width * 0.8; // 80% for tablets
    } else {
      return width * 0.7; // 70% for desktop
    }
  }

  /// Get responsive font size
  static double getResponsiveFontSize(BuildContext context, double baseSize) {
    double screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth < 600) {
      return baseSize; // Phone size
    } else if (screenWidth < 1024) {
      return baseSize * 1.2; // Tablet
    } else {
      return baseSize * 1.5; // Desktop
    }
  }

  /// Get responsive padding
  static EdgeInsets getResponsivePadding(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth < 600) {
      return const EdgeInsets.all(8);
    } else if (screenWidth < 1024) {
      return const EdgeInsets.all(16);
    } else {
      return const EdgeInsets.all(24);
    }
  }

  /// Check if device is in portrait mode
  static bool isPortrait(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait;
  }

  /// Check if screen is small (phone)
  static bool isSmallScreen(BuildContext context) {
    return MediaQuery.of(context).size.width < 600;
  }

  /// Check if screen is medium (tablet)
  static bool isMediumScreen(BuildContext context) {
    return MediaQuery.of(context).size.width >= 600 &&
        MediaQuery.of(context).size.width < 1024;
  }

  /// Check if screen is large (desktop)
  static bool isLargeScreen(BuildContext context) {
    return MediaQuery.of(context).size.width >= 1024;
  }

  /// Get grid column count based on screen size
  static int getGridColumns(BuildContext context) {
    if (isSmallScreen(context)) {
      return 1;
    } else if (isMediumScreen(context)) {
      return 2;
    } else {
      return 3;
    }
  }
}
