import 'package:flutter/material.dart';

class AppDimensions {
  // Spacing
  static const double spacingXxs = 2.0;
  static const double spacingXs = 4.0;
  static const double spacingSm = 8.0;
  static const double spacingMd = 16.0;
  static const double spacingLg = 24.0;
  static const double spacingXl = 32.0;
  static const double spacingXxl = 40.0;
  static const double spacingXxxl = 48.0;

  // Padding
  static const double paddingXxs = 2.0;
  static const double paddingXs = 4.0;
  static const double paddingSm = 8.0;
  static const double paddingMd = 16.0;
  static const double paddingLg = 24.0;
  static const double paddingXl = 32.0;
  static const double paddingXxl = 40.0;

  // Margin
  static const double marginXxs = 2.0;
  static const double marginXs = 4.0;
  static const double marginSm = 8.0;
  static const double marginMd = 16.0;
  static const double marginLg = 24.0;
  static const double marginXl = 32.0;
  static const double marginXxl = 40.0;

  // Radius
  static const double radiusXxs = 2.0;
  static const double radiusXs = 4.0;
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 20.0;
  static const double radiusXxl = 24.0;
  static const double radiusCircular = 100.0;
  static const double radiusRound = 100.0;

  // Icons
  static const double iconXxs = 12.0;
  static const double iconXs = 16.0;
  static const double iconSm = 20.0;
  static const double iconMd = 24.0;
  static const double iconLg = 32.0;
  static const double iconXl = 40.0;
  static const double iconXxl = 48.0;
  static const double iconXxxl = 56.0;

  // App Bar
  static const double appBarHeight = 56.0;
  static const double appBarElevation = 0.0;
  static const double appBarTitleSpacing = 16.0;

  // Buttons
  static const double buttonPaddingHorizontal = 24.0;
  static const double buttonPaddingVertical = 12.0;
  static const double buttonHeight = 48.0;
  static const double buttonHeightSm = 40.0;
  static const double buttonHeightMd = 48.0;
  static const double buttonHeightLg = 56.0;
  static const double buttonBorderRadius = 8.0;
  static const double buttonElevation = 2.0;
  static const double buttonIconSize = 24.0;
  static const double buttonIconSpacing = 8.0;

  // Input Fields
  static const double inputFieldHeight = 56.0;
  static const double inputFieldBorderRadius = 8.0;
  static const double inputFieldBorderWidth = 1.0;
  static const double inputFieldPadding = 16.0;
  static const double inputFieldIconSize = 24.0;
  static const double inputFieldIconPadding = 12.0;
  static const double inputFieldLabelSpacing = 8.0;
  static const double inputFieldErrorSpacing = 4.0;

  // Cards
  static const double cardElevation = 2.0;
  static const double cardBorderRadius = 12.0;
  static const double cardPadding = 16.0;
  static const double cardSpacing = 16.0;
  static const double cardImageHeight = 120.0;

  // Dialogs
  static const double dialogBorderRadius = 16.0;
  static const double dialogElevation = 24.0;
  static const double dialogPadding = 24.0;
  static const double dialogContentPadding = 16.0;
  static const double dialogActionsSpacing = 8.0;
  static const double dialogIconSize = 48.0;

  // Dividers
  static const double dividerThickness = 1.0;
  static const double dividerIndent = 16.0;
  static const double dividerEndIndent = 16.0;
  static const double dividerSpacing = 16.0;

  // Grid
  static const double gridSpacing = 16.0;
  static const double gridSpacingSmall = 8.0;
  static const double gridSpacingLarge = 24.0;
  static const double gridItemSpacing = 16.0;
  static const double gridItemAspectRatio = 1.0;

  // Animation
  static const Duration animationDurationFast = Duration(milliseconds: 200);
  static const Duration animationDurationMedium = Duration(milliseconds: 350);
  static const Duration animationDurationSlow = Duration(milliseconds: 500);
  static const Curve animationCurve = Curves.easeInOut;

  // Layout
  static const double maxContentWidth = 1200.0;
  static const double sideMenuWidth = 280.0;
  static const double bottomNavBarHeight = 64.0;
  static const double fabSize = 56.0;
  static const double fabMargin = 16.0;
  static const double toolbarHeight = 64.0;
  static const double tabBarHeight = 48.0;
  static const double tabBarIndicatorSize = 2.0;
  static const double bottomSheetBorderRadius = 16.0;
  static const double bottomSheetElevation = 8.0;
  static const double snackBarElevation = 6.0;
  static const double snackBarContentPadding = 16.0;
  static const double tooltipRadius = 4.0;
  static const double tooltipVerticalOffset = 8.0;
  static const double tooltipOpacity = 0.9;
  static const double tooltipWaitDuration = 500; // milliseconds
  static const double tooltipShowDuration = 1500; // milliseconds
  static const double tooltipMargin = 5.0;
  static const double tooltipHeight = 32.0;
  static const double tooltipWidth = 200.0;
  static const double tooltipBlurRadius = 3.0;
  static const double tooltipSpreadRadius = 1.0;
  static const double tooltipTextScaleFactor = 1.0;
  static const double tooltipFontSize = 14.0;
  static const double tooltipLetterSpacing = 0.1;
  static const double tooltipWordSpacing = 0.0;
  static const FontWeight tooltipFontWeight = FontWeight.normal;
  static const FontStyle tooltipFontStyle = FontStyle.normal;
  static const TextDecoration tooltipTextDecoration = TextDecoration.none;
  static const TextOverflow tooltipTextOverflow = TextOverflow.ellipsis;
  static const int tooltipMaxLines = 1;
  static const TextAlign tooltipTextAlign = TextAlign.center;
  static const TextDirection tooltipTextDirection = TextDirection.ltr;
  static const bool tooltipSoftWrap = true;
  static const double tooltipTextScaleFactorHeight = 1.0;
  static const double tooltipTextScaleFactorWidth = 1.0;
  static const double tooltipTextScaleFactorBaseline = 1.0;
  static const TextHeightBehavior? tooltipTextHeightBehavior = null;
  static const Locale? tooltipLocale = null;
  static const StrutStyle? tooltipStrutStyle = null;
  static const TextWidthBasis tooltipTextWidthBasis = TextWidthBasis.parent;
  static const TextLeadingDistribution tooltipTextLeadingDistribution = 
      TextLeadingDistribution.even;
}
