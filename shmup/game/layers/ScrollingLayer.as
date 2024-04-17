package com.isartdigital.shmup.game.layers 
{
	import com.isartdigital.utils.Config;
	import com.isartdigital.utils.Monitor;
	import com.isartdigital.utils.game.GameObject;
	import com.isartdigital.utils.game.GameStage;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * Classe "Plan", chaque plan (y compris le GameLayer) est une instance de Layer ou d'une classe fille de Layer
	 * TODO: A part GameLayer, toutes les instances de ScrollingLayer contiennent 3 MovieClips dont il faut gérer le "clipping" afin de les faire s'enchainer correctement
	 * @author Mathieu ANTHOINE
	 */
	public class ScrollingLayer extends GameObject
	{
		protected var _screenLimits:Rectangle = new Rectangle();
		protected  var speedFactor:Number = 0.5;
		protected var target:DisplayObject;
		protected var children:Vector.<DisplayObject>;
		private const PART_WIDHT:int = 1220;
		
		public function ScrollingLayer() 
		{
			super();
			
			children = new Vector.<flash.display.DisplayObject>();
			for (var i:int = numChildren-1; i > -1; i--) 
			{
				children.push(getChildAt(i));
			}
			children.sort(sortAscendingX);
			
		}
		
		private static function sortAscendingX(pA:DisplayObject,pB:DisplayObject):int 
		{
			return pA.x - pB.x;
		}
		
		public function init(pSpeed:Number,pTarget:DisplayObject):void 
		{
			speedFactor = pSpeed;
			target = pTarget;
		}

		protected function updateScreenLimits ():void {
			var lTopLeft:Point     = new Point (0, 0);
			var lBottomRight:Point = new Point(Config.stage.stageWidth, Config.stage.stageHeight);
			
			lTopLeft     = globalToLocal(lTopLeft);
			lBottomRight = globalToLocal(lBottomRight);
			
			_screenLimits.setTo(lTopLeft.x, lTopLeft.y, lBottomRight.x - lTopLeft.x, lBottomRight.y - lTopLeft.y);
		}
		
		/**
		 * Retourne les coordonnées des 4 coins de l'écran dans le repère du plan de scroll concerné 
		 * Petite nuance: en Y, retourne la hauteur de la SAFE_ZONE, pas de l'écran, car on a choisi de condamner le reste de l'écran (voir cours Ergonomie Multi écran)
		 * @return Rectangle dont la position et les dimensions correspondant à la taille de l'écran dans le repère local
		 */
		public function get screenLimits ():Rectangle {
			return _screenLimits;
		}

		override protected function doActionNormal():void 
		{
			x = target.x * speedFactor;
			updateScreenLimits();
			
			if (children[0].x + PART_WIDHT < _screenLimits.left)
			{
				children[0].x=children[children.length - 1].x + PART_WIDHT;
				children.push(children.shift());
			}
			
		}
		
        
        override public function destroy():void 
        {
            super.destroy();
            _screenLimits = null;
        }
		
	}

}