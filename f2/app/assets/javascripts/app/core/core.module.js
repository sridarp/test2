(function() {
  'use strict';

  angular.module('app.core', [
    // Angular modules
    'ngAnimate',
    'ngSanitize',
    'ngMessages',
    'ngAria',

    // Blocks modules
    'blocks.exception',
    'blocks.logger',
    'blocks.router',
    'blocks.multi-transclude',
    'blocks.pub-sub',
    'blocks.bind-attrs',
    'blocks.directive-options',
    'blocks.recursion',
    'blocks.state-override',

    // Third party modules
    'ui.router',
    'angular.filter'
  ]);
})();
