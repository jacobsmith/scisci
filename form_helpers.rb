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
    element << '<div class="controls">'
    element <<  "<input type=\"" + type + "\""
    element << "\" style=\"height:100px; width:300px;\"" if type == 'textarea' 
    element << " id=\"" + label + "\" name=\"" + label + "\" value=\"" + saved_value + "\">"
    element << '</div>'
    element << '</div>'
    element << "\n"
    element << "<br>" if label == labels[-1] 
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
