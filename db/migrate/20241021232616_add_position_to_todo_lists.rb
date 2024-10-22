class AddPositionToTodoLists < ActiveRecord::Migration[7.2]
  def change
    add_column :todo_lists, :position, :integer
  end
end
