
Unit GraphPart;

Interface
	Uses Domino,WinGraph,WinMouse;


	Type
	GraphWin = object
	public
		Constructor Init();
		Procedure MakeTable();
		Procedure Hands(var Hand:ptr; x,y:integer);
        Procedure Dice(x,y:integer;draw:boolean;Dice1:String = '' ;Dice2:String = '');
		Procedure WorkWithButtonEsc();
		Procedure TakeFromMarket(a:Ptr);
		Function ChooseDice():Ptr;
		Procedure TakeDice();
		Procedure PartOfDesk();
		Procedure RotationOfDice(x,y:integer;var Horizontal:boolean; var count:word);
		Procedure PutDice(x,y:integer);
		Procedure Table();
	private
		EscX,EscY,HandX:Array[1..2] of integer;
		DeskX,DeskY:integer;
		g:game;
		HandY:integer;
		ChoosenDice:ptr;
		MouseOK:boolean;
	end;


	Function IntToStr(I : byte) : String;

Implementation
	
	Constructor GraphWin.Init();
	var gd,gm:smallint;
	begin
		gd := d8bit; gm := mFullScr;
        InitGraph(Gd, Gm, '');
		g.Init;
		ChoosenDice:=nil;
	end;
	


	Function IntToStr(I : byte) : String;
	Var S : String [11];
	Begin
	 Str(I, S);
	 IntToStr:=S;
	End;




    Procedure GraphWin.Dice(x,y:integer;draw:boolean;Dice1:String = '' ;Dice2:String = '');
    begin
		if draw then begin
			SetColor(black);
			Rectangle(x,y,x+trunc((getmaxX-250)/28),y+100);
			Line(x,y+45,x+trunc((getmaxX-250)/28),y+45);
			OutTextXY(x+10,y+10,Dice1);
			OutTextXY(x+10,y+50,Dice2);
			Dice1:='';
			Dice2:='';
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
		Hand^.Tinfo.x:=x;
		HandX[1]:=x-10;
		Hand^.Tinfo.y1:=y;
		HandY:=y-10;
        y:=y+40;
		Hand^.Tinfo.y2:=y;
		Dice(Hand^.Tinfo.x-10,Hand^.Tinfo.y1-10,true,IntToStr(Hand^.Tinfo.first),IntToStr(Hand^.Tinfo.second));
        y:=y-40;
		Hand:=Hand^.next;
	    while Hand<>first do begin
			x:=x+trunc((getmaxX-200)/28);
			Hand^.Tinfo.x:=x;
			HandX[2]:=x+30;
			Hand^.Tinfo.y1:=y;
            y:=y+40;
			Hand^.Tinfo.y2:=y;
            y:=y-40;
			Dice(Hand^.Tinfo.x-10,Hand^.Tinfo.y1-10,true,IntToStr(Hand^.Tinfo.first),IntToStr(Hand^.Tinfo.second));
			Hand:=Hand^.next;
		end;
		Hand:=first;
	end;






    Procedure GraphWin.MakeTable();
    var temp:ptr;
	begin
		setfillstyle(1,Viridian);
		bar(0,0,getmaxX,getmaxY); // Color of background
		SetColor(0);
        temp:=g.getHand1;
		Hands(temp,250,getMaxY-85); // <-(*)

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
	begin
		flag := false;
		col:=false;
		repeat
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
			If (((GetMouseButtons and MouseLeftButton = MouseLeftButton)or (GetMouseButtons and MouseRightButton = MouseRightButton)) and ((EscX[2]>=x) and (EscY[2]<=y)))   Then
			begin
				flag:=true;
				halt;
			end;
		until flag;
	end;
	
	
	
	
	Function GraphWin.ChooseDice():Ptr;
	var first,Current:ptr;
		bool:boolean;
		x,y:integer;
	begin
		Current:=g.getHand1;
		first:=Current;
		bool:=false;
		repeat
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
	
	
	
	
	
	//Its realization of "Animation" of hand
	//MouseOK - if we clicked on dice  - then true ( this dice saving on ChoosenDice)
	// f - boolean of cycle (cout of steps)
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
			if (not f and not MouseOk) then begin
				ChoosenDice:=ChooseDice();
				Current:=ChoosenDice;
				if Current <> nil then begin
					Dice(Current^.Tinfo.x-10,Current^.Tinfo.y1-10,false);
					Dice(Current^.Tinfo.x-10,Current^.Tinfo.y1-20,true,IntToStr(Current^.Tinfo.first),IntToStr(Current^.Tinfo.second));
					f:=true;
				end;
			end;	
			if (f or MouseOK) then begin
				repeat
					Current:=ChoosenDice;
					state := GetMouseButtons;
					x:=GetMouseX;
					y:=GetMouseY;
					if ((State and MouseLeftButton = MouseLeftButton) and not MouseOK) then begin
						MouseOk:=true;
						bool:=true;
					end
					else begin
						if ((State and MouseLeftButton = MouseLeftButton) and MouseOK) then begin
							if (Current^.next = first) then begin
								if(((Current^.Tinfo.x-10>x) or (HandX[2]<x)) or (HandY>y)) then begin
									Dice(Current^.Tinfo.x-10,Current^.Tinfo.y1-20,false);
									Dice(Current^.Tinfo.x-10,Current^.Tinfo.y1-10,true,IntToStr(Current^.Tinfo.first),IntToStr(Current^.Tinfo.second));
									bool:=true;
									MouseOK:=false;
								end;
							end
							else
								if (((Current^.Tinfo.x-10>x) or (Current^.next^.Tinfo.x-10<x)) or (HandY>y)) then begin
									Dice(Current^.Tinfo.x-10,Current^.Tinfo.y1-20,false);
									Dice(Current^.Tinfo.x-10,Current^.Tinfo.y1-10,true,IntToStr(Current^.Tinfo.first),IntToStr(Current^.Tinfo.second));
									bool:=true;
									MouseOK:=false;
								end;
						end
						else begin
							if not MouseOk then
								if (Current^.next = first) then begin
									if(((Current^.Tinfo.x-10>x) or (HandX[2]<x)) or (HandY>y)) then begin
										Dice(Current^.Tinfo.x-10,Current^.Tinfo.y1-20,false);
										Dice(Current^.Tinfo.x-10,Current^.Tinfo.y1-10,true,IntToStr(Current^.Tinfo.first),IntToStr(Current^.Tinfo.second));
										bool:=true;
									end;
								end else
								if (((Current^.Tinfo.x-10>x) or (Current^.next^.Tinfo.x-10<x)) or (HandY>y)) then begin
									Dice(Current^.Tinfo.x-10,Current^.Tinfo.y1-20,false);
									Dice(Current^.Tinfo.x-10,Current^.Tinfo.y1-10,true,IntToStr(Current^.Tinfo.first),IntToStr(Current^.Tinfo.second));
									bool:=true;
								end;
						end;
					end;
					if bool then exit;
				until(bool = true);
			end;
		until bool = true;	
	end;
	
	
	
	
	
	Procedure GraphWin.RotationOfDice(x,y:integer;var Horizontal:boolean;var count:word);
	var temp:integer;
		tempInf:byte;
	begin
		inc(count);
		if count = 2 then begin
			tempInf:=ChoosenDice^.Tinfo.first;
			ChoosenDice^.Tinfo.first:=ChoosenDice^.Tinfo.second;
			ChoosenDice^.Tinfo.second:=tempInf;
		end;
		if count = 4 then begin
			count:=0;
			tempInf:=ChoosenDice^.Tinfo.first;
			ChoosenDice^.Tinfo.first:=ChoosenDice^.Tinfo.second;
			ChoosenDice^.Tinfo.second:=tempInf;
		end;
		if Horizontal then begin
			setfillstyle(1,Viridian);
			Bar(ChoosenDice^.Tinfo.x-10,ChoosenDice^.Tinfo.y1,ChoosenDice^.Tinfo.x+2*trunc((getmaxX-250)/28),ChoosenDice^.Tinfo.y2);
			Dice(x-10,y-10,true,IntToStr(ChoosenDice^.Tinfo.first),IntToStr(ChoosenDice^.Tinfo.second));
		end else begin
			Dice(x-10,y-10,false);
			ChoosenDice^.Tinfo.x:=x - trunc((getmaxX-250)/28)-10;
			temp:=trunc((ChoosenDice^.Tinfo.y2-ChoosenDice^.Tinfo.y1)/2);
			ChoosenDice^.Tinfo.y1:= y - temp+35;
			ChoosenDice^.Tinfo.y2:= y + temp+35;
			Rectangle(ChoosenDice^.Tinfo.x-10,ChoosenDice^.Tinfo.y1,ChoosenDice^.Tinfo.x+2*trunc((getmaxX-250)/28),ChoosenDice^.Tinfo.y2);
			Line(ChoosenDice^.Tinfo.x+40,ChoosenDice^.Tinfo.y1,ChoosenDice^.Tinfo.x+40,ChoosenDice^.Tinfo.y2);
			OutTextXY(ChoosenDice^.Tinfo.x+5,ChoosenDice^.Tinfo.y1,IntToStr(ChoosenDice^.Tinfo.first));
			OutTextXY(ChoosenDice^.Tinfo.x+2*trunc((getmaxX-250)/28)-30,ChoosenDice^.Tinfo.y2-40,IntToStr(ChoosenDice^.Tinfo.second));
		end;	
		Horizontal:=not Horizontal;
	end;
	
	
	
	
	
	Procedure GraphWin.PutDice(x,y:integer) ;
	var temp,first:ptr;
		bool,Horizontal:boolean;
		count:word;
	begin
		bool:=false;
		count:=0;
		Horizontal:=false;
		first:=g.getHand1;
		temp:=g.getHand1;
		if ((ChoosenDice<> nil) and MouseOK) then begin
			Dice(x-10,y-10,true,IntToStr(ChoosenDice^.Tinfo.first),IntToStr(ChoosenDice^.Tinfo.second));
			Dice(ChoosenDice^.Tinfo.x-10,ChoosenDice^.Tinfo.y1-20,false);
			temp:=g.getHand1;
			repeat
				if (temp^.Tinfo.x = ChoosenDice^.Tinfo.x) and (temp^.next^.Tinfo.x = ChoosenDice^.Tinfo.x) then begin
					temp:=nil;
					g.SetHand1(temp);
					setfillstyle(1,Viridian);
					Bar(HandX[1],HandY,HandX[2]+2,getMaxY);
					break;
				end else
					if temp^.Tinfo.x = ChoosenDice^.Tinfo.x then begin
							while (GetMouseButtons =0 ) do begin
								writeln(GetMouseButtons);
								if (GetMouseButtons = MouseLeftButton) then begin
									repeat
										temp:=temp^.next;
									until(temp^.next = first);
									first:=first^.next;
									temp^.next:=first;
									temp:=temp^.next;
									g.setHand1(temp);
									// Updating hand by redrawing
									setfillstyle(1,Viridian);
									Bar(HandX[1],HandY,HandX[2]+2,getMaxY);
									Hands(temp,250,getMaxY-85);
									bool:=true;
									break;
								end
								else if (GetMouseButtons = MouseRightButton ) then begin
									RotationOfDice(x,y,Horizontal,count);
								end;
							end;
					end else
						if temp^.next^.Tinfo.x = ChoosenDice^.Tinfo.x then begin
							while (GetMouseButtons =0 ) do begin
								if (GetMouseButtons = MouseLeftButton) then begin
									first:=ChoosenDice^.next;
									temp^.next:=first;
									g.setHand1(temp);
									//Dispose(ChooseDice);
									temp:=g.getHand1;
									// Updating hand by redrawing
									setfillstyle(1,Viridian);
									Bar(HandX[1],HandY,HandX[2]+2,getMaxY);
									Hands(temp,250,getMaxY-85);
									bool:=true;
									break;
								end
								else if (GetMouseButtons = MouseRightButton) then begin
									RotationOfDice(x,y,Horizontal,count);
								end;
							end;
						end
						else
							temp:=temp^.next;		
			until(bool = true );
			MouseOK:=false;
		end;
	end;
	
	
	
	
	
	Procedure GraphWin.PartOfDesk();
	var i,y:integer;
	begin
		{Randomize;
		y:=28;
		for i:=1 to 28 do begin
			SetColor(Random(100));
			Rectangle(trunc(GetMaxX/2)-7,trunc(HandY/28)+(y-14),trunc(GetMaxX/2)+7,trunc(HandY)+y);
			Rectangle(trunc(GetMaxX/2)-7,trunc(HandY/28)+y,trunc(GetMaxX/2)+7,trunc(HandY)+(y+14));
			y:=y+28;
		end;}
	end;
	
	
	
	
	
    Procedure GraphWin.Table();
	var x,y:integer;
		fs:boolean;
		cur,f:ptr;
	begin
		fs:=true;
		MouseOk:=false;
		setfillstyle(1,Black);
		Bar(trunc(GetMaxX/2-10),trunc(GetMaxY/2-10),trunc(GetMaxX/2+10),trunc(getmaxY/2+10));
		repeat
			x:=GetMouseX;
			y:=GetMouseY;
			if g.getHand1 = nil then begin
				writeln('The end!');
				repeat
					x:=GetMouseX;
					y:=GetMouseY;
				if ((EscX[2]>=x) and (EscY[2]<=y)) then WorkWithButtonEsc()
				until(fs =false);
			end;
			if ((EscX[2]>=x) and (EscY[2]<=y)) then WorkWithButtonEsc() else begin
				if ((HandX[1]<=x) and (HandX[2]>=x) and (HandY <=y)) and not MouseOK then
					TakeDice()
					else  if MouseOk then begin
							while GetMouseButtons=0 do begin
								x:=GetMouseX;
								y:=GetMouseY;
							end;
							if (((HandX[1] > x) or (HandX[2]<x)) or (HandY>y)) then begin
								PutDice(x,y);
							end
							else if ((ChoosenDice^.Tinfo.y1>y) and (GetMouseButtons = MouseLeftButton)) then begin
									Dice(ChoosenDice^.Tinfo.x-10,ChoosenDice^.Tinfo.y1-20,false);
									Dice(ChoosenDice^.Tinfo.x-10,ChoosenDice^.Tinfo.y1-10,true,IntToStr(ChoosenDice^.Tinfo.first),IntToStr(ChoosenDice^.Tinfo.second));
									MouseOk:=false;
							end;
					end;
			end;
		until (fs = false);
	end;

	Procedure GraphWin.TakeFromMarket(a:Ptr);
	begin
		
	end;

begin

end.
