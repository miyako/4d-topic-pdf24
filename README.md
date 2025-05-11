![version](https://img.shields.io/badge/version-20%2B-E23089)
![platform](https://img.shields.io/static/v1?label=platform&message=win-64&color=blue)

# 4d-topic-pdf24

## セットアップ

[PDF24 Creator 11.25.1](https://tools.pdf24.org/ja/creator#download)をダウンロードして実行します。

> [!WARNING]
> 途中で警告が表示されますが，インストールには成功します。

<img src="https://github.com/user-attachments/assets/e4939ef6-e78d-487b-96b4-632dea2c10d2" width=400 height=auto />

## 例題

```4d
$path:=System folder(Desktop)+"my document.pdf"
$profile:="default"  //high,email

SET PRINT OPTION(Paper option; "A5")
SET PRINT OPTION(Spooler document name option; "請求書")

If (PDF24($path; $profile))
	
	OPEN PRINTING JOB
	$h:=Print form("test")
	CLOSE PRINTING JOB
	
	OPEN URL($path)
	
End if 
```

### `PDF24`

```4d
#DECLARE($path : Text; $profile : Text) : Boolean

If (Is macOS)
	return False
End if 

ARRAY TEXT($printers; 0)
PRINTERS LIST($printers)

If (Find in array($printers; "PDF24")=-1)
	return False
End if 

If (Get current printer#"PDF24")
	SET CURRENT PRINTER("PDF24")
End if 

If (Not(["default"; "high"; "email"].contains($profile)))
	$profile:="default"
End if 

var $ini : Text
$ini:=["[GENERAL]"; \
"outputFile="+$path; \
"outputProfile="+$profile; \
"showSaveAsDialog=false"; \
"openPdfAfterSaving=false"].join("\r\n")

var $file : 4D.File
$file:=Folder(fk home folder).file("AppData/Local/PDF24/pdf24-job.ini")
$file.setText($ini)
```
