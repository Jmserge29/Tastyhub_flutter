import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tastyhub/config/providers/providers.dart';
import 'package:flutter_tastyhub/presentation/screens/auth/login/login_screen.dart';
import 'package:flutter_tastyhub/presentation/screens/core/home/principal_screen.dart';
import 'package:flutter_tastyhub/presentation/widgets/custom_button.dart';
import 'package:flutter_tastyhub/presentation/widgets/form/custom_input_form_field.dart';

class FormStateRegister extends ConsumerStatefulWidget {
  const FormStateRegister({super.key});

  @override
  ConsumerState<FormStateRegister> createState() => _FormStateRegisterState();
}

class _FormStateRegisterState extends ConsumerState<FormStateRegister> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingresa tu nombre';
    }
    if (value.length < 2) {
      return 'El nombre debe tener al menos 2 caracteres';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingresa tu email';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Por favor ingresa un email válido';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingresa tu contraseña';
    }
    if (value.length < 6) {
      return 'La contraseña debe tener al menos 6 caracteres';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    // Escuchar cambios en el estado de autenticación
    ref.listen(authNotifierProvider, (previous, next) {
      if (next.status == AuthStatus.authenticated) {
        // Navegar al home cuando se registra exitosamente
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => PrincipalScreen()),
        );
      } else if (next.status == AuthStatus.error) {
        // Mostrar error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage ?? 'Error al registrarse'),
            backgroundColor: Colors.red,
          ),
        );
      }
    });

    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomInputFormField(
            labelText: 'Nombre',
            hintText: 'Jhon Doe',
            controller: _nameController,
            keyboardType: TextInputType.name,
            prefixIcon: const Icon(Icons.person_outlined),
            validator: _validateName,
            textInputAction: TextInputAction.next,
            labelStyle: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          CustomInputFormField(
            labelText: 'Email',
            hintText: 'JhonDoe@gmail.com',
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            prefixIcon: const Icon(Icons.email_outlined),
            validator: _validateEmail,
            textInputAction: TextInputAction.next,
            labelStyle: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          CustomInputFormField(
            labelText: 'Contraseña',
            labelStyle: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            hintText: '••••••••',
            controller: _passwordController,
            obscureText: true,
            prefixIcon: const Icon(Icons.lock_outlined),
            validator: _validatePassword,
            textInputAction: TextInputAction.done,
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Text(
                '¿Ya tienes una cuenta?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },
                child: const Text(
                  'Inicia sesión',
                  style: TextStyle(
                    color: Color.fromARGB(255, 150, 69, 69),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Botón con estado de carga
          authState.status == AuthStatus.loading
              ? const CircularProgressIndicator(color: Colors.white)
              : CustomButton(
                  text: 'Registrarse',
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Llamar al registro desde Riverpod
                      ref
                          .read(authNotifierProvider.notifier)
                          .register(
                            _emailController.text.trim(),
                            _passwordController.text,
                            _nameController.text.trim(),
                          );
                    }
                  },
                  size: ButtonSize.small,
                ),
        ],
      ),
    );
  }
}
