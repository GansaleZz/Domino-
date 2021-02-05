Unit GraphPart;

Interface
	Uses Domino,WinGraph,WinMouse;


	Type
	GraphWin = object
	public
		Constructor Init();
		Procedure MakeTable();
		Procedure Hands(var Hand:ptr; x,y:integer);
        Procedure Dice(x,y:integer;draw:boolean);
		Procedure WorkWithButtonEsc();
		Procedure TakeFromMarket(a:Ptr);
		Function ChooseDice():Ptr;
		Procedure TakeDice();
		Procedure Table();
	private
		EscX,EscY,HandX:Array[1..2] of integer;
		g:game;
		HandY:integer;
	end;


	Function IntToStr(I : byte) : String;

Implementation
	
	Constructor GraphWin.Init();
	var gd,gm:smallint;
	begin
		gd := d8bit; gm := mFullScr;
        InitGraph(Gd, Gm, '');
		g.Init;
	end;
	

	Function IntToStr(I : byte) : String;
	Var S : String [11];
	Begin
	 Str(I, S);
	 IntToStr:=S;
	End;

    Procedure GraphWin.Dice(x,y:integer;draw:boolean);
    begin
	if draw then begin
		SetColor(black);
        Rectangle(x,y,x+trunc((getmaxX-250)/28),y+100);
        Line(x,y+45,x+trunc((getmaxX-250)/28),y+45);
	end
	else begin
		setfillstyle(1,Viridian);
		Bar(x,y,x+trunc((getmaxX-250)/28),y+100);
	end;	
    end;

	Procedure GraphWin.Hands(var Hand:ptr; x,y:integer);
	var first:ptr;
		i:integer;
	begin
		first:=Hand;
        SetTextStyle(3,2,4);
        Dice(x-10,y-10,true);
		Hand^.Tinfo.x:=x;
		HandX[1]:=x-10;
		Hand^.Tinfo.y1:=y;
		HandY:=y-10;
        OutTextXY(x,y,IntToStr(Hand^.Tinfo.first));
        y:=y+40;
		Hand^.Tinfo.y2:=y;
        OutTextXY(x,y,IntToStr(Hand^.Tinfo.second));
        y:=y-40;
		Hand:=Hand^.next;
		//for i:=1 to 21 do begin
	    while Hand<>first do begin
			x:=x+trunc((getmaxX-200)/28);
			Hand^.Tinfo.x:=x;
			HandX[2]:=x+30;
			Hand^.Tinfo.y1:=y;
            Dice(x-10,y-10,true);
			OutTextXY(x,y,IntToStr(Hand^.Tinfo.first));
            y:=y+40;
			Hand^.Tinfo.y2:=y;
            OutTextXY(x,y,IntToStr(Hand^.Tinfo.second));
            y:=y-40;
			Hand:=Hand^.next;
		end;
		Hand:=first;
	end;

        Procedure GraphWin.MakeTable();
        var f:ptr;
	begin
		setfillstyle(1,Viridian);
		bar(0,0,getmaxX,getmaxY); // Color of background
		SetColor(0);
                f:=g.getHand2;
                Hands(f,250,15); // Here im drawing Hands (*)
				g.setHand2(f);
                f:=g.getHand1;
		Hands(f,250,getMaxY-85); // <-(*)
		g.setHand1(f);

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
	var  flag,col:boolean;
             x,y:integer;
             state:word;
	begin
		flag := false;
		col:=false;
		repeat
			state := GetMouseButtons;
			x:=GetMouseX;
			y:=GetMouseY;
			if (((EscX[2]>=x) and (EscY[2]<=y)) and ( col = false)) then begin
				col:= true;
				setfillstyle(1,DarkGray);
				Bar(EscX[1],EscY[2],EscX[2],EscY[1]);
				SetColor(black);
				Rectangle(EscX[1],EscY[2],EscX[2],EscY[1]);
				SetColor(white);
				OutTextXY(25,getMaxY-45,'Exit');
			end;
			if ((col) and ((EscX[2]<x) or (EscY[2]>y)))then begin
				setfillstyle(1,Teal);
				Bar(EscX[1],EscY[2],EscX[2],EscY[1]);
				SetColor(black);
				Rectangle(EscX[1],EscY[2],EscX[2],EscY[1]);
				SetColor(white);
				OutTextXY(25,getMaxY-45,'Exit');
				col:=false;
				flag:=true;
			end;
		If (((State and MouseLeftButton = MouseLeftButton)or (State and MouseRightButton = MouseRightButton)) and ((EscX[2]>=x) and (EscY[2]<=y)))   Then
		begin
			flag:=true;
			halt;
		end;
		until flag;
	end;
	
	Function GraphWin.ChooseDice():Ptr;
	var first,Current:ptr;
		bool:boolean;
		state:word;
		x,y:integer;
	begin
		Current:=g.getHand1;
		first:=Current;
		bool:=false;
		repeat
			state:=GetMouseButtons;
			x:=GetMouseX;
			y:=GetMouseY;
			if ((x>=HandX[1]) and (x<=HandX[2]) and (y>=HandY)) then begin
				repeat
					if ((Current^.Tinfo.x-10<=x) and (Current^.next^.Tinfo.x-10>=x)  and (HandY<=y)) then begin
						ChooseDice:=Current;
						bool:=true;
					end
					else if ((Current^.next = first) and (Current^.Tinfo.x-10<=x) and (HandX[2]>=x) and (HandY<=y)) then begin
						ChooseDice:=Current;
						bool:=true;
					end else
						Current:=Current^.next;
				until((Current = first) or bool);
			end
			else begin
			ChooseDice:=nil;
			break;
			end;
		until (( Current = first) or bool);
	end;
	
	Procedure GraphWin.TakeDice();
	var state:word;
		x,y:integer;
		Current,first:ptr;
		f,bool:boolean;
	begin
		f:=false;;
		bool:=false;
		first:=g.getHand1;
		repeat
			state := GetMouseButtons;
			x:=GetMouseX;
			y:=GetMouseY;
			if not f then begin
				Current:=ChooseDice();
				if Current <> nil then begin
					Dice(Current^.Tinfo.x-10,Current^.Tinfo.y1-10,false);
					Dice(Current^.Tinfo.x-10,Current^.Tinfo.y1-20,true);
					OutTextXY(Current^.Tinfo.x,Current^.Tinfo.y1-10,IntToStr(Current^.Tinfo.first));
					OutTextXY(Current^.Tinfo.x,Current^.Tinfo.y2-10,IntToStr(Current^.Tinfo.second));
					f:=true;
				end;
			end;
			if f then begin
				repeat
				state := GetMouseButtons;
				x:=GetMouseX;
				y:=GetMouseY;
				if (Current^.next = first) then begin 
					if(((Current^.Tinfo.x-10>x) or (HandX[2]<x)) or (HandY>y)) then begin 
						Dice(Current^.Tinfo.x-10,Current^.Tinfo.y1-20,false);
						Dice(Current^.Tinfo.x-10,Current^.Tinfo.y1-10,true);
						OutTextXY(Current^.Tinfo.x,Current^.Tinfo.y1,IntToStr(Current^.Tinfo.first));
						OutTextXY(Current^.Tinfo.x,Current^.Tinfo.y2,IntToStr(Current^.Tinfo.second));
						bool:=true;
					end;
				end else 
				if (((Current^.Tinfo.x-10>x) or (Current^.next^.Tinfo.x-10<x)) or (HandY>y)) then begin
					Dice(Current^.Tinfo.x-10,Current^.Tinfo.y1-20,false);
					Dice(Current^.Tinfo.x-10,Current^.Tinfo.y1-10,true);
					OutTextXY(Current^.Tinfo.x,Current^.Tinfo.y1,IntToStr(Current^.Tinfo.first));
					OutTextXY(Current^.Tinfo.x,Current^.Tinfo.y2,IntToStr(Current^.Tinfo.second));
					bool:=true;
					exit;
				end;
				until(bool = true);
			end;
		until bool = true;	
	end;
	

    Procedure GraphWin.Table();
	var x,y:integer;
		fs,OnDice:boolean;
		state:word;
		cur:ptr;
	begin
		fs:=true;
		OnDice:=false;
		repeat
			state:= GetMouseButtons;
			x:=GetMouseX;
			y:=GetMouseY;
			if ((EscX[2]>=x) and (EscY[2]<=y)) then WorkWithButtonEsc else begin
				if ((HandX[1]<=x) and (HandX[2]>=x) and (HandY <=y)) then
					TakeDice();		
			end;
		until (fs = false);
	end;

	Procedure GraphWin.TakeFromMarket(a:Ptr);
	begin
		
	end;

begin

end.
