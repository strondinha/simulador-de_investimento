import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/comparacao_investimentos.dart';
import '../models/evolucao_mensal.dart';
import '../models/resultado_investimento.dart';
import '../theme/app_theme.dart';
import '../utils/formatadores.dart';
import '../widgets/nota_informativa.dart';
import '../widgets/painel.dart';
import '../widgets/grafico_comparativo.dart';
import '../widgets/resultado_card.dart';

class ResultadosScreen extends StatefulWidget {
  const ResultadosScreen({required this.comparacao, super.key});
  final ComparacaoInvestimentos comparacao;

  @override
  State<ResultadosScreen> createState() => _ResultadosScreenState();
}

class _ResultadosScreenState extends State<ResultadosScreen> {
  late int _mesSelecionado;
  bool _mostrarRendimento = false;
  ComparacaoInvestimentos get _dados => widget.comparacao;

  @override
  void initState() {
    super.initState();
    _mesSelecionado = _dados.meses;
  }

  @override
  Widget build(BuildContext context) {
    final margem = math.max(
      16.0,
      (MediaQuery.sizeOf(context).width - 1040) / 2,
    );
    final a = _dados.primeiro.evolucao[_mesSelecionado];
    final b = _dados.segundo.evolucao[_mesSelecionado];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sua comparação',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: CustomScrollView(
          key: const Key('lista_resultados'),
          slivers: [
            SliverPadding(
              padding: EdgeInsets.fromLTRB(margem, 20, margem, 0),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Comparação dos\ninvestimentos',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Projeção em ${_dados.meses} ${_dados.meses == 1 ? 'mês' : 'meses'} • Aportes no fim do mês',
                      style: const TextStyle(color: AppColors.muted),
                    ),
                    const SizedBox(height: 24),
                    // Os dois cartões ficam lado a lado, inclusive no celular.
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ResultadoCard(
                            resultado: _dados.primeiro,
                            letra: 'A',
                            cor: AppColors.green,
                            fundo: AppColors.greenSoft,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ResultadoCard(
                            resultado: _dados.segundo,
                            letra: 'B',
                            cor: AppColors.orange,
                            fundo: AppColors.orangeSoft,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.ink,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'COMPARAÇÃO DOS SALDOS',
                            style: TextStyle(
                              color: Color(0xFF9BDCCB),
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _dados.empate
                                ? 'Os montantes finais são iguais.'
                                : '${_dados.maiorMontante.investimento.nome} termina com ${moeda(_dados.diferenca)} a mais.',
                            key: const Key('resumo_comparacao'),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 19,
                              fontWeight: FontWeight.w700,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Valores aplicados diferentes também influenciam o saldo final. Compare o rendimento e o total aplicado de cada opção.',
                            style: TextStyle(
                              color: Color(0xFFD1DFE2),
                              fontSize: 12,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Painel(
                      padding: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Gráfico dos investimentos',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Explore a evolução dos dois investimentos.',
                            style: TextStyle(color: AppColors.muted),
                          ),
                          const SizedBox(height: 16),
                          SegmentedButton<bool>(
                            segments: const [
                              ButtonSegment(value: false, label: Text('Saldo')),
                              ButtonSegment(
                                value: true,
                                label: Text('Rendimento'),
                              ),
                            ],
                            selected: {_mostrarRendimento},
                            showSelectedIcon: false,
                            onSelectionChanged: (valor) => setState(
                              () => _mostrarRendimento = valor.first,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Wrap(
                            spacing: 20,
                            runSpacing: 8,
                            children: [
                              _legenda(
                                'A · ${_dados.primeiro.investimento.nome}',
                                AppColors.green,
                              ),
                              _legenda(
                                'B · ${_dados.segundo.investimento.nome}',
                                AppColors.orange,
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          GraficoComparativo(
                            comparacao: _dados,
                            mesSelecionado: _mesSelecionado,
                            mostrarRendimento: _mostrarRendimento,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            _mesSelecionado == 0
                                ? 'Início da simulação'
                                : 'Mês $_mesSelecionado',
                            key: const Key('mes_grafico'),
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          // setState move o marcador e atualiza os valores consultados.
                          Slider(
                            key: const Key('seletor_mes'),
                            min: 0,
                            max: _dados.meses.toDouble(),
                            divisions: _dados.meses,
                            value: _mesSelecionado.toDouble(),
                            label: 'Mês $_mesSelecionado',
                            onChanged: (valor) =>
                                setState(() => _mesSelecionado = valor.round()),
                          ),
                          Wrap(
                            spacing: 24,
                            runSpacing: 8,
                            children: [
                              Text(
                                'A: ${moeda(_mostrarRendimento ? a.rendimentoAcumulado : a.saldo)}',
                                style: const TextStyle(
                                  color: AppColors.green,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                'B: ${moeda(_mostrarRendimento ? b.rendimentoAcumulado : b.saldo)}',
                                style: const TextStyle(
                                  color: AppColors.orange,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),
                    Text(
                      'Evolução mensal',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Saldo e rendimento acumulado de cada investimento. Toque em um mês para ver os detalhes.',
                      style: TextStyle(color: AppColors.muted),
                    ),
                    const SizedBox(height: 18),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 12,
                      ),
                      decoration: const BoxDecoration(
                        color: AppColors.ink,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(14),
                        ),
                      ),
                      child: const Row(
                        children: [
                          SizedBox(
                            width: 42,
                            child: Text(
                              'MÊS',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              'INVESTIMENTO A',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: Color(0xFFA4DECC),
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'INVESTIMENTO B',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: Color(0xFFF5C6A4),
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // A lista monta sob demanda apenas os meses visíveis na tela.
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: margem),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => _linhaMensal(index),
                  childCount: _dados.meses + 1,
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.fromLTRB(margem, 24, margem, 32),
              sliver: SliverToBoxAdapter(
                child: Column(
                  children: [
                    const NotaInformativa(
                      texto:
                          'Montante = capital + aplicações + juros. Rendimento = montante − total aplicado. As projeções não descontam impostos, tarifas ou inflação.',
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        key: const Key('nova_simulacao'),
                        onPressed: () => Navigator.pop(context, true),
                        icon: const Icon(Icons.add_rounded),
                        label: const Text('Nova simulação'),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextButton.icon(
                      key: const Key('editar_valores'),
                      onPressed: () => Navigator.pop(context, false),
                      icon: const Icon(Icons.edit_outlined, size: 18),
                      label: const Text('Editar os valores atuais'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _legenda(String nome, Color cor) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(color: cor, shape: BoxShape.circle),
      ),
      const SizedBox(width: 6),
      Flexible(
        child: Text(
          nome,
          style: TextStyle(
            color: cor,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    ],
  );

  Widget _linhaMensal(int mes) {
    final a = _dados.primeiro.evolucao[mes];
    final b = _dados.segundo.evolucao[mes];
    return Material(
      key: Key('mes_$mes'),
      color: mes.isEven ? Colors.white : const Color(0xFFEDF3F2),
      child: InkWell(
        onTap: () => _detalharMes(mes),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
          child: Row(
            children: [
              SizedBox(
                width: 42,
                child: Text(
                  mes == 0 ? 'Início' : '$mes',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Expanded(child: _celulaMensal(a, AppColors.green)),
              const SizedBox(width: 12),
              Expanded(child: _celulaMensal(b, AppColors.orange)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _celulaMensal(EvolucaoMensal mes, Color cor) => Column(
    crossAxisAlignment: CrossAxisAlignment.end,
    children: [
      FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          moeda(mes.saldo),
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
        ),
      ),
      const SizedBox(height: 4),
      FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          '${moeda(mes.rendimentoAcumulado)} em juros',
          style: TextStyle(color: cor, fontSize: 10),
        ),
      ),
    ],
  );

  void _detalharMes(int mes) => showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (context) => SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 4, 24, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              mes == 0 ? 'Início da simulação' : 'Detalhes do mês $mes',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 20),
            _detalhe(_dados.primeiro, mes, AppColors.green, 'A'),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Divider(),
            ),
            _detalhe(_dados.segundo, mes, AppColors.orange, 'B'),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Fechar'),
              ),
            ),
          ],
        ),
      ),
    ),
  );

  Widget _detalhe(
    ResultadoInvestimento resultado,
    int mes,
    Color cor,
    String letra,
  ) {
    final dados = resultado.evolucao[mes];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$letra · ${resultado.investimento.nome}',
          style: TextStyle(
            color: cor,
            fontWeight: FontWeight.w800,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 10),
        Text('Saldo: ${moeda(dados.saldo)}'),
        Text('Total aplicado: ${moeda(dados.totalAportado)}'),
        Text('Juros deste mês: ${moeda(dados.jurosDoMes)}'),
        Text('Rendimento acumulado: ${moeda(dados.rendimentoAcumulado)}'),
      ],
    );
  }
}
