#
#  PrefsAccountViewController.rb
#  roice
#
#  Created by Jason Toy on 8/21/09.
#  Copyright (c) 2009 __MyCompanyName__. All rights reserved.
#

require 'osx/cocoa'

class PrefsAccountsViewController < OSX::NSViewController
  
  ib_outlet :addButton
  ib_outlet :removeButton
  ib_outlet :editButton
  ib_outlet :accountsTable

  ib_action :startAddingAccount
  ib_action :endAddingAccount
  ib_action :startEditingAccount
  ib_action :endEditingAccount
  ib_action :removeAccount
  
  def title
    NSLocalizedString("Accounts")
  end
  
  def image
    NSImage.imageNamed("NSUserAccounts")
  end
  
  def identifier
    "PrefsToolbarItemAccounts"
  end
  
  def loadView
    super_loadView
    registerObservers
    @editButton.title = NSLocalizedString("Edit")
    @accountsTable.target = self
    @accountsTable.setDoubleAction("startEditingAccount")
    forceRefresh
  end
  
  ## account list table view
  def numberOfRowsInTableView(sender)
	accounts.size
  end
	
  def tableView_objectValueForTableColumn_row(tableView, tableColumn, row)
	account = accounts[row]
    if account
      case tableColumn.identifier
      when "AccountName"
        account.username
      when "EnableStatus"
        account.enabled?
      end
    end
  end
	
  def tableView_setObjectValue_forTableColumn_row(tableView, object, tableColumn, row)	
    if (account = accounts[row]) && tableColumn.identifier == "EnableStatus"
	  account.enabled = object
      account.save
    end
  end
	
  def tableViewSelectionDidChange(notification)
    forceRefresh
  end

  ## button actions
  def startAddingAccount(sender)
	
    account = Accounts.alloc.initWithNameIntervalEnabledGrowlSound(
      "username", nil, true, true, nil
    )
    account.markNew
    AccountDetailController.editAccountOnWindow(account, view.superview.window)
  end
  
  def startEditingAccount(sender)
    account = currentAccount
    if account
      AccountDetailController.editAccountOnWindow(account, view.superview.window)
    end
  end
  
  def endAddingAccount(sender)        
    forceRefresh
    index = accounts.count - 1
    @accountsTable.selectRowIndexes_byExtendingSelection(NSIndexSet.indexSetWithIndex(index), false)
    @accountsTable.scrollRowToVisible(index)
  end
  
  def removeAccount(sender)
    account = currentAccount
    if account
      Preferences.sharedInstance.removeAccount(account) 
      forceRefresh
    end
  end
  
  def startEditingAccount(sender)
	account = currentAccount
    if account
      AccountDetailController.editAccountOnWindow(account, view.superview.window)
    end
  end
  
  def endEditingAccount(sender)
	forceRefresh
  end

  
  private
    def accounts
      Preferences.sharedInstance.accounts
    end
  
  def currentAccount
    if @accountsTable.selectedRow > -1
      accounts[@accountsTable.selectedRow]
    else
      nil
    end
  end
  
  def forceRefresh
    @accountsTable.reloadData
    enabled = !currentAccount.nil?
    @removeButton.enabled = @editButton.enabled = enabled
  end
	    
  def registerObservers
	center = NSNotificationCenter.defaultCenter
	center.addObserver_selector_name_object(
	  self,
	  "endAddingAccount",
	  "AccountAddedNotification",
	  nil
	)
	
	center.addObserver_selector_name_object(
	  self,
	  "endEditingAccount",
	  "AccountChangedNotification",
	  nil
	)
  end
  
  def accounts
	Preferences.sharedInstance.accounts
  end
end
