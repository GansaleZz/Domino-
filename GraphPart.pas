Unit GraphPart;

Interface
	Uses Graph,Domino;
	
	Type
	GraphWin = object
	public
		Procedure InitGr();
		Procedure MakeTable;
		Procedure Hands(Hand:ptr; x,y:integer);
	private
	end;


	Function IntToStr(I : byte) : String;

Implementation

	Procedure GraphWin.InitGr;
        var grDriver,grMode:integer;
	begin
                grDriver := Detect;
                InitGraph(grDriver, grMode,'');

	end;

	Procedure GraphWin.MakeTable();
	begin
		setfillstyle(1,2);
		bar(0,0,getmaxX,getmaxY);
		SetColor(0);
		Rectangle(100,0,getmaxX-100,100);
		Rectangle(100,getMaxY,getmaxX-100,getmaxY-100);
	end;

	Function IntToStr(I : byte) : String;
	Var S : String [11];
	Begin
	 Str(I, S);
	 IntToStr:=S;
	End;

	Procedure GraphWin.Hands(Hand:ptr; x,y:integer);
	var first:ptr;
	begin
		first:=Hand;
                SetTextStyle(3,2,4);
                OutTextXY(x,y,IntToStr(Hand^.Tinfo.first));
                y:=y+40;
                OutTextXY(x,y,IntToStr(Hand^.Tinfo.second));
                y:=y-40;
		Hand:=Hand^.next;
		while Hand<>first do begin
			x:=x+trunc((getmaxX-200)/28);
			OutTextXY(x,y,IntToStr(Hand^.Tinfo.first));
                        y:=y+40;
                        OutTextXY(x,y,IntToStr(Hand^.Tinfo.second));
                        y:=y-40;
			Hand:=Hand^.next;
		end;
		Hand:=first;
	end;


begin

end.
