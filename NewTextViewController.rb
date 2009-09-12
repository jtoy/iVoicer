#
#  NewTextController.rb
#  iVoicer
#
#  Created by Jason Toy on 9/9/09.
#  Copyright (c) 2009 __MyCompanyName__. All rights reserved.
#

require 'osx/cocoa'

class NewTextViewController <  OSX::NSWindowController
  include OSX
  ib_outlet :to_field
  ib_outlet :message
  attr_accessor :person
  def init
    initWithWindowNibName("NewTextView")
	return self
  end
  
  def windowDidLoad
	if person
	  @to_field.StringValue = "To: #{person}"
	end
  end
  
  def controlTextDidEndEditing(notification)
  	Accounts.gvoice.text person.phone, @message.stringValue
	window.close
  end
  
end
