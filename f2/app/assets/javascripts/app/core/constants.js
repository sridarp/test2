/* global toastr:false, moment:false, _:false, $:false, session:true */
(function() {
  'use strict';

  // Session is set during the bootstrap process (prior to angular running)
  // The variable exists in index.html and will be undefined in tests
  window.session = window.session || {};

  angular.module('app.core')
    .constant('lodash', _)
    .constant('jQuery', $)
    .constant('toastr', toastr)
    .constant('moment', moment)
    .constant('userSession', window.session);
})();
