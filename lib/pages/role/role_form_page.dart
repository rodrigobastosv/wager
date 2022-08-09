import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wager/pages/layout/w_scaffold.dart';

class RoleFormPage extends StatefulWidget {
  const RoleFormPage({Key? key}) : super(key: key);

  static const routeName = 'roleForm';

  @override
  State<RoleFormPage> createState() => _RoleFormPageState();
}

class _RoleFormPageState extends State<RoleFormPage> {
  late final GlobalKey<FormState> _formKey;

  String? _name;
  String? _description;

  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WScaffold(
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Nome do Cargo',
              ),
              validator: (name) => name!.isEmpty ? 'Campo Obrigatório' : null,
              onSaved: (name) => _name = name,
            ),
            TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Descrição',
              ),
              validator: (description) =>
                  description!.isEmpty ? 'Campo Obrigatório' : null,
              onSaved: (description) => _description = description,
            ),
            ElevatedButton(
              onPressed: () async {
                final form = _formKey.currentState!;
                if (form.validate()) {
                  form.save();
                  await FirebaseFirestore.instance.collection('role').add(
                    {
                      'name': _name,
                      'description': _description,
                    },
                  );

                  if (!mounted) return;
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Salvar'),
            )
          ],
        ),
      ),
    );
  }
}
