angular.module('translation').
directive('translation', ($compile, $rootScope, $filter)->
  return {
    restrict: 'E'
    scope: {
      field:   '@'
      default: '='
      other:   '='
      save:    '&'
    }
    transclude: true
    template: '<span ng-hide="edit" class="text" ng-transclude></span>'+
              '<span ng-show="edit" class="input">'+
                '<input type="text" ng-model="textTranslated" ng-keypress="key($event, textTranslated)" popover="{{ text }}" popover-placement="bottom" popover-trigger="mouseenter"/>'+
                '<button ng-click="edit=false">&gt;&gt;</button>'+
              '</span>'
    link: (scope, element, attrs) ->
      scope.translation = false
      scope.edit        = false

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

      if scope.default? # If we try to translate somethings in database
        scope.$watch('other', ->
          id    = scope.default.id
          field = scope.field
          if scope.other.hasOwnProperty(id) and scope.other[id].hasOwnProperty(field)
            scope.text = scope.other[id][field].content
            scope.rev  = scope.other[id][field]._rev
            scope.lang = scope.other[id].lang
          else
            scope.text = scope.default[field].content
            scope.rev  = scope.default[field]._rev
            scope.lang = scope.default.lang
        )
      else # If it's a translation in the interface
        scope.expr = element.find('.text').text().trim()
        $rootScope.$on('$translateChangeSuccess', ($event, language)->
          scope.lang = language
          scope.text = $filter('translate')(scope.expr)
        )

      scope.key = ($event, content) ->
        if $event.keyCode == 13
          id = (if scope.default? then scope.default.id else null)
          scope.edit = false
          scope.save({
            text:  content
            field: scope.field
            key:   scope.expr
            id:    id
            lang:  scope.translationLang
            rev:   scope.rev
          })
  }
)
