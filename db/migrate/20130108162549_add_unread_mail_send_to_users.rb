class AddUnreadMailSendToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :unread_mail_send_with, :int
  end

  def self.down
    remove_column :users, :unread_mail_send_with
  end
end
