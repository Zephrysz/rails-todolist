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
        redirect_to todo_lists_path, notice: "Todo List was successfully updated."
      else
        render :edit
      end
    end

    def destroy
      @todo_list.destroy
      redirect_to todo_lists_url, notice: "Todo List was successfully destroyed."
    end

    private
      def set_todo_list
        @todo_list = TodoList.find(params[:id])
      end

      def todo_list_params
        params.require(:todo_list).permit(:title)
      end
end
