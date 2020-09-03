class CreateUserImages < ActiveRecord::Migration[6.0]
  def change
    create_table :user_images do |t|
      t.integer :user_id
      t.timestamps
    end
    add_column :user_images, :image, :json
  end
end
