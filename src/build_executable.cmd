@echo off
"%SystemRoot%\Microsoft.NET\Framework64\v4.0.30319\csc.exe" ^
  /platform:x64 ^
  /target:exe ^
  /out:DSLKeyPad.exe ^
  /win32icon:Bin\DSLKeyPad_App_Icons\DSLKeyPad.app.ico ^
  /reference:System.Drawing.dll ^
  DSLKeyPad.cs
