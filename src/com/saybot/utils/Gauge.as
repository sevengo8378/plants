package com.saybot.utils
{
	import flash.geom.Point;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	public class Gauge extends Sprite
	{
		private var mImage:Image;
		private var mRatio:Number;
		
		public function Gauge(texture:Texture)
		{
			mRatio = 1.0;
			mImage = new Image(texture);
			addChild(mImage);
		}
		
		private function update():void
		{
			mImage.scaleX = mRatio;
			mImage.setTexCoords(1, new Point(mRatio, 0.0));
			mImage.setTexCoords(3, new Point(mRatio, 1.0));
		}
		
		public function get ratio():Number { return mRatio; }
		public function set ratio(value:Number):void 
		{
			mRatio = Math.max(0.0, Math.min(1.0, value));
			update();
		}
	}
}