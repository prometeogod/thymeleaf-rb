#!/usr/bin/env ruby

require_relative '../lib/thymeleaf_test'
require_relative '../compare/thymeleaf-Noko/thymeleaf-Noko'
require_relative 'suite'
require_relative 'test_runners/erb'
require_relative 'test_runners/th'
require_relative 'test_runners/th-Noko'

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
#########################################################
ap "[PERF] -----------------------------"

ThymeleafTest::TestDir::find_erb do |testfile|

  bench_name = testfile.test_name
  current_time = Time.now.strftime "%Y%m%d%H%M%S"
  save_test_dir = "#{__dir__}/results/#{bench_name}"
  suite = ThymeleafBenchSuite.new

  ap "[Bench:#{bench_name}] -----------------------------"

  # Pit Th against other template solutions. Also compare speed/memory performance against a baseline
  Benchmark.ips do |b|
    b.config(suite: suite, time: 2, warmup: 1)
    b.report("thymeleaf.rb") { ThTestRunner::render(testfile)  }
    b.report("ERB")          { ErbTestRunner::render(testfile) }
    b.compare!

    Dir.mkdir(save_test_dir) unless File.exists?(save_test_dir)
    json_name = b.json! "#{save_test_dir}/#{current_time}.json"
    
    puts "Benchmark saved on file #{json_name}"
    
  end

  Benchmark.memory do |x|
    x.report("thymeleaf.rb") { ThTestRunner::render(testfile)  }
    x.report("thymeleaf-Nokogiri") { ThNokoTestRunner::render(testfile)  }
    x.compare!
  end
end
