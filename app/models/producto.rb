class Producto < ActiveRecord::Base
  has_many :categorias
  mount_uploader :imagen, ImagenUploader

  def cart_action(session)
    if session[:product_ids ].include?(self.id)
      'Remove from'
    else
      'Add to'
    end
  end
end
