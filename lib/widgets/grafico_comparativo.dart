import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/comparacao_investimentos.dart';
import '../models/evolucao_mensal.dart';
import '../models/resultado_investimento.dart';
import '../theme/app_theme.dart';
import '../utils/formatadores.dart';

/// Gráfico desenhado com o próprio Flutter, sem depender de um pacote externo.
class GraficoComparativo extends StatelessWidget {
  const GraficoComparativo({
    required this.comparacao,
    required this.mesSelecionado,
    required this.mostrarRendimento,
    super.key,
  });
  final ComparacaoInvestimentos comparacao;
  final int mesSelecionado;
  final bool mostrarRendimento;

  @override
  Widget build(BuildContext context) => Semantics(
    label:
        'Gráfico comparativo de ${mostrarRendimento ? 'rendimentos' : 'saldos'}. '
        'Os valores exatos estão abaixo e na lista mensal.',
    image: true,
    child: SizedBox(
      height: 220,
      width: double.infinity,
      child: CustomPaint(
        painter: _GraficoPainter(
          comparacao: comparacao,
          mesSelecionado: mesSelecionado,
          mostrarRendimento: mostrarRendimento,
        ),
      ),
    ),
  );
}

class _GraficoPainter extends CustomPainter {
  _GraficoPainter({
    required this.comparacao,
    required this.mesSelecionado,
    required this.mostrarRendimento,
  });
  final ComparacaoInvestimentos comparacao;
  final int mesSelecionado;
  final bool mostrarRendimento;

  double _valor(EvolucaoMensal mes) =>
      mostrarRendimento ? mes.rendimentoAcumulado : mes.saldo;

  @override
  void paint(Canvas canvas, Size size) {
    const esquerda = 68.0;
    const topo = 18.0;
    final largura = math.max(1.0, size.width - esquerda - 12);
    final altura = size.height - topo - 32;
    final maximo =
        math.max(
          1.0,
          math.max(
            _valor(comparacao.primeiro.ultimoMes),
            _valor(comparacao.segundo.ultimoMes),
          ),
        ) *
        1.12;
    final base = topo + altura;
    Offset ponto(EvolucaoMensal mes) => Offset(
      esquerda + largura * mes.mes / comparacao.meses,
      base - altura * math.max(0, _valor(mes)) / maximo,
    );

    for (var i = 0; i <= 3; i++) {
      final y = topo + altura * i / 3;
      canvas.drawLine(
        Offset(esquerda, y),
        Offset(esquerda + largura, y),
        Paint()
          ..color = AppColors.border
          ..strokeWidth = 1,
      );
      _texto(canvas, moedaCurta(maximo * (3 - i) / 3), Offset(0, y - 7));
    }
    _texto(canvas, 'Início', Offset(esquerda, base + 11));
    final finalTexto = '${comparacao.meses} meses';
    _texto(canvas, finalTexto, Offset(esquerda + largura - 56, base + 11));

    void desenhar(ResultadoInvestimento resultado, Color cor) {
      final caminho = Path();
      final primeiro = ponto(resultado.evolucao.first);
      caminho.moveTo(primeiro.dx, primeiro.dy);
      for (final mes in resultado.evolucao.skip(1)) {
        final posicao = ponto(mes);
        caminho.lineTo(posicao.dx, posicao.dy);
      }
      final area = Path.from(caminho)
        ..lineTo(esquerda + largura, base)
        ..lineTo(esquerda, base)
        ..close();
      canvas.drawPath(area, Paint()..color = cor.withValues(alpha: 0.06));
      canvas.drawPath(
        caminho,
        Paint()
          ..color = cor
          ..strokeWidth = 3
          ..style = PaintingStyle.stroke
          ..strokeJoin = StrokeJoin.round,
      );
      final posicao = ponto(resultado.evolucao[mesSelecionado]);
      canvas.drawCircle(posicao, 6, Paint()..color = Colors.white);
      canvas.drawCircle(posicao, 4, Paint()..color = cor);
    }

    final xSelecionado = esquerda + largura * mesSelecionado / comparacao.meses;
    canvas.drawLine(
      Offset(xSelecionado, topo),
      Offset(xSelecionado, base),
      Paint()
        ..color = AppColors.muted.withValues(alpha: 0.3)
        ..strokeWidth = 1,
    );
    desenhar(comparacao.segundo, AppColors.orange);
    desenhar(comparacao.primeiro, AppColors.green);
  }

  void _texto(Canvas canvas, String texto, Offset posicao) {
    final painter = TextPainter(
      text: TextSpan(
        text: texto,
        style: const TextStyle(
          fontFamily: 'InvesteRoboto',
          fontSize: 10,
          color: AppColors.muted,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(canvas, posicao);
  }

  @override
  bool shouldRepaint(covariant _GraficoPainter oldDelegate) =>
      comparacao != oldDelegate.comparacao ||
      mesSelecionado != oldDelegate.mesSelecionado ||
      mostrarRendimento != oldDelegate.mostrarRendimento;
}
