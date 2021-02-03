Unit Domino;

Interface
 Uses crt,Dice;

 Type
  Info = record
	 First : byte;
	 Second :byte;
	 x,y1,y2:integer;
  End;

 Ptr = ^TPLay;
 TPlay = record
     Next:Ptr;
     TInfo:Info;
 end;


 Game = object
	public
		Constructor Init; // Инициализируем базар и руки игроков
		Function GetMarket:Ptr;
		Function GetHand1:Ptr;
		Function GetHand2:Ptr;
		Function GetDesk:Ptr;
		Procedure FirstMove(var f:boolean); //Первый ход
		Procedure TakeFromMarket(bool:boolean); //Взять кость с маркета
		Procedure TakeFromHand(var bool:boolean;temp:info);
		Procedure ScoreOfHands;
		Procedure ShowDesk;
		Procedure Playing;
	private
		Market:Ptr; // Базар
		Hand1:Ptr; // Рука первого игрока
        Hand2:Ptr; // Рука второго игрока
		Desk:Ptr; //Стол
        Left:byte; //Осталось
 end;

 Procedure ShowList(List:ptr); //Print list on the screen

 Implementation


 // Initializing market and hands of players
 Constructor Game.Init;
 var i,j:word;
	 firstH,firstM,DelItem:Ptr;
     temp:info;
 begin
    Left:=1;
	New(Market);
	Market^.next:=nil;
    firstM:=Market;
	for i:=0 to 5 do begin //Creating of market
		for j:=i to 6 do begin
			Market^.Tinfo.first:=i;
			Market^.Tinfo.second:=j;
			if (i<5) or (j<6) then begin
				New(Market^.next);
				Market:=Market^.next;
				Market^.next:=nil;
			end;
			Market^.next:=nil;
            inc(Left);
		end;
	end;
	New(Market^.next);
	Market:=Market^.next;
	Market^.Tinfo.first:=6;
	Market^.Tinfo.second:=6;
    Market^.next:=FirstM;
	Market:=firstM;
    // Init Hand of the first player
    New(Hand1);
    Hand1^.next:=nil;
    firstH:=Hand1;
    i:=1;
    while i<=7 do begin
        temp.First:=Random(7);
        temp.Second:=Random(7);
		// By initializing of hand, we are deleting these elements from market
        for j:=1 to Left do begin
            if (Market^.next^.TInfo.First = temp.First) and (Market^.next^.TInfo.Second = temp.Second) then begin
                Hand1^.TInfo.First:=temp.First;
                Hand1^.TInfo.Second:=temp.Second;
                if i<7 then begin
                    New(Hand1^.next);
                    Hand1:=Hand1^.next;
                    Hand1^.next:=nil;
                end;
				DelItem:=Market^.next;
				if Market^.next = firstM then begin
					firstM:=Market^.next^.next;
					Market^.next:=FirstM;
				end
				else
					Market^.next:=Market^.next^.next;
				Dispose(DelItem);
                Market:=firstM;
                dec(Left);
                inc(i);
                break;
            end
            else
                Market:=Market^.next;
        end;
		Market:=FirstM;
    end;
    Hand1^.next:=firstH;
   //Init Hand of the Second Player
    New(Hand2);
    Hand2^.next:=nil;
    firstH:=Hand2;
    i:=1;
     while i<=7 do begin
        temp.First:=Random(7);
        temp.Second:=Random(7);
		//Посредством инициализации руки, удаляем соответствующие кости из базара
        for j:=1 to Left do begin
            if (Market^.next^.TInfo.First = temp.First) and (Market^.next^.TInfo.Second = temp.Second) then begin
                Hand2^.TInfo.First:=temp.First;
                Hand2^.TInfo.Second:=temp.Second;
                if i<7 then begin
                    New(Hand2^.next);
                    Hand2:=Hand2^.next;
                    Hand2^.next:=nil;
                end;
				DelItem:=Market^.next;
				if Market^.next = firstM then begin
					firstM:=Market^.next^.next;
					Market^.next:=FirstM;
				end
				else
					Market^.next:=Market^.next^.next;
				Dispose(DelItem);
                Market:=firstM;
                dec(Left);
                inc(i);
                break;
            end
            else
                Market:=Market^.next;
        end;
		Market:=FirstM;
    end;
    Hand2^.next:=firstH;
    Hand2:=firstH;
    Market:=FirstM;
 end;


 Function Game.GetMarket:Ptr;
 begin
	GetMarket:=Market;
 end;

 Function Game.GetHand1:Ptr;
 begin
	GetHand1:=Hand1;
 end;

 Function Game.GetHand2:Ptr;
 begin
	GetHand2:=Hand2;
 end;

 Function Game.GetDesk:Ptr;
 begin
	GetDesk:=Desk;
 end;

//Вывод списка
 Procedure ShowList(List:ptr);
 var first:ptr;
 begin
	first:=List;
	writeln(List^.Tinfo.first,' ',List^.Tinfo.second);
	List:=List^.next;
	while List<>first do begin
		writeln(List^.Tinfo.first,' ',List^.Tinfo.second);
		List:=List^.next;
	end;
	List:=first;
 end;

 Procedure Game.Showdesk;
 var first:Ptr;
 begin
	first:=Desk;
	write(Desk^.Tinfo.First,' ',Desk^.Tinfo.Second,'   ');
	Desk:=Desk^.next;
	while Desk<>first do begin
		write(Desk^.Tinfo.First,' ',Desk^.Tinfo.Second,'   ');
		if Desk^.next = first then break else
			Desk:=Desk^.next;
	end;
	writeln;
 end;


 Procedure Game.FirstMove(var f:boolean);
 var First,DelItem:Ptr;
     temp:info;
     i:byte;
 begin
    temp.first:=Hand1^.TInfo.first;
    temp.second:=Hand1^.TInfo.second;
    First:=Hand1;
    Hand1:=Hand1^.next;
    for i:=1 to 7 do begin
        if temp.first<>temp.second then begin
            if Hand1^.TInfo.first = Hand1^.Tinfo.second then begin
                temp.first:=Hand1^.TInfo.first;
                temp.second:=Hand1^.TInfo.second;
            end
            else begin
                if Hand1^.TInfo.first>=temp.first then
                    if Hand1^.TInfo.second>temp.second then begin
                        temp.first:=Hand1^.TInfo.first;
                        temp.second:=Hand1^.TInfo.second;
                    end;
            end;
        end
        else begin
            if Hand1^.TInfo.first = Hand1^.TInfo.second then begin
                if Hand1^.TInfo.first>temp.first then begin
                    temp.first:=Hand1^.TInfo.first;
                    temp.second:=Hand1^.TInfo.second;
                end;
            end;
        end;
        Hand1:=Hand1^.next;
    end;
    f:=TRUE;
    Hand1:=first;
    first:=Hand2;
    for i:=1 to 7 do begin
        if temp.first<>temp.second then begin
            if Hand2^.TInfo.first = Hand2^.Tinfo.second then begin
                temp.first:=Hand2^.TInfo.first;
                temp.second:=Hand2^.TInfo.second;
                f:=FALSE;
            end
            else begin
                if Hand2^.TInfo.first>=temp.first then
                    if Hand2^.TInfo.second>temp.second then begin
                        temp.first:=Hand2^.TInfo.first;
                        temp.second:=Hand2^.TInfo.second;
                        f:=FALSE;
                    end;
            end;
        end
        else begin
            if Hand2^.TInfo.first = Hand2^.TInfo.second then begin
                if Hand2^.TInfo.first>temp.first then begin
                    temp.first:=Hand2^.TInfo.first;
                    temp.second:=Hand2^.TInfo.second;
                    f:=False;
                end;
            end;
        end;
		Hand2:=Hand2^.next;
    end;
    Hand2:=first;
    New(Desk);
    if f then begin
         first:=Hand1;
        while f=TRUE do begin
            if (Hand1^.next^.TInfo.first = temp.first) and (Hand1^.next^.Tinfo.second = temp.second) then begin
				Desk^.Tinfo.first:=temp.first;
				Desk^.Tinfo.second:=temp.second;
				DelItem:=Hand1^.next;
				if Hand1^.next = first then begin
					first:=Hand1^.next^.next;
					Hand1^.next:=First;
				end
				else
					Hand1^.next:=Hand1^.next^.next;
				Dispose(DelItem);
                break;
             end
             else
                 Hand1:=Hand1^.next;
         end;
         Hand1:=first;
    end
    else begin
        first:=Hand2;
        while f=FALSE do begin
             if (Hand2^.next^.TInfo.first = temp.first) and (Hand2^.next^.Tinfo.second = temp.second) then begin
                Desk^.Tinfo.first:=temp.first;
                Desk^.Tinfo.second:=temp.second;
                DelItem:=Hand2^.next;
				if Hand2^.next = first then begin
					first:=Hand2^.next^.next;
					Hand2^.next:=First;
				end
				else
					Hand2^.next:=Hand2^.next^.next;
				Dispose(DelItem);
                break;
             end
             else
                Hand2:=Hand2^.next;
        end;
		Hand2:=first;
    end;
	first:=Desk;
	Desk^.next:=first;
 end;



 //Взять кость с маркета
 Procedure Game.TakeFromMarket(bool:boolean);
 var first,DelItem,firstH:Ptr;
     templ:info;
     i:byte;
     tempb:boolean;
 begin
     first:=Market;
     tempb:=False;
     if bool then begin
         FirstH:=Hand1;
		 templ:=Hand1^.Tinfo;
         while (Hand1^.next^.Tinfo.first<>templ.first) or (Hand1^.next^.Tinfo.second<>templ.second) do begin
             Hand1:=Hand1^.next;
         end;
         while tempb = false do begin
             templ.first:=Random(7);
             templ.second:=random(7);
             for i:=1 to Left do begin
                 if (Market^.next^.Tinfo.first = templ.first) and (templ.second = Market^.next^.Tinfo.second) then begin
			   	    Hand1^.next:=nil;
                    New(Hand1^.next);
                    Hand1:=Hand1^.next;
                    Hand1^.Tinfo.first:=templ.first;
                    Hand1^.Tinfo.second:=templ.second;
                    DelItem:=Market^.next;
					if Market^.next = first then begin
						first:=Market^.next^.next;
						Market^.next:=First;
					end
					else
						Market^.next:=Market^.next^.next;
					Dispose(DelItem);
                    tempb:=True;
                    Dec(Left);
                    break;
                 end
				 else
					Market:=Market^.next;
             end;
         end;
         Hand1^.next:=FirstH;
		 Hand1:=FirstH;
     end
     else begin
         FirstH:=Hand2;
		 templ:=Hand2^.Tinfo;
         while (Hand2^.next^.Tinfo.first<>templ.first) or (Hand2^.next^.Tinfo.second<>templ.second) do begin
             Hand2:=Hand2^.next;
         end;
         while tempb = false do begin
             templ.first:=random(7);
             templ.second:=random(7);
             for i:=1 to Left do begin
                 if (Market^.next^.Tinfo.first = templ.first) and (templ.second = Market^.next^.Tinfo.second) then begin
			        Hand2^.next:=nil;
                    New(Hand2^.next);
                    Hand2:=Hand2^.next;
                    Hand2^.Tinfo.first:=templ.first;
                    Hand2^.Tinfo.second:=templ.second;
					DelItem:=Market^.next;
                    if Market^.next = first then begin
						first:=Market^.next^.next;
						Market^.next:=First;
					end
					else
						Market^.next:=Market^.next^.next;
					Dispose(DelItem);
                    tempb:=True;
                    Dec(Left);
                    break;
                 end
				 else
				 Market:=Market^.next;
             end;
         end;
		 Hand2^.next:=FirstH;
         Hand2:=FirstH;
     end;
	 Market:=first;
 end;

 Procedure Game.TakeFromHand(var bool:boolean;temp:info);
 var first,DelItem:ptr;
	 f:boolean;
 begin
	f:=false;
	if bool = true then begin	
		First:=Hand1;
		while f = false do begin
			if (Hand1^.next^.Tinfo.first = temp.first) and (Hand1^.next^.Tinfo.second = temp.second) then begin
				DelItem:=Hand1^.next;
				if Hand1^.next = first then begin
					first:=Hand1^.next^.next;
					Hand1^.next:=First;
				end
				else
					Hand1^.next:=Hand1^.next^.next;
				Dispose(DelItem);
				f:=true;
				bool:=not bool;
				break;
			end
			else
				Hand1:=Hand1^.next;
			if Hand1 = first then begin
				writeln('Wrong numbers!');
				break;
			end;
		end;
	end
	else begin
		First:=Hand2;
		while f = false do begin
			if (Hand2^.next^.Tinfo.first = temp.first) and (Hand2^.next^.Tinfo.second = temp.second) then begin
				DelItem:=Hand2^.next;
				if Hand2^.next = first then begin
					first:=Hand2^.next^.next;
					Hand2^.next:=First;
				end
				else
					Hand2^.next:=Hand2^.next^.next;
				Dispose(DelItem);
				f:=true;
				bool:=not bool;
				break;
			end
			else
				Hand2:=Hand2^.next;
			if Hand2 = first then begin
				writeln('Wrong numbers!');
				break;
			end;
		end;
	end;
 end;


 Procedure Game.ScoreOfHands;
 var score,score2:word;
	 temp:info;
	 f:boolean;
 begin
	f:=False;
	Score:=0;
	Score2:=0;
	temp:=Hand1^.Tinfo;
	while f=FALSE do begin
		Score:=score+Hand1^.Tinfo.first;
		Score:=Score+Hand1^.Tinfo.second;
		Hand1:=Hand1^.next;
		if (Hand1^.Tinfo.first = temp.first) and (Hand1^.Tinfo.second = temp.second) then
			break;
	end;
	temp:=Hand2^.Tinfo;
	while f=FALSE do begin
		Score2:=score2+Hand2^.Tinfo.first;
		Score2:=Score2+Hand2^.Tinfo.second;
		Hand2:=Hand2^.next;
		if (Hand2^.Tinfo.first = temp.first) and (Hand2^.Tinfo.second = temp.second) then
			break;
	end;
	if Score>Score2 then
		writeln('Won First player because he has most points in his hand')
	else if Score < Score2 then
		writeln('Won Second player because he has most points in his hand')
		 else
			writeln('There is no winners! Score of first player is equal to score of second player.');
	writeln('Score of the first player: ',Score);
	writeln('Score of the second player: ',Score2);
 end;

 Procedure Game.Playing;
 var EndG,bool:boolean;
     First,FirstD:Ptr;
     temp,templ:info;
     i,j:word;
 begin
     EndG:=FALSE;
	 i:=1;
     FirstMove(bool);
	 writeln('Round ',i);
     if bool then begin
         writeln('First move by First player: ');
         bool:=false;
     end
     else begin
         writeln('First move by second player: ');
         bool:=true;
     end;
	 inc(i);
	 FirstD:=Desk;
	 writeln('Desk: ');
	 ShowDesk;	
	 Writeln('Round ',i);
	 while ENDG<>TRUE do begin
		if bool then begin
			writeln('First players move');
			writeln('Choose Dice:');
			ShowList(Hand1);
			writeln('HELP:if you havent dice to move, enter 10. if the market is empty and you have not  dice to move enter 11');
			writeln('Enter First number: ');
			readln(temp.first);
			writeln('Enter Second number: ');
			readln(temp.second);
			if (temp.first = 11) or (temp.second = 11) then begin
				if Left =0 then begin
					ScoreofHands;
					break;
				end
				else
					Writeln('Market is not empty!');
			end;
			if (temp.first = 10) or (temp.second = 10) then
				if Left>0 then
					TakeFromMarket(bool)
				else
					writeln('Market is empty')
			else begin
				if Desk^.Tinfo.second = temp.first then begin
					TakeFromHand(bool,temp);
					if bool = true then
						writeln('Wrong numbers!')
					else begin
						new(Desk^.next);
						Desk:=Desk^.next;
						Desk^.next:=firstD;
						Desk^.Tinfo:=temp;
						bool:=not bool;
					end;
				end
				else begin
					if Desk^.Tinfo.second = temp.second then begin
						TakeFromHand(bool,temp);
						if bool = true then
							writeln('Wrong numbers!')
						else begin
							new(Desk^.next);
							Desk:=Desk^.next;
							Desk^.next:=firstD;
							Desk^.Tinfo.first:=temp.second;
							Desk^.Tinfo.second:=temp.first;
							bool:=not bool;
						end;
					end
					else begin
						writeln('Wrong numbers! Try again');
					end;
				end;
				if Hand1 = nil then begin
					writeln('Won first player! Because Hand is empty');
					ENDG:=TRUE;
				end;
			end;
		end
		else begin
			writeln('Second players move');
			writeln('Choose Dice:');
			ShowList(Hand2);
			writeln('HELP:if you havent dice to move, enter 10. if the market is empty and you have not dice to move enter 11');
			writeln('Enter First number: ');
			readln(temp.first);
			writeln('Enter Second number: ');
			readln(temp.second);
			if (temp.first = 11) or (temp.second = 11) then begin
				if Left =0 then begin
					ScoreofHands;
					break;
				end
				else
					Writeln('Market is not empty!');
			end;
			if (temp.first = 10) or (temp.second = 10) then
				if Left>0 then
					TakeFromMarket(bool)
				else
					writeln('Market is empty!')
			else begin
				if Desk^.Tinfo.second = temp.first then begin
					TakeFromHand(bool,temp);
					if bool = false then
						writeln('Wrong numbers!')
					else begin
						new(Desk^.next);
						Desk:=Desk^.next;
						Desk^.next:=firstD;
						Desk^.Tinfo:=temp;
						bool:=not bool;
					end;
				end
				else begin
					if Desk^.Tinfo.second = temp.second then begin
						TakeFromHand(bool,temp);
						if bool = false then
							writeln('Wrong numbers!')
						else begin
							new(Desk^.next);
							Desk:=Desk^.next;
							Desk^.next:=firstD;
							Desk^.Tinfo.first:=temp.second;
							Desk^.Tinfo.second:=temp.first;
							bool:=not bool;
						end;
					end
					else begin
						writeln('Wrong numbers! Try again');
					end;
				end;
				if Hand2 = nil then begin
					writeln('Won second player! Because Hand is empty');
					ENDG:=TRUE;
				end;
			end;
		end;
		bool:=not Bool;
		for j:=1 to 120 do
			write('_');
		writeln;
		inc(i);
		writeln('Round ',i);
		writeln('desk:');
		Desk:=FirstD;
		ShowDesk;
	 end;
 end;




begin

end.
