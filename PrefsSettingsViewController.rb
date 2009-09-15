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
  ib_outlet :hotkey
  ib_action :saveAutoLaunch
  ib_action :saveShowUnreadCount
  
  def title
	NSLocalizedString("Settings")
  end
  
  def hotkeyUpdated(hotkey)
	OSX::NSLog("test in hotkey")
    if @hotkey.valid?
      Preferences.sharedInstance.hotkey_code = @hotkey.keyCode
      Preferences.sharedInstance.hotkey_modifier = @hotkey.modifierFlags
      NSApp.registerHotKey_modifierFlags(@hotkey.keyCode, @hotkey.modifierFlags)
    else
	  Preferences.sharedInstance.hotkey_code = nil
      Preferences.sharedInstance.hotkey_modifier = nil
      NSApp.unregisterHotKey
    end
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
	if Preferences.sharedInstance.hotkey?
	  @hotkey.setKeyCode_modifierFlags(Preferences.sharedInstance.hotkey_code,Preferences.sharedInstance.hotkey_modifier)
	else
	  @hotkey.clearKey
	end
	@hotkey.delegate = self
  end
  
  def image
    NSImage.imageNamed("NSPreferencesGeneral")
  end
  
  def saveAutoLaunch(sender)
	
  end
  
  def saveShowUnreadCount(sender)
  
  end

end
