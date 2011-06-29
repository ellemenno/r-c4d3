
; projector customizer
;; http://www.autoitscript.com/site/autoit/


Dim $exeLoc = "Z:\_apps\PortableApps\PortableApps\_Versiown\Versiown.exe" ;$CmdLine[0]
Dim $projector = "Z:\_projects\pixeldroid\r-c4d3-branches\v0.5\romloader-as3\target\temp-desktop-projectors-debug\romloader-desktop-debug.exe" ;$CmdLine[2]
Dim $projectorIcon = "Z:\_projects\pixeldroid\r-c4d3-branches\v0.5\shared\src\icons\R.C4D3.ico" ;$CmdLine[2]
Dim $fileVersion = "v0.1.29" ;$CmdLine[3]
Dim $fileDescription = "R-C4D3 Desktop Rom Loader (debug)" ;$CmdLine[4]
Dim $legalCopyright = "Copyleft 2011 Pixeldroid" ;$CmdLine[5]
Dim $productName = "R-C4D3 Desktop Rom Loader (debug)" ;$CmdLine[6]
Dim $companyName = "pixeldroid.com" ;$CmdLine[7]
Dim $legalTrademarks = "R-C4D3 (tm) pixeldroid" ;$CmdLine[8]


; run Versiown
Run($exeLoc)
Dim $exeClass = "[CLASS:#32770]"
Dim $nextId = "[ID:1003]"

; wait for the app to become active
WinWaitActive($exeClass)


; navigate through GUI

; splash screen: next
clickNext()

; enter projector file path
ControlSetText($exeClass, "", "[ID:1101]", $projector )
tabout()
clickNext()

; enter projector icon path
ControlSetText($exeClass, "", "[ID:1102]", $projectorIcon )
tabout()
clickNext()

; use same icon: next
clickNext()

; enter data
ControlSetText($exeClass, "", "[ID:1401]", $fileVersion )
tabout()
ControlSetText($exeClass, "", "[ID:1402]", $fileDescription )
tabout()
ControlSetText($exeClass, "", "[ID:1403]", $legalCopyright ) ; need admin rights?
tabout()
ControlSetText($exeClass, "", "[ID:1404]", $productName )
tabout()
ControlSetText($exeClass, "", "[ID:1405]", $companyName )
tabout()
ControlSetText($exeClass, "", "[ID:1406]", $legalTrademarks )
tabout()
clickNext()

; finish
ControlClick($exeClass, "", "[ID:1006]")


; Finished!




; function definitions - - - - - - - - - - - - - - - - - - -

Func clickNext()
	ControlClick($exeClass, "", $nextId)
	Sleep(1250)
EndFunc

Func tabout()
	Sleep(250)
	Send(@TAB)
	Sleep(250)
	Send(@TAB)
	Sleep(250)
	Send(@TAB)
EndFunc