require_relative '../test_helper'
require 'thymeleaf/template'
describe Thymeleaf::Template do 
  before(:each) do
    # Something to run before every test
  end
  
  it 'should be an begin tag and an end tag' do
    simple_template = '<p></p>'
    processed = render(simple_template)
    assert_equal processed, simple_template
  end

  it 'should be tags with a simple id attribute' do
    html_attribute = '<p id="1"></p>' 
    processed = render(html_attribute)
    assert_equal processed, html_attribute
  end 

  it 'should be a normal tags and text content' do 
    text_template = '<p data-th-text="Texto"></p>'
  	processed = render(text_template)
  	assert_equal processed, simple_result
  end

  it 'should be a normal tags and utext content' do
    utext_template = '<p data-th-utext="Texto"></p>' 
  	processed = render(utext_template)
  	assert_equal processed, simple_result
  end

  it 'should write text and utext ' do
    utext_and_text = '<p data-th-utext="Texto" data-th-text="Texto"></p>'
  	processed = render(utext_and_text)
  	assert_equal processed, '<p>TextoTexto</p>'
  end

  it 'should write tags and text' do
    simple_child_text = '<p>Texto</p>' 
  	processed = render(simple_child_text)
    assert_equal processed, simple_result
  end

  it 'should write tags and text content cause if its true' do
    if_template = '<p data-th-if="${bool}">Texto</p>'
    processed = render(if_template, {'bool' => true})
    assert_equal processed, simple_result
  end

  it 'should write tags and text content cause unless its false' do
    unless_template = '<p data-th-unless="${bool}">Texto</p>'
    processed = render(unless_template, {'bool' => false})
    assert_equal processed, simple_result
  end

  it 'should write the  tags and the correct election of text' do 
    switch_template = '<div data-th-switch="${numero}">
<p data-th-case="1" data-th-text="Texto"></p>
<p data-th-case="2" data-th-text="No"></p>
</div>'
    processed = render(switch_template, {'numero' => 1})
    assert_equal processed, switch_result
  end

  it 'should remove data-th attribute and create a new one with the last part' do
    default_template = '<p data-th-class="Texto">Texto</p>' 
    processed = render(default_template)
    assert_equal processed, default_result
  end

  it 'should remove the th block tag and process child' do
    block_template = '<th-block data-th-class="list list-tag">
        <p data-th-unless="${must_show}" data-th-text="Texto"></p>
    </th-block>' 
    processed = render(block_template,{'must_show' => false})
    assert_equal processed.squeeze, block_result
  end

  it 'should repeat the text the number of items of the list passed' do
    each_template = '<p data-th-each= "element : ${list}" data-th-text="Texto">Texto</p>' 
    processed = render(each_template, {'list' => [1,2,3]})
    assert_equal processed, each_result
  end 

  it 'should remove none' do
    remove_none = '<p data-th-remove="none">Texto</p>'
    processed = render(remove_none)
    assert_equal processed, simple_result
  end

  it 'should remove all' do
    remove_all = '<p data-th-remove="all">Texto</p>' 
    processed = render(remove_all)
    assert_equal processed, ''
  end

  it 'should remove body' do
    remove_body = '<p data-th-remove="body">Texto</p>'
    processed = render(remove_body)
    assert_equal processed, '<p></p>'
  end

  it 'should remove tag' do
    remove_tag = '<p data-th-remove="tag"><p>Texto</p></p>'
    processed = render(remove_tag)
    assert_equal processed, simple_result
  end

  it 'should remove all but first' do
    remove_all_but_first = '<p data-th-remove="all-but-first">Texto<b>Borrar</b></p>'
    processed = render(remove_all_but_first)
    assert_equal processed, simple_result
  end

  it 'should process the fragment attribute' do
    fragment = '<p data-th-fragment="fragment">Texto</p>'
    processed = render(fragment)
    assert_equal processed, simple_result
  end

  it 'should process the insert attribute and insert none' do
    insert_error = '<p data-th-insert="this">Texto</p>'
    processed = render(insert_error)
    assert_equal processed, '<p></p>'
  end

  it 'should process the insert attribute and insert a page fragment' do
    insert_own_page_fragment='<p data-th-fragment="texto">Texto</p>
<p data-th-insert="this::texto"></p>'
    processed = render(insert_own_page_fragment)
    assert_equal processed, insert_fragment_result
  end

  it 'should process insert attribute with a fragment in short form' do 
    insert_own_page_fragment='<p data-th-fragment="texto">Texto</p>
<p data-th-insert="::texto"></p>'
    processed = render(insert_own_page_fragment)
    assert_equal processed, insert_fragment_result
  end

  it 'should process insert attribute with a DOM replacement ' do 
    # TODO test it 
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
  
  def insert_fragment_result
    '<p>Texto</p>
<p><p>Texto</p></p>'
  end
end