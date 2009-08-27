#
#  rb_main.rb
#  iVoicer
#
#  Created by Jason Toy on 8/24/09.
#  Copyright (c) 2009 __MyCompanyName__. All rights reserved.
#
require "rubygems"
require 'osx/cocoa'
gem 'activerecord', '= 1.15.6'
require "osx/active_record"
include OSX
def rb_main_init
  path = OSX::NSBundle.mainBundle.resourcePath.fileSystemRepresentation
  rbfiles = Dir.entries(path).select {|x| /\.rb\z/ =~ x}
  rbfiles -= [ File.basename(__FILE__) ]
  rbfiles.each do |path|
  begin
    require( File.basename(path) ) 
  rescue Exception => e
	OSX::NSLog("error #{e} for #{path}")
	end
  end
end

if $0 == __FILE__ then
  rb_main_init
  OSX.NSApplicationMain(0, nil)
end
