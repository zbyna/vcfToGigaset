unit unZjistiIp;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Grids,
  StdCtrls,simpleinternet,xquery;

type

  { TfrmZjistiIp }

  TfrmZjistiIp = class(TForm)
    btnOK: TButton;
    btnCancel: TButton;
    stringGrid1: TStringGrid;
    procedure FormShow(Sender: TObject);
    procedure StringGrid1SelectCell(Sender: TObject; aCol, aRow: Integer;
      var CanSelect: Boolean);
  private
    { private declarations }
  public
    { public declarations }


  end;

var
  frmZjistiIp: TfrmZjistiIp;

implementation

{$R *.frm}
uses
     unNastaveni;

{ TfrmZjistiIp }

procedure TfrmZjistiIp.FormShow(Sender: TObject);
var
   stazeno,pom : IXQValue;
   pomPole : TXQVArray;
   pomStringList : TStringList;
   i:Byte;
   pomBool : Boolean;
begin
  // stáhne info     frmNastaveni.Memo1.Text použito pro testování více základen :-)
  stazeno:=process('http://www.gigaset-config.com','<td><a>{.}</a></td>*');
  pomPole:=stazeno.toArray;
  pomStringList:=TStringList.Create;
  for pom in  pomPole do pomStringList.Append(pom.toString);
  if pomStringList.Text='' then
     begin
       MessageDlg('It is not possible to detect telephone base,'
                   +LineEnding+'try to restart it please.', mtWarning, [mbOK],0);
       frmZjistiIp.btnCancel.Click;  // ukonči formulář kliknutím na zrušit :-)
       exit;
     end;
  // zobrazí info v stringgridu
  for i:=0 to (pomStringList.Count div 4)-1 do
        StringGrid1.InsertRowWithValues(i+1,[pomStringList[i*4],
                                            pomStringList[(i*4)+1],
                                            pomStringList[(i*4)+2],
                                            pomStringList[(i*4)+3] ] );
  stringGrid1.RowCount:= StringGrid1.RowCount -1; // pořád zobrazuju 3 řádky
  // vybere první řádek
  stringGrid1.Col:=1;
  stringGrid1.Row:=1;
  pomBool:=False;
  stringGrid1SelectCell(self,1,1,pomBool);
  stringGrid1.SetFocus;
end;

procedure TfrmZjistiIp.StringGrid1SelectCell(Sender: TObject; aCol,
  aRow: Integer; var CanSelect: Boolean);
begin
  // opravdu je potřeba
end;

end.

