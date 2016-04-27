(function() {
  'use strict';

  angular.module('app.components')
    .directive('logTable', LogTableDirective);

  /** @ngInject */
  function LogTableDirective() {
    var directive = {
      restrict: 'AE',
      scope: {
        heading: '@',
        records: '=',
        collapsed: '=?',
        itemsPerPage: '=?'
      },
      link: link,
      templateUrl: 'app/components/log-table/log-table.html',
      controller: LogTableController,
      controllerAs: 'vm',
      bindToController: true
    };

    return directive;

    function link(scope, element, attrs, vm, transclude) {
      vm.activate();
    }

    /** @ngInject */
    function LogTableController() {
      var vm = this;

      vm.activate = activate;

      function activate() {
        vm.collapsed = angular.isDefined(vm.collapsed) ? vm.collapsed : false;
        vm.itemsPerPage = angular.isDefined(vm.itemsPerPage) ? vm.itemsPerPage : 10;
      }
    }
  }
})();
