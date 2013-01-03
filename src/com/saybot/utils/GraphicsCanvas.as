package com.saybot.utils
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	import starling.display.Image;
	import starling.textures.Texture;
	
	public class GraphicsCanvas extends Image
	{
		private var _bmd:BitmapData;
		
		private var _canvas:Sprite;
		
		public function GraphicsCanvas(w:Number, h:Number)
		{
			_bmd = new BitmapData(w, h, true, 0);
			_canvas = new Sprite();
			_canvas.width = _bmd.width;
			_canvas.height = _bmd.height;
			super(refreshCanvas());
		}
		
		public function refreshCanvas(clear:Boolean=false):Texture {
//			if(this.texture)
//				this.texture.dispose();
			_bmd.draw(_canvas);
			var tex:Texture = Texture.fromBitmapData(_bmd, false, false); 
			if(this.texture) {
				this.texture = tex;
				return null;
			}
			return tex;
		}
		
		public function clear():void {
			_canvas.graphics.clear();
		}
		
		public function drawLine(fromX:Number, fromY:Number, toX:Number, toY:Number, color:uint, thickness:Number=1):void {
			_canvas.graphics.lineStyle(thickness, color);
			_canvas.graphics.moveTo(fromX, fromY);
			_canvas.graphics.lineTo(toX, toY);
		}
		
		public function fillRect(x:Number, y:Number, w:Number, h:Number, color:uint):void {
			_canvas.graphics.beginFill(color);
			_canvas.graphics.drawRect(x, y, w, h);
			_canvas.graphics.endFill();
		}
		
		public function drawRect(x:Number, y:Number, w:Number, h:Number, color:uint, thickness:Number=1):void {
			_canvas.graphics.lineStyle(thickness, color);
			_canvas.graphics.drawRect(x, y, w, h);
		}
		
		override public function dispose():void {
			_bmd.dispose();
			_canvas = null;
			super.dispose();
		}
		
	}
}