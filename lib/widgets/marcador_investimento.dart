import 'package:flutter/material.dart';

class MarcadorInvestimento extends StatelessWidget {
  const MarcadorInvestimento({
    required this.letra,
    required this.cor,
    required this.fundo,
    super.key,
  });
  final String letra;
  final Color cor;
  final Color fundo;

  @override
  Widget build(BuildContext context) => Container(
    width: 42,
    height: 42,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: fundo,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Text(
      letra,
      style: TextStyle(color: cor, fontSize: 19, fontWeight: FontWeight.w800),
    ),
  );
}
