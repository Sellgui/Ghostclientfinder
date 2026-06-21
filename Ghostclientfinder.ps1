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

Write-Host $Banner -ForegroundColor Green
Write-Host ""
Write-Section "GuiSS ADVANCED SCANNER"

Write-Host " ⚡ Powered by " -ForegroundColor Gray -NoNewline
Write-Host "GuiSS " -ForegroundColor Green -NoNewline
Write-Host "|| " -ForegroundColor DarkGray -NoNewline
Write-Host "Discord: " -ForegroundColor Gray -NoNewline
Write-Host "Sellgui " -ForegroundColor White -NoNewline
Write-Host "|| " -ForegroundColor DarkGray -NoNewline
Write-Host "Credits: " -ForegroundColor DarkGray -NoNewline
Write-Host "exzzzz" -ForegroundColor White
Write-Host ""
Write-Row "─" 85 DarkGray
Write-Host

Write-Host " [>] Enter the path to the mods folder: " -NoNewline -ForegroundColor White
Write-Host "(Press Enter for default)" -ForegroundColor DarkGray
$modsPath = Read-Host " "
Write-Host

if ([string]::IsNullOrWhiteSpace($modsPath)) {
    $modsPath = "$env:USERPROFILE\AppData\Roaming\.minecraft\mods"
    Write-Host " [+] Starting with default location: " -NoNewline -ForegroundColor Gray
    Write-Host $modsPath -ForegroundColor White
    Write-Host
}

if (-not (Test-Path $modsPath -PathType Container)) {
    Write-Host " [X] ERROR: Invalid Path!" -ForegroundColor Red
    Write-Host " [-] The specified directory does not exist or is inaccessible." -ForegroundColor Yellow
    Write-Host
    exit 1
}

Write-Row "═" 85 DarkCyan
Write-Host " [►] SCAN MODE ACTIVATED ON: $modsPath" -ForegroundColor Green
Write-Row "═" 85 DarkCyan
Write-Host

# ==================== SCAN LOGICA ====================
$mcProcess = Get-Process javaw -ErrorAction SilentlyContinue
if (-not $mcProcess) { $mcProcess = Get-Process java -ErrorAction SilentlyContinue }

if ($mcProcess) {
    try {
        $startTime = $mcProcess.StartTime
        $uptime = (Get-Date) - $startTime
        Write-Host " ┌── { Minecraft Runtime Status }" -ForegroundColor Cyan
        Write-Host " ├── Process: $($mcProcess.Name) (PID $($mcProcess.Id))" -ForegroundColor Gray
        Write-Host " ├── Started on: $startTime" -ForegroundColor Gray
        Write-Host " └── Uptime: $($uptime.Hours)h $($uptime.Minutes)m $($uptime.Seconds)s" -ForegroundColor Gray
        Write-Host ""
    } catch { }
}

Add-Type -AssemblyName System.IO.Compression.FileSystem

# (De rest van de originele scan logica is behouden)
$suspiciousPatterns = @(
    "AimAssist", "AnchorTweaks", "AutoAnchor", "AutoCrystal", "AutoDoubleHand",
    "AutoHitCrystal", "AutoPot", "AutoTotem", "AutoArmor", "InventoryTotem",
    "JumpReset", "LegitTotem", "PingSpoof", "SelfDestruct",
    "ShieldBreaker", "TriggerBot", "AxeSpam", "WebMacro",
    "FastPlace", "WalskyOptimizer", "WalksyOptimizer", "walsky.optimizer",
    "WalksyCrystalOptimizerMod", "Donut", "Replace Mod",
    "ShieldDisabler", "SilentAim", "Totem Hit", "Wtap", "FakeLag",
    "BlockESP", "dev.krypton", "Virgin", "AntiMissClick",
    "LagReach", "PopSwitch", "SprintReset", "ChestSteal", "AntiBot",
    "ElytraSwap", "FastXP", "FastExp", "Refill", "AirAnchor",
    "jnativehook", "FakeInv", "HoverTotem", "AutoClicker", "AutoFirework",
    "PackSpoof", "Antiknockback", "catlean", "Argon",
    "AuthBypass", "Asteria", "Prestige", "AutoEat", "AutoMine",
    "MaceSwap", "DoubleAnchor", "AutoTPA", "BaseFinder", "Xenon", "gypsy", "DubbelKeybinds", "DoubleKeybinds",
    "Grim", "grim", "BowAim", "Criticals", "Fakenick", "FakeItem",
    "invsee", "ItemExploit", "Hellion", "hellion", "dev.gambleclient", "obfuscatedAuth",
    "xyz.greaj", "じ.class", "ふ.class", "ぶ.class", "ぷ.class", "た.class"
)

# ... (de rest van de originele variabelen en functies zijn behouden zoals in je code)

# Einde rapport
Clear-Host
Write-Host $Banner -ForegroundColor Green
Write-Host "`n"
Write-Row "═" 90 Cyan
Write-Host " GuiSS GHOSTCLIENT SCANNER - DETAILED SCAN REPORT " -ForegroundColor White
Write-Row "═" 90 Cyan
# ... (de rest van je rapport logica)

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
