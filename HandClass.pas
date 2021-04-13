 Unit HandClass;

 Interface
 Uses DiceClass,ListClass,MarketClass,WinGraph,WinMouse;
 Type
 tHand = object
 public
	constructor init(var market:tMarket);
	function getList():linkedList;
	function getShow():boolean;
	procedure setShow(show:boolean);
	procedure drawHand();
	procedure addToHand(dice:tDice);
	procedure remFromHand(dice:tDice);
	procedure setDrawn(drawn:boolean);
	function checkValid(desk:ptr;right:boolean):boolean;
 private
	list:linkedList;
	drawn:boolean;
	show:boolean;
	procedure setCoords();
 end;

 Implementation
	
	constructor tHand.init(var market:tMarket);
	var x,y:integer;
		dice:tDice;
		buffer:linkedList;
	begin
		x:=165;
		y:=getMaxY-100;
		while list.getSize() <= 6 do begin
			dice.init(Random(7),Random(7));
			if market.getList.getDice(dice).getFirst<>-1 then begin
				dice.setX(x);
				dice.setY(y);
				x:=x+trunc((getmaxX-200)/28);
				list.add(dice);
				buffer:=market.getList;
				buffer.rem(dice);
				market.setList(buffer);
				market.setLeft(market.getLeft-1);
			end;
		end;
		show:=false;
		drawn:=false;
	end;
	
	
	function tHand.getList():linkedList;
	begin
		getList:=list;
	end;
	
	function tHand.getShow():boolean;
	begin
		getShow:=show;
	end;
	
	procedure tHand.setShow(show:boolean);
	begin
		self.show:=show;
	end;
	
	procedure tHand.setCoords();
	var current:ptr;
		x:integer;
	begin
		current:=list.getList;
		x:=165;
		repeat
			current^.info.setX(x);
			current:=current^.next;
			x:=x+trunc((getmaxX-200)/28);
		until current = nil;
		current:=list.getList;
		setFillStyle(1,viridian);
		bar(x,current^.info.gety,x+current^.info.getWidth,current^.info.getY+current^.info.getHeight);
	end;
	
	procedure tHand.drawHand();
	var current:ptr;
		temp:ptr;
	begin
		setCoords;
		current:=list.getList;
		if not drawn then begin
			list.drawList(show);
			drawn:=true;
		end;
		if show then begin
			while current<>nil do begin
				if (getMouseX >= current^.info.getX) and (getMouseX <= current^.info.getX + current^.info.getWidth) and (getMouseY >= current^.info.getY) and (getMouseY <= current^.info.getY + current^.info.getHeight) then begin
					if not current^.info.getSelection then begin
						current^.info.setSelection(true);
						current^.info.drawDice(current^.info.getY-20);
					end else begin
						break;
					end;
				end else
					if current^.info.getSelection then begin
						current^.info.setSelection(false);
						current^.info.drawDice(current^.info.getY+20);
					end;
						current:=current^.next;
			end;
		end;
	end;
	
	procedure tHand.addToHand(dice:tDice);
	var current:ptr;
	begin
		current:=list.getList;
		while current^.next <> nil do begin
			current:=current^.next;
		end;
		dice.setX(current^.info.getX+trunc((getmaxX-200)/28));
		dice.setY(current^.info.getY);
		list.add(dice);
	end;
	
	procedure tHand.remFromHand(dice:tDice);
	begin
		list.rem(dice);
		setFillStyle(1,viridian);
		bar(dice.getX,dice.getY-20,dice.getX+dice.getWidth,dice.getY + dice.getHeight);
	end;
	
	procedure tHand.setDrawn(drawn:boolean);
	begin
		self.drawn:=drawn;
	end;
	
	function tHand.checkValid(desk:ptr;right:boolean):boolean;
	begin
		checkValid:=list.isValid(desk,right);
	end;
	
 begin

 end.
