//%attributes = {"invisible":true,"preemptive":"incapable"}
SET CURRENT PRINTER:C787("PDF24")

/*
Automatically save documents after printed: YES
Output directory: C:\Users\miyako\$printerName
File name: $fileName
*/

$name:="請求書"
var $file : 4D:C1709.File
$file:=Folder:C1567(fk home folder:K87:24).folder("PDF24").file($name+".pdf")
If ($file.exists)
	$file.delete()
End if 

SET PRINT OPTION:C733(Paper option:K47:1; "A5")
SET PRINT OPTION:C733(Spooler document name option:K47:10; $name)

OPEN PRINTING JOB:C995
$h:=Print form:C5("test")
CLOSE PRINTING JOB:C996

Repeat 
	DELAY PROCESS:C323(Current process:C322; 6)
Until ($file.exists)

OPEN URL:C673($file.platformPath)