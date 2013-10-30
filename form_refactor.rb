#still need to implement saved_values for editing later on

class Div
  def initialize 
  end

  def div_open(div_class="", id="")
   %Q{ 
    <div class="#{div_class}" id="#{id}"> 
  }
  end

  def div_close
    %Q{ 
    </div>
    } 
  end 

end



class FormInput
  def initialize 
  end

  def form_start(post_url="", div_class="") 
  %Q{
    <form action="#{post_url}" method="post" class="#{div_class}">
  } 
  end

  def text(label, label_class="", div_class="", id="")
    %Q{
      <label class="#{label_class}" for="#{id}">#{label}</label>
      <input type="text" class="#{div_class}" id="#{id}">
    }
  end

  def textarea(label="", label_class="", div_class="", id="")
    %Q{
      <label class="#{label_class}" for="#{id}">#{label}</label>
      <textarea class="#{div_class}" id="#{id}"></textarea>
    }
  end

  def form_end
  %Q{
    </form>
  } 
  end
end



#def refactor_inputs(type, labels, value = nil, columns = 0, rows = 0)
#  element = ''
#  labels.each do |label|
#    saved_value = @request.respond_to?(label) ? @request.send(label) : "" 
#    element << '<div class="control-group">'
#    element << '<label class="control-label" for="' + label + '">' + underscore_to_words(label) + '</label>'
#    element << '<div class="controls span0">'
#    element << '<input type="' + type + '" class="span4"' if type != 'textarea'
#    element << '<textarea class="span4" rows="4" ' if type == 'textarea'
#    element << ' id="' + label + '" name="' + label + '" value="' + saved_value + '">'
#    element << '</textarea>' if type == 'textarea'
#    element << '</div>'
#    element << '</div>'
#    element << "\n"
#    element << '<br>' if label == labels[-1] 
#    element << '<br>'
#  end
#  return element 
#end

d = Div.new
f = FormInput.new
puts d.div_open("class_abc", "id123")

puts f.form_start("/all_notes", "left-align")

puts d.div_open("form-control")
puts f.text("label1", "label_class", "div_class", "id")
puts d.div_close

puts f.textarea("label2", "label_class", "div_class", "id")
puts f.form_end
puts d.div_close
