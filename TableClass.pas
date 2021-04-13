Unit TableClass;

Interface
Uses HandClass,MarketClass,WinGraph,WinMouse,ButtonClass,DiceClass,DeskClass,ListClass;	
Type
	tFrame = object
	public
		constructor init();
		procedure drawMainFrame();	
		function getButtExit():tButton;
		function getButtMaket():tButton;
		function getMarket():tMarket;
		function getFirstHand():tHand;
		function getSecondHand():tHand;
		function getDesk():tDesk;
		function getMove():boolean;
		procedure drawButtons();
		procedure drawFirstHand();
		procedure drawSecondHand();
		procedure drawDesk();
		procedure drawHeader();
		procedure drawEndScreen();
		procedure fish();
	private
		buttExit,buttMarket,buttRound,buttShow:tButton;
		firstHand,secondHand:tHand;
		market:tMarket;
		desk:tDesk;
		round:integer;
		move:boolean; //true - first players move, false - second players move
		endOfRound:boolean;
		function intToStr(x:integer):String;
	end;
	
	
Implementation
	
	constructor tFrame.init();
	var gd,gm:smallint;
	begin
		gd := d8bit; gm := mFullScr;
        InitGraph(gd, gm, '');
		buttExit.init(0,getmaxY-50,40,getMaxY-40,'Exit');
		buttMarket.init(getMaxX-135,getMaxY-50,getMaxX-100,getMaxY-40,'Market');
		buttRound.init(getMaxX-135,getMaxY-104,getMaxX-97,getMaxY-94,'Round');
		buttRound.setAvailable(false);
		buttMarket.setAvailable(false);
		buttShow.init(buttExit.getX,buttExit.getY-buttExit.getHeight-4,buttExit.getX+10,buttExit.getY-buttExit.getHeight+10,'Show hand');
		market.init();
		round:=2;
		firstHand.init(market);
		secondHand.init(market);
		move:=not desk.firstMove(firstHand,secondHand);
	end;
	
	function tFrame.intToStr(x:integer):String;
	var s:String;
	begin
		str(x,s);
		intToStr:=s;
	end;
	
	procedure tFrame.drawHeader();
	var str:String;
	begin
		setFillStyle(1,viridian);
		bar(getMaxX div 2 -50,1,getMaxX div 2 +100,25);
		setColor(black);
		setTextStyle(0,0,4);
		str:='Round '+intToStr(round);
		outTextXY(getMaxX div 2 -50,1,str);
		if round = 2 then begin
			if move then
				outTextXY(0,1,'First move by first player')
			else
				outTextXY(0,1,'First move by second player');
		end;
		if round >2 then begin
			bar(0,1,getMaxX div 2 -49,30);
		end;
		if move then begin
			bar(getMaxX div 2 +100,1,getMaxX,30);
			outTextXY(getMaxX-370,1,'Move by second player');
		end else begin
			bar(getMaxX div 2 +100,1,getMaxX,30);		
			outTextXY(getMaxX-370,1,'Move by first player');
		end;
	end;
	
	procedure tFrame.drawMainFrame();
	begin
		setFillStyle(1,viridian);
		bar(0,0,getmaxX,getmaxY);
		buttExit.drawButton(false);
		buttShow.drawButton(false);
		buttMarket.drawButton(false);
		buttRound.drawButton(false);
		drawHeader;
	end;

	procedure tFrame.fish();
	var firstCount,secondCount:integer;
		buttEx:tButton;
		active:boolean;
	begin
		firstCount:=firstHand.getList.count;
		secondCount:=secondHand.getList.count;
		setColor(white);
		setTextStyle(0,0,30);
		setFillStyle(1,black);
		active:=false;
		bar(0,0,getMaxX,getMaxY);
		if firstCount>secondCount then begin 
			outTextXY(getMaxX div 2 -175,getMaxY div 2,'Second player won!');
		end else if firstCount<secondCount then begin 
			outTextXY(getMaxX div 2 -175,getMaxY div 2,'First player won!');
		end else begin 
			outTextXY(getMaxX div 2 -100 ,getmaxY div 2,'Dead heat!');
		end;
		outTextXY(getMaxX div 2 -460,getMaxY div 2+40,'First player score: '+intToStr(firstCount));
		outTextXY(getMaxX div 2 +50,getMaxY div 2+40,'Second player score: '+intToStr(secondCount));
		buttEx.init(getMaxX div 2 -100 ,getmaxY div 2 +90,getMaxX div 2 -60,getmaxY div 2 +100,'Exit');
		repeat
			if buttEx.mouseCoords(getMouseX,getMouseY) then begin
				buttEx.activeButton();
				if (getMouseButtons = mouseLeftButton) then halt;
			end else begin
				buttEx.drawButton(false);
			end;
		until active;
	end;

	procedure tFrame.drawButtons();
	var dice:tDice;
	begin
		if buttExit.mouseCoords(getMouseX,getMouseY) then begin
			buttExit.activeButton();
			if (getMouseButtons = mouseLeftButton) then halt;
		end else begin
			buttExit.drawButton(false);
		end;
		if not endOfRound and not buttMarket.getAvailable() then begin
			if not firstHand.checkValid(desk.getList.getFirst,false) and not firstHand.checkValid(desk.getList.getLast,true)
			and not secondHand.checkValid(desk.getList.getFirst,false) and not secondHand.checkValid(desk.getList.getLast,true) and (market.getLeft<=0) then begin
				fish();
			end else begin
				if not move then begin
					if not firstHand.checkValid(desk.getList.getFirst,false) and not firstHand.checkValid(desk.getList.getLast,true) then begin
						if market.getLeft()>0 then begin
							buttMarket.setAvailable(true);
							buttMarket.setActive(true);
							buttMarket.drawButton(false);
						end else begin
							endOfRound:=true;
						end;
					end;
				end else begin
					if not secondHand.checkValid(desk.getList.getFirst,false) and not secondHand.checkValid(desk.getList.getLast,true) then begin
						if market.getLeft>0 then begin
							buttMarket.setAvailable(true);
							buttMarket.setActive(true);
							buttMarket.drawButton(false);
						end else begin
							endOfRound:=true;
						end;
					end;
				end;
			end;
		end;
		if buttMarket.mouseCoords(getMouseX,getMouseY) then begin
			if not move then begin
				if not firstHand.checkValid(desk.getList.getFirst,false) and not firstHand.checkValid(desk.getList.getLast,true) and buttMarket.getAvailable then begin
					buttMarket.activeButton();
					if (getMouseButtons = mouseLeftButton) and not endOfRound then begin
						while not firstHand.checkValid(desk.getList.getFirst,false) and not firstHand.checkValid(desk.getList.getLast,true) do begin 
							dice:=market.takeFromMarket();
							if dice.getFirst<>-1 then begin
								firstHand.addToHand(dice);
								firstHand.setDrawn(false);
							end;
						end;
					end;
				end else begin
					buttMarket.setAvailable(false);
					buttMarket.drawButton(false);
				end;
			end else begin
				if not secondHand.checkValid(desk.getList.getFirst,false) and not secondHand.checkValid(desk.getList.getLast,true) and buttMarket.getAvailable then begin
					buttMarket.activeButton();
					if (getMouseButtons = mouseLeftButton) and not endOfRound then begin
						while not secondHand.checkValid(desk.getList.getFirst,false) and not secondHand.checkValid(desk.getList.getLast,true) do begin
							dice:=market.takeFromMarket();
							if dice.getFirst<>-1 then begin
								secondHand.addToHand(dice);
								secondHand.setDrawn(false);
							end;
						end;
					end;
				end else begin
					buttMarket.setAvailable(false);
					buttMarket.drawButton(false);
				end;
			end
		end else begin
			buttMarket.drawButton(false);
		end;
		if buttShow.mouseCoords(getMouseX,getMouseY) and buttShow.getAvailable then begin
			buttShow.activeButton;
			if (getMouseButtons = mouseLeftButton) then begin
				if not move then begin
					if not firstHand.getShow then begin
						firstHand.setDrawn(false);
						firstHand.setShow(not firstHand.getShow);
					end;
				end else begin
					if not secondHand.getShow then begin
						secondHand.setDrawn(false);
						secondHand.setShow(not secondHand.getShow);
					end;
				end;
				buttShow.setAvailable(false);
			end;
		end else
			buttShow.drawButton(false);
		if endOfRound then begin
			if not buttRound.getAvailable then begin
				buttRound.setAvailable(true);
				buttRound.setActive(true);
				buttRound.drawButton(false);
			end;
			if buttRound.mouseCoords(getMouseX,getMouseY) then begin
				buttRound.activeButton();
				if (getMouseButtons = mouseLeftButton) then begin
					if move then begin
						firstHand.setShow(false);
						firstHand.setDrawn(false)
					end	else begin
						secondHand.setShow(false);
						secondHand.setDrawn(false);
					end;
					buttShow.setAvailable(true);
					buttShow.drawButton(true);
					move:=not move;
					endOfRound:=false;
					buttRound.setAvailable(false);
					inc(round);
					drawHeader();
					buttRound.setActive(true);
					buttRound.drawButton(true);
					setFillStyle(1,Viridian);
					bar(buttExit.getX+buttExit.getWidth+1,buttRound.getY,buttRound.getX-1,getMaxY);
				end;
			end else begin
				buttRound.drawButton(false);
			end;
		end;
	end;
	
	procedure tFrame.drawFirstHand();
	begin
		firstHand.drawHand();
	end;
	
	procedure tFrame.drawSecondHand();
	begin
		secondHand.drawHand();
	end;
	
	procedure tFrame.drawDesk();
	begin
		if not endOfRound then begin
			if (firstHand.getList.getSize >0) and (secondHand.getList.getSize>0)then begin
				if not move then begin
					endOfRound:= desk.tryPut(firstHand);
					if endOfRound then drawFirstHand;
				end else begin
					endOfRound:= desk.tryPut(secondHand);
					if endOfRound then drawSecondHand;
				end;
				desk.drawDesk();
			end;
		end;
	end;
	
	function tFrame.getButtExit():tButton;
	begin
		getButtExit:=buttExit;
	end;
	
	function tFrame.getButtMaket():tButton;
	begin
		getButtMaket:=buttMarket;
	end;
	
	function tFrame.getMove():boolean;
	begin
		getMove:=move;
	end;
	
	function tFrame.getFirstHand():tHand;
	begin
		getFirstHand:=firstHand;
	end;
	
	function tFrame.getSecondHand():tHand;
	begin
		getSecondHand:=secondHand;
	end;
	
	function tFrame.getMarket():tMarket;
	begin
		getMarket:=market;
	end;
	
	function tFrame.getDesk():tDesk;
	begin
		getDesk:=desk;
	end;
	
	procedure tFrame.drawEndScreen();
	var buttEx:tButton;
		active:boolean;
	begin
		if firstHand.getList.getSize =0 then begin
			setFillStyle(1,black);
			setColor(white);
			active:=false;
			bar(0,0,getMaxX,getMaxY);
			setTextStyle(0,0,30);
			outTextXY(getMaxX div 2 -175,getMaxY div 2,'First player won!');
			buttEx.init(getMaxX div 2 -100 ,getmaxY div 2 +90,getMaxX div 2 -60,getmaxY div 2 +100,'Exit');
			repeat
				if buttEx.mouseCoords(getMouseX,getMouseY) then begin
					buttEx.activeButton();
					if (getMouseButtons = mouseLeftButton) then halt;
				end else begin
					buttEx.drawButton(false);
				end;
			until active;
		end else if secondHand.getList.getSize = 0 then begin
			setFillStyle(1,black);
			setColor(white);
			active:=false;
			bar(0,0,getMaxX,getMaxY);
			setTextStyle(0,0,30);
			outTextXY(getMaxX div 2 -175,getMaxY div 2,'Second player won!');
			buttEx.init(getMaxX div 2 -100 ,getmaxY div 2 +90,getMaxX div 2 -60,getmaxY div 2 +100,'Exit');
			repeat
				if buttEx.mouseCoords(getMouseX,getMouseY) then begin
					buttEx.activeButton();
					if (getMouseButtons = mouseLeftButton) then halt;
				end else begin
					buttEx.drawButton(false);
				end;
			until active;
		end;
	end;
	
begin
	
end.
