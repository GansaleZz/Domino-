Unit ButtonClass;

Interface
Uses WinGraph,WinMouse;
Type
	tButton = object
	public
		constructor init(x,y:integer; name:string);
		constructor init(x,y,xText,yText:integer; name:string); 
		function getX():integer;
		function getY():integer;
		function getWidth():integer;
		function getHeight():integer;
		function getAvailable():boolean;
		function getXText():integer;
		function getYText():integer;
		procedure setWidth(width:integer);
		procedure setAvailable(available:boolean);
		procedure drawButton(bool:boolean);
		procedure activeButton();
		procedure setActive(active:boolean);
		function mouseCoords(x,y:integer):boolean;
		function getActive():boolean;
	private
		x,y,xText,yText:integer;
		name:string;
		active:boolean;
		available:boolean;
		width:integer;
		height:integer;
	end;
	
Implementation

	constructor tButton.init(x,y:integer;name:string);
	begin
		self.x:=x;
		self.y:=y;
		self.name:=name;
		active:=true;
		available:=true;
		width:=135;
		height:=50;
		xText:=x+25;
		yText:=y+height-45;
	end;
	
	constructor tButton.init(x,y,xText,yText:integer; name:string); 
	begin 
		self.x:=x;
		self.y:=y;
		self.name:=name;
		active:=true;
		available:=true;
		width:=135;
		height:=50;
		self.xText:=xText;
		self.yText:=yText;
	end;
	
	
	function tButton.getX():integer;
	begin
		getX:=x;
	end;
	
	function tButton.getY():integer;
	begin
		getY:=y;
	end;
	
	function tButton.getXText():integer;
	begin 
		getXText:=xText;
	end;
	
	function tButton.getYText():integer;
	begin 
		getYText:=yText;
	end;
	
	function tButton.getAvailable():boolean;
	begin
		getAvailable:=available;
	end;	
	
	procedure tButton.setAvailable(available:boolean);
	begin
		self.available:=available;
	end;
	
	procedure tButton.setWidth(width:integer);
	begin 
		self.width:=width;
	end;
	
	function tButton.mouseCoords(x,y:integer):boolean;
	begin
		if (x>=self.x) and (x<=self.x+width) and (y>=self.y) and ( y<=self.y+height) then
			mouseCoords:=true
		else
			mouseCoords:=false;
	end;

	procedure tButton.drawButton(bool:boolean);
	begin
		if (not mouseCoords(getMouseX,getMouseY) and active) or bool then begin
			setColor(black);
			rectangle(x,y,x+width,y+height);
			setTextStyle(0,0,3);
			if available then
				setFillStyle(1,teal)
			else setFillStyle(1,red);
			bar(x+1,y+1,x+width-1,y+height-1);
			outTextXY(xText,yText,name);
			active:=false;
		end;
	end;
	
	procedure tButton.activeButton();
	begin
		if mouseCoords(getMouseX,getMouseY) and not active then begin
			setColor(black);
			setTextStyle(0,0,3);
			setFillStyle(1,darkGray);
			rectangle(x,y,x+width,y+height);
			bar(x+1,y+1,x+width-1,y+height-1);
			setColor(white);
			outTextXY(xText,yText,name);
			active:=true;
		end;
	end;

	procedure tButton.setActive(active:boolean);
	begin
		self.active:=active;
	end;
	
	function tButton.getActive():boolean;
	begin
		getActive:=active;
	end;
	
	function tButton.getWidth():integer;
	begin
		getWidth:=width;
	end;
	
	function tButton.getHeight():integer;
	begin
		getHeight:=height;
	end;
	
begin

end.
