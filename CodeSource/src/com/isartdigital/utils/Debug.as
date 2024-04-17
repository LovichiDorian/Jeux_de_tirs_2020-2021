package com.isartdigital.utils 
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Chadi Husser
	 */
	public class Debug 
	{
		static private var graphics:Graphics;
		
		static public function init(pContainer:Sprite) : void {
			graphics = pContainer.graphics;
		}
		
		static public function clear() : void {
			graphics.clear();
		}
		
		static public function drawPoint(pPoint:Point) : void {
			graphics.beginFill(0xff0000);
			graphics.drawCircle(pPoint.x, pPoint.y, 5);
		}
		
		static public function drawSegment(pStart:Point, pEnd:Point, pColor:uint = 0xff0000) : void {
			graphics.lineStyle(3, pColor);
			graphics.moveTo(pStart.x, pStart.y);
			graphics.lineTo(pEnd.x, pEnd.y);
		}
		
		static public function drawVector(pOrigin:Point, pVector:Point, pColor:uint = 0xff0000) : void {
			var lEnd:Point = new Point(pOrigin.x + pVector.x, pOrigin.y + pVector.y);
			drawSegment(pOrigin, lEnd, pColor);
		}
	}

}