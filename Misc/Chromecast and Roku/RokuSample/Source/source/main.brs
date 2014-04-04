
Sub Main()
	' If you had pre-work you wanted to do while the splash screen is being shown, now is the time to do it.
	' The splash screen will continue to be shown until you call Show on your first screen.

	' If you wanted to call a webservice, you could do it like this:
	'apiRequest = CreateObject("roUrlTransfer")
	'apiRequest.SetURL("pkg:/data/slide_flow.json")
	'presentationData = ParseJson(apiRequest.GetToString())

	jsonBytes = CreateObject("roByteArray")
	jsonBytes.ReadFile("pkg:/data/slide_flow.json")

	jsonString = jsonBytes.ToAsciiString()
	presentationData = ParseJson(jsonString)

	SetSlideIndices(presentationData)

	' You can also use this as an opportunity to set appropriate values for your application themeing.
	SetupTheme()

	' For us, we're going to show the presentation flow

	PresentationScreen_Show(presentationData)

End Sub

Sub SetupTheme()

	' Themes are applied by creating an associative array and setting it into the roAppManager

	app = CreateObject("roAppManager")
	theme = CreateObject("roAssociativeArray")

	theme.ThemeType = "generic-dark"
	theme.OverhangSliceSD = "pkg:/images/overhang_sd.png"
	theme.OverhangSliceHD = "pkg:/images/overhang_hd.png"

	theme.OverhangPrimaryLogoSD = "pkg:/images/sky_iron_side_sd.png"
	theme.OverhangPrimaryLogoHD = "pkg:/images/sky_iron_side_hd.png"

 	' NB: Numbers in the theme must be specified as strings

	theme.OverhangPrimaryLogoOffsetSD_X = "72"
	theme.OverhangPrimaryLogoOffsetSD_Y = "25"

	theme.OverhangPrimaryLogoOffsetHD_X = "128"
	theme.OverhangPrimaryLogoOffsetHD_Y = "40"

	' Different screen types need different theme values configured
	backgroundColor = "#101010"
	textColor = "#FFFFFF"

	theme.BackgroundColor = backgroundColor
	theme.PosterScreenLine1Text = textColor
	theme.PosterScreenLine2Text = textColor
	theme.ListItemText = textColor
	theme.ListScreenDescriptionText = textColor
	theme.ParagraphBodyText = textColor 
	theme.TextScreenBodyBackgroundColor = backgroundColor
	theme.TextScreenBodyText = textColor

	app.SetTheme(theme)
End Sub