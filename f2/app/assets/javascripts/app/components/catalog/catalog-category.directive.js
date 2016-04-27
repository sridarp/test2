(function() {
  'use strict';

  angular.module('app.components')
    .directive('catalogCategory', CatalogCategoryDirective);

  /** @ngInject */
  function CatalogCategoryDirective() {
    var directive = {
      restrict: 'AE',
      scope: {
        category: '=',
        viewMode: '=?',
        collapsed: '=?',
        comparable: '=?'
      },
      link: link,
      templateUrl: 'app/components/catalog/catalog-category.html',
      controller: CatalogCategoryController,
      controllerAs: 'vm',
      bindToController: true
    };

    return directive;

    function link(scope, element, attrs, vm, transclude) {
      vm.activate();
    }

    /** @ngInject */
    function CatalogCategoryController(VIEW_MODES, ProjectHelper, CartService, SelectedProjectHelper) {
      var vm = this;

      vm.activate = activate;
      vm.addToCart = addToCart;

      function activate() {
        vm.viewMode = vm.viewMode || VIEW_MODES.list;
        vm.collapsed = angular.isDefined(vm.collapsed) ? vm.collapsed : false;
        vm.requiredTags = vm.requiredTags || [];
        vm.comparable = angular.isDefined(vm.comparable) ? vm.comparable : true;
      }

      function addToCart(product) {
        if (SelectedProjectHelper.defaultProject) {
          CartService.add(SelectedProjectHelper.selectedProject, product);
        } else {
          ProjectHelper.showModal(product);
        }
      }
    }
  }
})();
