import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tastyhub/config/providers/theme/theme_provider.dart';

/// Modelo de datos para una categoría
class CategoryModel {
  final String id;
  final String name;
  final IconData icon;
  final Color? backgroundColor;
  final Color? textColor;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.icon,
    this.backgroundColor,
    this.textColor,
  });
}

/// Widget individual para cada categoría
class CategoryItem extends ConsumerStatefulWidget {
  final CategoryModel category;
  final VoidCallback? onTap;
  final double size;
  final double iconSize;
  final TextStyle? textStyle;

  const CategoryItem({
    super.key,
    required this.category,
    this.onTap,
    this.size = 40,
    this.iconSize = 14,
    this.textStyle,
  });

  @override
  ConsumerState<CategoryItem> createState() => _CategoryItemState();
}

class _CategoryItemState extends ConsumerState<CategoryItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _animationController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _animationController.reverse();
  }

  void _onTapCancel() {
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final themeState = ref.watch(themeProvider);
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTap: widget.onTap,
            onTapDown: _onTapDown,
            onTapUp: _onTapUp,
            onTapCancel: _onTapCancel,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Círculo con inner shadow
                Container(
                  width: widget.size,
                  height: widget.size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: themeState
                        .themeType
                        .accentColor, // Color marrón como en la imagen
                    boxShadow: [
                      // Sombra exterior
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      // Inner shadow effect usando gradient
                      gradient: RadialGradient(
                        colors: [
                          Colors.white.withOpacity(0.3),
                          Colors.transparent,
                          Colors.black.withOpacity(0.2),
                        ],
                        stops: const [0.0, 0.7, 1.0],
                        center: const Alignment(
                          -0.3,
                          -0.3,
                        ), // Posición de la luz
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        widget.category.icon,
                        size: widget.iconSize,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // Nombre de la categoría
                SizedBox(
                  width: widget.size + 16, // Un poco más ancho para el texto
                  child: Text(
                    widget.category.name,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style:
                        widget.textStyle ??
                        const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                          height: 1.2,
                        ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
