
def assert_html_page(expected, source, context = {})
  # assert_equal render(expected,{}).to_s, render(source, context).to_s
  assert_equal expected.to_s, render(source, context).to_s
end
