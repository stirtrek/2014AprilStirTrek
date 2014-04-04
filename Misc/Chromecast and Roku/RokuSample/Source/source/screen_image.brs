
Sub ImageSlide_Show(presentationData as Object, slide as Object)
	
	messagePort = CreateObject("roMessagePort")
	screen = CreateObject("roParagraphScreen")

	screen.SetMessagePort(messagePort)

	If slide.Breadcrumb <> Invalid Then
		slide.SetTitle(slide.Breadcrumb)
	End If

	screen.AddGraphic(slide.SlideImage, "scale-to-fit")

	If presentationData <> Invalid Then
		If HasNextSlide(presentationData, slide.SlideIndex) Then
			screen.AddButton(1, "Next")
		End If

		If HasPreviousSlide(presentationData, slide.SlideIndex) Then
			screen.AddButton(-1, "Previous")
		End If
	End If

	screen.Show()

	While True
		message = wait(0, screen.GetMessagePort())

		Print "Message Type: " + Type(message)

		If message = Invalid Then
			' I've found that occasionally I get an Invalid message object.
		ElseIf message.IsScreenClosed() Then
			Return
		ElseIf message.IsButtonPressed() Then
			buttonIndex = message.GetIndex()

			If buttonIndex <> 0 Then
				nextSlide = slide.SlideIndex + buttonIndex ' Previous is -1, Next is 1

				DisplaySlide(presentationData, nextSlide)

			End If

			' This screen should close afer the button is processed and any child screens are shown
			Return
		End If

	End While

End Sub
