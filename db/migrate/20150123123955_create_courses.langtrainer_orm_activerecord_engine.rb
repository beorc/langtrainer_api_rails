# This migration comes from langtrainer_orm_activerecord_engine (originally 20150113195017)
class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.string :slug, null: false
      t.boolean :published, default: false

      t.timestamps null: false

      t.index :slug, unique: true
      t.index :published
    end
  end
end
