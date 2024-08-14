class CreateConfigSets < ActiveRecord::Migration[7.0]
  def change
    create_table :config_sets do |t|
      t.string :name
      t.string :code
      t.string :description

      t.timestamps
    end
  end
end
