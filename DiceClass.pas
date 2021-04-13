 {$mode objfpc}
 Unit DiceClass;
 Interface
	Uses WinGraph;
 Type
	tDice = object
	public
		constructor init(first,second:integer);
		function getFirst():integer;
		function getSecond():integer;
		function getX():integer;
		function getY():integer;
		function getHeight():integer;
		function getWidth():integer;
		function getRotOfDice():boolean;
		function getPosOfDice():boolean;
		function getSelection():boolean;
		procedure setFirst(first:integer);
		procedure setSecond(second:integer);
		procedure setX(x:integer);
		procedure setY(y:integer);
		procedure setRotOfDice(rotOfDice:boolean);
		procedure setPosOfDice(posOfDice:boolean);
		procedure setSelection(selection:boolean);
		procedure drawDice();
		procedure drawDice(newY:integer);
		procedure drawBar();
	private
		first,second:integer;
		x,y,height,width:integer;
		rotOfDice:boolean; //false - vertical, true - horizontal
		posOfDice:boolean; //false - down, true - up
		selection:boolean; //false - not selected, true - selected
		function intToStr(a:integer):string;
	end;
	
	
 operator >(dice1,dice2:tDice)res:boolean;
 operator =(dice1,dice2:tDice)res:boolean;
 operator <>(dice1,dice2:tDice)res:boolean;
 Implementation
	
	constructor tDice.init(first,second:integer);
	begin
		self.first:=first;
		self.second:=second;
		posOfDice:=false;
		rotOfDice:=false;
		selection:=false;
		height:=100;
		width:=trunc((getmaxX-250)/28);
	end;
	
	function tDice.getFirst():integer;
	begin
		getFirst:=first;
	end;
	
	function tDice.getSecond():integer;
	begin
		getSecond:=second;
	end;
	
	function tDice.getX():integer;
	begin
		getX:=x;
	end;
	
	function tDice.getY():integer;
	begin
		getY:=y;
	end;
	
	function tDice.getHeight():integer;
	begin
		getHeight:=height;
	end;
	
	function tDice.getWidth():integer;
	begin
		getWidth:=width;
	end;
	
	function tDice.getRotOfDice():boolean;
	begin
		getRotOfDice:=rotOfDice;
	end;
	
	function tDice.getPosOfDice():boolean;
	begin
		getPosOfDice:=posOfDice;
	end;
	
	function tDice.getSelection():boolean;
	begin	
		getSelection:=selection;
	end;
	
	procedure tDice.setX(x:integer);
	begin
		self.x:=x;
	end;
	
	procedure tDice.setY(y:integer);
	begin
		self.y:=y;
	end;
	
	procedure tDice.setRotOfDice(rotOfDice:boolean);
	begin
		self.rotOfDice:=rotOfDice;
	end;
	
	procedure tDice.setPosOfDice(posOfDice:boolean);
	begin
		self.posOfDice:=posOfDice;
	end;
	
	procedure tDice.setSelection(selection:boolean);
	begin
		self.selection:=selection;
	end;
	
	procedure tDice.setFirst(first:integer);
	begin 
		self.first:=first;
	end;
	
	procedure tDice.setSecond(second:integer);
	begin 
		self.second:=second;
	end;
	
	operator =(dice1,dice2:tDice)res:boolean;
	begin
		if (dice1.getFirst = dice2.getFirst) and (dice1.getSecond = dice2.getSecond)or ((dice1.getFirst = dice2.getSecond) and (dice1.getSecond = dice2.getFirst)) then
			res:=true
		else res:=false;
	end;
	
	operator >(dice1,dice2:tDice)res:boolean;
	begin
		if(dice2.getFirst <> dice2.getSecond) then begin
			if(dice1.getFirst = dice1.getSecond) then res:=true
			else if (dice1.getFirst+dice1.getSecond)>(dice2.getFirst+dice2.getSecond) then res:=true;
		end else
				if(dice1.getFirst = dice1.getSecond ) and ( dice1.getFirst>dice2.getFirst) then res:=true
				else res:=false;
	end;
	
	operator <>(dice1,dice2:tDice)res:boolean;
	begin
		if ((dice1.getFirst = dice2.getFirst) and (dice1.getSecond = dice2.getSecond))  then
			res:=false
		else res:=true;
	end;
	
	function tDice.intToStr(a:integer):string;
	begin 
		str(a,intToStr);
	end;
	
	procedure tDice.drawDice();
	var temp:integer;
	begin 
		if not rotOfDice then begin 
			setFillStyle(1,viridian);
			bar(x,y,x+width,y+height);
			setColor(black);
			rectangle(x,y,x+width,y+height);
			line(x,y+(height div 2),x+width,y+(height div 2));
			setTextStyle(0,0,4);
			outTextXY(x+12,y+10,intToStr(first));
			outTextXY(x+12,y+60,intToStr(second));
		end else begin 
			setFillStyle(1,viridian);
			bar(x,y,x+width,y+height);
			if height>width then begin 
				temp:=height;
				height:=width;
				width:=temp;
			end;
			setColor(black);
			rectangle(x,y,x+width,y+height);
			line(x+(width div 2),y,x+(width div 2),y+height);
			setTextStyle(0,0,4);
			outTextXY(x+14,y+5,intToStr(first));
			outTextXY(x+(width div 2)+16,y+5,intToStr(second));
		end;
	end;
	
	procedure tDice.drawDice(newY:integer);
	begin 
		setFillStyle(1,viridian);
		bar(x,y,x+width,y+height);
		setColor(black);
		setTextStyle(0,0,4);
		y:=newY;
		rectangle(x,y,x+width,y+height);
		if not rotOfDice then begin 
			line(x,y+(height div 2),x+width,y+(height div 2));
			outTextXY(x+12,y+10,intToStr(first));
			outTextXY(x+12,y+60,intToStr(second));
		end else begin 
			line(x+(width div 2),y,x+(width div 2),y+height);
			outTextXY(x+12,y+10,intToStr(first));
			outTextXY(x+width-12,y+10,intToStr(second));
		end;
	end;
	
	procedure tDice.drawBar();
	begin 
		setFillStyle(1,black);
		bar(x,y,x+width,y+height);
	end;
 begin

 end.
