# -----------------------------------------------------------------------------
# -----------------------------------------------------------------------------
# -----------------------------------------------------------------------------

window.dustcrew = angular.module "dustcrew", []

# -----------------------------------------------------------------------------
# -----------------------------------------------------------------------------
# -----------------------------------------------------------------------------

dustcrew.factory "now", ()->
  ()->
    (new Date).valueOf()

# -----------------------------------------------------------------------------
# -----------------------------------------------------------------------------
# -----------------------------------------------------------------------------

dustcrew.factory "log", ["now", (now)->
  log = []
  (one)->
    if one.sample
      log.push $.extend true, {},
        time: now()
      , one
    log
]

# -----------------------------------------------------------------------------
# -----------------------------------------------------------------------------
# -----------------------------------------------------------------------------

dustcrew.factory "play", ["log", "now", (log, now)->
  (sample)->    
    $ "<audio>"
      .data
        sample: sample
        time: now()
      .prop "src", "samples/#{sample}.mp3"
      .on "loadeddata", (e)->
        $this = $ @
        log
          sample:   $this.data "sample"
          time:     $this.data "time"
          duration: Math.round 1000 * $this.prop "duration"
      .on "ended", (e)->
        $ @
          .remove()
      .trigger "play" if sample
]

# -----------------------------------------------------------------------------
# -----------------------------------------------------------------------------
# -----------------------------------------------------------------------------

dustcrew.directive "keygen", ()->
  restrict: "C"
  controller: ($element)->
    $element.on "keydown", (e)->
      # console.log e.keyCode
      $ "[keycode=#{e.keyCode}]"
        .trigger "click"

# -----------------------------------------------------------------------------
# -----------------------------------------------------------------------------
# -----------------------------------------------------------------------------

dustcrew.controller "hit", ["$attrs", "play", ($attrs, play)->
  @samle = $attrs.sample
  @do = ()->
    play @samle
    on
]

# -----------------------------------------------------------------------------
# -----------------------------------------------------------------------------
# -----------------------------------------------------------------------------

dustcrew.controller "rec", [
    "$scope", "$element", "$interval", "$timeout", "log", "play",
    ($scope, $element, $interval, $timeout, log, play)->
      @start = false
      @end   = false
      @in_rec = false
      @in_play = false

      @que   = []

      @loop = ()=>
        $interval.cancel @interval unless @in_play
        _.each @que, (one)=>
          $timeout ()=>
            play one.sample if @in_play
          , one.time - @start
      
      @rec = ()=>
        if @in_rec
          @end   = (new Date).valueOf()
          @que   = _.filter log(false), (one)=>
            fin = one.time + one.duration
            fin >= @start && fin <= @end
          @in_play = false
          @play()
        else 
          @start = (new Date).valueOf()
          @end   = false
          @que   = []
        @in_rec = !@in_rec
        on

      @play = ()=>
        if @in_play
          $interval.cancel @interval
        else
          @loop()
          @interval = $interval @loop, @end - @start
        @in_play = !@in_play
        # console.log @que
        on
  ]

# -----------------------------------------------------------------------------
# -----------------------------------------------------------------------------
# -----------------------------------------------------------------------------