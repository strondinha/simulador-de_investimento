/// Aceita 1500,50, 1.500,50 e 1500.50. Um ponto seguido de três
/// dígitos (1.500) representa milhar, conforme o padrão brasileiro.
/// Valores inválidos retornam null em vez de virarem zero silenciosamente.
double? lerNumero(String texto) {
  var valor = texto.trim().replaceAll(RegExp(r'\s'), '');
  valor = valor.replaceFirst(RegExp(r'^R\$'), '');
  if (valor.isEmpty) return null;

  if (valor.contains(',')) {
    if (!RegExp(r'^-?(?:\d+|\d{1,3}(?:\.\d{3})+),\d+$').hasMatch(valor)) {
      return null;
    }
    valor = valor.replaceAll('.', '').replaceAll(',', '.');
  } else if (RegExp(r'^-?[1-9]\d{0,2}(?:\.\d{3})+$').hasMatch(valor)) {
    valor = valor.replaceAll('.', '');
  } else if (!RegExp(r'^-?\d+(?:\.\d+)?$').hasMatch(valor)) {
    return null;
  }
  final numero = double.tryParse(valor);
  return numero != null && numero.isFinite ? numero : null;
}

String numeroBr(double valor, {int casas = 2}) {
  final arredondado = valor.abs().toStringAsFixed(casas);
  final partes = arredondado.split('.');
  final inteiro = partes[0].replaceAllMapped(
    RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
    (match) => '${match[1]}.',
  );
  final sinal = valor < 0 && double.parse(arredondado) > 0 ? '-' : '';
  return '$sinal$inteiro${casas > 0 ? ',${partes[1]}' : ''}';
}

String moeda(double valor) => 'R\$ ${numeroBr(valor)}';
String percentual(double valor) => '${numeroBr(valor)}%';

String moedaCurta(double valor) {
  if (valor >= 1000000000) {
    return 'R\$ ${numeroBr(valor / 1000000000, casas: 1)} bi';
  }
  if (valor >= 1000000) return 'R\$ ${numeroBr(valor / 1000000, casas: 1)} mi';
  if (valor >= 1000) return 'R\$ ${numeroBr(valor / 1000, casas: 1)} mil';
  return 'R\$ ${numeroBr(valor, casas: 0)}';
}
