
require 'osx/cocoa'

# a simple wrapper for preferences values
class Preferences < OSX::NSObject			

  attr_accessor :accounts, :autoLaunch, :showUnreadCount, :account
  
  def self.sharedInstance
    @instance ||= self.alloc.init
  end
	
  def  init
    super_init
	defaults = NSUserDefaults.standardUserDefaults
	@accounts	= NSMutableArray.alloc.init

    if archivedAccounts = defaults.objectForKey("Accounts")
	  @accounts = archivedAccounts.map { |a| NSKeyedUnarchiver.unarchiveObjectWithData(a) }
    end
    
	@autoLaunch = StartItems.alloc.init.isSet
	@showUnreadCount = defaults.boolForKey("ShowUnreadCount")
	@account = @accounts.first  #even though the backend supports multiple backends, we actually only use 1 account currenty

	self
  end
  
  def autoLaunch?
    StartItems.alloc.init.isSet
  end
    
  def autoLaunch=(val)
	StartItems.alloc.init.set(val)
  end
  
  def showUnreadCount?
    NSUserDefaults.standardUserDefaults.boolForKey("ShowUnreadCount")
  end
  
  def showUnreadCount=(val)
	NSUserDefaults.standardUserDefaults.setObject_forKey(val, "ShowUnreadCount")
    NSUserDefaults.standardUserDefaults.synchronize
    NSNotificationCenter.defaultCenter.postNotificationName_object("ShowUnreadCountChangedNotification", self)
  end
  
  def addAccount(account)
    @accounts.addObject(account)
    writeBack
    NSNotificationCenter.defaultCenter.postNotificationName_object("AccountAddedNotification", self)
  end
  
  def removeAccount(account)
    @accounts.removeObject(account)
    writeBack
    NSNotificationCenter.defaultCenter.postNotificationName_object("AccountRemovedNotification", self)
  end
  
  def saveAccount(account)
    writeBack
    NSNotificationCenter.defaultCenter.postNotificationName_object("AccountChangedNotification", self)
  end
	
  def writeBack
	defaults = NSUserDefaults.standardUserDefaults
				
	defaults.setObject_forKey(
      @accounts.map { |a| NSKeyedArchiver.archivedDataWithRootObject(a) },
      "Accounts"
    )

	# save to Info.plist
	defaults.synchronize	
		
	# save accounts to default keychain
	#TODO: still don't delete removed accounts for now, perhaps should add this feature to make the keychain clean
	@accounts.each do |account|
	  Keychain.sharedInstance.set_account(account.username, account.password)# if !account.deleted? && account.changed?
	end
		
  end
	
	class << self
		def setupDefaults
			NSUserDefaults.standardUserDefaults.registerDefaults(
				NSDictionary.dictionaryWithObjectsAndKeys(
					true, "ShowUnreadCount",
          "PrefsToolbarItemAccounts", "PreferencesSelection",
					nil
				)
			)
		end
	end
	
end
