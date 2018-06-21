unit Unit2;

{$mode objfpc}{$H+}
{$modeswitch nestedprocvars}
interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls;

type

  { TFormPolozkyPom }

  TFormPolozkyPom = class(TForm)
    ButtonDalsi: TButton;
    ButtonOk: TButton;
    ButtonCancel: TButton;
    LblEditJmeno: TLabeledEdit;
    LblEditPrijmeni: TLabeledEdit;
    LblEditDomu: TLabeledEdit;
    LblEditPrace: TLabeledEdit;
    LblEditMobil: TLabeledEdit;
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  FormPolozkyPom: TFormPolozkyPom;

implementation

{$R *.frm}

{ TFormPolozkyPom }

procedure TFormPolozkyPom.FormShow(Sender: TObject);
begin
  LblEditJmeno.SetFocus;
end;

end.

