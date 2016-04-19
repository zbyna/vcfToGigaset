unit unVyberHandsets;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs,
  StdCtrls, ExtCtrls,unit1,
  cef3lib,cef3lcl,cef3api,strutils,LazUTF8;

type

  { TfrmVyberHandsets }

  TfrmVyberHandsets = class(TForm)
    OK: TButton;
    Cancel: TButton;
    RadioGroup1: TRadioGroup;
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  frmVyberHandsets: TfrmVyberHandsets;

implementation


{$R *.lfm}

{ TfrmVyberHandsets }

procedure TfrmVyberHandsets.FormShow(Sender: TObject);
var
  delkaHandSets: SizeInt;
  i: Integer;
  pomString: String;
begin
 RadioGroup1.Items.Clear;
 delkaHandSets:= utf8length(handSets);
 for i:=1 to 6 do
   begin
     pomString:= Extractdelimited((1*i)+(6*(i-1)),handSets,[',']);
     if pomString='' then exit;
     RadioGroup1.Items.Add(pomString);
   end;
 AdjustSize;
end;

end.

