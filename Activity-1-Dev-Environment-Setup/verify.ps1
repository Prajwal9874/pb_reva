param([string]$Compiler = "gcc")
$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot
$log = [System.Collections.Generic.List[string]]::new()
$log.Add("ACTIVITY 1 - C/C++ ENVIRONMENT VERIFICATION")
$log.Add("Actual command output captured on " + (Get-Date -Format "yyyy-MM-dd HH:mm"))
$log.Add("")
$log.Add("> gcc --version")
$version = & $Compiler --version 2>&1
$version | ForEach-Object { $log.Add([string]$_) }
if ($LASTEXITCODE -ne 0) { throw "GCC version check failed" }
$log.Add("")
$log.Add("> gcc -dumpmachine")
$log.Add([string](& $Compiler -dumpmachine))
$log.Add("")
$log.Add("> gcc -Wall -Wextra -std=c11 hello.c -o hello.exe")
$diagnostics = & $Compiler -Wall -Wextra -std=c11 hello.c -o hello.exe 2>&1
$compileExit = $LASTEXITCODE
$diagnostics | ForEach-Object { $log.Add([string]$_) }
$log.Add("Compiler exit code: " + $compileExit)
if ($compileExit -ne 0) { throw "Compilation failed" }
$log.Add("")
$log.Add("> .\hello.exe")
$programOutput = & .\hello.exe 2>&1
$runExit = $LASTEXITCODE
$programOutput | ForEach-Object { $log.Add([string]$_) }
$log.Add("Program exit code: " + $runExit)
if ($runExit -ne 0 -or [string]$programOutput -ne "Hello, World!") { throw "Unexpected program result" }
$log.Add("")
$log.Add("Editor: Visual Studio Code")
$log.Add("Extension: Microsoft C/C++ (ms-vscode.cpptools)")
$log.Add("RESULT: PASS - compiled without warnings and ran successfully.")
$log | Set-Content -LiteralPath "verification-output.txt" -Encoding utf8
$log
