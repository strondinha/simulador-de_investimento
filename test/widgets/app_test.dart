import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simulador_investimentos/app.dart';

void main() {
  Future<void> abrir(
    WidgetTester tester, {
    Size tamanho = const Size(1100, 1800),
  }) async {
    tester.view.physicalSize = tamanho;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const SimuladorApp());
    await tester.pumpAndSettle();
  }

  testWidgets('calcula, navega, consulta gráfico e preserva dados ao voltar', (
    tester,
  ) async {
    await abrir(tester);
    await tester.tap(find.byKey(const Key('comparar')));
    await tester.pumpAndSettle();
    expect(find.text('Sua comparação'), findsOneWidget);
    expect(find.byKey(const Key('montante_A')), findsOneWidget);
    expect(find.byKey(const Key('montante_B')), findsOneWidget);
    expect(find.textContaining('termina com'), findsOneWidget);

    await tester.ensureVisible(find.byKey(const Key('seletor_mes')));
    await tester.tap(find.text('Rendimento'));
    await tester.pumpAndSettle();
    await tester.drag(
      find.byKey(const Key('seletor_mes')),
      const Offset(-400, 0),
    );
    await tester.pumpAndSettle();
    expect(find.text('Mês 12'), findsNothing);

    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<TextFormField>(find.byKey(const Key('capital_A')))
          .controller!
          .text,
      '1000,00',
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('valida campos e período antes de navegar', (tester) async {
    await abrir(tester);
    await tester.enterText(find.byKey(const Key('capital_A')), '-5');
    await tester.enterText(find.byKey(const Key('taxa_B')), 'abc');
    await tester.enterText(find.byKey(const Key('meses')), '0');
    await tester.ensureVisible(find.byKey(const Key('comparar')));
    await tester.tap(find.byKey(const Key('comparar')));
    await tester.pumpAndSettle();
    expect(find.text('Use zero ou um valor positivo.'), findsOneWidget);
    expect(find.text('Informe uma taxa válida. Ex.: 0,80'), findsOneWidget);
    expect(find.text('Informe de 1 a 600 meses.'), findsOneWidget);
    expect(find.text('Sua comparação'), findsNothing);
  });

  testWidgets('funciona em celular estreito e nova simulação limpa os campos', (
    tester,
  ) async {
    await abrir(tester, tamanho: const Size(360, 780));
    await tester.ensureVisible(find.byKey(const Key('comparar')));
    await tester.tap(find.byKey(const Key('comparar')));
    await tester.pumpAndSettle();
    expect(find.text('Sua comparação'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.scrollUntilVisible(
      find.byKey(const Key('mes_12')),
      400,
      scrollable: find
          .descendant(
            of: find.byKey(const Key('lista_resultados')),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    await tester.tap(find.byKey(const Key('mes_12')));
    await tester.pumpAndSettle();
    expect(find.text('Detalhes do mês 12'), findsOneWidget);
    await tester.tap(find.text('Fechar'));
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.byKey(const Key('nova_simulacao')),
      300,
      scrollable: find
          .descendant(
            of: find.byKey(const Key('lista_resultados')),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    await tester.tap(find.byKey(const Key('nova_simulacao')));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(const Key('capital_A')));
    expect(
      tester
          .widget<TextFormField>(find.byKey(const Key('capital_A')))
          .controller!
          .text,
      '0,00',
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'perfil Windows em 1366 x 768 compara e permite voltar para editar',
    (tester) async {
      final plataformaAnterior = debugDefaultTargetPlatformOverride;
      debugDefaultTargetPlatformOverride = TargetPlatform.windows;
      try {
        await abrir(tester, tamanho: const Size(1366, 768));
        await tester.ensureVisible(find.byKey(const Key('comparar')));
        await tester.tap(find.byKey(const Key('comparar')));
        await tester.pumpAndSettle();
        expect(find.text('Sua comparação'), findsOneWidget);
        expect(find.byKey(const Key('montante_A')), findsOneWidget);
        expect(find.byKey(const Key('montante_B')), findsOneWidget);
        expect(find.text('R\$ 2.395,08'), findsOneWidget);
        expect(find.text('R\$ 2.354,57'), findsOneWidget);
        expect(tester.takeException(), isNull);
        await tester.tap(find.byType(BackButton));
        await tester.pumpAndSettle();
        expect(
          tester
              .widget<TextFormField>(find.byKey(const Key('capital_A')))
              .controller!
              .text,
          '1000,00',
        );
        expect(tester.takeException(), isNull);
      } finally {
        debugDefaultTargetPlatformOverride = plataformaAnterior;
      }
    },
  );
}
