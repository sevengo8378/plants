package
{
	import com.saybot.AssetsMgr;
	import com.saybot.plants.StarlingMain;
	import com.saybot.ScreenDef;
	
	import flash.desktop.NativeApplication;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import starling.core.Starling;
	
	[SWF(width="480", height="320", frameRate="60", backgroundColor="#000000")]
	public class Plants extends Sprite
	{
		private var mStarling:Starling;
		
		public function Plants()
		{
			super();
			
			// 支持 autoOrient
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			Starling.multitouchEnabled = true; // useful on mobile devices
			Starling.handleLostContext = true; // required on Android
			
			
			// create a suitable viewport for the screen size
			var viewPort:Rectangle = new Rectangle();
			if (stage.fullScreenWidth / stage.fullScreenHeight > 1.5)
			{
				viewPort.height = stage.fullScreenHeight;
				viewPort.width  = int(viewPort.height * 1.5);
				viewPort.x = int((stage.fullScreenWidth - viewPort.width) / 2);
			}
			else
			{            
				viewPort.width = stage.fullScreenWidth; 
				viewPort.height = int(viewPort.width / 1.5);
				viewPort.y = int((stage.fullScreenHeight - viewPort.height) / 2);
			}
			
			// initialize Starling
			mStarling = new Starling(StarlingMain, stage, viewPort);
			Starling.current.stage.stageWidth  = ScreenDef.GameWidth;
			Starling.current.stage.stageHeight = ScreenDef.GameHeight;
			AssetsMgr.contentScaleFactor = Starling.current.contentScaleFactor;
			
			mStarling.simulateMultitouch  = false;
			mStarling.enableErrorChecking = false;
			mStarling.showStats = false;
			mStarling.start();
			// When the game becomes inactive, we pause Starling; otherwise, the enter frame event
			// would report a very long 'passedTime' when the app is reactivated. 
//			NativeApplication.nativeApplication.addEventListener(Event.ACTIVATE, 
//				function (e:Event):void { mStarling.start(); });
//			NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE, 
//				function (e:Event):void { mStarling.stop(); });
		}
	}
}