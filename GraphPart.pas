Unit GraphPart;

Interface
	Uses Domino,WinGraph,WinMouse;


	Type
	GraphWin = object
	public
		Procedure InitGr();
		Procedure MakeTable(a:Game);
		Procedure Hands(Hand:ptr; x,y:integer);
        Procedure Dice(x,y:integer);
		Procedure WorkWithButtonEsc();
		Procedure TakeFromMarket(a:Ptr);
	private
		EscX,EscY:Array[1..2] of integer;
	end;


	Function IntToStr(I : byte) : String;

Implementation

	Procedure GraphWin.InitGr;
        var gd,gm:smallint;
	begin
                gd := d8bit; gm := mFullScr;
                InitGraph(Gd, Gm, '');

	end;

	Function IntToStr(I : byte) : String;
	Var S : String [11];
	Begin
	 Str(I, S);
	 IntToStr:=S;
	End;

    Procedure GraphWin.Dice(x,y:integer);
    begin
        Rectangle(x,y,x+trunc((getmaxX-250)/28),y+100);
        Line(x,y+45,x+trunc((getmaxX-250)/28),y+45);
    end;

	Procedure GraphWin.Hands(Hand:ptr; x,y:integer);
	var first:ptr;
		i:integer;
	begin
		first:=Hand;
        SetTextStyle(3,2,4);
        Dice(x-10,y-10);
		Hand^.Tinfo.x:=x;
		Hand^.Tinfo.y1:=y;
        OutTextXY(x,y,IntToStr(Hand^.Tinfo.first));
        y:=y+40;
		Hand^.Tinfo.y2:=y;
        OutTextXY(x,y,IntToStr(Hand^.Tinfo.second));
        y:=y-40;
		Hand:=Hand^.next;
		for i:=1 to 21 do begin
	    //while Hand<>first do begin
			x:=x+trunc((getmaxX-200)/28);
			Hand^.Tinfo.x:=x;
			Hand^.Tinfo.y1:=y;
            Dice(x-10,y-10);
			OutTextXY(x,y,IntToStr(Hand^.Tinfo.first));
            y:=y+40;
			Hand^.Tinfo.y2:=y;
            OutTextXY(x,y,IntToStr(Hand^.Tinfo.second));
            y:=y-40;
			Hand:=Hand^.next;
		end;
		Hand:=first;
	end;

    Procedure GraphWin.MakeTable(a:Game);
	begin
		setfillstyle(1,Viridian);
		bar(0,0,getmaxX,getmaxY); // Color of background
		SetColor(0);
		
        Hands(a.GetHand2,250,15); // Here im drawing Hands (*)
		Hands(a.GetHand1,250,getMaxY-85); // <-(*)
		
		
		EscX[1]:=0; //Coordinates rectangle with key Esc
		EscY[1]:=getmaxY;
		EscX[2]:=135;
		EscY[2]:=getmaxY-50;  
		
		setfillstyle(1,Teal); // Here Im drawing key Esc (**)
		Bar(EscX[1],EscY[2],EscX[2],EscY[1]); // <-(**)
		setfillstyle(1,black);// <-(**)
		Rectangle(EscX[1],EscY[2],EscX[2],EscY[1]);// <-(**)
 		SetColor(white);// <-(**)
		OutTextXY(25,getMaxY-45,'Exit');// <-(**)
		
		setfillstyle(1,Teal); 
		Bar(getmaxX-EscX[2],EscY[2],getmaxX,EscY[1]); // key Market
		SetColor(black);
		Rectangle(getmaxX-EscX[2],EscY[2],getmaxX,EscY[1]);
		SetColor(white);
		OutTextXY(getMaxX-115,getMaxY-45,'Market');
	end;


	Procedure GraphWin.WorkWithButtonEsc(); 
	var  flag:boolean;
             x,y:integer;
             state:word;
	begin
		flag := false;
		repeat
		state:=GetMouseButtons;
		x:=GetMouseX;
		y:=GetMouseY;
		If (((State and MouseLeftButton = MouseLeftButton)or (State and MouseRightButton = MouseRightButton)) and ((EscX[2]>=x) and (EscY[2]<=y)))   Then
		begin
			flag:=true;
			halt;
		end;
		until flag;
	end;
	
	Procedure GraphWin.TakeFromMarket(a:Ptr);
	begin
		
	end;

begin

end.
