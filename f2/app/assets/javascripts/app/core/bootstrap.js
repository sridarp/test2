/* global session:true */
(function(angular) {
  'use strict';

  /** @ngInject */
  function initUserData($http) {
    $http.get('/api/v1/staff/current_member')
      .then(handleResults);

    function handleResults(data) {
      session = angular.extend(session, data.data);
    }
  }

  /** @ngInject */
  function initExtensions($http, $q) {
    var scripts = [];
    var deferred = $q.defer();

    $http.get('/api/v1/extensions')
      .then(handleResults, handleError);

    return deferred.promise;

    function handleResults(results) {
      angular.forEach(results.data, loadExtension);
      loadScripts();

      function loadExtension(extension) {
        scripts = scripts.concat(extension.scripts);
      }
    }

    function handleError(error) {
      console.error('Failed to load extensions');
      console.dir(error);
      deferred.resolve();
    }

    function loadScripts() {
      if (0 === scripts.length) {
        deferred.resolve();
        return;
      }
      
      angular.forEach(scripts, injectScript);

      function injectScript(script) {
        var tag = angular.element('<script>');
        angular.element('body').append(tag);
        tag.on('load', scriptLoaded);
        tag.on('error', scriptError);
        tag.attr('src', script);

        function scriptLoaded() {
          scripts.splice(scripts.indexOf(script), 1);
          if (0 === scripts.length) {
            deferred.resolve();
          }
        }

        function scriptError() {
          console.error('Failed to load extension script', script);
          scriptLoaded();
        }
      }
    }
  }

  angular.lazy('app')
    .resolve(initUserData)
    .resolve(initExtensions)
    .bootstrap();
})(angular);
