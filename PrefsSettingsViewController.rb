#
#  PrefsSettingsViewController.rb
#  roice
#
#  Created by Jason Toy on 8/21/09.
#  Copyright (c) 2009 __MyCompanyName__. All rights reserved.
#

require 'osx/cocoa'

class PrefsSettingsViewController <  OSX::NSViewController


  ib_outlet :autoLaunch
  ib_outlet :showUnreadCount
  
  ib_action :saveAutoLaunch
  ib_action :saveShowUnreadCount
  
  def title
	NSLocalizedString("Settings")
  end
  
  
  
  def identifier
	"PrefsToolbarItemSettings"
  end
  
  
  def loadView
    super_loadView
    @autoLaunch.setTitle(NSLocalizedString("Launch at login"))
	@autoLaunch.setState(Preferences.sharedInstance.autoLaunch? ? NSOnState : NSOffState)
    @showUnreadCount.setTitle(NSLocalizedString("Show unread count in menu bar"))
    @showUnreadCount.setState(Preferences.sharedInstance.showUnreadCount? ? NSOnState : NSOffState)
  end
  
  def image
    NSImage.imageNamed("NSPreferencesGeneral")
  end
  
  def saveAutoLaunch(sender)
	
  end
  
  def saveShowUnreadCount(sender)
  
  end

end
