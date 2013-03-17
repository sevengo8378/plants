package com.saybot
{
	public class AssetEmbeds_2x
	{
		// level config
		[Embed(source="/levels/level_config.xml", mimeType="application/octet-stream")]
		public static const LevelConfigXML:Class;
		
		// Bitmaps
		[Embed(source = "/textures/2x/splash.png")]
		public static const Splash:Class;
		
		[Embed(source = "/textures/2x/playfield.png")]
		public static const PlayField:Class;
		
		[Embed(source="/fonts/2x/desyrel.fnt", mimeType="application/octet-stream")]
		public static const DesyrelXml:Class;
		
		[Embed(source = "/fonts/2x/desyrel.png")]
		public static const DesyrelTexture:Class;
		
		[Embed(source = "/textures/2x/ui.png")]
		public static const UIPNG:Class;
		
		[Embed(source="/textures/2x/ui.xml", mimeType="application/octet-stream")]
		public static const UIXml:Class;
		
		
		// sounds
		[Embed(source="/audio/click.mp3")]
		public static const SFX_CLICK:Class;
		
		[Embed(source="/audio/explode.mp3")]
		public static const SFX_EXPLODE:Class;
		
		[Embed(source="/audio/plant_bite.mp3")]
		public static const SFX_PLANT_BITE:Class;
		
		[Embed(source="/audio/shoot_hurt.mp3")]
		public static const SFX_SHOOT_HURT:Class;
		
		[Embed(source="/audio/zombie_eat.mp3")]
		public static const SFX_ZOMBIE_EAT:Class;
		
		[Embed(source="/music/crazydave.mp3")]
		public static const crazydave:Class;
		
		// skeleton
		[Embed(source = "/textures/2x/plants.swf", mimeType = "application/octet-stream")]
		public static const SkeletonPlants:Class;
		
		[Embed(source = "/textures/2x/zombie.swf", mimeType = "application/octet-stream")]
		public static const SkeletonZombie:Class;
		
		// particle
		[Embed(source="/textures/2x/explode.pex", mimeType="application/octet-stream")]
		public static const EXPLODE_XML:Class;
		[Embed(source="/textures/2x/explode.png")]
		public static const EXPLODE_PNG:Class;
	}
}