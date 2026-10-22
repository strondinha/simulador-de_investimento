import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'screens/simulacao_screen.dart';
import 'theme/app_theme.dart';

class SimuladorApp extends StatelessWidget {
  const SimuladorApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Investe • Simulador de Investimentos',
    debugShowCheckedModeBanner: false,
    theme: criarTema(),
    locale: const Locale('pt', 'BR'),
    supportedLocales: const [Locale('pt', 'BR')],
    localizationsDelegates: GlobalMaterialLocalizations.delegates,
    home: const SimulacaoScreen(),
  );
}
