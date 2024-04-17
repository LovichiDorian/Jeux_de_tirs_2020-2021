package com.isartdigital.shmup.ui.help 
{
	import com.isartdigital.shmup.controller.Controller;
	import com.isartdigital.shmup.game.GameManager;
	import com.isartdigital.shmup.game.layers.GameLayer;
	import com.isartdigital.shmup.game.sprites.Player;
	import com.isartdigital.shmup.game.sprites.enemies.Enemy1;
	import com.isartdigital.shmup.ui.hud.Hud;
	import com.isartdigital.utils.ui.Screen;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Dorian LOVICHI
	 */
	public class HelpSpecial extends Screen 
	{
		private var countFrame:int = 0;
		public var btnPlay:SimpleButton;
		/**
		 * instance unique de la classe HelpSpecial
		 */
		protected static var instance: HelpSpecial;

		/**
		 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
		 * @return instance unique
		 */
		public static function getInstance (): HelpSpecial {
			if (instance == null) instance = new HelpSpecial();
			return instance;
		}		
	
		public function HelpSpecial() 
		{
			super();
			addEventListener(Event.ENTER_FRAME, gameLoop);
			if (instance!=null) trace ("Tentative de création d'un autre singleton.");
			else instance = this;

		}
		private function gameLoop(pEvent:Event):void 
		{
			
			Player.getInstance().x += 5;
			if (countFrame++ >=60) 
			{
				
				Player.getInstance().alpha = 0.30;
			}
			
		}
		override protected function init(pEvent:Event):void 
		{
			btnPlay.addEventListener(MouseEvent.CLICK, onClickPlay)
			addChild(Player.getInstance());
		
		}
		
		private function onClickPlay(pEvent:MouseEvent):void 
		{
			Player.getInstance().x += 0;
			Player.getInstance().alpha = 1;
			Player.getInstance().destroy();
			this.destroy();
			
			GameManager.start();
			Hud.getInstance().mcTopCenter.visible = true;
			Hud.getInstance().mcTopLeft.visible = true;
			Hud.getInstance().mcTopRight.visible = true;
			Hud.getInstance().mcBottomRight.visible = true;
			
		}
		
		
		/**
		 * détruit l'instance unique et met sa référence interne à null
		 */
		override public function destroy (): void {
			instance = null;
			//removeEventListener(Event.EXIT_FRAME, gameLoop);
			removeEventListener(Event.ENTER_FRAME, gameLoop);
		}

	}
}