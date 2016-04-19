unit unNastaveni;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, KButtons, Forms, Controls, Graphics, Dialogs,
  StdCtrls, ExtCtrls, Grids, Buttons, IniPropStorage, unZjistiIp, DCPblowfish,
  DCPtwofish;

type

  { TfrmNastaveni }

  TfrmNastaveni = class(TForm)
    btnOk: TButton;
    btnCancel: TButton;
    btnZjistiIP: TKBitBtn;
    DCP_twofish1: TDCP_twofish;
    ulozeniNastaveniDoIni: TIniPropStorage;
    lblEditNazevLan: TLabeledEdit;
    lblEditIpAdress: TLabeledEdit;
    lblEditNazevGigasetNet: TLabeledEdit;
    lblEditMacAdresa: TLabeledEdit;
    lblEditPin: TLabeledEdit;
    procedure btnCancelClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure btnZjistiIPClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  frmNastaveni: TfrmNastaveni;

implementation

{$R *.lfm}



{ TfrmNastaveni }

procedure TfrmNastaveni.btnZjistiIPClick(Sender: TObject);
var
    pom : Byte;
begin
  // vytvořit frmZjistiIp;
  Application.CreateForm(TfrmZjistiIp, frmZjistiIp);
  //aktualizuje hodnoty  v závislosti na tom které tlačítko ukončí frmZjistiIp
  if frmZjistiIp.ShowModal = mrOK then
     begin
        pom:=frmZjistiIp.stringGrid1.Row;
        lblEditNazevLan.Text:=frmZjistiIp.stringGrid1.Cells[0,pom];
        lblEditIpAdress.Text:=frmZjistiIp.stringGrid1.Cells[1,pom];
        lblEditNazevGigasetNet.Text:=frmZjistiIp.stringGrid1.Cells[2,pom];
        lblEditMacAdresa.Text:=frmZjistiIp.stringGrid1.Cells[3,pom];
     end;
  // uvolnit frmZjistiIp z paměti
  APPlication.ReleaseComponent(frmZjistiIp);
end;

procedure TfrmNastaveni.FormCreate(Sender: TObject);
//var
   // iniciacniVektor : array[0..7] of byte;
   // i: Integer;
begin
  //for i:=0 to 7 do
  //    iniciacniVektor[i]:=Random(256);
  //DCP_blowfish1.Init('slavenka',16,nil);        //  @iniciacniVektor
  DCP_twofish1.Init('taktojetedaheslo',128,nil); // asi by bylo bezpečnější použít hash hesla
  // v binárkách musí být samozřejmě jiné heslo
  ulozeniNastaveniDoIni.Restore;
  lblEditPin.Text:=DCP_twofish1.DecryptString(lblEditPin.Text);
  // ShowMessage(lblEditPin.Text);
  DCP_twofish1.Reset;   // !!! bez resetu nejde dál šifrovat i dešifrovat korektně
end;

procedure TfrmNastaveni.FormShow(Sender: TObject);
begin
  ulozeniNastaveniDoIni.Restore;
  lblEditPin.Text:=DCP_twofish1.DecryptString(lblEditPin.Text);
  // ShowMessage(lblEditPin.Text);
  DCP_twofish1.Reset;  // !!! bez resetu nejde dál šifrovat i dešifrovat korektně
end;

procedure TfrmNastaveni.btnOkClick(Sender: TObject);

begin
  lblEditPin.Text:= DCP_twofish1.EncryptString(lblEditPin.Text);
  DCP_twofish1.Reset;
  // ShowMessage(lblEditPin.Text);
  ulozeniNastaveniDoIni.Save;
end;

procedure TfrmNastaveni.btnCancelClick(Sender: TObject);
begin
  lblEditPin.Text:= DCP_twofish1.EncryptString(lblEditPin.Text);
  DCP_twofish1.Reset;
  ulozeniNastaveniDoIni.Save;
end;

end.

