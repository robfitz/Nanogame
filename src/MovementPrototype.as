package
{       
        import as3isolib.core.IIsoDisplayObject;
        import as3isolib.display.IsoSprite;
        import as3isolib.display.IsoView;
        import as3isolib.display.primitive.IsoBox;
        import as3isolib.display.scene.IsoGrid;
        import as3isolib.display.scene.IsoScene;
        import as3isolib.geom.IsoMath;
        import as3isolib.geom.Pt;
        import as3isolib.graphics.Stroke;
        
        import com.gskinner.motion.GTween;
        
        import flash.display.Bitmap;
        import flash.display.BitmapData;
        import flash.display.DisplayObject;
        import flash.display.Loader;
        import flash.display.Sprite;
        import flash.events.Event;
        import flash.events.MouseEvent;
        import flash.geom.Matrix;
        import flash.geom.Point;
        import flash.geom.Rectangle;
        import flash.net.URLLoader;
        import flash.net.URLRequest;
        
        import net.pixelpracht.tmx.TmxLayer;
        import net.pixelpracht.tmx.TmxMap;
        import net.pixelpracht.tmx.TmxPropertySet;
        import net.pixelpracht.tmx.TmxTileSet;
        
        import ui.Slider;
        import ui.SliderButton;
        
        [SWF(width='760', height='570')]
		public class MovementPrototype extends Sprite
        {
                private var box:IIsoDisplayObject;
                private var scene:IsoScene;
				private var foregroundScene:IsoScene;
                private var g:IsoGrid;
                private var view:IsoView;
                
                private var clickTarget:IIsoDisplayObject;
                
                private var character:Sprite;
                private var spriteSheet:DisplayObject;
                
                private var isMouseDown:Boolean = false;
                private var destination:Point;
                
                private var distancePerFrame:Number = 4.5;
                private var distanceToNextFrame:Number = distancePerFrame;
                
                private var decelerationFactor = 10;
                
                private var maxSpeed = 100;
                
                private static const FPS:int = 12;
                
                private static const SPRITE_WIDTH:int = 64;
                private static const SPRITE_HEIGHT:int = 64;
                private static const SPRITE_FRAMES:int = 8;
                
                [Embed(source="assets/Link_run.png")]
				private var Link:Class;
				
				[Embed(source="assets/Wildv2.png")]
				private var Background:Class;
                
                public function MovementPrototype ()
                {
                	
                	var mapLoader:URLLoader = new URLLoader();
                	
                	mapLoader.addEventListener(Event.COMPLETE, function(e:*):void {
	            		var mapXml:XML = new XML(mapLoader.data);
	            		var map:TmxMap = new TmxMap(mapXml);
	            		
	            		var tileSetsToLoad:uint = 0;
	            		
	            		for each (var tileset:TmxTileSet in map.tileSets) {
                			tileSetsToLoad ++;
                			
                			var imgLoader:Loader = new Loader();
                			imgLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(event:Event):void {
                				var bitmap:Bitmap = event.target.content as Bitmap;
                				trace("TODO: movementprototype.as - this will fail for multiple tilesets")
                				tileset.image = bitmap.bitmapData;
                				tileSetsToLoad --; 
                				if (tileSetsToLoad <= 0) {
                					createIsoTiles(map);
                				}
//                				addChild(event.target.content);
                			});
                			imgLoader.load(new URLRequest(tileset.imageSource));
                		}
                	});
                	mapLoader.load(new URLRequest("./assets/isometric_grass_and_water.tmx"));
                	
                    scene = new IsoScene();
					foregroundScene = new IsoScene();
                    
                    this.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
                    stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
                    
                    g = new IsoGrid();
                    g.gridlines = new Stroke(0, 0xCCCCCC, 0);
                    g.showOrigin = false;
                    g.setGridSize(119, 119);
                    stage.addEventListener(MouseEvent.MOUSE_DOWN, grid_mouseHandler);
                    stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
                    scene.addChild(g);
                    
                    clickTarget = new IsoBox();
                    clickTarget.setSize(3, 3, 10);
                    scene.addChild(clickTarget);
                    
                    character = new Sprite();
                    
                    spriteSheet = new Link();
                    character.addChild(spriteSheet);
                    
                    var mask:Sprite = new Sprite();
                    mask.graphics.beginFill(0xffffff);
                    mask.graphics.drawRect(0, 0, 64, 64);
                    mask.graphics.endFill();
                    character.addChild(mask);
                    character.mask = mask;
                    character.x = -32;
                    character.y = -54;
                    
                    var sprite:IsoSprite = new IsoSprite();
                    sprite.setSize(15, 15, 35);
                    sprite.sprites = [character]
                    box = sprite;
                    foregroundScene.addChild(box);
                    
                    view = new IsoView();
                    view.clipContent = false;
                    view.y = 0;
                    view.setSize(stage.stageWidth, stage.stageHeight);
                    view.addScene(scene);
					view.addScene(foregroundScene);
                    addChild(view);
                    
                    scene.render();
					foregroundScene.render();
                 
                 	var slider:Slider = new Slider(0, 18, 7, 400, 30, null, [1, 1.5, 2, 2.5, 3, 3.5, 4, 4.5, 5, 5.5, 6, 6.5, 7, 8, 9, 10, 11, 12, 13]);
                 	slider.addEventListener(Event.CHANGE, function(e:Event):void {
                 		distancePerFrame = slider.val;
                 		trace("set distance per frame: " + distancePerFrame);
                 	});
                 	var sb:SliderButton = new SliderButton("Animation speed", slider);
//                 	addChild(sb);
                 	
                 	var slider2:Slider = new Slider(0, 9, 4, 400, 30, null, [20, 40, 60, 80, 100, 120, 140, 160, 180, 200]);
                 	slider2.addEventListener(Event.CHANGE, function(e:Event):void {
                 		maxSpeed = slider2.val;
                 		trace("set max speed: " + maxSpeed);
                 	});
                 	sb = new SliderButton("Run speed", slider2);
                 	sb.y = 40;
//                 	addChild(sb);
                 	
                 	var gt:GTween = new GTween();
                 	
                 	var slider3:Slider = new Slider(0, 9, 4, 400, 30, [".2", ".4", ".6", ".8", "1", "1.2", "1.4", "1.6", "1.8", "2"], [.2, .4, .6, .8, 1, 1.2, 1.4, 1.6, 1.8, 2]);
                 	slider3.addEventListener(Event.CHANGE, function(e:Event):void {
                 		
                 		if (gt) gt.end();
                 		gt.target = view;
                 		gt.duration = .5;
                 		gt.setProperties({currentZoom:slider3.val});
                 		gt.play();
                 		
                 		//view.currentZoom = slider3.val;
                 		trace("set zoom: " + slider3.val);
                 	});
                 	sb = new SliderButton("Zoom", slider3);
//                 	sb.y = 80;
                 	addChild(sb);
                 	
                 	var slider4:Slider = new Slider(0, 9, 6, 400, 30, null, [48, 32, 24, 20, 16, 12, 10, 8, 6, 4]);
                 	slider4.addEventListener(Event.CHANGE, function(e:Event):void {
                 		
                 		decelerationFactor = slider4.val;
                 		
                 		//view.currentZoom = slider4.val;
                 		trace("set decel: " + slider4.val);
                 	});
                 	sb = new SliderButton("Deceleration", slider4);
                 	sb.y = 120;
//                 	addChild(sb);
                }
                
                private function createIsoTiles(map:TmxMap):void {
                	
                	var tile_sprites:Array = [];
                	for each (var layer:TmxLayer in map.layers) {
                			var spr:Sprite = new Sprite();
                			var tilesheetBitmap:Bitmap;
                			for (var row:int = 0; row < layer.tileGIDs.length; row ++) {
                				for (var col:int = 0; col < layer.tileGIDs[row].length; col ++) {
                					//add tile to map
                					var gid:uint = layer.tileGIDs[row][col];
                					var tileset:TmxTileSet = map.getGidOwner(gid);
                					var properties:TmxPropertySet = tileset.getPropertiesByGid(gid);
                					
                					trace("TODO: this doens't work at all, will only go for first tileset");
                					if (!tilesheetBitmap) tilesheetBitmap = new Bitmap(tileset.image);
                					
                					var rect:Rectangle = tileset.getRect(gid - tileset.firstGID);
                					
									var mat:Matrix = new Matrix();
                					mat.translate(-rect.left, -rect.top);
                					
                					var bmd:BitmapData = new BitmapData(tileset.tileWidth, tileset.tileHeight, true, 0x00ffffff);
                					bmd.draw(tileset.image, mat);
                					var bmp:Bitmap = new Bitmap(bmd);

//                					addChild(bmp);
//                					bmp.x = col * 64;
//                					bmp.y = row * 64;
//                					addChild(bmp);
//									scene.addChild(bmp); 
                					                					
//                					spr.graphics.beginBitmapFill(tileset.image, mat);
//                					var pt:Pt = IsoMath.isoToScreen(new Pt(col*32, row*32));
//                					spr.graphics.drawRect(0, 0, tileset.tileWidth, tileset.tileHeight);
                					
                					var sprite:IsoSprite = new IsoSprite();
                					sprite.setSize(tileset.tileWidth, tileset.tileHeight, 0);
				                    sprite.sprites = [bmp];
				                    sprite.x = col * 32;
//				                    sprite.includeInLayout = false;
				                    sprite.y = row * 32;
				                    //COMMENT IN/OUT
				                    scene.addChild(sprite);
				                    
//				                    tile_sprites.push(sprite);
                				}
                			}
                			//COMMENT IN/OUT
//                			var sprite:IsoSprite = new IsoSprite();
//                			var img:Sprite = new Sprite();
//                			var img_bmp:DisplayObject = new Background();
//                			img_bmp.x = -3766/1;
//                			img_bmp.y = -42*2;
//                			img_bmp.scaleX = 2;
//                			img_bmp.scaleY = 2;
//                			img.addChild(img_bmp);
//                			sprite.sprites = [img];
//                			scene.addChild(sprite);
                		}
                		scene.render();
                		for (var i:int = 0; i < tile_sprites.length; i ++) {
                			trace("unlaying out tile sprite " + i);
                			IsoSprite(tile_sprites[i]).includeInLayout = false;
                			trace("include?" + tile_sprites[i].includeInLayout);
                		}
                }
                
                private function grid_mouseHandler (event:MouseEvent):void
                {
                	isMouseDown = true;
                	onMouseMove(event);
                }
                
                private function onMouseUp(event:MouseEvent):void {
                	isMouseDown = false;
                }
                
                private function gt_completeHandler (evt:Event):void
                {
                }
                private function onMouseMove(event:MouseEvent):void {
                	
                }
                
                private function followMouse():void {
                	if (isMouseDown) {
						var pt:Pt = new Pt(stage.mouseX - stage.stageWidth / 2 + view.currentX, stage.mouseY - stage.stageHeight / 2 + view.currentY);
						
						IsoMath.screenToIso(pt);
						destination = pt;
						
						clickTarget.x = pt.x;
						clickTarget.y = pt.y;
						
						var dx:Number = (pt.x - box.x);
						var dy:Number = (pt.y - box.y); 
						
						var angle:Number = Math.atan2(dy, dx);
						
						//scoot everything forward to make the math slightly easier
						angle += Math.PI / 8;
						while (angle < 0) angle += 2 * Math.PI;
						while (angle >= 2 * Math.PI) angle -= 2 * Math.PI;
						
						var row:int = 0;
						if (angle > 2 * Math.PI || angle < Math.PI / 4) row = 0;
						else row = int(angle / (Math.PI / 4));
						
						spriteSheet.y = -SPRITE_HEIGHT * row;
					}
                }
                
                
                private var unmovedX:Number = 0;
                private var unmovedY:Number = 0;
                
                private function enterFrameHandler (evt:Event):void
                {
                	if (isMouseDown) {
                		followMouse();
                	}
					if (destination) {
			        	var pt:Point = destination;
			        	
	                	var dx:Number = (pt.x - box.x);
						var dy:Number = (pt.y - box.y);
						
						if (Math.abs(dx) < 2) {
							dx = 0;
							box.x = pt.x;
						} 
						if (Math.abs(dy) < 2) {
							dy = 0;
							box.y = pt.y;
						}
						
						dx /= decelerationFactor;
						dy /= decelerationFactor;
						
						var dist = Math.sqrt( dx * dx + dy * dy );
						
						var maxSpeedRatio = dist / (maxSpeed / FPS);
						if (maxSpeedRatio > 1) {
							dx /= maxSpeedRatio;
							dy /= maxSpeedRatio;
							dist /= maxSpeedRatio;
						}
						
						unmovedX += dx;
						unmovedY += dy;
						
						if (dist == 0) {
							//close enough, come to rest
							
							box.x = pt.x;
							box.y = pt.y;
							
							//standing posture
							spriteSheet.x = 0;
						} 
						else {
							//isolib only wants to move by full pixels, so store
							//up the incremental moves until it's at least 1 in any direction
							box.x += int(unmovedX);
							box.y += int(unmovedY);
							
							distanceToNextFrame -= Math.sqrt(int(unmovedX) * int(unmovedX) + int(unmovedY) * int(unmovedY));
							
							unmovedX -= int(unmovedX);
							unmovedY -= int(unmovedY);
							
							if (distanceToNextFrame < 0) {
								distanceToNextFrame += distancePerFrame;
								spriteSheet.x -= SPRITE_WIDTH;
								if (spriteSheet.x <= - SPRITE_FRAMES * SPRITE_WIDTH) {
									spriteSheet.x = 0;
								} 
							}  
						}
						
						if (box.x >= g.gridSize[0] * g.width - box.width) box.x = g.gridSize[0] * g.width - box.width;
						else if (box.x < 0) box.x = 0;
						
						if (box.y >= g.gridSize[1] * g.length - box.length) box.y = g.gridSize[1] * g.length - box.length;
						else if (box.y < 0) box.y = 0;
						
                        view.centerOnIso(box);
					}
					
					//scene.render();
					foregroundScene.render();
                }
        }
}