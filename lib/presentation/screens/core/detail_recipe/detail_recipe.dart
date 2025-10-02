import 'package:flutter/material.dart';
import 'package:flutter_tastyhub/domain/entities/receipe.dart';
import 'package:flutter_tastyhub/presentation/screens/core/profile/user_profile_screen.dart';

class DetailRecipeScreen extends StatelessWidget {
  const DetailRecipeScreen({super.key});

  void _navigateToUserProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserProfileScreen(
          userProfile: UserProfile(
            isCurrentUser: true,
            id: 'jose_serge_id',
            name: 'José Serge',
            role: 'Desarrollador Software',
            avatarUrl:
                'https://i.pinimg.com/736x/8d/98/09/8d98092817acce47d8a28e93c1deef6f.jpg',
            description:
                'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries',
            recipesCount: 25,
            followersCount: 100,
            likesCount: 200,
            userRecipes: [
              Recipe(
                id: 'filete_carne_res',
                title: 'Filete Carne de Res',
                categoryId: '1',
                createdAt: DateTime(2023, 1, 1),
                description: 'Delicious beef steak recipe',
                ingredients: [
                  'Carne de res',
                  'Pimienta',
                  'Hierba',
                  'Mantequilla',
                  'Beef stock',
                  'Olive Oil',
                  'Garlic de ajo',
                  'Onion mix',
                ],
                prepTime: 45,
                userId: 'jose_serge_id',
                imageUrl:
                    'https://www2.claro.com.co/portal/recursos/co/cpp/promociones/imagenes/1652370816559-6-comida-colombiana.jpg',
              ),
              Recipe(
                id: 'filete_carne_res',
                title: 'Filete Carne de Res',
                categoryId: '1',
                createdAt: DateTime(2023, 1, 1),
                description: 'Delicious beef steak recipe',
                ingredients: [
                  'Carne de res',
                  'Pimienta',
                  'Hierba',
                  'Mantequilla',
                  'Beef stock',
                  'Olive Oil',
                  'Garlic de ajo',
                  'Onion mix',
                ],
                prepTime: 45,
                userId: 'jose_serge_id',
                imageUrl:
                    'https://i.pinimg.com/736x/8d/98/09/8d98092817acce47d8a28e93c1deef6f.jpg',
              ),
            ],
          ),
          previousRoute: '/detail_recipe',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Image Section
            ClipRRect(
              borderRadius: BorderRadius.only(
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
                        image: AssetImage('assets/images/filete.jpg'),
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
                        icon: Icon(Icons.arrow_back, color: Colors.black),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Content Section
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              transform: Matrix4.translationValues(0, -20, 0),
              child: Padding(
                padding: EdgeInsets.all(36),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      'Filete Carne de Res\nen pimienta',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        height: 1.2,
                      ),
                    ),
                    SizedBox(height: 16),

                    // Description
                    Text(
                      'Lorem ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        height: 1.5,
                      ),
                      // textAlign: TextAlign.justify,
                    ),
                    SizedBox(height: 20),

                    // Stats Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildStatItem(Icons.access_time, '45 min'),
                        _buildStatItem(Icons.favorite_border, '123'),
                        _buildStatItem(Icons.bookmark_border, 'Luxury'),
                      ],
                    ),
                    SizedBox(height: 30),

                    // Chef Section with dark background
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xFF1B0B0B),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () => _navigateToUserProfile(context),
                            child: CircleAvatar(
                              radius: 20,
                              backgroundImage: AssetImage(
                                'assets/images/profilepicture.jpg',
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => _navigateToUserProfile(context),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'José Serge',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    'Desarrollador Software',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            width: 34,
                            height: 34,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.add, size: 19),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),

                    // Ingredients Section
                    Text(
                      'INGREDIENTES',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        color: Color.fromARGB(255, 108, 108, 108),
                      ),
                    ),
                    SizedBox(height: 16),

                    // Ingredients Tags
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _buildIngredientChip('Carne de res', Color(0xFF915D56)),
                        _buildIngredientChip('Pimienta', Color(0xFF915D56)),
                        _buildIngredientChip('Hierba', Color(0xFF915D56)),
                        _buildIngredientChip('Mantequilla', Color(0xFF915D56)),
                        _buildIngredientChip('Beef stock', Color(0xFF915D56)),
                        _buildIngredientChip('Olive Oil', Color(0xFF915D56)),
                        _buildIngredientChip(
                          'Garlic de ajo',
                          Color(0xFF915D56),
                        ),
                        _buildIngredientChip('Onion mix', Color(0xFF915D56)),
                      ],
                    ),
                    SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey[600], size: 20),
        SizedBox(width: 6),
        Text(text, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
      ],
    );
  }

  Widget _buildIngredientChip(String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
