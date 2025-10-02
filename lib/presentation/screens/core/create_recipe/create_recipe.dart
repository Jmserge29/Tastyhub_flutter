import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  String? _selectedCategory;
  List<String> _selectedIngredients = [];
  bool _isLoading = false;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Header section con imagen
          Container(
            height: 250,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color.fromRGBO(217, 217, 217, 1),
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

                // Icono central de plato
                Center(
                  child: Container(
                    width: 80,
                    height: 80,
                    child: Image.asset(
                      'assets/images/default_image_receipe.png',
                      width: 24,
                      height: 24,
                    ),
                  ),
                ),
              ],
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

                        // Descripción
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
                                _selectedIngredients.add(value as String);
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
                                  color: const Color.fromRGBO(145, 93, 86, 1),
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
                                  backgroundColor: const Color.fromRGBO(
                                    82,
                                    34,
                                    34,
                                    1,
                                  ),
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
      // Obtener el UseCase desde Riverpod
      final createRecipeUseCase = ref.read(createRecipeUseCaseProvider);

      // Crear la receta en Firebase
      final recipeId = await createRecipeUseCase.call(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        ingredients: _selectedIngredients,
        prepTime: int.parse(_prepTimeController.text.trim()),
        categoryId:
            _selectedCategory!, // Por ahora usamos el nombre, luego puedes usar IDs reales
        userId: 'default-user', // TODO: Obtener del usuario autenticado
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ ¡Receta creada exitosamente!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );

        // Limpiar formulario
        _titleController.clear();
        _descriptionController.clear();
        _prepTimeController.clear();

        setState(() {
          _selectedCategory = null;
          _selectedIngredients.clear();
        });

        // Regresar a la pantalla anterior después de 1 segundo
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
