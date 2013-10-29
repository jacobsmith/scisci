class FormInput
  def setup

  end

  def text(label)

  end

  def textarea(label)

  end

end


def refactor_inputs(type, labels, value = nil, columns = 0, rows = 0)
  element = ''
  labels.each do |label|
    saved_value = @request.respond_to?(label) ? @request.send(label) : "" 
    element << '<div class="control-group">'
    element << '<label class="control-label" for="' + label + '">' + underscore_to_words(label) + '</label>'
    element << '<div class="controls span0">'
    element << '<input type="' + type + '" class="span4"' if type != 'textarea'
    element << '<textarea class="span4" rows="4" ' if type == 'textarea'
    element << ' id="' + label + '" name="' + label + '" value="' + saved_value + '">'
    element << '</textarea>' if type == 'textarea'
    element << '</div>'
    element << '</div>'
    element << "\n"
    element << '<br>' if label == labels[-1] 
    element << '<br>'
  end
  return element 
end
