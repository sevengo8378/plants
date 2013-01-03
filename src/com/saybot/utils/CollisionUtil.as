package com.saybot.utils
{
	import flash.geom.Rectangle;

	public class CollisionUtil
	{
		public function CollisionUtil()
		{
		}
		
		public static function checkCol(rect1:Rectangle, rect2:Rectangle):Boolean {
			if((rect1.left < rect2.left && rect1.right <= rect2.left)
				|| (rect2.left < rect1.left && rect2.right <= rect1.left)
				|| (rect1.top < rect2.top && rect1.bottom <= rect2.top)
				|| (rect2.top < rect1.top && rect2.bottom <= rect1.top)
			)
				return false;
			return true;
		}
	}
}