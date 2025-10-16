import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tastyhub/config/providers/providers.dart';
import 'package:flutter_tastyhub/config/providers/theme/theme_provider.dart';
import 'package:flutter_tastyhub/domain/entities/receipe.dart';
import 'package:flutter_tastyhub/domain/entities/user.dart';
import 'package:flutter_tastyhub/presentation/screens/core/profile/user_profile_screen.dart';
import 'package:flutter_tastyhub/shared/types/app_theme_type.dart';

class DetailRecipeScreen extends ConsumerStatefulWidget {
  final String recipeId;
  const DetailRecipeScreen({super.key, required this.recipeId});

  @override
  ConsumerState<DetailRecipeScreen> createState() => _DetailRecipeScreenState();
}

class _DetailRecipeScreenState extends ConsumerState<DetailRecipeScreen> {
  bool _isProcessingLike = false;
  bool _isProcessingFollow = false;

  Future<void> _toggleLike(Recipe recipe) async {
    if (_isProcessingLike) return;

    setState(() => _isProcessingLike = true);

    try {
      final currentUser = await ref.read(getCurrentUserUseCaseProvider).call();

      if (currentUser == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Debes iniciar sesión para dar like'),
              backgroundColor: Colors.orange,
            ),
          );
        }
        return;
      }

      await ref.read(toggleLikeUseCaseProvider).call(recipe.id, currentUser.id);

      // Refrescar el provider del detalle
      ref.invalidate(_recipeDetailProvider(widget.recipeId));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessingLike = false);
      }
    }
  }

  Future<void> _toggleFollow(String recipeAuthorId) async {
    if (_isProcessingFollow) return;

    setState(() => _isProcessingFollow = true);

    try {
      final currentUser = await ref.read(getCurrentUserUseCaseProvider).call();

      if (currentUser == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Debes iniciar sesión para seguir usuarios'),
              backgroundColor: Colors.orange,
            ),
          );
        }
        return;
      }

      // Verificar si ya está siguiendo
      final isFollowing = await ref
          .read(authRepositoryProvider)
          .isFollowing(currentUser.id, recipeAuthorId);

      if (isFollowing) {
        await ref
            .read(authRepositoryProvider)
            .unfollowUser(currentUser.id, recipeAuthorId);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Dejaste de seguir al usuario'),
              backgroundColor: Colors.grey,
            ),
          );
        }
      } else {
        await ref
            .read(authRepositoryProvider)
            .followUser(currentUser.id, recipeAuthorId);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Ahora sigues a este usuario'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }

      // Refrescar los providers
      ref.invalidate(userByIdProvider(recipeAuthorId));
      ref.invalidate(isFollowingProvider(recipeAuthorId));
      ref.invalidate(currentUserProvider);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessingFollow = false);
      }
    }
  }

  void _navigateToUserProfile(String userId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserProfileScreen(userId: userId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final recipeAsync = ref.watch(_recipeDetailProvider(widget.recipeId));
    final currentUserAsync = ref.watch(currentUserProvider);
    final themeState = ref.watch(themeProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      body: recipeAsync.when(
        data: (recipe) => _buildContent(
          recipe,
          currentUserAsync,
          themeState.themeType.primaryColor,
          themeState.themeType.accentColor,
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Error: $error',
                style: const TextStyle(color: Colors.white),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Regresar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(
    Recipe recipe,
    AsyncValue<User?> currentUserAsync,
    Color colorTheme,
    Color colorThemeAccent,
  ) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Image Section
          ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            child: Stack(
              children: [
                Container(
                  height: 400,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: recipe.imageUrl.isNotEmpty
                          ? NetworkImage(recipe.imageUrl)
                          : const AssetImage(
                                  'assets/images/default_image_receipe.png',
                                )
                                as ImageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Back button
                Positioned(
                  top: 50,
                  left: 20,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Content Section
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            transform: Matrix4.translationValues(0, -20, 0),
            child: Padding(
              padding: const EdgeInsets.all(36),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    recipe.title,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Description
                  Text(
                    recipe.description,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Stats Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStatItem(
                        Icons.access_time,
                        '${recipe.prepTime} min',
                      ),
                      currentUserAsync.when(
                        data: (currentUser) => GestureDetector(
                          onTap: () => _toggleLike(recipe),
                          child: Row(
                            children: [
                              _isProcessingLike
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Icon(
                                      currentUser != null &&
                                              recipe.isLikedBy(currentUser.id)
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color:
                                          currentUser != null &&
                                              recipe.isLikedBy(currentUser.id)
                                          ? Colors.red
                                          : Colors.grey[600],
                                      size: 20,
                                    ),
                              const SizedBox(width: 6),
                              Text(
                                '${recipe.likesCount}',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        loading: () => _buildStatItem(
                          Icons.favorite_border,
                          '${recipe.likesCount}',
                        ),
                        error: (_, __) => _buildStatItem(
                          Icons.favorite_border,
                          '${recipe.likesCount}',
                        ),
                      ),
                      _buildStatItem(Icons.bookmark_border, recipe.categoryId),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // Chef Section - Usuario que creó la receta
                  _buildChefSection(
                    recipe.userId,
                    currentUserAsync,
                    colorThemeAccent,
                  ),
                  const SizedBox(height: 30),

                  // Ingredients Section
                  Text(
                    'INGREDIENTES',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      color: Color.fromARGB(255, 108, 108, 108),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Ingredients Tags
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: recipe.ingredients
                        .map(
                          (ingredient) =>
                              _buildIngredientChip(ingredient, colorTheme),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChefSection(
    String userId,
    AsyncValue<User?> currentUserAsync,
    Color colorTheme,
  ) {
    final recipeAuthorAsync = ref.watch(userByIdProvider(userId));
    final isFollowingAsync = ref.watch(isFollowingProvider(userId));

    return recipeAuthorAsync.when(
      data: (recipeAuthor) {
        if (recipeAuthor == null) {
          return _buildDefaultChefSection();
        }

        return currentUserAsync.when(
          data: (currentUser) {
            final isCurrentUser = currentUser?.id == recipeAuthor.id;

            return GestureDetector(
              onTap: () => _navigateToUserProfile(recipeAuthor.id),
              child: Container(
                decoration: BoxDecoration(
                  color: colorTheme,
                  borderRadius: BorderRadius.circular(25),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.grey.shade300,
                      backgroundImage:
                          recipeAuthor.profileImageUrl != null &&
                              recipeAuthor.profileImageUrl!.isNotEmpty
                          ? NetworkImage(recipeAuthor.profileImageUrl!)
                          : null,
                      child:
                          recipeAuthor.profileImageUrl == null ||
                              recipeAuthor.profileImageUrl!.isEmpty
                          ? const Icon(Icons.person, color: Colors.white)
                          : null,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            recipeAuthor.name,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          if (recipeAuthor.role != null &&
                              recipeAuthor.role!.isNotEmpty)
                            Text(
                              recipeAuthor.role!,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white70,
                              ),
                            ),
                        ],
                      ),
                    ),
                    if (!isCurrentUser)
                      isFollowingAsync.when(
                        data: (isFollowing) => GestureDetector(
                          onTap: () => _toggleFollow(recipeAuthor.id),
                          child: Container(
                            width: 34,
                            height: 34,
                            decoration: BoxDecoration(
                              color: isFollowing
                                  ? Colors.grey.shade300
                                  : Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: _isProcessingFollow
                                ? const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.black,
                                      ),
                                    ),
                                  )
                                : Icon(
                                    isFollowing ? Icons.check : Icons.add,
                                    size: 19,
                                    color: Colors.black,
                                  ),
                          ),
                        ),
                        loading: () => Container(
                          width: 34,
                          height: 34,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.black,
                              ),
                            ),
                          ),
                        ),
                        error: (_, __) => Container(
                          width: 34,
                          height: 34,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.add, size: 19),
                        ),
                      )
                    else
                      Container(
                        width: 34,
                        height: 34,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.person, size: 19),
                      ),
                  ],
                ),
              ),
            );
          },
          loading: () => _buildDefaultChefSection(),
          error: (_, __) => _buildDefaultChefSection(),
        );
      },
      loading: () => _buildDefaultChefSection(),
      error: (_, __) => _buildDefaultChefSection(),
    );
  }

  Widget _buildDefaultChefSection() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1B0B0B),
        borderRadius: BorderRadius.circular(25),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.grey.shade300,
            child: const Icon(Icons.person, color: Colors.white),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Chef',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Cargando...',
                  style: TextStyle(fontSize: 12, color: Colors.white70),
                ),
              ],
            ),
          ),
          Container(
            width: 34,
            height: 34,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.add, size: 19),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey[600], size: 20),
        const SizedBox(width: 6),
        Text(text, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
      ],
    );
  }

  Widget _buildIngredientChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

// Provider para obtener el detalle de la receta
final _recipeDetailProvider = FutureProvider.family<Recipe, String>((
  ref,
  recipeId,
) async {
  final useCase = ref.watch(getRecipeByIdUseCaseProvider);
  return await useCase.call(recipeId);
});
