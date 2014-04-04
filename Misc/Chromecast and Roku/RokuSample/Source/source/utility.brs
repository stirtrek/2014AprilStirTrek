
Function GetPlayerVersion() As String
	deviceInfo = CreateObject("roDeviceInfo")
	version = deviceInfo.GetVersion()
	Return version
End Function

Function HasTextScreen() As Boolean
	' The very nice roTextScreen was added in version 4.3
	version = GetPlayerVersion()

	versionSufficient = Val(version.Mid(2,4)) > 4.3

	return versionSufficient
End Function