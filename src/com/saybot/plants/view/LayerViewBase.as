package com.saybot.plants.view
{
	import com.saybot.plants.states.PlayfieldView;
	
	import starling.display.Sprite;
	
	public class LayerViewBase extends Sprite
	{
		protected var playfield:PlayfieldView;
		
		public function LayerViewBase(sceneView:PlayfieldView)
		{
			this.playfield = sceneView;
			super();
		}
	}
}