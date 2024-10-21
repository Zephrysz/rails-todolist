class TodoItemsController < ApplicationController
    before_action :set_todo_list
    before_action :set_todo_item, only: [ :destroy ]

    def create
      @todo_list = TodoList.find(params[:todo_list_id])
      @todo_item = @todo_list.todo_items.build(todo_item_params)

      if @todo_item.save
        respond_to do |format|
          format.json { render json: { id: @todo_item.id, content: @todo_item.content, todo_list_id: @todo_list.id } }
          # format.html { redirect_to @todo_list } # Ensure HTML format redirects back to the list
        end
      else
        respond_to do |format|
          format.json { render json: @todo_item.errors, status: :unprocessable_entity }
          format.html { redirect_to @todo_list, alert: "There was an error." } # HTML fallback in case of errors
        end
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
