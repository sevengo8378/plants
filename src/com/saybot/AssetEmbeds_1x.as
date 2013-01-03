package com.saybot
{
    public class AssetEmbeds_1x
    {
		// level config
		[Embed(source="/levels/level_config.xml", mimeType="application/octet-stream")]
		public static const LevelConfigXML:Class;
		
        // Bitmaps
        [Embed(source = "/textures/1x/splash.png")]
        public static const Background:Class;
		
		[Embed(source="/fonts/1x/desyrel.fnt", mimeType="application/octet-stream")]
		public static const DesyrelXml:Class;
		
		[Embed(source = "/fonts/1x/desyrel.png")]
		public static const DesyrelTexture:Class;
		
		[Embed(source = "/textures/1x/ui.png")]
		public static const UIPNG:Class;
		
		[Embed(source="/textures/1x/ui.xml", mimeType="application/octet-stream")]
		public static const UIXml:Class;
		
		// sounds
		[Embed(source="/audio/click.mp3")]
		public static const Click:Class;
		
		// skeleton
		[Embed(source = "/textures/1x/plants.swf", mimeType = "application/octet-stream")]
		public static const SkeletonPlants:Class;
		
		[Embed(source = "/textures/1x/zombie.swf", mimeType = "application/octet-stream")]
		public static const SkeletonZombie:Class;
        
    }
}