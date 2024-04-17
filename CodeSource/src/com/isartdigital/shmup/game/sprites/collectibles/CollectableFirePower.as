package com.isartdigital.shmup.game.sprites.collectibles
{
	import com.isartdigital.shmup.game.layers.GameLayer;
	import com.isartdigital.shmup.game.sprites.Player;
	import com.isartdigital.utils.sound.SoundManager;
	
	/**
	 * ...
	 * @author Dorian LOVICHI
	 */
	public class CollectableFirePower extends Collectable
	{
		public static var list:Vector.<CollectableFirePower> = new Vector.<CollectableFirePower>();
		private var nbPower:int = 0;
		
		public function CollectableFirePower(pAsset:String)
		{
			
			assetName = pAsset;
			super();
		
		}
		override protected function doActionNormal():void 
		{
			comport();
		}
		protected function comport():void 
		{
			nbPower++;
			SoundManager.getNewSoundFX("powerupFirePower").start();
			Player.getInstance().shotLevel = nbPower;
			destroy();
		}
	
	}

}