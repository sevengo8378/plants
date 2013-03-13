package com.saybot.utils
{
	import com.saybot.AssetsMgr;
	
	import starling.extensions.PDParticleSystem;
	import starling.textures.Texture;

	public class ParticleBuilder
	{
		public function ParticleBuilder()
		{
		}
		
		public static function build(xmlName:String, png:String):PDParticleSystem {
			var xml:XML = AssetsMgr.getXML(xmlName);
			var texture:Texture = AssetsMgr.getTexture(png);
			return new PDParticleSystem(xml, texture);
		}
	}
}