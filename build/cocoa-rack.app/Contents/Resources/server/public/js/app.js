
$(document).ready(function(){

  var $button = $('button');
  var $input  = $('input');
  var $select = $('select');

  $button.on('click',   function(){ speak() });
  $input.on('keypress', function(ev){ 
    if (ev.which == 13) speak() 
  });

  function speak(){
    $.post('/say', { text: $input.val(), voice: $select.val() })
  }

})