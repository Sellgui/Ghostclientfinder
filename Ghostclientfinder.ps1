[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
[Console]::InputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8
chcp 65001 | Out-Null
Clear-Host

$currentFont = (Get-ItemProperty "HKCU:\Console" -ErrorAction SilentlyContinue).FaceName
if ($currentFont -notmatch "NSimSun|Gothic|Noto") {
    Write-Host " [!] Tip: Set your terminal font to 'NSimSun' to display all elements correctly." -ForegroundColor DarkYellow
    Write-Host
}

$Banner = @"
╔══════════════════════════════════════════════════════════════════════════════╗
║                                                                              ║
║                       ██████╗ ██╗   ██╗██╗███████╗███████╗                   ║
║                      ██╔════╝ ██║   ██║██║██╔════╝██╔════╝                   ║
║                      ██║  ███╗██║   ██║██║███████╗███████╗                   ║
║                      ██║   ██║██║   ██║██║╚════██║╚════██║                   ║
║                      ╚██████╔╝╚██████╔╝██║███████║███████║                   ║
║                       ╚═════╝  ╚═════╝ ╚═╝╚══════╝╚══════╝                   ║
║                                                                              ║
║                    G H O S T   C L I E N T   S C A N                         ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝
"@

function Write-Section {
    param([string]$Title)
    Write-Host ""
    Write-Host "╔══════════════════════════════════════════════════════════════╗" -ForegroundColor DarkCyan
    Write-Host ("║ " + $Title.PadRight(58) + "║") -ForegroundColor Cyan
    Write-Host "╚══════════════════════════════════════════════════════════════╝" -ForegroundColor DarkCyan
}

function Write-Good { param([string]$Text) Write-Host " [+] $Text" -ForegroundColor Green }
function Write-Bad  { param([string]$Text) Write-Host " [!] $Text" -ForegroundColor Red }
function Write-Info { param([string]$Text) Write-Host " [•] $Text" -ForegroundColor Gray }

function Write-Row {
    param([string]$char, [int]$count, [System.ConsoleColor]$color)
    Write-Host ($char * $count) -ForegroundColor $color
}

Write-Host $Banner -ForegroundColor Green   # <-- Groen gemaakt
Write-Host ""
Write-Section "GuiSS ADVANCED SCANNER"

Write-Host " ⚡ Powered by " -ForegroundColor Gray -NoNewline
Write-Host "GuiSS " -ForegroundColor Green -NoNewline   # <-- Groen
Write-Host "|| " -ForegroundColor DarkGray -NoNewline
Write-Host "Discord: " -ForegroundColor Gray -NoNewline
Write-Host "Sellgui " -ForegroundColor White -NoNewline
Write-Host "|| " -ForegroundColor DarkGray -NoNewline
Write-Host "Credits: " -ForegroundColor DarkGray -NoNewline
Write-Host "exzzzz" -ForegroundColor White
Write-Host ""
Write-Row "─" 85 DarkGray
Write-Host

# Hier komt de rest van je scan code
Write-Host " [>] Enter the path to the mods folder: " -NoNewline -ForegroundColor White
Write-Host "(Press Enter for default)" -ForegroundColor DarkGray
$modsPath = Read-Host " "
# ... (rest van je originele script hier plakken)

Write-Host " ✨ System Analysis Complete. Thanks for using GuiSS Ghost client scanner!" -ForegroundColor Green
Write-Host ""
Write-Host " 👤 Creator  : " -ForegroundColor White -NoNewline
Write-Host "GuiSS" -ForegroundColor Green
Write-Host " 📱 Discord  : " -ForegroundColor White -NoNewline
Write-Host "Sellgui" -ForegroundColor White
Write-Host " 📝 Credits : " -ForegroundColor DarkGray -NoNewline
Write-Host "exzzzz" -ForegroundColor White
Write-Host ""
Write-Host " [i] Forensic scan run terminated. Press any key to safely dispose this window..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
