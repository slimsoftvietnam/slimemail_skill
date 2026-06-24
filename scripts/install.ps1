param(
    [Parameter(Mandatory = $true)]
    [string]$Target
)

$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)

New-Item -ItemType Directory -Force -Path "$Target\.claude\skills\slimemail-ai-agent" | Out-Null
New-Item -ItemType Directory -Force -Path "$Target\.cursor\skills\slimemail-ai-agent" | Out-Null
New-Item -ItemType Directory -Force -Path "$Target\.cursor\rules" | Out-Null

Copy-Item "$Root\skills\slimemail-ai-agent\*" "$Target\.claude\skills\slimemail-ai-agent\" -Force
Copy-Item "$Root\skills\slimemail-ai-agent\*" "$Target\.cursor\skills\slimemail-ai-agent\" -Force
Copy-Item "$Root\rules\slimemail-ai-agent.mdc" "$Target\.cursor\rules\" -Force

if (-not (Test-Path "$Target\.env")) {
    Copy-Item "$Root\.env.example" "$Target\.env"
    Write-Host "Created $Target\.env — dien SLIMEMAIL_API_KEY"
}

if (-not (Test-Path "$Target\CLAUDE.md")) {
    Copy-Item "$Root\templates\CLAUDE.md" "$Target\CLAUDE.md"
}

Write-Host "OK: skill -> .claude/skills + .cursor/skills"
Write-Host "Sua .env roi test: curl .../api/agent/me"
