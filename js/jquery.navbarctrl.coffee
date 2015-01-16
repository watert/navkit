###

# quick start:

```coffeescript
navbar = $(selector).navbar()
navbar.push($dom)
navbar.pop()
```

# init options:

- `animate: true|false`, default `true`

# methods

- `push($dom, options)`: push dom to stack with options:
	- init: ()->
	- title: ()->
	- 
- `pop(options)`: pop dom to back
- `setTitle(titleString)`
- ``

###

$ ->
	nav = $("#navbarCtrl").navCtrl()
	window.nav = nav
	nav.push( " Content Dom ", {title: "title1"} )
	setTimeout ()->
		nav.push( " Content Dom 2 ", {title: "title2"} )
	,500
# nav
class BaseView
	constructor:(opt)->
		$.extend this,
			options:opt
		if opt.el then $.extend this,
			el: opt.el
			$el: $(opt.el)
		@initialize?(arguments...)
	$: -> @$el.find(arguments...)

class SwipeView extends BaseView
	initialize:()->
		@$el.on("touchstart",(e)=> @handleTouchStart(e))
		@$el.on("touchmove",(e)=> @handleTouchMove(e))
		@$el.on("touchend",(e)=> @handleTouchEnd(e))

	pointByTouch:(touch)->
		ret = x:touch.pageX, y:touch.pageY
	getOffset:(touch)->
		point1 = @edgeData.pointStart
		point2 = @pointByTouch(touch)
		ret = 
			x: point2.x - point1.x
			y: point2.y - point1.y
		return ret

	# 获取初始的边缘信息
	getStartEdge:(point)->
		edgePercentage = .13 #在13%范围内则为边缘发起
		width = @$el.width()
		offset = @$el.offset()
		pos = 
			x: point.x - offset.left
			y: point.y - offset.top
		per = 1.0 * pos.x / width

		if per < edgePercentage then return "left"
		else if per > (1 - edgePercentage) then return "right"
		else return "center"

	# 事件处理
	handleTouchStart:(e)->
		touch = e.originalEvent.touches[0]
		point = @pointByTouch(touch)
		@edgeData = e.edgeData = {
			pointStart: point
			startEdge: @getStartEdge(point)
		}
		@$el.trigger("swipestart", @edgeData)

	handleTouchMove:(e)->
		touch = e.originalEvent.touches[0]
		offset = @edgeData.offset = @getOffset(touch)
		# edgeOffset = if @edgeData.startEdge is "left" then offset.x else 0 - offset.x
		@$el.trigger "swipemove", @edgeData
	handleTouchEnd:(e)->
		@edgeData.pointEnd = @pointByTouch(e)
		@$el.trigger "swipeend", @edgeData

class NavViewItem extends BaseView
	initialize:($dom, options)->
		console.debug "init NavViewItem", $dom
		if typeof $dom is "string" then $dom = $.parseHTML($dom)
		@$el = $($.parseHTML @html).append($dom)
		@setStyle()

	setNavbar:(navbar)->
		@navbar = navbar
		navbar.show()
	show:()->
		console.debug @$el.width(), cssTranslateX(@$el.width())
		domAnimate(@$el, cssTranslateX(@$el.width()), cssTranslateX(0) )

	hide:()->
		console.debug "hide",@$el
		domAnimateTo(@$el, cssTranslateX( -@$el.width()*.2 ))
		@navbar.hide()

		return
		@$el.removeClass("fadeInRight").addClass("fadeOutLeft animated")
	html:"""
		<div class="view-item">

		</div>
	"""
	setStyle:()->
		@$el.css
			width:"100%"
			position:"absolute"
			left:0
			top:0
class NavbarItem
	constructor:(opt)->
		@$el = $($.parseHTML(@html))
		@$ = (a)-> @$el.find(a)
		if opt.title 
			@$(".navbar-title").text(opt.title)
	pos: [0.6, -0.2]
	hide:()->
		cssTo =  $.extend {opacity:0} ,cssTranslateX( @$el.width()*@pos[1] )
		domAnimateTo(@$el, cssTo )
	show:()->
		cssFrom = $.extend {opacity:0} , cssTranslateX(@$el.width()*@pos[0])
		cssTo =  $.extend {opacity:1} ,cssTranslateX(0)
		domAnimate(@$el, cssFrom,cssTo  )
		# domAnimate(@$el, cssTranslateX( -@$el.width()*.2 ))

		# @$el.addClass("fadeInRight animated")
	html: """
		<div class="navbar-item">
			<div class="navbar-left">
				<button class="btn btn-back">
					< <span class="back-btn-text"> Back </span>
				</button>
			</div>
			<div class="navbar-title">
				
			</div>
		</div>
	"""
class NavCtrl extends BaseView
	initSlide:()->

	initialize:(options)->
		@stack = []
		@$el.html(@html)
		@swipe = new SwipeView(el:@el)
		@$el.on "swipemove",(e,data)=>
			if data.startEdge isnt "left" then return
			x = data.offset.x
			if x < 0 then x = 0
			@setMoveOffsets(x)
		@$el.on "swipeend",(e,data)=>
			# reset to original
			view = @currentView()
			domAnimateTo( view.$el, cssTranslateX(0) )
			domAnimateTo(view.navbar.$el, $.extend({opacity:1}, cssTranslateX(0)) )

		@$(".views-container").height( @$el.height() - @$(".navbar").height() )
	setMoveOffsets:(x)->
		view = @currentView()
		view.$el.css(cssTranslateX(x))

		navbarCSS = cssTranslateX(x* view.navbar.pos[0])
		$.extend(navbarCSS, {opacity:1- x/@$el.width()})

		view.navbar.$el.css( navbarCSS )
	html: """
		<div class="navctrl">
			<div class="navbar">
			</div>
			<div class="views-container">
				<div class="views" style="position:relative;">
					
				</div>
			</div>
		</div>
	"""
	currentView:()->
		@stack[@stack.length-1]

	push:($dom,options={})->
		# init new view
		lastView = @currentView()
		console.debug "new NavViewItem",$dom
		view = new NavViewItem($dom)
		options.prevNavbar = lastView?.navbar
		navbar = new NavbarItem(options)

		# @setStyle(view.$el)
		console.debug @$(".views"),$dom

		# hide old one
		lastView.hide() if lastView

		# insert new view
		@$(".views").append(view.$el)
		@$(".navbar").append(navbar.$el)
		@stack.push(view)
		view.setNavbar(navbar)
		view.show()

# Utils
domAnimateTo = ($dom, to)->
	$dom.css(cssTransition("all ease-in-out .2s")).css(to)
		.on "-webkit-transitionEnd transitionend", ()-> $dom.css(cssTransition(""))
domAnimate = ($dom, from, to)->
	$dom.css(from)
	setTimeout ( -> domAnimateTo($dom, to) ), 33
cssTransition = (val)->
	"-webkit-transition": "-webkit-"+val
	"transition": val
cssTranslate = (val)->
	"-webkit-transform": val
	"transform": val
cssTranslateX = (x)->
	cssTranslate("translateX(#{x}px)")

$.fn.navCtrl = (options={})->
	options.el = this
	nav = new NavCtrl(options)
	$(this).data("nav",nav)
	return nav