import 'package:flutter/material.dart';
import 'package:flutter_tastyhub/presentation/shared/custom_button.dart';
import 'package:flutter_tastyhub/presentation/shared/form/custom_dropdown_form_field.dart';
import 'package:flutter_tastyhub/presentation/shared/form/custom_input_form_field.dart';

class CreateRecipeScreen extends StatefulWidget {
  const CreateRecipeScreen({Key? key}) : super(key: key);

  @override
  State<CreateRecipeScreen> createState() => _CreateRecipeScreenState();
}

class _CreateRecipeScreenState extends State<CreateRecipeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _timeController = TextEditingController();

  String? _selectedCategory;
  List<String> _selectedIngredients = [];

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
    _nameController.dispose();
    _descriptionController.dispose();
    _timeController.dispose();
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
                        CustomInputFormField(
                          labelText: 'Nombre',
                          hintText: 'Costillas de cerdo ahumada...',
                          borderColor: Colors.transparent,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingresa el nombre de la receta';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            // Lógica de búsqueda
                          },
                        ),
                        const SizedBox(height: 10),
                        CustomInputFormField(
                          labelText: 'Descripción',
                          keyboardType: TextInputType.multiline,
                          maxLines: 3,
                          hintText: 'Costillas de cerdo ahumada...',
                          borderColor: Colors.transparent,
                          onChanged: (value) {
                            // Lógica de búsqueda
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingresa una descripción';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
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
                        CustomInputFormField(
                          labelText: 'Tiempo',
                          hintText: '30 minutos',
                          borderColor: Colors.transparent,
                          prefixIcon: const Icon(Icons.timelapse),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingresa el tiempo de preparación';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            // Lógica de búsqueda
                          },
                        ),
                        const SizedBox(height: 10),
                        CustomDropdownField(
                          hintText: 'Seleccione los ingredientes',
                          labelText: 'Ingredientes',
                          items: _availableIngredients,
                          validator: (value) {
                            if (value == null) {
                              return 'Campo requerido';
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
                        const SizedBox(height: 10),
                        Center(
                          child: CustomButton(
                            text: 'Crear receta',
                            onPressed: _createRecipe,
                            backgroundColor: Color.fromRGBO(82, 34, 34, 1),
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

  void _createRecipe() {
    if (_formKey.currentState!.validate()) {
      if (_selectedIngredients.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Por favor selecciona al menos un ingrediente'),
          ),
        );
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Receta creada exitosamente')),
      );

      // Limpiar formulario
      _nameController.clear();
      _descriptionController.clear();
      _timeController.clear();
      setState(() {
        _selectedCategory = null;
        _selectedIngredients.clear();
      });
      // Opcional: regresar a la pantalla anterior
      // Navigator.pop(context);
    }
  }
}
