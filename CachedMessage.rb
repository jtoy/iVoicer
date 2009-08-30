#
#  Message.rb
#  iVoicer
#
#  Created by Jason Toy on 8/26/09.
#  Copyright (c) 2009 __MyCompanyName__. All rights reserved.
#
require 'osx/cocoa'


class CachedMessage < ActiveRecord::Base
  def to_s
    message
  end
  def to_title
    "#{from} at #{sent_at}"
  end
  
  validates_presence_of :sha,:message,:from,:sent_at
end

ActiveRecordConnector.connect_to_sqlite_in_application_support :log => true
migrations_dir =OSX::NSBundle.mainBundle.resourcePath.fileSystemRepresentation.to_s
ActiveRecord::Migrator.migrate(migrations_dir, nil)

#TODO: upgrade to lastest osx/active_record code and delete the migration
if !CachedMessage.table_exists?
  ActiveRecord::Base.connection.create_table :cached_messages do |t|
    t.column "sha",:string
	t.column "sent_at",:string
    t.column "from",:string
    t.column "message",:string
	t.column "updated_at",:datetime
	t.column "created_at", :datetime
    end
end
