// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require_tree .

$(document).ready(function () {

  $('button[data-action]').click(function (event) {
    event.preventDefault();

    var that = $(this);

    var new_title, new_action;
    var action = that.data('action');
    var productId = that.data('productid');
    var url = 'cart/' + action + '/' + productId;

    if (action === 'add') {
      //Add a new item to cart
      new_action = 'remove';
      new_title = "Eliminar del ";
    } else if (action === 'remove') {
      //Remove item from cart
      new_action = 'add';
      new_title = "Agregar al ";
      that.parents("tr.cart-item").remove();
    }

    $.ajax({
      url: url,
      data: { cantidad: that.prev('select.cantidad').val() },
      type: 'put'
    }).done(function (data) {
      //Update menu
      $('.cart-cantidad').html(data.cantidad);
      $('.cart-ahorro').html(data.ahorro.toFixed(2) + "%");
      $('.cart-total').html(data.total);

      that.find('span.cart-action').html(new_title);
      that.data('action', new_action);
    });
  });

  var app = angular.module('misionApp', []);

  app.controller('CartController', [ '$http', function ($http) {
      var cart = this;
      cart.items = [];

      cart.getItems = function() {
        $http.get('/cart/angular').success(function(data, status, headers, config){
          cart.items = data;
        });
      };
      cart.getItems();

      cart.addItem = function (item) {
        cart.items.push({qty: 1, prod_id: item.prod_id, price: item.price, saving: item.saving});
      };

      cart.removeItem = function (prod_id) {
        angular.forEach(cart.items, function (item) {
          if(item.prod_id == prod_id) {
            console.log(prod_id);
            var index = $.inArray(item, cart.items);
            cart.items.splice(index,1);
            return;
          }
        });
      };

      cart.total = function () {
        var total = 0;
        angular.forEach(cart.items, function (item) {
          total += item.precio * item.cantidad;
        });
        return total;
      };

      cart.savings = function () {
        return 0;
      };
  }]);

  app.controller('ProductosController', [ '$http', function ($http) {
    var cart = this;
    cart.productos = [];

    cart.getProductos = function() {
      $http.get('/productos.json').success(function(data, status, headers, config){
        cart.productos = data;
      });
    };
    cart.getProductos();

  }]);
});