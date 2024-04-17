package com.isartdigital.shmup.ui 
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Sine;
	import com.isartdigital.shmup.game.GameManager;
	import com.isartdigital.shmup.game.sprites.Player;
	import com.isartdigital.shmup.ui.hud.Hud;
	import com.isartdigital.utils.sound.SoundManager;
	import com.isartdigital.utils.ui.UIPosition;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	/**
	 * Classe Game OVer (Singleton)
	 * @author Mathieu ANTHOINE
	 */
	public class GameOver extends EndScreen 
	{
		/**
		 * instance unique de la classe GameOver
		 */
		protected static var instance: GameOver;
		
		//public var btnNext:SimpleButton;
		public var btnRetry:SimpleButton;
		
		public function GameOver() 
		{
			super();
			onResize();
		}
		override protected function onResize(pEvent:Event = null):void 
		{
			super.onResize(pEvent);
			UIManager.setPosition(mcBackground, UIPosition.FIT_SCREEN);
		}
		override protected function init(pEvent:Event):void 
		{
			Hud.getInstance().mcTopCenter.visible = false;
			Hud.getInstance().mcTopLeft.visible = false;
			Hud.getInstance().mcTopRight.visible = false;
			Hud.getInstance().mcBottomRight.visible = false;
			btnNext.addEventListener(MouseEvent.CLICK, onClickNext)
			btnRetry.addEventListener(MouseEvent.CLICK, onClickRetry)
			TweenLite.from(this, 3, {scaleX: 0.1, scaleY: 0.1,ease:Sine.easeOut})
		}
		
		private function onClickRetry(pEvent:MouseEvent):void 
		{
			Hud.getInstance().mcTopCenter.visible = true;
			Hud.getInstance().mcTopLeft.visible = true;
			Hud.getInstance().mcTopRight.visible = true;
			Hud.getInstance().mcBottomRight.visible = true;
			GameManager.destroyAll();
			Player.getInstance().nbBomb = 2;
			Player.getInstance().life = 4;
			GameManager.start();
		}
		
		private function onClickNext(pEvent:MouseEvent):void 
		{
			
			GameManager.destroyAll();
			Player.getInstance().life = 4;
			UIManager.addScreen(TitleCard.getInstance());
		}
		/**
		 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
		 * @return instance unique
		 */
		public static function getInstance (): GameOver {
			if (instance == null) instance = new GameOver();
			return instance;
		}
		
		/**
		 * détruit l'instance unique et met sa référence interne à null
		*/
		override public function destroy (): void {
			instance = null;
			super.destroy();
		}
		
	}

}