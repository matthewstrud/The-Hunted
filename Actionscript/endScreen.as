package  {
	
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.system.fscommand;
	
	
	public class endScreen extends MovieClip {
		
		public function endScreen() {
			this.Exit.addEventListener(MouseEvent.CLICK,exit);
			this.Spectate.addEventListener(MouseEvent.CLICK,spectate);
		}
			private function exit(event:MouseEvent):void {
					fscommand("quit");
			}
			
			private function spectate(event:MouseEvent):void {
				this.parent.removeChild(this); 
			}
	}	
}
