Sub DirectoryListingScreen_Show(directoryPath as String)
	directoryListing = ListDir(directoryPath)

	messagePort = CreateObject("roMessagePort")
	screen = CreateObject("roParagraphScreen")

	screen.SetMessagePort(messagePort)

	screen.AddHeaderText("Directory Listing: " + directoryPath)

	For itemCounter = 0 To (directoryListing.Count() - 1)
		nameParts = directoryListing.GetEntry(itemCounter).Tokenize(".")
		name = nameParts.GetHead()
		screen.AddButton(itemCounter, name)
	End For

	screen.Show()

	While True
		message = wait(0, messagePort)

		If message = Invalid Then
			' I've found that occasionally I get an Invalid message object.
		ElseIf message.IsScreenClosed() Then
			Return
		ElseIf Type(message) = "roParagraphScreenEvent" Then
			' Events specific to this screen type.  Here's where most commands
			' will come through.
			If message.IsButtonPressed() Then
				index = message.GetIndex()

				path = directoryPath + directoryListing.GetEntry(index)

				StaticTextScreen_Show(path, "")
			End If

		End If 

	End While


End Sub