![version](https://img.shields.io/badge/version-20%2B-E23089)
![platform](https://img.shields.io/static/v1?label=platform&message=win-64&color=blue)

# 4d-topic-pdf24

[PDF24 Creator 11.25.1](https://tools.pdf24.org/ja/creator#download)はフリーの仮想プリンタードライバーです。

> [!WARNING]
> 途中で警告が表示されますが，インストールには成功します。

<img src="https://github.com/user-attachments/assets/e4939ef6-e78d-487b-96b4-632dea2c10d2" width=400 height=auto />

## 自動保存オブションを使用する方法

**PDF24 Creator**アプリを起動し，設定を開きます。

<img src="https://github.com/user-attachments/assets/d1b5f57e-3d4c-41fd-8db0-f69aa7ceb507" width=500 height=auto />

以下の項目を入力します。

* 印刷後にドキュメントを自動保存する
* 出力ディレクトリ
* ファイル名

`$fileName`には`SET PRINT OPTION`と`Spooler document name option`で設定したジョブ名が代入されます。

> [!WARNING]
> * 仮想プリンタードライバーによる印刷ファイル出力は非同期処理です。
> * 同名のファイルが存在する場合は接尾辞`(1)`が追加されます。

下記の要領で印刷できます。

```4d
SET CURRENT PRINTER("PDF24")

/*
	Automatically save documents after printed: YES
	Output directory: C:\Users\miyako\$printerName
	File name: $fileName
*/

$name:="請求書"
var $file : 4D.File
$file:=Folder(fk home folder).folder("PDF24").file($name+".pdf")
If ($file.exists)
	$file.delete()
End if 

SET PRINT OPTION(Paper option; "A5")
SET PRINT OPTION(Spooler document name option; $name)

OPEN PRINTING JOB
$h:=Print form("test")
CLOSE PRINTING JOB

Repeat 
	DELAY PROCESS(Current process; 6)
Until ($file.exists)

OPEN URL($file.platformPath)
```

### 【参考】過去バージョンの場合

[過去バージョン](https://creator.pdf24.org/listVersions.php)は一時ファイル`pdf24-job.ini`を上書きして設定を変更するという裏技があったようです。

64-bit版のPDF24 Creator 11,10,9で検証したところ，一時ファイル`pdf24-job.ini`を作成しても無視されました。

## 理論上の例題

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

* `PDF24`

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

If (Not(["default"; "high"; "email"].includes($profile)))
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

return True
```
