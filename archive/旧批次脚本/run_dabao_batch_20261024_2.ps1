# dabao v3 批次配音：007 炎帝 → 011 商汤（2026-10-24 重启版，规避 Start-Process -Wait 挂起）
$ErrorActionPreference = 'Continue'
$py     = "D:\GPT-SoVITS\.venv\Scripts\python.exe"
$engine = "D:\GPT-SoVITS\dabao_tts.py"
$audioDir = "D:\@kaifa\PeiYin\donghua-pipeline\05-配音提示\audio"
$base   = "D:\@kaifa\PeiYin\出稿"
$log    = "D:\@kaifa\PeiYin\配音批次_20261024_v3.log"

$jobs = @(
    @{ n = '007_炎帝'; txt = Join-Path $audioDir '炎帝_全篇.txt' },
    @{ n = '008_黄帝'; txt = Join-Path $audioDir '黄帝_全篇.txt' },
    @{ n = '009_大禹'; txt = Join-Path $audioDir '大禹_全篇.txt' },
    @{ n = '010_夏桀'; txt = Join-Path $audioDir '夏桀_全篇.txt' },
    @{ n = '011_商汤'; txt = Join-Path $audioDir '商汤_全篇.txt' }
)

"===== BATCH RESUME (007-011) $(Get-Date -Format 'HH:mm:ss') =====" | Out-File -LiteralPath $log -Append -Encoding utf8
foreach ($j in $jobs) {
    $outDir = Join-Path $base $j.n
    if (-not (Test-Path -LiteralPath $outDir)) { New-Item -ItemType Directory -Path $outDir | Out-Null }
    $wav = Join-Path $outDir '配音.wav'
    $so  = Join-Path $outDir 'run_stdout.log'
    "===== START $($j.n) $(Get-Date -Format 'HH:mm:ss') =====" | Out-File -LiteralPath $log -Append -Encoding utf8
    & $py -X utf8 $engine --text-file $j.txt --out $wav --force --keep-server 2>&1 | Out-File -LiteralPath $so -Encoding utf8
    "===== END $($j.n) exit=$LASTEXITCODE $(Get-Date -Format 'HH:mm:ss') =====" | Out-File -LiteralPath $log -Append -Encoding utf8
}
"DONE $(Get-Date -Format 'HH:mm:ss')" | Out-File -LiteralPath $log -Append -Encoding utf8
