package com.saybot
{
    public class AssetEmbeds_1x
    {
        // Bitmaps
        
        [Embed(source = "/textures/1x/background_rotate.png")]
        public static const Background:Class;
		
		[Embed(source="/fonts/1x/desyrel.fnt", mimeType="application/octet-stream")]
		public static const DesyrelXml:Class;
		
		[Embed(source = "/fonts/1x/desyrel.png")]
		public static const DesyrelTexture:Class;
		
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