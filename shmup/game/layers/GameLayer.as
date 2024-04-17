package com.isartdigital.shmup.game.layers 
{
	import com.isartdigital.shmup.game.levelDesign.GameObjectGenerator;
	import com.isartdigital.shmup.game.sprites.Player;
	import com.isartdigital.utils.Monitor;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.getDefinitionByName;
	//import com.isartdigital.utils.Debug;
	
	/**
	 * Classe "plan de jeu", elle contient tous les éléments du jeu, Generateurs, Player, Ennemis, shots...
	 * @author Mathieu ANTHOINE
	 */
	public class GameLayer extends ScrollingLayer 
	{
		protected  var _speed:int = 8;
		
		/**
		 * instance unique de la classe GameLayer
		 */
		protected static var instance: GameLayer;

		public function GameLayer() 
		{
			super();
			
				Monitor.getInstance().addSlideBar("GameLayer speed", 0, 40, 5, 0.5, onWeaponSliderUpdated);
				
		}
		private function onWeaponSliderUpdated(pEvent:Event):void
        {
            _speed = pEvent.target.value;
        }
		
		
		/**s
		 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
		 * @return instance unique
		 */
		public static function getInstance (): GameLayer {
			if (instance == null) instance = new GameLayer();
			return instance;
		}
		
		override protected function doActionNormal():void 
		{
			
			x -= speed;
			updateScreenLimits();
			
			if (children.length)
				if (children[0].x <= screenLimits.bottomRight.x+200) 
				{
				GameObjectGenerator(children[0]).generate();
				children.shift();
				}
			
		}

		/**
		 * détruit l'instance unique et met sa référence interne à null
		 */
		 public function get speed():int 
		 {
			 return _speed;
		 }
		 
		override public function destroy (): void {
			instance = null;
			super.destroy();
		}

	}
}