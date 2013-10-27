def tag_links(note)
  if note.tags != ''
    note.tags.split(",").each do |tag| 
      return link_to("#" + tag.strip, "/tag/#{tag}") 
    end
  else
    return ''
  end 
end 
