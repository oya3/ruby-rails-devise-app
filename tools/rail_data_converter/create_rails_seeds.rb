# coding: utf-8
$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__)))
require 'yaml'
require 'optparse' # オプション解析
require 'n02_dataset'
require 'active_support/all'
require 'outputter'
require 'pry'

Encoding.default_external = 'utf-8'
Encoding.default_internal = 'utf-8'

puts "create_rails_seeds version.0.2017.06.22.1352"

if ARGV.length != 1
  puts "usage create_rails_seeds <config file path>"
  exit
end

# yml = YAML.load_file(ARGV[0]).with_indifferent_access
yml = HashWithIndifferentAccess.new(YAML.load_file(ARGV[0]))
contents = yml[:contents]
N02Dataset.new contents

outputter = Outputter.new contents
File.binwrite "../../db/seeds.rb", outputter.put, external_encoding: 'utf-8'

puts 'complate.'
