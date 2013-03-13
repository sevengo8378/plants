package com.saybot
{
    
    import flash.display.Bitmap;
    import flash.media.Sound;
    import flash.utils.ByteArray;
    import flash.utils.Dictionary;
    
    import starling.text.BitmapFont;
    import starling.text.TextField;
    import starling.textures.Texture;
    import starling.textures.TextureAtlas;

    public class AssetsMgr
    {
        // If you're developing a game for the Flash Player / browser plugin, you can directly
        // embed all textures directly in this class. This demo, however, provides two sets of
        // textures for different resolutions. That's useful especially for mobile development,
        // where you have to support devices with different resolutions.
        //
        // For that reason, the actual embed statements are in separate files; one for each
        // set of textures. The correct set is chosen depending on the "contentScaleFactor".
        
        // TTF-Fonts
        
        // The 'embedAsCFF'-part IS REQUIRED!!!!
        [Embed(source="/fonts/Ubuntu-R.ttf", embedAsCFF="false", fontFamily="Ubuntu")]        
        private static const UbuntuRegular:Class;
		
        // Texture cache
        private static var sContentScaleFactor:int = 1;
        private static var sTextures:Dictionary = new Dictionary();
        private static var sSounds:Dictionary = new Dictionary();
        private static var sTextureAtlas:TextureAtlas;
        private static var sBitmapFontsLoaded:Boolean;
		
        public static function getTexture(name:String):Texture
        {
            if (sTextures[name] == undefined)
            {
                var data:Object = create(name);
                
                if (data is Bitmap)
                    sTextures[name] = Texture.fromBitmap(data as Bitmap, true, false, sContentScaleFactor);
                else if (data is ByteArray)
                    sTextures[name] = Texture.fromAtfData(data as ByteArray, sContentScaleFactor);
            }
            
            return sTextures[name];
        }
		
		public static function getTextureAtlas(textureName:String, xmlName:String):TextureAtlas
		{
			if (sTextureAtlas == null)
			{
				var texture:Texture = getTexture(textureName);
				var xml:XML = XML(create(xmlName));
				sTextureAtlas = new TextureAtlas(texture, xml);
			}
			
			return sTextureAtlas;
		}
		
		public static function prepareCommonSounds():void
		{
			sSounds[GameConst.SFX_CLICK] = create(GameConst.SFX_CLICK);
			sSounds[GameConst.SFX_EXPLODE] = create(GameConst.SFX_EXPLODE);
			sSounds[GameConst.SFX_PLANT_BITE] = create(GameConst.SFX_PLANT_BITE);
			sSounds[GameConst.SFX_SHOOT_HURT] = create(GameConst.SFX_SHOOT_HURT);
		}
		
		public static function loadSound(name:String):void {
			sSounds[name] = create(name);
		}
		
		public static function unloadSound(name:String):void {
			var snd:Sound = sSounds[name] as Sound;
			try {
				snd.close();
				delete sSounds[name];
			}catch(e:Error) {
				trace("Sound Error: "+name);
			}
		}
        
        public static function getSound(name:String):Sound
        {
            var sound:Sound = sSounds[name] as Sound;
            if (sound) return sound;
            else throw new ArgumentError("Sound not found: " + name);
        }
        
        public static function loadBitmapFonts():void
        {
            if (!sBitmapFontsLoaded)
            {
                var texture:Texture = getTexture("DesyrelTexture");
                var xml:XML = XML(create("DesyrelXml"));
                TextField.registerBitmapFont(new BitmapFont(texture, xml));
                sBitmapFontsLoaded = true;
            }
        }
		
		public static function getXML(xmlName:String):XML {
			return XML(create(xmlName));
		}
		
		public static function getSWF(name:String):* {
			return create(name);
		}
		
        private static function create(name:String):Object
        {
            var assetsClass:Class = sContentScaleFactor == 1 ? AssetEmbeds_1x : AssetEmbeds_2x;
            return new assetsClass[name];
        }
        
        public static function get contentScaleFactor():Number { return sContentScaleFactor; }
        public static function set contentScaleFactor(value:Number):void 
        {
            for each (var texture:Texture in sTextures)
                texture.dispose();
            
            sTextures = new Dictionary();
            sContentScaleFactor = value < 1.5 ? 1 : 2; // assets are available for factor 1 and 2 
        }
    }
}
