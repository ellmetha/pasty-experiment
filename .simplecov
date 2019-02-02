require "simplecov"
require 'simplecov-console'
SimpleCov.formatter = SimpleCov::Formatter::Console
SimpleCov.start("rails") do
  add_filter("/bin/")
  add_filter("/lib/tasks/auto_annotate_models.rake")
  add_filter("/lib/tasks/coverage.rake")
end
SimpleCov.minimum_coverage(80)
SimpleCov.use_merging(false)
