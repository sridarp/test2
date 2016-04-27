(function() {
  'use strict';

  angular.module('app.resources')
    .factory('Log', LogFactory);

  /** @ngInject */
  function LogFactory($resource) {
    var Log = $resource('/api/v1/logs/:type/:id' , {id: '@id', type: '@type'}, {});
    delete Log.get;
    delete Log.save;
    delete Log.remove;
    delete Log.delete;

    return Log;
  }
})();
