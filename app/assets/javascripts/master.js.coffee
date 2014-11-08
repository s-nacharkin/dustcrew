# -----------------------------------------------------------------------------
# -----------------------------------------------------------------------------
# -----------------------------------------------------------------------------

window.jackband = angular.module "jackband", []

# -----------------------------------------------------------------------------
# -----------------------------------------------------------------------------
# -----------------------------------------------------------------------------

jackband.directive "hit", ()->
  restrict: "C"
  controller: ($scope, $element, $attrs)->
    if $attrs.keycode
      @keycode = $attrs.keycode
      $scope.keygen = [] unless $scope.keygen?
      $scope.keygen.push @
    if $attrs.sample
      # TODO: Свернуть в шаблон!!!
      @hit = ()->
        $tmp = $ """
          <audio>
            <source src=\"samples/#{$attrs.sample}.mp3\" type=\"audio/mpeg\">
            </source>
          </audio>
        """
          .on "ended", (e)->
            $ @
              .remove()
        $ "body"
          .append $tmp
        $tmp.trigger "play"
      $element.on "click", @hit

# -----------------------------------------------------------------------------
# -----------------------------------------------------------------------------
# -----------------------------------------------------------------------------

jackband.directive "keygen", ()->
  restrict: "C"
  controller: ($scope, $element, $attrs)->
    $element.on "keydown", (e)->
      console.log e.keyCode
      _.chain $scope.keygen
        .filter (one)->
          one.keycode == "#{e.keyCode}"
        .each (one)->
          one.hit?()

# -----------------------------------------------------------------------------
# -----------------------------------------------------------------------------
# -----------------------------------------------------------------------------