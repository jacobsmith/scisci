def li(css_class="", id = "", *args)
  '<li class="' + css_class.to_s + '" id="' + id.to_s + '">' + args.join(" ") + '</li>'
end

def p(css_class="", id="", *args)
 '<p ' + css_class_id + args.join(" ") 
end

def css_tag(type, css_class, id, *args)
  "<#{type} #{css_class_id(css_class, id)}" + args.join + "</#{type}>"
end

def css_class_id(css_class, id)
  'class="' + css_class.to_s + '" id="' + id.to_s + '">'
end

puts css_tag("p", "expand", "first_element", li(nil, nil, "this is a cool test in a list element"))

puts li(css_class="expand", nil, "this is a test")
puts li("this", "is", "a", "test")
