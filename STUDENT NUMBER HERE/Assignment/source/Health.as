package  {
	
	import flash.display.MovieClip;
	
	
	public class Health extends Screen {
		
		public static var healthframe :String = "Full";
		
		public function Health() {
			gotoAndStop(healthframe);
		}
		public static function changehealth(health:int):void {
			if (health == 2) {
			healthframe = "Half";
			}
			else if (health == 1) {
			healthframe = "Quarter";
			}
			else if (health == 0) {
			healthframe = "None";
			}
		}
		override public function update()
		{
			gotoAndStop(healthframe);
		}
	
	}
}