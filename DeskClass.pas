Unit DeskClass;

Interface
Uses DiceClass,HandClass,ListClass,WinGraph,WinMouse;

Type
	tDesk = object
	public
		function firstMove(var firstHand,secondHand:tHand):boolean;
		procedure drawDesk();
		function getStep():integer;
		function getList():linkedList;
		function tryPut(var hand:tHand):boolean;
	private
		list:linkedList;
		step:integer;
		constructor init();
		function checkValidLeft(var dice:tDice):boolean;
		function checkValidLeftUp(var dice:tDice):boolean;
		function checkValidRight(var dice:tDice):boolean;
		function checkValidRightUp(var dice:tDice):boolean;
	end;
	
Implementation
	
	constructor tDesk.init();
	begin
		list.init();
	end;
	
	function tDesk.firstMove(var firstHand,secondHand:tHand):boolean;
	var dice:tDice;
	begin
		init();
		dice:=firstHand.getList.getMax();
		if secondHand.getList.getMax() > dice then begin
			dice:=secondHand.getList.getMax();
			secondHand.remFromHand(dice);
			firstMove:=true;
		end else begin
			firstHand.remFromHand(dice);
			firstMove:=false;
		end;
		dice.setX((getMaxX div 2)-60);
		dice.setY(getMaxY - 250);
		dice.setRotOfDice(true);
		list.add(dice);
		step:=0;
	end;
	
	procedure tDesk.drawDesk();
	begin
		if step < list.getSize then begin
			list.drawList();
			inc(step);
		end;
	end;
	
	function tDesk.getStep():integer;
	begin
		getStep:=step;
	end;
	
	function tDesk.checkValidLeft(var dice:tDice):boolean;
	var first:ptr;
		buf:integer;
	begin
		first:=list.getFirst;
		if (first^.info.getFirst = dice.getFirst) then begin
			buf:=dice.getFirst;
			dice.setFirst(dice.getSecond);
			dice.setSecond(buf);
			checkValidLeft:=true;
		end else if (first^.info.getFirst = dice.getSecond) then checkValidLeft:=true
		else checkValidLeft:=false;
	end;
	
	function tDesk.checkValidLeftUp(var dice:tDice):boolean;
	var first:ptr;
		buf:integer;
	begin
		first:=list.getFirst;
		if (0 >= first^.info.getY-dice.getHeight) and ( getMaxX>=first^.info.getX+dice.getWidth) then begin
			if not first^.info.getRotOfDice then begin
				if first^.info.getFirst = dice.getFirst then
					checkValidLeftUp:=true
				else if first^.info.getFirst = dice.getSecond then begin
					buf:=dice.getFirst;
					dice.setFirst(dice.getSecond);
					dice.setSecond(buf);
					checkValidLeftUp:=true;
				end
				else checkValidLeftUp:=false;
			end
			else begin
				if first^.info.getSecond = dice.getFirst then
					checkValidLeftUp:=true
				else if first^.info.getSecond = dice.getSecond then begin
					buf:=dice.getFirst;
					dice.setFirst(dice.getSecond);
					dice.setSecond(buf);
					checkValidLeftUp:=true;
				end
				else checkValidLeftUp:=false;
			end;
		end else checkValidLeftUp:=false;
	end;
	
	function tDesk.checkValidRight(var dice:tDice):boolean;
	var last:ptr;
		buf:integer;
	begin
		last:=list.getLast;
		if  last^.info.getRotOfDice then begin
			if (last^.info.getSecond = dice.getFirst) then checkValidRight:=true
			else if  (last^.info.getSecond = dice.getSecond) then begin
				buf:=dice.getFirst;
				dice.setFirst(dice.getSecond);
				dice.setSecond(buf);
				checkValidRight:=true
			end
			else checkValidRight:=false;
		end else begin
			if (last^.info.getFirst = dice.getFirst) then begin
				buf:=dice.getFirst;
				dice.setFirst(dice.getSecond);
				dice.setSecond(buf);
				checkValidRight:=true
			end
			else if  (last^.info.getFirst = dice.getSecond) then
				checkValidRight:=true
			else checkValidRight:=false;
		end;
	end;
	
	function tDesk.checkValidRightUp(var dice:tDice):boolean;
	var last:ptr;
		buf:integer;
	begin
		last:=list.getLast;
		if (0 >= last^.info.getY-dice.getHeight) and ( 0<=last^.info.getX-dice.getWidth) then begin
			if not last^.info.getRotOfDice then begin
				if last^.info.getFirst = dice.getSecond then
					checkValidRightUp:=true
				else if last^.info.getFirst = dice.getFirst then begin
					buf:=dice.getFirst;
					dice.setFirst(dice.getSecond);
					dice.setSecond(buf);
					checkValidRightUp:=true;
				end
				else checkValidRightUp:=false;
			end
			else begin
				if last^.info.getFirst = dice.getSecond then
					checkValidRightUp:=true
				else if last^.info.getFirst = dice.getFirst then begin
					buf:=dice.getFirst;
					dice.setFirst(dice.getSecond);
					dice.setSecond(buf);
					checkValidRightUp:=true;
				end
				else checkValidRightUp:=false;
			end;
		end;
	end;
	
	function tDesk.tryPut(var hand:tHand):boolean;
	var current:ptr;
		handList:ptr;
		dice:tDice;
		buf:integer;
	begin
		current:=nil;
		handList:=hand.getList.getList;
        current:=list.getFirst;
		dice.init(-1,-1);
		while handList<>nil do begin
			if handList^.info.getSelection then begin
				dice:=handList^.info;
				break;
			end else handList:=handList^.next;
		end;
		if checkValidLeftUp(dice)and (list.getFirst^.info.getY - dice.getHeight-2<0) then begin
			current:=list.getFirst;
			hand.remFromHand(dice);
			dice.setX(current^.info.getX+current^.info.getWidth+2);
			dice.setY(current^.info.getY);
			dice.setRotOfDice(true);
			list.addFirst(dice);
			tryPut:=true;
		end else
		if checkValidLeft(dice) and (list.getFirst^.info.getY - dice.getHeight-2>0) then begin
			current:=list.getFirst;
			hand.remFromHand(dice);
			if current^.info.getRotOfDice then begin
				if current^.info.getX-dice.getHeight-2 >= 1 then begin
					dice.setX(current^.info.getX-dice.getHeight-2);
					dice.setY(current^.info.getY);
					dice.setRotOfDice(true);
				end else begin
					dice.setX(current^.info.getX);
					dice.setY(current^.info.getY-current^.info.getWidth-2);
				end;
			end else  begin
				if current^.info.getY-current^.info.getHeight >= 1 then begin
					dice.setX(current^.info.getX);
					dice.setY(current^.info.getY-current^.info.getHeight-2);
				end else begin
					dice.setX(current^.info.getX+current^.info.getWidth+2);
					dice.setY(current^.info.getY);
					dice.setRotOfDice(true);
				end;
			end;
			list.addFirst(dice);
			tryPut:=true
		end else if checkValidRightUp(dice) and (list.getLast^.info.getY - dice.getHeight-2<0) then begin
			current:=list.getLast;
			hand.remFromHand(dice);
			if not current^.info.getRotOfDice then begin
				dice.setX(current^.info.getX-current^.info.getHeight-2);
				dice.setY(current^.info.getY);
			end else begin
				dice.setX(current^.info.getX-current^.info.getWidth-2);
				dice.setY(current^.info.getY);
			end;
			dice.setRotOfDice(true);
			list.add(dice);
			tryPut:=true;
		end
		else if checkValidRight(dice) and (list.getLast^.info.getY - dice.getHeight-2>0) then begin
			current:=list.getLast;
			hand.remFromHand(dice);
			if current^.info.getRotOfDice then begin
				if current^.info.getX+2*dice.getHeight+2 <= getMaxX-2 then begin
					dice.setX(current^.info.getX+dice.getHeight+2);
					dice.setY(current^.info.getY);
					dice.setRotOfDice(true);
				end else begin
					buf:=dice.getFirst;
					dice.setFirst(dice.getSecond);
					dice.setSecond(buf);
					dice.setX(current^.info.getX+dice.getHeight-dice.getWidth);
					dice.setY(current^.info.getY - current^.info.getWidth-2);
				end;	
			end else begin
				if current^.info.getY-current^.info.getHeight >= 1 then begin
					dice.setX(current^.info.getX);
					dice.setY(current^.info.getY-current^.info.getHeight-2);
				end else begin
					dice.setX(current^.info.getX-current^.info.getWidth-2);
					dice.setY(current^.info.getY);
					dice.setRotOfDice(true);
				end;
			end;
			list.add(dice);
			tryPut:=true;
		end else
		tryPut:=false;
	end;
	
	function tDesk.getList():linkedList;
	begin 
		getList:=list;
	end;
	
begin

end.
