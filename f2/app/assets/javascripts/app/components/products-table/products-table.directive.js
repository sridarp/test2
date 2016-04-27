(function() {
  'use strict';

  angular.module('app.components')
    .directive('productsTable', ProductsTableDirective);

  /** @ngInject */
  function ProductsTableDirective() {
    var directive = {
      restrict: 'AE',
      scope: {
        products: '=',
        productTypes: '='
      },
      link: link,
      templateUrl: 'app/components/products-table/products-table.html',
      controller: ProductsTableController,
      controllerAs: 'vm',
      bindToController: true
    };

    return directive;

    function link(scope, element, attrs, vm, transclude) {
      vm.activate();
    }

    /** @ngInject */
    function ProductsTableController(lodash) {
      var vm = this;

      vm.activate = activate;

      function activate() {
        setProductTypes();
      }

      // Private

      function setProductTypes() {
        angular.forEach(vm.products, setProductType);

        function setProductType(product) {
          var productType = lodash.find(vm.productTypes, {id: product.product_type_id});
          product.product_type = productType ? productType.name : 'Unknown';
        }
      }
    }
  }
})();
