package  {
	
	import flash.display.MovieClip;
	import flash.events.*;
	
	
	
	public class menuScreen extends Screen 
	{
		private var p = null;		
		
		public function menuScreen() 
		{
			addEventListener(Event.ADDED_TO_STAGE, addedHandler);
			this.About.addEventListener(MouseEvent.CLICK,aboutscreen);
			this.Start.addEventListener(MouseEvent.CLICK,selectscreen);
			this.Settings.addEventListener(MouseEvent.CLICK,settingsscreen);
			//Start.addEventListener(MouseEvent.CLICK, start);
		}
		
		
		override public function update()
		{
			
		}
		
		public function addedHandler(e:Event)
		{
			p = this.parent;
		}
		
		/*public function start(e:Event)
		{
			p.mm();
		}*/
		/*Function checking if highscore button has been pressed based
	if so show highscore screen */
	
	private function aboutscreen(event:MouseEvent):void {
		var about:aboutScreen = new aboutScreen(); //New instance of highscore screen
			this.parent.addChild(about); //Adds the highscore screen
			}
			
			private function settingsscreen(event:MouseEvent):void {
		var settings:settingsScreen = new settingsScreen(); //New instance of highscore screen
			this.parent.addChild(settings); //Adds the highscore screen
			}
			
			private function selectscreen(event:MouseEvent):void {
		var select:selectScreen = new selectScreen(); //New instance of highscore screen
			this.parent.addChild(select); //Adds the highscore screen
			}

	}
	
}
