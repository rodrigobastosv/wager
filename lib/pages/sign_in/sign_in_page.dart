import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wager/pages/pages.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({
    super.key,
  });

  static const routeName = '/signIn';

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool _isLoading = false;
  String? _email;
  String? _errorMessage;

  late final GlobalKey<FormState> _formKey;

  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 48),
            width: 400,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  './assets/images/logo.png',
                  width: 200,
                  filterQuality: FilterQuality.high,
                ),
                const SizedBox(height: 24),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'E-mail',
                  ),
                  validator: (email) =>
                      email!.isEmpty ? 'Campo Obrigatório' : null,
                  onSaved: (email) => _email = email,
                ),
                const SizedBox(height: 18),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Senha',
                  ),
                  obscureText: true,
                  validator: (password) =>
                      password!.isEmpty ? 'Campo Obrigatório' : null,
                  onSaved: (password) async {
                    try {
                      setState(() {
                        _isLoading = true;
                      });

                      final userCredential = await FirebaseAuth.instance
                          .signInWithEmailAndPassword(
                        email: _email!,
                        password: password!,
                      );

                      if (userCredential.user != null) {
                        if (!mounted) return;
                        Navigator.pushNamed(context, HomePage.routeName);
                      }
                    } on FirebaseAuthException catch (e) {
                      setState(() {
                        _errorMessage = e.message;
                      });
                    } finally {
                      setState(() {
                        _isLoading = false;
                      });
                    }
                  },
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: 160,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () {
                      final form = _formKey.currentState!;
                      if (form.validate()) {
                        form.save();
                      }
                    },
                    child: _isLoading
                        ? const SizedBox(
                            width: 40,
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text('Entrar'),
                  ),
                ),
                const SizedBox(height: 18),
                if (_errorMessage != null)
                  Text(
                    _errorMessage!,
                    style: const TextStyle(
                      color: Colors.red,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
