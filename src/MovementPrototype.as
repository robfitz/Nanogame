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
        import as3isolib.graphics.SolidColorFill;
        import as3isolib.graphics.Stroke;
        
        import com.gskinner.motion.GTween;
        
        import flash.display.Bitmap;
        import flash.display.BitmapData;
        import flash.display.Loader;
        import flash.display.MovieClip;
        import flash.display.Sprite;
        import flash.events.Event;
        import flash.events.MouseEvent;
        import flash.geom.Matrix;
        import flash.geom.Point;
        import flash.geom.Rectangle;
        import flash.net.URLLoader;
        import flash.net.URLRequest;
        import flash.text.TextField;
        import flash.utils.getTimer;
        
        import nano.CollisionLayer;
        import nano.Character;
        
        import net.pixelpracht.tmx.TmxLayer;
        import net.pixelpracht.tmx.TmxMap;
        import net.pixelpracht.tmx.TmxObject;
        import net.pixelpracht.tmx.TmxObjectGroup;
        import net.pixelpracht.tmx.TmxPropertySet;
        import net.pixelpracht.tmx.TmxTileSet;
        
        [SWF(width='760', height='570')]
		public class MovementPrototype extends Sprite
        {
        		private static const DEBUG_DRAW:Boolean = true;
        	
                private var scene:IsoScene;
				private var foregroundScene:IsoScene;
                private var g:IsoGrid;
                private var view:IsoView;
                
                private var clickTarget:IIsoDisplayObject;
                
                private var character:Character;
                
                private var isMouseDown:Boolean = false;
                
                private var playerSpawnPoint:Point = new Point(); 
                
                private static const FPS:int = 12;
                
                private var collisions:CollisionLayer = new CollisionLayer();
				
				// DEBUG STUFF
				private var fpsCounter:TextField;
				private var updates:int = 0;
				private var now:int = 0;
				private var then:int = 0;
				// end DEBUG STUFF
                
                private static const SPRITE_WIDTH:int = 64;
                private static const SPRITE_HEIGHT:int = 64;
                private static const SPRITE_FRAMES:int = 8;
                
//                [Embed(source="assets/Link_run.png")]
				[Embed(source="assets/avatar.swf")]
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
                		for each (var objectGroup:TmxObjectGroup in map.objectGroups) {
                			
	                		for each (var object:TmxObject in objectGroup.objects) {
	                			if ((objectGroup.properties && objectGroup.properties.hasOwnProperty("nowalk")) 
	                				|| (object.custom && object.custom.hasOwnProperty("nowalk"))) {
	                				
	                				Collisions.add(object);
	                				
	                				if (DEBUG_DRAW) {
		                				var collision_hull:IsoBox = new IsoBox();
					                    collision_hull.setSize(object.width, object.height, 3);
					                    collision_hull.moveTo(object.x, object.y, 0);
					                    var f:SolidColorFill = new SolidColorFill(0xffffff, 0.2);
					                    collision_hull.fills = [f, f, f, f, f, f];
					                    scene.addChild(collision_hull);
					                }
			                 	}
			                 	else if (object.custom && object.custom.hasOwnProperty("spawn")) {
			                 		if (object.custom["spawn"] == "player") {
			                 			playerSpawnPoint.x = object.x;
			                 			playerSpawnPoint.y = object.y;
			                 			
			                 			if (character) {
			                 				character.moveTo(playerSpawnPoint.x, playerSpawnPoint.y, 0);
			                 				if (view) view.centerOnIso(character);
			                 			}
			                 		}
	                			}
	                		}
	                	}
                	});
                	mapLoader.load(new URLRequest("./assets/isometric_grass_and_water.tmx"));
                	
                    scene = new IsoScene();
					foregroundScene = new IsoScene();
                    
                    this.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
                    stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
					now = flash.utils.getTimer();
                    
                    g = new IsoGrid();
                    g.gridlines = new Stroke(0, 0xCCCCCC, 0);
                    g.showOrigin = false;
                    g.setGridSize(119, 119);
                    stage.addEventListener(MouseEvent.MOUSE_DOWN, grid_mouseHandler);
                    stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
                    scene.addChild(g);
                    
                    Collisions.init(g);
                    
                    clickTarget = new IsoBox();
                    clickTarget.setSize(3, 3, 10);
                    scene.addChild(clickTarget);
                    
                    var img:* = new Link();
                    img.addEventListener(Event.COMPLETE, function(event:Event):void {
                    	trace("load complete");
                    	
                    });
					var sprite:* = new Character(100, 157, 16, 16, 64, img);
                                        
//                    var childs:* = sprite.getChildAt(0);
                    character = sprite;
                    foregroundScene.addChild(sprite);
                    sprite.moveTo(playerSpawnPoint.x, playerSpawnPoint.y, 0);
                    
                    if (DEBUG_DRAW) {
                    	var collision_hull:IsoBox = new IsoBox();
	                    collision_hull.setSize(sprite.width, sprite.length, 3);
//	                    collision_hull.moveTo(object.x, object.y, 0);
	                    var f:SolidColorFill = new SolidColorFill(0xffffff, 0.2);
	                    collision_hull.fills = [f, f, f, f, f, f];
	                    foregroundScene.addChild(collision_hull);
	                    addEventListener(Event.ENTER_FRAME, function(e:*):void {
	                    	collision_hull.moveTo(sprite.x, sprite.y, sprite.z);
	                    });
//	                    sprite.addChild(collision_hull);
                    }
                    
                    view = new IsoView();
                    view.clipContent = false;
                    view.y = 0;
                    view.setSize(stage.stageWidth, stage.stageHeight);
                    view.addScene(scene);
					view.addScene(foregroundScene);
                    addChild(view);
                    
                    scene.render();
					foregroundScene.render();
                 
                 	var gt:GTween = new GTween();
                 	
					// FPS Counter
					this.fpsCounter = new TextField();
					this.fpsCounter.x = 700;
					this.fpsCounter.y = 5;
					this.fpsCounter.text = "30";
					this.addChild(this.fpsCounter);
					this.updates = 0;
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
//                			IsoSprite(tile_sprites[i]).includeInLayout = false;
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
						character.walkTo(pt);
						
						clickTarget.x = pt.x;
						clickTarget.y = pt.y;
					}
                }
                
                
                private function enterFrameHandler (evt:Event):void
                {
					
					// update fps
					this.then = this.now;
					this.now = flash.utils.getTimer();
					if(this.updates == 10) {
						var fpsCalc:Number = 1000 / (this.now - this.then);
						this.fpsCounter.text= "FPS: " + fpsCalc;
						this.updates = 0;
					}
					this.updates ++;
					
                	if (isMouseDown) {
                		followMouse();
                	}
					
					
                    view.centerOnIso(character);
					foregroundScene.render();
                }
        }
}