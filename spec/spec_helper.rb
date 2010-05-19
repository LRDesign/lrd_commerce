require 'spec/spec_helper'

LRD_COMMERCE_DIR = File::join(File::expand_path(__FILE__).split(File::Separator)[0..-3]) unless defined?(LRD_COMMERCE_DIR)
Factory.definition_file_paths.unshift(File::join(LRD_COMMERCE_DIR, "spec", "factories"))
Factory.find_definitions
