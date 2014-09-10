class AddSlugToAllModels < ActiveRecord::Migration
  def change
    add_column :equipment, :slug, :string
    add_index :equipment, :slug
    #####################################
    add_column :brands, :slug, :string
    add_index :brands, :slug
    #####################################
    add_column :categories, :slug, :string
    add_index :categories, :slug
    #####################################
    add_column :galleries, :slug, :string
    add_index :galleries, :slug
    #####################################
    add_column :images, :slug, :string
    add_index :images, :slug
    #####################################
    add_column :videos, :slug, :string
    add_index :videos, :slug
    #####################################

  end
end
