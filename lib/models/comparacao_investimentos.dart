import 'resultado_investimento.dart';

class ComparacaoInvestimentos {
  const ComparacaoInvestimentos({
    required this.primeiro,
    required this.segundo,
    required this.meses,
  });

  final ResultadoInvestimento primeiro;
  final ResultadoInvestimento segundo;
  final int meses;

  // A comparação usa os mesmos centavos exibidos nos cartões. Os cálculos
  // mensais continuam com a precisão completa no serviço.
  double get diferenca =>
      (_centavos(primeiro.montanteFinal) - _centavos(segundo.montanteFinal))
          .abs() /
      100;

  bool get empate => diferenca == 0;
  ResultadoInvestimento get maiorMontante =>
      primeiro.montanteFinal >= segundo.montanteFinal ? primeiro : segundo;

  int _centavos(double valor) => (valor * 100).round();
}
