# ========= Settings =========
$maxRuns = 12                         # Total number of runs
$skipRuns = @(7, 12)                  # Runs to skip JMeter execution
$waitSecondsOnSkip = 300              # Wait time (5 minutes) when skipping

# Base directories (relative paths)
$reportBaseDir = "..\..\async-reports"
$jmxBasePath   = "..\..\async-scenario1"

# JMX file name template (with placeholder for run number)
# Example → API_test-1-1-1-1-1_3.jmx
$jmxTemplate = "API_test-1-1-1-1-1_{0}.jmx"
# ============================

Write-Host "=== JMeter Batch Execution Started ==="
Write-Host "Start Time: $(Get-Date -Format 'yyyy/MM/dd HH:mm:ss')"
Write-Host ""

for ($i = 1; $i -le $maxRuns; $i++) {

    Write-Host ""
    Write-Host "[$i/$maxRuns] $(Get-Date -Format 'HH:mm:ss') : Run Processing Start"

    # ========== Skip Logic (Run 7 & 12) ==========
    if ($skipRuns -contains $i) {
        Write-Host "[$i/$maxRuns] JMeter execution is SKIPPED for this run."
        Write-Host "Waiting for 5 minutes..."
        Start-Sleep -Seconds $waitSecondsOnSkip
        Write-Host "[$i/$maxRuns] Skip wait completed."
        continue
    }
    # ============================================

    # Create timestamp directory
    $timestamp = Get-Date -Format "yyyy-MMdd-HHmm"
    $reportDir = Join-Path $reportBaseDir $timestamp

    Write-Host "Creating report directory: $reportDir"
    New-Item -ItemType Directory -Force -Path $reportDir | Out-Null

    # Build JMX filename from template
    $jmxFilename = ($jmxTemplate -f $i)
    $jmxFile = Join-Path $jmxBasePath $jmxFilename

    # ========== Execute JMeter ==========
    Write-Host "Executing JMeter:"
    Write-Host "  JMX:        $jmxFile"
    Write-Host "  Output Dir: $reportDir"

    $process = Start-Process ".\jmeter.bat" `
        -ArgumentList "-n", "-t", $jmxFile, "-l", $reportDir `
        -Wait -PassThru

    # ========== Error Handling (Continue) ==========
    if ($process.ExitCode -ne 0) {
        Write-Host ""
        Write-Host "********************************************"
        Write-Host "*  WARNING: JMeter failed on run $i        *"
        Write-Host "*  Exit Code: $($process.ExitCode)         *"
        Write-Host "********************************************"
        Write-Host ""
    }
    # ===============================================

    Write-Host "[$i/$maxRuns] $(Get-Date -Format 'HH:mm:ss') : Execution Completed"
}

Write-Host ""
Write-Host "=== All $maxRuns Runs Finished ==="
Write-Host "End Time: $(Get-Date -Format 'yyyy/MM/dd HH:mm:ss')"
