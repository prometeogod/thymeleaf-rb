require_relative '../nodetree'
require_relative 'cache'
require_relative 'node_value_date'
require_relative '../utils/json_to_nodetree_converter'
require 'json'
require 'time'
require 'fileutils'

# CacheManager definition : Controls the E/S operations for the Cache
class CacheManager
  attr_accessor :parsed_cache, :fragment_cache

  def clear_caches
    folder = 'lib/thymeleaf/cache/parsed_cache/'
    folder1 = 'lib/thymeleaf/cache/fragment_cache/'
    files = Dir.glob("#{folder}/*") + Dir.glob("#{folder1}/*")
    files.each { |file| FileUtils.rm_rf file }
  end

  def create_parsed_cache
    self.parsed_cache = Cache.new
    cache_path = 'lib/thymeleaf/cache/parsed_cache'
    mem2parsed_cache(cache_path, parsed_cache)
  end

  def create_fragment_cache
    self.fragment_cache = Cache.new
    cache_path = 'lib/thymeleaf/cache/fragment_cache'
    mem2fragment_cache(cache_path, fragment_cache)
  end

  # Read memory and creates a parsed templates cache
  def mem2parsed_cache(folder, cache)
    Dir.mkdir(folder, 0o700) unless Dir.exist?(folder)
    Dir.foreach(folder) do |file|
      if (file != '.') && (file != '..')
        time, nodetree_list = read_file_cache(folder + '/' + file)
        nodevd = NodeValueDate.new(nodetree_list, time)
        cache.set(file, nodevd)
      end
    end
  end

  def mem2fragment_cache(folder, cache)
    Dir.mkdir(folder, 0o700) unless Dir.exist?(folder)
    Dir.foreach(folder) do |file|
      if (file != '.') && (file != '..')
        key, nodetree_list = read_file_fragment(folder + '/' + file)
        cache.set(key, nodetree_list.first)
      end
    end
  end

  def write_file_cache(node_list, filename)
    file_suffix = '.th.parsed_cache'
    file_preffix = 'lib/thymeleaf/cache/parsed_cache/'
    file_path = file_preffix + filename + file_suffix

    list = node_list.map(&:to_h)
    hash = {
      time: Time.now,
      value: list
    }
    json = hash.to_json
    File.open(file_path, 'w+') { |file| file.puts json }
  end

  def read_file_cache(filename)
    hash = read_file_json(filename)

    nodes = hash['value']
    time = Time.parse(hash['time']) # Unica linea que cambia

    nodetree_list = JSONToNodetreeConverter.new.to_nodetree(nodes)
    [time, nodetree_list]
  end

  def write_file_fragment(node, key, filename)
    file_suffix = '.th.fragment_cache'
    file_preffix = 'lib/thymeleaf/cache/fragment_cache/'
    file_path = file_preffix + filename + file_suffix
    list = [] << node.to_h
    hash = {
      key: key,
      value: list
    }
    json = hash.to_json
    File.open(file_path, 'w+') { |file| file.puts json }
  end

  def read_file_fragment(filename)
    hash = read_file_json(filename)

    nodes = hash['value']
    key = hash['key'] # Unica linea que cambia

    nodetree_list = JSONToNodetreeConverter.new.to_nodetree(nodes)
    [key, nodetree_list]
  end

  private

  def read_file_json(filename)
    json = ''
    File.open(filename, 'r') do |file|
      while (linea = file.gets)
        json << linea
      end
    end
    JSON.parse(json)
  end
end
