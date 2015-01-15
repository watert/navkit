// Generated by CoffeeScript 1.8.0

/*

 *# init code:

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
 */

(function() {
  (function() {
    var SwipeView;
    SwipeView = (function() {
      function SwipeView(opt) {
        this.options = opt;
        $.extend(this, {
          options: opt,
          el: opt.el,
          $el: $(opt.el)
        });
        this.init();
      }

      SwipeView.prototype.init = function() {
        this.$el.on("touchstart", (function(_this) {
          return function(e) {
            return _this.handleTouchStart(e);
          };
        })(this));
        this.$el.on("touchmove", (function(_this) {
          return function(e) {
            return _this.handleTouchMove(e);
          };
        })(this));
        return this.$el.on("touchend", (function(_this) {
          return function(e) {
            return _this.handleTouchEnd(e);
          };
        })(this));
      };

      SwipeView.prototype.pointByTouch = function(touch) {
        var ret;
        return ret = {
          x: touch.pageX,
          y: touch.pageY
        };
      };

      SwipeView.prototype.getOffset = function(touch) {
        var point1, point2, ret;
        point1 = this.edgeData.pointStart;
        point2 = this.pointByTouch(touch);
        ret = {
          x: point2.x - point1.x,
          y: point2.y - point1.y
        };
        return ret;
      };

      SwipeView.prototype.getStartEdge = function(point) {
        var edgePercentage, offset, per, pos, width;
        edgePercentage = .13;
        width = this.$el.width();
        offset = this.$el.offset();
        pos = {
          x: point.x - offset.left,
          y: point.y - offset.top
        };
        per = 1.0 * pos.x / width;
        if (per < edgePercentage) {
          return "left";
        } else if (per > (1 - edgePercentage)) {
          return "right";
        } else {
          return "center";
        }
      };

      SwipeView.prototype.handleTouchStart = function(e) {
        var point, touch;
        touch = e.originalEvent.touches[0];
        point = this.pointByTouch(touch);
        this.edgeData = e.edgeData = {
          pointStart: point,
          startEdge: this.getStartEdge(point)
        };
        return this.$el.trigger("swipestart", this.edgeData);
      };

      SwipeView.prototype.handleTouchMove = function(e) {
        var offset, touch;
        touch = e.originalEvent.touches[0];
        offset = this.edgeData.offset = this.getOffset(touch);
        return this.$el.trigger("swipemove", this.edgeData);
      };

      SwipeView.prototype.handleTouchEnd = function(e) {
        this.edgeData.pointEnd = this.pointByTouch(e);
        return this.$el.trigger("swipeend", this.edgeData);
      };

      return SwipeView;

    })();
    return $.fn.edgeSwipe = function(options) {
      var view;
      if (options == null) {
        options = {};
      }
      options.el = this;
      view = new SwipeView(options);
      $(this).data("swpieView", view);
      return this;
    };
  })();

}).call(this);

//# sourceMappingURL=jquery.edgeswipe.js.map