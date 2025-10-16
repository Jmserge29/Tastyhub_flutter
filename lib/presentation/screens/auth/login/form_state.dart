import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tastyhub/config/providers/providers.dart';
import 'package:flutter_tastyhub/presentation/screens/auth/register/register_screen.dart';
import 'package:flutter_tastyhub/presentation/screens/core/home/principal_screen.dart';
import 'package:flutter_tastyhub/presentation/widgets/custom_button.dart';
import 'package:flutter_tastyhub/presentation/widgets/form/custom_input_form_field.dart';

class FormStateLogin extends ConsumerStatefulWidget {
  const FormStateLogin({super.key});

  @override
  ConsumerState<FormStateLogin> createState() => _FormStateLoginState();
}

class _FormStateLoginState extends ConsumerState<FormStateLogin> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
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

    ref.listen(authNotifierProvider, (previous, next) {
      if (next.status == AuthStatus.authenticated) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => PrincipalScreen()),
        );
      } else if (next.status == AuthStatus.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage ?? 'Error al iniciar sesión'),
            backgroundColor: Colors.red,
          ),
        );
      }
    });

    return SafeArea(
      child: SingleChildScrollView(
        // Esto permite que el formulario se desplace cuando el teclado aparece
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
                    '¿Aún no estás registrado?',
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
                          builder: (context) => const RegisterScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'Regístrate',
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
              authState.status == AuthStatus.loading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : CustomButton(
                      text: 'Iniciar sesión',
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          ref
                              .read(authNotifierProvider.notifier)
                              .login(
                                _emailController.text.trim(),
                                _passwordController.text,
                              );
                        }
                      },
                      size: ButtonSize.small,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
