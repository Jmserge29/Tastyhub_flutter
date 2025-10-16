import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tastyhub/config/providers/ia/ia_provider.dart';
import 'package:flutter_tastyhub/config/providers/theme/theme_provider.dart';
import 'package:flutter_tastyhub/shared/types/app_theme_type.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_tastyhub/config/providers/providers.dart';
import 'package:flutter_tastyhub/presentation/widgets/custom_button.dart';
import 'package:flutter_tastyhub/presentation/widgets/form/custom_dropdown_form_field.dart';
import 'package:flutter_tastyhub/presentation/widgets/form/custom_input_form_field.dart';

class CreateRecipeScreen extends ConsumerStatefulWidget {
  const CreateRecipeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<CreateRecipeScreen> createState() => _CreateRecipeScreenState();
}

class _CreateRecipeScreenState extends ConsumerState<CreateRecipeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _prepTimeController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  String? _selectedCategory;
  List<String> _selectedIngredients = [];
  bool _isLoading = false;
  bool _isImprovingDescription = false; // Nuevo estado para la IA
  File? _selectedImage;

  final List<String> _categories = [
    'Mexicana',
    'Italiana',
    'Asiática',
    'Americana',
    'Mediterránea',
    'India',
    'Japonesa',
    'Francesa',
  ];

  final List<String> _availableIngredients = [
    'Carne de res',
    'Pollo',
    'Pescado',
    'Arroz',
    'Pasta',
    'Tomate',
    'Cebolla',
    'Ajo',
    'Aceite de oliva',
    'Sal',
    'Pimienta',
    'Queso',
    'Leche',
    'Huevos',
    'Harina',
    'Azúcar',
    'Mantequilla',
    'Limón',
    'Perejil',
    'Orégano',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _prepTimeController.dispose();
    super.dispose();
  }

  // Función para mejorar descripción con IA
  Future<void> _improveDescriptionWithAI() async {
    final description = _descriptionController.text.trim();

    if (description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚠️ Por favor escribe una descripción primero'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isImprovingDescription = true;
    });

    try {
      final aiService = ref.read(aiServiceProvider);
      final improvedDescription = await aiService.improveRecipeDescription(
        description: description,
        title: _titleController.text.trim().isNotEmpty
            ? _titleController.text.trim()
            : null,
        ingredients: _selectedIngredients.isNotEmpty
            ? _selectedIngredients
            : null,
      );

      setState(() {
        _descriptionController.text = improvedDescription;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✨ ¡Descripción mejorada con IA!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Error: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } finally {
      setState(() {
        _isImprovingDescription = false;
      });
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al seleccionar imagen: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Cámara'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Galería'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            if (_selectedImage != null)
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text(
                  'Eliminar imagen',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _selectedImage = null;
                  });
                },
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeState = ref.watch(themeProvider);
    return Scaffold(
      body: Column(
        children: [
          // Header section con imagen
          GestureDetector(
            onTap: _showImageSourceDialog,
            child: Container(
              height: 250,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color.fromRGBO(217, 217, 217, 1),
                image: _selectedImage != null
                    ? DecorationImage(
                        image: FileImage(_selectedImage!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: Stack(
                children: [
                  // Botón de regreso
                  Positioned(
                    top: 50,
                    left: 20,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.black),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                  ),

                  // Icono central
                  Center(
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        shape: BoxShape.circle,
                      ),
                      child: _selectedImage == null
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(
                                  Icons.add_photo_alternate,
                                  size: 32,
                                  color: Colors.grey,
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Agregar foto',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            )
                          : const Icon(
                              Icons.edit,
                              size: 32,
                              color: Colors.grey,
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Formulario
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              height: double.infinity,
              transform: Matrix4.translationValues(0, -35, 0),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),

                        // Título de la receta
                        CustomInputFormField(
                          controller: _titleController,
                          labelText: 'Título',
                          hintText: 'Costillas de cerdo ahumada...',
                          borderColor: Colors.transparent,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingresa el título de la receta';
                            }
                            return null;
                          },
                          onChanged: (value) {},
                        ),
                        const SizedBox(height: 10),

                        // Descripción con botón de IA
                        Stack(
                          children: [
                            CustomInputFormField(
                              controller: _descriptionController,
                              labelText: 'Descripción',
                              keyboardType: TextInputType.multiline,
                              maxLines: 3,
                              hintText: 'Una deliciosa receta de...',
                              borderColor: Colors.transparent,
                              onChanged: (value) {},
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor ingresa una descripción';
                                }
                                return null;
                              },
                            ),
                            // Botón mágico de IA
                            Positioned(
                              right: 8,
                              top: 8,
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: _isImprovingDescription
                                      ? null
                                      : _improveDescriptionWithAI,
                                  borderRadius: BorderRadius.circular(20),
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: themeState.themeType.primaryColor
                                          .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: themeState.themeType.primaryColor
                                            .withOpacity(0.3),
                                        width: 1,
                                      ),
                                    ),
                                    child: _isImprovingDescription
                                        ? SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                    themeState
                                                        .themeType
                                                        .primaryColor,
                                                  ),
                                            ),
                                          )
                                        : Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.auto_fix_high,
                                                size: 18,
                                                color: themeState
                                                    .themeType
                                                    .primaryColor,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                'IA',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: themeState
                                                      .themeType
                                                      .primaryColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // Categoría
                        CustomDropdownField(
                          hintText: 'Selecciona una categoría',
                          labelText: 'Categoría',
                          prefixIcon: const Icon(Icons.bookmark_border),
                          items: _categories,
                          value: _selectedCategory,
                          validator: (value) {
                            if (value == null) {
                              return 'Campo requerido';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            setState(() {
                              _selectedCategory = value;
                            });
                          },
                        ),
                        const SizedBox(height: 10),

                        // Tiempo de preparación
                        CustomInputFormField(
                          controller: _prepTimeController,
                          labelText: 'Tiempo de preparación (minutos)',
                          hintText: '30',
                          borderColor: Colors.transparent,
                          prefixIcon: const Icon(Icons.timelapse),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingresa el tiempo de preparación';
                            }
                            if (int.tryParse(value) == null) {
                              return 'Ingresa un número válido';
                            }
                            return null;
                          },
                          onChanged: (value) {},
                        ),
                        const SizedBox(height: 10),

                        // Ingredientes
                        CustomDropdownField(
                          hintText: 'Seleccione los ingredientes',
                          labelText: 'Ingredientes',
                          items: _availableIngredients,
                          validator: (value) {
                            if (_selectedIngredients.isEmpty) {
                              return 'Selecciona al menos un ingrediente';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            setState(() {
                              if (value != null &&
                                  !_selectedIngredients.contains(value)) {
                                _selectedIngredients.add(value);
                              }
                            });
                          },
                        ),
                        const SizedBox(height: 10),

                        // Chips de ingredientes seleccionados
                        if (_selectedIngredients.isNotEmpty)
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: _selectedIngredients.map((ingredient) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      themeState.themeType ==
                                          AppThemeType.vintage
                                      ? const Color.fromRGBO(145, 93, 86, 1)
                                      : themeState.themeType.primaryColor,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      ingredient,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _selectedIngredients.remove(
                                            ingredient,
                                          );
                                        });
                                      },
                                      child: const Icon(
                                        Icons.close,
                                        size: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        const SizedBox(height: 20),

                        // Botón de crear
                        Center(
                          child: _isLoading
                              ? const CircularProgressIndicator()
                              : CustomButton(
                                  text: 'Crear receta',
                                  onPressed: _createRecipe,
                                  backgroundColor:
                                      themeState.themeType.accentColor,
                                  size: ButtonSize.small,
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _createRecipe() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedIngredients.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor selecciona al menos un ingrediente'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final currentUser = await ref.read(getCurrentUserUseCaseProvider).call();

      if (currentUser == null) {
        throw Exception('No hay usuario autenticado');
      }

      final createRecipeUseCase = ref.read(createRecipeUseCaseProvider);

      final recipeId = await createRecipeUseCase.call(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        ingredients: _selectedIngredients,
        prepTime: int.parse(_prepTimeController.text.trim()),
        categoryId: _selectedCategory!,
        userId: currentUser.id,
        imageFile: _selectedImage,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _selectedImage != null
                  ? '✅ ¡Receta creada con imagen!'
                  : '✅ ¡Receta creada exitosamente!',
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );

        _titleController.clear();
        _descriptionController.clear();
        _prepTimeController.clear();

        setState(() {
          _selectedCategory = null;
          _selectedIngredients.clear();
          _selectedImage = null;
        });

        await Future.delayed(const Duration(seconds: 1));
        if (mounted) {
          Navigator.pop(context);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Error al crear receta: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
