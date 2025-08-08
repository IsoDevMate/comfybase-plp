import 'package:flutter/material.dart';

/// A utility class for handling responsive layouts
class Responsive {
  /// Breakpoints for different screen sizes
  static const double mobileMaxWidth = 600;
  static const double tabletMaxWidth = 1200;
  static const double desktopMaxWidth = 1920;

  /// Screen size getters
  static bool isMobile(BuildContext context) => 
      MediaQuery.of(context).size.width < mobileMaxWidth;

  static bool isTablet(BuildContext context) => 
      MediaQuery.of(context).size.width >= mobileMaxWidth && 
      MediaQuery.of(context).size.width < tabletMaxWidth;

  static bool isDesktop(BuildContext context) => 
      MediaQuery.of(context).size.width >= tabletMaxWidth;

  /// Returns a value based on screen size
  static T responsiveValue<T>({
    required BuildContext context,
    required T mobile,
    T? tablet,
    T? desktop,
    T? largeDesktop,
  }) {
    final width = MediaQuery.of(context).size.width;
    
    if (width >= (largeDesktop != null ? desktopMaxWidth : tabletMaxWidth)) {
      return largeDesktop ?? desktop ?? tablet ?? mobile;
    } else if (width >= mobileMaxWidth) {
      return tablet ?? mobile;
    } else {
      return mobile;
    }
  }

  /// Returns a widget based on screen size
  static Widget responsiveWidget({
    required BuildContext context,
    required Widget mobile,
    Widget? tablet,
    Widget? desktop,
    Widget? largeDesktop,
  }) {
    return responsiveValue<Widget>(
      context: context,
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
      largeDesktop: largeDesktop,
    );
  }

  /// Returns a double value scaled based on screen size
  static double responsiveDouble({
    required BuildContext context,
    required double mobile,
    double? tablet,
    double? desktop,
    double? largeDesktop,
  }) {
    return responsiveValue<double>(
      context: context,
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
      largeDesktop: largeDesktop,
    );
  }

  /// Returns an integer value based on screen size
  static int responsiveInt({
    required BuildContext context,
    required int mobile,
    int? tablet,
    int? desktop,
    int? largeDesktop,
  }) {
    return responsiveValue<int>(
      context: context,
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
      largeDesktop: largeDesktop,
    );
  }

  /// Returns an edge insets based on screen size
  static EdgeInsets responsivePadding({
    required BuildContext context,
    required EdgeInsets mobile,
    EdgeInsets? tablet,
    EdgeInsets? desktop,
    EdgeInsets? largeDesktop,
  }) {
    return responsiveValue<EdgeInsets>(
      context: context,
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
      largeDesktop: largeDesktop,
    );
  }

  /// Returns a border radius based on screen size
  static BorderRadius responsiveBorderRadius({
    required BuildContext context,
    required BorderRadius mobile,
    BorderRadius? tablet,
    BorderRadius? desktop,
    BorderRadius? largeDesktop,
  }) {
    return responsiveValue<BorderRadius>(
      context: context,
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
      largeDesktop: largeDesktop,
    );
  }

  /// Returns a text style with font size scaled based on screen size
  static TextStyle responsiveTextStyle({
    required BuildContext context,
    required TextStyle baseStyle,
    double? mobileScale,
    double? tabletScale,
    double? desktopScale,
    double? largeDesktopScale,
  }) {
    final width = MediaQuery.of(context).size.width;
    double scale = 1.0;

    if (width >= (largeDesktopScale != null ? desktopMaxWidth : tabletMaxWidth)) {
      scale = largeDesktopScale ?? desktopScale ?? tabletScale ?? 1.0;
    } else if (width >= mobileMaxWidth) {
      scale = tabletScale ?? 1.0;
    } else {
      scale = mobileScale ?? 1.0;
    }

    return baseStyle.copyWith(
      fontSize: baseStyle.fontSize != null ? baseStyle.fontSize! * scale : null,
    );
  }

  /// Wraps a widget with a maximum width constraint for better readability on large screens
  static Widget maxWidthContainer({
    required BuildContext context,
    required Widget child,
    double? maxWidth,
    EdgeInsets? padding,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final containerMaxWidth = maxWidth ?? tabletMaxWidth;
    
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: containerMaxWidth),
        child: Padding(
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 16.0),
          child: child,
        ),
      ),
    );
  }

  /// Returns the number of columns for a grid based on screen size
  static int gridCrossAxisCount(BuildContext context) {
    return responsiveValue<int>(
      context: context,
      mobile: 1,
      tablet: 2,
      desktop: 3,
      largeDesktop: 4,
    );
  }

  /// Returns the aspect ratio for grid items based on screen size
  static double gridAspectRatio(BuildContext context) {
    return responsiveValue<double>(
      context: context,
      mobile: 3 / 4,
      tablet: 4 / 5,
      desktop: 1,
      largeDesktop: 4 / 3,
    );
  }
}
