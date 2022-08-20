import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:wager/pages/layout/w_scaffold.dart';

import 'register_utils.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  int _currentStep = 0;

  // Dados da Empresa
  List<String> ramosAtuacaoDisponiveis = [];
  String? _nome;
  String? _contato;
  String? _ramo;
  String? _outroRamo;
  String? _telefone;
  DateTime? _dataBase;
  String? _dataDosDados;
  String? _faturamentoAnual;
  int? _numeroDeFuncionarios;
  Map<String, dynamic>? _informacoesDaEmpresa;

  /// Beneficios
  // Assistencia Medica
  String? _assistenciaMedicaEmpresa;
  String? _assistenciaMedicaFuncionario;
  String? _servicoAmbulatorialEmpresa;
  String? _servicoAmbulatorialFuncionario;
  // Assistencia Odontologica
  String? _assistenciaOdontologicaEmpresa;
  String? _assistenciaOdontologicaFuncionario;
  String? _servicoAmbulatorialProprioEmpresa;
  String? _servicoAmbulatorialProprioFuncionario;
  // Alimentacao
  String? _restauranteEmpresa;
  String? _restauranteFuncionario;
  String? _valeRefeicaoEmpresa;
  String? _valeRefeicaoFuncionario;
  String? _cestaBasicaEmpresa;
  String? _cestaBasicaFuncionario;
  String? _valeAlimentacaoEmpresa;
  String? _valeAlimentacaoFuncionario;
  // Convenios
  bool academias = false;
  bool instituicoesDeEnsino = false;
  bool livrarias = false;
  bool lojasParceiras = false;
  String? outros;
  // Seguro de Vida
  String? _seguroDeVidaEmGrupoEmpresa;
  String? _seguroDeVidaEmGrupoFuncionario;
  String? _seguroAcidentesDeTrabalhoEmpresa;
  String? _seguroAcidentesDeTrabalhoFuncionario;
  Map<String, dynamic>? _informacoesBeneficios;

  /// Cargos
  List<String> cargosDisponiveis = [];
  bool estaEmAdicaoDeCargos = false;
  String? _cargo;
  String? _senioridade;
  String? _vinculo;
  int? _frequencia;
  int? _salario;
  int? _bonificacoes;
  String? _observacoes;
  final List<Map<String, dynamic>> _cargosDaEmpresa = [];

  late final GlobalKey<FormState> _companyInfoFormKey;
  late final GlobalKey<FormState> _benefitsFormKey;
  late final GlobalKey<FormState> _cargosFormKey;

  @override
  void initState() {
    _companyInfoFormKey = GlobalKey<FormState>();
    _benefitsFormKey = GlobalKey<FormState>();
    _cargosFormKey = GlobalKey<FormState>();

    FirebaseFirestore.instance
        .collection('ramos_atuacao')
        .orderBy('nome')
        .get()
        .then((querySnapshot) {
      setState(() {
        ramosAtuacaoDisponiveis = querySnapshot.docs
            .map((doc) => doc.data()['nome'] as String)
            .toList();
      });
    });

    FirebaseFirestore.instance
        .collection('cargos')
        .orderBy('nome')
        .get()
        .then((querySnapshot) {
      setState(() {
        cargosDisponiveis = querySnapshot.docs
            .map((doc) => doc.data()['nome'] as String)
            .toList();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WScaffold(
      title: 'Cadastro de Dados de Cargos',
      withMenu: false,
      body: Stepper(
        type: StepperType.horizontal,
        elevation: 0,
        physics: const ScrollPhysics(),
        currentStep: _currentStep,
        onStepTapped: (step) => tapped(step),
        controlsBuilder: (_, details) => Padding(
          padding: const EdgeInsets.only(top: 28),
          child: Row(
            children: <Widget>[
              TextButton(
                onPressed: details.onStepCancel,
                child: const Text('Voltar'),
              ),
              ElevatedButton(
                onPressed: details.onStepContinue,
                child:
                    Text(details.stepIndex == 2 ? 'Salvar Dados' : 'Continuar'),
              ),
            ],
          ),
        ),
        onStepContinue: () {
          if (_currentStep == 0) {
            final companyInfoForm = _companyInfoFormKey.currentState!;
            if (companyInfoForm.validate()) {
              companyInfoForm.save();
              _informacoesDaEmpresa = {
                'nome': _nome,
                'contato': _contato,
                'ramo': _ramo == 'Outro' ? _outroRamo : _ramo,
                'telefone': _telefone,
                'dataBase': '${_dataBase!.month}/${_dataBase!.year}',
                'dataDosDados': _dataDosDados,
                'faturamentoAnual': _faturamentoAnual,
                'numeroDeFuncionarios': _numeroDeFuncionarios,
              };
              companyInfoForm.reset();

              setState(() {
                _currentStep++;
              });
            }
          } else if (_currentStep == 1) {
            final benefitsForm = _benefitsFormKey.currentState!;
            if (benefitsForm.validate()) {
              benefitsForm.save();
              _informacoesBeneficios = {
                'assistenciaMedica': {
                  'assistenciaMedica': {
                    'empresa': _assistenciaMedicaEmpresa ?? '0%',
                    'funcionario': _assistenciaMedicaFuncionario ?? '0%',
                  },
                  'servicoAmbulatorial': {
                    'empresa': _servicoAmbulatorialEmpresa ?? '0%',
                    'funcionario': _servicoAmbulatorialFuncionario ?? '0%',
                  },
                },
                'assistenciaOdontologica': {
                  'assistenciaOdontologica': {
                    'empresa': _assistenciaOdontologicaEmpresa ?? '0%',
                    'funcionario': _assistenciaOdontologicaFuncionario ?? '0%',
                  },
                  'servicoAmbulatorialProprio': {
                    'empresa': _servicoAmbulatorialProprioEmpresa ?? '0%',
                    'funcionario':
                        _servicoAmbulatorialProprioFuncionario ?? '0%',
                  },
                },
                'alimentacao': {
                  'restaurante': {
                    'empresa': _restauranteEmpresa ?? '0%',
                    'funcionario': _restauranteFuncionario ?? '0%',
                  },
                  'valeRefeicao': {
                    'empresa': _valeRefeicaoEmpresa ?? '0%',
                    'funcionario': _valeRefeicaoFuncionario ?? '0%',
                  },
                  'cestaBasica': {
                    'empresa': _cestaBasicaEmpresa ?? '0%',
                    'funcionario': _cestaBasicaFuncionario ?? '0%',
                  },
                  'valeAlimentacao': {
                    'empresa': _valeAlimentacaoEmpresa ?? '0%',
                    'funcionario': _valeAlimentacaoFuncionario ?? '0%',
                  },
                },
                'convenios': {
                  'academias': academias ? 'SIM' : 'NÃO',
                  'instituicoesDeEnsino': instituicoesDeEnsino ? 'SIM' : 'NÃO',
                  'livrarias': livrarias ? 'SIM' : 'NÃO',
                  'lojasParceiras': lojasParceiras ? 'SIM' : 'NÃO',
                  'outros': outros ?? '',
                },
                'seguroDeVida': {
                  'seguroDeVidaEmGrupo': {
                    'empresa': _seguroDeVidaEmGrupoEmpresa ?? '0%',
                    'funcionario': _seguroDeVidaEmGrupoFuncionario ?? '0%',
                  },
                  'seguroAcidentesDeTrabalho': {
                    'empresa': _seguroAcidentesDeTrabalhoEmpresa ?? '0%',
                    'funcionario':
                        _seguroAcidentesDeTrabalhoFuncionario ?? '0%',
                  },
                }
              };
              benefitsForm.reset();

              setState(() {
                _currentStep++;
              });
            }
          } else {
            if (_cargosDaEmpresa.isEmpty) {
              PanaraInfoDialog.show(
                context,
                title: 'Atenção',
                message:
                    'Você deve cadastrar pelo menos um cargo para a sua empresa!',
                buttonText: 'OK',
                onTapDismiss: () => Navigator.of(context).pop(),
                panaraDialogType: PanaraDialogType.warning,
              );
            } else {
              FirebaseFirestore.instance.collection('empresas').doc(_nome).set({
                'empresa': _informacoesDaEmpresa,
                'beneficios': _informacoesBeneficios,
                'cargos': _cargosDaEmpresa,
              }).then(
                (_) => PanaraInfoDialog.show(
                  context,
                  title: 'Parabéns',
                  message: 'Os dados da sua empresa foram salvos com sucesso!',
                  buttonText: 'OK',
                  onTapDismiss: () => Navigator.of(context)
                      .pushNamedAndRemoveUntil('/register', (route) => false),
                  panaraDialogType: PanaraDialogType.success,
                ),
              );
            }
          }
        },
        onStepCancel: cancel,
        steps: <Step>[
          Step(
            title: const Text('Informações da Empresa'),
            content: Form(
              key: _companyInfoFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 400,
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Nome da Empresa',
                      ),
                      initialValue: _nome,
                      validator: (name) =>
                          name!.isEmpty ? 'Campo Obrigatório' : null,
                      onSaved: (name) => _nome = name,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      SizedBox(
                        width: 220,
                        child: SelectFormField(
                          decoration: const InputDecoration(
                            labelText: 'Ramo da Empresa',
                          ),
                          type: SelectFormFieldType.dropdown,
                          initialValue: _ramo,
                          items: _getRamosAtuacao(),
                          validator: (ramo) =>
                              ramo!.isEmpty ? 'Campo Obrigatório' : null,
                          onSaved: (ramo) => _ramo = ramo,
                          onChanged: (ramo) => setState(() {
                            _ramo = ramo;
                          }),
                        ),
                      ),
                      if (_ramo == 'Outro')
                        SizedBox(
                          width: 220,
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Nome do Ramo',
                            ),
                            initialValue: _outroRamo,
                            validator: (outroRamo) =>
                                outroRamo!.isEmpty ? 'Campo Obrigatório' : null,
                            onSaved: (outroRamo) => _outroRamo = outroRamo,
                          ),
                        ),
                      SizedBox(
                        width: 220,
                        child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'No. de Funcionários',
                          ),
                          initialValue: _numeroDeFuncionarios?.toString(),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          validator: (numberOfEmployees) =>
                              numberOfEmployees!.isEmpty
                                  ? 'Campo Obrigatório'
                                  : null,
                          onSaved: (numberOfEmployees) =>
                              _numeroDeFuncionarios =
                                  int.tryParse(numberOfEmployees!),
                        ),
                      ),
                      SizedBox(
                        width: 200,
                        child: SelectFormField(
                          decoration: const InputDecoration(
                            labelText: 'Faturamento Anual (R\$)',
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
                          validator: (faturamentoAnual) =>
                              faturamentoAnual!.isEmpty
                                  ? 'Campo Obrigatório'
                                  : null,
                          onSaved: (faturamentoAnual) =>
                              _faturamentoAnual = faturamentoAnual,
                          onChanged: (faturamentoAnual) => setState(() {
                            _faturamentoAnual = faturamentoAnual;
                          }),
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
                          initialValue: _dataBase,
                          format: DateFormat("MM/yyyy"),
                          validator: (baseDate) =>
                              baseDate == null ? 'Campo Obrigatório' : null,
                          onSaved: (baseDate) => _dataBase = baseDate,
                          onShowPicker: (_, currentValue) =>
                              showMonthYearPicker(
                            context: context,
                            locale: const Locale('pt', 'BR'),
                            initialDate: currentValue ?? DateTime.now(),
                            firstDate: DateTime(2022),
                            lastDate: DateTime(2099),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 220,
                        child: DateTimeField(
                          decoration: const InputDecoration(
                            labelText: 'Data das Informações',
                          ),
                          initialValue: _dataDosDados != null
                              ? DateTime.parse(_dataDosDados!)
                              : null,
                          format: DateFormat("dd/MM/yyyy"),
                          validator: (infoDate) =>
                              infoDate == null ? 'Campo Obrigatório' : null,
                          onSaved: (infoDate) =>
                              _dataDosDados = infoDate.toString(),
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
                          initialValue: _contato,
                          validator: (contact) =>
                              contact!.isEmpty ? 'Campo Obrigatório' : null,
                          onSaved: (contact) => _contato = contact,
                        ),
                      ),
                      SizedBox(
                        width: 180,
                        child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Telefone',
                          ),
                          initialValue: _telefone,
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
                      ),
                    ],
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ExpansionTile(
                    title: const Text('Assistência Médica (Participação %)'),
                    expandedCrossAxisAlignment: CrossAxisAlignment.start,
                    expandedAlignment: Alignment.topLeft,
                    childrenPadding: const EdgeInsets.only(
                      left: 16,
                      bottom: 32,
                    ),
                    children: [
                      const Text('Assistência Médica:'),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        children: [
                          SizedBox(
                            width: 300,
                            child: SelectFormField(
                                key: UniqueKey(),
                                decoration: const InputDecoration(
                                  labelText: 'Empresa',
                                ),
                                type: SelectFormFieldType.dropdown,
                                items: getValoresBonificacoes(),
                                initialValue: _assistenciaMedicaEmpresa,
                                onChanged: (assistenciaMedicaEmpresa) {
                                  var assistenciaMedicaFuncionario = '';
                                  if (assistenciaMedicaEmpresa == '100%') {
                                    assistenciaMedicaFuncionario = '0%';
                                  } else if (assistenciaMedicaEmpresa ==
                                      '75%') {
                                    assistenciaMedicaFuncionario = '25%';
                                  } else if (assistenciaMedicaEmpresa ==
                                      '50%') {
                                    assistenciaMedicaFuncionario = '50%';
                                  } else if (assistenciaMedicaEmpresa ==
                                      '25%') {
                                    assistenciaMedicaFuncionario = '75%';
                                  } else {
                                    assistenciaMedicaFuncionario = '100%';
                                  }
                                  setState(() {
                                    _assistenciaMedicaEmpresa =
                                        assistenciaMedicaEmpresa;
                                    _assistenciaMedicaFuncionario =
                                        assistenciaMedicaFuncionario;
                                  });
                                }),
                          ),
                          SizedBox(
                            width: 300,
                            child: SelectFormField(
                              key: UniqueKey(),
                              decoration: const InputDecoration(
                                labelText: 'Funcionário',
                              ),
                              type: SelectFormFieldType.dropdown,
                              items: getValoresBonificacoes(),
                              initialValue: _assistenciaMedicaFuncionario,
                              onChanged: (assistenciaMedicaFuncionario) {
                                var assistenciaMedicaEmpresa = '';
                                if (assistenciaMedicaFuncionario == '100%') {
                                  assistenciaMedicaEmpresa = '0%';
                                } else if (assistenciaMedicaFuncionario ==
                                    '75%') {
                                  assistenciaMedicaEmpresa = '25%';
                                } else if (assistenciaMedicaFuncionario ==
                                    '50%') {
                                  assistenciaMedicaEmpresa = '50%';
                                } else if (assistenciaMedicaFuncionario ==
                                    '25%') {
                                  assistenciaMedicaEmpresa = '75%';
                                } else {
                                  assistenciaMedicaEmpresa = '100%';
                                }
                                setState(() {
                                  _assistenciaMedicaFuncionario =
                                      assistenciaMedicaFuncionario;
                                  _assistenciaMedicaEmpresa =
                                      assistenciaMedicaEmpresa;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text('Serviço Ambulatorial:'),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        children: [
                          SizedBox(
                            width: 300,
                            child: SelectFormField(
                              key: UniqueKey(),
                              decoration: const InputDecoration(
                                labelText: 'Empresa',
                              ),
                              type: SelectFormFieldType.dropdown,
                              items: getValoresBonificacoes(),
                              initialValue: _servicoAmbulatorialEmpresa,
                              onChanged: (servicoAmbulatorialEmpresa) {
                                var servicoAmbulatorialFuncionario = '';
                                if (servicoAmbulatorialEmpresa == '100%') {
                                  servicoAmbulatorialFuncionario = '0%';
                                } else if (servicoAmbulatorialEmpresa ==
                                    '75%') {
                                  servicoAmbulatorialFuncionario = '25%';
                                } else if (servicoAmbulatorialEmpresa ==
                                    '50%') {
                                  servicoAmbulatorialFuncionario = '50%';
                                } else if (servicoAmbulatorialEmpresa ==
                                    '25%') {
                                  servicoAmbulatorialFuncionario = '75%';
                                } else {
                                  servicoAmbulatorialFuncionario = '100%';
                                }
                                setState(() {
                                  _servicoAmbulatorialEmpresa =
                                      servicoAmbulatorialEmpresa;
                                  _servicoAmbulatorialFuncionario =
                                      servicoAmbulatorialFuncionario;
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            width: 300,
                            child: SelectFormField(
                              key: UniqueKey(),
                              decoration: const InputDecoration(
                                labelText: 'Funcionário',
                              ),
                              type: SelectFormFieldType.dropdown,
                              items: getValoresBonificacoes(),
                              initialValue: _servicoAmbulatorialFuncionario,
                              onChanged: (servicoAmbulatorialFuncionario) {
                                var servicoAmbulatorialEmpresa = '';
                                if (servicoAmbulatorialFuncionario == '100%') {
                                  servicoAmbulatorialEmpresa = '0%';
                                } else if (servicoAmbulatorialFuncionario ==
                                    '75%') {
                                  servicoAmbulatorialEmpresa = '25%';
                                } else if (servicoAmbulatorialFuncionario ==
                                    '50%') {
                                  servicoAmbulatorialEmpresa = '50%';
                                } else if (servicoAmbulatorialFuncionario ==
                                    '25%') {
                                  servicoAmbulatorialEmpresa = '75%';
                                } else {
                                  servicoAmbulatorialEmpresa = '100%';
                                }
                                setState(() {
                                  _servicoAmbulatorialFuncionario =
                                      servicoAmbulatorialFuncionario;
                                  _servicoAmbulatorialEmpresa =
                                      servicoAmbulatorialEmpresa;
                                });
                              },
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  ExpansionTile(
                    title:
                        const Text('Assistência Odontológica (Participação %)'),
                    expandedCrossAxisAlignment: CrossAxisAlignment.start,
                    expandedAlignment: Alignment.topLeft,
                    childrenPadding: const EdgeInsets.only(
                      left: 16,
                      bottom: 32,
                    ),
                    children: [
                      const Text('Assistência Odontológica:'),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        children: [
                          SizedBox(
                            width: 300,
                            child: SelectFormField(
                              key: UniqueKey(),
                              decoration: const InputDecoration(
                                labelText: 'Empresa',
                              ),
                              type: SelectFormFieldType.dropdown,
                              items: getValoresBonificacoes(),
                              initialValue: _assistenciaOdontologicaEmpresa,
                              onChanged: (assistenciaOdontologicaEmpresa) {
                                var assistenciaOdontologicaFuncionario = '';
                                if (assistenciaOdontologicaEmpresa == '100%') {
                                  assistenciaOdontologicaFuncionario = '0%';
                                } else if (assistenciaOdontologicaEmpresa ==
                                    '75%') {
                                  assistenciaOdontologicaFuncionario = '25%';
                                } else if (assistenciaOdontologicaEmpresa ==
                                    '50%') {
                                  assistenciaOdontologicaFuncionario = '50%';
                                } else if (assistenciaOdontologicaEmpresa ==
                                    '25%') {
                                  assistenciaOdontologicaFuncionario = '75%';
                                } else {
                                  assistenciaOdontologicaFuncionario = '100%';
                                }
                                setState(() {
                                  _assistenciaOdontologicaEmpresa =
                                      assistenciaOdontologicaEmpresa;
                                  _assistenciaOdontologicaFuncionario =
                                      assistenciaOdontologicaFuncionario;
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            width: 300,
                            child: SelectFormField(
                              key: UniqueKey(),
                              decoration: const InputDecoration(
                                labelText: 'Funcionário',
                              ),
                              type: SelectFormFieldType.dropdown,
                              items: getValoresBonificacoes(),
                              initialValue: _assistenciaOdontologicaFuncionario,
                              onChanged: (assistenciaOdontologicaFuncionario) {
                                var assistenciaOdontologicaEmpresa = '';
                                if (assistenciaOdontologicaFuncionario ==
                                    '100%') {
                                  assistenciaOdontologicaEmpresa = '0%';
                                } else if (assistenciaOdontologicaFuncionario ==
                                    '75%') {
                                  assistenciaOdontologicaEmpresa = '25%';
                                } else if (assistenciaOdontologicaFuncionario ==
                                    '50%') {
                                  assistenciaOdontologicaEmpresa = '50%';
                                } else if (assistenciaOdontologicaFuncionario ==
                                    '25%') {
                                  assistenciaOdontologicaEmpresa = '75%';
                                } else {
                                  assistenciaOdontologicaEmpresa = '100%';
                                }
                                setState(() {
                                  _assistenciaOdontologicaFuncionario =
                                      assistenciaOdontologicaFuncionario;
                                  _assistenciaOdontologicaEmpresa =
                                      assistenciaOdontologicaEmpresa;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text('Serviço Ambulatorial Próprio:'),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        children: [
                          SizedBox(
                            width: 300,
                            child: SelectFormField(
                              key: UniqueKey(),
                              decoration: const InputDecoration(
                                labelText: 'Empresa',
                              ),
                              type: SelectFormFieldType.dropdown,
                              items: getValoresBonificacoes(),
                              initialValue: _servicoAmbulatorialProprioEmpresa,
                              onChanged: (servicoAmbulatorialProprioEmpresa) {
                                var servicoAmbulatorialProprioFuncionario = '';
                                if (servicoAmbulatorialProprioEmpresa ==
                                    '100%') {
                                  servicoAmbulatorialProprioFuncionario = '0%';
                                } else if (servicoAmbulatorialProprioEmpresa ==
                                    '75%') {
                                  servicoAmbulatorialProprioFuncionario = '25%';
                                } else if (servicoAmbulatorialProprioEmpresa ==
                                    '50%') {
                                  servicoAmbulatorialProprioFuncionario = '50%';
                                } else if (servicoAmbulatorialProprioEmpresa ==
                                    '25%') {
                                  servicoAmbulatorialProprioFuncionario = '75%';
                                } else {
                                  servicoAmbulatorialProprioFuncionario =
                                      '100%';
                                }
                                setState(() {
                                  _servicoAmbulatorialProprioEmpresa =
                                      servicoAmbulatorialProprioEmpresa;
                                  _servicoAmbulatorialProprioFuncionario =
                                      servicoAmbulatorialProprioFuncionario;
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            width: 300,
                            child: SelectFormField(
                              key: UniqueKey(),
                              decoration: const InputDecoration(
                                labelText: 'Funcionário',
                              ),
                              type: SelectFormFieldType.dropdown,
                              items: getValoresBonificacoes(),
                              initialValue:
                                  _servicoAmbulatorialProprioFuncionario,
                              onChanged:
                                  (servicoAmbulatorialProprioFuncionario) {
                                var servicoAmbulatorialProprioEmpresa = '';
                                if (servicoAmbulatorialProprioFuncionario ==
                                    '100%') {
                                  servicoAmbulatorialProprioEmpresa = '0%';
                                } else if (servicoAmbulatorialProprioFuncionario ==
                                    '75%') {
                                  servicoAmbulatorialProprioEmpresa = '25%';
                                } else if (servicoAmbulatorialProprioFuncionario ==
                                    '50%') {
                                  servicoAmbulatorialProprioEmpresa = '50%';
                                } else if (servicoAmbulatorialProprioFuncionario ==
                                    '25%') {
                                  servicoAmbulatorialProprioEmpresa = '75%';
                                } else {
                                  servicoAmbulatorialProprioEmpresa = '100%';
                                }
                                setState(() {
                                  _servicoAmbulatorialProprioFuncionario =
                                      servicoAmbulatorialProprioFuncionario;
                                  _servicoAmbulatorialProprioEmpresa =
                                      servicoAmbulatorialProprioEmpresa;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  ExpansionTile(
                    title: const Text('Alimentação (Participação %)'),
                    expandedCrossAxisAlignment: CrossAxisAlignment.start,
                    expandedAlignment: Alignment.topLeft,
                    childrenPadding: const EdgeInsets.only(
                      left: 16,
                      bottom: 32,
                    ),
                    children: [
                      const Text('Restaurante:'),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        children: [
                          SizedBox(
                            width: 300,
                            child: SelectFormField(
                              key: UniqueKey(),
                              decoration: const InputDecoration(
                                labelText: 'Empresa',
                              ),
                              type: SelectFormFieldType.dropdown,
                              items: getValoresBonificacoes(),
                              initialValue: _restauranteEmpresa,
                              onChanged: (restauranteEmpresa) {
                                var restauranteFuncionario = '';
                                if (restauranteEmpresa == '100%') {
                                  restauranteFuncionario = '0%';
                                } else if (restauranteEmpresa == '75%') {
                                  restauranteFuncionario = '25%';
                                } else if (restauranteEmpresa == '50%') {
                                  restauranteFuncionario = '50%';
                                } else if (restauranteEmpresa == '25%') {
                                  restauranteFuncionario = '75%';
                                } else {
                                  restauranteFuncionario = '100%';
                                }
                                setState(() {
                                  _restauranteEmpresa = restauranteEmpresa;
                                  _restauranteFuncionario =
                                      restauranteFuncionario;
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            width: 300,
                            child: SelectFormField(
                              key: UniqueKey(),
                              decoration: const InputDecoration(
                                labelText: 'Funcionário',
                              ),
                              type: SelectFormFieldType.dropdown,
                              items: getValoresBonificacoes(),
                              initialValue: _restauranteFuncionario,
                              onChanged: (restauranteFuncionario) {
                                var restauranteEmpresa = '';
                                if (restauranteFuncionario == '100%') {
                                  restauranteEmpresa = '0%';
                                } else if (restauranteFuncionario == '75%') {
                                  restauranteEmpresa = '25%';
                                } else if (restauranteFuncionario == '50%') {
                                  restauranteEmpresa = '50%';
                                } else if (restauranteFuncionario == '25%') {
                                  restauranteEmpresa = '75%';
                                } else {
                                  restauranteEmpresa = '100%';
                                }
                                setState(() {
                                  _restauranteFuncionario =
                                      restauranteFuncionario;
                                  _restauranteEmpresa = restauranteEmpresa;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text('Vale Refeição:'),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        children: [
                          SizedBox(
                            width: 300,
                            child: SelectFormField(
                              key: UniqueKey(),
                              decoration: const InputDecoration(
                                labelText: 'Empresa',
                              ),
                              type: SelectFormFieldType.dropdown,
                              items: getValoresBonificacoes(),
                              initialValue: _valeRefeicaoEmpresa,
                              onChanged: (valeRefeicaoEmpresa) {
                                var valeRefeicaoFuncionario = '';
                                if (valeRefeicaoEmpresa == '100%') {
                                  valeRefeicaoFuncionario = '0%';
                                } else if (valeRefeicaoEmpresa == '75%') {
                                  valeRefeicaoFuncionario = '25%';
                                } else if (valeRefeicaoEmpresa == '50%') {
                                  valeRefeicaoFuncionario = '50%';
                                } else if (valeRefeicaoEmpresa == '25%') {
                                  valeRefeicaoFuncionario = '75%';
                                } else {
                                  valeRefeicaoFuncionario = '100%';
                                }
                                setState(() {
                                  _valeRefeicaoEmpresa = valeRefeicaoEmpresa;
                                  _valeRefeicaoFuncionario =
                                      valeRefeicaoFuncionario;
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            width: 300,
                            child: SelectFormField(
                              key: UniqueKey(),
                              decoration: const InputDecoration(
                                labelText: 'Funcionário',
                              ),
                              type: SelectFormFieldType.dropdown,
                              items: getValoresBonificacoes(),
                              initialValue: _valeRefeicaoFuncionario,
                              onChanged: (valeRefeicaoFuncionario) {
                                var valeRefeicaoEmpresa = '';
                                if (valeRefeicaoFuncionario == '100%') {
                                  valeRefeicaoEmpresa = '0%';
                                } else if (valeRefeicaoFuncionario == '75%') {
                                  valeRefeicaoEmpresa = '25%';
                                } else if (valeRefeicaoFuncionario == '50%') {
                                  valeRefeicaoEmpresa = '50%';
                                } else if (valeRefeicaoFuncionario == '25%') {
                                  valeRefeicaoEmpresa = '75%';
                                } else {
                                  valeRefeicaoEmpresa = '100%';
                                }
                                setState(() {
                                  _valeRefeicaoFuncionario =
                                      valeRefeicaoFuncionario;
                                  _valeRefeicaoEmpresa = valeRefeicaoEmpresa;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text('Cesta Básica:'),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        children: [
                          SizedBox(
                            width: 300,
                            child: SelectFormField(
                              key: UniqueKey(),
                              decoration: const InputDecoration(
                                labelText: 'Empresa',
                              ),
                              type: SelectFormFieldType.dropdown,
                              items: getValoresBonificacoes(),
                              initialValue: _cestaBasicaEmpresa,
                              onChanged: (cestaBasicaEmpresa) {
                                var cestaBasicaFuncionario = '';
                                if (cestaBasicaEmpresa == '100%') {
                                  cestaBasicaFuncionario = '0%';
                                } else if (cestaBasicaEmpresa == '75%') {
                                  cestaBasicaFuncionario = '25%';
                                } else if (cestaBasicaEmpresa == '50%') {
                                  cestaBasicaFuncionario = '50%';
                                } else if (cestaBasicaEmpresa == '25%') {
                                  cestaBasicaFuncionario = '75%';
                                } else {
                                  cestaBasicaFuncionario = '100%';
                                }
                                setState(() {
                                  _cestaBasicaEmpresa = cestaBasicaEmpresa;
                                  _cestaBasicaFuncionario =
                                      cestaBasicaFuncionario;
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            width: 300,
                            child: SelectFormField(
                              key: UniqueKey(),
                              decoration: const InputDecoration(
                                labelText: 'Funcionário',
                              ),
                              type: SelectFormFieldType.dropdown,
                              items: getValoresBonificacoes(),
                              initialValue: _cestaBasicaFuncionario,
                              onChanged: (cestaBasicaFuncionario) {
                                var cestaBasicaEmpresa = '';
                                if (cestaBasicaFuncionario == '100%') {
                                  cestaBasicaEmpresa = '0%';
                                } else if (cestaBasicaFuncionario == '75%') {
                                  cestaBasicaEmpresa = '25%';
                                } else if (cestaBasicaFuncionario == '50%') {
                                  cestaBasicaEmpresa = '50%';
                                } else if (cestaBasicaFuncionario == '25%') {
                                  cestaBasicaEmpresa = '75%';
                                } else {
                                  cestaBasicaEmpresa = '100%';
                                }
                                setState(() {
                                  _cestaBasicaFuncionario =
                                      cestaBasicaFuncionario;
                                  _cestaBasicaEmpresa = cestaBasicaEmpresa;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text('Vale Alimentação:'),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        children: [
                          SizedBox(
                            width: 300,
                            child: SelectFormField(
                              key: UniqueKey(),
                              decoration: const InputDecoration(
                                labelText: 'Empresa',
                              ),
                              type: SelectFormFieldType.dropdown,
                              items: getValoresBonificacoes(),
                              initialValue: _valeAlimentacaoEmpresa,
                              onChanged: (valeAlimentacaoEmpresa) {
                                var valeAlimentacaoFuncionario = '';
                                if (valeAlimentacaoEmpresa == '100%') {
                                  valeAlimentacaoFuncionario = '0%';
                                } else if (valeAlimentacaoEmpresa == '75%') {
                                  valeAlimentacaoFuncionario = '25%';
                                } else if (valeAlimentacaoEmpresa == '50%') {
                                  valeAlimentacaoFuncionario = '50%';
                                } else if (valeAlimentacaoEmpresa == '25%') {
                                  valeAlimentacaoFuncionario = '75%';
                                } else {
                                  valeAlimentacaoFuncionario = '100%';
                                }
                                setState(() {
                                  _valeAlimentacaoEmpresa =
                                      valeAlimentacaoEmpresa;
                                  _valeAlimentacaoFuncionario =
                                      valeAlimentacaoFuncionario;
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            width: 300,
                            child: SelectFormField(
                              key: UniqueKey(),
                              decoration: const InputDecoration(
                                labelText: 'Funcionário',
                              ),
                              type: SelectFormFieldType.dropdown,
                              items: getValoresBonificacoes(),
                              initialValue: _valeAlimentacaoFuncionario,
                              onChanged: (valeAlimentacaoFuncionario) {
                                var valeAlimentacaoEmpresa = '';
                                if (valeAlimentacaoFuncionario == '100%') {
                                  valeAlimentacaoEmpresa = '0%';
                                } else if (valeAlimentacaoFuncionario ==
                                    '75%') {
                                  valeAlimentacaoEmpresa = '25%';
                                } else if (valeAlimentacaoFuncionario ==
                                    '50%') {
                                  valeAlimentacaoEmpresa = '50%';
                                } else if (valeAlimentacaoFuncionario ==
                                    '25%') {
                                  valeAlimentacaoEmpresa = '75%';
                                } else {
                                  valeAlimentacaoEmpresa = '100%';
                                }
                                setState(() {
                                  _valeAlimentacaoFuncionario =
                                      valeAlimentacaoFuncionario;
                                  _valeAlimentacaoEmpresa =
                                      valeAlimentacaoEmpresa;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  ExpansionTile(
                    title: const Text('Convênios'),
                    expandedCrossAxisAlignment: CrossAxisAlignment.start,
                    expandedAlignment: Alignment.topLeft,
                    childrenPadding: const EdgeInsets.only(
                      left: 16,
                      bottom: 32,
                    ),
                    children: [
                      CheckboxListTile(
                        title: const Text('Academias'),
                        value: academias,
                        onChanged: (value) {
                          setState(() {
                            academias = value!;
                          });
                        },
                        activeColor: Theme.of(context).colorScheme.primary,
                      ),
                      CheckboxListTile(
                        title: const Text(
                            'Instituições de ensino (escolas, faculdades, cursos de línguas)'),
                        value: instituicoesDeEnsino,
                        onChanged: (value) {
                          setState(() {
                            instituicoesDeEnsino = value!;
                          });
                        },
                        activeColor: Theme.of(context).colorScheme.primary,
                      ),
                      CheckboxListTile(
                        title: const Text('Livrarias'),
                        value: livrarias,
                        onChanged: (value) {
                          setState(() {
                            livrarias = value!;
                          });
                        },
                        activeColor: Theme.of(context).colorScheme.primary,
                      ),
                      CheckboxListTile(
                        title: const Text('Lojas Parceiras'),
                        value: lojasParceiras,
                        onChanged: (value) {
                          setState(() {
                            lojasParceiras = value!;
                          });
                        },
                        activeColor: Theme.of(context).colorScheme.primary,
                      ),
                      SizedBox(
                          width: 400,
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Outros',
                            ),
                            initialValue: outros,
                            onChanged: (o) => outros = o,
                            maxLines: 3,
                          ),
                        ),
                    ],
                  ),
                  ExpansionTile(
                    title: const Text('Seguro de Vida (Participação %)'),
                    expandedCrossAxisAlignment: CrossAxisAlignment.start,
                    expandedAlignment: Alignment.topLeft,
                    childrenPadding: const EdgeInsets.only(
                      left: 16,
                      bottom: 32,
                    ),
                    children: [
                      const Text('Seguro de Vida em Grupo:'),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        children: [
                          SizedBox(
                            width: 300,
                            child: SelectFormField(
                              key: UniqueKey(),
                              decoration: const InputDecoration(
                                labelText: 'Empresa',
                              ),
                              type: SelectFormFieldType.dropdown,
                              items: getValoresBonificacoes(),
                              initialValue: _seguroDeVidaEmGrupoEmpresa,
                              onChanged: (seguroDeVidaEmGrupoEmpresa) {
                                var seguroDeVidaEmGrupoFuncionario = '';
                                if (seguroDeVidaEmGrupoEmpresa == '100%') {
                                  seguroDeVidaEmGrupoFuncionario = '0%';
                                } else if (seguroDeVidaEmGrupoEmpresa ==
                                    '75%') {
                                  seguroDeVidaEmGrupoFuncionario = '25%';
                                } else if (seguroDeVidaEmGrupoEmpresa ==
                                    '50%') {
                                  seguroDeVidaEmGrupoFuncionario = '50%';
                                } else if (seguroDeVidaEmGrupoEmpresa ==
                                    '25%') {
                                  seguroDeVidaEmGrupoFuncionario = '75%';
                                } else {
                                  seguroDeVidaEmGrupoFuncionario = '100%';
                                }
                                setState(() {
                                  _seguroDeVidaEmGrupoEmpresa =
                                      seguroDeVidaEmGrupoEmpresa;
                                  _seguroDeVidaEmGrupoFuncionario =
                                      seguroDeVidaEmGrupoFuncionario;
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            width: 300,
                            child: SelectFormField(
                              key: UniqueKey(),
                              decoration: const InputDecoration(
                                labelText: 'Funcionário',
                              ),
                              type: SelectFormFieldType.dropdown,
                              items: getValoresBonificacoes(),
                              initialValue: _seguroDeVidaEmGrupoFuncionario,
                              onChanged: (seguroDeVidaEmGrupoFuncionario) {
                                var seguroDeVidaEmGrupoEmpresa = '';
                                if (seguroDeVidaEmGrupoFuncionario == '100%') {
                                  seguroDeVidaEmGrupoEmpresa = '0%';
                                } else if (seguroDeVidaEmGrupoFuncionario ==
                                    '75%') {
                                  seguroDeVidaEmGrupoEmpresa = '25%';
                                } else if (seguroDeVidaEmGrupoFuncionario ==
                                    '50%') {
                                  seguroDeVidaEmGrupoEmpresa = '50%';
                                } else if (seguroDeVidaEmGrupoFuncionario ==
                                    '25%') {
                                  seguroDeVidaEmGrupoEmpresa = '75%';
                                } else {
                                  seguroDeVidaEmGrupoEmpresa = '100%';
                                }
                                setState(() {
                                  _seguroDeVidaEmGrupoFuncionario =
                                      seguroDeVidaEmGrupoFuncionario;
                                  _seguroDeVidaEmGrupoEmpresa =
                                      seguroDeVidaEmGrupoEmpresa;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text('Seguro Acidentes de Trabalho:'),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        children: [
                          SizedBox(
                            width: 300,
                            child: SelectFormField(
                              key: UniqueKey(),
                              decoration: const InputDecoration(
                                labelText: 'Empresa',
                              ),
                              type: SelectFormFieldType.dropdown,
                              items: getValoresBonificacoes(),
                              initialValue: _seguroAcidentesDeTrabalhoEmpresa,
                              onChanged: (seguroAcidentesDeTrabalhoEmpresa) {
                                var seguroAcidentesDeTrabalhoFuncionario = '';
                                if (seguroAcidentesDeTrabalhoEmpresa ==
                                    '100%') {
                                  seguroAcidentesDeTrabalhoFuncionario = '0%';
                                } else if (seguroAcidentesDeTrabalhoEmpresa ==
                                    '75%') {
                                  seguroAcidentesDeTrabalhoFuncionario = '25%';
                                } else if (seguroAcidentesDeTrabalhoEmpresa ==
                                    '50%') {
                                  seguroAcidentesDeTrabalhoFuncionario = '50%';
                                } else if (seguroAcidentesDeTrabalhoEmpresa ==
                                    '25%') {
                                  seguroAcidentesDeTrabalhoFuncionario = '75%';
                                } else {
                                  seguroAcidentesDeTrabalhoFuncionario = '100%';
                                }
                                setState(() {
                                  _seguroAcidentesDeTrabalhoEmpresa =
                                      seguroAcidentesDeTrabalhoEmpresa;
                                  _seguroAcidentesDeTrabalhoFuncionario =
                                      seguroAcidentesDeTrabalhoFuncionario;
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            width: 300,
                            child: SelectFormField(
                              key: UniqueKey(),
                              decoration: const InputDecoration(
                                labelText: 'Funcionário',
                              ),
                              type: SelectFormFieldType.dropdown,
                              items: getValoresBonificacoes(),
                              initialValue:
                                  _seguroAcidentesDeTrabalhoFuncionario,
                              onChanged:
                                  (seguroAcidentesDeTrabalhoFuncionario) {
                                var seguroAcidentesDeTrabalhoEmpresa = '';
                                if (seguroAcidentesDeTrabalhoFuncionario ==
                                    '100%') {
                                  seguroAcidentesDeTrabalhoEmpresa = '0%';
                                } else if (seguroAcidentesDeTrabalhoFuncionario ==
                                    '75%') {
                                  seguroAcidentesDeTrabalhoEmpresa = '25%';
                                } else if (seguroAcidentesDeTrabalhoFuncionario ==
                                    '50%') {
                                  seguroAcidentesDeTrabalhoEmpresa = '50%';
                                } else if (seguroAcidentesDeTrabalhoFuncionario ==
                                    '25%') {
                                  seguroAcidentesDeTrabalhoEmpresa = '75%';
                                } else {
                                  seguroAcidentesDeTrabalhoEmpresa = '100%';
                                }
                                setState(() {
                                  _seguroAcidentesDeTrabalhoFuncionario =
                                      seguroAcidentesDeTrabalhoFuncionario;
                                  _seguroAcidentesDeTrabalhoEmpresa =
                                      seguroAcidentesDeTrabalhoEmpresa;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            isActive: _currentStep >= 1,
            state: _currentStep >= 1 ? StepState.complete : StepState.disabled,
          ),
          Step(
            title: const Text('Cargos'),
            content: estaEmAdicaoDeCargos
                ? Form(
                    key: _cargosFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: 16,
                          runSpacing: 16,
                          children: <Widget>[
                            SizedBox(
                              width: 300,
                              child: SelectFormField(
                                decoration: const InputDecoration(
                                  labelText: 'Cargo',
                                ),
                                type: SelectFormFieldType.dropdown,
                                initialValue: _cargo,
                                items: _getCargos(),
                                validator: (cargo) =>
                                    cargo!.isEmpty ? 'Campo Obrigatório' : null,
                                onSaved: (cargo) => _cargo = cargo,
                                onChanged: (cargo) => setState(() {
                                  _cargo = cargo;
                                }),
                              ),
                            ),
                            SizedBox(
                              width: 200,
                              child: SelectFormField(
                                decoration: const InputDecoration(
                                  labelText: 'Nivel de Senioridade',
                                ),
                                type: SelectFormFieldType.dropdown,
                                initialValue: 'Junior (Até 3 anos)',
                                items: const [
                                  {
                                    'value': 'Junior (Até 3 anos)',
                                    'label': 'Junior (Até 3 anos)',
                                  },
                                  {
                                    'value': 'Pleno (4 a 9 anos)',
                                    'label': 'Pleno (4 a 9 anos)',
                                  },
                                  {
                                    'value': 'Pleno (4 a 9 anos)',
                                    'label': 'Pleno (4 a 9 anos)',
                                  },
                                  {
                                    'value': 'Especialista (Mais de 12 anos)',
                                    'label': 'Especialista (Mais de 12 anos)',
                                  },
                                ],
                                validator: (senioridade) => senioridade!.isEmpty
                                    ? 'Campo Obrigatório'
                                    : null,
                                onSaved: (senioridade) =>
                                    _senioridade = senioridade,
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
                              width: 150,
                              child: SelectFormField(
                                decoration: const InputDecoration(
                                  labelText: 'Vínculo',
                                ),
                                type: SelectFormFieldType.dropdown,
                                initialValue: 'CLT',
                                items: const [
                                  {
                                    'value': 'CLT',
                                    'label': 'CLT',
                                  },
                                  {
                                    'value': 'PJ',
                                    'label': 'PJ',
                                  },
                                  {
                                    'value': 'Terceirizado',
                                    'label': 'Terceirizado',
                                  },
                                ],
                                validator: (vinculo) => vinculo!.isEmpty
                                    ? 'Campo Obrigatório'
                                    : null,
                                onSaved: (vinculo) => _vinculo = vinculo,
                              ),
                            ),
                            Tooltip(
                              message: '''

Quantidade de ocupantes do cargo que recebe o mesmo valor de salário.
Ex.: Mecânicos Manutenção
02 recebem R\$ 850,00
01 recebe R\$ 920,00
01 recebe R\$ 980,00
''',
                              child: SizedBox(
                                width: 150,
                                child: TextFormField(
                                  decoration: const InputDecoration(
                                    labelText: 'Frequência',
                                  ),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  validator: (frequencia) => frequencia!.isEmpty
                                      ? 'Campo Obrigatório'
                                      : null,
                                  onSaved: (frequencia) =>
                                      _frequencia = int.tryParse(frequencia!),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 150,
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  labelText: 'Salário (R\$)',
                                ),
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                validator: (salario) => salario!.isEmpty
                                    ? 'Campo Obrigatório'
                                    : null,
                                onSaved: (salario) =>
                                    _salario = int.tryParse(salario!),
                              ),
                            ),
                            Tooltip(
                              message: '''

Informar em valores (R\$) quaisquer adicionais recebidos pelo ocupante. Informar no campo observações o tipo de adicional recebidos.
''',
                              child: SizedBox(
                                width: 150,
                                child: TextFormField(
                                  decoration: const InputDecoration(
                                    labelText: 'Bonificações (R\$)',
                                  ),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  onSaved: (bonificacoes) => _bonificacoes =
                                      int.tryParse(bonificacoes!),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 200,
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  labelText: 'Observações',
                                ),
                                onSaved: (observacoes) =>
                                    _observacoes = observacoes,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () {
                            final form = _cargosFormKey.currentState!;
                            if (form.validate()) {
                              form.save();
                              setState(() {
                                _cargosDaEmpresa.add({
                                  'cargo': _cargo,
                                  'senioridade': _senioridade,
                                  'vinculo': _vinculo,
                                  'frequencia': _frequencia,
                                  'salario': _salario,
                                  'bonificacoes': _bonificacoes,
                                  'observacoes': _observacoes,
                                });
                                estaEmAdicaoDeCargos = false;
                                _cargo = null;
                              });
                              form.reset();
                            }
                          },
                          child: const Text('Salvar'),
                        ),
                      ],
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 40,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            setState(() {
                              estaEmAdicaoDeCargos = true;
                            });
                          },
                          label: const Text('Adicionar Cargo'),
                          icon: const Icon(Icons.add),
                        ),
                      ),
                      ListView.separated(
                        shrinkWrap: true,
                        separatorBuilder: (context, index) => const Divider(),
                        itemCount: _cargosDaEmpresa.length,
                        itemBuilder: (_, i) => ListTile(
                          title: Text(_cargosDaEmpresa[i]['cargo']),
                        ),
                      ),
                    ],
                  ),
            isActive: _currentStep >= 2,
            state: _currentStep >= 2 ? StepState.complete : StepState.disabled,
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getRamosAtuacao() {
    final ramos = ramosAtuacaoDisponiveis
        .map(
          (ramo) => {
            'value': ramo as dynamic,
            'label': ramo as dynamic,
          },
        )
        .toList();

    return [
      ...ramos,
      {
        'value': 'Outro',
        'label': 'Outro',
      }
    ];
  }

  List<Map<String, dynamic>> _getCargos() {
    return cargosDisponiveis
        .map(
          (cargo) => {
            'value': cargo as dynamic,
            'label': cargo as dynamic,
          },
        )
        .toList();
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
