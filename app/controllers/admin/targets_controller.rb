class Admin::TargetsController < Admin::BaseController
  before_action :set_target, only: %i[show edit update destroy]

      def show
        @tag_relationships = @target.tags
        @tag_list = @target.tags.pluck(:name).join(',')
      end
    
      def index
        @targets = Target.order(created_at: :desc)
        @tag_list = Tag.all
      end
    
      def new
        @target = Target.new
        @tag_list = @target.tags.pluck(:name).join(',')
      end
    
      def edit
        @tag_list = @target.tags.pluck(:name).join(',')
      end
    
      def update
        if @target.update(target_params)
          redirect_to admin_target_path(@target)
        else
          render :edit
        end
      end
    
      def destroy
        @target.api_destroy(@target)
        @target.destroy
        redirect_to admin_targets_path
      end
    
      def create
        @target = Target.new(target_params)
        #profile作成
        @target.get_profile(@target)

        if @target.save
          #音声をAPIのprofileに登録
          @target.enrollment_voice(@target)
          redirect_to admin_targets_path
        else
          render :new
        end
      end
    
      private

      def set_target
        @target = Target.find(params[:id])
      end
    
      def target_params
        params.require(:target).permit(:name, :target_voice, tag_ids: [])
      end

end
