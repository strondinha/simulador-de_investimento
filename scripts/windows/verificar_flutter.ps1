$ErrorActionPreference = 'Stop'
Write-Host 'VERIFICACAO DO FLUTTER' -ForegroundColor Cyan
Write-Host ''

$comando = Get-Command flutter -CommandType Application -ErrorAction SilentlyContinue | Select-Object -First 1
$flutterEncontrado = $null
if ($comando) {
    $flutterEncontrado = $comando.Source
    Write-Host "Flutter localizado no PATH: $flutterEncontrado" -ForegroundColor Green
} else {
    $candidatos = @(
        "$env:USERPROFILE\develop\flutter\bin\flutter.bat",
        "$env:USERPROFILE\development\flutter\bin\flutter.bat",
        "$env:USERPROFILE\flutter\bin\flutter.bat",
        'C:\src\flutter\bin\flutter.bat',
        'C:\dev\flutter\bin\flutter.bat'
    )
    foreach ($candidato in $candidatos) {
        if (Test-Path -LiteralPath $candidato) {
            $flutterEncontrado = $candidato
            break
        }
    }
    if ($flutterEncontrado) {
        Write-Host "Flutter encontrado fora do PATH: $flutterEncontrado" -ForegroundColor Yellow
        Write-Host 'Adicione a pasta bin desse SDK ao PATH e reabra o VS Code.'
    } else {
        Write-Host 'Flutter nao foi localizado no PATH nem nas pastas comuns verificadas.' -ForegroundColor Yellow
        Write-Host 'Ele pode estar em outra pasta. A extensao instalada no VS Code, sozinha, nao comprova que o SDK esta instalado.'
        Write-Host 'Veja docs\INSTALAR_FLUTTER_WINDOWS.md para instalar ou localizar o SDK.'
    }
}

Write-Host ''
$gitEncontrado = Get-Command git -CommandType Application -ErrorAction SilentlyContinue | Select-Object -First 1
if ($gitEncontrado) {
    & $gitEncontrado.Source --version
} else {
    Write-Host 'Git nao localizado no PATH. Veja o guia de instalacao.' -ForegroundColor Yellow
}

if ($flutterEncontrado) {
    Write-Host ''
    Write-Host 'VERSAO DO FLUTTER' -ForegroundColor Cyan
    & $flutterEncontrado --version
    Write-Host ''
    Write-Host 'DIAGNOSTICO DO AMBIENTE' -ForegroundColor Cyan
    & $flutterEncontrado doctor -v
    Write-Host ''
    Write-Host 'No Windows, confira principalmente Flutter, Git e Chrome para testar no navegador.'
}
