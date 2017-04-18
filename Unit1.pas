unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls,
  Vcl.AppEvnts, Vcl.Menus, Vcl.Buttons, math, Vcl.ImgList;

type
  TForm1 = class(TForm)
    Edit1: TEdit;
    Label1: TLabel;
    RadioGroup1: TRadioGroup;
    Label2: TLabel;
    Edit2: TEdit;
    GroupBox1: TGroupBox;
    Memo1: TMemo;
    StatusBar1: TStatusBar;
    MainMenu1: TMainMenu;
    Plik1: TMenuItem;
    Pomoc1: TMenuItem;
    Koniec1: TMenuItem;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    Pomoc2: TMenuItem;
    Oprogramie1: TMenuItem;
    ImageList1: TImageList;
    procedure FormCanResize(Sender: TObject; var NewWidth, NewHeight: Integer;
      var Resize: Boolean);
    procedure Koniec1Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    function zepsuj(l, p, ilosc : integer) : string;
    procedure BitBtn1Click(Sender: TObject);
    function napraw(w : string; p : integer) : integer;
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    function przetraw(pokarm : integer) : integer;
    function wypluj(tresc : integer) : integer;
    procedure Pomoc2Click(Sender: TObject);
    procedure Oprogramie1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses Unit2;

procedure TForm1.BitBtn1Click(Sender: TObject);
begin
if edit1.Text<>'' then
begin
  memo1.Clear;
  if radiogroup1.ItemIndex=0 then
  begin
    if (strtoint(edit1.Text)<=255) and (strtoint(edit1.Text)>=1) then
      edit2.Text:=inttostr(przetraw(strtoint(edit1.Text)))
    else
      showmessage('8 bitów to nie wiecej ni¿ 255, LOL');
  end
  else
  begin
    if (strtoint(edit1.Text)<=4095) and (strtoint(edit1.Text)>=10) then
      edit2.Text:=inttostr(wypluj(strtoint(edit1.Text)))
    else
      showmessage('Na 12 bitach nie pojdzie wiecej ni¿ 4095, LOL');
  end;
end
else
  showmessage('WeŸ coœ tam wpisz w w pole "wejœcie", LOL');
end;

procedure TForm1.BitBtn2Click(Sender: TObject);
begin
  edit1.Clear;
  edit2.Clear;
  memo1.Clear;
end;

procedure TForm1.BitBtn3Click(Sender: TObject);
begin
  randomize;
  if radiogroup1.ItemIndex=0 then
    edit1.Text:=inttostr(random(257)+2)
  else
    edit1.Text:=inttostr(random(4100)+5);
end;

procedure TForm1.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  if key=#13 then
    bitbtn1.Click;
end;

procedure TForm1.FormCanResize(Sender: TObject; var NewWidth,
  NewHeight: Integer; var Resize: Boolean);
begin
  resize:=false;
end;

procedure TForm1.Koniec1Click(Sender: TObject);
begin
  close;
end;

function tform1.zepsuj(l, p, ilosc : integer) : string;
var
  bufor : array[1..12] of integer;
  i : integer;
begin
  result:='';
  for I := 1 to ilosc do
    bufor[i]:=0;
  i:=ilosc;
  while (l>0) do
  begin
    bufor[i]:=l mod p;
    l:=l div p;
    i:=i-1;
  end;
  for I := 1 to ilosc do
    result:=result+inttostr(bufor[i]);
end;

function tform1.napraw(w : string; p : integer) : integer;
var
  i, il, b : integer;
begin
  il:=length(w)-1;
  b:=0;
  for I := 1 to length(w) do
  begin
    b:=b+((ord(w[i])-48)*round(power(p,il)));
    il:=il-1;
  end;
  result:=b;
end;

procedure TForm1.Oprogramie1Click(Sender: TObject);
begin
  showmessage('Pozdro 600!'+#13+'W przypadku problemów z obs³ug¹ programu, zajrzyj do zak³adki "Pomoc".');
end;

procedure TForm1.Pomoc2Click(Sender: TObject);
begin
  form2.show;
end;

function tform1.przetraw(pokarm: integer) : integer;
var
  t : array[1..4,1..12] of shortstring;
  i, j, c, m, a : byte;
  z, w : shortstring;
  kontrolne : array[1..4] of byte;
begin
  j:=1;
  m:=7;
  c:=4;
  a:=1;
  z:=zepsuj(pokarm,2,8);
  for I := 12 downto 1 do
  begin
    if i>=10 then
      t[1,i]:=inttostr(i)
    else
      t[1,i]:='  '+inttostr(i);
    t[2,i]:=zepsuj(i,2,4);
    if (i=8) or (i=4) or (i=2) or (i=1) then
    begin
      t[3,i]:='c'+inttostr(c);
      c:=c-1;
    end
    else
    begin
      t[3,i]:='m'+inttostr(m);
      m:=m-1;
      t[4,i]:=z[j];
      j:=j+1;
    end;
  end;
  for I := 1 to 4 do
    kontrolne[i]:=0;
  for I := a to 12 do
  begin
    for j := 4 downto 1 do
    begin
      if ((t[2,i,j]='1') and (t[4,i]='1')) and (pos('c',t[3,i])=0) then
        kontrolne[abs(j-4)+1]:=kontrolne[abs(j-4)+1]+1;
    end;
    a:=a*2;
  end;
  for j := 1 to 4 do
  begin
    kontrolne[j]:=kontrolne[j] mod 2;
    t[4,round(power(2,(j-1)))]:=inttostr(kontrolne[j]);
  end;
  w:='';
  for I := 12 downto 1 do
  begin
    memo1.Lines.Add(t[1,i]+'|'+t[2,i]+'|'+t[3,i]+'|'+t[4,i]);
    w:=w+t[4,abs(i-12)+1];
  end;
  memo1.Lines.Add('c1='+inttostr(kontrolne[1])+', c2='+inttostr(kontrolne[2])+', c4='+inttostr(kontrolne[3])+', c8='+inttostr(kontrolne[4]));
  result:=napraw(w,2);
end;

function tform1.wypluj(tresc: Integer) : integer;
var
  i, j, c, m, a : byte;
  z, syndrom, w : shortstring;
  t : array[1..4,1..12] of shortstring;
  k : array[1..4,1..3] of shortstring;
  kontrolne : array[1..4] of byte;
begin
  z:=zepsuj(tresc, 2, 12);
  j:=1;
  m:=7;
  c:=4;
  a:=8;
  for I := 12 downto 1 do
  begin
    if i>=10 then
      t[1,i]:=inttostr(i)
    else
      t[1,i]:='  '+inttostr(i);
    t[2,i]:=zepsuj(i,2,4);
    if (i=8) or (i=4) or (i=2) or (i=1) then
    begin
      t[3,i]:='c'+inttostr(c);
      c:=c-1;
    end
    else
    begin
      t[3,i]:='m'+inttostr(m);
      m:=m-1;
      t[4,i]:=z[j];
      j:=j+1;
    end;
    t[4,i]:=z[i];
    memo1.Lines.Add(t[1,i]+'|'+t[2,i]+'|'+t[3,i]+'|'+t[4,i]);
  end;
  for I := 4 downto 1 do
  begin
    k[abs(i-4)+1,1]:=t[4,a];
    a:=round(a/2);
  end;
  for I := 1 to 4 do
    kontrolne[i]:=0;
  for I := a to 12 do
  begin
    for j := 4 downto 1 do
    begin
      if ((t[2,i,j]='1') and (t[4,i]='1')) and (pos('c',t[3,i])=0) then
        kontrolne[j]:=kontrolne[j]+1;
    end;
    a:=a*2;
  end;
  syndrom:='';
  for I := 1 to 4 do
  begin
    k[i,2]:=inttostr(kontrolne[i] mod 2);
    k[i,3]:=booltostr(strtobool(k[i,1]) xor strtobool(k[i,2]));
    syndrom:=syndrom+k[i,3];
  end;
  syndrom:=stringreplace(syndrom,'-','',[rfReplaceAll, rfIgnoreCase]);
  if napraw(syndrom,2)>12 then
  begin
    memo1.Lines.Add('Wykry³em wiêcej, ni¿ 1 b³¹d transmisji. Sorry, kancierta niet budziet.');
    result:=0;
  end
  else
  begin
    if (napraw(syndrom,2)>0) and (napraw(syndrom,2)<=12) then
    begin
      for I := 1 to 12 do
        if t[2,i]=syndrom then
          if t[4,i]='1' then
            t[4,i]:='0'
          else
            t[4,i]:='1';
      memo1.Lines.Add('Znalaz³em 1 b³¹d transmisji, ale spokojnie Andrzeju... Poradziliœmy sobie!');
      memo1.Lines.Add('Miejsce b³êdu: '+syndrom);
    end
    else
      memo1.Lines.Add('Transmisja przebieg³a bezb³êdnie!');
    w:='';
    for I := 12 downto 1 do
      if (i<>8) and (i<>4) and (i<>2) and (i<>1) then
        w:=w+t[4,i];
      result:=napraw(w,2);
  end;
end;

end.
