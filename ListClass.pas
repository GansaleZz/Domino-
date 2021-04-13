 Unit ListClass;

 Interface
 Uses DiceClass,WinGraph;
 Type
 ptr = ^tList;
 tList = record
	next:ptr;
	info:tDice;
 end;

 linkedList = object
	public
		constructor init();
		function getSize():integer;
		function getList():ptr;
		procedure add(dice:tDice);
		procedure addFirst(dice:tDice);
		procedure rem(dice:tDice);
		function getDice(dice:tDice):tDice;
		function getMax():tDice;
		function getFirst():ptr;
		function getLast():ptr;
		function count():integer;
		procedure drawList(show:boolean);
		procedure drawList();
		function isValid(desk:ptr; right:boolean):boolean; // check list for valid dices to put it 
	private
		list,first,last : ptr;
		size : integer;
 end;

 Implementation
	
	constructor linkedList.init();
	begin
		size:=0;
		list:=nil;
	end;
	
	function linkedList.getSize():integer;
	begin
		getSize:=size;
	end;
	
	function linkedList.getList():ptr;
	begin
		getList:=list;
	end;
	
	procedure linkedList.add(dice:tDice);
	var firstel,cur:ptr;
	begin
		firstel:=list;
		new(cur);
		cur^.info:=dice;
		last:=cur;
		if list = nil then begin
			list:=cur;
			first:=cur;
			list^.next:=nil;
		end else begin
			while list^.next<>nil do begin
				list:=list^.next;
			end;
			list^.next:=cur;
			cur^.next:=nil;
		end;
		if firstel <> nil then
			list:=firstel;
		inc(size);
	end;
	
	procedure linkedList.addFirst(dice:tDice);
	var current:ptr;
	begin
		new(current);
		current^.next:=list;
		current^.info:=dice;
		list:=current;
		first:=list;
		inc(size);
	end;
	
	procedure linkedList.rem(dice:tDice);
	var firstel,del:ptr;
	begin
		if size>0 then begin
			firstel:=list;
			del:=nil;
			if(list^.info = dice) then begin
				del:=list;
				if list^.next <> nil then begin
					list:=list^.next;
					first:=list;
				end;
				dispose(del);
				dec(size);
			end
			else begin
				repeat
					if(list^.next^.info = dice) then begin
						del:=list^.next;
						break;
					end else
						list:=list^.next;
				until list^.next = nil;	
				if del<>nil then begin
					if (firstel <> nil) then begin
						list^.next:=list^.next^.next;
						last:=list;
						list:=firstel;
					end;
					dispose(del);
					dec(size);
				end;
			end;
		end;		
	end;
	
	function linkedList.getMax():tDice;
	var firstel:ptr;
		buffer:tDice;
	begin
		if size>0 then begin
			firstel:=list;
			buffer:=list^.info;
			list:=list^.next;
			while list<>nil do begin
				if list^.info > buffer then buffer:=list^.info;
				list:=list^.next;
			end;
			list:=firstel;
			getMax:=buffer;
		end else begin
			buffer.init(-1,-1);
			getMax:=buffer;
		end;
	end;
	
	function linkedList.getDice(dice:tDice):tDice;
	var firstel:ptr;
		buffer:tDice;
	begin
		if size >0 then begin
			firstel:=list;
			buffer.init(-1,-1);
			while list<>nil do begin
				if list^.info = dice then begin
					buffer:=list^.info;
					break;
				end;
				list:=list^.next;
			end;
			list:=firstel;
			getDice:=buffer;
		end else begin
			buffer.init(-1,-1);
			getDice:=buffer;
		end;
	end;
	
	procedure linkedList.drawList();
	var first_:ptr;
	begin
		if size >0 then begin
			first_:=list;
			while list<>nil do begin
				list^.info.drawDice();
				list:=list^.next;
			end;
			list:=first_;
		end;
	end;
	
	
	procedure linkedList.drawList(show:boolean);
	var first_:ptr;
	begin
		if size >0 then begin
			first_:=list;
			while list<>nil do begin
				if show then
					list^.info.drawDice()
				else
					list^.info.drawBar();
				list:=list^.next;
			end;
			list:=first_;
		end;
	end;
	
	function linkedList.getFirst():ptr;
	begin
		getFirst:=first;
	end;
	
	function linkedList.getLast():ptr;
	begin
		getLast:=last;
	end;
	
	function linkedList.isValid(desk:ptr; right:boolean):boolean;
	var first_:ptr;
	begin 
		if size>0 then begin 
			first_:= list;
			if 0<desk^.info.getY-100 then begin 
				while list<>nil do begin 
					if right then begin
						if not desk^.info.getRotOfDice then begin 
							if (list^.info.getFirst = desk^.info.getFirst) or (list^.info.getSecond = desk^.info.getFirst) then begin 
								isValid:=true;
								break;
							end;
						end else begin 
							if (list^.info.getFirst = desk^.info.getSecond) or (list^.info.getSecond = desk^.info.getSecond) then begin 
								isValid:=true;
								break;
							end; 
						end;
					end else begin
						if not desk^.info.getRotOfDice then begin 
							if (list^.info.getFirst = desk^.info.getFirst) or (list^.info.getSecond = desk^.info.getFirst) then begin 
								isValid:=true;
								break;
							end;
						end else begin 
							if (list^.info.getFirst = desk^.info.getFirst) or (list^.info.getSecond = desk^.info.getFirst) then begin 
								isValid:=true;
								break;
							end;
						end;
					end;
					list:=list^.next;
				end;
			end else begin 
				while list<>nil do begin
					if right then begin
						if not desk^.info.getRotOfDice then begin 
							if (list^.info.getFirst = desk^.info.getFirst) or (list^.info.getSecond = desk^.info.getFirst) then begin 
								isValid:=true;
								break;
							end;
						end else begin 
							if (list^.info.getFirst = desk^.info.getSecond) or (list^.info.getSecond = desk^.info.getSecond) then begin 
								isValid:=true;
								break;
							end; 
						end;
						if (list^.info.getFirst = desk^.info.getFirst) or (list^.info.getSecond = desk^.info.getFirst) then begin 
							isValid:=true;
							break;
						end 
					end else begin 
						if not desk^.info.getRotOfDice then begin 
							if (list^.info.getFirst = desk^.info.getFirst) or (list^.info.getSecond = desk^.info.getFirst) then begin 
								isValid:=true;
								break;
							end;
						end else begin 
							if (list^.info.getFirst = desk^.info.getFirst) or (list^.info.getSecond = desk^.info.getFirst) then begin 
								isValid:=true;
								break;
							end;
						end;
					end;
					list:=list^.next;
				end;
				
			end;
		end;
		if list = nil then isValid:=false;
		list:=first_;
	end;
	
	function linkedList.count():integer;
	var first_:ptr;
		buf:integer;
	begin 
		first_:=list;
		buf:=0;
		while list<>nil do begin 
			buf:=buf+list^.info.getFirst;
			buf:=buf+list^.info.getSecond;
			list:=list^.next;
		end;
		list:=first_;
		count:=buf;
	end;	
	
 begin

 end.
