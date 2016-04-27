(function() {
  'use strict';

  angular.module('app.components')
    .directive('operationsButton', OperationsButtonDirective);

  /** @ngInject */
  function OperationsButtonDirective() {
    var directive = {
      restrict: 'AE',
      scope: {
        service: '=service'
      },
      link: link,
      templateUrl: 'app/components/operations-button/operations-button.html',
      controller: OperationsController,
      controllerAs: 'vm',
      bindToController: true
    };

    return directive;

    function link(scope, element, attrs, vm, transclude) {
      vm.activate();
    }

    /** @ngInject */
    function OperationsController(Service) {
      var vm = this;

      vm.activate = activate;
      vm.operations = [{name: 'Deprovision'}];
      vm.executeOperation = executeOperation;

      function activate() {
      }

      function executeOperation(operation) {
        Service.operation({id: vm.service.id, operation: operation.toLowerCase()})
          .$promise.then(operationSuccess, operationFailure);
      }

      function operationSuccess(data) {
      }

      function operationFailure(data) {
      }
    }
  }
})();
