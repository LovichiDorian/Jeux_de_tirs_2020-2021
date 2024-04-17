package com.isartdigital.shmup.ui.hud 
{
	import com.isartdigital.shmup.game.GameManager;
	import com.isartdigital.shmup.ui.TitleCard;
	import com.isartdigital.shmup.ui.UIManager;
	import com.isartdigital.utils.ui.Screen;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Dorian LOVICHI
	 */
	public class Credits extends Screen 
	{
		public var btnQuit:SimpleButton;
		/**
		 * instance unique de la classe Credits
		 */
		protected static var instance: Credits;

		/**
		 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
		 * @return instance unique
		 */
		public static function getInstance (): Credits {
			if (instance == null) instance = new Credits();
			return instance;
		}		
		override protected function init(pEvent:Event):void 
		{
			super.init(pEvent);
			btnQuit.addEventListener(MouseEvent.CLICK,onClickButton)
		}
		
		private function onClickButton(pEvent:MouseEvent):void 
		{
			UIManager.addScreen(TitleCard.getInstance());
		}
	
		public function Credits() 
		{
			super();
			
			if (instance!=null) trace ("Tentative de création d'un autre singleton.");
			else instance = this;

		}
		
		/**
		 * détruit l'instance unique et met sa référence interne à null
		 */
		override public function destroy (): void {
			instance = null;
		}

	}
}