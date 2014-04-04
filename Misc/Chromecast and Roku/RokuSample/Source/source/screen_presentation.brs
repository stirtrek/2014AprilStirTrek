Sub PresentationScreen_Show(presentationData as Object)
	messagePort = CreateObject("roMessagePort")
	screen = CreateObject("roPosterScreen")

	screen.SetMessagePort(messagePort)

	categoryNames = []

	For Each c in presentationData.categories
		categoryNames.Push(c.title)
	End For

	screen.SetListStyle("arced-landscape")

	screen.SetListNames(categoryNames)

	selectedCategory = 0
	ShowSlidesInSection(screen, presentationData, selectedCategory)

	screen.Show()

	While True 
		message = wait(0, messagePort)

		If message = Invalid Then
			'' Continue
		ElseIf message.IsScreenClosed() Then
			Return
		ElseIf message.IsListFocused() Then
			selectedCategory = message.GetIndex()

			ShowSlidesInSection (screen, presentationData, selectedCategory)
		ElseIf message.IsListItemSelected() Then
			slideIndex = message.GetIndex()

			slide = GetSlideInCategory(presentationData, selectedCategory, slideIndex)

			DisplaySlide(presentationData, slide.SlideIndex)
		End If
	End While

End Sub

Sub ShowSlidesInSection(screen as Object, presentationData As Object, selectedCategory as Integer)
	Print "Showing category:" + Str(selectedCategory)
	category = presentationData.categories.GetEntry(selectedCategory)

	screen.SetContentList(category.slides)
	screen.SetFocusedListItem(0)
End Sub