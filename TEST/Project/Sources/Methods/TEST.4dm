//%attributes = {"invisible":true,"preemptive":"incapable"}
$path:=System folder:C487(Desktop:K41:16)+"my document.pdf"
$profile:="default"  //high,email

SET PRINT OPTION:C733(Paper option:K47:1; "A5")
SET PRINT OPTION:C733(Spooler document name option:K47:10; "請求書")

If (PDF24($path; $profile))
	
	OPEN PRINTING JOB:C995
	$h:=Print form:C5("test")
	CLOSE PRINTING JOB:C996
	
	OPEN URL:C673($path)
	
End if 