import 'package:flutter/material.dart';

import '../models/investimento.dart';
import '../utils/formatadores.dart';

/// Os controllers pertencem à tela e são descartados em dispose().
class CamposInvestimentoController {
  CamposInvestimentoController(String nome)
    : nome = TextEditingController(text: nome),
      capital = TextEditingController(text: '1000,00'),
      aporte = TextEditingController(text: '100,00'),
      taxa = TextEditingController(text: '1,00');

  final TextEditingController nome;
  final TextEditingController capital;
  final TextEditingController aporte;
  final TextEditingController taxa;

  Investimento ler() => Investimento(
    nome: nome.text.trim(),
    capitalInicial: lerNumero(capital.text)!,
    aporteMensal: lerNumero(aporte.text)!,
    taxaMensal: lerNumero(taxa.text)!,
  );

  void preencher({
    required String nome,
    String capital = '0,00',
    String aporte = '0,00',
    String taxa = '0,00',
  }) {
    this.nome.text = nome;
    this.capital.text = capital;
    this.aporte.text = aporte;
    this.taxa.text = taxa;
  }

  void dispose() {
    nome.dispose();
    capital.dispose();
    aporte.dispose();
    taxa.dispose();
  }
}
