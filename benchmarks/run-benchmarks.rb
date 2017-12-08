#!/usr/bin/env ruby

require_relative '../lib/thymeleaf_test'
require_relative '../compare/thymeleaf-Noko/thymeleaf-Noko'
require_relative 'suite'
require_relative 'test_runners/erb'
require_relative 'test_runners/th'
require_relative 'test_runners/th-Noko'
require_relative './utils/monkey'

require 'benchmark/ips'
require 'benchmark/memory'
require 'awesome_print'
require 'fileutils'


Thymeleaf.configure do |config|
  config.template.prefix = "#{__dir__}/../test/templates/"
  config.template.suffix = '.th.html'
end
# Thymeleaf Nokogiri configuration to compare
ThymeleafNoko.configure do |config|
  config.template.prefix = "#{__dir__}/../test/templates/"
  config.template.suffix = '.th.html'
end
# ------------------------------------------
ap "[PERF] -----------------------------"

ThymeleafTest::TestDir::find_erb do |testfile|

  bench_name = testfile.test_name
  current_time = Time.now.strftime "%Y%m%d%H%M%S"
  save_test_dir = "#{__dir__}/results/ips"
  save_test_dir_m = "#{__dir__}/results/memory"
  save_test_dir_ips = "#{__dir__}/results/ips/#{bench_name}"
  save_test_dir_memory = "#{__dir__}/results/memory/#{bench_name}"
  suite = ThymeleafBenchSuite.new

  ap "[Bench:#{bench_name}] -----------------------------"

  # Pit Th against other template solutions. Also compare speed/memory performance against a baseline
  Benchmark.ips do |b|
    b.config(suite: suite, time: 2, warmup: 1)
    b.report("thymeleaf.rb") { ThTestRunner::render(testfile)  }
    b.report("ERB")          { ErbTestRunner::render(testfile) }
    b.compare!
    Dir.mkdir(save_test_dir) unless Dir.exists?(save_test_dir) 
    Dir.mkdir(save_test_dir_ips) unless Dir.exists?(save_test_dir_ips)
    json_name = b.json! "#{save_test_dir_ips}/#{current_time}.json"
    
    puts "Benchmark saved on file #{json_name}"
    
  end

  Benchmark.memory do |x|
    x.report("thymeleaf.rb") { ThTestRunner::render(testfile)  }
    x.report("ERB") { ErbTestRunner::render(testfile)  }
    x.compare!
    Dir.mkdir(save_test_dir_m) unless Dir.exists?(save_test_dir_m)
    Dir.mkdir(save_test_dir_memory) unless Dir.exists?(save_test_dir_memory)
    json_name = x.json! "#{save_test_dir_memory}/#{current_time}.json"
    puts "Benchmark saved on file #{json_name}"
  end
end
