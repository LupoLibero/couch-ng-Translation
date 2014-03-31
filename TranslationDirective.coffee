angular.module('translation').
directive('translation', ($compile, $rootScope, $timeout)->
  return {
    restrict: 'E'
    scope: {
      save:    '&'
    }
    transclude: true
    template: '<span ng-hide="edit" class="text" ng-transclude></span>'+
              '<span ng-show="edit" class="input">'+
                '<input popover="{{ text }}" popover-trigger="focus" type="text" ng-model="content" ng-keypress="key($event, content)"/>'+
                '<button ng-click="textMode()">&gt;&gt;</button>'+
              '</span>'
    link: (scope, element, attrs) ->
      scope.translation = false

      $rootScope.$on('LangBarNewLanguage', ->
        scope.translation = true
      )
      $rootScope.$on('LangBarStopTranslate', ->
        scope.translation = false
      )

      element.on('mouseenter', ->
        if scope.translation
          scope.edit = true
      )
      element.on('mouseleave', ->
        scope.edit = false
      )

      scope.expr = element.find('.text').text().trim()[2..-3]
      scope.text = scope.$parent.$eval(scope.expr)

      $rootScope.$on('LanguageChangeSuccess', ->
        scope.text = scope.$parent.$eval(scope.expr)
      )

      scope.textMode = ->
        scope.edit = false

      scope.key = ($event, content) ->
        if $event.keyCode == 13
          scope.edit = false
          scope.save({text: content})
  }
)
