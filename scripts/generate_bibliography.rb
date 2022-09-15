#!/usr/bin/env ruby

# frozen_string_literal: true

require "yaml"
require "relaton"

class GenerateBibliography
  def initialize(input_file, output_dir)
    @input_file = input_file
    @output_dir = output_dir

    @bibliography_map = YAML.load_file(@input_file)
    @db = Relaton::Db.new(nil, nil)
  end

  def generate
    Dir.mkdir(@output_dir) unless File.directory?(@output_dir)

    @bibliography_map.each do |name, identifier|
      bib = @db.fetch(identifier["reference"])

      if bib.nil?
        bib = {
          "user_defined" => true,
          "reference" => identifier["reference"],
          "link" => identifier["link"]
        }.compact
      end

      file_path = "#{@output_dir}/#{name}.yaml"
      File.write(file_path, bib.to_yaml)
    end
  end
end

GenerateBibliography.new("isotc204-glossary/bibliography.yaml", "bibliography").generate
