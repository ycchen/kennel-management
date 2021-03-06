class DogsController < ApplicationController
  before_action :set_dog, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  # GET /dogs
  # GET /dogs.json
  def index
    @dogs = Dog.where(nil).order(birthday: :desc)
    respond_to do |format|
      format.html
      format.csv {send_data @dogs.to_csv}
      format.xls
    end
  end

  # GET /dogs/1
  # GET /dogs/1.json
  def show
    get_parents
  end

  # GET /dogs/new
  def new
    @dog = Dog.new
    # get_parents
  end

  # GET /dogs/1/edit
  def edit
    # get_parents
  end

  # POST /dogs
  # POST /dogs.json
  def create
    @dog = Dog.new(dog_params)

    respond_to do |format|
      if @dog.save
        format.html { redirect_to @dog, notice: 'Dog was successfully created.' }
        format.json { render action: 'show', status: :created, location: @dog }
      else
        format.html { render action: 'new' }
        format.json { render json: @dog.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /dogs/1
  # PATCH/PUT /dogs/1.json
  def update
    respond_to do |format|
      if @dog.update(dog_params)
        format.html { redirect_to @dog, notice: 'Dog was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @dog.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /dogs/1
  # DELETE /dogs/1.json
  def destroy
    @dog.destroy
    respond_to do |format|
      format.html { redirect_to dogs_url }
      format.json { head :no_content }
    end
  end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_dog
      @dog = Dog.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def dog_params
      params.require(:dog).permit(:name, :call_name, :birthday, :gender, :registration_no, :sire_id, :dams_id, :color_id, :status_id,:pictures_attributes => [:id, :file, '_destroy'])
    end

    #
    def get_parents
      @bitches = Dog.where(gender: 'Female')
      @dogs = Dog.where(gender: 'Male')
    end
end
