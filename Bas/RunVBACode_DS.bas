Option Explicit
Sub Main
	'DS.ReportInformation "RunVBACode - Start"
    Dim matlabfcn
    matlabfcn = DS.RestoreGlobalDataValue("matlabfcn")
	'DS.ReportInformation matlabfcn
    MacroRunThis matlabfcn
	'DS.ReportInformation "RunVBACode - Finish"
End Sub