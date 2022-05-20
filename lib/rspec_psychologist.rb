# frozen_string_literal: true

require_relative "rspec_psychologist/version"
require_relative "rspec_psychologist/rspec_psychologist_helper"

module RSpec::Psychologist
  class Error < StandardError; end
  def prefer_it_be(spec, expectation, &block)
    RSpec::PsychologistHelper.new(spec, expectation, yield)
  end

  RSpec.configure do |config|
    config.before(:each) do |example|
      # if the test sets this, we use it in the after(:each)
      @rspec_psychologist = nil
    end
    config.after(:each) do |example|
      if example.exception && @rspec_psychologist
        if ENV["OPEN_TO_SUGGESTIONS"]
          example.reporter.message("💁 Setting a more realistic expectation...Rerun your test to verify")
           @rspec_psychologist.adjust_expectation(example.metadata[:file_path], example.metadata[:line_number])
        else
          example.reporter.message("🙋 It doesn't have to be this way! run again with OPEN_TO_SUGGESTIONS=true to correct")
        end
      end
    end
  end
end
