package com.isartdigital.shmup.ui 
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Bounce;
	import com.isartdigital.shmup.game.GameManager;
	import com.isartdigital.shmup.game.sprites.Player;
	import com.isartdigital.shmup.ui.hud.Credits;
	import com.isartdigital.utils.sound.SoundManager;
	import com.isartdigital.utils.ui.UIPosition;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	/**
	 * Ecran de Victoire (Singleton)
	 * @author Mathieu ANTHOINE
	 */
	public class WinScreen extends EndScreen 
	{
		/**
		 * instance unique de la classe WinScreen
		 */
		protected static var instance: WinScreen;
		
		
		public function WinScreen() 
		{
			super();
			onResize();
		}
		override protected function init(pEvent:Event):void 
		{
			super.init(pEvent);
			TweenLite.from(this, 0.7, {scaleX: 0.1, scaleY: 0.1,ease:Bounce.easeOut})
			btnNext.addEventListener(MouseEvent.CLICK, onClickNext)
			SoundManager.getNewSoundFX("winJingle").loop();
			
		}
		
		private function onClickNext(pEvent:MouseEvent):void 
		{
			
			GameManager.destroyAll();
		
			destroy();
			UIManager.addScreen(TitleCard.getInstance());
			
		}
		
		override protected function onResize(pEvent:Event = null):void 
		{
			super.onResize(pEvent);
			UIManager.setPosition(mcBackground, UIPosition.FIT_SCREEN);
			
		}
		
		/**
		 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
		 * @return instance unique
		 */
		public static function getInstance (): WinScreen {
			if (instance == null) instance = new WinScreen();
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