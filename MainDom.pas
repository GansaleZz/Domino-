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
  // GetImage(1000,700,1100,800,BMO);
  // PutImage(800,800,BMO,BMF);
   //g.TakeDice(a.getHand1);
   g.Table;
   readln;
end.


