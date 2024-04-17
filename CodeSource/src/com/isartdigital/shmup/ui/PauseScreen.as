package com.isartdigital.shmup.ui 
{
	import com.isartdigital.shmup.game.GameManager;
	import com.isartdigital.shmup.ui.UIManager;
	import com.isartdigital.utils.Config;
	import com.isartdigital.utils.ui.Screen;
	import com.isartdigital.utils.ui.UIPosition;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Dorian LOVICHI
	 */
	public class PauseScreen extends Screen 
	{
		
		/**
		 * instance unique de la classe PauseScreen
		 */
		protected static var instance: PauseScreen;
		public var mcBackground:MovieClip;
		public var btnResume:SimpleButton;
		public var btnQuit:SimpleButton;
		public var isResume:Boolean = false;

		/**
		 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
		 * @return instance unique
		 */
		public static function getInstance (): PauseScreen {
			if (instance == null) instance = new PauseScreen();
			return instance;
		}		
	
		public function PauseScreen() 
		{
			super();
			
			if (instance!=null) trace ("Tentative de création d'un autre singleton.");
			else instance = this;

		}
		override protected function init(pEvent:Event):void 
		{
			btnResume.addEventListener(MouseEvent.CLICK, onClickResume)
			btnQuit.addEventListener(MouseEvent.CLICK, onClickQuit)
			
		}
		
		private function onClickQuit(pEvent:MouseEvent):void 
		{
			
			GameManager.destroyAll();
			UIManager.addScreen(TitleCard.getInstance());
			
		}
		
		private function onClickResume(pEvent:MouseEvent):void 
		{
			GameManager.resume();
			UIManager.closeScreens();
		}
		
		
		
		/**
		 * détruit l'instance unique et met sa référence interne à null
		 */
		override public function destroy (): void {
			instance = null;
		}

	}
}