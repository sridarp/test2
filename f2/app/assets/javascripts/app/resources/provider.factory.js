(function() {
  'use strict';

  angular.module('app.resources')
    .factory('Provider', ProviderFactory);

  /** @ngInject */
  function ProviderFactory($resource) {
    var Provider = $resource('/api/v1/providers/:id', {id: '@id'}, {
      update: {
        method: 'PUT',
        isArray: false
      }
    });

    Provider.defaults = {
      registered_provider_id: null,
      name: '',
      description: '',
      active: false,
      tags: [],
      answers: []
    };

    Provider.new = newProvider;

    function newProvider(data) {
      return new Provider(angular.extend({}, Provider.defaults, data || {}));
    }

    return Provider;
  }
})();
