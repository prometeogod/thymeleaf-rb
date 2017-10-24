require 'fileutils'
def clear_bench_result
   folder = 'benchmarks/results/'
   files = Dir.glob("#{folder}/*")
   files.each { |file| FileUtils.rm_rf file }
end
clear_bench_result
