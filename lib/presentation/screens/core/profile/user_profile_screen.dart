import 'package:flutter/material.dart';
import 'package:flutter_tastyhub/presentation/shared/recipe/recipe_card.dart';

/// Modelo de datos para el usuario
class UserProfile {
  final String id;
  final String name;
  final String role;
  final String avatarUrl;
  final String description;
  final int recipesCount;
  final int followersCount;
  final int likesCount;
  final List<Recipe> userRecipes;
  final bool isCurrentUser;

  const UserProfile({
    required this.id,
    required this.name,
    required this.role,
    required this.avatarUrl,
    required this.description,
    required this.recipesCount,
    required this.followersCount,
    required this.likesCount,
    required this.userRecipes,
    this.isCurrentUser = false,
  });
}

/// Widget para mostrar estadísticas del usuario
class UserStatsWidget extends StatelessWidget {
  final int recipesCount;
  final int followersCount;
  final int likesCount;

  const UserStatsWidget({
    Key? key,
    required this.recipesCount,
    required this.followersCount,
    required this.likesCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _StatItem(
          value: recipesCount,
          label: 'Recetas',
          onTap: () => _showRecipesList(context),
        ),
        _StatItem(
          value: followersCount,
          label: 'Seguidores',
          onTap: () => _showFollowersList(context),
        ),
        _StatItem(
          value: likesCount,
          label: 'Me gustas',
          onTap: () => _showLikesList(context),
        ),
      ],
    );
  }

  void _showRecipesList(BuildContext context) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Mostrando lista de recetas')));
  }

  void _showFollowersList(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Mostrando lista de seguidores')),
    );
  }

  void _showLikesList(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Mostrando lista de me gustas')),
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
              fontSize: 34,
              fontWeight: FontWeight.w900,
              color: Colors.black,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
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
enum ProfileMenuOption {
  settings,
  editProfile,
  privacyAndSecurity,
  logout,
  report,
  block,
}

/// Vista principal del perfil de usuario
class UserProfileScreen extends StatefulWidget {
  final UserProfile userProfile;
  final String? previousRoute; // Para saber de dónde viene

  const UserProfileScreen({
    super.key,
    required this.userProfile,
    this.previousRoute,
  });

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  bool _isFollowing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(
            child: Column(
              children: [
                _buildProfileHeader(),
                const SizedBox(height: 24),
                _buildUserStats(),
                const SizedBox(height: 32),
                _buildAboutSection(),
                const SizedBox(height: 32),
                _buildRecipesSection(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: widget.userProfile.isCurrentUser
          ? _buildAddRecipeButton()
          : null,
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      elevation: 0,
      pinned: false,
      floating: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black87),
        onPressed: _handleBackNavigation,
      ),
      actions: [
        PopupMenuButton<ProfileMenuOption>(
          icon: const Icon(Icons.more_vert, color: Colors.black87),
          onSelected: _handleMenuSelection,
          itemBuilder: (context) => _buildMenuItems(),
        ),
      ],
    );
  }

  void _handleBackNavigation() {
    // Navegación inteligente basada en el origen
    if (widget.previousRoute != null) {
      Navigator.pushReplacementNamed(context, widget.previousRoute!);
    } else if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      // Si no hay ruta previa, ir al home
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  List<PopupMenuEntry<ProfileMenuOption>> _buildMenuItems() {
    if (widget.userProfile.isCurrentUser) {
      // Menú para el usuario actual
      return [
        const PopupMenuItem(
          value: ProfileMenuOption.settings,
          child: ListTile(
            leading: Icon(Icons.settings),
            title: Text('Ajustes'),
            contentPadding: EdgeInsets.zero,
          ),
        ),
        const PopupMenuItem(
          value: ProfileMenuOption.editProfile,
          child: ListTile(
            leading: Icon(Icons.edit),
            title: Text('Editar perfil'),
            contentPadding: EdgeInsets.zero,
          ),
        ),
        const PopupMenuItem(
          value: ProfileMenuOption.privacyAndSecurity,
          child: ListTile(
            leading: Icon(Icons.security),
            title: Text('Políticas y seguridad'),
            contentPadding: EdgeInsets.zero,
          ),
        ),
        const PopupMenuDivider(),
        const PopupMenuItem(
          value: ProfileMenuOption.logout,
          child: ListTile(
            leading: Icon(Icons.logout, color: Colors.red),
            title: Text('Cerrar sesión', style: TextStyle(color: Colors.red)),
            contentPadding: EdgeInsets.zero,
          ),
        ),
      ];
    } else {
      // Menú para otros usuarios
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
            title: Text(
              'Bloquear usuario',
              style: TextStyle(color: Colors.red),
            ),
            contentPadding: EdgeInsets.zero,
          ),
        ),
      ];
    }
  }

  void _handleMenuSelection(ProfileMenuOption option) {
    switch (option) {
      case ProfileMenuOption.settings:
        _navigateToSettings();
        break;
      case ProfileMenuOption.editProfile:
        _navigateToEditProfile();
        break;
      case ProfileMenuOption.privacyAndSecurity:
        _navigateToPrivacySettings();
        break;
      case ProfileMenuOption.logout:
        _showLogoutDialog();
        break;
      case ProfileMenuOption.report:
        _showReportDialog();
        break;
      case ProfileMenuOption.block:
        _showBlockDialog();
        break;
    }
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
      child: Column(
        children: [
          // Avatar
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.grey.shade300,
            backgroundImage: widget.userProfile.avatarUrl.isNotEmpty
                ? NetworkImage(widget.userProfile.avatarUrl)
                : null,
            child: widget.userProfile.avatarUrl.isEmpty
                ? Icon(Icons.person, size: 50, color: Colors.grey.shade600)
                : null,
          ),
          const SizedBox(height: 16),

          // Nombre
          Text(
            widget.userProfile.name,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 2),

          // Rol
          Text(
            widget.userProfile.role.toUpperCase(),
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

  Widget _buildUserStats() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: UserStatsWidget(
        recipesCount: widget.userProfile.recipesCount,
        followersCount: widget.userProfile.followersCount,
        likesCount: widget.userProfile.likesCount,
      ),
    );
  }

  Widget _buildAboutSection() {
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
            widget.userProfile.description,
            maxLines: 3,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w100,
              color: Colors.black,
              height: 1.5,
            ),
          ),
          if (!widget.userProfile.isCurrentUser) ...[
            const SizedBox(height: 24),
            _buildFollowButton(),
          ],
        ],
      ),
    );
  }

  Widget _buildFollowButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _toggleFollow,
        style: ElevatedButton.styleFrom(
          backgroundColor: _isFollowing
              ? Colors.grey.shade300
              : const Color.fromRGBO(69, 38, 30, 1),
          foregroundColor: _isFollowing ? Colors.black87 : Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
        ),
        child: Text(
          _isFollowing ? 'Siguiendo' : 'Seguir',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildRecipesSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'MIS PUBLICACIONES',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w900,
              color: Color.fromARGB(255, 108, 108, 108),
            ),
          ),
          const SizedBox(height: 16),
          _buildRecipesGrid(),
        ],
      ),
    );
  }

  Widget _buildRecipesGrid() {
    if (widget.userProfile.userRecipes.isEmpty) {
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
                widget.userProfile.isCurrentUser
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
      itemCount: widget.userProfile.userRecipes.length,
      itemBuilder: (context, index) {
        final recipe = widget.userProfile.userRecipes[index];
        return RecipeCard(
          recipe: recipe,
          width: double.infinity,
          height: double.infinity,
          onTap: () => _navigateToRecipeDetail(recipe),
        );
      },
    );
  }

  Widget _buildAddRecipeButton() {
    return FloatingActionButton(
      onPressed: _navigateToAddRecipe,
      backgroundColor: const Color.fromRGBO(69, 38, 30, 1),
      child: const Icon(Icons.add, color: Colors.white),
    );
  }

  void _toggleFollow() {
    setState(() {
      _isFollowing = !_isFollowing;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isFollowing
              ? 'Ahora sigues a ${widget.userProfile.name}'
              : 'Dejaste de seguir a ${widget.userProfile.name}',
        ),
      ),
    );
  }

  // Métodos de navegación
  void _navigateToSettings() {
    Navigator.pushNamed(context, '/settings');
  }

  void _navigateToEditProfile() {
    Navigator.pushNamed(context, '/edit-profile');
  }

  void _navigateToPrivacySettings() {
    Navigator.pushNamed(context, '/privacy-settings');
  }

  void _navigateToAddRecipe() {
    Navigator.pushNamed(context, '/add-recipe');
  }

  void _navigateToRecipeDetail(Recipe recipe) {
    Navigator.pushNamed(context, '/recipe-detail', arguments: recipe);
  }

  // Métodos de diálogos
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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reportar usuario'),
        content: Text('¿Quieres reportar a ${widget.userProfile.name}?'),
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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Bloquear usuario'),
        content: Text('¿Quieres bloquear a ${widget.userProfile.name}?'),
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
    // Lógica de logout
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Sesión cerrada')));
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  void _performReport() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Usuario ${widget.userProfile.name} reportado')),
    );
  }

  void _performBlock() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Usuario ${widget.userProfile.name} bloqueado')),
    );
  }
}
