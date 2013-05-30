require "rubygems"
require "bundler"
Bundler.setup
Bundler.require


require "signs"
# use Rack::Reloader, 0
use Rack::Cache, {
  :verbose     => true,
  :metastore   => 'file:tmp/cache/rack/meta',
  :entitystore => 'file:tmp/cache/rack/body'
}
run Signs.new