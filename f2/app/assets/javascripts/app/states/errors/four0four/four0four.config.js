(function() {
  'use strict';

  angular.module('app.states')
    .run(runNotFound);

  function runNotFound($rootScope, $state) {
    $rootScope.$on('$stateNotFound', notFound);

    function notFound(event, toState) {
      event.preventDefault();
      $state.go('errors.four0four', {toState: toState});
    }
  }
})();
