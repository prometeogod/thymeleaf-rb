require_relative '../test_helper'
require 'thymeleaf/template'
describe Thymeleaf::Template do 
  before(:each) do
    @simple_template = '<p></p>'
    @html_attribute = '<p id="1"></p>'
    @text_template = '<p data-th-text="Texto"></p>'
    @utext_template = '<p data-th-utext="Texto"></p>'
    @utext_and_text = '<p data-th-utext="Texto" data-th-text="Texto"></p>'
    @simple_child_text = '<p>Texto</p>'
    @if_template = '<p data-th-if="${bool}">Texto</p>'
    @unless_template = '<p data-th-unless="${bool}">Texto</p>'
    @switch_template = '<div data-th-switch="${numero}">
<p data-th-case="1" data-th-text="Texto"></p>
<p data-th-case="2" data-th-text="No"></p>
</div>'
    @default_template = '<p data-th-class="Texto">Texto</p>'
    @block_template = '<th-block data-th-class="list list-tag">
        <p data-th-unless="${must_show}" data-th-text="Texto"></p>
    </th-block>'
    @each_template = '<p data-th-each= "element : ${list}" data-th-text="Texto">Texto</p>'
    @remove_none = '<p data-th-remove="none">Texto</p>'
    @remove_all = '<p data-th-remove="all">Texto</p>'
    @remove_body = '<p data-th-remove="body">Texto</p>'
    @remove_tag = '<p data-th-remove="tag"><p>Texto</p></p>'
    @remove_all_but_first = '<p data-th-remove="all-but-first">Texto<b>Borrar</b></p>'
  end
  
  it 'should be a contracted tag' do
    processed = render(@simple_template)
    assert_equal processed, '<p/>'
  end

  it 'should be a contrated with a simple id attribute' do 
    processed = render(@html_attribute)
    assert_equal processed, "<p id=\"1\"/>"
  end 

  it 'should be a normal tags and text content' do 
  	processed = render(@text_template)
  	assert_equal processed, simple_result
  end

  it 'should be a normal tags and utext content' do 
  	processed = render(@utext_template)
  	assert_equal processed, simple_result
  end

  it 'should write text and utext ' do
  	processed = render(@utext_and_text)
  	assert_equal processed, '<p>TextoTexto</p>'
  end

  it 'should write tags and text' do 
  	processed = render(@simple_child_text)
    assert_equal processed, simple_result
  end

  it 'should write tags and text content cause if its true' do
    processed = render(@if_template, {'bool' => true})
    assert_equal processed, simple_result
  end

  it 'should write tags and text content cause unless its false' do
    processed = render(@unless_template, {'bool' => false})
    assert_equal processed, simple_result
  end

  it 'should write the  tags and the correct election of text' do 
    processed = render(@switch_template, {'numero' => 1})
    assert_equal processed, switch_result
  end

  it 'should remove data-th attribute and create a new one with the last part' do 
    processed = render(@default_template)
    assert_equal processed, default_result
  end

  it 'should remove the th block tag and process child' do 
    processed = render(@block_template,{'must_show' => false})
    assert_equal processed.squeeze, block_result
  end

  it 'should repeat the text the number of items of the list passed' do 
    processed = render(@each_template, {'list' => [1,2,3]})
    assert_equal processed, each_result
  end 

  it 'should remove none' do 
    processed = render(@remove_none)
    assert_equal processed, simple_result
  end

  it 'should remove all' do 
    processed = render(@remove_all)
    assert_equal processed, ''
  end

  it 'should remove body' do 
    processed = render(@remove_body)
    assert_equal processed, '<p></p>'
  end

  it 'should remove tag' do 
    processed = render(@remove_tag)
    assert_equal processed, simple_result
  end

  it 'should remove all but first' do 
    processed = render(@remove_all_but_first)
    assert_equal processed, simple_result
  end
  
  private

  def render(source, context = {})
    Thymeleaf::Template.new(source, context).render
  end

  def simple_result
    '<p>Texto</p>'
  end

  def switch_result
    '<div>
<p>Texto</p>

</div>'
  end

  def default_result
    '<p class="Texto">Texto</p>'
  end

  def block_result
    '
 <p>Texto</p>
 '
  end

  def each_result
    '<p>Texto</p><p>Texto</p><p>Texto</p>'
  end  

end