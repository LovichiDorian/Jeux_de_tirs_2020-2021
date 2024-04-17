package com.isartdigital.shmup.ui
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	import com.greensock.easing.Bounce;
	import com.isartdigital.shmup.ui.UIManager;
	import com.isartdigital.shmup.ui.hud.Credits;
	import com.isartdigital.utils.Monitor;
    import com.isartdigital.utils.sound.SoundFX;
	import com.isartdigital.utils.sound.SoundManager;
	import com.isartdigital.utils.ui.Screen;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * Ecran principal
	 * @author Mathieu ANTHOINE
	 */
	public class TitleCard extends Screen
	{
		
		/**
		 * instance unique de la classe TitleCard
		 */
		protected static var instance:TitleCard;
		
		public var btnPlay:SimpleButton;
		public var btnCredits:SimpleButton;
		
		public function TitleCard()
		{
			super();
		}
		
		/**
		 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
		 * @return instance unique
		 */
		public static function getInstance():TitleCard
		{
			if (instance == null) instance = new TitleCard();
			return instance;
		}
		
		override protected function init(pEvent:Event):void
		{
			super.init(pEvent);
			btnPlay.addEventListener(MouseEvent.CLICK, onClick);
			btnCredits.addEventListener(MouseEvent.CLICK, onCredits)
			SoundManager.getNewSoundFX("uiLoop").loop();
			TweenLite.from(this, 2, {scaleX: 2, scaleY: 2})
			TweenLite.from(btnPlay, 2, {x : btnPlay.x, y:btnCredits.y, ease:Bounce.easeOut})
			
		
		}
		
		private function onCredits(pEvent:MouseEvent):void 
		{
			UIManager.addScreen(Credits.getInstance());
		}
		
		protected function onClick(pEvent:MouseEvent):void
		{
			UIManager.addScreen(Help.getInstance());
			SoundManager.getNewSoundFX("click").start();
			
		}
		
		/**
		 * détruit l'instance unique et met sa référence interne à null
		 */
		override public function destroy():void
		{
			btnPlay.removeEventListener(MouseEvent.CLICK, onClick);
			instance = null;
			super.destroy();
		}
	
	}
}