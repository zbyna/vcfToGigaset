program vcfToGigaset;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, Unit1, pl_rx, pl_zeosdbo, pl_exsystem, lz_mouseandkeyinput,
  pl_kcontrols, pl_dcp, Unit2, unVyberHandsets, utf8tools, unNastaveni,
  unZjistiIp, lz_chmhelp, lz_rxbase, pl_virtualtrees, poweredby, unHledej,
  unUkazHistorii;

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TFormPolozkyPom, FormPolozkyPom);
  Application.CreateForm(TfrmVyberHandsets, frmVyberHandsets);
  Application.CreateForm(TfrmNastaveni, frmNastaveni);
  Application.CreateForm(TfrmUkazHistorii, frmUkazHistorii);
  Application.Run;
end.

