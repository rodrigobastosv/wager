import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CompanyFormPage extends StatefulWidget {
  const CompanyFormPage({Key? key}) : super(key: key);

  @override
  State<CompanyFormPage> createState() => _CompanyFormPageState();
}

class _CompanyFormPageState extends State<CompanyFormPage> {
  late final GlobalKey<FormState> _formKey;

  String? _name;
  String? _contact;
  String? _business;
  String? _phone;
  String? _baseDate;
  String? _infoDate;
  String? _invoicing;
  int? _numberOfEmployees;

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
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Nome da Empresa',
              ),
              validator: (name) => name!.isEmpty ? 'Campo Obrigatório' : null,
              onSaved: (name) => _name = name,
            ),
            TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Contato',
              ),
              validator: (contact) =>
                  contact!.isEmpty ? 'Campo Obrigatório' : null,
              onSaved: (contact) => _contact = contact,
            ),
            TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Telefone',
              ),
              validator: (phone) => phone!.isEmpty ? 'Campo Obrigatório' : null,
              onSaved: (phone) => _phone = phone,
            ),
            TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Ramo da Empresa',
              ),
              validator: (business) =>
                  business!.isEmpty ? 'Campo Obrigatório' : null,
              onSaved: (business) => _business = business,
            ),
            TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Data Base',
              ),
              validator: (baseDate) =>
                  baseDate!.isEmpty ? 'Campo Obrigatório' : null,
              onSaved: (baseDate) => _baseDate = baseDate,
            ),
            TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Data das Informações',
              ),
              validator: (infoDate) =>
                  infoDate!.isEmpty ? 'Campo Obrigatório' : null,
              onSaved: (infoDate) => _infoDate = infoDate,
            ),
            TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Porte da Empresa',
              ),
              validator: (invoicing) =>
                  invoicing!.isEmpty ? 'Campo Obrigatório' : null,
              onSaved: (invoicing) => _invoicing = invoicing,
            ),
            TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Número de Funcionários',
              ),
              validator: (numberOfEmployees) =>
                  numberOfEmployees!.isEmpty ? 'Campo Obrigatório' : null,
              onSaved: (numberOfEmployees) =>
                  _numberOfEmployees = int.tryParse(numberOfEmployees!),
            ),
            ElevatedButton(
              onPressed: () async {
                final form = _formKey.currentState!;
                if (form.validate()) {
                  form.save();
                  await FirebaseFirestore.instance.collection('company').add(
                    {
                      'name': _name,
                      'contact': _contact,
                      'business': _business,
                      'phone': _phone,
                      'baseDate': _baseDate,
                      'infoDate': _infoDate,
                      'invoicing': _invoicing,
                      'numberOfEmployees': _numberOfEmployees,
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
