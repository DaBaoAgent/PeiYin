@echo off
chcp 65001 >nul
cd /d "%~dp0"
copy /b 女娲_炎帝_配音_20261024.zip.part1+女娲_炎帝_配音_20261024.zip.part2+女娲_炎帝_配音_20261024.zip.part3+女娲_炎帝_配音_20261024.zip.part4+女娲_炎帝_配音_20261024.zip.part5 女娲_炎帝_配音_20261024.zip >nul
if exist 女娲_炎帝_配音_20261024.zip (echo 合并完成: 女娲_炎帝_配音_20261024.zip) else (echo 合并失败: 请确认5个分卷都在本文件夹)
pause
