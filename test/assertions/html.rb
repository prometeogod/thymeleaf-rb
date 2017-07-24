
def assert_html(expected, source, context = {})
  #assert_equal expected, render(source, context).to_s
  assert_equal expected, render(source,context).to_html
end