class CreateMembers < ActiveRecord::Migration[6.0]
  def change
    create_table :members do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :street
      t.string :city
      t.string :state
      t.decimal :zip
      t.datetime :joined
      t.boolean :active

      t.timestamps
    end
  end
end
