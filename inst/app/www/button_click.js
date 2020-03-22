//$(document).keyup(function(event) {
//  if ($("question-div").is(":focus") && (event.key == "Enter")) {
//    $("next_question").click();
//  }
//});

//$(document).keyup(function(event) {
//  if (event.key == "Enter") {
//    $("next_question").click();
//  }
//});

document.onkeydown = function (e) {
  e = e || window.event;
  var key = (e.which || e.keyCode),
  // pressed = {68:'next_question', 65:'show_answer', 83:'back_to_question', 87:'know_it'};
  pressed = {68:'gen_card_ui_1-next_question', 65:'gen_card_ui_1-show_answer', 83:'gen_card_ui_1-back_to_question', 87:'gen_card_ui_1-know_it'};
				
  if( typeof pressed[ key ] === 'undefined' )
    return;
				
	button = document.getElementById(pressed[ key ]);
	if (button.classList.contains("shinyjs-hide"))
	  return;
	  
  button.click();
 };
 