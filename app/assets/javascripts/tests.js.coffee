question_num = 0
all_data = []
started = false

window.addEventListener 'load', () ->
	new FastClick(document.body);
, false

color_map = {
	Red: "#F2003C",
	Brown: "#855A2D",
	Green: "#2CDE6A",
	Purple:"#9F5AC7"
}

combinations = [
	{"color":"purple", "text":"brown"},
	{"color":"red", "text":"red"},
	{"color":"green", "text":"purple"},
	{"color":"brown", "text":"purple"},
	{"color":"purple", "text":"green"},
	{"color":"brown", "text":"brown"},
	{"color":"purple", "text":"purple"},
	{"color":"red", "text":"green"},
	{"color":"purple", "text":"brown"},
	{"color":"green", "text":"purple"}
]

fisher_yates = (arr) ->
	m = arr.length
	while m
		i = Math.floor(Math.random() * m-=1)
		t = arr[m]
		arr[m] = arr[i]
		arr[i] = t
	arr


next_test = () ->
	attempts = 0
	t_start = Date.now()
	color = combinations[question_num].color
	word = combinations[question_num].text
	$(".test-text").text(word).css("color", color)
	$("#button_list").empty()
	fisher_yates(Object.keys(color_map)).map (name) ->
		$("<button>")
			.addClass("btn btn-large")
			.text(name)
			.appendTo("#button_list")
			.one 'click', ->
				attempts += 1
				if name.toLowerCase() is color
					question_num += 1
					all_data.push({
						color: color,
						word: word,
						elapsed: Date.now() - t_start,
						attempts: attempts
					})
					splash()
				else
					$(this).remove()

splash = () ->
	$(".test-container").hide()
	$(".splash-screen").removeClass("hidden")
	$(".progress-text").text(question_num + "/" + combinations.length)
	$(".bar").css("width",  (question_num/combinations.length)*100 + "%")

	if not started
		$(".btn-start").one 'click', ->
			started = true
			$(this).remove()
			$(".btn-next").removeClass("hidden")
			unsplash()
	else if question_num < combinations.length
		$(".btn-next").one 'click', ->
			unsplash()
	else
		finished()

unsplash = () ->
	$(".test-container").show()
	$('.splash-screen').addClass("hidden")
	next_test()

finished = () ->
	$.post("/test/submit-data", {  test_data:all_data } )
	$(".test-container").hide()
	$(".splash-screen").hide()
	$(".end-screen").removeClass("hidden")
	window.location = "/"


splash()
