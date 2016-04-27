(function() {
  'use strict';

  angular.module('app.components')
    .factory('ProductTypeModal', ProductTypeModalFactory);

  /** @ngInject */
  function ProductTypeModalFactory($modal) {
    var service = {
      showModal: showModal
    };

    return service;

    function showModal() {
      var modalOptions = {
        templateUrl: 'app/components/product-type-modal/product-type-modal.html',
        controller: ProductTypeModalController,
        controllerAs: 'vm',
        resolve: {
          providers: resolveProviders
        },
        windowTemplateUrl: 'app/components/common/modal-window.html'
      };
      var modal = $modal.open(modalOptions);

      return modal.result;

      /** @ngInject */
      function resolveProviders(Provider) {
        return Provider.query().$promise;
      }
    }
  }

  /** @ngInject */
  function ProductTypeModalController(providers) {
    var vm = this;

    vm.selections = {
      providerId: null,
      productTypeId: null
    };

    activate();

    function activate() {
      initFields();
    }

    // Private

    function initFields() {
      vm.fields = [
        {
          key: 'providerId',
          type: 'select',
          templateOptions: {
            label: 'Provider',
            options: providers,
            valueProp: 'id',
            labelProp: 'name'
          }
        },
        {
          key: 'productTypeId',
          type: 'async_select',
          templateOptions: {
            label: 'Product Type',
            options: [],
            valueProp: 'id',
            labelProp: 'name'
          },
          controller: ProductTypeController,
          expressionProperties: {
            'templateOptions.disabled': '!model.providerId'
          }
        }
      ];

      /** @ngInject */
      function ProductTypeController($scope, ProviderProductType) {
        $scope.$watch('model.providerId', loadProductTypes);

        function loadProductTypes(newValue, oldValue) {
          if (newValue === oldValue) {
            return;
          }

          if ($scope.model[$scope.options.key] && oldValue) {
            $scope.model[$scope.options.key] = null;
          }

          $scope.to.loading = ProviderProductType.query({providerId: newValue}).$promise.then(handleResults);

          function handleResults(data) {
            $scope.to.options = data;
          }
        }
      }
    }
  }
})();
