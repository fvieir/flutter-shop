import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/exceptions/auth_exception.dart';
import 'package:shop/models/auth.dart';

enum AuthMode {
  login,
  signup,
}

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm>
    with SingleTickerProviderStateMixin {
  final _passawordController = TextEditingController();
  var _authMode = AuthMode.login;
  final Map<String, String> _authData = {'email': '', 'password': ''};
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  AnimationController? _controller;
  Animation<Size>? _heigthAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 300,
      ),
    );

    _heigthAnimation = Tween(
      begin: const Size(double.infinity, 310),
      end: const Size(double.infinity, 350),
    ).animate(
      CurvedAnimation(parent: _controller!, curve: Curves.linear),
    );

    // _heigthAnimation?.addListener(() {
    //   setState(() {});
    // });
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
  }

  bool _isLogin() {
    return _authMode == AuthMode.login;
  }

  bool _isSignup() {
    return _authMode == AuthMode.signup;
  }

  void _siwtchAuthMode() {
    if (_isLogin()) {
      setState(() => _authMode = AuthMode.signup);
      _controller?.forward();
    } else {
      setState(() => _authMode = AuthMode.login);
      _controller?.reverse();
    }
  }

  void _showErrorDialog(String msg) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text(
            'Ocorreu erro.',
            style: TextStyle(color: Colors.black87),
          ),
          content: Text(msg),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Fechar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _submit() async {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    setState(() => _isLoading = true);

    _formKey.currentState?.save();
    Auth auth = Provider.of(context, listen: false);

    try {
      if (_isLogin()) {
        await auth.login(
          _authData['email']!,
          _authData['password']!,
        );
      } else {
        await auth.sigunp(
          _authData['email']!,
          _authData['password']!,
        );
      }
    } on AuthException catch (error) {
      _showErrorDialog(error.toString());
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final double deviceSize = MediaQuery.of(context).size.width;
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: AnimatedBuilder(
        animation: _heigthAnimation!,
        builder: (BuildContext context, Widget? child) => Container(
          padding: const EdgeInsets.all(16),
          height: _heigthAnimation?.value.height ?? (_isLogin() ? 310 : 400),
          width: deviceSize * 0.75,
          child: child,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'E-mail'),
                keyboardType: TextInputType.emailAddress,
                onSaved: (email) => _authData['email'] = email ?? '',
                validator: (value) {
                  final email = value ?? '';

                  if (email.trim().isEmpty || !email.contains('@')) {
                    return 'Campo e-mail é inválido!';
                  }

                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Senha'),
                keyboardType: TextInputType.text,
                obscureText: true,
                controller: _passawordController,
                onSaved: (password) => _authData['password'] = password ?? '',
                validator: (value) {
                  final password = value ?? '';

                  if (password.isEmpty || password.length < 6) {
                    return 'Campo senha deve conter no mínimo 6 caracteres';
                  }

                  return null;
                },
              ),
              if (_isSignup())
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: 'Confirmar senha'),
                  obscureText: true,
                  validator: _authMode == AuthMode.login
                      ? null
                      : (value) {
                          final passwordConfirm = value ?? '';

                          if (passwordConfirm != _passawordController.text) {
                            return 'Senhas informadas não conferem.';
                          }

                          return null;
                        },
                ),
              const SizedBox(height: 20),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 8,
                          )),
                      child: Text(
                        _isLogin() ? 'ENTRAR' : 'REGISTRAR',
                      ),
                    ),
              const Spacer(),
              TextButton(
                onPressed: () => _siwtchAuthMode(),
                child:
                    Text(_isLogin() ? 'DESEJA REGISTRAR ?' : 'JA POSSUO LOGIN'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
