(function() {
  'use strict';

  angular.module('app.components')
    .directive('projectServices', ProjectServicesDirective);

  /** @ngInject */
  function ProjectServicesDirective() {
    var directive = {
      restrict: 'AE',
      scope: {
        project: '=',
        services: '='
      },
      link: link,
      templateUrl: 'app/components/project-services/project-services.html',
      controller: ProjectServicesController,
      controllerAs: 'vm',
      bindToController: true
    };

    return directive;

    function link(scope, element, attrs, vm, transclude) {
      vm.activate();
    }

    /** @ngInject */
    function ProjectServicesController($state, SelectedProjectHelper) {
      var vm = this;

      vm.activate = activate;
      vm.readOnly = readOnlyCheck;
      vm.addService = addService;

      function activate() {
      }

      function readOnlyCheck() {
        return null === vm.project.archived;
      }

      function addService() {
        SelectedProjectHelper.selectProject(vm.project, true);
        $state.go('marketplace');
      }
    }
  }
})();
