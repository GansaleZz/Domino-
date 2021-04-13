Unit MarketClass;

Interface
	Uses ListClass,Diceclass;
	
	Type
	tMarket = object
	public
		constructor init();
		function getList():linkedList;
		function getLeft():shortint;
		procedure setLeft(left:shortint);
		procedure setList(list:linkedList);
		function takeFromMarket():tDice;
	private
		left:shortint;
		list:linkedList;
	end;
	
Implementation
	
	constructor tMarket.init();
	var i,j:integer;
		dice:tDice;
	begin 
		left:=1;
		list.init();
		for i:=0 to 5 do begin 
			for j:=i to 6 do begin 
				dice.init(i,j);
				list.add(dice);
				inc(left);
			end;
		end;
		dice.init(6,6);
		list.add(dice);
	end;
	
	function tMarket.getList():linkedList;
	begin 
		getList:=list;
	end;
	
	function tMarket.getLeft():shortint;
	begin
		getLeft:=left;
	end;
	
	procedure tMarket.setLeft(left:shortint);
	begin 
		self.left:=left;
	end;
	
	procedure tMarket.setList(list:linkedList);
	begin 
		self.list:=list;
	end;
	
	function tMarket.takeFromMarket():tDice;
	var dice:tDice;
	begin 
		if left > 0 then begin
			repeat
				dice.init(random(7),random(7));
				dice:= list.getDice(dice);
			until dice.getFirst() <> -1 ;
			list.rem(dice);
			dec(left);
		end else dice.init(-1,-1);
		takeFromMarket:=dice;
	end;
	
begin 

end.