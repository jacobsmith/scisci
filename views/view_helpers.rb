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

def tag_append(source)
    
  @all_tags = {}
  @all_tags.default = 0

  source.note.map { |note|
    if note.tags != ""
      note.tags.split(",").each do |tag|
        #ensure we don't add empty tags (tag.strip will still add "" as a valid entry)
        @all_tags[tag.strip] += 1 if tag.strip != ""
      end
    end
  } 
  sorted_tags = @all_tags.sort_by { |key, value| value }.reverse

  #doing a hack to return tags with links--not the best solution, but working
  tags = "" 
  sorted_tags.each { |tag, value| tags += link_to("#" + tag.to_s, "#tag_to_append", "tags_to_append") + " " }
  return tags
end
  

