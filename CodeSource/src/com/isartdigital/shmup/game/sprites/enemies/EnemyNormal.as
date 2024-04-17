package com.isartdigital.shmup.game.sprites.enemies
{
	import com.isartdigital.shmup.game.layers.GameLayer;
	import com.isartdigital.shmup.game.sprites.Player;
	import com.isartdigital.shmup.game.sprites.ShotPlayer;
	import com.isartdigital.utils.game.CollisionManager;
	import com.isartdigital.utils.game.StateObject;
	import flash.display.StageQuality;
	
	/**
	 * ...
	 * @author Dorian LOVICHI
	 */
	public class EnemyNormal extends StateObject
	{
		public static var list:Vector.<EnemyNormal> = new Vector.<EnemyNormal>();
		public var EnemyIsTouched:Boolean = false;
		public var undergoesDamage:int = 0 * Player.getInstance().shotLevel;
		
		public function EnemyNormal()
		{
			list.push(this);
			
			super();
		
		}
		
		override public function destroy():void
		{
			super.destroy();
		}
	
	}
}

