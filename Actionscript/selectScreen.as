package  {
	
	import flash.display.MovieClip;
	import flash.events.*;
	
	
	public class selectScreen extends Screen {
		
		private var p = null;
		
		public function selectScreen() {
			var a = Vishal.addEventListener(MouseEvent.CLICK, start1);
			Matt.addEventListener(MouseEvent.CLICK, start2);
			Karandeep.addEventListener(MouseEvent.CLICK, start3);
			Robin.addEventListener(MouseEvent.CLICK, start4);
			addEventListener(Event.ADDED_TO_STAGE, addedHandler);
		}
		
		public function start1(e:Event)
		{
			this.parent.removeChild(this); //Removes the menu screen to save memory
			Main.shipNum = 3;
			p.mm();
		}
		public function start2(e:Event)
		{
			this.parent.removeChild(this); //Removes the menu screen to save memory
			Main.shipNum = 2;
			p.mm();
		}
		public function start3(e:Event)
		{
			this.parent.removeChild(this); //Removes the menu screen to save memory
			Main.shipNum = 1;
			p.mm();
		}
		public function start4(e:Event)
		{
			this.parent.removeChild(this); //Removes the menu screen to save memory
			Main.shipNum = 4;
			p.mm();
		}
		public function addedHandler(e:Event)
		{
			p = this.parent;
		}
	}
	
}
