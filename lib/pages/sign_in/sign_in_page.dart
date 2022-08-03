import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({
    super.key,
  });

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  String? _email;

  late final GlobalKey<FormState> _formKey;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'E-mail',
              ),
              validator: (email) => email!.isEmpty ? 'Campo Obrigatório' : null,
              onSaved: (email) => _email = email,
            ),
            const SizedBox(height: 18),
            TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Senha',
              ),
              validator: (password) =>
                  password!.isEmpty ? 'Campo Obrigatório' : null,
              onSaved: (password) async {
                final userCredential =
                    await FirebaseAuth.instance.signInWithEmailAndPassword(
                  email: _email!,
                  password: password!,
                );

                if (userCredential.user != null) {
                  if (!mounted) return;
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => Scaffold(),
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 28),
            ElevatedButton(
              onPressed: () {
                final form = _formKey.currentState!;
                if (form.validate()) {
                  form.save();
                }
              },
              child: const Text('Entrar'),
            ),
          ],
        ),
      ),
    );
  }
}
