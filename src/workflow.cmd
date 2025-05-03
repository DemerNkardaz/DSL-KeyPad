@echo off
set ver=0.1.1.1-alpha-testing
set preRelease=True
call build_executable.cmd
call Bin\\build_icons_dll.cmd
