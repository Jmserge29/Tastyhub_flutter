import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_tastyhub/presentation/widgets/form/custom_input_form_field.dart';

/// Widget de búsqueda de recetas con debounce
class InputSearchRecipes extends StatefulWidget {
  /// Callback que se ejecuta después del debounce con el texto de búsqueda
  final ValueChanged<String> onSearch;

  /// Tiempo de espera del debounce en milisegundos
  final int debounceMilliseconds;

  /// Texto del hint
  final String hintText;

  const InputSearchRecipes({
    super.key,
    required this.onSearch,
    this.debounceMilliseconds = 800,
    this.hintText = 'Buscar recetas...',
  });

  @override
  State<InputSearchRecipes> createState() => _InputSearchRecipesState();
}

class _InputSearchRecipesState extends State<InputSearchRecipes> {
  Timer? _debounceTimer;
  final TextEditingController _controller = TextEditingController();
  bool _isSearching = false;

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onTextChanged(String value) {
    // Cancelar el timer anterior
    _debounceTimer?.cancel();

    // Actualizar estado visual
    setState(() {
      _isSearching = value.isNotEmpty;
    });

    // Si está vacío, notificar inmediatamente
    if (value.isEmpty) {
      widget.onSearch('');
      return;
    }

    // Crear nuevo timer con el delay configurado
    _debounceTimer = Timer(
      Duration(milliseconds: widget.debounceMilliseconds),
      () {
        // Ejecutar callback después del debounce
        widget.onSearch(value.trim());
      },
    );
  }

  void _clearSearch() {
    _controller.clear();
    setState(() {
      _isSearching = false;
    });
    widget.onSearch('');
  }

  @override
  Widget build(BuildContext context) {
    return CustomInputFormField(
      controller: _controller,
      hintText: widget.hintText,
      borderColor: Colors.transparent,
      prefixIcon: const Icon(Icons.search),
      suffixIcon: _isSearching
          ? IconButton(icon: const Icon(Icons.clear), onPressed: _clearSearch)
          : null,
      onChanged: _onTextChanged,
    );
  }
}
