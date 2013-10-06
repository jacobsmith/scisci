def create_form_header(url, id='')
  element = ""
  element <<  "<form action=\"/" + url 
  element <<  "/" + @request.id.to_s if @request.respond_to?("id")  
  element << "\" method=\"post\">"
  element << "\n"
  return element
end

def create_inputs(type, labels, value = nil, columns='', rows='', end_break = true)
  element = ''
  labels.each do |label|
    saved_value = @request.respond_to?(label) ? @request.send(label) : "" 
    element <<  "<label for=\"" + label + "\">" + underscore_to_words(label) + "</label>"
    element <<  "<input type=\"" + type + "\" id=\"" + label + "\" name=\"" + label + "\" value=\"" + saved_value + "\">"
    element << "\n"
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
    element << "selected=\"selected\"" + @request.send(category).to_s if option == saved_value      
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

def create_form_submit()
  element = ''
  element <<  "<input type=\"submit\">"
  element <<  "</form>"
end

def underscore_to_words(string_with_underscores)
  string_with_underscores.split("_").map { |i| i.capitalize }.join(" ")
end

def link_to(text, url)
    "<a href='#{url}' >#{text}</a>"
end
