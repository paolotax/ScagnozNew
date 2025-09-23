class CausaliMagazzinoController < ApplicationController
  before_action :set_causale_magazzino, only: [ :show, :edit, :update, :destroy ]

  # GET /causali_magazzino
  def index
    @causali_magazzino = CausaleMagazzino.all.order(:codice)
  end

  # GET /causali_magazzino/1
  def show
  end

  # GET /causali_magazzino/new
  def new
    @causale_magazzino = CausaleMagazzino.new
  end

  # GET /causali_magazzino/1/edit
  def edit
  end

  # POST /causali_magazzino
  def create
    @causale_magazzino = CausaleMagazzino.new(causale_magazzino_params)

    if @causale_magazzino.save
      redirect_to @causale_magazzino, notice: "Causale magazzino creata con successo."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /causali_magazzino/1
  def update
    if @causale_magazzino.update(causale_magazzino_params)
      redirect_to @causale_magazzino, notice: "Causale magazzino aggiornata con successo."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /causali_magazzino/1
  def destroy
    @causale_magazzino.destroy
    redirect_to causali_magazzino_path, notice: "Causale magazzino eliminata con successo."
  end

  private

  def set_causale_magazzino
    @causale_magazzino = CausaleMagazzino.find(params[:id])
  end

  def causale_magazzino_params
    params.require(:causale_magazzino).permit(:codice, :nome, :descrizione, :tipo_movimento, :segno_movimento, :attiva, :di_sistema, :richiede_fornitore, :richiede_cliente)
  end
end
