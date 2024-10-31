class TodoListsController < ApplicationController
    before_action :set_todo_list, only: [ :show, :edit, :update, :destroy ]

    def index
      @todo_lists = TodoList.all
      @todo_list = TodoList.new
    end

    def show
    end

    def new
      @todo_list = TodoList.new
    end

    def create
      @todo_list = TodoList.new(todo_list_params)

      TodoList.transaction do
        TodoList.where.not(id: @todo_list.id).update_all("position = position + 1")
        @todo_list.position = 0
      end

      if @todo_list.save
        respond_to do |format|
          format.json { render json: { id: @todo_list.id, title: @todo_list.title } }
          format.html { render partial: "todo_lists/todo_list", locals: { todo_list: @todo_list }, status: :created } # HTML fallback
        end
      else
        respond_to do |format|
          format.json { render json: @todo_list.errors, status: :unprocessable_entity }
          format.html { render :new, alert: "Error creating list." }
        end
      end
    end

    def edit
    end

    def update
      if @todo_list.update(todo_list_params)
        respond_to do |format|
          format.json { render json: { title: @todo_list.title }, status: :ok }
          format.html { render partial: "todo_lists/todo_list", locals: { todo_list: @todo_list }, status: :ok }
        end
      else
        respond_to do |format|
          format.json { render json: @todo_list.errors, status: :unprocessable_entity }
          format.html { render :edit }
        end
      end
    end

    def destroy
      @todo_list.destroy
      redirect_to todo_lists_url, notice: "Todo List was successfully destroyed."
    end

    def update_order
      dragged_id = params[:dragged_id]
      target_id = params[:target_id]

      TodoList.transaction do
        dragged_list = TodoList.find(dragged_id)
        target_list = TodoList.find(target_id)

        dragged_position = dragged_list.position
        # update! sends an exception if there's an error, to callback the transaction
        dragged_list.update!(position: target_list.position)
        target_list.update!(position: dragged_position)
      end

      render json: {
       status: "success"
      }
    end

    private
      def set_todo_list
        @todo_list = TodoList.find(params[:id])
      end

      def todo_list_params
        params.require(:todo_list).permit(:title)
      end
end
