###

## init code:

usage: $(selector).edgeSwipe().on({
	"swipestart": function(e,data){ 
		// while start  
	}, 
	"swipemove": function(e,data){  
		//while moving  
	}, 
	"swipeend": function(e,data){  
		//while end  
	}, 
});

###

do -> # swipe

	class SwipeView
		constructor:(opt)->
			@options = opt
			$.extend this,
				options:opt
				el: opt.el
				$el: $(opt.el)
			@init()
		init:()->
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

	$.fn.edgeSwipe = (options={})->
		options.el = this
		view = new SwipeView(options)
		$(this).data("swpieView",view)
		return this