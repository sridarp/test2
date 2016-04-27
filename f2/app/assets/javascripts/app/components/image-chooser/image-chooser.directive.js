(function() {
  'use strict';

  angular.module('app.components')
    .directive('imageChooser', ImageChooserDirective);

  /** @ngInject */
  function ImageChooserDirective() {
    var directive = {
      restrict: 'AE',
      scope: {
        image: '='
      },
      link: link,
      templateUrl: 'app/components/image-chooser/image-chooser.html',
      controller: ImageChooserController,
      controllerAs: 'vm',
      bindToController: true
    };

    return directive;

    function link(scope, element, attrs, vm, transclude) {
      vm.activate();
    }

    /** @ngInject */
    function ImageChooserController() {
      var vm = this;

      vm.activate = activate;

      function activate() {
        // TODO Implement

        // Create a Image service to talk to the server  !!Keep service concerns out of this directive!!
        // Create a modal service that has a showModal() !!Keep modal concerns out of this directive!!
      }
    }
  }
})();
