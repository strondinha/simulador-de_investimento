# Verificar e instalar o Flutter no Windows

## 1. Verificar se já está instalado

No VS Code, abra **Terminal > Novo Terminal**. Digite um comando por vez:

```powershell
where.exe flutter
flutter --version
flutter doctor -v
```

- `where.exe flutter` mostra onde o comando foi encontrado no PATH.
- `flutter --version` mostra as versões do Flutter e do Dart.
- `flutter doctor -v` informa quais ferramentas estão prontas e quais faltam.

Se aparecer “flutter não é reconhecido” ou “o termo flutter não é reconhecido”, isso significa que o terminal não localizou o comando. O SDK pode não estar instalado ou pode estar fora do PATH.

Há uma verificação pronta em `scripts/windows/verificar_flutter.bat`. Ela procura o comando e algumas pastas comuns, mostra a versão encontrada e executa o diagnóstico. O script não instala nem altera o PATH automaticamente.

Ter a extensão Flutter no VS Code não significa, por si só, que o Flutter SDK esteja instalado.

## 2. Instalar usando o VS Code

1. Verifique o Git com `git --version`. Se não estiver disponível, instale o [Git for Windows](https://git-scm.com/downloads/win) e reabra o VS Code.
2. No VS Code, pressione **Ctrl + Shift + X**. Procure **Flutter**, da **Dart Code**, e instale. A extensão Dart acompanha essa instalação.
3. Pressione **Ctrl + Shift + P** e procure **Flutter: New Project**.
4. Se o editor pedir a localização do SDK, escolha **Download SDK**. Se o SDK já existir, escolha a pasta dele em vez de baixar outra cópia.
5. Escolha uma pasta simples para o SDK. Exemplo: crie `C:\src` e selecione essa pasta para que o Flutter fique em `C:\src\flutter`.
6. Escolha **Clone Flutter** e aguarde a conclusão.
7. Quando aparecer a opção **Add SDK to PATH**, use-a.
8. Feche os terminais, reinicie o VS Code e execute novamente os três comandos da primeira seção.

Esse processo instala o SDK. Você não precisa criar outro aplicativo: depois, abra a pasta do projeto que acompanha este ZIP.

Fonte: [Instalação oficial com VS Code](https://docs.flutter.dev/install/with-vs-code).

## 3. Se o Flutter existe, mas não é reconhecido

Confirme se existe o arquivo `C:\src\flutter\bin\flutter.bat`. Se o SDK estiver em outro lugar, use o caminho real.

1. Abra o menu Iniciar e pesquise **Editar as variáveis de ambiente da sua conta**.
2. Em **Variáveis do usuário**, selecione **Path** e clique em **Editar**.
3. Clique em **Novo** e acrescente a pasta `bin` do SDK. Exemplo: `C:\src\flutter\bin`.
4. Confirme as janelas e reabra o VS Code.
5. Execute `flutter --version`.

Não apague as outras entradas do PATH. A pasta adicionada precisa ser a do Flutter SDK, não a pasta do projeto.

Referência: [Adicionar Flutter ao PATH](https://docs.flutter.dev/install/add-to-path).

## 4. Entender o resultado do doctor

Para este primeiro teste no Windows, confira principalmente Flutter, Git e Chrome/Edge. Você pode testar no navegador antes de configurar Android Studio ou Visual Studio para aplicativos Windows nativos.

- **Android toolchain:** necessário para executar no Android e gerar APK.
- **Visual Studio:** usado para compilar executáveis Windows; é diferente do VS Code.

Um aviso sobre uma plataforma que você ainda não vai usar não significa, sozinho, que o projeto está com defeito.

## 5. Abrir e executar este projeto

Extraia o ZIP inteiro. Abra `Simulador_Investimentos.code-workspace`, ou use **Arquivo > Abrir Pasta** e escolha a pasta que contém `pubspec.yaml`.

No terminal dessa pasta:

```powershell
flutter pub get
flutter run -d chrome --no-web-resources-cdn
```

O primeiro comando baixa as dependências. O segundo abre o aplicativo no Chrome. Para usar Edge no Windows, troque o segundo comando por `flutter run -d edge --no-web-resources-cdn`.

Se preferir, abra `scripts/windows/iniciar.bat`.

Para conferir o projeto:

```powershell
dart format lib test
flutter analyze
flutter test
```

O primeiro uso precisa de conexão com a internet para obter o SDK e as dependências. Este aplicativo não consulta serviços externos para fazer os cálculos.
