/// Fotografia do investimento ao final de um mês (mês zero = início).
class EvolucaoMensal {
  const EvolucaoMensal({
    required this.mes,
    required this.saldo,
    required this.totalAportado,
    required this.jurosDoMes,
  });

  final int mes;
  final double saldo;
  final double totalAportado;
  final double jurosDoMes;

  double get rendimentoAcumulado => saldo - totalAportado;
}
