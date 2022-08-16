import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:wager/pages/layout/w_scaffold.dart';

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
  String? _dataBase;
  String? _dataDosDados;
  String? _faturamentoAnual;
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
                'dataBase': _dataBase,
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
                    'empresa': _assistenciaMedicaEmpresa ?? 0,
                    'funcionario': _assistenciaMedicaFuncionario ?? 0,
                  },
                  'servicoAmbulatorial': {
                    'empresa': _servicoAmbulatorialEmpresa ?? 0,
                    'funcionario': _servicoAmbulatorialFuncionario ?? 0,
                  },
                },
                'assistenciaOdontologica': {
                  'assistenciaOdontologica': {
                    'empresa': _assistenciaOdontologicaEmpresa ?? 0,
                    'funcionario': _assistenciaOdontologicaFuncionario ?? 0,
                  },
                  'servicoAmbulatorialProprio': {
                    'empresa': _servicoAmbulatorialProprioEmpresa ?? 0,
                    'funcionario': _servicoAmbulatorialProprioFuncionario ?? 0,
                  },
                },
                'alimentacao': {
                  'restaurante': {
                    'empresa': _restauranteEmpresa ?? 0,
                    'funcionario': _restauranteFuncionario ?? 0,
                  },
                  'valeRefeicao': {
                    'empresa': _valeRefeicaoEmpresa ?? 0,
                    'funcionario': _valeRefeicaoFuncionario ?? 0,
                  },
                  'cestaBasica': {
                    'empresa': _cestaBasicaEmpresa ?? 0,
                    'funcionario': _cestaBasicaFuncionario ?? 0,
                  },
                  'valeAlimentacao': {
                    'empresa': _valeAlimentacaoEmpresa ?? 0,
                    'funcionario': _valeAlimentacaoFuncionario ?? 0,
                  },
                },
                'transporte': {
                  'valeTransporte': _valeTransporte ?? 0,
                  'frotaPropria': _frotaPropria ?? 0,
                  'frotaTerceirizada': _frotaTerceirizada ?? 0,
                },
                'seguroDeVida': {
                  'seguroDeVidaEmGrupo': {
                    'empresa': _seguroDeVidaEmGrupoEmpresa ?? 0,
                    'funcionario': _seguroDeVidaEmGrupoFuncionario ?? 0,
                  },
                  'seguroAcidentesDeTrabalho': {
                    'empresa': _seguroAcidentesDeTrabalhoEmpresa ?? 0,
                    'funcionario': _seguroAcidentesDeTrabalhoFuncionario ?? 0,
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
                          initialValue: _dataBase != null
                              ? DateTime.parse(_dataBase!)
                              : null,
                          format: DateFormat("dd/MM/yyyy"),
                          validator: (baseDate) =>
                              baseDate == null ? 'Campo Obrigatório' : null,
                          onSaved: (baseDate) =>
                              _dataBase = baseDate.toString(),
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
                            child: TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Empresa',
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              initialValue:
                                  _assistenciaMedicaEmpresa?.toString() ?? '',
                              onChanged: (name) => setState(() {
                                _assistenciaMedicaEmpresa = int.tryParse(name);
                              }),
                            ),
                          ),
                          SizedBox(
                            width: 300,
                            child: TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Funcionário',
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              initialValue:
                                  _assistenciaMedicaFuncionario?.toString() ??
                                      '',
                              onChanged: (name) => setState(() {
                                _assistenciaMedicaFuncionario =
                                    int.tryParse(name);
                              }),
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
                            child: TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Empresa',
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              initialValue:
                                  _servicoAmbulatorialEmpresa?.toString() ?? '',
                              onChanged: (name) => setState(() {
                                _servicoAmbulatorialEmpresa =
                                    int.tryParse(name);
                              }),
                            ),
                          ),
                          SizedBox(
                            width: 300,
                            child: TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Funcionário',
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              initialValue:
                                  _servicoAmbulatorialFuncionario?.toString() ??
                                      '',
                              onChanged: (name) => setState(() {
                                _servicoAmbulatorialFuncionario =
                                    int.tryParse(name);
                              }),
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
                            child: TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Empresa',
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              initialValue:
                                  _assistenciaOdontologicaEmpresa?.toString() ??
                                      '',
                              onChanged: (name) => setState(() {
                                _assistenciaOdontologicaEmpresa =
                                    int.tryParse(name);
                              }),
                            ),
                          ),
                          SizedBox(
                            width: 300,
                            child: TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Funcionário',
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              initialValue: _assistenciaOdontologicaFuncionario
                                      ?.toString() ??
                                  '',
                              onChanged: (name) => setState(() {
                                _assistenciaOdontologicaFuncionario =
                                    int.tryParse(name);
                              }),
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
                            child: TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Empresa',
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              initialValue: _servicoAmbulatorialProprioEmpresa
                                      ?.toString() ??
                                  '',
                              onChanged: (name) => setState(() {
                                _servicoAmbulatorialProprioEmpresa =
                                    int.tryParse(name);
                              }),
                            ),
                          ),
                          SizedBox(
                            width: 300,
                            child: TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Funcionário',
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              initialValue:
                                  _servicoAmbulatorialProprioFuncionario
                                          ?.toString() ??
                                      '',
                              onChanged: (name) => setState(() {
                                _servicoAmbulatorialProprioFuncionario =
                                    int.tryParse(name);
                              }),
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
                            child: TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Empresa',
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              initialValue:
                                  _restauranteEmpresa?.toString() ?? '',
                              onChanged: (name) => setState(() {
                                _restauranteEmpresa = int.tryParse(name);
                              }),
                            ),
                          ),
                          SizedBox(
                            width: 300,
                            child: TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Funcionário',
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              initialValue:
                                  _restauranteFuncionario?.toString() ?? '',
                              onChanged: (name) => setState(() {
                                _restauranteFuncionario = int.tryParse(name);
                              }),
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
                            child: TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Empresa',
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              initialValue:
                                  _valeRefeicaoEmpresa?.toString() ?? '',
                              onChanged: (name) => setState(() {
                                _valeRefeicaoEmpresa = int.tryParse(name);
                              }),
                            ),
                          ),
                          SizedBox(
                            width: 300,
                            child: TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Funcionário',
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              initialValue:
                                  _valeRefeicaoFuncionario?.toString() ?? '',
                              onChanged: (name) => setState(() {
                                _valeRefeicaoFuncionario = int.tryParse(name);
                              }),
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
                            child: TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Empresa',
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              initialValue:
                                  _cestaBasicaEmpresa?.toString() ?? '',
                              onChanged: (name) => setState(() {
                                _cestaBasicaEmpresa = int.tryParse(name);
                              }),
                            ),
                          ),
                          SizedBox(
                            width: 300,
                            child: TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Funcionário',
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              initialValue:
                                  _cestaBasicaFuncionario?.toString() ?? '',
                              onChanged: (name) => setState(() {
                                _cestaBasicaFuncionario = int.tryParse(name);
                              }),
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
                            child: TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Empresa',
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              initialValue:
                                  _valeAlimentacaoEmpresa?.toString() ?? '',
                              onChanged: (name) => setState(() {
                                _valeAlimentacaoEmpresa = int.tryParse(name);
                              }),
                            ),
                          ),
                          SizedBox(
                            width: 300,
                            child: TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Funcionário',
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              initialValue:
                                  _valeAlimentacaoFuncionario?.toString() ?? '',
                              onChanged: (name) => setState(() {
                                _valeAlimentacaoFuncionario =
                                    int.tryParse(name);
                              }),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  ExpansionTile(
                    title: const Text('Transporte (Participação %)'),
                    expandedCrossAxisAlignment: CrossAxisAlignment.start,
                    expandedAlignment: Alignment.topLeft,
                    childrenPadding: const EdgeInsets.only(
                      left: 16,
                      bottom: 32,
                    ),
                    children: [
                      const Text('Vale Transporte:'),
                      const SizedBox(height: 6),
                      SizedBox(
                        width: 300,
                        child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Funcionário',
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          initialValue: _valeTransporte?.toString() ?? '',
                          onChanged: (name) => setState(() {
                            _valeTransporte = int.tryParse(name);
                          }),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text('Frota Própria:'),
                      SizedBox(
                        width: 300,
                        child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Funcionário',
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          initialValue: _frotaPropria?.toString() ?? '',
                          onChanged: (name) => setState(() {
                            _frotaPropria = int.tryParse(name);
                          }),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text('Frota Terceirizada:'),
                      const SizedBox(height: 6),
                      SizedBox(
                        width: 300,
                        child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Funcionário',
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          initialValue: _frotaTerceirizada?.toString() ?? '',
                          onChanged: (name) => setState(() {
                            _frotaTerceirizada = int.tryParse(name);
                          }),
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
                            child: TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Empresa',
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              initialValue:
                                  _seguroDeVidaEmGrupoEmpresa?.toString() ?? '',
                              onChanged: (name) => setState(() {
                                _seguroDeVidaEmGrupoEmpresa =
                                    int.tryParse(name);
                              }),
                            ),
                          ),
                          SizedBox(
                            width: 300,
                            child: TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Funcionário',
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              initialValue:
                                  _seguroDeVidaEmGrupoFuncionario?.toString() ??
                                      '',
                              onChanged: (name) => setState(() {
                                _seguroDeVidaEmGrupoFuncionario =
                                    int.tryParse(name);
                              }),
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
                            child: TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Empresa',
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              initialValue: _seguroAcidentesDeTrabalhoEmpresa
                                      ?.toString() ??
                                  '',
                              onChanged: (name) => setState(() {
                                _seguroAcidentesDeTrabalhoEmpresa =
                                    int.tryParse(name);
                              }),
                            ),
                          ),
                          SizedBox(
                            width: 300,
                            child: TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Funcionário',
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              initialValue:
                                  _seguroAcidentesDeTrabalhoFuncionario
                                          ?.toString() ??
                                      '',
                              onChanged: (name) => setState(() {
                                _seguroAcidentesDeTrabalhoFuncionario =
                                    int.tryParse(name);
                              }),
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
                                  labelText: 'Salário',
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
                                    labelText: 'Bonificações',
                                  ),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  onSaved: (bonificacoes) =>
                                      _bonificacoes = int.tryParse(bonificacoes!),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 200,
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  labelText: 'Observações',
                                ),
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                onSaved: (observacoes) => _observacoes = observacoes,
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
