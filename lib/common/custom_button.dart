import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomButton extends ConsumerWidget {
  const CustomButton({
    super.key,
    required this.buttonType,
    required this.buttonSize,
    required this.child,
    required this.onPressed,
    this.icon,
    this.foregroundColor,
    this.backgroundColor,
    this.disabledForegroundColor,
    this.disabledBackgroundColor,
    this.shadowColor,
    this.surfaceTintColor,
    this.elevation,
    this.textStyle,
    this.padding,
    this.minimumSize,
    this.maximumSize,
    this.side,
    this.shape,
    this.enabledMouseCursor,
    this.disabledMouseCursor,
    this.visualDensity,
    this.tapTargetSize,
    this.animationDuration,
    this.enableFeedback,
    this.alignment,
    this.splashFactory,
    this.primary,
    this.onPrimary,
    this.onSurface,
    this.borderColor,
  });

  final ButtonType buttonType;
  final void Function()? onPressed;
  final Widget child;
  final ButtonSize buttonSize;
  final Widget? icon;
  final Color? foregroundColor;
  final Color? backgroundColor;
  final Color? disabledForegroundColor;
  final Color? disabledBackgroundColor;
  final Color? shadowColor;
  final Color? surfaceTintColor;
  final double? elevation;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry? padding;
  final Size? minimumSize;
  final Size? maximumSize;
  final BorderSide? side;
  final OutlinedBorder? shape;
  final MouseCursor? enabledMouseCursor;
  final MouseCursor? disabledMouseCursor;
  final VisualDensity? visualDensity;
  final MaterialTapTargetSize? tapTargetSize;
  final Duration? animationDuration;
  final bool? enableFeedback;
  final AlignmentGeometry? alignment;
  final InteractiveInkFeatureFactory? splashFactory;
  final Color? primary;
  final Color? onPrimary;
  final Color? onSurface;
  final Color? borderColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (buttonType == ButtonType.elevated) {
      return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          fixedSize: Size(double.infinity, buttonSize.getButtonSizeFrom()),
          alignment: alignment,
          animationDuration: animationDuration,
          backgroundColor: backgroundColor,
          disabledBackgroundColor: disabledBackgroundColor,
          disabledForegroundColor: disabledForegroundColor,
          disabledMouseCursor: disabledMouseCursor,
          elevation: elevation,
          enableFeedback: enableFeedback,
          enabledMouseCursor: enabledMouseCursor,
          foregroundColor: foregroundColor,
          maximumSize: maximumSize,
          minimumSize: minimumSize,
          padding: padding,
          shadowColor: shadowColor,
          side: side,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          splashFactory: splashFactory,
          surfaceTintColor: surfaceTintColor,
          textStyle: textStyle,
          tapTargetSize: tapTargetSize,
          visualDensity: visualDensity,
        ),
        child: child,
      );
    } else if (buttonType == ButtonType.filled) {
      return FilledButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          fixedSize: Size(double.infinity, buttonSize.getButtonSizeFrom()),
          alignment: alignment,
          animationDuration: animationDuration,
          backgroundColor: backgroundColor,
          disabledBackgroundColor: disabledBackgroundColor,
          disabledForegroundColor: disabledForegroundColor,
          disabledMouseCursor: disabledMouseCursor,
          elevation: elevation,
          enableFeedback: enableFeedback,
          enabledMouseCursor: enabledMouseCursor,
          foregroundColor: foregroundColor,
          maximumSize: maximumSize,
          minimumSize: minimumSize,
          padding: padding,
          shadowColor: shadowColor,
          side: side,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          splashFactory: splashFactory,
          surfaceTintColor: surfaceTintColor,
          textStyle: textStyle,
          tapTargetSize: tapTargetSize,
          visualDensity: visualDensity,
        ),
        child: child,
      );
    } else if (buttonType == ButtonType.filledIcon) {
      return FilledButton.icon(
        onPressed: onPressed,
        label: child,
        icon: icon!,
        style: ElevatedButton.styleFrom(
          fixedSize: Size(double.infinity, buttonSize.getButtonSizeFrom()),
          alignment: alignment,
          animationDuration: animationDuration,
          backgroundColor: backgroundColor,
          disabledBackgroundColor: disabledBackgroundColor,
          disabledForegroundColor: disabledForegroundColor,
          disabledMouseCursor: disabledMouseCursor,
          elevation: elevation,
          enableFeedback: enableFeedback,
          enabledMouseCursor: enabledMouseCursor,
          foregroundColor: foregroundColor,
          maximumSize: maximumSize,
          minimumSize: minimumSize,
          padding: padding,
          shadowColor: shadowColor,
          side: side,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          splashFactory: splashFactory,
          surfaceTintColor: surfaceTintColor,
          textStyle: textStyle,
          tapTargetSize: tapTargetSize,
          visualDensity: visualDensity,
        ),
      );
    } else if (buttonType == ButtonType.elevatedIcon) {
      return ElevatedButton.icon(
        onPressed: onPressed,
        label: child,
        icon: icon!,
        style: ElevatedButton.styleFrom(
          fixedSize: Size(double.infinity, buttonSize.getButtonSizeFrom()),
          alignment: alignment,
          animationDuration: animationDuration,
          backgroundColor: backgroundColor,
          disabledBackgroundColor: disabledBackgroundColor,
          disabledForegroundColor: disabledForegroundColor,
          disabledMouseCursor: disabledMouseCursor,
          elevation: elevation,
          enableFeedback: enableFeedback,
          enabledMouseCursor: enabledMouseCursor,
          foregroundColor: foregroundColor,
          maximumSize: maximumSize,
          minimumSize: minimumSize,
          padding: padding,
          shadowColor: shadowColor,
          side: side,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          splashFactory: splashFactory,
          surfaceTintColor: surfaceTintColor,
          textStyle: textStyle,
          tapTargetSize: tapTargetSize,
          visualDensity: visualDensity,
        ),
      );
    } else if (buttonType == ButtonType.outlined) {
      return OutlinedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          fixedSize: Size(double.infinity, buttonSize.getButtonSizeFrom()),
          alignment: alignment,
          animationDuration: animationDuration,
          backgroundColor: backgroundColor,
          disabledBackgroundColor: disabledBackgroundColor,
          disabledForegroundColor: disabledForegroundColor,
          disabledMouseCursor: disabledMouseCursor,
          elevation: elevation,
          enableFeedback: enableFeedback,
          enabledMouseCursor: enabledMouseCursor,
          foregroundColor: foregroundColor,
          maximumSize: maximumSize,
          minimumSize: minimumSize,
          padding: padding,
          shadowColor: shadowColor,
          side: side,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          splashFactory: splashFactory,
          surfaceTintColor: surfaceTintColor,
          textStyle: textStyle,
          tapTargetSize: tapTargetSize,
          visualDensity: visualDensity,
        ),
        child: child,
      );
    } else if (buttonType == ButtonType.outlinedIcon) {
      return OutlinedButton.icon(
        onPressed: onPressed,
        label: child,
        icon: icon!,
        style: ElevatedButton.styleFrom(
          fixedSize: Size(double.infinity, buttonSize.getButtonSizeFrom()),
          alignment: alignment,
          animationDuration: animationDuration,
          backgroundColor: backgroundColor,
          disabledBackgroundColor: disabledBackgroundColor,
          disabledForegroundColor: disabledForegroundColor,
          disabledMouseCursor: disabledMouseCursor,
          elevation: elevation,
          enableFeedback: enableFeedback,
          enabledMouseCursor: enabledMouseCursor,
          foregroundColor: foregroundColor,
          maximumSize: maximumSize,
          minimumSize: minimumSize,
          padding: padding,
          shadowColor: shadowColor,
          side: side,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          splashFactory: splashFactory,
          surfaceTintColor: surfaceTintColor,
          textStyle: textStyle,
          tapTargetSize: tapTargetSize,
          visualDensity: visualDensity,
        ),
      );
    }
    return const SizedBox.shrink();
  }
}

enum ButtonType {
  filled,
  elevated,
  elevatedIcon,
  filledIcon,
  outlined,
  outlinedIcon
}

enum ButtonSize {
  small,
  medium,
  large,
}

extension on ButtonSize {
  double getButtonSizeFrom() {
    if (this == ButtonSize.large) {
      return 58;
    } else if (this == ButtonSize.medium) {
      return 50;
    } else if (this == ButtonSize.small) {
      return 46;
    }
    return 46;
  }
}
