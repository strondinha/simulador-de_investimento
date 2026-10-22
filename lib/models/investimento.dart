/// Valores informados no formulário. A taxa é mensal e está em porcentagem.
class Investimento {
  const Investimento({
    required this.nome,
    required this.capitalInicial,
    required this.aporteMensal,
    required this.taxaMensal,
  });

  final String nome;
  final double capitalInicial;
  final double aporteMensal;
  final double taxaMensal;
}
