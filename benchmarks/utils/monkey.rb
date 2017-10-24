require 'benchmark/memory'
require 'json'
# MonkeyPatch of the class Benchmark::Memory::Job
class Benchmark::Memory::Job
  def json!(file_path)
    entries = run.comparison.entries
    hash_list = entries.map { |entry| to_h_entry(entry) }
    json_list = hash_list.map(&:to_json)
    File.open(file_path, 'w+') { |file| file.puts json_list }
    file_path
  end

  private

  def to_h_entry(entry)
    list = []
    list << entry.label.to_s
    measures = entry.measurement
    list = measures_to_list(measures, list)
    list_to_h(list)
  end

  def measures_to_list(measures, list)
    list << measures.allocated_memory
    memsize, memsize_retained = measures_memsize(measures)
    list << memsize
    list << memsize_retained
    objects, objects_retained = measures_objects(measures)
    list << objects
    list << objects_retained
    strings, strings_retained = measures_strings(measures)
    list << strings
    list << strings_retained
  end

  def measures_memsize(measures)
    memsize = measures.memory.allocated
    memsize_retained = measures.memory.retained
    [memsize, memsize_retained]
  end

  def measures_objects(measures)
    objects = measures.objects.allocated
    objects_retained = measures.objects.retained
    [objects, objects_retained]
  end

  def measures_strings(measures)
    strings = measures.strings.allocated
    strings_retained = measures.strings.retained
    [strings, strings_retained]
  end

  def list_to_h(list)
    {
      name: list[0],
      allocated_memory: list[1],
      memsize: list[2],
      memsize_retained: list[3],
      objects: list[4],
      objects_retained: list[5],
      strings: list[6],
      strings_retained: list[7]
    }
  end
end
