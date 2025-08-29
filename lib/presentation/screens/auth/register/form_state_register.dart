import 'package:flutter/material.dart';
import 'package:flutter_tastyhub/presentation/screens/auth/login/login_screen.dart';
import 'package:flutter_tastyhub/presentation/screens/core/home/principal_screen.dart';
import 'package:flutter_tastyhub/presentation/shared/custom_button.dart';
import 'package:flutter_tastyhub/presentation/shared/form/custom_input_form_field.dart';

class FormStateRegister extends StatefulWidget {
  const FormStateRegister({super.key});

  @override
  State<FormStateRegister> createState() => _FormStateRegisterState();
}

class _FormStateRegisterState extends State<FormStateRegister> {
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
            labelStyle: TextStyle(
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
            labelStyle: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          CustomInputFormField(
            labelText: 'Contraseña',
            labelStyle: TextStyle(
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
              Text(
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
                child: Text(
                  'Inicia sesión',
                  style: TextStyle(
                    color: const Color.fromARGB(255, 150, 69, 69),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          CustomButton(
            text: 'Registrarse',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PrincipalScreen()),
              );
            },
            size: ButtonSize.small,
          ),
        ],
      ),
    );
  }
}