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
	nav.push( " Content Dom ", {title: "title1"} )
	setTimeout ()->
		nav.push( " Content Dom 2 ", {title: "title2"} )
	,1000
do -> # nav

	class NavViewItem
		constructor:($dom, options)->
			if typeof $dom is "string" then $dom = $.parseHTML($dom)
			@$el = $($.parseHTML @html)
			console.debug "@$el",@$el
			@$el.append($dom)
			@setStyle()
			return this
		setNavbar:(navbar)->
			@navbar = navbar
			navbar.show()
		show:()->
			@$el.addClass("fadeInRight animated")
		hide:()->
			console.debug "hide",@$el
			@navbar?.$el.hide()
			return
			@$el.removeClass("fadeInRight").addClass("fadeOutLeft animated")
			# @$el.addClass("hidden")
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
		show:()->
			@$el.addClass("fadeInRight animated")
		html: """
			<div class="navbar-item">
				<div class="navbar-title">
					
				</div>
			</div>
		"""
	class NavCtrl
		constructor:(opt)->
			# @options = opt
			# $.extend this,
			# 	options:opt
			# 	el: opt.el
			# 	$el: $(opt.el)
			@el = opt.el
			@$el = $(@el)
			@$ = (a,b)->@$el.find(a,b)
			@init(opt)
			return this
		initSlide:()->

		init:(options)->
			@stack = []
			@$el.html(@html)
			@$(".views-container").height( @$el.height()-@$(".navbar").height() )
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

		push:($dom,options)->
			# init new view
			view = new NavViewItem($dom)
			navbar = new NavbarItem(options)
			# @setStyle(view.$el)
			console.debug @$(".views"),$dom

			# hide old one
			lastView = @currentView()
			lastView.hide() if lastView

			# insert new view
			@$(".views").append(view.$el)
			@stack.push(view)
			view.setNavbar(navbar)
			view.show()
			@$(".navbar").append(navbar.$el)
	# class NavbarItem
	# 	constructor:(opt)->
	# 		@init(opt)
	# 		if opt.rootEl then @push(opt.rootEl)


	$.fn.navCtrl = (options={})->
		options.el = this
		nav = new NavCtrl(options)
		$(this).data("nav",nav)
		return nav