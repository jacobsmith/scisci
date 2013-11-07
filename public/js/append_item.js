$(document).ready( function() {
});
  
$('.tags_to_append').click( function() {
  clicked_tag = $(event.target).html();
  clicked_tag += ", "
  tag_to_append = clicked_tag.substring(1);
    $('#tags').val($('#tags').val() + tag_to_append); 
  });
