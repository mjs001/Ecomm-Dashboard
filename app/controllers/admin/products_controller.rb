class Admin::ProductsController < AdminController
  before_action :set_admin_product, only: %i[ show edit update destroy ]

  # GET /admin/products or /admin/products.json
  def index
    @admin_products = Product.all
  end

  # GET /admin/products/1 or /admin/products/1.json
  def show
    @category_name = get_cat_name(@admin_product.category_id)
  end

  # GET /admin/products/new
  def new
    @admin_product = Product.new
  end

  # GET /admin/products/1/edit
  def edit
    @category_name = get_cat_name(@admin_product.category_id)
    @id = @admin_product.category_id
  end

  # POST /admin/products or /admin/products.json
  def create
    category_name_or_id = admin_product_params[:category_id]
    if is_integer?(category_name_or_id) == false
      find_category = Category.find_by(name: category_name_or_id)
      category_id = find_category.id
      copy_of_params = admin_product_params
      copy_of_params[:category_id] = category_id
      @admin_product = Product.new(copy_of_params)
    else
      @admin_product = Product.new(admin_product_params)
    end
    respond_to do |format|
      if @admin_product.save
        format.html { redirect_to admin_product_url(@admin_product), notice: "Product was successfully created." }
        format.json { render :show, status: :created, location: @admin_product }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @admin_product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/products/1 or /admin/products/1.json
  def update
    params_for_update = {}
  category_name_or_id = admin_product_params[:category_id]
    if is_integer?(category_name_or_id) == false
      find_category = Category.find_by(name: category_name_or_id)
      category_id = find_category.id
      copy_of_params = admin_product_params
      copy_of_params[:category_id] = category_id
      params_for_update = copy_of_params
    else
      params_for_update = admin_product_params
    end
    p "testing", @admin_product
    respond_to do |format|
      if @admin_product.update(params_for_update)
        format.html { redirect_to admin_product_url(@admin_product), notice: "Product was successfully updated." }
        format.json { render :show, status: :ok, location: @admin_product }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @admin_product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/products/1 or /admin/products/1.json
  def destroy
    @admin_product.destroy!

    respond_to do |format|
      format.html { redirect_to admin_products_url, notice: "Product was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_admin_product
      @admin_product = Product.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def admin_product_params
      params.require(:product).permit(:name, :description, :price, :category_id, :active, images: [])
    end

    def is_integer?(string)
      string.to_i.to_s == string
    end

    def get_cat_name(category_id_or_name)
      Category.find(category_id_or_name).name
    end
end
