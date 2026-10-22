import 'package:flutter/material.dart';

import '../models/resultado_investimento.dart';
import '../theme/app_theme.dart';
import '../utils/formatadores.dart';
import 'marcador_investimento.dart';
import 'painel.dart';

class ResultadoCard extends StatelessWidget {
  const ResultadoCard({
    required this.resultado,
    required this.letra,
    required this.cor,
    required this.fundo,
    super.key,
  });
  final ResultadoInvestimento resultado;
  final String letra;
  final Color cor;
  final Color fundo;

  @override
  Widget build(BuildContext context) => Painel(
    padding: 18,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MarcadorInvestimento(letra: letra, cor: cor, fundo: fundo),
        const SizedBox(height: 12),
        Text(
          resultado.investimento.nome,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 4),
        Text(
          '${percentual(resultado.investimento.taxaMensal)} ao mês',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 22),
        const Text(
          'Montante final',
          style: TextStyle(color: AppColors.muted, fontSize: 12),
        ),
        const SizedBox(height: 5),
        SizedBox(
          width: double.infinity,
          child: FittedBox(
            alignment: Alignment.centerLeft,
            fit: BoxFit.scaleDown,
            child: Text(
              moeda(resultado.montanteFinal),
              key: Key('montante_$letra'),
              style: TextStyle(
                fontSize: 29,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.8,
                color: cor,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        const Divider(color: AppColors.border, height: 1),
        const SizedBox(height: 16),
        _linha('Total aplicado', resultado.totalAportado),
        const SizedBox(height: 12),
        _linha('Rendimento total', resultado.rendimentoTotal, destaque: true),
      ],
    ),
  );

  Widget _linha(String titulo, double valor, {bool destaque = false}) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        titulo,
        style: const TextStyle(color: AppColors.muted, fontSize: 12),
      ),
      const SizedBox(height: 3),
      SizedBox(
        width: double.infinity,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            moeda(valor),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: destaque ? cor : AppColors.ink,
            ),
          ),
        ),
      ),
    ],
  );
}
