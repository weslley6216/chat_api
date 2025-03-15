class CreateConversations < ActiveRecord::Migration[8.0]
  def change
    create_table :conversations do |t|
      t.references :user_a, foreign_key: { to_table: :users }
      t.references :user_b, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
