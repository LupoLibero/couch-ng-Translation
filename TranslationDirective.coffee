angular.module('translation').
directive('translation', ($compile, $rootScope, $filter)->
  return {
    restrict: 'E'
    scope: {
      field:  '@'
      object: '='
      save:   '&'
    }
    transclude: true
    template: """
              <span ng-hide="edit" class="text" ng-transclude></span>
              <span ng-show="edit" class="input">
                <input type="text" ng-model="textTranslated" ng-keypress="key($event, textTranslated)" popover="{{ text }}" popover-placement="bottom" popover-trigger="mouseenter"/>
                <button ng-click="edit=false">&gt;&gt;</button>
              </span>
              """
    link: (scope, element, attrs) ->
      scope.translation = false
      scope.edit        = false
      scope.lang        = scope.object?.lang

      $rootScope.$on('LangBarNewLanguage', ($event, lang)->
        scope.translation     = true
        scope.translationLang = lang
      )
      $rootScope.$on('LangBarStopTranslate', ->
        scope.translation = false
      )

      element.on('mouseenter', ->
        if scope.translation
          scope.textTranslated = (if scope.lang is scope.translationLang then scope.text else '')
          scope.edit = true
      )
      element.on('mouseleave', ->
        scope.edit = false
      )

      if scope.object? # If we try to translate somethings in database
        scope.expr   = element.find('.text').text().trim()[2..-3]
        $rootScope.$on('ChangeLanguageSuccess', ->
          scope.text = scope.$parent.$eval(scope.expr)
        )
      else # If it's a translation in the interface
        scope.expr = element.find('.text').text().trim()
        $rootScope.$on('$translateChangeSuccess', ($event, language)->
          scope.lang = language
          scope.text = $filter('translate')(scope.expr)
        )

      scope.key = ($event, content) ->
        if $event.keyCode == 13
          scope.edit = false
          scope.save({
            text:  content
            field: scope.field
            key:   scope.expr
            id:    scope.object?.id
            lang:  scope.translationLang
            from:  scope.object?.lang
          })
  }
)
