class Admin::TagsController < Admin::BaseController
    
    def index
      @tags = Tag.all.order(created_at: :asc)
    end

    def new
      @tag = Tag.new
    end

    def edit
      @tag = Tag.find(params[:id])
      @tag_list = @tag.targets.pluck(:name).join(',')
    end

    def update
      @tag = Tag.find(params[:id])
      if @tag.update(tag_params)
        redirect_to admin_tags_path
      else
        render :edit
      end
    end

    def destroy
      @tag = Tag.find(params[:id])

      @tag.destroy
      redirect_to admin_tags_path
    end

    def create
      @tag = Tag.new(tag_params)
      if @tag.save
        redirect_to admin_tags_path
      else
        render :new
      end
    end

    private

    def tag_params
      params.require(:tag).permit(:name)
    end
end
