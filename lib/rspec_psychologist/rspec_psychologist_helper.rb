class RSpec::PsychologistHelper

  attr_reader :result_object, :expected, :spec, :call_line

  HELPER_METHOD = "prefer_it_be"

  def initialize(spec, expected, object)
    @spec = spec
    @expected = expected
    @result_object = object
    spec.instance_variable_set(:@rspec_psychologist, self)
  end

  def result
    called = caller.first
    file, @call_line, desc = called.split(":")
    # we need to remove extra spacing for the yaml to load
    if result_object.is_a?(String) && result_object.include?("---")
       indentation = result_object.match(/^(\s+)/)[0].count(" ")
      YAML.load result_object.gsub(" " * indentation, '')
    else
      result_object
    end
  end


  def adjust_expectation(file, starting_line)
    read_spec = File.readlines(file)
    ending_line = call_line.to_i
    def_start_pos = ending_line - read_spec[starting_line..ending_line].rindex.find_index{|l| l.include?(HELPER_METHOD)} + 1
    def_end_pos = read_spec[def_start_pos..ending_line].find_index{|l| l.match?(/\s+end/)} + def_start_pos - 1
    read_spec.slice!(def_start_pos..def_end_pos)
    indentation = read_spec[def_start_pos-1].match(/^(\s+)/)[0].count(" ") + 2

    read_spec.insert(def_start_pos, *yaml_lines(expected, indentation))
    File.write(file, read_spec.join())
  end

  # adds indentation
  def yaml_lines(expected, indentation)
    yaml_lines = expected.to_yaml.lines.map{|l| l = "  #{l}"}
    yaml_lines.unshift("%Q(\n")
    yaml_lines << ")\n"
    yaml_lines = yaml_lines.map{|l| l = ( " " * indentation) + l}
  end

end