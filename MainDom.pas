program MainDom;

Uses Domino,crt,GraphPart,Graph;

var a:Game;
	g:GraphWin;
	f:boolean;
begin
   ClrScr;
   Randomize;
   a.Init;
  // a.Playing;
   g.InitGr;
   g.MakeTable;
   g.Hands(a.GetHand2,101,15);
   g.Hands(a.GetHand1,101,getMaxY-85);
   readln;
end.

