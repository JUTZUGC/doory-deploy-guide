# Doory 一键部署脚本（第三方指南）——按官方文档封装
# 官方文档：https://github.com/shaongitbd/doory#self-host-it
# 更新日期：2026-10-30
# 类型：docker
$ErrorActionPreference = 'Stop'
Set-Location -Path $PSScriptRoot

foreach ($cmd in @('git', 'docker')) {
  if (-not (Get-Command $cmd -ErrorAction SilentlyContinue)) { throw "需要先安装 $cmd" }
}
docker compose version | Out-Null
if ($LASTEXITCODE -ne 0) { throw '需要 Docker Compose v2（docker compose 子命令）' }

New-Item -ItemType Directory -Force -Path .download | Out-Null
Set-Location -Path .download

git clone https://github.com/shaongitbd/doory.git
Set-Location doory
Copy-Item .env.example .env
$b=[Convert]::ToBase64String((1..48|ForEach-Object{Get-Random -Maximum 256})); $p=-join ((48..57)+(65..90)+(97..122)|Get-Random -Count 24|ForEach-Object{[char]$_}); (Get-Content .env) -replace '^DJANGO_SECRET_KEY=.*',("DJANGO_SECRET_KEY="+$b) -replace '^POSTGRES_PASSWORD=.*',("POSTGRES_PASSWORD="+$p) | Set-Content .env
docker compose up -d --build
Write-Host "已启动：http://127.0.0.1:8080"

Write-Host ''
$url = 'http://127.0.0.1:8080'
Write-Host "等待服务启动：$url"
$ready = $false
for ($i = 0; $i -lt 30; $i++) {
  try {
    Invoke-WebRequest -UseBasicParsing -Uri $url -TimeoutSec 3 | Out-Null
    $ready = $true
    break
  } catch {
    Start-Sleep -Seconds 2
  }
}
if (-not $ready) { throw "60 秒内未探测到 $url，请手动打开确认或查看日志" }
Write-Host '服务已就绪'
Write-Host '部署完成：打开 http://127.0.0.1:8080 直接开始设计；需要模板、字体和图标再按 README 里的命令导入'
Write-Host '若结果异常或需要改配置，请参考官方文档：https://github.com/shaongitbd/doory#self-host-it'
