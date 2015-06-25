class Item
  attr_reader :producto, :cantidad

  def initialize(producto, cantidad)
    @producto = producto || fail('Producto no definido')
    @cantidad = cantidad.to_f
    fail('Debe proveer una cantidad') if @cantidad <= 0
  end

  def ahorro
    return 0 if @producto.precio_super.nil? || @producto.precio_super == 0
    @cantidad * 100 * ((@producto.precio_super - @producto.precio) / @producto.precio_super)
  end

  def total
    @cantidad * @producto.precio
  end

  def to_json
  { producto_id: @producto.id, 
    cantidad: @cantidad,
    removeUrl: remove_from_cart_path(@producto.id) }
  end

  def purchase_data
  { 
    producto_id: @producto.id, 
    cantidad: @cantidad,
    total: total,
  }
  end

  def angularData
  { 
    id: @producto.id,
    nombre: @producto.nombre,
    codigo: @producto.codigo,
    cantidad: @cantidad,
    precio: @producto.precio,
    ahorro: @producto.ahorro
  }
  end
end
