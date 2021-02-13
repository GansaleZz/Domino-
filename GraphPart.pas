
Unit GraphPart;

Interface
	Uses Domino,WinGraph,WinMouse;


	Type
	
	But = record
	x1,y1,x2,y2:integer;
	end;	
	
	VerticalScrlBar = object
	public
		Constructor InitVSB(x1,y1,x2,y2:integer);
		Function getButUp():But;
		Function getButDown():But;
		Function getScrollerV():But;
		Procedure Scrolling(bool:boolean; var Current:ptr);
	private
		ButUp,ButDown:But;
		ScrollerV:But;
	end;
	
	HorizScrlBar = object
	public
		Constructor InitHSB(x1,y1,x2,y2:integer);
		Function getButLeft():But;
		Function getButRight():But;
		Function getScrollerH():But;
	    Procedure Scrolling(bool:boolean; var Current:ptr);
	private
		ButLeft,ButRight:But;
		ScrollerH:But;
	end;
	
	
	GraphWin = object
	public
		Constructor Init();
		Procedure MakeTable();
		Procedure Hands(var Hand:ptr; x,y:integer);
        Procedure Dice(x,y:integer;draw:boolean;Dice1:String = '' ;Dice2:String = '';y2:integer = 0;Horizontal:boolean = false);
		Procedure WorkWithButtonEsc();
		Procedure TakeFromMarket(a:Ptr);
		Function ChooseDice():Ptr;
		Procedure TakeDice();
		Procedure PartOfDesk();
		Procedure RotationOfDice(x,y:integer;var Horizontal:boolean; var count:word);
		Procedure PutDice(x,y:integer;var DeskPtr:ptr);
		Procedure Table();
	private
		EscX,EscY,HandX:Array[1..2] of integer;
		DeskX,DeskY:integer;
		g:game;
		HandY:integer;
		ChoosenDice:ptr;
		MouseOK:boolean;
		HSCB:HorizScrlBar;
		VSCB:VerticalScrlBar;
	end;
	
	DeskPart = object(GraphWin)
	public
		Constructor InitD(x1,y1,x2,y2:integer);
		Function getDesk():But;
		Function getDeskPtr():Ptr;
		Procedure setDeskPtr(DeskPtr:ptr);
		Procedure DrawingOfDesk();
		Procedure addToDesk(DeskPtr:Ptr);
	private
		Desk:But;
		DeskPtr:Ptr;
	end;
	

	

	Function IntToStr(I : byte) : String;

Implementation

//----------------------------------------------------Realization of ScrollBar------------------------------------------------------------------------------
				//-------------------------------Vertical Scroll Bar------------------------------------------------------------------------------------	
	Constructor VerticalScrlBar.InitVSB(x1,y1,x2,y2:integer);
	begin
		ButUp.x1:=x2;
		ButUp.y1:=y1;
		ButUp.x2:=x2+30;
		ButUp.y2:=y1+50;
		
		ButDown.x1:=x2;
		ButDown.y1:=y2-50;
		ButDown.x2:=x2+30;
		ButDown.y2:=y2;
		
		Rectangle(ButUp.x1,ButUp.y1,ButUp.x2,ButUp.y2);
		Rectangle(ButDown.x1,ButDown.y1,ButDown.x2,ButDown.y2);
		
		ScrollerV.x1:=ButUp.x1; // Status(Position) of camera
		ScrollerV.y1:=ButUp.y2+trunc((ButDown.y1-ButUp.y2)/3);
		ScrollerV.x2:=ButDown.x2;
		ScrollerV.y2:=ButDown.y1-trunc((ButDown.y1-ButUp.y2)/3);
		setfillstyle(1,0);
		Bar(ScrollerV.x1,ScrollerV.y1,ScrollerV.x2,ScrollerV.y2);
		SetColor(0);
		Rectangle(ButUp.x1,ButUp.y2,ButDown.x2,ButDown.y1);
	end;
	
	
	Function VerticalScrlBar.getButDown():But;
	begin
		getButDown:=ButDown;
	end;
	
	Function VerticalScrlBar.getButUp():But;
	begin
		getButUp:=ButUp;
	end;
	
	Function VerticalScrlBar.getScrollerV():But;
	begin
		getScrollerV:=ScrollerV;
	end;
	
	Procedure VerticalScrlBar.Scrolling(bool:boolean;var Current:Ptr);
	var temp:integer;
		first:ptr;
	begin
		temp:=(ScrollerV.y2-ScrollerV.y1-3);
		if(bool) then begin
			if(ScrollerV.y1-temp>(ButUp.y2)) then begin
				setfillstyle(1,Viridian);
				Bar(ScrollerV.x1+1,ScrollerV.y1,ScrollerV.x2-1,ScrollerV.y2);
				setfillstyle(1,0);
				ScrollerV.y1:=ScrollerV.y1-temp;
				ScrollerV.y2:=ScrollerV.y2-temp;
				Bar(ScrollerV.x1+1,ScrollerV.y1,ScrollerV.x2,ScrollerV.y2-1);
				if Current<>nil then begin
					first:=Current;
					repeat
						Current^.Tinfo.y1:=Current^.Tinfo.y1+3*trunc(temp/2);
						Current^.Tinfo.y2:=Current^.Tinfo.y2+3*trunc(temp/2);
						Current:=Current^.next;
					until(Current=first);
				end;
			end else exit;
		end else begin
			if (ScrollerV.y2+temp<(ButDown.y1)) then begin
				setfillstyle(1,Viridian);
				Bar(ScrollerV.x1+1,ScrollerV.y1,ScrollerV.x2-1,ScrollerV.y2);
				setfillstyle(1,0);
				ScrollerV.y1:=ScrollerV.y1+temp;
				ScrollerV.y2:=ScrollerV.y2+temp;
				Bar(ScrollerV.x1,ScrollerV.y1,ScrollerV.x2,ScrollerV.y2);
				if Current<>nil then begin
					first:=Current;
					repeat
						Current^.Tinfo.y1:=Current^.Tinfo.y1-3*trunc(temp/2);
						Current^.Tinfo.y2:=Current^.Tinfo.y2-3*trunc(temp/2);
						Current:=Current^.next;
					until(Current=first);
				end;
			end else exit;
		end;
	end;
				//-------------------------------Horizontal Scroll Bar------------------------------------------------------------------------------------
	Constructor HorizScrlBar.InitHSB(x1,y1,x2,y2:integer);
	begin
		ButLeft.x1:=x1;
		ButLeft.y1:=y2;
		ButLeft.x2:=x1+50;
		ButLeft.y2:=y2+30;
		
		ButRight.x1:=x2-50;
		ButRight.y1:=y2;
		ButRight.x2:=x2;
		ButRight.y2:=y2+30;
		
		setcolor(black);
		Rectangle(ButLeft.x1,ButLeft.y1,ButLeft.x2,ButLeft.y2);
		Rectangle(ButRight.x1,ButRight.y1,ButRight.x2,ButRight.y2);
		
		ScrollerH.x1:=ButLeft.x2+trunc((ButRight.x1-ButLeft.x2)/3);// Status(Position) of camera
		ScrollerH.y1:=ButLeft.y1;
		ScrollerH.x2:=ButRight.x1-trunc((ButRight.x1-ButLeft.x2)/3);
		ScrollerH.y2:=ButRight.y2;
		
		Rectangle(ButLeft.x2,ButLeft.y1,ButRight.x1,ButLeft.y2);
		setfillstyle(1,0);
		Bar(ScrollerH.x1,ScrollerH.y1,ScrollerH.x2,ScrollerH.y2);
	end;
	
	
	Function HorizScrlBar.getButLeft():But;
	begin
		getButLeft:=ButLeft;
	end;
	
	Function HorizScrlBar.getButRight():But;
	begin
		getButRight:=ButRight;
	end;
	
	Function HorizScrlBar.getScrollerH():But;
	begin
		getScrollerH:=ScrollerH;
	end;
	
	Procedure HorizScrlBar.Scrolling(bool:boolean;var Current:Ptr);
	var temp:integer;
		first:ptr;
	begin
		temp := ScrollerH.x2 - ScrollerH.x1 -3 ;
		if bool then begin
			if (ScrollerH.x1 - temp > ButLeft.x2) then begin
				setfillstyle(1,Viridian);
				Bar(ScrollerH.x1,ScrollerH.y1+1,ScrollerH.x2,ScrollerH.y2-1);
				setfillstyle(1,0);
				ScrollerH.x1:=ScrollerH.x1-temp;
				ScrollerH.x2:=ScrollerH.x2-temp;
				Bar(ScrollerH.x1,ScrollerH.y1,ScrollerH.x2,ScrollerH.y2);
				if Current<>nil then begin
					first:=Current;
					repeat
						Current^.Tinfo.x:=Current^.Tinfo.x+temp;
						Current:=Current^.next;
					until(Current=first);
				end;
			end else exit;
		end else begin
			if (ScrollerH.x2 + temp < ButRight.x1) then begin
				setfillstyle(1,Viridian);
				Bar(ScrollerH.x1,ScrollerH.y1+1,ScrollerH.x2,ScrollerH.y2-1);
				setfillstyle(1,0);
				ScrollerH.x1:=ScrollerH.x1+temp;
				ScrollerH.x2:=ScrollerH.x2+temp;
				Bar(ScrollerH.x1,ScrollerH.y1,ScrollerH.x2,ScrollerH.y2);
				if Current<>nil then begin
					first:=Current;
					repeat
						Current^.Tinfo.x:=Current^.Tinfo.x-temp;
						Current:=Current^.next;
					until(Current=first);
				end;
			end else exit;
		end;
	end;

	
	
//------------------------------------------------------------------------------------------------------------------------------------------------------------	
//--------------------------------------------------Realization of Desk---------------------------------------------------------------------------------------

	Constructor DeskPart.InitD(x1,y1,x2,y2:integer);
	begin
		Desk.x1:=x1;
		Desk.y1:=y1;
		Desk.x2:=x2;
		Desk.y2:=y2;
		
		DeskPtr:=nil;
		
		SetColor(0);
		Rectangle(Desk.x1,Desk.y1,Desk.x2,Desk.y2);
	end;
	
	Function DeskPart.getDesk():But;
	begin
		getDesk:=Desk;
	end;
	
	Function DeskPart.getDeskPtr():Ptr;
	begin
		getDeskPtr:=DeskPtr;
	end;
	
	Procedure DeskPart.setDeskPtr(DeskPtr:ptr);
	begin
		self.Deskptr:=Deskptr;
	end;
	
	Procedure DeskPart.addToDesk(DeskPtr:Ptr);
	var first,Current:ptr;
		temp:Info;
	begin
		if self.DeskPtr <> nil then begin
			first:=self.DeskPtr;
			Current:=self.DeskPtr;
			while Current^.next <> first do begin
				Current:=Current^.next;
			end;
			new(Current^.next);
			Current:=Current^.next;
			temp:=DeskPtr^.Tinfo;
			Current^.Tinfo:=temp;
			Current^.next:=first;
		end else begin
			New(Current);
			first:=Current;
			self.DeskPtr:=first;
			temp:=DeskPtr^.Tinfo;
			Current^.Tinfo:=temp;
			Current^.Tinfo.y1:=Current^.Tinfo.y1-400;
			Current^.Tinfo.y2:=Current^.Tinfo.y2-400;
			Current^.next:=first;
		end;
	end;	
	
	Procedure DeskPart.DrawingOfDesk();
	var Current,first,firstD:Ptr;
		temp:info;
	begin
		first:=DeskPtr;
		Current:=DeskPtr;
		setfillstyle(1,Viridian);
		Bar(Desk.x1+1,Desk.y1+1,Desk.x2-1,Desk.y2-1);
		repeat
			if((Current^.Tinfo.x>Desk.x1) and (Current^.Tinfo.x+trunc((getmaxX-250)/28)<Desk.x2) and (Current^.Tinfo.y1>Desk.y1) and (Current^.Tinfo.y1+100<Desk.y2)) then begin
				if Current^.Tinfo.pos = false then 
					Dice(Current^.Tinfo.x,Current^.Tinfo.y1,true,IntToStr(Current^.Tinfo.first),IntToStr(Current^.Tinfo.second))
				else 
					Dice(Current^.Tinfo.x,Current^.Tinfo.y1,true,IntToStr(Current^.Tinfo.first),IntToStr(Current^.Tinfo.second),Current^.Tinfo.y2,true);
			end;
			Current:=Current^.next;
		until(Current = first);
		
	end;

//-------------------------------------------------------------------------------------------------------------------------------------------------------------	
//--------------------------------------------------Realization of GraphicPart---------------------------------------------------------------------------------
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




    Procedure GraphWin.Dice(x,y:integer;draw:boolean;Dice1:String = '' ;Dice2:String = '';y2:integer = 0;Horizontal:boolean = false); // drawing Dice
    begin
		if not Horizontal then begin
			if draw then begin
				SetColor(black);
				Rectangle(x,y+10,x+trunc((getmaxX-250)/28),y+100);
				Line(x,y+55,x+trunc((getmaxX-250)/28),y+55);
				OutTextXY(x+10,y+10,Dice1);
				OutTextXY(x+10,y+60,Dice2);
				Dice1:='';
				Dice2:='';
			end
			else begin
				setfillstyle(1,Viridian);
				Bar(x,y,x+trunc((getmaxX-250)/28),y+100);
			end;
		end else begin
			if draw then begin
				SetColor(0);
				Rectangle(x,y,x+2*trunc((getmaxX-250)/28),y2);
				Line(x+40,y,x+40,y2);
				OutTextXY(x+5,y,Dice1);
				OutTextXY(x+2*trunc((getmaxX-250)/28)-30,y2-40,Dice2);
			end else begin
				setfillstyle(1,Viridian);
				Bar(x-10,y,x+2*trunc((getmaxX-250)/28),y2);
			end;
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
		Hand^.Tinfo.pos:=false;
		Hand:=Hand^.next;
	    while Hand<>first do begin
			x:=x+trunc((getmaxX-200)/28);
			Hand^.Tinfo.x:=x;
			Hand^.Tinfo.pos:=false;
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
        DeskP:DeskPart;
	begin
		setfillstyle(1,Viridian);
		bar(0,0,getmaxX,getmaxY); // Color of background
		SetColor(0);
        temp:=g.getHand1;
		Hands(temp,250,getMaxY-85); // <-(*)
	
	    HSCB.InitHSB(100,trunc(getMaxY/8)-40,getmaxX-100,getmaxY - trunc(getMaxY/8)-40);
		VSCB.InitVSB(100,trunc(getMaxY/8)-40,getmaxX-100,getmaxY - trunc(getMaxY/8)-40);
		
		
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
	var temp,buf:integer;
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
			Dice(ChoosenDice^.Tinfo.x,ChoosenDice^.Tinfo.y1,false,'','',ChoosenDice^.Tinfo.y2,true);
			ChoosenDice^.Tinfo.x:=x-10;
			ChoosenDice^.Tinfo.y1:=y-10;
			ChoosenDice^.Tinfo.y2:=ChoosenDice^.Tinfo.y1+100;
			Dice(ChoosenDice^.Tinfo.x,ChoosenDice^.Tinfo.y1,true,IntToStr(ChoosenDice^.Tinfo.first),IntToStr(ChoosenDice^.Tinfo.second));
		end else begin
			ChoosenDice^.TInfo.x:=x-10;
			ChoosenDice^.Tinfo.y1:=y-10;
			ChoosenDice^.Tinfo.y2:=ChoosenDice^.Tinfo.y1+100;
			Dice(ChoosenDice^.Tinfo.x,ChoosenDice^.Tinfo.y1,false);
			temp:=trunc((ChoosenDice^.Tinfo.y2-ChoosenDice^.Tinfo.y1)/2);
			ChoosenDice^.Tinfo.x:=ChoosenDice^.Tinfo.x -temp;
			ChoosenDice^.Tinfo.y1:= ChoosenDice^.Tinfo.y1+30;
			ChoosenDice^.Tinfo.y2:= ChoosenDice^.Tinfo.y2-30;
			Dice(ChoosenDice^.Tinfo.x,ChoosenDice^.Tinfo.y1,true,IntToStr(ChoosenDice^.Tinfo.first),IntToStr(ChoosenDice^.Tinfo.second),ChoosenDice^.Tinfo.y2,true);
		end;	
		Horizontal:=not Horizontal;
		ChoosenDice^.Tinfo.pos:=not ChoosenDice^.Tinfo.pos;
	end;
	
	
	
	
	
	Procedure GraphWin.PutDice(x,y:integer; var DeskPtr:ptr) ;
	var temp,first,firstD:ptr;
		bool,Horizontal:boolean;
		count:word;
		tempInf:Info;
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
								if (GetMouseButtons = MouseLeftButton) then begin
									repeat
										temp:=temp^.next;
									until(temp^.next = first);
									first:=first^.next;
									temp^.next:=first;
									temp:=temp^.next;
									g.setHand1(temp);
									firstD:=DeskPtr;
									repeat
										DeskPtr:=DeskPtr^.next;
									until(DeskPtr^.next = firstD);
									new(DeskPtr^.next);
									DeskPtr:=DeskPtr^.next;
									DeskPtr^.Tinfo:=ChoosenDice^.Tinfo;
									DeskPtr^.Tinfo.x:=x;
									DeskPtr^.Tinfo.y1:=y;
									DeskPtr^.Tinfo.y2:=y+40;
									DeskPtr^.next:=firstD;
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
									firstD:=DeskPtr;
									repeat
										DeskPtr:=DeskPtr^.next;
									until(DeskPtr^.next = firstD);
									new(DeskPtr^.next);
									DeskPtr:=DeskPtr^.next;
									DeskPtr^.Tinfo:=ChoosenDice^.Tinfo;
									DeskPtr^.Tinfo.x:=x;
									DeskPtr^.Tinfo.y1:=y;
									DeskPtr^.Tinfo.y2:=y+40;
									DeskPtr^.next:=firstD;
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
		cur,tempDesk,firstD:ptr;
		state:word;
		DeskP:DeskPart;
	begin
		fs:=true;
		MouseOk:=false;
		setfillstyle(1,Black);
		Bar(trunc(GetMaxX/2-10),trunc(GetMaxY/2-10),trunc(GetMaxX/2+10),trunc(getmaxY/2+10));
		DeskP.InitD(100,trunc(getMaxY/8)-40,getmaxX-100,getmaxY - trunc(getMaxY/8)-40); // Desk
		DeskP.addToDesk(g.getHand1);
		DeskP.DrawingOfDesk;
		repeat
			state:=GetMouseButtons;
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
								tempDesk:=DeskP.getDeskPtr;
								PutDice(x,y,tempDesk);
								DeskP.setDeskPtr(tempDesk);
							end
							else if ((ChoosenDice^.Tinfo.y1>y) and (GetMouseButtons = MouseLeftButton)) then begin
									Dice(ChoosenDice^.Tinfo.x-10,ChoosenDice^.Tinfo.y1-20,false);
									Dice(ChoosenDice^.Tinfo.x-10,ChoosenDice^.Tinfo.y1-10,true,IntToStr(ChoosenDice^.Tinfo.first),IntToStr(ChoosenDice^.Tinfo.second));
									MouseOk:=false;
							end;
					end
						else if ((x>=HSCB.getButRight.x1) and (x<=HSCB.getButRight.x2) and (y<=HSCB.getButRight.y2) and (y>=HSCB.getButRight.y1) and (state and GetMouseButtons = MouseLeftButton)) then begin
							tempDesk:=DeskP.getDeskPtr;
							HSCB.Scrolling(false,tempDesk);
							DeskP.DrawingOfDesk;
							while(GetMouseButtons = MouseLeftButton) do begin end;
						end
							else if ((x>=HSCB.getButLeft.x1) and (x<=HSCB.getButLeft.x2) and (y<=HSCB.getButLeft.y2) and (y>=HSCB.getButLeft.y1) and (state and GetMouseButtons = MouseLeftButton))then begin
								tempDesk:=DeskP.getDeskPtr;
								HSCB.Scrolling(true,tempDesk);
								DeskP.DrawingOfDesk;
								while(GetMouseButtons = MouseLeftButton) do begin end;
							end
								else if ((x>=VSCB.getButUp.x1) and (x<=VSCB.getButUp.x2) and (y>=VSCB.getButUp.y1) and (y<=VSCB.getButUp.y2) and (state and GetMouseButtons = MouseLeftButton)) then begin
									tempDesk:=DeskP.getDeskPtr;
									VSCB.Scrolling(true,tempDesk);
									DeskP.DrawingOfDesk;
									while(GetMouseButtons = MouseLeftButton) do begin end;
								end
									else if ((x>=VSCB.getButDown.x1) and (x<=VSCB.getButDown.x2) and (y>=VSCB.getButDown.y1) and (y<=VSCB.getButDown.y2) and (state and GetMouseButtons = MouseLeftButton)) then begin
										tempDesk:=DeskP.getDeskPtr;
										VSCB.Scrolling(false,tempDesk);
										DeskP.DrawingOfDesk;
										while(GetMouseButtons = MouseLeftButton) do begin end;
									end;
			end;
		until (fs = false);
	end;

	Procedure GraphWin.TakeFromMarket(a:Ptr);
	begin
		
	end;

begin

end.
