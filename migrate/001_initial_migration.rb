#
#  initial_migration.rb
#  iVoicer
#
#  Created by Jason Toy on 8/26/09.
#  Copyright (c) 2009 __MyCompanyName__. All rights reserved.
#
class InitialMigration < ActiveRecord::Migration
  def self.up
    create_table :cached_messages do |t|
      t.string :sha,:from, :message,:sent_at,:from
      t.timestamps
    end
  end

  def self.down
    drop_table :cached_messages
  end
end
