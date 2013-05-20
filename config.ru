require "rubygems"
require "bundler"
Bundler.setup
Bundler.require


require "signs"
use Rack::Reloader, 0
run Signs.new