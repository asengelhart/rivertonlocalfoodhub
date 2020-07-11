class CreateRemindertext < ActiveRecord::Migration[6.0]
  def change
    create_table :remindertexts do |t|
      t.text :text
      t.references :user, null: false, foreign_key: true
    end
  end
end
