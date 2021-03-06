class LittersController < ApplicationController
  before_action :set_litter, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  # GET /litters
  # GET /litters.json
  def index
    @litters = Litter.order('pregnancy_id')
  end

  # GET /litters/1
  # GET /litters/1.json
  def show
  end

  # GET /litters/new
  def new
    @litter = Litter.new
  end

  # GET /litters/1/edit
  def edit
    @pregnancy = @litter.pregnancy
  end

  # POST /litters
  # POST /litters.json
  def create
    @pregnancy = Pregnancy.find(params[:pregnancy_id])
    @litter = Litter.new(litter_params)

    respond_to do |format|
      if @litter.save
        format.html { redirect_to @pregnancy, notice: 'Litter was successfully created.' }
        format.json { render action: 'show', status: :created, location: @litter }
      else
        format.html { render action: 'new' }
        format.json { render json: @litter.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /litters/1
  # PATCH/PUT /litters/1.json
  def update
    @pregnancy = @litter.pregnancy
    respond_to do |format|
      if @litter.update(litter_params)
        format.html { redirect_to @pregnancy, notice: 'Litter was successfully updated.' }
        format.json { head :no_content }
        format.js
      else
        format.html { render action: 'edit' }
        format.json { render json: @litter.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end

  # DELETE /litters/1
  # DELETE /litters/1.json
  def destroy
    @litter.destroy
    respond_to do |format|
      format.html { redirect_to litters_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_litter
      @litter = Litter.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def litter_params
      params.require(:litter).permit(:pregnancy_id, :gender, :color_id, :survival, :cleft_palate,:dog_id)
    end
end
