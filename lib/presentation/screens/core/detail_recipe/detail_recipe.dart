import 'package:flutter/material.dart';



class DetailRecipeScreen extends StatelessWidget {
  const DetailRecipeScreen({super.key});

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
                    borderRadius:  BorderRadius.circular(10),
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
                padding: EdgeInsets.all(24),
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
                    ),
                    SizedBox(height: 20),
                    
                    // Stats Row
                    Row(
                      children: [
                        
                        _buildStatItem(Icons.access_time, '45 min'),
                        SizedBox(width: 65),
                        _buildStatItem(Icons.favorite_border, '123'),
                        SizedBox(width: 65),
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
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundImage: AssetImage('assets/images/profilepicture.jpg'),
                          ),
                          SizedBox(width: 10),
                          Expanded(
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
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      letterSpacing: 1.2,
                      ),
                    ),
                    SizedBox(height: 16),
                    
                    // Ingredients Tags
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _buildIngredientChip('Carne de res', Color(0xFF915D56) ),
                        _buildIngredientChip('Pimienta', Color(0xFF915D56)),
                        _buildIngredientChip('Hierba', Color(0xFF915D56)),
                        _buildIngredientChip('Mantequilla', Color(0xFF915D56)),
                        _buildIngredientChip('Beef stock', Color(0xFF915D56)),
                        _buildIngredientChip('Olive Oil', Color(0xFF915D56)),
                        _buildIngredientChip('Garlic de ajo', Color(0xFF915D56)),
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
        Icon(
          icon,
          color: Colors.grey[600],
          size: 20,
        ),
        SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(
          color: Colors.grey[600],
          fontSize: 14,
          ),
        ),
      ],
    );
  }
  
  Widget _buildIngredientChip(String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}