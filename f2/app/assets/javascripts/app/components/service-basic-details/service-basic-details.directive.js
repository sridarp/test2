(function() {
  'use strict';

  angular.module('app.components')
    .directive('serviceBasicDetails', ServiceBasicDetailsDirective);

  /** @ngInject */
  function ServiceBasicDetailsDirective() {
    var directive = {
      restrict: 'AE',
      scope: {
        service: '='
      },
      link: link,
      templateUrl: 'app/components/service-basic-details/service-basic-details.html',
      controller: ServiceBasicDetailsController,
      controllerAs: 'vm',
      bindToController: true
    };

    return directive;

    function link(scope, element, attrs, vm, transclude) {
      vm.activate();
    }

    /** @ngInject */
    function ServiceBasicDetailsController() {
      var vm = this;

      vm.activate = activate;

      function activate() {
      }
    }
  }
})();
