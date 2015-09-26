class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.boolean :is_yes
      t.integer :user_id
      t.integer :question_id

      t.timestamps null: false
    end
  end
end
