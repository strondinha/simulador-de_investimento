import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:simulador_investimentos/models/investimento.dart';
import 'package:simulador_investimentos/services/simulador_service.dart';

void main() {
  final simulador = SimuladorService();
  Investimento dados({
    double capital = 1000,
    double aporte = 100,
    double taxa = 1,
  }) => Investimento(
    nome: 'Teste',
    capitalInicial: capital,
    aporteMensal: aporte,
    taxaMensal: taxa,
  );

  test('aplica juros antes do aporte e registra o mês zero', () {
    final resultado = simulador.simular(dados(), 2);
    expect(resultado.evolucao, hasLength(3));
    expect(resultado.evolucao.first.saldo, 1000);
    expect(resultado.evolucao[1].saldo, closeTo(1110, 0.000001));
    expect(resultado.evolucao[1].jurosDoMes, closeTo(10, 0.000001));
    expect(resultado.montanteFinal, closeTo(1221.1, 0.000001));
    expect(resultado.totalAportado, 1200);
    expect(resultado.rendimentoTotal, closeTo(21.1, 0.000001));
  });

  test(
    'confere a recorrência com a fórmula de juros compostos com aportes',
    () {
      const capital = 1500.0;
      const aporte = 250.0;
      const taxa = 0.008;
      const meses = 36;
      final fator = math.pow(1 + taxa, meses);
      final esperado = capital * fator + aporte * (fator - 1) / taxa;
      final resultado = simulador.simular(
        dados(capital: capital, aporte: aporte, taxa: taxa * 100),
        meses,
      );
      expect(resultado.montanteFinal, closeTo(esperado, 0.000001));
      expect(resultado.evolucao.last.mes, meses);
    },
  );

  test('juros zero não causam divisão por zero', () {
    final resultado = simulador.simular(dados(taxa: 0), 6);
    expect(resultado.montanteFinal, closeTo(1600, 0.000001));
    expect(resultado.rendimentoTotal, closeTo(0, 0.000001));
  });

  test('aportes com centavos e taxa zero não criam rendimento residual', () {
    final resultado = simulador.simular(
      dados(capital: 0.1, aporte: 0.1, taxa: 0),
      600,
    );
    for (final mes in resultado.evolucao) {
      expect(mes.saldo, mes.totalAportado);
      expect(mes.rendimentoAcumulado, 0);
      expect(mes.jurosDoMes, 0);
    }
  });

  test('sem aporte, capital rende sozinho', () {
    final resultado = simulador.simular(dados(aporte: 0), 12);
    expect(
      resultado.montanteFinal,
      closeTo(1000 * math.pow(1.01, 12), 0.000001),
    );
    expect(resultado.totalAportado, 1000);
  });

  test('capital e aportes zero são uma simulação válida', () {
    final resultado = simulador.simular(dados(capital: 0, aporte: 0), 600);
    expect(resultado.montanteFinal, 0);
    expect(resultado.rendimentoTotal, 0);
    expect(resultado.evolucao, hasLength(601));
  });

  test('compara maior montante e identifica empate', () {
    final resultado = simulador.comparar(dados(), dados(taxa: 0.8), 12);
    expect(resultado.empate, isFalse);
    expect(resultado.maiorMontante, same(resultado.primeiro));
    expect(resultado.diferenca, 40.51);
    expect(simulador.comparar(dados(), dados(), 12).empate, isTrue);
  });

  test('diferença e empate correspondem aos centavos exibidos', () {
    final diferentes = simulador.comparar(
      dados(capital: 100.004, aporte: 0, taxa: 0),
      dados(capital: 100.006, aporte: 0, taxa: 0),
      1,
    );
    expect(diferentes.empate, isFalse);
    expect(diferentes.diferenca, 0.01);
    expect(diferentes.maiorMontante, same(diferentes.segundo));

    final iguais = simulador.comparar(
      dados(capital: 100.001, aporte: 0, taxa: 0),
      dados(capital: 100.004, aporte: 0, taxa: 0),
      1,
    );
    expect(iguais.empate, isTrue);
    expect(iguais.diferenca, 0);
  });

  test('rejeita período inválido, negativos, NaN e infinito', () {
    for (final meses in [0, -1, 601]) {
      expect(() => simulador.simular(dados(), meses), throwsArgumentError);
    }
    for (final invalido in [
      dados(capital: -1),
      dados(aporte: -1),
      dados(taxa: -1),
      dados(taxa: 101),
      dados(capital: double.nan),
      dados(aporte: double.infinity),
      dados(taxa: double.nan),
      dados(capital: SimuladorService.maxValorEntrada + 1),
    ]) {
      expect(() => simulador.simular(invalido, 12), throwsArgumentError);
    }
  });

  test(
    'interrompe valores excessivos antes de perder precisão ou estourar',
    () {
      expect(
        () => simulador.simular(dados(taxa: 100), 600),
        throwsFormatException,
      );
    },
  );
}
