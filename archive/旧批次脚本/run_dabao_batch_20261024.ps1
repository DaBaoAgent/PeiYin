# dabao v3 批次配音：006 女娲 → 011 商汤（2026-10-24）
$ErrorActionPreference = 'Continue'
$py     = "D:\GPT-SoVITS\.venv\Scripts\python.exe"
$engine = "D:\GPT-SoVITS\dabao_tts.py"
$audioDir = "D:\@kaifa\PeiYin\donghua-pipeline\05-配音提示\audio"
$base   = "D:\@kaifa\PeiYin\出稿"
$log    = "D:\@kaifa\PeiYin\配音批次_20261024_v3.log"

$jobs = @(
    @{ n = '006_女娲'; txt = Join-Path $audioDir '女娲_全篇.txt' },
    @{ n = '007_炎帝'; txt = Join-Path $audioDir '炎帝_全篇.txt' },
    @{ n = '008_黄帝'; txt = Join-Path $audioDir '黄帝_全篇.txt' },
    @{ n = '009_大禹'; txt = Join-Path $audioDir '大禹_全篇.txt' },
    @{ n = '010_夏桀'; txt = Join-Path $audioDir '夏桀_全篇.txt' },
    @{ n = '011_商汤'; txt = Join-Path $audioDir '商汤_全篇.txt' }
)

"BATCH START $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" | Out-File -LiteralPath $log -Encoding utf8
foreach ($j in $jobs) {
    $outDir = Join-Path $base $j.n
    if (-not (Test-Path -LiteralPath $outDir)) { New-Item -ItemType Directory -Path $outDir | Out-Null }
    $wav = Join-Path $outDir '配音.wav'
    $so  = Join-Path $outDir 'run_stdout.log'
    $se  = Join-Path $outDir 'run_stderr.log'
    "===== START $($j.n) $(Get-Date -Format 'HH:mm:ss') =====" | Out-File -LiteralPath $log -Append -Encoding utf8
    $p = Start-Process -FilePath $py `
        -ArgumentList @('-X','utf8',$engine,'--text-file',$j.txt,'--out',$wav,'--force','--keep-server') `
        -WorkingDirectory 'D:\GPT-SoVITS' `
        -RedirectStandardOutput $so -RedirectStandardError $se -Wait -PassThru -WindowStyle Hidden
    "===== END $($j.n) exit=$($p.ExitCode) $(Get-Date -Format 'HH:mm:ss') =====" | Out-File -LiteralPath $log -Append -Encoding utf8
}
"BATCH DONE $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" | Out-File -LiteralPath $log -Append -Encoding utf8
