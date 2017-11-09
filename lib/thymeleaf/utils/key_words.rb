
def key_words
  ['text-content', 'comment', 'doctype', 'meta']
end

def key_word?(word)
  key_words.any? { |w| w == word }
end
