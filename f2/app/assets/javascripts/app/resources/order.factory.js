(function() {
  'use strict';

  angular.module('app.resources')
    .factory('Order', OrderFactory);

  /** @ngInject */
  function OrderFactory($resource) {
    var Order = $resource('/api/v1/orders/:id', {id: '@id'});

    Order.defaults = {
      product_id: null,
      service: {
        name: null
      }
    };

    Order.new = newOrder;
    Order.prototype.total = total;

    function newOrder(data) {
      return new Order(angular.extend({}, Order.defaults, data || {}));
    }

    function total() {
      /*jshint validthis: true */
      return this.hourly_price * 750 + this.monthly_price;
    }

    return Order;
  }
})();
