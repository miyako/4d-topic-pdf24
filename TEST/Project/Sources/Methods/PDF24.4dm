//%attributes = {"invisible":true,"preemptive":"incapable"}
#DECLARE($path : Text; $profile : Text) : Boolean

If (Is macOS:C1572)
	return False:C215
End if 

ARRAY TEXT:C222($printers; 0)
PRINTERS LIST:C789($printers)

If (Find in array:C230($printers; "PDF24")=-1)
	return False:C215
End if 

If (Get current printer:C788#"PDF24")
	SET CURRENT PRINTER:C787("PDF24")
End if 

If (Not:C34(["default"; "high"; "email"].includes($profile)))
	$profile:="default"
End if 

var $ini : Text
$ini:=["[GENERAL]"; \
"outputFile="+$path; \
"outputProfile="+$profile; \
"showSaveAsDialog=false"; \
"openPdfAfterSaving=false"].join("\r\n")

var $file : 4D:C1709.File
$file:=Folder:C1567(fk home folder:K87:24).file("AppData/Local/PDF24/pdf24-job.ini")
$file.setText($ini)

return True:C214