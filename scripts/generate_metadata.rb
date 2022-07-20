#!/usr/bin/env ruby

# frozen_string_literal: true

require "yaml"

terms = []
Dir["isotc204-glossary/concepts/*.yaml"].map do |yaml_file|
  terms << YAML.safe_load(IO.read(yaml_file))
  puts "Processing #{yaml_file}"
end

term_count = terms.map do |t|
  t.keys.length - 2
end.sum

meta = {
  "concept_count" => terms.length,
  "term_count" => term_count,
  "version" => "20200602"
}

File.open("metadata.yaml", "w") do |file|
  file.write(meta.to_yaml)
end

puts "Done."
