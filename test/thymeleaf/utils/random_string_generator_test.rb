require 'thymeleaf/utils/random_string_generator'

describe RandomStringGenerator do
  it 'should generate a string' do
    random = RandomStringGenerator.new.random
    assert_equal random.is_a?(String), true
  end
end
