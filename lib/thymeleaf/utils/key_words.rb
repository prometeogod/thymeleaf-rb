
def key_words
  ['text_content', 'comment', 'doctype', 'meta']
end

def key_word?(word)
  key_words.any? { |w| w == word }
end
