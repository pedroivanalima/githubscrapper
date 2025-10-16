class BuscasController < ApplicationController
  before_action :set_busca, only: %i[ show edit update destroy ]

  # GET /buscas or /buscas.json
  def index
    @buscas = Busca.all
  end

  # GET /buscas/1 or /buscas/1.json
  def show
  end

  # GET /buscas/new
  def new
    @busca = Busca.new
  end

  # GET /buscas/1/edit
  def edit
  end

  # POST /buscas or /buscas.json
  def create
    @busca = Busca.new(busca_params)

    respond_to do |format|
      if @busca.save
        BuscaJob.new.perform(@busca.id)
        format.html { redirect_to edit_perfil_path(@busca.perfil_id), notice: "Nova busca criada." }
        format.json { render edit_perfil_path(@busca.perfil_id), status: :created, location: @busca }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @busca.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /buscas/1 or /buscas/1.json
  def update
    respond_to do |format|
      if @busca.update(busca_params)
        format.html { redirect_to @busca, notice: "Busca was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @busca }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @busca.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /buscas/1 or /buscas/1.json
  def destroy
    @busca.destroy!

    respond_to do |format|
      format.html { redirect_to buscas_path, notice: "Busca was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_busca
      @busca = Busca.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def busca_params
      params.expect(busca: [ :perfil_id ])
    end
end
