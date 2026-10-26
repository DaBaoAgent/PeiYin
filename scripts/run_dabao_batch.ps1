# run_dabao_batch.ps1

> 徐艾伦历史口播 · 批量配音脚本（可复用模板）
> 用法：编辑下方【任务表】后执行 `./run_dabao_batch.ps1`（在项目根目录的 PowerShell 中）
> 依赖：本机 GPT-SoVITS api_v2 服务（127.0.0.1:9880，`dabao_tts.py` 可自动拉起/复用）

$ErrorActionPreference = 'Continue'

# ── 配置区：按本机环境修改 ──────────────────────────
$py       = "D:\GPT-SoVITS\.venv\Scripts\python.exe"   # TTS 引擎 Python 解释器
$engine   = "D:\GPT-SoVITS\dabao_tts.py"               # dabao TTS 主脚本
$textDir  = Join-Path $PSScriptRoot "..\workdir\tts"    # TTS 输入目录：XX_全篇.txt
$outBase  = Join-Path $PSScriptRoot "..\出稿"            # 输出目录：0XX_人物名\配音.wav
$log      = Join-Path $PSScriptRoot "..\workdir\logs\batch_$(Get-Date -Format 'yyyyMMdd_HHmmss').log"

# ── 任务表：按需增删（n=人物目录名，txt=workdir/tts 下的输入文件名）──
$jobs = @(
    @{ n = '012_商纣王';  txt = '商纣王_全篇.txt'  }
    # 新增任务照此追加：@{ n = '038_人物名'; txt = '人物名_全篇.txt' }
)

# ── 执行（一般无需修改）──────────────────────────────
"BATCH START $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" | Out-File -LiteralPath $log -Encoding utf8
foreach ($j in $jobs) {
    $outDir = Join-Path $outBase $j.n
    if (-not (Test-Path -LiteralPath $outDir)) { New-Item -ItemType Directory -Path $outDir | Out-Null }
    $txt = Join-Path $textDir $j.txt
    $wav = Join-Path $outDir '配音.wav'
    $so  = Join-Path $outDir 'run_stdout.log'
    if (-not (Test-Path -LiteralPath $txt)) {
        "SKIP $($j.n): 缺少输入 $txt" | Out-File -LiteralPath $log -Append -Encoding utf8
        continue
    }
    "===== START $($j.n) $(Get-Date -Format 'HH:mm:ss') =====" | Out-File -LiteralPath $log -Append -Encoding utf8
    & $py -X utf8 $engine --text-file $txt --out $wav --force --keep-server 2>&1 | Out-File -LiteralPath $so -Encoding utf8
    "===== END $($j.n) exit=$LASTEXITCODE $(Get-Date -Format 'HH:mm:ss') =====" | Out-File -LiteralPath $log -Append -Encoding utf8
}
"DONE $(Get-Date -Format 'HH:mm:ss')" | Out-File -LiteralPath $log -Append -Encoding utf8
