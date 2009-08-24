#
#  SearchViewController.rb
#  roice
#
#  Created by Jason Toy on 8/21/09.
#  Copyright (c) 2009 __MyCompanyName__. All rights reserved.
#
require 'osx/cocoa'

class SearchViewController < OSX::NSViewController

  def title
	"Search"
  end
  def identifier
    "SearchView"
  end
  
  def loadView
    super_loadView
  end

end
