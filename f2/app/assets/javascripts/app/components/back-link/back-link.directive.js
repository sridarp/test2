(function() {
  'use strict';

  angular.module('app.components')
    .service('$previousState', PreviousStateService);

  /** @ngInject */
  function PreviousStateService($rootScope, $state) {
    var previous = null;
    var lastPrevious = null;

    $rootScope.$on('$stateChangeStart', stateChangeStart);
    $rootScope.$on('$stateChangeError', stateChangeError);
    $rootScope.$on('$stateChangeSuccess', stateChangeSuccess);

    function stateChangeStart(evt, toState, toStateParams, fromState, fromStateParams) {
      lastPrevious = previous;
      previous = {state: fromState, params: fromStateParams};
    }

    function stateChangeError() {
      previous = lastPrevious;
      lastPrevious = null;
    }

    function stateChangeSuccess() {
      lastPrevious = null;
    }

    var $previousState = {
      get: getFunction,
      go: goFunction
    };

    function getFunction() {
      return previous;
    }

    function goFunction() {
      var to = $previousState.get();

      return $state.go(to.state, to.params);
    }

    return $previousState;
  }

  angular.module('app.components').run(previousStateInstantiation);

  /** @ngInject */
  function previousStateInstantiation($previousState) {
  }

  angular.module('app.components')
    .directive('backLink', BackLinkDirective);

  /** @ngInject */
  function BackLinkDirective() {
    var directive = {
      restrict: 'AE',
      scope: {},
      link: link,
      template: '<button class="btn-link" ng-click="vm.stateTransition()">Back</button>',
      controller: BackLinkController,
      controllerAs: 'vm',
      bindToController: true
    };

    return directive;

    function link(scope, element, attrs, vm, transclude) {
      vm.activate();
    }

    /** @ngInject */
    function BackLinkController($previousState) {
      var vm = this;

      vm.activate = activate;
      vm.stateTransition = stateTransition;

      function activate() {
      }

      function stateTransition() {
        $previousState.go();
      }
    }
  }
})();
