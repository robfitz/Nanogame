/**
 * Parallax effect baclgrounds for the timeline modules
 */

(function() {
  var root = this,
      IMAGE_HEIGHT = 300;
  
  var TimelineBlock = root.TimelineBlock = function(el, hPos) {
    var _this = this;
    
    this.hPos = hPos || 'right'
    this.el = $(el);
    this.foreground = this.el.find('.foreground');
    this.top = this.el.position().top;
    this.height = this.el.height();
    
    $(window).scroll(function(event) {
      _this.onScroll(event);
    }).scroll();
  };
  TimelineBlock.prototype = {
    onScroll: function(event) {
      var scrollTop = $(window).scrollTop(),
          scrollHeight = $(window).height(),
          offset,
          parallax;
      
      offset = ((scrollTop + scrollHeight / 2) - (this.top + this.height / 2)) / .7;
      offset = Math.min(0, offset);
      
      parallax = Math.floor(((this.height / 2 - IMAGE_HEIGHT / 2) + offset));
      
      this.foreground.css({
        backgroundPosition: this.hPos + ' ' + parallax + 'px'
      });
    }
  };
  
}).call(this);