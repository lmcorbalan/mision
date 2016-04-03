class TransactionsController < ApplicationController
  before_action :set_transaction, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @transactions = Transaction.all
  end

  def show
    respond_with(@transaction)
  end

  def new
    if params['pedido_id']
      @pedido = Pedido.find(params['pedido_id'])
      @usuario = Usuario.find(@pedido.usuario_id)
    end
    @transaction = Transaction.new
  end

  def edit
  end

  def create
    @transaction = Transaction.new(transaction_params)
    if params['producto_ids']
      pedido = Pedido.find(@transaction.pedido_id)
      params['producto_ids'].each do |i|
        if i != 0
          JSON.parse(pedido.items, symbolize_names: true).each do |item|
            if i.to_i == item[:producto_id].to_i
              @transaction.transaction_details << TransactionDetail.create(
                  transaction_id: @transaction.id,
                  producto_id: i,
                  price: item[:total]/item[:cantidad],
                  quantity: item[:cantidad],
                  subtotal: item[:total]
              )
            end
          end

      end
      end
    if params['no_producto_ids']
      puts('noproducto')
      params['no_producto_ids'].each do |i|
        @transaction.transaction_details << TransactionDetail.create(
            transaction_id: @transaction.id,
            price: params['no_producto_precio_'+i],
            quantity: params['no_producto_cantidad_'+i],
            subtotal: params['no_producto_total_'+i],
        )
      end
    end

    end
    @transaction.save
    respond_with(@transaction)
  end

  def update
    @transaction.update(transaction_params)
    respond_with(@transaction)
  end

  def list
    @widgets = Widget.order(:name).where("name like ?", "%#{params[:term]}%")
    render json: @widgets.map(&:name)
  end

  def destroy
    @transaction.destroy
    respond_with(@transaction)
  end

  def generar
    unless(params[:ciclo_id].empty?)
      count = 0
      pedidos = Pedido.where(compra_id: params[:ciclo_id])
      pedidos.each do |pedido|
        if pedido.has_missing?
          usuario = Usuario.find(pedido.usuario_id)
          if !Transaction.where(pedido_id: pedido.id).exists?
            transaction = Transaction.create(
                                        account_id: usuario.account.id,
                                        pedido_id: pedido.id,
                                        transaction_type: 0,
                                        description: 'Transacción generada automáticamente del pedido #' + pedido.id.to_s
            )
            JSON.parse(pedido.items, symbolize_names: true).each do |item|
              producto = Producto.find(item[:producto_id]) rescue nil
              if !producto.blank?
                if producto.faltante?
                  transaction.transaction_details << TransactionDetail.create(
                                                                         transaction_id: transaction.id,
                                                                         producto_id: producto.id,
                                                                         price: producto.precio,
                                                                         quantity: item[:cantidad],
                                                                         subtotal: item[:total]
                  )
                end
              end
            end
            transaction.amount = transaction.total
            transaction.save
            if transaction.valid?
              count += count
            end
          end
        end
      end
      message = { notice: "Se generaron #{count} Notas de cédito" }
    end
    redirect_to remitos_pedido_index_path(), message
  end

  private
    def set_transaction
      @transaction = Transaction.find(params[:id])
    end

    def transaction_params
      params.require(:transaction).permit(
          :account_id, :pedido_id, :transaction_type, :amount, :description,
          producto_ids:[]
      )
    end
end