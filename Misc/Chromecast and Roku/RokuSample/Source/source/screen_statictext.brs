Sub StaticTextSlide_Show(presentationData as Object, slide as Object)
	breadcrumb = slide.Breadcrumb

	If breadcrumb = Invalid Then
		breadcrumb = ""
	End If

	StaticTextScreen_Show(slide.SlideText, breadcrumb, presentationData, slide.SlideIndex)
End Sub

Sub StaticTextScreen_Show(textFilePath as String, breadcrumb as String, presentationData as Object, slideIndex as Integer)
	Print "Loading text file: " + textFilePath

	textContents = ReadAsciiFile(textFilePath)

	screenObject = Invalid

	' Needs a button to be added to close the screen if we're not going to add the Next/Previous buttons
	screenObject = StaticFallbackTextScreen_WithBreadcrumb_Show(breadcrumb, textContents)

	If presentationData <> Invalid Then
		If HasNextSlide(presentationData, slideIndex) Then
			screenObject.screen.AddButton(1, "Next")
		End If

		If HasPreviousSlide(presentationData, slideIndex) Then
			screenObject.screen.AddButton(-1, "Previous")
		End If
	End If

	screenObject.screen.AddButton(0, "Close")

	screenObject.screen.Show()

	If presentationData.ScreenToClose <> Invalid Then
		presentationData.ScreenToClose.Close()
		presentationData.ScreenToClose = Invalid
	End If

	While True
		message = wait(0, screenObject.screen.GetMessagePort())

		Print "Message Type: " + Type(message)

		If message = Invalid Then
			' I've found that occasionally I get an Invalid message object.
		ElseIf message.IsScreenClosed() Then
			Return
		ElseIf message.IsButtonPressed() Then
			buttonIndex = message.GetIndex()

			If buttonIndex = 0 Then
				Return
			End If

			If buttonIndex > 0 Then
				nextToken = screenObject.tokens.GetIndex()

				If nextToken <> Invalid Then
					' Next was selected while there's still unshown content.  Show the next element
					screenObject.AddItem(nextToken)
					buttonIndex = 0
				End If
			End If


			If buttonIndex <> 0 Then
				' Display the requested slide
				nextSlide = slideIndex + buttonIndex ' Previous is -1, Next is 1

				presentationData.ScreenToClose = screenObject.screen

				DisplaySlide(presentationData, nextSlide)

				Return
			End If
		End If

	End While

End Sub

Function StaticFallbackTextScreen_WithBreadcrumb_Show(breadcrumb as String, textContents as String) as Object

	messagePort = CreateObject("roMessagePort")
	screen = CreateObject("roParagraphScreen")

	screen.SetMessagePort(messagePort)

	If breadcrumb <> "" Then
		screen.SetTitle(breadcrumb)
	End If

	tokens = textContents.Tokenize(Chr(10))

	result = {screen: screen
			tokens: tokens
			AddItem: Function(item As String) : m.screen.AddParagraph(item) : End Function
		}

	result.tokens.ResetIndex()

	nextItem = result.tokens.GetIndex()

	If (nextItem <> invalid) Then
		result.screen.AddHeaderText(nextItem)

		nextItem = result.tokens.GetIndex()
	End If

	While nextItem <> Invalid
		result.screen.AddParagraph(nextItem)

		If nextItem.Left(1) = "-" Then
			' Bullet Points will be shown one at a time
			Exit While
		End If

		nextItem = result.tokens.GetIndex()
	End While

	Return result
End Function