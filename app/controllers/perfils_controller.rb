class PerfilsController < ApplicationController
  before_action :set_perfil, only: %i[ show edit update destroy ]

  # GET /perfils or /perfils.json
  def index
    if procurar_params[:texto].present?
      @perfils = Perfil.procurar(procurar_params[:texto])
    else
      @perfils = Perfil.all
    end
  end

  # GET /perfils/1 or /perfils/1.json
  # não está sendo utilizado, ao verificar o registro prefiro poder alterá-lo
  # o show pode ser utilizado quando não se espera que o usuário o edite, como um card para hover ou algo do gênero
  def show
  end

  # GET /perfils/new
  def new
    @perfil = Perfil.new
    @perfil.link = @perfil.build_link
  end

  # GET /perfils/1/edit
  def edit
  end

  # POST /perfils or /perfils.json
  def create
    @resultado = PerfilInteractor.call perfil_params: perfil_params
    @perfil = @resultado.perfil

    respond_to do |format|
      if @resultado.status
        format.html { redirect_to edit_perfil_path(@perfil), notice: "Sucesso!" }
        format.json { render :edit, status: :created, location: @perfil }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @resultado.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /perfils/1 or /perfils/1.json
  def update
    respond_to do |format|
      @resultado = PerfilInteractor.call perfil_params: perfil_params, id: params[:id]
      #if @perfil.update(perfil_params)
      if @resultado.status
        format.html { redirect_to edit_perfil_path(@perfil), notice: "Perfil atualizado.", status: :see_other }
        format.json { render :edit, status: :ok, location: @perfil }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @resultado.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /perfils/1 or /perfils/1.json
  def destroy
    #@perfil.destroy!

    respond_to do |format|
      format.html { redirect_to perfils_path, notice: "Perfil deletado.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_perfil
      @perfil = Perfil.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def perfil_params
      params.require(:perfil).permit([:id, :nome], link_attributes: [:id, :url_original])
    end

    def procurar_params
      params.permit(:texto)
    end
end
