#
#  Person.rb
#  roice
#
#  Created by Jason Toy on 8/22/09.
#  Copyright (c) 2009 rubynow.com . All rights reserved.
#
require 'osx/cocoa'
OSX.require_framework "AddressBook"
OSX.ns_import :ABAddressBook
OSX.ns_import :ABPerson
OSX.ns_import :ABMultiValue

class Person
  attr_reader :name,:phonetype,:phone
  
  def initialize name, phonetype, phone
	@name=name
	@phonetype=phonetype
	@phone=phone
  end
  
  def to_s
    "#{@name} #{@phonetype} #{@phone}"
  end
  
  #all ABPerson with a phone number
  def self.all
	array = []
    OSX::ABAddressBook.sharedAddressBook.people.select{|x| !x.valueForProperty(OSX::KABPhoneProperty).nil? }.collect do |x|
	#TODO figure out the correct order
	  count = x.valueForProperty(OSX::KABPhoneProperty).count
	  (1..count).to_a.each do |i|
	    array << Person.new("#{x.valueForProperty(OSX::KABFirstNameProperty)} #{x.valueForProperty(OSX::KABLastNameProperty)}",x.valueForProperty(OSX::KABPhoneProperty).labelAtIndex(i-1),x.valueForProperty(OSX::KABPhoneProperty).valueAtIndex(i-1) ) 
	  end
	end
	array
  end
  
end
