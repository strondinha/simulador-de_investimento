# Validação

Revisão de 22/10/2026, realizada com Flutter 3.35.7 e Dart 3.9.2 em Linux.

| Verificação | Resultado |
| --- | --- |
| Formatação | 21 arquivos Dart no padrão do formatador oficial |
| Análise estática | Nenhum problema apontado por `flutter analyze --no-pub` |
| Testes | 17 testes aprovados |
| Compilação web | Versão release gerada com sucesso |
| Interface | Formulário e resultados revisados por captura dos widgets renderizados pelo Flutter |
| Tamanhos de tela | Fluxo testado em 1366 × 768 e 360 × 780 pixels |
| Servidor web | HTML e bootstrap respondendo HTTP 200 em teste local |
| Arquivos de apoio | JSON, XML, links internos, imports e sintaxe dos scripts conferidos |
| Pacote | Fontes, configurações e testes separados dos caches e arquivos compilados |

## Casos cobertos

- Juros antes do aporte mensal e registro do capital no mês zero.
- Conferência do saldo por uma fórmula independente de juros compostos com aportes.
- Taxa zero, ausência de aportes, valores zerados e prazo máximo.
- Aportes com centavos sem rendimento residual quando a taxa é zero.
- Comparação e empate coerentes com os montantes exibidos em centavos.
- Rejeição de entradas inválidas e interrupção de saldos acima do limite.
- Leitura de valores brasileiros e formatação monetária.
- Formulário, navegação, seleção do gráfico e preservação dos dados ao voltar.
- Consulta dos detalhes mensais e limpeza dos campos para outra simulação.

A interface foi verificada com Flutter Test, e a versão web foi compilada e servida por HTTP. Os atalhos `.bat` dependem do ambiente Windows e não foram executados no computador do usuário. O script `verificar_flutter.bat` permite conferir o SDK e o navegador nesse computador. A compilação Android não fez parte desta revisão.
