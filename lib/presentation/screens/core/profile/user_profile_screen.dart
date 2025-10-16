import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tastyhub/config/providers/providers.dart';
import 'package:flutter_tastyhub/domain/entities/receipe.dart';
import 'package:flutter_tastyhub/domain/entities/user.dart';
import 'package:flutter_tastyhub/presentation/screens/core/politics/politics_screen.dart';
import 'package:flutter_tastyhub/presentation/widgets/button_create_recipe.dart';
import 'package:flutter_tastyhub/presentation/widgets/recipe/recipe_card.dart';

/// Widget para mostrar estadísticas del usuario
class UserStatsWidget extends StatelessWidget {
  final int recipesCount;
  final int followersCount;
  final int followingCount;
  final VoidCallback? onRecipesTap;
  final VoidCallback? onFollowersTap;
  final VoidCallback? onFollowingTap;

  const UserStatsWidget({
    super.key,
    required this.recipesCount,
    required this.followersCount,
    required this.followingCount,
    this.onRecipesTap,
    this.onFollowersTap,
    this.onFollowingTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _StatItem(value: recipesCount, label: 'Recetas', onTap: onRecipesTap),
        _StatItem(
          value: followersCount,
          label: 'Seguidores',
          onTap: onFollowersTap,
        ),
        _StatItem(
          value: followingCount,
          label: 'Siguiendo',
          onTap: onFollowingTap,
        ),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  final int value;
  final String label;
  final VoidCallback? onTap;

  const _StatItem({required this.value, required this.label, this.onTap});

  String _formatValue(int value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}k';
    }
    return value.toString();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Text(
            _formatValue(value),
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: Colors.black,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

/// Opciones del menú desplegable
enum ProfileMenuOption { privacyAndSecurity, logout, report, block }

/// Vista principal del perfil de usuario
class UserProfileScreen extends ConsumerStatefulWidget {
  final String userId;
  final String? previousRoute;

  const UserProfileScreen({
    super.key,
    required this.userId,
    this.previousRoute,
  });

  @override
  ConsumerState<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends ConsumerState<UserProfileScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(userByIdProvider(widget.userId));
    final currentUserAsync = ref.watch(currentUserProvider);
    final isFollowingAsync = ref.watch(isFollowingProvider(widget.userId));

    return Scaffold(
      body: userAsync.when(
        data: (user) {
          if (user == null) {
            return const Center(child: Text('Usuario no encontrado'));
          }

          return currentUserAsync.when(
            data: (currentUser) {
              final isCurrentUser = currentUser?.id == user.id;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: CustomScrollView(
                  slivers: [
                    _buildAppBar(isCurrentUser),
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          _buildProfileHeader(user),
                          _buildUserStats(user, isCurrentUser),
                          const SizedBox(height: 32),
                          _buildAboutSection(user),
                          if (!isCurrentUser) ...[
                            const SizedBox(height: 24),
                            isFollowingAsync.when(
                              data: (isFollowing) => _buildFollowButton(
                                isFollowing,
                                currentUser,
                                user,
                              ),
                              loading: () => const Center(
                                child: CircularProgressIndicator(),
                              ),
                              error: (_, __) => const SizedBox.shrink(),
                            ),
                          ],
                          const SizedBox(height: 32),
                          _buildRecipesSection(user, isCurrentUser),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Center(child: Text('Error: $error')),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
      ),
      floatingActionButton: currentUserAsync.when(
        data: (currentUser) {
          if (currentUser?.id == widget.userId) {
            return const ButtonCreateRecipe();
          }
          return null;
        },
        loading: () => null,
        error: (_, __) => null,
      ),
    );
  }

  Widget _buildAppBar(bool isCurrentUser) {
    return SliverAppBar(
      elevation: 0,
      pinned: false,
      floating: true,
      backgroundColor: Colors.transparent,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black87),
        onPressed: _handleBackNavigation,
      ),
      actions: [
        PopupMenuButton<ProfileMenuOption>(
          icon: const Icon(Icons.more_vert, color: Colors.black87),
          onSelected: _handleMenuSelection,
          offset: const Offset(0, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 8,
          color: Colors.white,
          itemBuilder: (context) => _buildMenuItems(isCurrentUser),
        ),
      ],
    );
  }

  void _handleBackNavigation() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else if (widget.previousRoute != null) {
      Navigator.pushReplacementNamed(context, widget.previousRoute!);
    } else {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  List<PopupMenuEntry<ProfileMenuOption>> _buildMenuItems(bool isCurrentUser) {
    if (isCurrentUser) {
      return [
        PopupMenuItem(
          value: ProfileMenuOption.privacyAndSecurity,
          child: const ListTile(
            leading: Icon(Icons.security),
            title: Text('Políticas y seguridad'),
            contentPadding: EdgeInsets.zero,
          ),
          onTap: () => Future.delayed(
            const Duration(milliseconds: 100),
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PoliticsScreen()),
            ),
          ),
        ),
        PopupMenuItem(
          value: ProfileMenuOption.logout,
          child: const ListTile(
            leading: Icon(Icons.logout),
            title: Text('Cerrar sesión'),
            contentPadding: EdgeInsets.zero,
          ),
          onTap: () => Future.delayed(
            const Duration(milliseconds: 100),
            () => _showLogoutDialog(),
          ),
        ),
      ];
    } else {
      return [
        const PopupMenuItem(
          value: ProfileMenuOption.report,
          child: ListTile(
            leading: Icon(Icons.report, color: Colors.orange),
            title: Text('Reportar usuario'),
            contentPadding: EdgeInsets.zero,
          ),
        ),
        const PopupMenuItem(
          value: ProfileMenuOption.block,
          child: ListTile(
            leading: Icon(Icons.block, color: Colors.red),
            title: Text('Bloquear usuario'),
            contentPadding: EdgeInsets.zero,
          ),
        ),
      ];
    }
  }

  void _handleMenuSelection(ProfileMenuOption option) {
    switch (option) {
      case ProfileMenuOption.privacyAndSecurity:
        break;
      case ProfileMenuOption.logout:
        break;
      case ProfileMenuOption.report:
        _showReportDialog();
        break;
      case ProfileMenuOption.block:
        _showBlockDialog();
        break;
    }
  }

  Widget _buildProfileHeader(User user) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
      child: Column(
        children: [
          CircleAvatar(
            radius: 36,
            backgroundColor: Colors.grey.shade300,
            backgroundImage:
                user.profileImageUrl != null && user.profileImageUrl!.isNotEmpty
                ? NetworkImage(user.profileImageUrl!)
                : null,
            child: user.profileImageUrl == null || user.profileImageUrl!.isEmpty
                ? Icon(Icons.person, size: 50, color: Colors.grey.shade600)
                : null,
          ),
          const SizedBox(height: 16),
          Text(
            user.name,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 2),
          if (user.role != null && user.role!.isNotEmpty)
            Text(
              user.role!.toUpperCase(),
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildUserStats(User user, bool isCurrentUser) {
    final userRecipesAsync = ref.watch(userRecipesProvider(user.id));

    return userRecipesAsync.when(
      data: (recipes) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: UserStatsWidget(
          recipesCount: recipes.length,
          followersCount: user.followersCount,
          followingCount: user.followingCount,
          onRecipesTap: () => _showRecipesList(context),
          onFollowersTap: () => _navigateToFollowersList(user.id),
          onFollowingTap: () => _navigateToFollowingList(user.id),
        ),
      ),
      loading: () => Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: UserStatsWidget(
          recipesCount: 0,
          followersCount: user.followersCount,
          followingCount: user.followingCount,
          onRecipesTap: () => _showRecipesList(context),
          onFollowersTap: () => _navigateToFollowersList(user.id),
          onFollowingTap: () => _navigateToFollowingList(user.id),
        ),
      ),
      error: (error, _) {
        print('Error loading recipes: $error');
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: UserStatsWidget(
            recipesCount: 0,
            followersCount: user.followersCount,
            followingCount: user.followingCount,
            onRecipesTap: () => _showRecipesList(context),
            onFollowersTap: () => _navigateToFollowersList(user.id),
            onFollowingTap: () => _navigateToFollowingList(user.id),
          ),
        );
      },
    );
  }

  Widget _buildAboutSection(User user) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ACERCA DE',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w900,
              color: Color.fromARGB(255, 108, 108, 108),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            user.bio ?? 'Sin descripción',
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.black,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFollowButton(
    bool isFollowing,
    User? currentUser,
    User targetUser,
  ) {
    if (currentUser == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _isLoading
              ? null
              : () => _toggleFollow(isFollowing, currentUser.id, targetUser),
          style: ElevatedButton.styleFrom(
            backgroundColor: isFollowing
                ? Colors.grey.shade300
                : const Color.fromRGBO(69, 38, 30, 1),
            foregroundColor: isFollowing ? Colors.black87 : Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
          ),
          child: _isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Text(
                  isFollowing ? 'Siguiendo' : 'Seguir',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildRecipesSection(User user, bool isCurrentUser) {
    final userRecipesAsync = ref.watch(userRecipesProvider(user.id));

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isCurrentUser ? 'MIS PUBLICACIONES' : 'PUBLICACIONES',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w900,
              color: Color.fromARGB(255, 108, 108, 108),
            ),
          ),
          const SizedBox(height: 16),
          userRecipesAsync.when(
            data: (recipes) => _buildRecipesGrid(recipes, isCurrentUser),
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(32.0),
                child: CircularProgressIndicator(),
              ),
            ),
            error: (error, stackTrace) {
              print('Error loading recipes: $error');
              print('Stack trace: $stackTrace');
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 48,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Error al cargar recetas',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRecipesGrid(List<Recipe> userRecipes, bool isCurrentUser) {
    if (userRecipes.isEmpty) {
      return SizedBox(
        height: 200,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.restaurant_menu,
                size: 48,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 16),
              Text(
                isCurrentUser
                    ? 'Aún no has publicado recetas'
                    : 'Este usuario no ha publicado recetas',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
              ),
            ],
          ),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.8,
      ),
      itemCount: userRecipes.length,
      itemBuilder: (context, index) {
        final recipe = userRecipes[index];
        return RecipeCard(
          recipe: recipe,
          width: 80,
          height: 100,
          onTap: () => _navigateToRecipeDetail(recipe),
        );
      },
    );
  }

  Future<void> _toggleFollow(
    bool isFollowing,
    String currentUserId,
    User targetUser,
  ) async {
    setState(() => _isLoading = true);

    try {
      if (isFollowing) {
        await ref
            .read(authRepositoryProvider)
            .unfollowUser(currentUserId, targetUser.id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Dejaste de seguir a ${targetUser.name}'),
              backgroundColor: Colors.grey.shade700,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      } else {
        await ref
            .read(authRepositoryProvider)
            .followUser(currentUserId, targetUser.id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Ahora sigues a ${targetUser.name}'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }

      ref.invalidate(isFollowingProvider(targetUser.id));
      ref.invalidate(userByIdProvider(targetUser.id));
      ref.invalidate(currentUserProvider);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showRecipesList(BuildContext context) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Mostrando lista de recetas')));
  }

  void _navigateToFollowersList(String userId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FollowersListScreen(userId: userId),
      ),
    );
  }

  void _navigateToFollowingList(String userId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FollowingListScreen(userId: userId),
      ),
    );
  }

  void _navigateToRecipeDetail(Recipe recipe) {
    Navigator.pushNamed(context, '/recipe-detail', arguments: recipe);
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cerrar sesión'),
        content: const Text('¿Estás seguro de que quieres cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _performLogout();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Cerrar sesión'),
          ),
        ],
      ),
    );
  }

  void _showReportDialog() {
    final user = ref.read(userByIdProvider(widget.userId)).value;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reportar usuario'),
        content: Text('¿Quieres reportar a ${user?.name ?? "este usuario"}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _performReport();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: const Text('Reportar'),
          ),
        ],
      ),
    );
  }

  void _showBlockDialog() {
    final user = ref.read(userByIdProvider(widget.userId)).value;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Bloquear usuario'),
        content: Text('¿Quieres bloquear a ${user?.name ?? "este usuario"}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _performBlock();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Bloquear'),
          ),
        ],
      ),
    );
  }

  void _performLogout() {
    ref.read(authRepositoryProvider).signOut();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Sesión cerrada')));
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  void _performReport() {
    final user = ref.read(userByIdProvider(widget.userId)).value;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Usuario ${user?.name ?? ""} reportado')),
    );
  }

  void _performBlock() {
    final user = ref.read(userByIdProvider(widget.userId)).value;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Usuario ${user?.name ?? ""} bloqueado')),
    );
  }
}

class FollowersListScreen extends ConsumerWidget {
  final String userId;

  const FollowersListScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final followersAsync = ref.watch(userFollowersProvider(userId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Seguidores'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: followersAsync.when(
        data: (followers) {
          if (followers.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.people_outline,
                    size: 64,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No hay seguidores aún',
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: followers.length,
            itemBuilder: (context, index) {
              final follower = followers[index];
              return UserListTile(user: follower);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error: $error'),
            ],
          ),
        ),
      ),
    );
  }
}

class FollowingListScreen extends ConsumerWidget {
  final String userId;

  const FollowingListScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final followingAsync = ref.watch(userFollowingProvider(userId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Siguiendo'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: followingAsync.when(
        data: (following) {
          if (following.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.person_add_outlined,
                    size: 64,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No sigue a nadie aún',
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: following.length,
            itemBuilder: (context, index) {
              final user = following[index];
              return UserListTile(user: user);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error: $error'),
            ],
          ),
        ),
      ),
    );
  }
}

class UserListTile extends ConsumerWidget {
  final User user;

  const UserListTile({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserAsync = ref.watch(currentUserProvider);
    final isFollowingAsync = ref.watch(isFollowingProvider(user.id));

    return currentUserAsync.when(
      data: (currentUser) {
        final isCurrentUser = currentUser?.id == user.id;

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: ListTile(
            leading: CircleAvatar(
              radius: 24,
              backgroundColor: Colors.grey.shade300,
              backgroundImage:
                  user.profileImageUrl != null &&
                      user.profileImageUrl!.isNotEmpty
                  ? NetworkImage(user.profileImageUrl!)
                  : null,
              child:
                  user.profileImageUrl == null || user.profileImageUrl!.isEmpty
                  ? Icon(Icons.person, size: 24, color: Colors.grey.shade600)
                  : null,
            ),
            title: Text(
              user.name,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
            ),
            subtitle: user.role != null && user.role!.isNotEmpty
                ? Text(
                    user.role!,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  )
                : null,
            trailing: isCurrentUser
                ? null
                : isFollowingAsync.when(
                    data: (isFollowing) => _FollowButton(
                      isFollowing: isFollowing,
                      currentUserId: currentUser!.id,
                      targetUser: user,
                    ),
                    loading: () => const SizedBox(
                      width: 80,
                      height: 32,
                      child: Center(
                        child: SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                    ),
                    error: (_, _) => const SizedBox.shrink(),
                  ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserProfileScreen(userId: user.id),
                ),
              );
            },
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
    );
  }
}

class _FollowButton extends ConsumerStatefulWidget {
  final bool isFollowing;
  final String currentUserId;
  final User targetUser;

  const _FollowButton({
    required this.isFollowing,
    required this.currentUserId,
    required this.targetUser,
  });

  @override
  ConsumerState<_FollowButton> createState() => _FollowButtonState();
}

class _FollowButtonState extends ConsumerState<_FollowButton> {
  bool _isLoading = false;

  Future<void> _toggleFollow() async {
    setState(() => _isLoading = true);

    try {
      if (widget.isFollowing) {
        await ref
            .read(authRepositoryProvider)
            .unfollowUser(widget.currentUserId, widget.targetUser.id);
      } else {
        await ref
            .read(authRepositoryProvider)
            .followUser(widget.currentUserId, widget.targetUser.id);
      }

      ref.invalidate(isFollowingProvider(widget.targetUser.id));
      ref.invalidate(userByIdProvider(widget.targetUser.id));
      ref.invalidate(userFollowersProvider(widget.targetUser.id));
      ref.invalidate(userFollowingProvider(widget.currentUserId));
      ref.invalidate(currentUserProvider);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 32,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _toggleFollow,
        style: ElevatedButton.styleFrom(
          backgroundColor: widget.isFollowing
              ? Colors.grey.shade300
              : const Color.fromRGBO(69, 38, 30, 1),
          foregroundColor: widget.isFollowing ? Colors.black87 : Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
        ),
        child: _isLoading
            ? const SizedBox(
                height: 16,
                width: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                widget.isFollowing ? 'Siguiendo' : 'Seguir',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}
