/**
 * Tour Map generator and controller
 */

(function() {
  var root = this;
  
  /**
   * Distance between two points
   */
  function dist(x1, y1, x2, y2) {
    return Math.sqrt((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2));
  }

  var TourMap = root.TourMap = function(elSelector, bubbleSelector) {
    this.el = $(elSelector);
    this.bubbleEl = $(bubbleSelector);
    this.data = window.tourData;
    this.containerOffset = $('#tour-map').offset();
    this.generateMap();
    this.initialize();
  };
  
  TourMap.prototype = {
    // constants
    DISTANCE_THRESHOLD: 100,
    
    // map state
    mapWidth: 2900,
    mapHeight: 1800,
    tileWidth: 250,
    tileHeight: 250,
    imgPrefix: "img/map/map_tile_",
    mapX: 0,
    mapY: 0,
    
    // normalized mouse state
    mouseX: 0,
    mouseY: 0,
    
    // info bubble state
    infoState: "hidden",    // The state of the info popup
    currentInfo: null,      // Object of the current active info, if any
    
    generateMap: function() {
      var tilesWide = Math.ceil(this.mapWidth / this.tileWidth),
          tilesTall = Math.ceil(this.mapHeight / this.tileHeight),
          tile;
      
      for(var x = 0; x < tilesWide; x ++) {
        for(var y = 0; y < tilesTall; y ++) {
          tile = $('<div id="tile-' + (x + 1) + '-' + (y + 1) + '" class="tile" />');
          tile.css({
            left: x * this.tileWidth,
            top: y * this.tileHeight,
            backgroundImage: 'url(' + this.imgPrefix + (x+1) + '_' + (y+1) + '.png)'
          });
          this.el.append(tile);
        }
      }
    },
    
    initialize: function() {
      this.moveMapTo(-1200, -300);
      
      var _this = this;
      
      // Mouse move events
      $(window).mousemove(function(event) {
        _this.mouseMove(event);
      });
      
      // Start UI updating
      setInterval(function() { 
        _this.update(); 
      }, 33);
      
      // Our drag behavior
      this.el.mousedown(function(event) {
        _this.isMouseDown = true;
        _this.startPos = _this.el.position();
        _this.mouseStartX = event.pageX;
        _this.mouseStartY = event.pageY;
        
        $(window).mouseup(function(event) {
          _this.isMouseDown = false;
        });
      });
    },
    
    /**
     * Our UI update function, delegating the display of the
     * info bubble
     */
    update: function() {
      // Update the map
      this.el.css({
        left: this.mapX,
        top: this.mapY,
      });
      
      // Update the info buble
      var closestInfo = null;
      var closestDist = 999999;
      
      for(var i in this.data) {
        var info = this.data[i],
            d = dist(info.x, info.y, this.mouseX, this.mouseY),
            inBounds;

        var viewWidth = this.el.parent().width();
        var viewHeight = this.el.parent().height();
        
        inBounds = info.x > -this.mapX && 
          info.x < -this.mapX + viewWidth && 
          info.y > -this.mapY &&
          info.y < -this.mapY + viewHeight;
        
        if(inBounds && d < closestDist && d < this.DISTANCE_THRESHOLD) {
          closestInfo = info;
        }
      }
      
      if(this.currentInfo != closestInfo) {
        this.currentInfo = closestInfo;
        if(this.currentInfo) {
          this.updateBubble(this.currentInfo)
          this.bubbleEl.show();
        } else {
          this.bubbleEl.hide();
        }
      }
      
      if(this.currentInfo) {
        this.bubbleEl.css({
          left: this.mapX + this.currentInfo.x + this.containerOffset.left,
          top: this.mapY + this.currentInfo.y + this.containerOffset.top,
        })
      }
    },
    
    /**
     * Our move mosue function serves to purposes:
     * 1) To update mouse state for the UI
     * 2) Handle drag motions
     */
    mouseMove: function(event) {
      if(this.isMouseDown) {
        var x = event.pageX - this.mouseStartX + this.startPos.left,
            y = event.pageY - this.mouseStartY + this.startPos.top;
        this.moveMapTo(x, y);
      }
      
      var offset = this.el.offset();
      this.mouseX = event.pageX - offset.left;
      this.mouseY = event.pageY - offset.top;
    },
    
    updateBubble: function(info) {
      this.bubbleEl.find('#name').html(info.name);
      this.bubbleEl.find('#description').html(info.description);
    },
    
    moveMapTo: function(x, y) {
      var viewWidth = this.el.parent().width();
      var viewHeight = this.el.parent().height();
      this.mapX = Math.min(0, Math.max(-(this.mapWidth - viewWidth), x)),
      this.mapY = Math.min(0, Math.max(-(this.mapHeight - viewHeight), y));
      console.log(this.mapX, this.mapY);
    }
  }
  
}).call(this);