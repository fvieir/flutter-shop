import 'package:flutter/material.dart';

enum AuthMode {
  login,
  signup,
}

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _emailController = TextEditingController();
  final _passawordController = TextEditingController();
  final _authMode = AuthMode.login;

  void _submit() {}

  @override
  Widget build(BuildContext context) {
    final double sizeWidth = MediaQuery.of(context).size.width;
    return Card(
      child: Container(
        height: 250,
        width: sizeWidth * 0.75,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'E-mail',
                  ),
                  controller: _emailController,
                  validator: (value) {
                    final email = value ?? '';

                    if (email.trim().isEmpty || !email.contains('@')) {
                      return 'Campo e-mail é inválido!';
                    }

                    return null;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Senha',
                  ),
                  obscureText: true,
                  controller: _passawordController,
                  validator: (value) {
                    final password = value ?? '';

                    if (password.isEmpty || password.length > 5) {
                      return 'Campo senha deve conter no mínimo 5 caracteres';
                    }

                    return null;
                  },
                ),
                if (_authMode == AuthMode.signup)
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Confirmar senha',
                    ),
                    validator: (value) {
                      final passwordConfirm = value ?? '';

                      if (passwordConfirm != _passawordController.text) {
                        return 'Senhas não conferem';
                      }

                      return null;
                    },
                  ),
                const SizedBox(height: 20),
                ElevatedButton(onPressed: _submit, child: const Text('ENTRAR')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
