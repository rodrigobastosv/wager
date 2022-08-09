import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:select_form_field/select_form_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  int _currentStep = 0;

  // Dados da Empresa
  String? _nome;
  String? _contato;
  String? _ramo;
  String? _telefone;
  String? _dataBase;
  String? _dataDosDados;
  String? _porte;
  int? _numeroDeFuncionarios;
  Map<String, dynamic>? _informacoesDaEmpresa;

  /// Beneficios
  // Assistencia Medica
  int? _assistenciaMedicaEmpresa;
  int? _assistenciaMedicaFuncionario;
  int? _servicoAmbulatorialEmpresa;
  int? _servicoAmbulatorialFuncionario;
  // Assistencia Odontologica
  int? _assistenciaOdontologicaEmpresa;
  int? _assistenciaOdontologicaFuncionario;
  int? _servicoAmbulatorialProprioEmpresa;
  int? _servicoAmbulatorialProprioFuncionario;
  // Alimentacao
  int? _restauranteEmpresa;
  int? _restauranteFuncionario;
  int? _valeRefeicaoEmpresa;
  int? _valeRefeicaoFuncionario;
  int? _cestaBasicaEmpresa;
  int? _cestaBasicaFuncionario;
  int? _valeAlimentacaoEmpresa;
  int? _valeAlimentacaoFuncionario;
  // Transporte
  int? _valeTransporte;
  int? _frotaPropria;
  int? _frotaTerceirizada;
  // Seguro de Vida
  int? _seguroDeVidaEmGrupoEmpresa;
  int? _seguroDeVidaEmGrupoFuncionario;
  int? _seguroAcidentesDeTrabalhoEmpresa;
  int? _seguroAcidentesDeTrabalhoFuncionario;
  Map<String, dynamic>? _informacoesBeneficios;

  late final GlobalKey<FormState> _companyInfoFormKey;
  late final GlobalKey<FormState> _benefitsFormKey;

  @override
  void initState() {
    _companyInfoFormKey = GlobalKey<FormState>();
    _benefitsFormKey = GlobalKey<FormState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Cadastro'),
        centerTitle: true,
      ),
      body: Stepper(
        type: StepperType.horizontal,
        physics: const ScrollPhysics(),
        currentStep: _currentStep,
        onStepTapped: (step) => tapped(step),
        onStepContinue: () {
          if (_currentStep == 0) {
            /*final form = _companyInfoFormKey.currentState!;
            if (form.validate()) {
              form.save();
              _companyInfo = {
                  'name': _name,
                  'contact': _contact,
                  'business': _business,
                  'phone': _phone,
                  'baseDate': _baseDate,
                  'infoDate': _infoDate,
                  'invoicing': _invoicing,
                  'numberOfEmployees': _numberOfEmployees,
                };

              setState(() {
                _currentStep++;
              });
            }*/
            setState(() {
              _currentStep++;
            });
          } else if (_currentStep == 1) {
            final form = _companyInfoFormKey.currentState!;
            if (form.validate()) {
              form.save();
              _informacoesBeneficios = {
                'assistenciaMedica': {
                  'assistenciaMedica': {
                    'empresa': _assistenciaMedicaEmpresa,
                    'funcionario': _assistenciaMedicaFuncionario,
                  },
                  'servicoAmbulatorial': {
                    'empresa': _servicoAmbulatorialEmpresa,
                    'funcionario': _servicoAmbulatorialFuncionario,
                  },
                },
                'assistenciaOdontologica': {
                  'assistenciaOdontologica': {
                    'empresa': _assistenciaOdontologicaEmpresa,
                    'funcionario': _assistenciaOdontologicaFuncionario,
                  },
                  'servicoAmbulatorialProprio': {
                    'empresa': _servicoAmbulatorialProprioEmpresa,
                    'funcionario': _servicoAmbulatorialProprioFuncionario,
                  },
                },
                'alimentacao': {
                  'restaurante': {
                    'empresa': _restauranteEmpresa,
                    'funcionario': _restauranteFuncionario,
                  },
                  'valeRefeicao': {
                    'empresa': _valeRefeicaoEmpresa,
                    'funcionario': _valeRefeicaoFuncionario,
                  },
                  'cestaBasica': {
                    'empresa': _cestaBasicaEmpresa,
                    'funcionario': _cestaBasicaFuncionario,
                  },
                  'valeAlimentacao': {
                    'empresa': _valeAlimentacaoEmpresa,
                    'funcionario': _valeAlimentacaoFuncionario,
                  },
                },
                'transporte': {
                  'valeTransporte': _valeTransporte,
                  'frotaPropria': _frotaPropria,
                  'frotaTerceirizada': _frotaTerceirizada,
                },
                'seguroDeVida': {
                  'seguroDeVidaEmGrupo': {
                    'empresa': _seguroDeVidaEmGrupoEmpresa,
                    'funcionario': _seguroDeVidaEmGrupoFuncionario,
                  },
                  'seguroAcidentesDeTrabalho': {
                    'empresa': _seguroAcidentesDeTrabalhoEmpresa,
                    'funcionario': _seguroAcidentesDeTrabalhoFuncionario,
                  },
                }
              };

              setState(() {
                _currentStep++;
              });
            }
          } else {
            // Save Firebase
          }
        },
        onStepCancel: cancel,
        steps: <Step>[
          Step(
            title: const Text('Informações da Empresa'),
            content: Form(
              key: _companyInfoFormKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Nome da Empresa',
                    ),
                    validator: (name) =>
                        name!.isEmpty ? 'Campo Obrigatório' : null,
                    onSaved: (name) => _nome = name,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Contato',
                    ),
                    validator: (contact) =>
                        contact!.isEmpty ? 'Campo Obrigatório' : null,
                    onSaved: (contact) => _contato = contact,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Telefone',
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
                    onSaved: (phone) => _telefone = phone,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Ramo da Empresa',
                    ),
                    validator: (business) =>
                        business!.isEmpty ? 'Campo Obrigatório' : null,
                    onSaved: (business) => _ramo = business,
                  ),
                  DateTimeField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Data Base',
                    ),
                    format: DateFormat("dd/MM/yyyy"),
                    validator: (baseDate) =>
                        baseDate == null ? 'Campo Obrigatório' : null,
                    onSaved: (baseDate) => _dataBase = baseDate.toString(),
                    onShowPicker: (_, currentValue) => showDatePicker(
                      context: context,
                      locale: const Locale('pt', 'BR'),
                      firstDate: DateTime(1900),
                      initialDate: currentValue ?? DateTime.now(),
                      lastDate: DateTime(2100),
                    ),
                  ),
                  DateTimeField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Data das Informações',
                    ),
                    format: DateFormat("dd/MM/yyyy"),
                    validator: (infoDate) =>
                        infoDate == null ? 'Campo Obrigatório' : null,
                    onSaved: (infoDate) => _dataDosDados = infoDate.toString(),
                    onShowPicker: (_, currentValue) => showDatePicker(
                      context: context,
                      locale: const Locale('pt', 'BR'),
                      firstDate: DateTime(1900),
                      initialDate: currentValue ?? DateTime.now(),
                      lastDate: DateTime(2100),
                    ),
                  ),
                  SelectFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    type: SelectFormFieldType.dropdown,
                    initialValue: 'Até 4.8 mil',
                    labelText: 'Porte da Empresa',
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
                    onSaved: (invoicing) => _porte = invoicing,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Número de Funcionários',
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    validator: (numberOfEmployees) =>
                        numberOfEmployees!.isEmpty ? 'Campo Obrigatório' : null,
                    onSaved: (numberOfEmployees) => _numeroDeFuncionarios =
                        int.tryParse(numberOfEmployees!),
                  ),
                ],
              ),
            ),
            isActive: _currentStep >= 0,
            state: _currentStep >= 0 ? StepState.complete : StepState.disabled,
          ),
          Step(
            title: const Text('Benefícios'),
            content: Form(
              key: _benefitsFormKey,
              child: Column(
                children: [
                  ExpansionTile(
                    title: const Text('Assistência Médica'),
                    children: [
                      Row(
                        children: [
                          const Text('Assistência Médica:'),
                          Expanded(
                            child: TextFormField(
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Empresa',
                              ),
                              onSaved: (name) => _assistenciaMedicaEmpresa =
                                  int.tryParse(name!),
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Funcionário',
                              ),
                              onSaved: (name) => _assistenciaMedicaFuncionario =
                                  int.tryParse(name!),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Text('Serviço Ambulatorial:'),
                          Expanded(
                            child: TextFormField(
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Empresa',
                              ),
                              onSaved: (name) => _servicoAmbulatorialEmpresa =
                                  int.tryParse(name!),
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Funcionário',
                              ),
                              onSaved: (name) =>
                                  _servicoAmbulatorialFuncionario =
                                      int.tryParse(name!),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  ExpansionTile(
                    title: const Text('Assistência Odontológica'),
                    children: [
                      Row(
                        children: [
                          const Text('Assistência Odontológica:'),
                          Expanded(
                            child: TextFormField(
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Empresa',
                              ),
                              onSaved: (name) =>
                                  _assistenciaOdontologicaEmpresa =
                                      int.tryParse(name!),
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Funcionário',
                              ),
                              onSaved: (name) =>
                                  _assistenciaOdontologicaFuncionario =
                                      int.tryParse(name!),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Text('Serviço Ambulatorial Próprio:'),
                          Expanded(
                            child: TextFormField(
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Empresa',
                              ),
                              onSaved: (name) =>
                                  _servicoAmbulatorialProprioEmpresa =
                                      int.tryParse(name!),
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Funcionário',
                              ),
                              onSaved: (name) =>
                                  _servicoAmbulatorialProprioFuncionario =
                                      int.tryParse(name!),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  ExpansionTile(
                    title: const Text('Alimentação'),
                    children: [
                      Row(
                        children: [
                          const Text('Restaurante:'),
                          Expanded(
                            child: TextFormField(
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Empresa',
                              ),
                              onSaved: (name) =>
                                  _restauranteEmpresa = int.tryParse(name!),
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Funcionário',
                              ),
                              onSaved: (name) =>
                                  _restauranteFuncionario = int.tryParse(name!),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Text('Vale Refeição:'),
                          Expanded(
                            child: TextFormField(
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Empresa',
                              ),
                              onSaved: (name) =>
                                  _valeRefeicaoEmpresa = int.tryParse(name!),
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Funcionário',
                              ),
                              onSaved: (name) => _valeRefeicaoFuncionario =
                                  int.tryParse(name!),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Text('Cesta Básica:'),
                          Expanded(
                            child: TextFormField(
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Empresa',
                              ),
                              onSaved: (name) =>
                                  _cestaBasicaEmpresa = int.tryParse(name!),
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Funcionário',
                              ),
                              onSaved: (name) =>
                                  _cestaBasicaFuncionario = int.tryParse(name!),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Text('Vale Alimentação:'),
                          Expanded(
                            child: TextFormField(
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Empresa',
                              ),
                              onSaved: (name) =>
                                  _valeAlimentacaoEmpresa = int.tryParse(name!),
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Funcionário',
                              ),
                              onSaved: (name) => _valeAlimentacaoFuncionario =
                                  int.tryParse(name!),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  ExpansionTile(
                    title: const Text('Transporte'),
                    children: [
                      Row(
                        children: [
                          const Text('Vale Transporte:'),
                          Expanded(
                            child: TextFormField(
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Funcionário',
                              ),
                              onSaved: (name) =>
                                  _valeTransporte = int.tryParse(name!),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Text('Frota Própria:'),
                          Expanded(
                            child: TextFormField(
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Funcionário',
                              ),
                              onSaved: (name) =>
                                  _frotaPropria = int.tryParse(name!),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Text('Frota Terceirizada:'),
                          Expanded(
                            child: TextFormField(
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Funcionário',
                              ),
                              onSaved: (name) =>
                                  _frotaTerceirizada = int.tryParse(name!),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  ExpansionTile(
                    title: const Text('Seguro de Vida'),
                    children: [
                      Row(
                        children: [
                          const Text('Seguro de Vida em Grupo:'),
                          Expanded(
                            child: TextFormField(
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Empresa',
                              ),
                              onSaved: (name) => _seguroDeVidaEmGrupoEmpresa =
                                  int.tryParse(name!),
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Funcionário',
                              ),
                              onSaved: (name) =>
                                  _seguroDeVidaEmGrupoFuncionario =
                                      int.tryParse(name!),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Text('Seguro Acidentes de Trabalho:'),
                          Expanded(
                            child: TextFormField(
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Empresa',
                              ),
                              onSaved: (name) =>
                                  _seguroAcidentesDeTrabalhoEmpresa =
                                      int.tryParse(name!),
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Funcionário',
                              ),
                              onSaved: (name) =>
                                  _seguroAcidentesDeTrabalhoEmpresa =
                                      int.tryParse(name!),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            isActive: _currentStep >= 0,
            state: _currentStep >= 1 ? StepState.complete : StepState.disabled,
          ),
          Step(
            title: const Text('Cargos'),
            content: Column(
              children: <Widget>[
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Mobile Number'),
                ),
              ],
            ),
            isActive: _currentStep >= 0,
            state: _currentStep >= 2 ? StepState.complete : StepState.disabled,
          ),
        ],
      ),
    );
  }

  tapped(int step) {
    setState(() => _currentStep = step);
  }

  continued() {
    _currentStep < 2 ? setState(() => _currentStep += 1) : null;
  }

  cancel() {
    _currentStep > 0 ? setState(() => _currentStep -= 1) : null;
  }
}
