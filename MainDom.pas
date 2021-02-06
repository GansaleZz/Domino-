program MainDom;

Uses Domino,crt,GraphPart,Graph;

var a:Game;
	g:GraphWin;
	f:boolean;
begin
   ClrScr;
   Randomize;
   //a.Init;
  // a.Playing;
   g.Init();
   g.MakeTable();
   //g.TakeDice(a.getHand1);
   g.Table;
   readln;
end.


