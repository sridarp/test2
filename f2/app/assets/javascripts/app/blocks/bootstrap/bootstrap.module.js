/**
 * This comes from https://github.com/rajeshsegu/angular-lazy-bootstrap
 *
 * It adds `.lazy()` to the angular object so that the application can
 * be loaded lazily.
 */
(function(angular) {
  'use strict';

  // Generic

  function makeArray(arr) {
    if (!arr) {
      return [];
    }

    return angular.isArray(arr) ? arr : [arr];
  }

  // Angular

  function provideRootElement(modules, element) {
    element = angular.element(element);
    modules.unshift(unshiftElement);

    /** @ngInject */
    function unshiftElement($provide) {
      $provide.value('$rootElement', element);
    }
  }

  function createInjector(injectorModules, element) {
    var modules = ['ng'].concat(makeArray(injectorModules));

    if (element) {
      provideRootElement(modules, element);
    }

    return angular.injector(modules);
  }

  function bootstrapApplication(angularApp) {
    angular.element(document).ready(bootstrap);

    function bootstrap() {
      angular.bootstrap(document, [angularApp]);
    }
  }

  angular.lazy = function(app, modules) {
    var injector = createInjector(modules);
    var $q = injector.get('$q');
    var promises = [];
    var errorCallback = angular.noop;
    var loadingCallback = angular.noop;
    var doneCallback = angular.noop;

    return {
      resolve: resolve,
      bootstrap: bootstrap,
      loading: loading,
      done: done,
      error: error
    };

    function resolve(promise) {
      promise = $q.when(injector.instantiate(promise));
      promises.push(promise);

      /*jshint validthis: true */
      return this;
    }

    function bootstrap() {
      loadingCallback();

      return $q.all(promises)
        .then(boot, errorCallback)
        .finally(doneCallback);

      function boot() {
        bootstrapApplication(app);
      }
    }

    function loading(callback) {
      loadingCallback = callback;

      /*jshint validthis: true */
      return this;
    }

    function done(callback) {
      doneCallback = callback;

      /*jshint validthis: true */
      return this;
    }

    function error(callback) {
      errorCallback = callback;

      /*jshint validthis: true */
      return this;
    }
  };
})(angular);
