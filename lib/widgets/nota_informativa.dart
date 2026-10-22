import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class NotaInformativa extends StatelessWidget {
  const NotaInformativa({required this.texto, super.key});
  final String texto;

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Icon(Icons.info_outline_rounded, size: 18, color: AppColors.muted),
      const SizedBox(width: 9),
      Expanded(
        child: Text(texto, style: Theme.of(context).textTheme.bodySmall),
      ),
    ],
  );
}
