$mapPath = Join-Path $PSScriptRoot "..\docs\对标逐字稿\asr_tasks.json"
$outDir  = Join-Path $PSScriptRoot "..\docs\对标逐字稿"
$tasks = Get-Content -LiteralPath $mapPath -Raw -Encoding utf8 | ConvertFrom-Json

# 友好命名映射
$nameMap = @{
  "*秦始皇*7580689621*" = "张予不才_秦始皇发明中国.txt"
  "*汉武帝*7590409859*" = "张予不才_汉武帝是继承者.txt"
  "*位面之子*7611857572*" = "祀与戎_位面之子刘秀.txt"
  "*嫡长子*7618924052*" = "一代书生_嫡长子继承制.txt"
  "*地图推演匈奴*7691266724*" = "布衣历史_冒顿单于匈奴.txt"
  "*定义了中华文明*7386975214*" = "木鱼水心_定义文明的王朝.txt"
  "*犹太人*7684244601*" = "小五狼_犹太人历史.txt"
  "*绝地天通*7696837807*" = "悦木说_绝地天通.txt"
  "*张居正*7594463193*" = "一代书生_张居正.txt"
  "*商鞅变法*7639276950*" = "古人空间_商鞅变法.txt"
  "*苏联解体*7691598086*" = "重八_苏联解体高考.txt"
}

foreach($t in $tasks){
  $tid = $t.task_id
  $origFile = $t.file
  Write-Host "[$tid] Querying $($origFile.Substring(0,[Math]::Min(20,$origFile.Length)))..."
  try {
    $raw = mediakit-cli shared query-task --task-id $tid --poll-complete 2>&1 | Out-String
    $obj = $raw | ConvertFrom-Json
    if($obj.status -eq "completed" -and $obj.subtitles){
      # 拼纯文本
      $lines = $obj.subtitles | ForEach-Object { $_.subtitle_text }
      $text = ($lines -join "")
      # 找友好文件名
      $outName = "unknown_$tid.txt"
      foreach($k in $nameMap.Keys){
        if($origFile -like $k){ $outName = $nameMap[$k]; break }
      }
      $outPath = Join-Path $outDir $outName
      # 加头部元信息
      $header = "# 来源: $origFile`n# 时长: $([math]::Round($obj.duration,1)) 秒`n# task_id: $tid`n# 字幕条数: $($obj.subtitles.Count)`n`n"
      [IO.File]::WriteAllText($outPath, $header + $text, (New-Object Text.UTF8Encoding($false)))
      Write-Host "  OK -> $outName  ($([math]::Round($obj.duration,0))s, $($text.Length) chars)"
    } else {
      Write-Host "  STATUS=$($obj.status) (no subtitles yet)"
    }
  } catch {
    Write-Host "  ERROR: $($_.Exception.Message)"
  }
  Start-Sleep -Seconds 1
}
Write-Host "`n=== ALL DONE ==="
