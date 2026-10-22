import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../controllers/campos_investimento_controller.dart';
import '../services/simulador_service.dart';
import '../theme/app_theme.dart';
import '../widgets/nota_informativa.dart';
import '../widgets/painel.dart';
import '../widgets/investimento_form_card.dart';
import 'resultados_screen.dart';

/// Formulário de entrada e estado local: nenhum pacote de estado é necessário.
class SimulacaoScreen extends StatefulWidget {
  const SimulacaoScreen({super.key});

  @override
  State<SimulacaoScreen> createState() => _SimulacaoScreenState();
}

class _SimulacaoScreenState extends State<SimulacaoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _primeiro = CamposInvestimentoController('Investimento A');
  final _segundo = CamposInvestimentoController('Investimento B');
  final _meses = TextEditingController(text: '12');
  final _simulador = SimuladorService();
  String? _erro;
  var _validacao = AutovalidateMode.disabled;

  @override
  void initState() {
    super.initState();
    _segundo.taxa.text = '0,80';
  }

  @override
  void dispose() {
    _primeiro.dispose();
    _segundo.dispose();
    _meses.dispose();
    super.dispose();
  }

  void _preencher({required bool exemplo}) {
    FocusManager.instance.primaryFocus?.unfocus();
    _formKey.currentState?.reset();
    // setState atualiza os controles de período e limpa mensagens da simulação.
    setState(() {
      _validacao = AutovalidateMode.disabled;
      _erro = null;
      _meses.text = '12';
      _primeiro.preencher(
        nome: 'Investimento A',
        capital: exemplo ? '1000,00' : '0,00',
        aporte: exemplo ? '100,00' : '0,00',
        taxa: exemplo ? '1,00' : '0,00',
      );
      _segundo.preencher(
        nome: 'Investimento B',
        capital: exemplo ? '1000,00' : '0,00',
        aporte: exemplo ? '100,00' : '0,00',
        taxa: exemplo ? '0,80' : '0,00',
      );
    });
  }

  Future<void> _comparar() async {
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {
      _validacao = AutovalidateMode.onUserInteraction;
      _erro = null;
    });
    if (!_formKey.currentState!.validate()) return;

    try {
      final resultado = _simulador.comparar(
        _primeiro.ler(),
        _segundo.ler(),
        int.parse(_meses.text),
      );
      // Navigator separa a entrada de dados da tela de comparação.
      final reiniciar = await Navigator.of(context).push<bool>(
        MaterialPageRoute(
          builder: (_) => ResultadosScreen(comparacao: resultado),
        ),
      );
      if (mounted && reiniciar == true) _preencher(exemplo: false);
    } on FormatException catch (erro) {
      setState(() => _erro = erro.message);
    } on ArgumentError catch (erro) {
      setState(() => _erro = erro.message.toString());
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.green,
              borderRadius: BorderRadius.circular(11),
            ),
            child: const Icon(
              Icons.trending_up_rounded,
              color: Colors.white,
              size: 23,
            ),
          ),
          const SizedBox(width: 10),
          const Text(
            'investe',
            style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: -0.8),
          ),
        ],
      ),
      actions: [
        IconButton(
          tooltip: 'Sobre o simulador',
          icon: const Icon(Icons.help_outline_rounded),
          onPressed: () => showDialog<void>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Sobre o simulador'),
              content: const Text(
                'Projeto da Atividade 02 de Programação para Dispositivos Móveis.\n\n'
                'Compara dois investimentos com juros compostos e aportes no fim do mês. '
                'Os resultados são projeções com taxa fixa, sem impostos, taxas ou inflação. '
                'Os dados ficam somente na memória do aplicativo.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Entendi'),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
      ],
    ),
    body: SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1040),
            child: Form(
              key: _formKey,
              autovalidateMode: _validacao,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.greenSoft,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Text(
                      'PDM • ATIVIDADE 02',
                      style: TextStyle(
                        color: AppColors.green,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    'Simulador de\ninvestimentos',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Preencha os dados dos dois investimentos para comparar os resultados.',
                    style: TextStyle(
                      color: AppColors.muted,
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 28),
                  Painel(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.calendar_month_outlined,
                              color: AppColors.green,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Por quanto tempo?',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'O mesmo período será usado nos dois investimentos.',
                          style: TextStyle(color: AppColors.muted),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          key: const Key('meses'),
                          controller: _meses,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          decoration: const InputDecoration(
                            labelText: 'Período',
                            suffixText: 'meses',
                          ),
                          onChanged: (_) => setState(() {}),
                          validator: (texto) {
                            final meses = int.tryParse(texto ?? '');
                            return meses == null ||
                                    meses < 1 ||
                                    meses > SimuladorService.maxMeses
                                ? 'Informe de 1 a ${SimuladorService.maxMeses} meses.'
                                : null;
                          },
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          children: [6, 12, 24, 60]
                              .map(
                                (meses) => ChoiceChip(
                                  label: Text('$meses meses'),
                                  selected: _meses.text == '$meses',
                                  showCheckmark: false,
                                  onSelected: (_) =>
                                      setState(() => _meses.text = '$meses'),
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final a = InvestimentoFormCard(
                        campos: _primeiro,
                        letra: 'A',
                        cor: AppColors.green,
                        fundo: AppColors.greenSoft,
                      );
                      final b = InvestimentoFormCard(
                        campos: _segundo,
                        letra: 'B',
                        cor: AppColors.orange,
                        fundo: AppColors.orangeSoft,
                      );
                      if (constraints.maxWidth >= 760) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: a),
                            const SizedBox(width: 20),
                            Expanded(child: b),
                          ],
                        );
                      }
                      return Column(
                        children: [a, const SizedBox(height: 20), b],
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  if (_erro != null) ...[
                    Container(
                      key: const Key('erro_simulacao'),
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.errorContainer,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text(
                        _erro!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onErrorContainer,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      key: const Key('comparar'),
                      onPressed: _comparar,
                      icon: const Icon(Icons.insights_rounded),
                      label: const Text('Comparar investimentos'),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    children: [
                      TextButton.icon(
                        onPressed: () => _preencher(exemplo: true),
                        icon: const Icon(Icons.auto_awesome_outlined, size: 18),
                        label: const Text('Carregar exemplo'),
                      ),
                      TextButton.icon(
                        key: const Key('limpar'),
                        onPressed: () => _preencher(exemplo: false),
                        icon: const Icon(Icons.restart_alt, size: 18),
                        label: const Text('Limpar valores'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  const NotaInformativa(
                    texto:
                        'Aportes no fim de cada mês. Taxas mensais fixas, sem impostos, tarifas ou inflação. Uma projeção para aprender e comparar.',
                  ),
                  const SizedBox(height: 26),
                  const Center(
                    child: Text(
                      'PDM  •  ATIVIDADE 02  •  FLUTTER',
                      style: TextStyle(
                        color: AppColors.muted,
                        fontSize: 11,
                        letterSpacing: 1.1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
