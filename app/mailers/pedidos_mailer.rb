class PedidosMailer < ActionMailer::Base
  default from: "victoriacolectiva@misionantiinflacion.com.ar"

  def mail_checkout(to_email,pedido)
    @email = to_email
    @pedido = pedido
    mail(to: to_email, subject: 'Felicitaciones, hiciste tu pedido en la Mision')
  end

end