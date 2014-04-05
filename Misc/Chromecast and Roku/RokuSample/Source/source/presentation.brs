' Methods related to the presentation metadata

Function GetSlide(presentationData, slide)
	Return GetSlideInCategory(presentationData, 0, slide)
End Function

Function GetSlideInCategory(presentationData as Object, category as Integer, slide as Integer)
	slidesInCategory = GetSlidesInCategory(presentationData, category)

	If slide > slidesInCategory - 1 Then
		Return GetSlideInCategory(presentationData, category + 1, slide - slidesInCategory)
	Else
		Return presentationData.categories.GetEntry(category).slides.GetEntry(slide)
	End If
End Function

Function GetSlidesInCategory(presentationData as Object, category as Integer) As Integer
	Return presentationData.categories.GetEntry(category).slides.Count()
End Function

Function HasNextSlide(presentationData as Object, slideIndex as Integer) As Boolean
	Return slideIndex < presentationData.slideCount - 1
End Function

Function HasPreviousSlide(presentationData as Object, slideIndex as Integer) As Boolean
	Return slideIndex > 0
End Function

Sub SetSlideIndices(presentationData As Object)
	counter = 0

	For Each category in presentationData.categories
		For Each slide in category.slides
			slide.SlideIndex = counter

			counter = counter + 1
		End For
	End For

	presentationData.slideCount = counter
End Sub

Sub DisplaySlide(presentationData as Object, slideIndex as Integer)
	slide = GetSlide(presentationData, slideIndex)

	Print "Showing slide:" + slide.ShortDescriptionLine1

	If slide.DoesExist("SlideText") Then
		' We want to show a text file.  Fire up a text screen
		StaticTextSlide_Show(presentationData, slide)
	ElseIf slide.DoesExist("SlideImage") Then
		ImageSlide_Show(presentationData, slide)
	End If

End Sub