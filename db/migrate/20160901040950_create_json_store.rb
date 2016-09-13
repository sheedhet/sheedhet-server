class CreateJsonStore < ActiveRecord::Migration[5.0]
  def change
    create_table :json_stores do |t|
      t.string :json
    end
  end
end
