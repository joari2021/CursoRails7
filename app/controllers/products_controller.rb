class ProductsController < ApplicationController
  def index
    @categories = Category.order(name: :asc).load_async
    @products = Product.with_attached_photo
    if params[:category_id]
      @products = Product.where(category_id: params[:category_id])
    end
    if params[:min_price].present?
      @products = Product.where("price >= ?", params[:min_price])
    end
    if params[:max_price].present?
      @products = Product.where("price <= ?", params[:max_price])
    end
    if params[:query_text].present?
      @products = Product.search_full_text(params[:query_text])
    end
    
    order_by = Product::ORDER_BY.fetch(params[:order_by]&.to_sym, Product::ORDER_BY[:newest])
    @products = Product.order(order_by)
    @pagy, @products = pagy_countless(@products, items: 12)
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

  def product
    @product = Product.find(params[:id])
  end
end
