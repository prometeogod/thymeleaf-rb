
def assert_html(expected, source, context = {})
  # assert_equal expected, render(source, context).to_s
  assert_equal expected, render(source, context).to_html
end

def assert_equals_html(expected, obtained)
  expected_splited = expected.split
  expected_formated = ""
  expected_splited.each {|word| expected_formated+= word }

  obtained_splited = obtained.split
  obtained_formated = ""
  obtained_splited.each {|word| obtained_formated+= word }

  assert_equal expected_formated, obtained_formated
end
