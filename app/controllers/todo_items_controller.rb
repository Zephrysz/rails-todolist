class TodoItemsController < ApplicationController
    before_action :set_todo_list
    before_action :set_todo_item, only: [ :destroy ]

    def create
      @todo_item = @todo_list.todo_items.build(todo_item_params)
      if @todo_item.save
        redirect_to @todo_list, notice: "Todo Item was successfully added."
      else
        redirect_to @todo_list, alert: "Unable to add Todo Item."
      end
    end

    def toggle_complete
      @todo_item = TodoItem.find(params[:id])
      @todo_item.update(completed: !@todo_item.completed)
      redirect_to todo_list_path(@todo_item.todo_list)
    end

    def destroy
      Rails.logger.info "Deleting item with ID: #{@todo_item.id}"
      @todo_item.destroy
      redirect_to @todo_list, notice: "Todo Item was successfully removed."
    end

    private
      def set_todo_list
        @todo_list = TodoList.find(params[:todo_list_id])
      end

      def set_todo_item
        @todo_item = @todo_list.todo_items.find(params[:id])
      end

      def todo_item_params
        params.require(:todo_item).permit(:content, :completed)
      end
end
