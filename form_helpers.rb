require './views/view_helpers.rb'

def create_form_header(url, id='')
  element = ""
  element <<  "<form action=\"/" + url 
  element <<  "/" + @request.id.to_s if @request.respond_to?("id")  
  element << '" method="post" class="form-horizontal">'
  element << "\n"
  return element
end

def create_inputs(type, labels, value = nil, columns = 0, rows = 0)
  element = ''
  labels.each do |label|
    saved_value = @request.respond_to?(label) ? @request.send(label) : "" 
    element << '<div class="control-group">'
    element <<  '<label class="control-label" for="' + label + '">' + underscore_to_words(label) + '</label>'
    element << '<div class="controls span0">'
    element <<  "<input type=\"" + type + "\" class=\"span4\"" if type != 'textarea'
    element << '<textarea class="span4" rows="4" ' if type == 'textarea'
    element << " id=\"" + label + "\" name=\"" + label + "\" value=\"" + saved_value + "\">"
#    element << '</input>' if type != 'textarea'
    element << '</textarea>' if type == 'textarea'
    element << '</div>'
    element << '</div>'
    element << "\n"
    element << "<br>" if label == labels[-1] 
    element << "<br>"
  end
  return element 
end

def create_drop_down(category, options)
  #pass array to options to iterate throw in the drop down
  element = ''
  saved_value = @request.respond_to?(category) ? @request.send(category) : ""
  element <<  "<label for=\"" + category + "\">" + underscore_to_words(category) + "</label>"
  element <<  "<select name=\"" + category + "\">"

  options.each do |option|
    option = option.to_s
    element <<  "  <option value=\"" + option + "\""
    element << "selected=\"selected\"" + saved_value if option == saved_value      
    element << ">" + underscore_to_words(option) + "</option>"
    element << "\n"
  end

  element <<  "</select>"
  element << "<br>"
  element << "\n" 
end

def check_box(id)
  completed = @request.completed if @request.respond_to?("completed")
  element = ""
  element << "<li>"
  element << "<input type=\"checkbox\""
  element << " checked" if completed == true 
  element << " value=\"true\" name=\"" + id.to_s + "\">" + underscore_to_words(id.to_s) + "<br>"
  element << "</li>"
end

def hidden_form(name, value)
  return "<input type=\"hidden\" name=\"#{name}\" value=\"#{value}\">"
end

def create_form_submit(text = "Submit")
  element = ''
  element <<  '<button type="submit" class="btn">'
  element << text
  element << '</button>'
  element <<  "</form>"
end

def underscore_to_words(string_with_underscores)
  string_with_underscores.split("_").map { |i| i.capitalize }.join(" ")
end

def link_to(text, url)
    "<a href='#{url}' >#{text}</a>"
end
 
def url_is(string) 
  return true if request.path_info == string 
end 

def url_not(string) 
  return true if request.path_info != string 
end 

def create_tabs()
  element = ''
  element << '<div class="tabbale tabs-left">' 
  element << '<ul class="nav nav-tabs" data-toggle="tabs">'
  @sources.each do |source|
    element << '<li><a href="#' + source.id.to_s + '" data-toggle="tab">' + source.title + '</a></li>'
  end
  element << '</ul>' #end of creating tabs themselves

  #tab content

  element << "\n"
  element << '<div class="tab-content">'
  @sources.each do |source|
    element << '<div id="' + source.id.to_s + '" class="tab-pane">'
      source.note.each do |note|
        element << note.quote + "<br>" if note.source == source
      end
      element << '</div>'
    end
  element << '</div>'
  element << '</div>'

  return element
end

def create_tabs2()
  element = ''
  element << '<div class="tabbale tabs-left">' 
  element << '<ul class="nav nav-tabs" data-toggle="tabs">'
  @sources.each do |source|
    element << '<li><a href="#' + source.title.split.join.to_s + source.id.to_s + '" data-toggle="tab">' + source.title + '</a></li>'
  end
  element << '</ul>' #end of creating tabs themselves

  #tab content

  element << "\n"
  element << '<div class="tab-content">'
  @sources.each do |source|
    element << '<div id="' + source.title.split.join.to_s + source.id.to_s + '" class="tab-pane">'
    element << '<ul class="list-group span7">'

    source.note.each do |note|
      element << '<li class="list-group-item">'
      element << note.quote + toggle_visibility(note) + "<br>" if note.source == source
      element << expand(note)
      element << '</li>'
    end
    element << '</ul>' 
    element << '</div>'
  end
  element << '</div>'

  return element
end

def expand(note)
  element = ''
  element << '<p style="display:none" id="' + note.id.to_s + '">'
  element << 'Page: ' + note.page.to_s if note.page != ''
  element << ' Tags: ' + tag_links(note) if note.tags != ''
  element << '<br> Comments: ' + note.comments.to_s if note.comments != ''
  element << '</p>'
end

def toggle_visibility(note)
  element = ''
    ##href=#expand -- points to non-existant div, so it doesn't go anywhere
  element << '<a href="#expand" onclick="toggle_visibility(\''
  element << note.id.to_s
  element << '\');"> &raquo;'
  element << '</a>'
end

def flash_message(message, type_of_notice)
  element = ''
  element << '<div id="flash" class="alert alert-dismissable span11 '
  element << "alert-#{type_of_notice}\">" 
  element << message.to_s
  element << '</div>'
  element << "<script type=\"text/javascript\">('#flash').fadeOut();</script>"
  return element
end


