package com.saybot.plants.view.entity
{
	import com.saybot.GameConst;
	import com.saybot.plants.vo.Entity;
	import com.saybot.utils.GraphicsCanvas;
	
	import dragonBones.Armature;
	import dragonBones.events.AnimationEvent;
	
	import starling.display.DisplayObject;
	
	public class SkeletonView extends EntityViewBase
	{
		protected var armature:Armature;
		
		public function SkeletonView(vo:Entity, armature:Armature)
		{
			this.armature = armature;
			this.display = armature.display as DisplayObject;
			super(vo);
			switchState(GameConst.ZOMBIE_IDLE);
			armature.addEventListener(AnimationEvent.MOVEMENT_CHANGE, armatureEventHandler);
			armature.addEventListener(AnimationEvent.START, armatureEventHandler);
			armature.addEventListener(AnimationEvent.COMPLETE, armatureEventHandler);
			armature.addEventListener(AnimationEvent.LOOP_COMPLETE, armatureEventHandler);
		}
		
		protected function armatureEventHandler(evt:AnimationEvent):void {
		}
		
		override public function advanceTime(time:Number):void {
			stateLastTime += time;
			armature.update();
			super.advanceTime(time);
		}
		
		override public function dispose():void {
			super.dispose();
			armature.removeEventListener(AnimationEvent.MOVEMENT_CHANGE, armatureEventHandler);
			armature.removeEventListener(AnimationEvent.START, armatureEventHandler);
			armature.removeEventListener(AnimationEvent.COMPLETE, armatureEventHandler);
			armature.removeEventListener(AnimationEvent.LOOP_COMPLETE, armatureEventHandler);
//			armature.dispose(); //can't disposs armature, other zombies use the same data
			armature = null;
		}
	}
}