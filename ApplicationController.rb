#
#  ApplicationController.rb
#  roice
#
#  Created by Jason Toy on 8/20/09.
#  Copyright (c) 2009 jtoy.net . All rights reserved.
#


require 'osx/cocoa'
require 'yaml'


include OSX
OSX.require_framework 'Security'
OSX.load_bridge_support_file(NSBundle.mainBundle.pathForResource_ofType("Security", "bridgesupport"))
OSX.ruby_thread_switcher_stop

class ApplicationController < OSX::NSObject
	
	ib_outlet :menu
	ib_outlet :search_item
	ib_outlet :search_field
	
	ib_action :manualCall
	ib_action :showAbout
	ib_action :goToAccount
	ib_action :gotoPreferences
	RESULTS_MENUITEM_POS = 5
	def awakeFromNib
	  OSX::NSLog("init")
	  @status_bar = NSStatusBar.systemStatusBar
	  @status_item = @status_bar.statusItemWithLength(NSVariableStatusItemLength)

	  @status_item.setHighlightMode(true)
	  @status_item.setMenu(@menu)
	  @app_icon = NSImage.imageNamed('menu.tiff')
	  @status_item.setImage(@app_icon)
	 
	  populateData
	  registerGrowl
	  setTimer
	  checkMessages
	end
	

	
	def goToAccount
	
	end
	
	
	def setTimer
	  @timer.invalidate if @timer
	  #TODO: have this use preferences timer
	  if @account
	    OSX::NSLog("interval is #{@account.interval}")
		#@timer = NSTimer.scheduledTimerWithTimeInterval_target_selector_userInfo_repeats(@account.interval * 60, self, 'checkMessagesByTimer', nil, true)
	  end
	end
	
	def checkMessagesByTimer(timer)
		checkMessages
	end
	
	def checkMessages
	  if @account
		#get new messages,  store each sha1 in history, and only show messages that are in the history
		notify('test title', 'test description')
	  end
	end
	
	def showAbout(sender)
		NSApplication.sharedApplication.activateIgnoringOtherApps(true)
		NSApplication.sharedApplication.orderFrontStandardAboutPanel(sender)
	end
	
	def gotoPreferences(sender)
		NSApplication.sharedApplication.activateIgnoringOtherApps(true)
		PreferencesController.sharedController.showWindow(sender)
	end
	
	def controlTextDidChange(notification)
	  string = notification.object.stringValue
	  OSX::NSLog("YES,I am in here with #{string}")
	  return if string.nil? || string.empty?
	  (RESULTS_MENUITEM_POS...@menu.numberOfItems).to_a.reverse.each{|i|  OSX::NSLog("did it delete #{i}"); @status_item.menu.removeItemAtIndex(i) } 
	  menu_position = RESULTS_MENUITEM_POS
	  results = data.select do |x| 
	    x.to_s.match(/#{string}/i)
	  end
	  OSX::NSLog("results #{results}")

	  menu_position = RESULTS_MENUITEM_POS
	  results.each do |r|

	    addResultMenuItem(r, menu_position)
		menu_position += 1
	  end
	  
	end
	
	
	def manualCall(sender)
	  OSX::NSLog("manualcall #{sender.stringValue}")
	  Accounts.gvoice.call(sender.stringValue.to_s,@selected_phone.phoneNumber)

	end
	def call(sender)
	  OSX::NSLog("we can call #{sender}")
	  OSX::NSLog("we can object #{sender.representedObject.class}")
	  Accounts.gvoice.call(sender.representedObject.phone,@selected_phone.phoneNumber)
 	end
	
	def	addResultMenuItem(result, pos)
		  OSX::NSLog("iun menu add with #{result}")
		
		#top level menu item for acount
		item = NSMenuItem.alloc.init
		item.title = result.to_s
		item.target = self
		item.representedObject = result
		item.action = 'call'

		@status_item.menu.insertItem_atIndex(item, pos)
		
	end
	
	def data
	  return @data ||= Person.all
	end
	
	
	# delegate not working if :click_context not provided?
	def growlNotifierClicked_context(sender, context)
		openInboxForAccount(context) if context
	end

	def growlNotifierTimedOut_context(sender, context)
	end
	
	def notify(title, desc)
	  Growl::Notifier.sharedInstance.notify('new_messages', title, desc, :click_context => title)
	end
	
	private
	
	def populateData
	  if @account && Accounts.gvoice
	    @selected_phone = Accounts.gvoice.phones.find{|x| x.phone_id == @account.forward_phone_id } || Accounts.gvoice.phones.first
		OSX::NSLog("selected phone in application is #{@selected_phone} and its phoenNumber is '#{@selected_phone.phoneNumber}'")
	  end
	end
	
	def registerGrowl
      g = Growl::Notifier.sharedInstance
      g.delegate = self
      g.register('iVoicer', ['new_messages'])
  end
	

end