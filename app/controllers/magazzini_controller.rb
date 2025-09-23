class MagazziniController < ApplicationController
  before_action :set_magazzino, only: [:show, :edit, :update, :destroy]

  def index
    @magazzini = Magazzino.all.order(:codice)
  end

  def show
  end

  def new
    @magazzino = Magazzino.new
  end

  def create
    @magazzino = Magazzino.new(magazzino_params)
    
    if @magazzino.save
      redirect_to @magazzino, notice: 'Magazzino creato con successo.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @magazzino.update(magazzino_params)
      redirect_to @magazzino, notice: 'Magazzino aggiornato con successo.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @magazzino.destroy
    redirect_to magazzini_url, notice: 'Magazzino eliminato con successo.'
  end

  private

  def set_magazzino
    @magazzino = Magazzino.find(params[:id])
  end

  def magazzino_params
    params.require(:magazzino).permit(:nome, :codice, :attivo)
  end
end
