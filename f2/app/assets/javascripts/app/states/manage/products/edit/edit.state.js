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
      'manage.products.edit': {
        url: '/edit/:productId',
        templateUrl: 'app/states/manage/products/edit/edit.html',
        controller: StateController,
        controllerAs: 'vm',
        title: 'Product Edit',
        resolve: {
          product: resolveProduct
        }
      }
    };
  }

  /** @ngInject */
  function resolveProduct(Product, $stateParams) {
    return Product.get({id: $stateParams.productId, 'includes[]': ['answers', 'product_type', 'provider']}).$promise;
  }

  /** @ngInject */
  function StateController(lodash, product) {
    var vm = this;

    var provider = product.provider;
    var productType = product.product_type;

    vm.product = product;

    vm.title = 'Product Edit';
    vm.activate = activate;

    activate();

    function activate() {
      vm.subHeading = [provider.name, productType.name].join(' :: ');
      initProduct();
      initForm();
    }

    // Private

    function initProduct() {
      var questions = angular.copy(productType.product_questions);

      delete vm.product.provider;
      delete vm.product.product_type;
      angular.forEach(questions, mergeWithAnswer);
      vm.product.answers = questions;

      function mergeWithAnswer(question) {
        var answer = lodash.find(product.answers, 'name', question.name);

        angular.extend(question, answer || {});
      }
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
