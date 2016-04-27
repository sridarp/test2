(function() {
  'use strict';

  angular.module('app.states')
    .run(appRun);

  /** @ngInject */
  function appRun(routerHelper) {
    routerHelper.configureStates(getStates());
  }

  function getStates() {
    return {
      'manage.products.create': {
        url: '/create/:providerId/:productTypeId',
        templateUrl: 'app/states/manage/products/create/create.html',
        controller: StateController,
        controllerAs: 'vm',
        title: 'Manage Products Create',
        resolve: {
          provider: resolveProvider,
          productType: resolveProductType
        }
      }
    };
  }

  /** @ngInject */
  function resolveProvider($stateParams, Provider) {
    return Provider.get({id: $stateParams.providerId}).$promise;
  }

  /** @ngInject */
  function resolveProductType($stateParams, ProductType) {
    return ProductType.get({id: $stateParams.productTypeId}).$promise;
  }

  /** @ngInject */
  function StateController(Product, provider, productType) {
    var vm = this;

    vm.title = 'Manage Products Create';
    vm.activate = activate;

    activate();

    function activate() {
      vm.subHeading = [provider.name, productType.name].join(' :: ');
      initProduct();
      initForm();
    }

    // Private

    function initProduct() {
      vm.product = Product.new({provider_id: provider.id, product_type_id: productType.id});
      vm.product.tags = provider.tags.concat(productType.tags);
      vm.product.answers = angular.copy(productType.product_questions);
    }

    function initForm() {
      vm.options = {
        formState: {
          provider: provider
        }
      };
    }
  }
})();
