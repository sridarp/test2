(function() {
  'use strict';

  angular.module('blocks.state-override')
    .factory('StateOverride', StateOverrideFactory);

  /** @ngInject */
  function StateOverrideFactory($injector, lodash) {
    var service = {
      override: override,
      get: get
    };

    var overrides = {};

    return service;

    function override(state, other) {
      initState(state);
      overrides[state].push(other);
    }

    function get(state, locals) {
      if (!lodash.has(overrides, state)) {
        return;
      }

      return lodash.find(lodash.map(overrides[state], invoke));

      function invoke(other) {
        return $injector.invoke(other, {}, locals);
      }
    }

    // Private

    function initState(state) {
      if (angular.isUndefined(overrides[state])) {
        overrides[state] = [];
      }
    }
  }
})();
