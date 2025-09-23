class SoggettiController < ApplicationController
  before_action :set_soggetto, only: [:show, :edit, :update, :destroy]

  def index
    @soggetti = Soggetto.all.order(:ragione_sociale)
    @soggetti = @soggetti.where(tipo: params[:tipo]) if params[:tipo].present?
  end

  def show
  end

  def new
    @soggetto = Soggetto.new
  end

  def create
    @soggetto = Soggetto.new(soggetto_params)
    
    if @soggetto.save
      redirect_to @soggetto, notice: 'Soggetto creato con successo.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @soggetto.update(soggetto_params)
      redirect_to @soggetto, notice: 'Soggetto aggiornato con successo.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @soggetto.destroy
    redirect_to soggetti_url, notice: 'Soggetto eliminato con successo.'
  end

  private

  def set_soggetto
    @soggetto = Soggetto.find(params[:id])
  end

  def soggetto_params
    params.require(:soggetto).permit(:ragione_sociale, :partita_iva, :codice_fiscale, :email, :telefono, :tipo)
  end
end
