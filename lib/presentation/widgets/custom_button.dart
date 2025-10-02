import 'package:flutter/material.dart';

/// Enumeración para definir los tamaños del botón
enum ButtonSize { small, medium, large }

/// Clase que contiene las propiedades de cada tamaño
class ButtonSizeProperties {
  final EdgeInsetsGeometry padding;
  final double fontSize;
  final double iconSize;
  final double borderRadius;

  const ButtonSizeProperties({
    required this.padding,
    required this.fontSize,
    required this.iconSize,
    required this.borderRadius,
  });
}

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData? rightIcon;
  final ButtonSize size;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? iconColor;
  final bool enabled;
  final double? width;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.rightIcon,
    this.size = ButtonSize.large, // Tamaño por defecto es grande (actual)
    this.backgroundColor,
    this.textColor,
    this.iconColor,
    this.enabled = true,
    this.width,
  });

  /// Mapa que define las propiedades para cada tamaño
  static const Map<ButtonSize, ButtonSizeProperties> _sizeProperties = {
    ButtonSize.small: ButtonSizeProperties(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 28),
      fontSize: 14,
      iconSize: 16,
      borderRadius: 100,
    ),
    ButtonSize.medium: ButtonSizeProperties(
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 22),
      fontSize: 16,
      iconSize: 18,
      borderRadius: 100,
    ),
    ButtonSize.large: ButtonSizeProperties(
      padding: EdgeInsets.symmetric(vertical: 18, horizontal: 26),
      fontSize: 18,
      iconSize: 20,
      borderRadius: 100,
    ),
  };

  /// Obtiene las propiedades del tamaño seleccionado
  ButtonSizeProperties get _currentSizeProperties => _sizeProperties[size]!;

  /// Colores por defecto
  Color get _defaultBackgroundColor => const Color.fromRGBO(69, 38, 30, 1);
  Color get _defaultTextColor => Colors.white;
  Color get _defaultIconColor => Colors.white;

  /// Colores cuando está deshabilitado
  Color get _disabledBackgroundColor =>
      _defaultBackgroundColor.withOpacity(0.5);
  Color get _disabledTextColor => _defaultTextColor.withOpacity(0.7);
  Color get _disabledIconColor => _defaultIconColor.withOpacity(0.7);

  @override
  Widget build(BuildContext context) {
    final sizeProps = _currentSizeProperties;

    return GestureDetector(
      onTap: enabled ? onPressed : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: width,
        padding: sizeProps.padding,
        decoration: BoxDecoration(
          color: enabled
              ? (backgroundColor ?? _defaultBackgroundColor)
              : _disabledBackgroundColor,
          borderRadius: BorderRadius.circular(sizeProps.borderRadius),
        ),
        child: Row(
          mainAxisSize: width != null ? MainAxisSize.max : MainAxisSize.min,
          mainAxisAlignment: width != null
              ? MainAxisAlignment.center
              : MainAxisAlignment.start,
          children: [
            Flexible(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: sizeProps.fontSize,
                  color: enabled
                      ? (textColor ?? _defaultTextColor)
                      : _disabledTextColor,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            if (rightIcon != null) ...[
              const Spacer(),
              Icon(
                rightIcon,
                color: enabled
                    ? (iconColor ?? _defaultIconColor)
                    : _disabledIconColor,
                size: sizeProps.iconSize,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
