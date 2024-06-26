class ProductsController < ApplicationController
  skip_before_action :protect_pages, only: [:index, :show]
  
  def index
    @categories = Category.order(name: :asc).load_async

    @pagy, @products = pagy_countless(FindProducts.new.call(product_params_index), items: 12)
    #@pagy, @products = pagy_countless(FindProducts.new.call(product_params_index).load_async, items: 12)  Da conflicto con Load_async
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)

    if @product.save
      redirect_to products_path, notice: "Tu producto se ha creado correctamente"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    product
  end

  def edit
    product
  end

  def update
    if product.update(product_params)
      redirect_to products_path, notice: "Tu producto se ha actualizado correctamente"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    product.destroy
    redirect_to products_path, notice:"Tu producto se ha eliminado correctamente", status: :see_other
  end

  private

  def product_params
    params.require(:product).permit(:title, :description, :price, :photo, :category_id)
  end

  def product_params_index
    params.permit(:category_id, :min_price, :max_price, :query_text, :order_by)
  end

  def product
    @product = Product.find(params[:id])
  end
end
