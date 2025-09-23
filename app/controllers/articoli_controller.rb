class ArticoliController < ApplicationController
  before_action :set_articolo, only: [:show, :edit, :update, :destroy]

  def index
    @articoli = Articolo.all.order(:sku)
    @articoli = @articoli.where(attivo: true) if params[:attivi] == 'true'
  end

  def show
  end

  def new
    @articolo = Articolo.new
  end

  def create
    @articolo = Articolo.new(articolo_params)
    
    if @articolo.save
      redirect_to @articolo, notice: 'Articolo creato con successo.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @articolo.update(articolo_params)
      redirect_to @articolo, notice: 'Articolo aggiornato con successo.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @articolo.destroy
    redirect_to articoli_url, notice: 'Articolo eliminato con successo.'
  end

  private

  def set_articolo
    @articolo = Articolo.find(params[:id])
  end

  def articolo_params
    params.require(:articolo).permit(:sku, :titolo, :autore, :editore, :barcode, :unita_misura, :attivo)
  end
end
