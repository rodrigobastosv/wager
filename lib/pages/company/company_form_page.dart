import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:wager/pages/layout/w_scaffold.dart';

class CompanyFormPage extends StatefulWidget {
  const CompanyFormPage({Key? key}) : super(key: key);

  static const routeName = 'companyForm';

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
    return WScaffold(
      title: 'Cadastro de Empresas',
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 400,
              child: TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Nome da Empresa',
                ),
                validator: (name) => name!.isEmpty ? 'Campo Obrigatório' : null,
                onSaved: (name) => _name = name,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                SizedBox(
                  width: 220,
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Ramo da Empresa',
                    ),
                    validator: (business) =>
                        business!.isEmpty ? 'Campo Obrigatório' : null,
                    onSaved: (business) => _business = business,
                  ),
                ),
                SizedBox(
                  width: 220,
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'No. de Funcionários',
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (numberOfEmployees) =>
                        numberOfEmployees!.isEmpty ? 'Campo Obrigatório' : null,
                    onSaved: (numberOfEmployees) =>
                        _numberOfEmployees = int.tryParse(numberOfEmployees!),
                  ),
                ),
                SizedBox(
                  width: 200,
                  child: SelectFormField(
                    decoration: const InputDecoration(
                      labelText: 'Porte da Empresa',
                    ),
                    type: SelectFormFieldType.dropdown,
                    initialValue: 'Até 4.8 mil',
                    items: const [
                      {
                        'value': 'Até 4.8 mil',
                        'label': 'Até 4.8 mil',
                      },
                      {
                        'value': 'De 4.8 mil até 20 mil',
                        'label': 'De 4.8 mil até 20 mil',
                      },
                      {
                        'value': 'Acima de 20 mil',
                        'label': 'Acima de 20 mil',
                      },
                    ],
                    validator: (invoicing) =>
                        invoicing!.isEmpty ? 'Campo Obrigatório' : null,
                    onSaved: (invoicing) => _invoicing = invoicing,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                SizedBox(
                  width: 220,
                  child: DateTimeField(
                    decoration: const InputDecoration(
                      labelText: 'Data Base',
                    ),
                    format: DateFormat("dd/MM/yyyy"),
                    validator: (baseDate) =>
                        baseDate == null ? 'Campo Obrigatório' : null,
                    onSaved: (baseDate) => _baseDate = baseDate.toString(),
                    onShowPicker: (_, currentValue) => showDatePicker(
                      context: context,
                      locale: const Locale('pt', 'BR'),
                      firstDate: DateTime(1900),
                      initialDate: currentValue ?? DateTime.now(),
                      lastDate: DateTime(2100),
                    ),
                  ),
                ),
                SizedBox(
                  width: 220,
                  child: DateTimeField(
                    decoration: const InputDecoration(
                      labelText: 'Data das Informações',
                    ),
                    format: DateFormat("dd/MM/yyyy"),
                    validator: (infoDate) =>
                        infoDate == null ? 'Campo Obrigatório' : null,
                    onSaved: (infoDate) => _infoDate = infoDate.toString(),
                    onShowPicker: (_, currentValue) => showDatePicker(
                      context: context,
                      locale: const Locale('pt', 'BR'),
                      firstDate: DateTime(1900),
                      initialDate: currentValue ?? DateTime.now(),
                      lastDate: DateTime(2100),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                SizedBox(
                  width: 220,
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Contato',
                    ),
                    validator: (contact) =>
                        contact!.isEmpty ? 'Campo Obrigatório' : null,
                    onSaved: (contact) => _contact = contact,
                  ),
                ),
                SizedBox(
                  width: 180,
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Telefone',
                    ),
                    inputFormatters: [
                      MaskTextInputFormatter(
                        mask: '(##) # ########',
                        filter: {"#": RegExp(r'[0-9]')},
                        type: MaskAutoCompletionType.lazy,
                      ),
                    ],
                    validator: (phone) =>
                        phone!.isEmpty ? 'Campo Obrigatório' : null,
                    onSaved: (phone) => _phone = phone,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final form = _formKey.currentState!;
                    if (form.validate()) {
                      form.save();
                      await FirebaseFirestore.instance
                          .collection('company')
                          .add(
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
