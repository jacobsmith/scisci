def tag_links(note)
  if note.tags != ''
    all_tags = ''
    note.tags.split(",").each do |tag| 
      all_tags += link_to(" #" + tag.strip, "/tag/#{tag}")
    end
    return all_tags
  else
    return ''
  end 
end 
