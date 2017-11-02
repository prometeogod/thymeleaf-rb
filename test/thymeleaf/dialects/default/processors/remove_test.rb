require 'thymeleaf'
# DefaultProcessor test
describe RemoveProcessor do
  it 'should return true if it is empty' do
    empty = {}
    no_empty = { attr: 1 }
    processor = RemoveProcessor.new
    result = processor.send(:empty_attributes?, empty)
    assert_equal result, true

    result2 = processor.send(:empty_attributes?, no_empty)
    assert_equal result2, false
  end
end
