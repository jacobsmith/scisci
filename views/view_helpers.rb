def tag_links(note)
   note.tags.split(",").each do |tag| 
    return link_to("#" + tag.strip, "/tag/#{tag}") 
   end 
end 
