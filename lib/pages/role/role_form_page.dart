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
      title: 'Cadastro de Cargos',
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 300,
              child: TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Nome do Cargo',
                ),
                validator: (name) => name!.isEmpty ? 'Campo Obrigatório' : null,
                onSaved: (name) => _name = name,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: 400,
              child: TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Descrição',
                ),
                minLines: 3,
                maxLines: 3,
                validator: (description) =>
                    description!.isEmpty ? 'Campo Obrigatório' : null,
                onSaved: (description) => _description = description,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
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
                ),
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Voltar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
