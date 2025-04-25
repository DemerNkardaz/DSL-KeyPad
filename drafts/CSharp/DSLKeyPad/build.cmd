@echo off
dotnet publish -r win-x64 -c Release --self-contained false --output ./publish /p:PublishSingleFile=true /p:DebugType=None
pause