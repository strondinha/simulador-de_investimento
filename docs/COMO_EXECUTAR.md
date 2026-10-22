# Como executar

## Abrir no VS Code

Extraia o ZIP inteiro. Abra a pasta que contém `pubspec.yaml`, ou dê dois cliques em `Simulador_Investimentos.code-workspace`.

Os arquivos Dart do aplicativo ficam em `lib`. Comece por `main.dart`, depois veja `app.dart` e as duas telas em `screens`.

## Executar no navegador

Com o Flutter disponível no terminal:

```powershell
flutter pub get
flutter run -d chrome --no-web-resources-cdn
```

Para usar Edge no Windows, troque `chrome` por `edge`. No Windows, `scripts/windows/iniciar.bat` faz o mesmo processo. Para passar a opção Edge pelo PowerShell:

```powershell
.\scripts\windows\iniciar.bat edge
```

Aguarde o terminal informar que o aplicativo está em execução. Mantenha esse terminal aberto enquanto usa o app. Para encerrar, pressione `q` nele.

## Conferir o ambiente

```powershell
flutter --version
flutter doctor -v
flutter devices
```

A lista de dispositivos deve mostrar o navegador escolhido. Se Flutter não for reconhecido, siga [Instalar o Flutter no Windows](INSTALAR_FLUTTER_WINDOWS.md).

| Problema | O que conferir |
| --- | --- |
| Flutter não é reconhecido | Instalação do SDK, entrada `bin` no PATH e reinício do terminal |
| Chrome não aparece | Instalação do navegador; tente Edge ou execute `flutter config --enable-web` e confira `flutter devices` novamente |
| O terminal não encontra `pubspec.yaml` | Abra o terminal na raiz do projeto, junto desse arquivo |
| Falha no download das dependências | Conexão com a internet e saída de `flutter pub get` |
| Avisos de Android ou Visual Studio no doctor | Essas ferramentas atendem outras plataformas; para este teste, confira Flutter e o navegador |
| Campos indicam erro | Use números válidos e confira o período de 1 a 600 meses |

## Testes e formatação

```bash
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test
```

Se o primeiro comando apontar arquivos fora do padrão, execute `dart format lib test`. O atalho Windows `scripts/windows/testar.bat` verifica dependências, formatação, análise e testes.

## Gerar a versão web

```bash
flutter build web --release --no-web-resources-cdn --pwa-strategy=none --no-tree-shake-icons --no-wasm-dry-run
```

O resultado fica em `build/web`. Para abrir o aplicativo durante o desenvolvimento, use `flutter run`; os arquivos de uma compilação web devem ser servidos por HTTP.

## Android

O projeto também inclui a configuração Android. Caso queira usar essa plataforma depois, configure o Android SDK, consulte `flutter devices` e execute `flutter run -d ID_DO_DISPOSITIVO`.
