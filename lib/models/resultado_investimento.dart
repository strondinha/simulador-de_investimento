import 'evolucao_mensal.dart';
import 'investimento.dart';

class ResultadoInvestimento {
  ResultadoInvestimento({
    required this.investimento,
    required List<EvolucaoMensal> evolucao,
  }) : evolucao = List.unmodifiable(evolucao);

  final Investimento investimento;
  final List<EvolucaoMensal> evolucao;

  EvolucaoMensal get ultimoMes => evolucao.last;
  double get montanteFinal => ultimoMes.saldo;
  double get totalAportado => ultimoMes.totalAportado;
  double get rendimentoTotal => ultimoMes.rendimentoAcumulado;
}
