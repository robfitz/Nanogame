/**
 * Tour Map generator and controller
 */

(function() {
  var root = this;

  var TourMap = root.TourMap = function(elSelector) {
    this.el = $(elSelector);
    
    this.generateMap();
    this.initialize();
  };
  
  TourMap.prototype = {
    mapWidth: 2624,
    mapHeight: 1612,
    tileWidth: 250,
    tileHeight: 250,
    imgPrefix: "img/map/map_tile_",
    
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
      this.moveTo(- this.mapWidth / 2, - this.mapHeight / 2);
      
      var _this = this;
      
      this.el.mousedown(function(event) {
        
        var onMouseDrag = function(event) {
          var x = event.pageX - _this.mouseStartX + _this.startPos.left,
              y = event.pageY - _this.mouseStartY + _this.startPos.top;
          _this.moveTo(x, y)
        };
        
        $(window).mousemove(onMouseDrag).mouseup(function(event) {
          $(window).unbind('mousemove', onMouseDrag);
        });
        
        _this.startPos = _this.el.position();
        _this.mouseStartX = event.pageX;
        _this.mouseStartY = event.pageY;
        
      });
    },
    
    moveTo: function(x, y) {
      var normX = Math.min(0, Math.max(-(this.mapWidth - 760), x)),
          normY = Math.min(0, Math.max(-(this.mapHeight - 540), y));
      
      this.el.css({
        left: normX,
        top: normY
      });
    }
  }
  
}).call(this);