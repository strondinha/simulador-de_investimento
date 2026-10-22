import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Cartão usado em diferentes telas para manter a mesma identidade visual.
class Painel extends StatelessWidget {
  const Painel({required this.child, this.padding = 24, super.key});
  final Widget child;
  final double padding;

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.all(padding),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(22),
      border: Border.all(color: AppColors.border),
    ),
    child: child,
  );
}
