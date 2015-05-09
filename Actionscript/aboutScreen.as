package  {
	
	import flash.display.MovieClip;
	import flash.events.*;
	
	
	public class aboutScreen extends MovieClip {
		
		
		public function aboutScreen() {
			this.Back.addEventListener(MouseEvent.CLICK,back);
		}
		
		private function back(event:MouseEvent):void {
			this.parent.removeChild(this); //Removes the menu screen to save memory
			}
	}
	
}
