package  {
	
	import flash.display.MovieClip;
	import flash.media.SoundChannel;
	import flash.events.*;
	
	
	public class selectScreen extends Screen {
		
		private var p = null;
		var selected = new Laser2(); //New instance of the hit ground sound
		var channel:SoundChannel = new SoundChannel(); //New soundchannel to hold the track
		
		public function selectScreen() {
			Predator.addEventListener(MouseEvent.CLICK, start1);
			Aurora.addEventListener(MouseEvent.CLICK, start2);
			Firestorm.addEventListener(MouseEvent.CLICK, start3);
			Cyclone.addEventListener(MouseEvent.CLICK, start4);
			addEventListener(Event.ADDED_TO_STAGE, addedHandler);
		}
		
		public function start1(e:Event)
		{
			this.parent.removeChild(this); //Removes the screen to save memory
			this.playselect();
			Main.shipNum = 3;
			p.mm();
		}
		public function start2(e:Event)
		{
			this.parent.removeChild(this); //Removes the screen to save memory
			this.playselect();
			Main.shipNum = 2;
			p.mm();
		}
		public function start3(e:Event)
		{
			this.parent.removeChild(this); //Removes the screen to save memory
			this.playselect();
			Main.shipNum = 1;
			p.mm();
		}
		public function start4(e:Event)
		{
			this.parent.removeChild(this); //Removes the screen to save memory
			this.playselect();
			Main.shipNum = 4;
			p.mm();
		}
		public function addedHandler(e:Event)
		{
			p = this.parent;
		}
		/*Function which will play sound to show spaceship has been selected*/
		public function playselect():void {
				channel = selected.play(0,1);
		 }
	}
	
}
