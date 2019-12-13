Option Explicit
Sub Main
	'ReportInformation "Start"
    Dim matlabfcn
    matlabfcn = RestoreGlobalDataValue("matlabfcn")
	'ReportInformation matlabfcn
    MacroRunThis matlabfcn
	'ReportInformation "Finish"
End Sub