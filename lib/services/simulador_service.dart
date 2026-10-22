import '../models/comparacao_investimentos.dart';
import '../models/evolucao_mensal.dart';
import '../models/investimento.dart';
import '../models/resultado_investimento.dart';

/// Regra de negócio independente da interface, para facilitar os testes.
class SimuladorService {
  static const int maxMeses = 600;
  static const double maxValorEntrada = 1000000000;
  static const double maxSaldo = 1000000000000;

  ResultadoInvestimento simular(Investimento investimento, int meses) {
    if (meses < 1 || meses > maxMeses) {
      throw ArgumentError('O período deve ser de 1 a $maxMeses meses.');
    }
    if (!_valorValido(investimento.capitalInicial) ||
        !_valorValido(investimento.aporteMensal) ||
        !investimento.taxaMensal.isFinite ||
        investimento.taxaMensal < 0 ||
        investimento.taxaMensal > 100) {
      throw ArgumentError('Os valores do investimento são inválidos.');
    }

    var saldo = investimento.capitalInicial;
    final taxa = investimento.taxaMensal / 100;
    final evolucao = <EvolucaoMensal>[
      EvolucaoMensal(mes: 0, saldo: saldo, totalAportado: saldo, jurosDoMes: 0),
    ];

    for (var mes = 1; mes <= meses; mes++) {
      // Primeiro rendem os recursos do mês anterior. O novo aporte entra
      // no FINAL do mês e passa a render a partir do mês seguinte.
      final juros = saldo * taxa;
      final totalAportado =
          investimento.capitalInicial + investimento.aporteMensal * mes;
      // Sem juros, o saldo é exatamente o total aplicado. Isso evita
      // resíduos de ponto flutuante após somar aportes com centavos.
      saldo = taxa == 0
          ? totalAportado
          : saldo + juros + investimento.aporteMensal;

      // Também impede estouro numérico em simulações exageradas.
      if (!saldo.isFinite || saldo > maxSaldo) {
        throw const FormatException(
          'A simulação ultrapassou o limite de R\$ 1 trilhão. '
          'Reduza o período, a taxa ou os valores e tente novamente.',
        );
      }

      evolucao.add(
        EvolucaoMensal(
          mes: mes,
          saldo: saldo,
          totalAportado: totalAportado,
          jurosDoMes: juros,
        ),
      );
    }
    // Não arredondamos o saldo a cada mês, para não acumular erros.
    // O arredondamento para centavos acontece apenas na exibição.
    return ResultadoInvestimento(
      investimento: investimento,
      evolucao: evolucao,
    );
  }

  ComparacaoInvestimentos comparar(
    Investimento primeiro,
    Investimento segundo,
    int meses,
  ) => ComparacaoInvestimentos(
    primeiro: simular(primeiro, meses),
    segundo: simular(segundo, meses),
    meses: meses,
  );

  bool _valorValido(double valor) =>
      valor.isFinite && valor >= 0 && valor <= maxValorEntrada;
}
