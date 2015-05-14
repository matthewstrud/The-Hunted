package  {
	
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.system.fscommand;
	
	
	public class endScreen extends MovieClip {
		
		private var p;
		
		public function endScreen(par : multiplayerManager, val:Boolean) {
			this.p = par;
			trace("END SCREEN: " + val);
			if (val)
			{
				this.str_mes.text = "You won, you had this many kills: " + p.getNumOfKills();
				removeChild(this.Spectate);
			}
			else
			{
				this.str_mes.text = "You lost, you had this many kills: " + p.getNumOfKills();
				this.Spectate.addEventListener(MouseEvent.CLICK, spectate);
			}
			this.Exit.addEventListener(MouseEvent.CLICK,exit);
			
		}
			private function exit(event:MouseEvent):void {
					fscommand("quit");
			}
			
			private function spectate(event:MouseEvent):void {
				p.setMovement(true);
				p.removeChild(this);
				//this.parent.removeChild(this); 
			}
	}	
}
