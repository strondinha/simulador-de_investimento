import 'package:flutter_test/flutter_test.dart';
import 'package:simulador_investimentos/utils/formatadores.dart';

void main() {
  test('lê valores brasileiros e decimais com ponto', () {
    final exemplos = <String, double>{
      '1.500,50': 1500.5,
      '1500,50': 1500.5,
      '1500.50': 1500.5,
      '1.500': 1500,
      '1.000.000': 1000000,
      '0,80': 0.8,
      '0.800': 0.8,
      'R\$ 1.234,56': 1234.56,
      '0': 0,
      '-1,50': -1.5,
    };
    exemplos.forEach(
      (texto, esperado) => expect(lerNumero(texto), esperado, reason: texto),
    );
  });

  test('não transforma texto inválido em um valor aceito', () {
    for (final texto in [
      '',
      'abc',
      'NaN',
      'Infinity',
      '1,2,3',
      '1.2.3',
      '1.23,45',
      '1e8',
      '--1',
    ]) {
      expect(lerNumero(texto), isNull, reason: texto);
    }
  });

  test('formata dinheiro com separador brasileiro e duas casas', () {
    expect(moeda(1234.5), 'R\$ 1.234,50');
    expect(moeda(0), 'R\$ 0,00');
    expect(moeda(-0.0000001), 'R\$ 0,00');
    expect(moeda(-0.01), 'R\$ -0,01');
    expect(percentual(0.8), '0,80%');
  });
}
