class TestNameParser < TestThymeleaf
  require 'thymeleaf/utils/name_parser'

  def test_to_cache_name
    filename = 'test/templates/block.th.test'
    cache_name = 'test_templates_block_th_test'
    suffix = '.th.parsed_cache'
    assert_equal to_cache_name(filename), cache_name
    assert_equal to_cache_name(filename, suffix), cache_name + suffix
  end

  def test_to_file_name
  	filename = 'test/templates/block.th.test'
    cache_name = 'test_templates_block_th_test'
    suffix = '.th.test'
    assert_equal to_file_name(cache_name, suffix), filename
  end
 
end

