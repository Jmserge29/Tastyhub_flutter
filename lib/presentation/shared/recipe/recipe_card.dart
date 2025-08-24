import 'package:flutter/material.dart';

/// Modelo de datos para una receta
class Recipe {
  final String id;
  final String name;
  final String author;
  final String imageUrl;
  final bool isFavorite;
  final double? rating;
  final int? cookingTime; // en minutos
  final String? difficulty;

  const Recipe({
    required this.id,
    required this.name,
    required this.author,
    required this.imageUrl,
    this.isFavorite = false,
    this.rating,
    this.cookingTime,
    this.difficulty,
  });

  Recipe copyWith({
    String? id,
    String? name,
    String? author,
    String? imageUrl,
    bool? isFavorite,
    double? rating,
    int? cookingTime,
    String? difficulty,
  }) {
    return Recipe(
      id: id ?? this.id,
      name: name ?? this.name,
      author: author ?? this.author,
      imageUrl: imageUrl ?? this.imageUrl,
      isFavorite: isFavorite ?? this.isFavorite,
      rating: rating ?? this.rating,
      cookingTime: cookingTime ?? this.cookingTime,
      difficulty: difficulty ?? this.difficulty,
    );
  }
}

/// Widget personalizado para cada tarjeta de receta
class RecipeCard extends StatefulWidget {
  final Recipe recipe;
  final VoidCallback? onTap;
  final ValueChanged<bool>? onFavoriteToggle;
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const RecipeCard({
    super.key,
    required this.recipe,
    this.onTap,
    this.onFavoriteToggle,
    this.width = 200,
    this.height = 280,
    this.borderRadius,
  });

  @override
  State<RecipeCard> createState() => _RecipeCardState();
}

class _RecipeCardState extends State<RecipeCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.recipe.isFavorite;
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

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });
    widget.onFavoriteToggle?.call(_isFavorite);
  }

  @override
  Widget build(BuildContext context) {
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
            child: SizedBox(
              width: widget.width,
              height: widget.height,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius:
                      widget.borderRadius ?? BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius:
                      widget.borderRadius ?? BorderRadius.circular(16),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Imagen de fondo
                      _buildBackgroundImage(),

                      // Overlay gradient
                      _buildGradientOverlay(),

                      // Botón de favorito
                      _buildFavoriteButton(),

                      // Información de la receta
                      _buildRecipeInfo(),

                      // Rating badge (si existe)
                      if (widget.recipe.rating != null) _buildRatingBadge(),

                      // Cooking time badge (si existe)
                      if (widget.recipe.cookingTime != null)
                        _buildCookingTimeBadge(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBackgroundImage() {
    return widget.recipe.imageUrl.startsWith('http')
        ? Image.network(
            widget.recipe.imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                _buildPlaceholderImage(),
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return _buildPlaceholderImage();
            },
          )
        : Image.asset(
            widget.recipe.imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                _buildPlaceholderImage(),
          );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      color: Colors.grey[300],
      child: const Center(
        child: Icon(Icons.restaurant, size: 50, color: Colors.grey),
      ),
    );
  }

  Widget _buildGradientOverlay() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.transparent,
            Colors.black.withOpacity(0.3),
            Colors.black.withOpacity(0.8),
          ],
          stops: const [0.0, 0.4, 0.7, 1.0],
        ),
      ),
    );
  }

  Widget _buildFavoriteButton() {
    return Positioned(
      top: 12,
      right: 12,
      child: GestureDetector(
        onTap: _toggleFavorite,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
          child: Icon(
            _isFavorite ? Icons.favorite : Icons.favorite_border,
            color: _isFavorite ? Colors.red : Colors.white,
            size: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildRecipeInfo() {
    return Positioned(
      left: 16,
      right: 16,
      bottom: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.recipe.name.toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            'By: ${widget.recipe.author}',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildRatingBadge() {
    return Positioned(
      top: 12,
      left: 12,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.orange,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.star, color: Colors.white, size: 14),
            const SizedBox(width: 2),
            Text(
              widget.recipe.rating!.toStringAsFixed(1),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCookingTimeBadge() {
    return Positioned(
      bottom: 70,
      right: 12,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.6),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.access_time, color: Colors.white, size: 12),
            const SizedBox(width: 2),
            Text(
              '${widget.recipe.cookingTime}m',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
