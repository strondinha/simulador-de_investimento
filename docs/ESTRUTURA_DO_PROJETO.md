# Estrutura do projeto

## Fluxo principal

1. `lib/main.dart` inicia o aplicativo.
2. `lib/app.dart` configura o tema, o idioma e a tela inicial.
3. `lib/screens/simulacao_screen.dart` valida o formulário e solicita a comparação.
4. `lib/services/simulador_service.dart` calcula os juros e registra a evolução dos dois investimentos.
5. `lib/screens/resultados_screen.dart` apresenta os resultados, o gráfico e a lista mensal.

Ao voltar para editar, a tela inicial preserva os valores. Ao escolher uma nova simulação, os campos são zerados e o período volta para 12 meses.

## Arquivos Dart

| Arquivo | Responsabilidade |
| --- | --- |
| `lib/main.dart` | Ponto de entrada com `runApp` |
| `lib/app.dart` | Configuração geral do aplicativo |
| `lib/models/investimento.dart` | Nome, capital, aplicação mensal e taxa |
| `lib/models/evolucao_mensal.dart` | Saldo, aplicações e juros de cada mês |
| `lib/models/resultado_investimento.dart` | Resultado e evolução de um investimento |
| `lib/models/comparacao_investimentos.dart` | Diferença e comparação dos montantes |
| `lib/controllers/campos_investimento_controller.dart` | Controllers, preenchimento e leitura dos campos |
| `lib/services/simulador_service.dart` | Juros compostos, limites e comparação |
| `lib/screens/simulacao_screen.dart` | Formulário e navegação para os resultados |
| `lib/screens/resultados_screen.dart` | Comparação, consulta do gráfico e evolução mensal |
| `lib/widgets/investimento_form_card.dart` | Formulário reutilizado para A e B |
| `lib/widgets/resultado_card.dart` | Resumo de cada investimento |
| `lib/widgets/grafico_comparativo.dart` | Gráfico com `CustomPainter` |
| `lib/widgets/painel.dart` | Painel reutilizado nas telas |
| `lib/widgets/marcador_investimento.dart` | Identificação visual de A e B |
| `lib/widgets/nota_informativa.dart` | Observações sobre a simulação |
| `lib/theme/app_theme.dart` | Cores, fontes, campos e botões |
| `lib/utils/formatadores.dart` | Conversão e formatação dos números |

## Pastas de apoio

| Pasta | Conteúdo |
| --- | --- |
| `test/unit/` | Testes da matemática, dos limites e dos formatos numéricos |
| `test/widgets/` | Testes do formulário, navegação, gráfico e adaptação da interface |
| `assets/fonts/` | Fontes locais com licença |
| `web/` | HTML, manifesto e ícones do navegador |
| `android/` | Gradle, manifesto, atividade principal e ícones Android |
| `scripts/windows/` | Execução, testes e diagnóstico do Flutter |
| `scripts/unix/` | Execução no navegador em Linux/macOS |
| `docs/` | Guias do projeto |

## Estado e recursos

A tela inicial usa `setState` para o período, as mensagens e o preenchimento dos campos. A tela de resultados usa `setState` para a seleção do mês e a troca entre saldo e rendimento. A navegação é feita com `Navigator`.

Os `TextEditingController` são descartados em `dispose`. O serviço de cálculo não depende da interface e pode ser testado separadamente. A lista mensal usa `SliverList` para criar os itens conforme aparecem na tela.

## Formatação e arquivos gerados

O projeto usa o formatador oficial do Dart e indentação de dois espaços. A configuração do VS Code formata o código ao salvar.

Os arquivos produzidos pelo Flutter ficam em `build` e `.dart_tool`. Eles não fazem parte do código para editar e são ignorados pelo Git. As alterações das telas e dos cálculos devem ser feitas em `lib`.
