$ErrorActionPreference = 'Stop'

Write-Host '==> 1/3 Running flutter analyze (strict)...' -ForegroundColor Cyan
flutter analyze --fatal-infos --fatal-warnings
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

Write-Host '==> 2/3 Running architecture guardrail tests...' -ForegroundColor Cyan
flutter test test/architecture/
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

Write-Host '==> 3/3 Running full unit and widget test suite...' -ForegroundColor Cyan
flutter test
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

Write-Host 'All Flutter quality gates passed!' -ForegroundColor Green
