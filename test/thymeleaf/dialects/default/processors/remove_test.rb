require 'thymeleaf'
# DefaultProcessor test
describe RemoveProcessor do
  it 'should return true if it is empty string' do
    empty = '	'
    no_empty = 'attributes'
    processor = RemoveProcessor.new
    result = processor.send(:empty_string?, empty)
    assert_equal result, true

    result2 = processor.send(:empty_string?, no_empty)
    assert_equal result2, false
  end
end
