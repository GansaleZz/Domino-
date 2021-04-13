Unit MainApplication;

Interface
	Uses WinGraph,TableClass,WinMouse,DiceClass;
	Type
	tGame = object
	public
		procedure startGame();
	end;
	
Implementation
	
	procedure tGame.startGame();
	var frame:tFrame;
		mouse_X,mouse_Y:integer;
		endOfGame:boolean;
		dice:tDice;
	begin
		frame.init();
		frame.drawMainFrame;
		endOfGame:=false;
		frame.drawDesk();
		repeat
			frame.drawButtons();
			if (getMouseButtons = mouseLeftButton) then 
				frame.drawDesk();
			if not frame.getMove then 
				frame.drawFirstHand()
			else frame.drawSecondHand();
			frame.drawEndScreen;
		until endOfGame;
	end;
	
begin

end.
