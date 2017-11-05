require_relative '../test_helper'
require 'thymeleaf'
# Test Template
class TemplateTest < TestThymeleaf
  def template_content
    '<p data-th-text="Hello, ${user}">Hello, world</p>'
  end

  def template_result
    '<p>Hello, John</p>'
  end

  def test_template_render
    assert_equal render(template_content, user: 'John'), template_result
  end

  def file_render_context
    {
      'subtemplate' => {
        'title' => 'Included title',
        'text'  => 'Included content!'
      }
    }
  end

  def file_render_result
    '<div id="content-included">
    <h2>Included title</h2>
    <p>Included content!</p>
</div>'
  end

  def test_file_render
    context = file_render_context
    result = file_render_result
    file = 'content'
    rendered = Thymeleaf::Template.new(file, context).render_file
    assert_equal rendered, result
  end
end
