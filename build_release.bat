@echo off
echo ==========================================
echo      Scientific Calculator Release Build
echo ==========================================

echo [1/3] Cleaning project...
call flutter clean
call flutter pub get

echo [2/3] Running Test Suite...
call flutter test
if %errorlevel% neq 0 (
    echo [ERROR] Tests failed! Build aborted.
    exit /b %errorlevel%
)

echo [3/3] Building Release Bundle (AAB)...
REM Note: This requires signing config in android/build.gradle or manual signing later.
REM Using --no-sound-null-safety if strictly needed, but we targeting modern flutter so omitted.
REM --obfuscate --split-debug-info maps symbols for crashlytics.
call flutter build appbundle --release --obfuscate --split-debug-info=build/app/outputs/symbols

echo.
echo ==========================================
if %errorlevel% equ 0 (
    echo [SUCCESS] Build generated at build\app\outputs\bundle\release\app-release.aab
) else (
    echo [ERROR] Build failed.
)
echo ==========================================
pause
