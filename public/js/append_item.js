$(document).ready( function() {
});
  
$('.tags_to_append').click( function() {
    $('#tags').val($('#tags').val() + $(this.text)); 
  });
