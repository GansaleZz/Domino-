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
   g.MakeTable(a);
   g.WorkWithButtonEsc;
   readln;
end.

