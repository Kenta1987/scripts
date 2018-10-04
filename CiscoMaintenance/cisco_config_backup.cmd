@echo off

pushd %0\..
set csvfile=C:\config_backup\Cisco\conf\switch_list.csv
set macro=C:\config_backup\Cisco\ttl\get_cisco_config.ttl

rem フィールド数の設定
set tokens=1,2,3,4
 
rem CSVファイル内の行頭に#がある場合はコメントとみなされて無視される
for /F "usebackq eol=# tokens=%tokens% delims=," %%a in (%csvfile%) do (
	"%ProgramFiles(x86)%\teraterm\ttpmacro.exe" "%macro%" %%a %%b %%c
	timeout 2 > nul
)
