
require 'osx/cocoa'
require 'rubygems'
begin
  require 'googlevoice' 
rescue Exception => e
  OSX::NSLog("what is ther error? #{e}")
end
# a google voice account
class Accounts < OSX::NSObject

  attr_accessor :username, :password, :interval, :enabled, :sound, :growl, :forward_phone_id
  Properties = [:username, :interval, :enabled, :sound, :growl,:forward_phone_id]
  	
	MIN_INTERVAL		= 1
	MAX_INTERVAL		= 300
	DEFAULT_INTERVAL	= 10

	def init
	  self.password = Keychain.sharedInstance.get_password(@username)
	  super_init
	end

	def	initWithNameIntervalEnabledGrowlSound(username, interval, enabled, growl, sound)
	  self.username = username    
      self.interval = interval || DEFAULT_INTERVAL
      self.enabled = enabled
      self.growl = growl
      self.sound = sound || Sound::SOUND_NONE
    
	  init
	end
  
  def initWithCoder(coder)
    Properties.each do |prop|
      val = coder.decodeObjectForKey(prop)
      self.send("#{prop.to_s}=", val)
    end
    
    init
  end
  
  def encodeWithCoder(coder)
    Properties.each do |prop|
      val = self.send(prop)
      coder.encodeObject_forKey(val, prop)
    end
  end
  
  def description
    "<#{self.class}: #{username}, enabled? : #{enabled?}\ninterval: #{interval}, sound: #{sound}, growl: #{growl}>"
  end
  
  alias inspect to_s
  alias enabled? enabled
  
  def enabled=(val)
    @enabled = val
    @enabled = false if val == 0
  end
  
  def interval=(val)
    @interval = val.to_i
    @interval = DEFAULT_INTERVAL unless @interval.between?(MIN_INTERVAL, MAX_INTERVAL)
  end
  
  def growl=(val)
    @growl = val
    @growl = false if val == 0
  end
	
	def	username=(new_username)
	  @old_username ||= @username
	  @username = new_username
	end
	
	def	password=(new_password)
	  @old_password ||= @password
	  @password = new_password
	end
	
	def	username_changed?
	  @old_username && @old_username != @username
	end
	
	def	password_changed?
		@old_password && @old_password != @password
	end
	
  def changed?
	username_changed? || password_changed? #todo
  end
  
  def new?
    @new_account
  end
  
  def markNew
    @new_account = true
  end
  
  def save
    if new?
      Preferences.sharedInstance.addAccount(self)
    else
      Preferences.sharedInstance.saveAccount(self)
    end
    @new_account = false
  end
  
  def self.gvoice
	return @gv if @gv
	account = Preferences.sharedInstance.accounts.first
	if account
	  @gv = GoogleVoice.new(account.username,account.password)
	  @gv.login unless @gv.logged_in?
	else
	  @gv = nil
	end
	@gv
  end
  
end
