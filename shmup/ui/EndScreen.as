package com.isartdigital.shmup.ui 
{
	import com.isartdigital.utils.ui.Screen;
	import com.isartdigital.utils.ui.UIPosition;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	
	/**
	 * Classe mère des écrans de fin
	 * @author Mathieu ANTHOINE
	 */
	public class EndScreen extends Screen 
	{
		
		public var mcBackground:Sprite;
		public var mcScore:MovieClip;
		public var score:TextField;
		
		
		public var btnNext:SimpleButton;
	
		public function EndScreen() 
		{
			super();
			score = mcScore.txtScore;
		}
		override protected function onResize(pEvent:Event = null):void 
		{
			super.onResize(pEvent);
			UIManager.setPosition(mcBackground, UIPosition.FIT_SCREEN);
		}
	}
}