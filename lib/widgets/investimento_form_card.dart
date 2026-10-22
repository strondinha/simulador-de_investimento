import 'package:flutter/material.dart';

import '../controllers/campos_investimento_controller.dart';
import '../services/simulador_service.dart';
import '../utils/formatadores.dart';
import 'marcador_investimento.dart';
import 'painel.dart';

class InvestimentoFormCard extends StatelessWidget {
  const InvestimentoFormCard({
    required this.campos,
    required this.letra,
    required this.cor,
    required this.fundo,
    super.key,
  });
  final CamposInvestimentoController campos;
  final String letra;
  final Color cor;
  final Color fundo;

  String? _validarValor(String? texto) {
    final valor = lerNumero(texto ?? '');
    if (valor == null) return 'Informe um número válido. Ex.: 1000,50';
    if (valor < 0) return 'Use zero ou um valor positivo.';
    if (valor > SimuladorService.maxValorEntrada) {
      return 'O limite é R\$ 1 bilhão por campo.';
    }
    return null;
  }

  String? _validarTaxa(String? texto) {
    final taxa = lerNumero(texto ?? '');
    if (taxa == null) return 'Informe uma taxa válida. Ex.: 0,80';
    if (taxa < 0 || taxa > 100) {
      return 'A taxa mensal deve ficar entre 0% e 100%.';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) => Painel(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            MarcadorInvestimento(letra: letra, cor: cor, fundo: fundo),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Investimento $letra',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            Icon(Icons.savings_outlined, color: cor),
          ],
        ),
        const SizedBox(height: 24),
        TextFormField(
          key: Key('nome_$letra'),
          controller: campos.nome,
          textCapitalization: TextCapitalization.sentences,
          textInputAction: TextInputAction.next,
          maxLength: 32,
          decoration: const InputDecoration(
            labelText: 'Nome do investimento',
            counterText: '',
          ),
          validator: (valor) => valor == null || valor.trim().isEmpty
              ? 'Dê um nome ao investimento.'
              : null,
        ),
        const SizedBox(height: 20),
        TextFormField(
          key: Key('capital_$letra'),
          controller: campos.capital,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(
            labelText: 'Capital inicial',
            prefixText: 'R\$ ',
          ),
          validator: _validarValor,
        ),
        const SizedBox(height: 20),
        TextFormField(
          key: Key('aporte_$letra'),
          controller: campos.aporte,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(
            labelText: 'Aplicação mensal',
            prefixText: 'R\$ ',
          ),
          validator: _validarValor,
        ),
        const SizedBox(height: 20),
        TextFormField(
          key: Key('taxa_$letra'),
          controller: campos.taxa,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          textInputAction: TextInputAction.done,
          decoration: const InputDecoration(
            labelText: 'Taxa de juros mensal',
            suffixText: '% ao mês',
          ),
          validator: _validarTaxa,
        ),
        const SizedBox(height: 12),
        Text(
          'Use vírgula nos centavos. Ex.: 1.000,50',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    ),
  );
}
