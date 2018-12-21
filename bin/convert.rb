#!/usr/bin/env ruby

$LOAD_PATH << File.dirname(__FILE__) + "/../lib/"

require 'extract'

puts extract(ARGF.read).mediawiki
