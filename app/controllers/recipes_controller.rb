class RecipesController < ApplicationController
    layout 'application'

  def index
    @recipes = Recipe.all
  end

  def show
    @recipe = Recipe.find(params[:id])
  end

  def new
    @recipe = Recipe.new
  end

  def create
    @recipe = Recipe.new(name: recipe_params[:name])

    if @recipe.save
      recipe_params[:ingredients].each do |ingredient_id|
        if ingredient_id != ""
          RecipeIngredient.create(recipe_id: @recipe.id, ingredient_id: ingredient_id)
        end 
      end
      redirect_to @recipe
    else
      render :new
    end
  end

  def edit
    @recipe = Recipe.find(params[:id])
  end

  def update
    @recipe = Recipe.find(params[:id])

    @recipe.update(name: recipe_params[:name])
    @recipe.recipe_ingredients.destroy_all
    recipe_params[:ingredients].each do |ingredient_id|
        if ingredient_id != ""
          RecipeIngredient.create(recipe_id: @recipe.id, ingredient_id: ingredient_id)
        end 
    end
    redirect_to @recipe
  end

  def destroy
    @recipe = Recipe.find(params[:id])
    @recipe.destroy
    flash[:notice] = "Recipe deleted."
    redirect_to recipes_path
  end

  private

  def recipe_params
    params.require(:recipe).permit(:name, :ingredients => [])
  end
end
