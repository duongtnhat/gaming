class CreateConfigs < ActiveRecord::Migration[7.0]
  def change
    create_table :configs do |t|
      t.references :config_set, null: false, foreign_key: true
      t.string :key
      t.string :value
      t.boolean :enable

      t.timestamps
    end
    add_index :configs, :key
  end
end
