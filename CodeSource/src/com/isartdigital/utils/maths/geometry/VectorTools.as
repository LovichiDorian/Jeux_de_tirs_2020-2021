package com.isartdigital.utils.maths.geometry 
{
	import flash.geom.Point;
	/**
	 * ...
	 * @author Chadi Husser
	 */
	public class VectorTools 
	{
		
		public static function dotProduct(pA:Point, pB:Point) :Number {
			return pA.x * pB.x + pA.y * pB.y;
		}
		
		public static function moveToward(pCurrent:Point, pTarget:Point, pSpeed:Number) : Point {
			var lDirection:Point = pTarget.subtract(pCurrent);
			lDirection.normalize(pSpeed);
			
			return pCurrent.add(lDirection);
		}
	}

}