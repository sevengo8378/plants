package com.saybot.plants.vo
{
	import flash.utils.getDefinitionByName;

	public class ValueObjectBase
	{
		protected var _properties:Object;
		
		public var class_name:String;
		
		public function ValueObjectBase(data:Object=null)
		{
			if(data != null)
				initProperties(data);
		}
		
		private function initProperties(properties:Object):void {
			var val:*;
			var valtype:String;
			_properties = properties;
			for(var p:String in properties) {
				if(this.hasOwnProperty(p)) {
					val = properties[p];
					valtype = typeof val;
					if(valtype == "string" && (val as String).indexOf(",")>=0) {
						val = (val as String).split(",");
					} else if(val is Array) {
						for(var i:int=0; i<(val as Array).length; i++) {
							val[i] = translateObject2VO(val[i]);
						}
					} else if(valtype == "object") {
						val = translateObject2VO(val);
					}
					try {
						this[p] = val;
					} catch(e:Error) {
						this[p] = [val];
					}
				}
			}
		}
		
		private var importCls:Array = [PtyLevel, PtyZombie, PtyRound, ZombieInstance, PtyPlant, PtyBullet];
		public static function translateObject2VO(obj:Object):Object {
			if(obj == null)
				return null;
			if(!obj.hasOwnProperty("class_name"))
				return obj;
			var clsName:String = "com.saybot.plants.vo."+obj["class_name"];
			var cls:Class;
			try {
				cls = getDefinitionByName(clsName) as Class;
			}
			catch(e:Error) {
			}
			return cls ? new cls(obj) : obj;
		}
		
//		public function clone():ValueObjectBase {
//			var myClass:Class = Object(this).constructor() as Class;
//			return new myClass(ObjectUtil.copy(this._properties));
//		}
		public function get properties():Object {
			return _properties;
		}
	}
}
