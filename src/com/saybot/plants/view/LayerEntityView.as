package com.saybot.plants.view
{
	import com.saybot.plants.states.PlayfieldView;
	import com.saybot.plants.view.entity.EntityViewBase;
	
	public class LayerEntityView extends LayerViewBase
	{
		public function LayerEntityView(sceneView:PlayfieldView)
		{
			super(sceneView);
		}
		
		public function toggleDebugInfo(val:Boolean):void {
			for(var i:int=0; i<this.numChildren; i++) {
				var child:EntityViewBase = this.getChildAt(i) as EntityViewBase;
				if(child)
					child.toggleDebugInfo(val);
			}
		}
	}
}