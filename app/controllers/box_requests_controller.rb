class BoxRequestsController < ApplicationController
  before_action :set_box_request, only: %i[show edit update destroy]

  # GET /box_requests
  # GET /box_requests.json
  def index
    @box_requests = BoxRequest.all

    if (sort_attr = params[:sort_by])
      @box_requests = @box_requests.order(sort_attr)
    end
  end

  # GET /box_requests/1
  # GET /box_requests/1.json
  def show
    @box_request = request_review_scope.find(params[:id])
  end

  # GET /box_requests/new
  def new
    @box_request = BoxRequest.new
  end

  # GET /box_requests/1/edit
  def edit
    @box_request = request_review_scope.find(params[:id])
    # Prepare JSON for autocomplete and chips
    @tags_json = @box_request.to_json(only: :tag_list)
  end

  # POST /box_requests
  # POST /box_requests.json
  def create
    @box_request = BoxRequest.new(box_request_params)

    respond_to do |format|
      if @box_request.save
        format.html { redirect_to box_requests_path, notice: 'Box request was successfully created.' }
        format.json { render :show, status: :created, location: @box_request }
      else
        format.html { render :new }
        format.json { render json: @box_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /box_requests/1
  # PATCH/PUT /box_requests/1.json
  def update
    respond_to do |format|
      @box_request.reviewed_by_id = current_user.id if @box_request.reviewed_by_id == nil

      if @box_request.update(box_request_params)
        format.html { redirect_to box_requests_path, notice: 'Box request was successfully updated.' }
        format.json { render :show, status: :ok, location: @box_request }
      else
        format.html { render :edit }
        format.json { render json: @box_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /box_requests/1
  # DELETE /box_requests/1.json
  def destroy
    @box_request.destroy
    respond_to do |format|
      format.html { redirect_to box_requests_url, notice: 'Box request was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # /box_requests/1/already_claimed
  def already_claimed
    render layout: false
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_box_request
    @box_request = BoxRequest.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def box_request_params
    params.require(:box_request).permit(:question_re_current_situation,
                                        :question_re_affect,
                                        :question_re_referral_source,
                                        :question_re_if_not_self_completed,
                                        :summary,
                                        :reviwed_by_id,
                                        :tag_list)
  end

  def request_review_scope
    policy_scope(BoxRequest, policy_scope_class: BoxPolicy::ReviewScope)
  end
end
