package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.*;
	import flash.media.*;
	
	
	public class settingsScreen extends Screen
	{
		var soundtoggle:Boolean = true; 
		
		public function settingsScreen() 
		{
			Toggle.addEventListener(MouseEvent.CLICK, soundtoggler);
			Light.addEventListener(MouseEvent.CLICK, arenaselectlight);
			Dark.addEventListener(MouseEvent.CLICK, arenaselectdark);
			Back.addEventListener(MouseEvent.CLICK,back);
		}

		 /*Function which will play sound to show spaceship has been selected*/
			public function soundtoggler(event:MouseEvent):void {
					 if (soundtoggle == true){ 
					   SoundMixer.soundTransform = new SoundTransform(0); 
					   soundtoggle = false;
		  	  }
			        else { 
					SoundMixer.soundTransform = new SoundTransform(1); 
					soundtoggle = true;
			  }  
		 }
		 private function back(event:MouseEvent):void {
			this.parent.removeChild(this); //Removes the menu screen to save memory
			}
			
			private function arenaselectlight(event:MouseEvent):void {
				multiplayerManager.battlearena(true);
			}
			
			private function arenaselectdark(event:MouseEvent):void {
			multiplayerManager.battlearena(false);
			}
	}
	
}
