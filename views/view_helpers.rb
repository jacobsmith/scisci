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

def tag_append(note)
  if note.tags != ''
    all_tags = ''
    note.tags.split(",").each do |tag|
      all_tags += link_to(" #" + tag.strip, "#tag_to_append", "tags_to_append")
    end
    return all_tags
  else
    return ''
  end
end
