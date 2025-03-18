class RemoveUserAIdAndUserBIdFromConversations < ActiveRecord::Migration[8.0]
  def change
    remove_column :conversations, :user_a_id, :integer
    remove_column :conversations, :user_b_id, :integer
  end
end
