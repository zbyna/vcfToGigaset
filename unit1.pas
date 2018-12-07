unit Unit1;

{$mode objfpc}{$H+}
{$modeswitch nestedprocvars}
interface

uses
  Classes, SysUtils, db, fileutil, ZConnection, ZDataset, ZSqlUpdate,
  rxdbgrid, RxSortZeos,LazFileUtils,
  Forms, Controls, Graphics,
  Dialogs, DbCtrls, DBGrids, strutils, Menus, ComCtrls, ExtCtrls, ActnList,
  utf8scanner, Clipbrd, LCLIntf, {mainCEF,}
  cef3lcl, MouseAndKeyInput, LCLType, StdCtrls, usplashabout,
  uPoweredby, lazUTF8,
  {from former mainCEF}
   cef3types, cef3lib, cef3intf, cef3ref, cef3api, cef3own, process, types,
   cef3gui, gvector,typinfo,variants,unUkazHistorii,vte_edittree,VirtualTrees;

type

   { TCustomRenderProcessHandler }
   TCustomRenderProcessHandler = class(TCefRenderProcessHandlerOwn)
      protected
        function OnProcessMessageReceived(const browser: ICefBrowser;
          sourceProcess: TCefProcessId; const message: ICefProcessMessage): Boolean;
          override;
        procedure OnBrowserCreated(const browser: ICefBrowser); override;
      end;


   { extention for TRxDBGrid}
   { TRxDBGridHelper }

   TRxDBGridHelper = class helper for TRxDBGrid
                       procedure HideQuickFilter;
                       //procedure ShowQuickFilter;    // prostě nefunguje chyba v rx knihovně
                     end;

  //---začátek------objekty pro historii operací - deklarace typů------
   { TUndoNeboRedo }
   TUndoNeboRedo = (undo,redo);
   { TsqlTypProUndo }
  TsqlTypProUndo = (delete,insert);
  THodnoty = array[0..4] of String;
   { TPolozka }
   TPolozka = class
     operaceUndo:TsqlTypProUndo;
     operaceRedo:TsqlTypProUndo;
     hodnoty: Thodnoty;
     constructor create(op:TsqlTypProUndo; pomHodnoty:THodnoty);
   end;

    { TPolePolozek }
  TPolePolozek = specialize TVector<Tpolozka>;

  { THistoryItem }
  THistoryItem = class
     jmenoPolozky:String;
     polePolozek:TPolePolozek;
     constructor create(pomString:string;pomHodnoty:THodnoty;sqlTyp:TsqlTypProUndo);
     procedure operaceDoPolePolozek(pomHodnoty:Thodnoty;sqlTyp:TsqlTypProUndo);
     procedure operaceZPolePolozek( pomDs:TDataset;pomUnRe:TUndoNeboRedo;pomPol:Integer);
  end;
  { THistoryVector }
  THistoryVector = specialize Tvector<THistoryItem>;
  { THistory }
  THistory = class
     name:String;
     historyVector:THistoryVector;
     procedure printHistoryVector;
     constructor create(pomString:String);
  end;

  //----konec-------objekty pro historii operací - deklarace typů------

  { TForm1 }

  TForm1 = class(TForm)
    Action1: TAction;
    ActionList1: TActionList;
    ActionList2: TActionList;
    ApplicationProperties1: TApplicationProperties;  //   - z MainCEF
    BGo: TButton;         //                              - z MainCEF
    Button1: TButton;     // Add DOM listener             - z MainCEF
    Button2: TButton;     // V8 zkouška                   - z MainCEF
    Button3: TButton;     // Close browser                - z MainCEF
    Button4: TButton;     // LogOn + Directory            - z MainCEF
    Button5: TButton;     // Spusť JavaScript             - z MainCEF
    Button6: TButton;     // Directory to PC              - z MainCEF
    Button7: TButton;     // LogOff                       - z MainCEF
    Button8: TButton;     // Seznam do Tel                - z MainCEF
    Chromium: TChromium;  //                              - z MainCEF
    EUrl: TEdit;          //                              - z MainCEF
    JavaScript: TMemo;    //                              - z MainCEF
    LUrl: TStaticText;    //                              - z MainCEF
    Memo1: TMemo;         //                              - z MainCEF
    DataSource1: TDataSource;
    DBNavigator1: TDBNavigator;
    ImageListPoUp: TImageList;
    ImageListToolBar: TImageList;
    ImageListHlavniMenu: TImageList;
    MainMenu1: TMainMenu;
    Memo2: TMemo;
    MenuItemShowHistoryBuffer: TMenuItem;
    MenuItemRedo: TMenuItem;
    MenuItemUndo: TMenuItem;
    MenuItemHistorie: TMenuItem;
    MenuItemPomoc: TMenuItem;
    MenuItemOProgramu: TMenuItem;
    MenuItemEditaceSmazatVyber: TMenuItem;
    MenuItemNastrojeImport: TMenuItem;
    MenuItemNastaveni: TMenuItem;
    MenuItemNastrojeImportGigasetSluchatko: TMenuItem;
    MenuItemNastrojeImportGoogleMailVcf: TMenuItem;
    MenuItemNastrojeImportNormalVcf: TMenuItem;
    MenuItemNastrojeExportVyberuNormalVcf: TMenuItem;
    MenuItemNastrojeExportVyberuGigasetSluchatko: TMenuItem;
    MenuItemNastrojePrijmeniDoJmeno: TMenuItem;
    MenuItemNastrojeExportVyberu: TMenuItem;
    MenuItemEditaceVybratVse: TMenuItem;
    MenuItemEditaceVlozitRadek: TMenuItem;
    MenuItemEditaceEditaceTabuky: TMenuItem;
    MenuItemNastroje: TMenuItem;
    MenuItemEditace: TMenuItem;
    MenuItemViditelnostSloupcu: TMenuItem;
    MenuItemTrideniPodleSloupcu: TMenuItem;
    MenuItemHledejData: TMenuItem;
    MenuItemFiltrujDataVeFormulari: TMenuItem;
    MenuItemVypniFiltr: TMenuItem;
    MenuItemTabulka: TMenuItem;
    MenuItemExportNormal: TMenuItem;
    MenuItemExportGigaset: TMenuItem;
    MenuItemImportGigaset: TMenuItem;
    MenuItemHledej: TMenuItem;
    MenuItemPrijmeniDoJmeno: TMenuItem;
    MenuItemExport: TMenuItem;
    MenuItemInzert: TMenuItem;
    MenuItemDelete: TMenuItem;
    MenuItemEdit: TMenuItem;
    MenuItemImportGoogle: TMenuItem;
    MenuItemImportNormal: TMenuItem;
    MenuItemImport: TMenuItem;
    MenuItemSoubor: TMenuItem;
    MenuItemUkoncit: TMenuItem;
    MenuItemNovy: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItemOtevrit: TMenuItem;
    MenuItemOtevritNedavne: TMenuItem;
    MenuItemUlozit: TMenuItem;
    MenuItemUlozitJako: TMenuItem;
    MenuItemZavrit: TMenuItem;
    MenuItem9: TMenuItem;
    OpenDialog1: TOpenDialog;
    PageControl1: TPageControl;
    PopupMenu1: TPopupMenu;
    Poweredby1: TPoweredby;
    ProgressBar1: TProgressBar;
    RxDBGrid1: TRxDBGrid;
    RxSortZeos1: TRxSortZeos;
    SaveDialog1: TSaveDialog;
    SplashAbout1: TSplashAbout;
    StatusBar1: TStatusBar;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButtonHledej: TToolButton;
    ToolButton6: TToolButton;
    ToolButtonInsert: TToolButton;
    ToolButton3: TToolButton;
    ToolButtonDelete: TToolButton;
    ToolButton5: TToolButton;
    ToolButtonOtevritNedavne: TToolButton;
    ToolButton2: TToolButton;
    ToolButtonEdit: TToolButton;
    ToolButtonExport: TToolButton;
    ToolButton11: TToolButton;
    ToolButtonUkoncit: TToolButton;
    ToolButton13: TToolButton;
    ToolButton14: TToolButton;
    ToolButton15: TToolButton;
    ToolButton17: TToolButton;
    ToolButton18: TToolButton;
    ToolButton19: TToolButton;
    ToolButtonNew: TToolButton;
    ToolButton20: TToolButton;
    ToolButtonOtevrit: TToolButton;
    ToolButtonUlozit: TToolButton;
    ToolButtonUlozitJako: TToolButton;
    ToolButtonImport: TToolButton;
    ToolButtonZavrit: TToolButton;
    ToolButton9: TToolButton;
    ZConnection1: TZConnection;
    ZQuery1: TZQuery;
    ZUpdateSQL1: TZUpdateSQL;
    procedure Action1Update(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
                              {test na odhlášení od základny a neuloženou změnu v souboru}
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure MenuItemDeleteClick(Sender: TObject);       {popup - Smaže výběr}
    procedure MenuItemEditaceEditaceTabukyClick(Sender: TObject);
    procedure MenuItemEditaceSmazatVyberClick(Sender: TObject);
    procedure MenuItemEditaceVlozitRadekClick(Sender: TObject);
    procedure MenuItemEditaceVybratVseClick(Sender: TObject);
    procedure MenuItemEditClick(Sender: TObject);         {popup - Zap/Vyp Editace}
    procedure MenuItemExportGigasetClick(Sender: TObject);{popup - export ze sluchátka Gigaset}
    procedure MenuItemExportNormalClick(Sender: TObject); {popup - export z vcf souboru}
    procedure MenuItemFiltrujDataVeFormulariClick(Sender: TObject);
    procedure MenuItemHistorieClick(Sender: TObject);
    procedure MenuItemHledejDataClick(Sender: TObject);
    procedure MenuItemImportGigasetClick(Sender: TObject);{popup - import ze sluchátka Gigaset}
    procedure MenuItemImportGoogleClick(Sender: TObject); {popup - Import z vcf Google}
    procedure MenuItemImportNormalClick(Sender: TObject); {popup - Import z vcf MenuItemExportNormal}
    procedure MenuItemHledejClick(Sender: TObject);
    procedure MenuItemInzertClick(Sender: TObject);       {popup - Vloží řádek}
    procedure MenuItemNastaveniClick(Sender: TObject);
    procedure MenuItemNastrojeExportVyberuGigasetSluchatkoClick(Sender: TObject
      );
    procedure MenuItemNastrojeExportVyberuNormalVcfClick(Sender: TObject);
    procedure MenuItemNastrojeImportGigasetSluchatkoClick(Sender: TObject);
    procedure MenuItemNastrojeImportGoogleMailVcfClick(Sender: TObject);
    procedure MenuItemNastrojeImportNormalVcfClick(Sender: TObject);
    procedure MenuItemNastrojePrijmeniDoJmenoClick(Sender: TObject);
    procedure MenuItemNovyClick(Sender: TObject);          {menu soubor - Nový}
    procedure MenuItemOProgramuClick(Sender: TObject);
    procedure MenuItemOtevritClick(Sender: TObject);       {menu soubor - Open}
    procedure MenuItemOtevritNedavneClick(Sender: TObject);{menu soubor - Otevřít nedávné}
    procedure MenuItemPomocClick(Sender: TObject);
    procedure MenuItemRedoClick(Sender: TObject);
    procedure MenuItemShowHistoryBufferClick(Sender: TObject);
    procedure MenuItemTrideniPodleSloupcuClick(Sender: TObject);
    procedure MenuItemUndoClick(Sender: TObject);
    procedure MenuItemViditelnostSloupcuClick(Sender: TObject);
    procedure MenuItemVypniFiltrClick(Sender: TObject);
    procedure MenuItemPrijmeniDoJmenoClick(Sender: TObject); {popup - Příjmení do Jméno}
    procedure MenuItemSouborClick(Sender: TObject);
    procedure MenuItemUlozitClick(Sender: TObject);        {menu soubor - Save}
    procedure MenuItemUlozitJakoClick(Sender: TObject);    {menu soubor - Save As}
    procedure MenuItemZavritClick(Sender: TObject);        {menu soubor - Close}
    procedure MenuItemUkoncitClick(Sender: TObject);       {menu soubor - Ukončit}
    procedure OpenDialog1CanClose(Sender: TObject; var CanClose: boolean);
    procedure PopupMenu1Popup(Sender: TObject);      {přístupnost položek popup menu}
    procedure RxDBGrid1MouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure ToolButtonEditClick(Sender: TObject);        {ToolBar - Zap/Vyp Editace}
    Procedure UlozZmenySQL;  {Uloží změny do databáze (souboru) transakčně}
    Procedure VlozDoHistoryFiles(PomString:string);  {aktualizace HistoryFiles objektu}
    Procedure MojeOnClick(sender:TObject); {handler pro položky menu soubor - Otevřít nedávné}
    procedure RxDBGrid1CellClick(Column: TColumn);
    procedure RxDBGrid1ShiftSelect(Sender: TObject; existingBookmarks: TBookmark);
                                                         {dovolí výběr clik + SHIFT}
    procedure nahradDiakritiku(var retezec:String);
    function najdiDuplicity(pJme,pPri,pDom,pPra,pMob:String):Boolean;
                                          {hledá duplicity v databázi před uložením}
    procedure ZQuery1AfterDelete(DataSet: TDataSet); // pro sledování zmenaVDatabazi
    procedure ZQuery1AfterEdit(DataSet: TDataSet);
    procedure ZQuery1AfterInsert(DataSet: TDataSet);
    procedure ZQuery1AfterPost(DataSet: TDataSet);// pro sledování zmenaVDatabazi

    // *********************************************************   from former mainCEF
    // *********************************************************   BEGIN
    procedure BGoClick(Sender : TObject);
    procedure Button1Click(Sender: TObject); // for adding mouse event DOM listener
    procedure Button2Click(Sender: TObject); // message z browser procesu do render procesu
    // s žádostí o hodnotu z javascriptu
    procedure Button3Click(Sender: TObject); // korektní uzavření prohlížeče
    procedure Button4Click(Sender: TObject); // vyplní heslo, přihlásí se a iniciuje
    // pomocí chromiumloadend nahrání settings_phonebook_transfer.html :-)
    procedure Button5Click(Sender: TObject); // vykoná javascript z Tmemo Javascript
    procedure Button6Click(Sender: TObject); // seznam z vybraného sluchátka do pc
    procedure Button7Click(Sender: TObject); // LogOff
    procedure Button8Click(Sender: TObject); // seznam z pc do vybraného sluchátka
    procedure ChromiumBeforeDownload(Sender: TObject;
      const Browser: ICefBrowser; const downloadItem: ICefDownloadItem;
      const suggestedName: ustring; const callback: ICefBeforeDownloadCallback);
    procedure ChromiumDownloadUpdated(Sender: TObject;
      const Browser: ICefBrowser; const downloadItem: ICefDownloadItem;
      const callback: ICefDownloadItemCallback);
    procedure ChromiumFileDialog(Sender: TObject; const Browser: ICefBrowser;
      mode: TCefFileDialogMode; const title, defaultFileName: ustring;
      acceptFilters: TStrings; selectedAcceptFilter: Integer;  const callback: ICefFileDialogCallback; out
      Result: Boolean);
    procedure ChromiumKeyEvent(Sender: TObject; const Browser: ICefBrowser;
      const event: PCefKeyEvent; osEvent: TCefEventHandle; out Result: Boolean);
    procedure ChromiumLoadEnd(Sender : TObject; const Browser : ICefBrowser;
      const Frame : ICefFrame; httpStatusCode : Integer);
    procedure ChromiumProcessMessageReceived(Sender: TObject;
      const Browser: ICefBrowser; sourceProcess: TCefProcessId;
      const message: ICefProcessMessage; out Result: Boolean);
    procedure ChromiumTitleChange(Sender : TObject;
      const Browser : ICefBrowser; const title : ustring);
    procedure EUrlKeyDown(Sender : TObject; var Key : Word;
      Shift : TShiftState);
    procedure spustUpload(Data: PtrInt); // pomocná pro application.procedure QueueAsyncCall
    procedure ZQuery1AfterScroll(DataSet: TDataSet); // pro vyběr SHIFT+kolečko a
    procedure ZQuery1BeforeDelete(DataSet: TDataSet);
    procedure ZQuery1BeforeEdit(DataSet: TDataSet);
    procedure ZQuery1BeforeInsert(DataSet: TDataSet);
    procedure ZQuery1BeforePost(DataSet: TDataSet);
    // zrušení označení první řádku při pohybu kolečkem
    procedure ZQuery1BeforeScroll(DataSet: TDataSet);  // pro vyběr SHIFT+kolečko a
    procedure ZQuery1PostError(DataSet: TDataSet; E: EDatabaseError;
      var DataAction: TDataAction);
    // zrušení označení první řádku při pohybu kolečkem
    // *********************************************************  from former mainCEF
   // *********************************************************   END
  private
    { private declarations }
  public
    //---začátek------objekty pro historii operací - deklarace proměnných----
    historyItem:THistoryItem;
    undoPolozky:THistory;
    redoPolozky:THistory;
    multiPolozkaHistorie:Boolean; //  více prvků v historyItem.polePolozek
    probihaUndo:Boolean; // vybráno menu Historie/Undo
    probihaRedo:Boolean; // vybráno menu Historie/Redo
    //---konec------objekty pro historii operací - deklarace proměnných------
  end;

var
  Form1: TForm1;
  // *********************************************************   from former mainCEF
   // *********************************************************  BEGIN
  mujGlobalBrowser:ICefBrowser; //  browser object for render process
  mujClickListener:Boolean; // switch for click listener
  prihlaseno:Boolean; // přihlášeno v web rozhraní telefonu
  reloadPoOdhlaseni:Boolean; // reload login obrazovky po odhlašení nesmí znovu zalogovat
  jsemVHome:Boolean; // jsem v Home adresáři web rozhraní telefonu
  jsemVDirectory:Boolean; // jsem v Directory stránce web rozhraní telefonu
  seznamDoPocitace:Boolean; // nahrej seznam z vybraného sluchátka do počítače
  seznamDoTelefonu:Boolean;  // nahrej seznam z počítač do vybraného sluchátka
  handSets:string; // názvy + porty sluchátek ze základny


  // *********************************************************   from former mainCEF
   // *********************************************************  END
implementation
   uses unVyberHandsets {from mainCEF},unit2,unNastaveni,unHledej;
{$R *.frm}
var
 HistoryFiles:TStringList;   {seznam naposledy otevřených souborů}
 JmenoAktSoubor:String;      {jméno aktuálně otevřeného souboru *.fdb}
 importZSluchatka:Boolean;   {importuje se ze sluchátka ?}
 exportDoSluchatka:Boolean;   {exportuje se do sluchátka ?}
 ZmenaVDatabazi:boolean;  {byla změněná základní tabulka ?, pravděpodobně navíc z projektu
                              XBMC Media Stub Creator, UPDATE uz dává :-) deaktivaloval jsem
                              ZConnection1.AutoCommit }
 previousGridBookmark: TBookMark; {pro výběr pomocí SHIFT+Click}
 kolecko:Boolean; // pro onMouseWheel, přepínač pro výběr pomocí shift a kolečka a



                  // zrušení označeí první řádku při pohybu kolečkem
{ extention for TRxDBGrid}
{ TRxDBGridHelper }

procedure TRxDBGridHelper.HideQuickFilter;
begin
   OnFilterClose(self);
  // OptionsRx:=OptionsRx - [rdgFilter]
end;

//procedure TRxDBGridHelper.ShowQuickFilter;
//begin    // z procedury DoShowQuickFilter v rxdbgrid.pas (rxdbgrid unit)
//  if not (rdgAllowQuickFilter in  OptionsRx) then  // původně ... in FOptionsRx a to nefunguje!!
//      exit;
//    OnFilter(self);
//end;

//---začátek------objekty pro historii operací - implementace------

{ TPolozka }

constructor TPolozka.create(op:TsqlTypProUndo; pomHodnoty:THodnoty);

begin
  self.operaceUndo:=op;
  case op of
   insert:self.operaceRedo:= delete ;
   delete:self.operaceRedo:= insert ;
  end;
  self.hodnoty:=pomHodnoty;
end;

{ THistory }

constructor THistory.create(pomString:String);
begin
  self.name:=pomString;
  self.historyVector:=THistoryVector.Create;
end;

procedure THistory.printHistoryVector; // upravit podle potřeby
var
  i, j, k: Integer;
  pomStr:String;
  v:THistoryVector;
  VET:TVirtualEditTree;
  Data: PTreeData;
  XNodeRoot, XNodeSezona, XNodeDisk, XnodeDil : PVirtualNode;
begin
  if self.name = 'Undo Buffer Items' then VET:= frmUkazHistorii.VET
                               else VET := frmUkazHistorii.vetRedo ;
  VET.Header.Columns.Items[0].Text:= self.name + ': '+
        inttostr(self.historyVector.Size);
  if self.historyVector.Size = 0 then
    begin
      Form1.Memo2.Append(timetostr(Time)+' '+self.name + ' je prázdný');
      VET.DeleteChildren(VET.RootNode,true);
      XNodeRoot:=VET.AddChild(nil);
      Data:=VET.GetNodeData(XNodeRoot);
      Data^.Column0:='Empty';
      exit;
    end;
  //pomStr:=timetostr(Time)+' --------------- '+self.name+LineEnding;
  v:=self.historyVector;
  if VET.RootNodeCount <> 0 then VET.DeleteChildren(VET.RootNode,true);
  XNodeRoot:=VET.AddChild(nil);
  if VET.AbsoluteIndex(XNodeRoot) > -1 then
  Begin
   Data := VET.GetNodeData(XnodeRoot);
   Data^.Column0:= self.name;
  End;
  for i:=0 to v.Size-1 do
    begin
     XNodeSezona:= VET.AddChild(XNodeRoot);
     Data := VET.GetNodeData(XNodeSezona);
     Data^.Column0:= v[i].jmenoPolozky + LineEnding;
      for j:=0 to v[i].polePolozek.Size-1 do
        begin
         if self.name = 'Undo Buffer Items' then
         pomStr:= ' '+inttostr(j)+' operationUndo: ' +
         GetEnumName(Typeinfo(TsqlTypProUndo),ord(v[i].polePolozek[j].operaceUndo))
                                      else
         pomStr:= ' '+inttostr(j)+' operationRedo: '+
         GetEnumName(Typeinfo(TsqlTypProUndo),ord(v[i].polePolozek[j].operaceRedo))+
         LineEnding + ' value of fields:'+LineEnding;
         XNodeDisk:= VET.AddChild(XNodeSezona);
         Data := VET.GetNodeData(XNodeDisk);
         Data^.Column0:= pomStr;
         for k:=0 to 4 do
           begin
            pomStr:= '  ' + inttostr(k)+': ' +
            v[i].polePolozek[j].hodnoty[k]+LineEnding;
            XnodeDil:=vet.AddChild(XNodeDisk);
            Data:=vet.GetNodeData(XnodeDil);
            Data^.Column0:=pomStr;
           end;
          VET.Expanded[XNodeDisk]:=True;
        end;
      VET.Expanded[XNodeSezona]:=True;
    end;
  VET.Expanded[XNodeRoot]:=True;
  //Form1.Memo2.Append(pomStr+'-----------------------------------');
end;


{ THistoryItem }

constructor THistoryItem.create(pomString: string;pomHodnoty:THodnoty;sqlTyp:TsqlTypProUndo);
begin
  self.jmenoPolozky:=pomString;
  self.polePolozek:=TPolePolozek.Create;
  self.polePolozek.PushBack(TPolozka.create(sqlTyp,pomHodnoty));
end;

procedure THistoryItem.operaceDoPolePolozek(pomHodnoty: Thodnoty;
  sqlTyp: TsqlTypProUndo);

begin
  self.polePolozek.PushBack(TPolozka.create(sqlTyp,pomHodnoty));
end;

procedure THistoryItem.operaceZPolePolozek( pomDs: TDataset;pomUnRe:TUndoNeboRedo;pomPol:integer);
var
  i: Integer;
  v:variant;
  pomOperace:TsqlTypProUndo;
begin
  case pomUnRe of
    undo: pomOperace:=self.polePolozek.Items[pomPol].operaceUndo;
    redo: pomOperace:=self.polePolozek.Items[pomPol].operaceRedo;
  end;
  case pomOperace of
   insert:
          begin
           pomDs.Insert;
           for i:=0  to 4 do
             pomDs.Fields[i].AsString:= self.polePolozek.Items[pomPol].hodnoty[i];
           pomDs.Post;
          end;
   delete:
        begin
          v:=VarArrayCreate([0,4],varvariant);
          for i:=0  to 4 do
             v[i]:= self.polePolozek.Items[pomPol].hodnoty[i];
          pomDs.Locate('PRIJMENI;JMENO;DOMU;PRACE;MOBIL',v,[loCaseInsensitive]);
          pomDs.Delete
        end
  end;
  //self.polePolozek.PopBack;
end;

//----konec-------objekty pro historii operací - implementace------

{ TForm1 }

procedure TForm1.VlozDoHistoryFiles(PomString: string);
var
  i: byte;
begin
  for i:=HistoryFiles.Count-1 downto 1  do
    HistoryFiles.Strings[i] := HistoryFiles.Strings[i-1];
  HistoryFiles.Strings[0] := UTF8ToSys(PomString);
  HistoryFiles.SaveToFile('history.txt');
end;

procedure TForm1.FormCreate(Sender: TObject);
var
 PomMenu : TMenuItem;
 i: Integer;

begin     ///   TForm1.FormCreate
 SplashAbout1.ShowSplash;
 kolecko:=true;// pro zrušení označení řádku od kterého se roluje kolečkem myši
 Randomize; // pro kodování v unNastavení
 Form1.Caption:= 'Phone Book for Gigaset 610,620H  ';
 //StatusBar1.Panels[0].Text:='Seřazeno dle:  ';
 //GlobalSwitch:=true;
 ProgressBar1.Hide;
 importZSluchatka:= False; // aby fungoval InportClickNormal
 exportDoSluchatka:= False; // aby fungoval Export
 {vytvoř položky menu  soubor - Otevřít nedávné ------ začátek}
 MenuItemOtevritNedavne.Clear;
 PomMenu := TmenuItem.create(Self);
 HistoryFiles := Tstringlist.create;
 HistoryFiles.LoadFromfile('history.txt');
 for i:=0 to HistoryFiles.Count-1 do
  begin
    PomMenu := TmenuItem.create(Self);
    PomMenu.Caption :=SysToUTF8( HistoryFiles.Strings[i]);
    PomMenu.OnClick := @MojeOnClick;
    MenuItemOtevritNedavne.Add(PomMenu);
  end;
 {vytvoř položky menu  soubor - Otevřít nedávné  ------ konec}

 // ******************************************************** from former mainCEF
 // ********************************************************* BEGIN
  prihlaseno:=False;
  reloadPoOdhlaseni:=false;
  jsemVHome:=False;
  jsemVDirectory:=False;
  seznamDoPocitace:=False;
  seznamDoTelefonu:=False;
  handSets:='';
  JavaScript.Text:='var r = browseButton.getBoundingClientRect();'+
                   'alert("Top/Left: "+r.top+" / "+r.left);'+
                   'alert("Right/Bottom: "+r.right+" / "+r.bottom);';

  mujClickListener:=false;
  CefSingleProcess:=false;
  {$INFO Uncomment to use a subprocess} // vyžaduje exáč z \Lazarus - Pokusy\CEF3\
  CefBrowserSubprocessPath := '.' + PathDelim + 'subprocess'{$IFDEF WINDOWS}+'.exe'{$ENDIF};
  //CefRenderProcessHandler := TCustomRenderProcessHandler.Create; // pro přístup k DOM

Chromium.visible:=false; // přechodně se musí zneviditelnit,
// (Chromium.visible:=true je v TForm1.FormShow()) protože po upgradu
// na poslední verzi CEFu (3.2454) neprojde nějakou kontrolou lcl viz. chyba:
// EInvalidOperation.Create(SCannotFocus) line 1838 file customform.inc,
// a nastavit v Form1.Show - zřejmě to pošlu dliwovi jako bug
// update: nevypadá to jako bug, spíše se něco táhne z minulé verze mého
// projektu, v nové pokusu, kde jsou pouze taby a v druhém Chromium to
// nezlobí :-)

//Chromium.enabled:=false;

 // ******************************************************** from former mainCEF
 // ********************************************************* END
 //---začátek-------objekty pro historii operací------
    undoPolozky:=THistory.Create('Undo Buffer Items');
    redoPolozky:=THistory.Create('Redo Buffer Items');
    multiPolozkaHistorie:=False;
    probihaUndo:=False;
    probihaRedo:=False;
   //---konec---------objekty pro historii operací------
end;      ///   TForm1.FormCreate

procedure TForm1.Action1Update(Sender: TObject);
// OBROVSKY DULEŽITÉ:
// TCustomAction.DisableIfNoHandler musí být false (default je true)
// jinak se po druhém clicku na holý Form1 aplikace zasekne
// tzn. formálně běží, ale nereaguje, zřejmě používáš Action jinak než
// jsou zamýšlené :-) viz.
// http://docs.embarcadero.com/products/rad_studio/radstudio2007/RS2007_helpupdates/HUpdate4/EN/html/delphivclwin32/ActnList_TCustomAction_DisableIfNoHandler.html
begin
  if  JmenoAktSoubor='' then
   begin
    ToolButtonUlozit.Enabled:=false;
    ToolButtonUlozitJako.Enabled:=false;
    ToolButtonZavrit.Enabled:=false;
    ToolButtonImport.Enabled:=false;
    ToolButtonExport.Enabled:=false;
    ToolButtonInsert.Enabled:=false;
    ToolButtonEdit.Enabled:=false;
    ToolButtonDelete.Enabled:=false;
    ToolButtonHledej.Enabled:=false;
    MenuItemTabulka.Enabled:= False;
    MenuItemEditace.Enabled :=False;
    MenuItemNastroje.Enabled := False;
   end
                       else
   begin
    ToolButtonUlozit.Enabled:=true;
    ToolButtonUlozitJako.Enabled:=true;
    ToolButtonZavrit.Enabled:=true;
    ToolButtonImport.Enabled:=true;
    ToolButtonExport.Enabled:=true;
    ToolButtonInsert.Enabled:=true;
    ToolButtonEdit.Enabled:=true;
    ToolButtonDelete.Enabled:=true;
    ToolButtonHledej.Enabled:=true;
    If ToolButtonEdit.Down then
                              begin
                               MenuItemDelete.Enabled:=False;
                               ToolButtonDelete.Enabled:=False;
                              end
                          else
                              begin
                               MenuItemDelete.Enabled:=True;
                               ToolButtonDelete.Enabled:=True;
                              end;
   MenuItemTabulka.Enabled := True;
   MenuItemEditace.Enabled :=True;
   MenuItemNastroje.Enabled := True;
   StatusBar1.Panels.Items[1].Text:='Records number: '+inttostr(ZQuery1.RecordCount);
   end;
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  CanClose:= not (prihlaseno or ZmenaVDatabazi); {test na odhlášení od základny a }
  if prihlaseno then                              {neuloženou změnu v souboru}
     begin
        Form1.TabSheet2.Show;
        case QuestionDlg('Connection with base station is active !!!',
          'Before quitting is needed to logoff', mtWarning,
          [mrYes, 'Logoff ', mrNo, 'Do not logoff'], 0) of
          mrYes: Button7.Click ;
          mrNo: ;
        end;
     end;
  if ZmenaVDatabazi then MenuItemZavrit.Click;
//  RxDBGrid1.KeyStrokes;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  HistoryFiles.SaveToFile('history.txt');
end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
  );
begin
  // tůze rychlé pro pro položku menu,stačí nastavit shortcut pro menu
   // souvisí s keyPreview property formuláře
  //if (Shift = [ssCtrl]) and (key = ord('Z')) then Form1.MenuItemUndo.Click;
  //if (Shift = [ssCtrl,ssShift]) and (key = ord('Z')) then
  //       Form1.MenuItemRedo.Click;

end;

procedure TForm1.FormShow(Sender: TObject);
begin
   //Chromium.enabled:=True;
   Chromium.visible:=True;
   //Chromium.TabStop:=True; // těžko říct, ale napoprvé to pomohlo při updatu na poslední verzi CEFu
   //Chromium.TabOrder:=1;   // těžko říct, ale napoprvé to pomohlo při updatu na poslední verzi CEFu
   //Chromium.Load('file:///obr.png');
end;

procedure TForm1.MenuItemDeleteClick(Sender: TObject); {popup - Smaže výběr}
var
  i: Integer;
begin

  for i:=RxDBGrid1.SelectedRows.Count-1 downto 0  do
  begin
    ZQuery1.GotoBookmark(RxDBGrid1.SelectedRows.Items[i]);
    ZQuery1.Delete;
  end;
  //ZQuery1.Refresh;                              // aby fungovaly bookmarky
  Rxdbgrid1.SelectedRows.Clear;                   // a šlo ihned bez
  Rxdbgrid1.SelectedRows.CurrentRowSelected:=true;// překliknutí mazat
  RxDBGrid1CellClick(RxDbgrid1.SelectedColumn);  // aby šlo ihned vybírat pomocí SHIFT

end;

procedure TForm1.MenuItemEditaceEditaceTabukyClick(Sender: TObject);
begin
  MenuItemEdit.Click;
end;

procedure TForm1.MenuItemEditaceSmazatVyberClick(Sender: TObject);
begin
  MenuItemDelete.Click;
end;

procedure TForm1.MenuItemEditaceVlozitRadekClick(Sender: TObject);
begin
  MenuItemInzert.Click;
end;

procedure TForm1.MenuItemEditaceVybratVseClick(Sender: TObject);
begin
   RxDBGrid1.SelectAllRows;
end;

procedure TForm1.MenuItemEditClick(Sender: TObject); {popup - Zap/Vyp Editace}
begin
  ToolButtonEdit.Down:=not(ToolButtonEdit.Down);
  ToolButtonEdit.Click;
end;

procedure TForm1.MenuItemExportGigasetClick(Sender: TObject);
begin
  // TODO: je potřeba dodělat TForm1.MenuItemExportGigasetClick
  // nastaví exportDoSluchatka na true
  //  - MenuItemExportNormalClick pozná, že má exportovat do souboru aaaaa.vcf
  //     (když bude false otevře dialog na výběr souboru pro export tzn. byla volána z popup
  //     položky MenuItemExportNormalClick )
  //   - TForm1.ChromiumFileDialog na page2 pozná, že má odesílát soubor aaaaa.vcf
  //     (když bude false otevře dialog na výběr souboru pro nahrání do telefonu tzn.
  //      byla volána z buttonu na page2)
  // zavolá MenuItemExportNormalClick pro export
  // pak nastaví pamarametry podle TForm1.Button8Click(Sender: TObject)
  Form1.TabSheet2.Show;  // zobrazit okno prohlížeče (cef3)
  if frmNastaveni.lblEditIpAdress.Text = '' then
     begin
       MessageDlg('IP adress of base is empty,'+LineEnding+
       'fill in it in Settings', mtWarning, [mbOK],0);
       exit;
     end;
  exportDoSluchatka:=true; // globání proměnná,aby fungoval z page1 i normální export i click
                           // na buton v page2 s prohlížečem tzn TForm1.Button8Click(Sender: TObject);
  MenuItemExportNormal.Click;  // volá procedůru TForm1.MenuItemExportNormalClick()
  // nastavení parametrů podle TForm1.Button8Click(Sender: TObject)

   Chromium.Load(UTF8ToUTF16('http://'+frmNastaveni.lblEditIpAdress.Text +'/login.html'));
   if not prihlaseno then      // důležité - může být přihlášeno
   begin
     prihlaseno:=False;
   end ;
   jsemVHome:=False;
   jsemVDirectory:=False;
   seznamDoTelefonu:=true;  // tady je přepínač :-)
end;

procedure TForm1.MenuItemExportNormalClick(Sender: TObject);   {popup - Export do vcf}
var
  i: Integer;
  seznamStringu:TStringList;
  jmenoSouboru:String;
  diakritika:Boolean;
  pomPrijmeni: String;
  pomJmeno: String;
  str:WideString;
  // TODO: potřeba upravit: TForm1.MenuItemExportNormalClick
  // když bude exportDoSluchatka true tak exportovat do aaaaa.vcf jinak vyvolat
  // dialog na výběr souboru nebo ponechat stávající metodu - rozmysli si to zbyňo :-)
begin
  if MessageDlg('Without diacritics ?', mtConfirmation, [mbYes, mbNo],0) = mrYes
           then  diakritika:=True
           else  diakritika:=False;
  seznamStringu:=TStringList.Create;
  for i:=0 to RxDBGrid1.SelectedRows.Count-1 do
   begin
     ZQuery1.GotoBookmark(RxDBGrid1.SelectedRows.Items[i]);
     seznamStringu.add('BEGIN:VCARD');
     seznamStringu.add('VERSION:2.1');
     pomPrijmeni:= ZQuery1.FieldByName('PRIJMENI').asString;
     pomJmeno:= ZQuery1.FieldByName('JMENO').asString;
     if diakritika then
         begin
          nahradDiakritiku(pomPrijmeni);
          nahradDiakritiku(pomJmeno);
         end;
     seznamStringu.add('N:'+utf8tosys(pomPrijmeni)+';'+utf8tosys( pomJmeno));
     seznamStringu.add('TEL;HOME:'+utf8tosys(ZQuery1.FieldByName('DOMU').asString));
     seznamStringu.add('TEL;WORK:'+utf8tosys(ZQuery1.FieldByName('PRACE').asString));
     seznamStringu.add('TEL;CELL:'+utf8tosys(ZQuery1.FieldByName('MOBIL').asString));
     seznamStringu.add('END:VCARD');
     seznamStringu.add('')
   end;
   if exportDoSluchatka then
      begin
         CefGetPath(PK_DIR_EXE,str);
         str:=str+PathDelim+'aaaaa.vcf';
         jmenoSouboru := UTF16toUTF8(str);  // zřejmně by mělo být všude kde jde widechar(UTF16)
                                            //  do utf8
         seznamStringu.SaveToFile(jmenoSouboru);
      end
                         else
      begin
        jmenoSouboru:= ExtractFileNameWithoutExt(JmenoAktSoubor);
        seznamStringu.SaveToFile(utf8tosys(jmenoSouboru+'.vcf'));
        case QuestionDlg('Export to vcf was finished', 'Export was save to the file: '+jmenoSouboru+'.vcf'
        +LineEnding+'file name was coppied to clipboard', mtInformation,[mrYes, 'Ok', mrNo, 'Open in Explorer', mrCancel, 'Open www of telefon base'], 0) of
          mrYes: ;
          mrNo:OpenDocument(ExtractFileDir(jmenoSouboru)  );
          mrCancel: begin
                     OpenURL('http://192.168.1.130');
                     Clipboard.AsText:=jmenoSouboru+'.vcf'
                    end;
        end;
      end;
  seznamStringu.Destroy;
end;

procedure TForm1.MenuItemFiltrujDataVeFormulariClick(Sender: TObject);
begin
  RxDBGrid1.ShowFilterDialog;
end;

procedure TForm1.MenuItemHistorieClick(Sender: TObject);
begin
 if undoPolozky.historyVector.Size=0 then MenuItemUndo.Enabled:=false
                                     else MenuItemUndo.Enabled:=true;
 if redoPolozky.historyVector.Size=0 then MenuItemRedo.Enabled:=false
                                     else MenuItemRedo.Enabled:=true;
end;

procedure TForm1.MenuItemHledejDataClick(Sender: TObject);
begin
  // RxDBGrid1.ShowFindDialog; // volání rutiny v rxDBGrid1 - není povedená podle mě :-)
  Application.CreateForm(TfrmHledej,frmHledej);
  frmHledej.Show;
end;

procedure TForm1.MenuItemImportGigasetClick(Sender: TObject);{import ze sluchátka Gigaset}

begin
  // přidává záznamy do otevřené tabulky (když není otevřená import menu není aktivní)
  // počkat dokud není stáhnuto, pozná se zřejmě jedině podle TForm1.ChromiumDownloadUpdated
  // tam nastavit globální bool proměnnou  importZSluchatka na true a zavolat
  // MenuItemImportNormal.Click (když bude false pak se použije open dialog viz.
  //  MenuItemImportNormalClick :-) )) a
  Form1.TabSheet2.Show;  // zobrazit okno prohlížeče (cef3)
   if frmNastaveni.lblEditIpAdress.Text = '' then
     begin
       MessageDlg('IP adress of the telephone base is empty,'+LineEnding+
       'fill it in application settings please', mtWarning, [mbOK],0);
       exit;
     end;
   importZSluchatka:= True;  // globání proměnná,aby fungoval z page 1 i normální import, i click na buton
                             // v page2 s prohlížečem, i
   Chromium.Load(UTF8ToUTF16('http://'+frmNastaveni.lblEditIpAdress.Text +'/login.html'));
   if not prihlaseno then      // důležité - může být přihlášeno
   begin
     prihlaseno:=False;
   end ;
   jsemVHome:=False;
   jsemVDirectory:=False;
   seznamDoPocitace:=true;  // tady je přepínač :-) pro doputování v do Direcories v prohlížeči

end;

procedure TForm1.MenuItemImportNormalClick(Sender: TObject); {import z vcf normální (win1250)}
var
  i: Integer;
  seznamStringu:TStringList;
  jmenoSouboru:String;
  str:WideString;
  PomS: String;
  pomPosition: Integer;
  pJme,pPri,pDom,pPra,pMob:String;
  pocetDuplicit:Integer =0;
  pocetVizitek:Integer =0;
begin
  pJme:=''; pPri:='';pDom:='';pPra:='';pMob:='';
  Memo2.Append(timetostr(Time)+'..................................' );
  Memo2.Append(timetostr(Time)+' ..... Import is being proceed .....   :-) ' );
  seznamStringu:=TStringList.Create;
  If importZSluchatka then
    begin
      CefGetPath(PK_DIR_EXE,str);
      str:=str+PathDelim+'aaaaa.vcf';
      jmenoSouboru := UTF16toUTF8(str);  // zřejmně by mělo být všude kde jde widechar(UTF16)
                                         // do utf8
      importZSluchatka := False;  // globální proměnná
      //ShowMessage('Funguje import ze sluchátka házím exit' + LineEnding +
      //             jmenoSouboru);
     // exit   // pro ladění :-)
    end
                      else
    begin
       OpenDialog1.filter:='vCard|*.vcf';
       If opendialog1.Execute = true then
             begin
              jmenoSouboru :=  utf8tosys(OpenDialog1.FileName);
              OpenDialog1.filter:='firebird|*.fdb'
             end

                                     else
              exit;
    end;
   seznamStringu.LoadFromFile(jmenoSouboru);
   ProgressBar1.Show;
   ProgressBar1.Max:=seznamStringu.Count-1;
   ProgressBar1.Min:=0;
   ProgressBar1.Step:=1;
   RxDBGrid1.ScrollBars:=ssNone;  // vypnutí scrollbarů protože výběr všeho v najdiDuplicity();
   if MessageDlg('První řádek souboru: '+seznamStringu[0], mtWarning, [mbOK, mbCancel],0) = mrOk then

       for i:=0 to seznamStringu.Count -1 do
         begin
            ProgressBar1.StepIt;
            PomS:=utf8tosys(seznamStringu[i]);  // utf8tosys()'VERSION:3.0' z gmailu je v utf8 :-( ale stačí změnit
            if poms='BEGIN:VCARD' then             //kódování v PsPadu :-)
                  begin
                   ZQuery1.insert;
                   pocetVizitek:=pocetVizitek+1;
                   continue;
                  end;
            if poms='END:VCARD' then
                  begin
                   // zkontrolovat aby se nezadala duplicita and jmeno nesmí být prázdne
                   // v případě prázdného jména tam nakopírovat příjmení a teprve pak
                   // hledat duplicity :-)
                    if najdiDuplicity(pJme,pPri,pDom,pPra,pMob) = false then   // nemůže se stát, že by neměli hodnotu
                    begin
                      ZQuery1.insert;
                      Zquery1.FieldByName('PRIJMENI').asString:=pPri;
                      Zquery1.FieldByName('JMENO').asString:=pJme;
                      Zquery1.FieldByName('DOMU').asString:=pDom;
                      Zquery1.FieldByName('PRACE').AsString:=pPra;
                      Zquery1.FieldByName('MOBIL').AsString:=pMob;
                      ZQuery1.Post;// v BeforePost se vytvoří THistoryItem;
                      multiPolozkaHistorie:=True; // aby přidávalo do té samé položky historie
                      // je třeba vyčistit všechny použité proměnné pro nalezené texty
                      pPri:='';
                      pJme:='';
                      pDom:='';
                      pPra:='';
                      pMob:='';
                      continue;
                    end
                                                else
                    begin
                      pocetDuplicit:=pocetDuplicit+1;
                      continue;
                    end;
                  end;
            if findpart('N:',PomS)<>0 then
              begin
                if PomS[3]=';' then
                   begin
                     //Zquery1.FieldByName('PRIJMENI').asString:='';
                     pPri:='';
                     //Zquery1.FieldByName('JMENO').asString:=
                     pJme:=
                              //systoutf8(LeftBStr(Rightstr(PomS,Length(pomS)-3),20));
                                systoutf8(LeftBStr(extractword(2,poms,[';']),25));
                     continue;
                   end

                               else
                   begin
                     pomPosition:=3;
                     //Zquery1.FieldByName('PRIJMENI').asString:=
                     pPri:=
                            systoutf8(LeftBStr(ExtractSubstr(pomS,pomPosition,[';']),25));
                     //Zquery1.FieldByName('JMENO').asString:=
                     pJme:=
                              systoutf8(LeftBStr(extractword(2,poms,[';']),25));
                     continue;
                   end;
               end;
            if (findpart('TEL;HOME:',PomS)<>0) or (findpart('TEL;TYPE=HOME:',PomS)<>0)  then
                 begin
                   //Zquery1.FieldByName('DOMU').asString:=
                   pDom:=
                     systoutf8(extractword(2,poms,[':']));
                   continue;
                 end;
            if (findpart('TEL;WORK:',PomS)<>0) or (findpart('TEL;TYPE=WORK:',PomS)<>0)  then
                 begin
                   //Zquery1.FieldByName('PRACE').AsString:=
                   pPra:=
                     systoutf8(extractword(2,poms,[':']));
                   continue;
                 end;
            if (findpart('TEL;CELL:',PomS)<>0) or (findpart('TEL;TYPE=CELL:',PomS)<>0) then
                 begin
                   //Zquery1.FieldByName('MOBIL').AsString:=
                   pMob:=
                     systoutf8(extractword(2,poms,[':']));
                   continue;
                 end;
         end;
   RxDBGrid1.ScrollBars:=ssBoth;  // zapnutí scrollbarů protože výběr všeho v najdiDuplicity();
   ZQuery1.First;  // na první záznam podle aktuálního třídění
   RxDBGrid1.SelectedRows.Clear; // zruš výběr všeho z najdiDuplicity()
   Memo2.Append(timetostr(Time)+' ..... Import finished  .....   :-) ' );
   Memo2.Append(timetostr(Time)+'..................................' );
   multiPolozkaHistorie:=False; // je možnos přidávat další THistoryItem;
   if MessageDlg('Items to import: '+inttostr(pocetVizitek)+LineEnding+
               'Duplicit items: '+inttostr(pocetDuplicit)+LineEnding+
               'Imported: '+inttostr(pocetVizitek-pocetDuplicit),
                mtInformation, [mbOK],0) = mrOk then
                       begin
                         ProgressBar1.Hide;
                         ProgressBar1.Position:=0;
                       end;

end;

procedure TForm1.MenuItemImportGoogleClick(Sender: TObject);{import z vcf google (utf8)}
begin
  MenuItemImportNormal.Click;
end;



procedure TForm1.MenuItemHledejClick(Sender: TObject);
begin
  Application.CreateForm(TfrmHledej,frmHledej);
  frmHledej.Show;
  // vše VYŘEŠENO :-) pomocí standardních funkcí CEFu pro upload dialog, zatím to je pouze
  // v testovacím projektu  CEF3_beztimeru_pokrok - tzn. je potřeba vrátit změny v:
  //  - položce menu "Otevřít nedávné"
  //  VRÁCENO :-) a už je to vše zapracované v tomto projektu :-)
end;

procedure TForm1.MenuItemInzertClick(Sender: TObject);   {popup - Vloží řádek}
var
  vysledekOkna: Integer;
begin
  StatusBar1.Panels.Items[0].Text:='ROWS ADDING';
  repeat
     //ZQuery1.Insert;
     FormPolozkyPom.LblEditJmeno.Text:='';
     FormPolozkyPom.LblEditPrijmeni.Text:='';
     FormPolozkyPom.LblEditDomu.Text:='';
     FormPolozkyPom.LblEditPrace.Text:='';
     FormPolozkyPom.LblEditMobil.Text:='';
     vysledekOkna:= FormPolozkyPom.ShowModal;
     if (vysledekOkna = mrOK) or (vysledekOkna = mrYes) then
        begin
           ZQuery1.Insert; // přesunuto
           ZQuery1.FieldByName('JMENO').asString:=FormPolozkyPom.LblEditJmeno.Text;
           ZQuery1.FieldByName('PRIJMENI').asString:=FormPolozkyPom.LblEditPrijmeni.Text;
           ZQuery1.FieldByName('DOMU').asString:=FormPolozkyPom.LblEditDomu.Text;
           ZQuery1.FieldByName('PRACE').asString:=FormPolozkyPom.LblEditPrace.Text;
           ZQuery1.FieldByName('MOBIL').asString:=FormPolozkyPom.LblEditMobil.Text;
           ZQuery1.Post; // přesunuto
        end;
  until  (vysledekOkna = mrOK) or (vysledekOkna= mrCancel) ;
  //ZQuery1.Post;
  statusBar1.Panels.Items[0].Text:='BROWSER MOD';
end;

procedure TForm1.MenuItemNastaveniClick(Sender: TObject);
begin
  // Application.CreateForm(TfrmNastaveni, frmNastaveni);
  frmNastaveni.ShowModal;
  // Application.ReleaseComponent(frmNastaveni);
end;

procedure TForm1.MenuItemNastrojeExportVyberuGigasetSluchatkoClick(
  Sender: TObject);
begin
  MenuItemExportGigaset.Click;
end;

procedure TForm1.MenuItemNastrojeExportVyberuNormalVcfClick(Sender: TObject);
begin
  MenuItemExportNormal.Click;
end;

procedure TForm1.MenuItemNastrojeImportGigasetSluchatkoClick(Sender: TObject);
begin
  MenuItemImportGigaset.Click;
end;

procedure TForm1.MenuItemNastrojeImportGoogleMailVcfClick(Sender: TObject);
begin
   MenuItemImportGoogle.Click;
end;

procedure TForm1.MenuItemNastrojeImportNormalVcfClick(Sender: TObject);
begin
  MenuItemImportNormal.Click;
end;

procedure TForm1.MenuItemNastrojePrijmeniDoJmenoClick(Sender: TObject);
begin
  MenuItemPrijmeniDoJmeno.Click;
end;

procedure TForm1.MenuItemOtevritClick(Sender: TObject);{menu soubor - Open}
begin
  If JmenoAktSoubor <> '' then MenuItemZavrit.Click;
  If opendialog1.Execute = true then
   begin
        //SdfDataSet1.FirstLineAsSchema:= true;
        //SdfDataSet1.FileName := UTF8ToSys(OpenDialog1.FileName);
        //SdfDataSet1.Active := true;
        ZQuery1.Close;
        ZQuery1.SQL.Text:= 'SELECT * FROM  TELEPHONE_DIRECTORY ORDER BY '
                           + RxDbgrid1.Columns.Items[0].FieldName  +' ASC';
        ZConnection1.Database:= UTF8ToSys(OpenDialog1.FileName);          //
        ZConnection1.Connected:= True;
        //SQLTransaction1.Active:= True;
        ZQuery1.Open;
        JmenoAktSoubor := Opendialog1.FileName;
        Form1.Caption:= Form1.Caption + '  ' + JmenoAktSoubor;
        VlozDoHistoryFiles(JmenoAktSoubor);
        ZmenaVDatabazi := false;         {žádná změna základní tabulky zatím neproběhla}
        RxDBGrid1.SelectedRows.CurrentRowSelected:=true;{po otevření vybrat celý řádek, ne jen
        buňka}
        //RxDBGrid1CellClick(RxDBGrid1.Columns[0]); // aby fungoval výběr pomoci SHIFT+click
        undoPolozky.historyVector.Clear;
        redoPolozky.historyVector.Clear;
        undoPolozky.printHistoryVector;
        redoPolozky.printHistoryVector;
   end;
end;

procedure TForm1.MenuItemOtevritNedavneClick(Sender: TObject);{menu soubor - Otevřít nedávné}

var
 PomMenu : TMenuItem;
 i: Integer;

begin
 {vytvoř položky menu  soubor - Otevřít nedávné ------ začátek}
 MenuItemOtevritNedavne.Clear;
 PomMenu := TmenuItem.create(Self);
 HistoryFiles := Tstringlist.create;
 HistoryFiles.LoadFromfile('history.txt');
 for i:=0 to HistoryFiles.Count-1 do
  begin
    PomMenu := TmenuItem.create(Self);
    PomMenu.Caption :=SysToUTF8( HistoryFiles.Strings[i]);
    PomMenu.OnClick := @MojeOnClick;
    MenuItemOtevritNedavne.Add(PomMenu);
  end;
 {vytvoř položky menu  soubor - Otevřít nedávné  ------ konec}
end;

procedure TForm1.MenuItemPomocClick(Sender: TObject); //sumatrapdf
//var
//   str:String;
begin
   OpenURL(GetCurrentDirUTF8 +'\Help\index.html');
  //str:='"help.chm"  -restrict  ';
  //RunCommand('sumatrapdf',str,str);
end;

procedure TForm1.MenuItemTrideniPodleSloupcuClick(Sender: TObject);
begin
  RxDBGrid1.ShowSortDialog;
end;

procedure TForm1.MenuItemRedoClick(Sender: TObject);
var
  i: Integer;
begin
  if redoPolozky.historyVector.Size = 0 then
    begin
      Memo2.Append(timetostr(Time)+' no redo to proceed');
      exit;
    end;
  probihaRedo:=True;
  for i:=0 to redoPolozky.historyVector.Back.polePolozek.Size-1 do
    redoPolozky.historyVector.Back.operaceZPolePolozek(
      ZQuery1 as Tdataset,redo,i);
  undoPolozky.historyVector.PushBack(redoPolozky.historyVector.Back);
  undoPolozky.printHistoryVector;
  redoPolozky.historyVector.PopBack;
  redoPolozky.printHistoryVector;
  probihaRedo:=False;
end;

procedure TForm1.MenuItemShowHistoryBufferClick(Sender: TObject);
begin
  //Application.CreateForm(TfrmUkazHistorii,frmUkazHistorii);
  frmUkazHistorii.Show;
end;

procedure TForm1.MenuItemUndoClick(Sender: TObject);

var
  i: Integer;
begin
  if undoPolozky.historyVector.Size = 0 then
    begin
      Memo2.Append(timetostr(Time)+' no undo to proceed');
      exit;
    end;
  probihaUndo:=True;
  for i:=0 to undoPolozky.historyVector.Back.polePolozek.Size-1 do
    undoPolozky.historyVector.Back.operaceZPolePolozek(
      ZQuery1 as Tdataset,undo,i);
  redoPolozky.historyVector.PushBack(undoPolozky.historyVector.Back);
  redoPolozky.printHistoryVector;
  undoPolozky.historyVector.PopBack;
  undoPolozky.printHistoryVector;
  probihaUndo:=False;
end;

procedure TForm1.MenuItemViditelnostSloupcuClick(Sender: TObject);
begin
  RxDBGrid1.ShowColumnsDialog;
end;

procedure TForm1.MenuItemVypniFiltrClick(Sender: TObject);
begin
  RxDBGrid1.HideQuickFilter;    // přidáno do zdroje rxdbgrid.pas :-)
end;

procedure TForm1.MenuItemPrijmeniDoJmenoClick(Sender: TObject);
var
  i: Integer;
begin
  for i:=0 to RxDBGrid1.SelectedRows.Count-1 do
   begin
     ZQuery1.GotoBookmark(RxDBGrid1.SelectedRows.Items[i]);
     ZQuery1.Edit;
     if  ZQuery1.FieldByName('PRIJMENI').asString=' ' then
                     ZQuery1.FieldByName('PRIJMENI').asString:='';
     ZQuery1.FieldByName('JMENO').asString:=ZQuery1.FieldByName('PRIJMENI').asString+' '+
                                            ZQuery1.FieldByName('JMENO').asString;
     ZQuery1.FieldByName('PRIJMENI').asString:='';
     ZQuery1.Post;
   end;
end;

procedure TForm1.MenuItemSouborClick(Sender: TObject);
begin
  if  JmenoAktSoubor='' then
   begin
    MenuItemUlozit.Enabled:=False;
    MenuItemUlozitJako.Enabled:=False;
    MenuItemZavrit.Enabled:=False;
   end
                       else
   begin
    MenuItemUlozit.Enabled:=True;
    MenuItemUlozitJako.Enabled:=True;
    MenuItemZavrit.Enabled:=True;
   end;
end;

procedure TForm1.MenuItemUlozitClick(Sender: TObject);  {menu soubor - Save}
begin
    UlozZmenySQL
end;

procedure TForm1.MenuItemUlozitJakoClick(Sender: TObject);{menu soubor - Save As}
var
  PomStr : String;
begin
   SaveDialog1.FileName:= ExtractFileNameOnly(JmenoAktSoubor);
   if SaveDialog1.execute  then      {}
   begin
     //SdfDataset1.SaveFileAs(UTF8ToSys(savedialog1.FileName));
      {uložit provedené změny - to samé je v menu Soubor - Save}
    UlozZmenySQL;
    PomStr:=SystoUTF8(ZConnection1.Database);
    ZQuery1.Close; {zavřít původní databázi - to samé je v menu Soubor - Close}
    //SQLTransaction1.Active:= False;
    ZConnection1.Connected:= False;
    if PomStr <> Savedialog1.FileName then
        FileUtil.CopyFile(PomStr,savedialog1.FileName);  {vytvořit kopii databáze, cesty v UTF8}
    ZConnection1.Database:= (UTF8ToSys(Savedialog1.FileName));  {otevřít novou databázi}
    ZConnection1.Connected:= True;
    //SQLTransaction1.Active:= True;
    ZQuery1.Open;
    JmenoAktSoubor := Savedialog1.FileName;
    Form1.Caption:= 'Phone Book for Gigaset 610,620H' + '  ' + JmenoAktSoubor;
    VlozDoHistoryFiles(JmenoAktSoubor);
    ZmenaVDatabazi := false    {vynulování změn základní tabulky }
   end;
end;

procedure TForm1.MenuItemZavritClick(Sender: TObject);{menu Close}
var
  PomStr : string;
begin
  if (ZmenaVDatabazi)  then
     begin
      if QuestionDlg('Unsaved changes', 'There are unsaved changes in file,'+LineEnding+
                    'do you want to save them ?',mtWarning, [mrYes, 'Yes', mrNo, 'No'], 0)
                     = mrYes then
           begin
               SaveDialog1.FileName:= ExtractFileNameOnly(JmenoAktSoubor);
               if SaveDialog1.execute  then
                begin
                 //SdfDataset1.SaveFileAs(UTF8ToSys(savedialog1.FileName));
                 {uložit provedené změny - to samé je v menu Soubor - Save}
                  UlozZmenySQL;
                  PomStr:=SystoUTF8(ZConnection1.Database);
                  ZQuery1.Close; {zavřít původní databázi - to samé je v menu Soubor - Close}
                  //SQLTransaction1.Active:= False;
                  ZConnection1.Connected:= False;
                  If PomStr <> Savedialog1.FileName then
                    FileUtil.CopyFile(PomStr,savedialog1.FileName);  {vytvořit kopii databáze,
                                                                     cesty v UTF8}
                  ZmenaVDatabazi := false;    {vynulování změn základní tabulky }
                end;

           end;
     end;
  //sdfDataset1.Close;
  //SdfDataSet1.FileMustExist:=true;
  ZQuery1.Close;
  //SQLTransaction1.Active:= False;
  ZConnection1.Connected:= False;
  Form1.Caption:= 'Phone Book for Gigaset 610,620H  ';
  ZmenaVDatabazi := false;    {vynulování změn základní tabulky }
  undoPolozky.historyVector.Clear;
  redoPolozky.historyVector.Clear;
  undoPolozky.printHistoryVector;
  redoPolozky.printHistoryVector;
  Memo2.Clear;
  // StatusBar1.Panels[0].Text:='Seřazeno dle:  ';
  JmenoAktSoubor:='';
end;

procedure TForm1.MenuItemUkoncitClick(Sender: TObject); {menu soubor - Ukončit}
begin
 Form1.Close;
end;

procedure TForm1.OpenDialog1CanClose(Sender: TObject; var CanClose: boolean);
begin
  if systoutf8(ExtractFileNameOnly(UTF8tosys(Opendialog1.FileName))) = 'new' then
    begin
       CanClose:=False;
       if MessageDlg('File name new '+LineEnding+'is not allowed',
                     mtWarning, [mbOK],0) = mrOk then OpenDialog1.FileName:='';
    end

                                         else CanClose:=True;
end;

procedure TForm1.PopupMenu1Popup(Sender: TObject);
begin
  if  JmenoAktSoubor='' then
     begin
      MenuItemInzert.Enabled:=False;
      MenuItemEdit.Enabled:=False;
      MenuItemDelete.Enabled:=False;
      MenuItemExport.Enabled:=False;
      MenuItemImport.Enabled:=False;
      MenuItemPrijmeniDoJmeno.Enabled:=False;

     end
                         else
     begin
      MenuItemInzert.Enabled:=True;
      MenuItemEdit.Enabled:=True;
      MenuItemDelete.Enabled:=True;
      MenuItemExport.Enabled:=True;
      MenuItemImport.Enabled:=True;
      MenuItemPrijmeniDoJmeno.Enabled:=True;
     end;
end;

procedure TForm1.RxDBGrid1MouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
    // při otočení kolečkem nezůstává první řádek vybraný
  //If kliknuto and not(ssShift in GetKeyShiftState) then
  //              begin
  //                kliknuto:=false;
  //              end;
  kolecko:=true;
  //ShowMessage('MouseWheel a kolečko je ' + booltostr(kolecko));
end;

procedure TForm1.ToolButtonEditClick(Sender: TObject);
var
  i: Integer;
  vysledekOkna: Integer;
begin
 if ToolButtonEdit.Down then
      begin
        StatusBar1.Panels.Items[0].Text:='MOD TABLE EDIT';
        for i:=0 to RxDBGrid1.SelectedRows.Count-1 do
           begin
             ZQuery1.GotoBookmark(RxDBGrid1.SelectedRows.Items[i]);
             // ZQuery1.Edit;
             FormPolozkyPom.LblEditJmeno.Text:=ZQuery1.FieldByName('JMENO').asString;
             FormPolozkyPom.LblEditPrijmeni.Text:=ZQuery1.FieldByName('PRIJMENI').asString;
             FormPolozkyPom.LblEditDomu.Text:=ZQuery1.FieldByName('DOMU').asString;
             FormPolozkyPom.LblEditPrace.Text:=ZQuery1.FieldByName('PRACE').asString;
             FormPolozkyPom.LblEditMobil.Text:=ZQuery1.FieldByName('MOBIL').asString;
             if  (RxDBGrid1.SelectedRows.Count-1-i)=0 then
                                    FormPolozkyPom.ButtonDalsi.Enabled:=false;
             vysledekOkna:= FormPolozkyPom.ShowModal;
             if (vysledekOkna = mrOK) or (vysledekOkna = mrYes) then
                begin
                   ZQuery1.Edit; // přesunutí ZQuery1.Edit;
                   ZQuery1.FieldByName('JMENO').asString:=FormPolozkyPom.LblEditJmeno.Text;
                   ZQuery1.FieldByName('PRIJMENI').asString:=FormPolozkyPom.LblEditPrijmeni.Text;
                   ZQuery1.FieldByName('DOMU').asString:=FormPolozkyPom.LblEditDomu.Text;
                   ZQuery1.FieldByName('PRACE').asString:=FormPolozkyPom.LblEditPrace.Text;
                   ZQuery1.FieldByName('MOBIL').asString:=FormPolozkyPom.LblEditMobil.Text;
                   ZQuery1.Post;
                end;
             if (vysledekOkna = mrOK) or (vysledekOkna= mrCancel) then
                begin
                   ToolButtonEdit.Down:=false;
                   StatusBar1.Panels.Items[0].Text:='BROWSER MOD';
                   FormPolozkyPom.ButtonDalsi.Enabled:=true;
                   exit;
                end;
           end;

        //RxDBGrid1.Options:=RxDBGrid1.Options-[dgMultiSelect]-[dgRowSelect]+[dgEditing];
        ToolButtonEdit.Down:=false;
        StatusBar1.Panels.Items[0].Text:='BROWSER MOD';
        FormPolozkyPom.ButtonDalsi.Enabled:=true;
      end

                          else
      begin
        //RxDBGrid1.Options :=RxDBGrid1.Options +[dgMultiselect] + [dgRowSelect]-[dgEditing];

      end;
end;

procedure TForm1.MenuItemNovyClick(Sender: TObject);
var
  PomS: TTranslateString;
begin
  If JmenoAktSoubor <> '' then MenuItemZavrit.Click;
  PomS:=OpenDialog1.Title;
  OpenDialog1.Title:='Enter the name of new file ';
  If opendialog1.Execute = true then
   begin
      ZQuery1.Close;
      ZQuery1.SQL.Text:= 'SELECT * FROM TELEPHONE_DIRECTORY ';
      ZQuery1.Close; {zavřít původní databázi - to samé je v menu Soubor - Close}
      //SQLTransaction1.Active:= False;
      ZConnection1.Connected:= False;
     FileUtil.CopyFile('new.fdb',Opendialog1.FileName);  {vytvořit kopii databáze, cesty v UTF8}
     JmenoAktSoubor := Opendialog1.FileName;
     Form1.Caption:= Form1.Caption + '  ' + JmenoAktSoubor;
     VlozDoHistoryFiles(JmenoAktSoubor);
     ZConnection1.Database:= (UTF8ToSys(Opendialog1.FileName));  {otevřít novou databázi}
     ZConnection1.Connected:= True;
     //SQLTransaction1.Active:= True;   {Zeos DB narozdíl od SQLDB implicitně automaticky}
     ZQuery1.Open;                       { používá transakce a ukládá po změně}
     ZmenaVDatabazi := false;   {žádná změna základní tabulky zatím neproběhla}
     RxDBGrid1.SelectedRows.CurrentRowSelected:=true;{po otevření vybrat celý řádek}
     // DBGrid1CellClick(RxDBGrid1.Columns[0]);  aby fungoval výběr pomoci SHIFT+click
   end;
   OpenDialog1.Title:=PomS;
   undoPolozky.historyVector.Clear;
   redoPolozky.historyVector.Clear;
   undoPolozky.printHistoryVector;
   redoPolozky.printHistoryVector;
end;

procedure TForm1.MenuItemOProgramuClick(Sender: TObject);
begin
  SplashAbout1.ShowAbout;
end;

procedure TForm1.MojeOnClick(sender: TObject);  {handler pro položky menu
                                               soubor - Otevřít nedávné }
var
   PomString : string;
begin
  PomString := (Sender as TmenuItem).Caption ;

  if ZQuery1.Active then
       MenuItemZavrit.Click;   {Vyvolá událost obsouženou TForm1.MenuItem8Click tj. soubor - zavřít}
  ZQuery1.Close;
  ZQuery1.SQL.Text:= 'SELECT * FROM  TELEPHONE_DIRECTORY';
  ZConnection1.Database:= UTF8ToSys(PomString);
  ZConnection1.Connected:= True;
  //SQLTransaction1.Active:= True;
  ZQuery1.Open;
  JmenoAktSoubor := PomString;
  VlozDoHistoryFiles(JmenoAktSoubor);
  Form1.Caption:= Form1.Caption + '  ' + JmenoAktSoubor;
  ZmenaVDatabazi := false;
  RxDBGrid1.SelectedRows.CurrentRowSelected:=true;{po otevření vybrat celý řádek, ne jen buňka}
  //RxDBGrid1CellClick(RxDBGrid1.Columns[0]); // aby fungoval výběr pomoci SHIFT+click
end;

procedure TForm1.UlozZmenySQL;                      {Uloží transakčně změny v SQLQuery1}
 begin{SQLQuery1 je DataSet descendant}
  try                   {Zeos DB narozdíl od SQLDB implicitně automaticky}
                        { používá transakce a ukládá po změně takže je tahle procedura zbytečná :-)}
    //if SQLTransaction1.Active then
    //  begin
        //ZQuery1.ApplyUpdates;            //Pass user-generated changes back to database...
        ZConnection1.Commit;
        //SQLTransaction1.Commit;           //... and commit them using the transaction.
        ZConnection1.Connected:= True;   //SQLTransaction1.Active now is false
        //SQLTransaction1.Active:= True;
        ZQuery1.Open;                    {znovu obnovit spojení a naplnit DBgrid}
        ZmenaVDatabazi := false    {vynulování změn základní tabulky }
      //end;
  except
  on E: EDatabaseError do
    begin
      MessageDlg('Error', 'A database error has occurred. Technical error message: ' +
        E.Message, mtError, [mbOK], 0);
    end;
  end;
 end;

procedure TForm1.RxDBGrid1CellClick(Column: TColumn);

begin
  RxDBGrid1ShiftSelect(RxDBGrid1, previousGridBookmark);  {pro výběr pomocí clik + SHIFT}
//  previousGridBookmark := DBGrid1.DataSource.DataSet.GetBookmark; je to depreciated
  previousGridBookmark := ZQuery1.Bookmark; // save last selected bookmark
 // kliknuto:=true;
end;

procedure TForm1.RxDBGrid1ShiftSelect(Sender: TObject; existingBookmarks: TBookmark);
{dovolí výběr clik + SHIFT}
var
	soucPos: TBookmark;
	grid: TRxDBGrid;
	dSet: TDataSet;
	prvni, posledni, pom: integer;
begin
  grid := (Sender as TRxDBGrid);
  dSet := grid.DataSource.DataSet;
  // Get the current position (bookmark) and record number (the row we shift-clicked on)
  soucPos := dSet.GetBookmark;
  posledni := dSet.RecNo;
  dSet.DisableControls;
  try    // dummy loop that allows multiple exits to a single point
    repeat
	if not (ssShift in GetKeyShiftState) then exit;
	if (existingBookmarks = nil) then exit;
	// go to the last bookmark before we shift-clicked
	dSet.GotoBookmark(existingBookmarks);
	prvni := dSet.RecNo;
	if posledni = prvni then exit;
	// we want to only mark moving forward, so if need be, swap the bookmarks
	if posledni < prvni then
           begin
		pom := posledni;
		posledni := prvni;
		prvni := pom;
		grid.SelectedRows.CurrentRowSelected := True;
		dSet.GotoBookmark(soucPos);
	   end;
	repeat
	  // highlight current row
	  grid.SelectedRows.CurrentRowSelected := True;
	  dset.Next;
	  prvni := dSet.recNo;
	  // keep going until we reach the shift-clicked row
	until prvni = posledni ;
    until true;
  finally
    dSet.FreeBookmark(soucPos);
    dSet.EnableControls;
  end;
end;

procedure TForm1.nahradDiakritiku(var retezec:String);
var
  S:TUTF8Scanner;
begin
  s := TUTF8Scanner.Create(retezec);
  s.FindChars := 'ěščřžýáíéúůŽŠČŘŤťĎďÝÁÚ';
 repeat
   case s.FindIndex(s.Next) of
 {ě} 0: s.Replace('e');
 {š} 1: s.Replace('s');
 {č} 2: s.Replace('c');
     3: s.Replace('r');
     4: s.Replace('z');
     5: s.Replace('y');
     6: s.Replace('a');
     7: s.Replace('i');
     8: s.Replace('e');
     9: s.Replace('u');
     10: s.Replace('u');
     11: s.Replace('Z');
     12: s.Replace('S');
     13: s.Replace('C');
     14: s.Replace('R');
     15: s.Replace('T');
     16: s.Replace('t');
     17: s.Replace('D');
     18: s.Replace('d');
     19: s.Replace('Y');
     20: s.Replace('A');
     21: s.Replace('U');
   end;
 until s.Done;
 retezec:= s.UTF8String;
 s.free;
 // OpenURL('http://www.google.com');
end;

function TForm1.najdiDuplicity(pJme, pPri, pDom, pPra, pMob: String): Boolean;
                                                      {hledá duplicity v databázi před uložením}
var
  i: Integer;
  Jme,Pri,Dom,Pra,Mob : String;
begin
  // vypadá to že jméno může být prázdené :-)
  //if (pJme=' ') or (pJme='') then
  //   begin
  //      Memo2.Append(timetostr(Time)+'Příjmení do Jméno');
  //      pJme:='';
  //      pJme:=pJme+pPri;
  //   end;

  RxDBGrid1.SelectAllRows;
  for i:=0 to RxDBGrid1.SelectedRows.Count -1 do
   begin
     ZQuery1.GotoBookmark(RxDBGrid1.SelectedRows.Items[i]);
     Jme:=ZQuery1.FieldByName('JMENO').asString;
     Pri:=ZQuery1.FieldByName('PRIJMENI').asString;
     Dom:=ZQuery1.FieldByName('DOMU').asString;
     Pra:=ZQuery1.FieldByName('PRACE').asString;
     Mob:=ZQuery1.FieldByName('MOBIL').asString;
     If (Jme=pJme) and (Pri=pPri) and (Dom=pDom) and (Pra=pPra) and (Mob=pMob) then
                 begin
                   result :=True;
                   Memo2.Append('DUPLICITY ITEM '+ format('[%0:-20s]',[pJme])+
                                format('[%0:-19s]',[pPri]));
                   exit;
                 end;

   end;
 // Memo2.Append(timetostr(Time)+' '+ format('[%0:-25s]',[pJme])+
 //                                 ' Duplicita False');
  result:=False;
end;

procedure TForm1.ZQuery1AfterDelete(DataSet: TDataSet);
begin
  ZmenaVDatabazi:=True;     // je třeba, deaktivaloval jsem  ZConnection1.AutoCommit;
  //Memo2.Append('After delete: '+dataset.FieldByName('JMENO').AsString);
end;

procedure TForm1.ZQuery1AfterEdit(DataSet: TDataSet);
begin
  //Memo2.Append('After edit: '+dataset.FieldByName('JMENO').AsString);
end;

procedure TForm1.ZQuery1AfterInsert(DataSet: TDataSet);
begin
  //Memo2.Append('After insert: '+dataset.FieldByName('JMENO').AsString );
end;

procedure TForm1.ZQuery1BeforeDelete(DataSet: TDataSet);
 var
    pomHodnoty:THodnoty;
    i:Integer;
begin
 for i:=0 to 4 do
      pomHodnoty[i]:=dataSet.Fields.Fields[i].AsString;
 if (not probihaUndo) and (not probihaRedo)  then
     begin
      if redoPolozky.historyVector.Size <> 0 then
          begin
            redoPolozky.historyVector.Clear;
            redoPolozky.printHistoryVector;
            Memo2.Append(timetostr(Time)+' redo buffer cleared');
          end;
      Memo2.Append(timetostr(Time)+' DELETE (Before delete): '+dataset.FieldByName('JMENO').AsString);
      undoPolozky.historyVector.PushBack(THistoryItem.create(
         inttostr(undoPolozky.historyVector.Size+1)+' history item',
         pomHodnoty,insert));
      undoPolozky.printHistoryVector;
     end;
end;

procedure TForm1.ZQuery1BeforeEdit(DataSet: TDataSet);
 var
    pomHodnoty:THodnoty;
    i:Integer;
begin
 for i:=0 to 4 do
      pomHodnoty[i]:=dataSet.Fields.Fields[i].AsString;
 if (not probihaUndo) and (not probihaRedo)  then
   begin
    Memo2.Append(timetostr(Time)+' EDIT (Before edit): '+dataset.FieldByName('JMENO').AsString);
    // multiPolozkaHistorie:=True; - dataset.state automaticky na dsEdit;
    undoPolozky.historyVector.PushBack(THistoryItem.create(
      inttostr(undoPolozky.historyVector.Size+1)+' history item (multi)',
      pomHodnoty,insert));
   // undoPolozky.printHistoryVector;
   end;
end;

procedure TForm1.ZQuery1BeforeInsert(DataSet: TDataSet);
begin
  //Memo2.Append('Before insert: '+dataset.FieldByName('JMENO').AsString );
               //dataset.FieldByName('PRIJMENI').asString +
               //dataset.FieldByName('DOMU').asString +
               //dataset.FieldByName('PRACE').asString +
               //dataset.FieldByName('MOBIL').asString );
end;

procedure TForm1.ZQuery1BeforePost(DataSet: TDataSet);
 var
     pomHodnoty:THodnoty;
     i:Integer;
begin
  //Memo2.Append('Before post: '+dataset.FieldByName('JMENO').AsString);
  for i:=0 to 4 do
      pomHodnoty[i]:=dataSet.Fields.Fields[i].AsString;
 if (not probihaUndo) and (not probihaRedo) then // neprobíhá Undo ani Redo
   begin  // tak by se asi mělo vyprázdnit Redo (probíhá normální operace)
          // tzn. todo
    if redoPolozky.historyVector.Size <> 0 then
      begin
        redoPolozky.historyVector.Clear;
        redoPolozky.printHistoryVector;
        Memo2.Append(timetostr(Time)+' redo buffer cleared');
      end;
    Memo2.Append(timetostr(Time)+' POSTED (After post): '+dataset.FieldByName('JMENO').AsString);
    if (multiPolozkaHistorie) or (dataset.State=dsEdit) then
       begin
        undoPolozky.historyVector[undoPolozky.historyVector.Size-1].
               operaceDoPolePolozek(pomHodnoty,delete);
        if multiPolozkaHistorie then   multiPolozkaHistorie:=false;
        // dataset.State automaticky na dsBrowse po úspěšném dataset.Post;
       end
                            else
       begin
         undoPolozky.historyVector.PushBack(THistoryItem.create(inttostr(
          undoPolozky.historyVector.Size+1)+' history item',
          pomHodnoty,delete));
       end;
    undoPolozky.printHistoryVector;
   end;
end;

procedure TForm1.ZQuery1AfterPost(DataSet: TDataSet);
begin
 ZmenaVDatabazi:=True; // je třeba, deaktivaloval jsem  ZConnection1.AutoCommit;

end;

// ********************************************************* from former mainCEF
// ********************************************************* BEGIN


procedure TForm1.BGoClick(Sender : TObject);
//var
//    mujFrame : ICefFrame;
begin
   Chromium.Load(UTF8ToUTF16(EUrl.Text));
   //mujFrame:=Chromium.Browser.GetMainFrame;
   //mujFrame.ExecuteJavaScript('alert(window.file)',mujFrame.GetURL(), 0);;
  {copy javascript object handsets  to windows clipboard}
  //mujFrame.ExecuteJavaScript( 'var copyDiv = document.createElement("div");'+
  //                            'copyDiv.contentEditable = true;'+
  //                            'document.body.appendChild(copyDiv);'+
  //                            'copyDiv.innerHTML = handsets;'+
  //                            'copyDiv.unselectable = "off"; '+
  //                            'copyDiv.focus();'+
  //                            'document.execCommand("SelectAll");'+
  //                            'document.execCommand("Copy", false, null);'+
  //                            'document.body.removeChild(copyDiv);',mujFrame.GetURL(), 0);
end;

procedure TForm1.Button1Click(Sender: TObject); // for adding mouse event DOM listener
begin
  mujClickListener:=not(mujClickListener);
  if mujClickListener then
  Chromium.browser.SendProcessMessage(PID_RENDERER,TCefProcessMessageRef.New('addListener'));
end;

procedure TForm1.Button2Click(Sender: TObject); // message z browser procesu do render
begin                                              // procesu s žádostí o hodnotu z javascriptu
  Chromium.browser.SendProcessMessage(PID_RENDERER,TCefProcessMessageRef.New('v8_zkouska'));
end;

procedure TForm1.Button3Click(Sender: TObject);  // korektní uzavření prohlížeče
begin
  Chromium.Browser.GetHost.CloseBrowser(false);
end;

procedure TForm1.Button4Click(Sender: TObject);  // vyplní heslo, přihlásí se a iniciuje
 //var                                                // pomocí chromiumloadend nahrání
 //mujFrame : ICefFrame;                           // settings_phonebook_transfer.html :-)
begin
  if frmNastaveni.lblEditIpAdress.Text = '' then
     begin
       MessageDlg('IP adress of telephone base is empty,'+LineEnding+
       'fill it in application settings', mtWarning, [mbOK],0);
       exit;
     end;
  Chromium.Load(UTF8ToUTF16('http://'+frmNastaveni.lblEditIpAdress.Text +'/login.html'));
  if not prihlaseno then      // důležité - může být přihlášeno
   begin
     prihlaseno:=False;
   end ;
  jsemVHome:=False;
  jsemVDirectory:=False;
  seznamDoPocitace:=false;
end;

procedure TForm1.Button5Click(Sender: TObject); // vykoná javascript z Tmemo Javascript
 var
     mujFrame : ICefFrame;
     str:widestring;
 begin
  // Chromium.Load(EUrl.Text);
   mujFrame:=Chromium.Browser.GetMainFrame;
   mujFrame.ExecuteJavaScript(UTF8ToUTF16(JavaScript.Text),mujFrame.GetURL(), 0);
   CefGetPath(PK_DIR_CURRENT,str);
   Memo1.Append('CURRENT: '+ utf16toutf8(str));
   CefGetPath(PK_DIR_EXE,str);
   Memo1.Append('EXE: '+ utf16toutf8(str));
   CefGetPath(PK_DIR_MODULE,str);
   Memo1.Append('MODULE: ' +utf16toutf8(str));
   CefGetPath(PK_DIR_TEMP,str);
   Memo1.Append('TEMP: '+ utf16toutf8(str));
end;

procedure TForm1.Button6Click(Sender: TObject); // seznam z vybraného sluchátka do pc

 begin
   if frmNastaveni.lblEditIpAdress.Text = '' then
       begin
         MessageDlg('IP adress of the telephone base is empty,'+LineEnding+
         'feel it in application settings please', mtWarning, [mbOK],0);
         exit;
       end;
   Chromium.Load(UTF8ToUTF16('http://'+frmNastaveni.lblEditIpAdress.Text +'/login.html'));
   jsemVHome:=False;
   jsemVDirectory:=False;
   if not prihlaseno then      // důležité - může být přihlášeno
   begin
     prihlaseno:=False;
   end ;
   seznamDoPocitace:=true;  // tady je přepínač :-)
 end;

procedure TForm1.Button7Click(Sender: TObject); // LogOff
begin
  if not prihlaseno then  exit;
  Chromium.Load(UTF8ToUTF16('http://'+frmNastaveni.lblEditIpAdress.Text +'/logout.html'));
  Memo1.Append(timetostr(Time)+' logoff finished (procedure click)');
end;

procedure TForm1.Button8Click(Sender: TObject); // seznam z pc do vybraného sluchátka

begin
   if frmNastaveni.lblEditIpAdress.Text = '' then
       begin
         MessageDlg('IP adress of the telephone base is empty,'+LineEnding+
         'fill it in application settings please', mtWarning, [mbOK],0);
         exit;
       end;
   Chromium.Load(UTF8ToUTF16('http://'+frmNastaveni.lblEditIpAdress.Text +'/login.html'));
   if not prihlaseno then     // důležité - může být přihlášeno
   begin
     prihlaseno:=False;
   end;
   jsemVHome:=False;
   jsemVDirectory:=False;
   seznamDoTelefonu:=true;  // tady je přepínač :-)
 end;

procedure TForm1.ChromiumBeforeDownload(Sender: TObject;  // before file download
  const Browser: ICefBrowser; const downloadItem: ICefDownloadItem;
  const suggestedName: ustring; const callback: ICefBeforeDownloadCallback);
var
  str: ustring;
  mojeBool: Boolean;
  pomS:String;
begin
  mojeBool:=False;
  pomS:=SaveDialog1.Filter;
  if importZSluchatka then   // volaný z page1 stahnout ze sluchátka a hned import do page1
              begin;
                CefGetPath(PK_DIR_EXE,str);
                str:=str+PathDelim+'aaaaa.vcf';
              end
                      else  // volaný z buttonu z page2
              begin
                SaveDialog1.Filter:='vCard File|*.vcf';
                if SaveDialog1.Execute then
                  begin
                   str:=UTF8ToUTF16(SaveDialog1.FileName); // ustring je widestring tzn. UTF16
                  end;
                SaveDialog1.Filter:=pomS;
              end;

  Memo1.Append(timetostr(downloaditem.GetStartTime)+' downloading to '+
               UTF16ToUTF8(str));
  Memo1.Append(string(timetostr(Time))+' wait ... ');
  callback.Cont(str,mojeBool);
end;

procedure TForm1.ChromiumDownloadUpdated(Sender: TObject;
  const Browser: ICefBrowser; const downloadItem: ICefDownloadItem;
  const callback: ICefDownloadItemCallback); // při změně udájů o probíhajícím downloadu
begin
  if downloadItem.IsComplete then
       begin
          Memo1.Append(string(timetostr(downloaditem.EndTime))+' downloaded');
          if importZSluchatka then
            begin;
              Form1.TabSheet1.Show;  // zobrazit okno prohlížeče (cef3)
              MenuItemImportNormal.Click; // importovat do tabulky na page1
           end;
       end;
end;

procedure TForm1.ChromiumFileDialog(Sender: TObject;   // before file upload
  const Browser: ICefBrowser; mode: TCefFileDialogMode; const title,
  defaultFileName: ustring; acceptFilters: TStrings; selectedAcceptFilter: Integer;
  const callback: ICefFileDialogCallback ; out Result: Boolean);
      // POZOR !!! :-) pere se s Chromium.browser.host.RunFileDialog
var
   fileList:TStringlist;
   str: ustring;
   // Potřeba dodělat
   // když globání exportDoSluchatka true (je voláno z page1) tak poslat do telefonu aaaaa.vcf
   // jinak (je voláno z buttonu na page2) vyvolat dialog na výběr souboru
   // a v každém případě nastavit exportDoSluchatka na false
begin
   //Pozor změna v nové verzi CEF3 (3.2454) - bude pravděpodobně dělat problémy
  //alespoň ze začátku :-) přikládám diff:
//   ICefFileDialogCallBack = interface(ICefBase) ['{F5F75E88-4BEC-4BE3-B179-DC5C6DFDAA84}']
//-    procedure Cont(file_paths:TStrings);
//+    procedure Cont(selectedAcceptFilter: Integer; filePaths: TStrings);
//// a další změna, která se toho zřejmě týká:
//   ICefDialogHandler = interface(ICefBase) ['{07386301-A6AB-4599-873E-8D89545CB39F}']
//     function OnFileDialog(const browser: ICefBrowser; mode: TCefFileDialogMode;
//      const title, defaultFileName: ustring;
//-  accept_types: TStrings;
//+  acceptFilters: TStrings; selectedAcceptFilter: Integer;
//   const callback: ICefFileDialogCallback): Boolean;
   fileList:=TStringlist.Create;  // naplnit cestou k aktuálnímu otevřenému souboru
   if exportDoSluchatka then      // je voláno z page1 z lokálního menu
        begin
           CefGetPath(PK_DIR_EXE,str);
           str:=str+PathDelim+'aaaaa.vcf';
           // exportDoSluchatka := False; bude nastaveno až nakonec v spustUpload();
        end
                        else      // je voláno z buttonu na page2 a je tedy třeba vybrat soubor
       begin
           OpenDialog1.filter:='vCard|*.vcf';
           If opendialog1.Execute = true then
             begin
              str :=UTF8ToUTF16(OpenDialog1.FileName);
              OpenDialog1.filter:='firebird|*.fdb'
             end

                                     else
              exit;
       end;
   fileList.Append(utf8tosys(UTF16ToUTF8(str)));
   callback.Cont(selectedAcceptFilter,fileList);   // buďto Cont nebo Cancel;
   //callback.Cancel;
   Memo1.Append(string(timetostr(Time))+' upload of file: '+ UTF16toUTF8(str));
   Memo2.Append(string(timetostr(Time))+' upload of file: '+ LineEnding + UTF16toUTF8(str));
   Application.QueueAsyncCall(@spustUpload,1); // umistí do messageloop nakonec tzn spustí až
                                               // proběhne všechno co tam je tj. nakonec :-)
   Result:=true; // pro zobrazení stdandardního dialogu vrátit false
end;

procedure TForm1.spustUpload(Data: PtrInt);   // pomocná pro  QueueAsyncCall
var
    mujFrame:ICefFrame;
begin
   mujFrame:=Chromium.Browser.GetMainFrame;
   mujFrame.ExecuteJavaScript('start_tdt_upload();',mujFrame.GetURL(),0);
   if exportDoSluchatka  then exportDoSluchatka:= false
end;

procedure TForm1.ZQuery1AfterScroll(DataSet: TDataSet);    // pro vyběr SHIFT+kolečko
begin

 if  (ssShift in GetKeyShiftState)  then
                             begin
                                rxDBGrid1.SelectedRows.CurrentRowSelected:=true;
                                kolecko:=false;
                                //ShowMessage(inttostr(rxDBGrid1.SelectedRows.Count))
                             end
                                   else
                              if kolecko then
                                       begin
                                          rxDBGrid1.SelectedRows.CurrentRowSelected:=true;
                                          kolecko:=false;
                                         // ShowMessage('After scroll a kolečko je: '+ booltostr(kolecko));
                                       end;
//ShowMessage('AfterScroll ');

end;

procedure TForm1.ZQuery1BeforeScroll(DataSet: TDataSet);   // pro vyběr SHIFT+kolečko
begin
  if  (ssShift in GetKeyShiftState)  then
        begin
          rxDBGrid1.SelectedRows.CurrentRowSelected:=true;
        end
                                     else
                      if kolecko then
                             begin
                              // ShowMessage('Nuluju výběr a kolečko je' + booltostr(kolecko));
                              rxDBGrid1.SelectedRows.CurrentRowSelected:=false;
                              rxDBGrid1.SelectedRows.Refresh;
                             end;
   //ShowMessage('BeforeScroll ');
end;

procedure TForm1.ZQuery1PostError(DataSet: TDataSet; E: EDatabaseError;
  var DataAction: TDataAction);
begin
 E.Message:='It is not possible to save data, probably duplicity item';
 dataset.Cancel;
end;

procedure TForm1.ChromiumLoadEnd(Sender : TObject; const Browser : ICefBrowser; const Frame : ICefFrame;
  httpStatusCode : Integer);  // kaskáda pro doputování na settings_phonebook_transfer.html :-)
var
   mujFrame: ICefFrame;
   pomPin:String;

begin
  EUrl.Text := UTF8Encode(Browser.MainFrame.Url);
  if mujClickListener then
  Chromium.browser.SendProcessMessage(PID_RENDERER,TCefProcessMessageRef.New('addListener'));
  if not(prihlaseno) and (browser.GetMainFrame.GetUrl=UTF8ToUTF16('http://'+frmNastaveni.lblEditIpAdress.Text +'/login.html')) then
    begin
      if reloadPoOdhlaseni then
         begin
           reloadPoOdhlaseni:=false;
           exit;
         end;
      mujFrame:=Chromium.Browser.GetMainFrame; // lblEditPin.Text
      pomPin:=frmNastaveni.DCP_twofish1.DecryptString(frmNastaveni.lblEditPin.Text);
      frmNastaveni.DCP_twofish1.Reset; // !!! bez toho nefungují další procedury DCP !!!
      mujFrame.ExecuteJavaScript(UTF8ToUTF16('document.getElementById("password").value='+
                                   pomPin+';'+'submit_gigaset_form();'),
                                   mujFrame.GetURL(), 0); // "7205;"
      prihlaseno:=true;
      Memo1.Append(string(timetostr(Time))+' Logon finished:'+booltostr(prihlaseno,true));
    end;
  if not(jsemVHome) and (browser.GetMainFrame.GetUrl=UTF8ToUTF16('http://'+frmNastaveni.lblEditIpAdress.Text +'/home.html')) then
    begin
      Chromium.Load(UTF8ToUTF16('http://'+frmNastaveni.lblEditIpAdress.Text +'/settings_phonebook_transfer.html'));
      jsemVHome:=true;
      Memo1.Append(string(timetostr(Time))+' Home:'+booltostr(jsemVHome,true));
    end;
  if not(jsemVDirectory) and
    (browser.GetMainFrame.GetUrl=UTF8ToUTF16('http://'+frmNastaveni.lblEditIpAdress.Text +'/settings_phonebook_transfer.html')) then
    begin
      jsemVDirectory:=true;
      Memo1.Append(string(timetostr(Time))+' Directory:'+booltostr(jsemVDirectory,true));
      Chromium.browser.SendProcessMessage(PID_RENDERER,TCefProcessMessageRef.New('v8_zkouska'));
      Memo1.Append(string(timetostr(Time))+' Handsets request to the render process');
      // pokračuje v ChromiumProcessMessageReceived
    end;




  if (browser.GetMainFrame.GetUrl=UTF8ToUTF16('http://'+frmNastaveni.lblEditIpAdress.Text +'/logout.html')) then
     begin
       Memo1.Append(timetostr(Time)+' logoff finished (logout.html)');
       reloadPoOdhlaseni:=true;
       prihlaseno:=false;
     end;
end;

procedure TForm1.ChromiumKeyEvent(Sender: TObject;
  const Browser: ICefBrowser; const event: PCefKeyEvent;
  osEvent: TCefEventHandle; out Result: Boolean);
begin
  // for entering DOM sends message to render process (only place for obtaining DOM)
  Chromium.browser.SendProcessMessage(PID_RENDERER,TCefProcessMessageRef.New('visitdom'));
end;

// vyškrtnuto z cef3 (od 3.2454), lze realizovat javascriptem
// viz.: https://bitbucket.org/chromiumembedded/cef/issues/933/provide-alternate-implementation-for
//procedure mujEventListener(const event: ICefDomEvent); // obsluha pro event
//
// var
//    mojeMsg: ICefProcessMessage;
//
//    begin
//      mojeMsg := TCefProcessMessageRef.New('click');
//      mojeMsg.ArgumentList.SetString(0, UTF8ToUTF16(string(event.Target.Name)));
//      mujGlobalBrowser.SendProcessMessage(PID_BROWSER, mojeMsg);
//    end;


{TCustomRenderProcessHandler - zpracuje message poslaný do render procesu}
function TCustomRenderProcessHandler.OnProcessMessageReceived(
      const browser: ICefBrowser; sourceProcess: TCefProcessId;
      const message: ICefProcessMessage): Boolean ;


        procedure pokus(const document:ICefDomDocument); {user defined nested procedure}
          var
              mojeMessage: ICefProcessMessage;
              begin
                mojeMessage:=TCefProcessMessageRef.New('hodnota');
                mojeMessage.GetArgumentList.SetString(0,document.GetTitle);
                browser.SendProcessMessage(PID_BROWSER,mojeMessage);
                // for nested type procedure variables is needed:
                // adding {$modeswitch nestedprocvars} AFTER {$mode xxx} declaration in units:
                // cef3intf,cef3own, cef3ref;
                // and change line 121 in cef3intf.pas:
                //    TCefDomVisitorProc=procedure(const document:ICefDomDocument);
                // to
                //    TCefDomVisitorProc = procedure(const document: ICefDomDocument) is nested;
              end;

// vyškrtnuto z cef3 (od 3.2454), lze realizovat javascriptem
// viz.: https://bitbucket.org/chromiumembedded/cef/issues/933/provide-alternate-implementation-for
        //procedure dalsiPokus(const document:ICefDomDocument);
        //
        //var
        //    mujEventListener1:TCefDomEventListenerProc;
        //    msg: ICefProcessMessage;
        //
        //begin
        //  mujEventListener1:=@mujEventListener;
        //  document.Body.AddEventListenerProc('click',true,mujEventListener1);
        //  msg:=TCefProcessMessageRef.New('listenerAdded');
        //  browser.SendProcessMessage(PID_BROWSER,msg);
        //end;

  var
       pokus1,dalsiPokus1:TCefDomVisitorProc;
       context: ICefv8Context;
       {mujObjekt,}poku : ICefv8Value;    // by zbyna poslední změna
       exc:ICefV8Exception;
       pok: string;
       msg: ICefProcessMessage;

  begin   {TCustomRenderProcessHandler.OnProcessMessageReceived}
    case message.Name of
    'visitdom' :
        begin
          //pokus1:= @pokus;
          browser.MainFrame.VisitDomProc(pokus1);
          Result := True;
        end;
     // vyškrtnuto z cef3 (od 3.2454), lze realizovat javascriptem
     // viz.: https://bitbucket.org/chromiumembedded/cef/issues/933/provide-alternate-implementation-for
     //'addListener' :
     //    begin
     //      dalsiPokus1:=@dalsiPokus;
     //      browser.MainFrame.VisitDomProc(dalsiPokus1);
     //      Result:=true;
     //    end;
     'v8_zkouska' :
         begin
           context:=browser.GetMainFrame.GetV8Context;
          // mujObjekt:=browser.GetMainFrame.GetV8Context.GetGlobal;
           if context <> nil then
            begin
             //context.Enter;
             if context. Eval('String(window.handsets) ',poku,exc) then
                           pok:=UTF16ToUTF8(poku.GetStringValue)
                                                             else
                           pok:=UTF16ToUTF8(exc.GetMessage);
             msg:=TCefProcessMessageRef.New('v8_zkouska');
             msg.GetArgumentList.SetString(0,UTF8ToUTF16(pok)); // widestring(ustring) is utf16
             browser.SendProcessMessage(PID_BROWSER,msg);
            //context.Exit;
            end;
         end
     else
        Result:=false;
    end;
  end;   {TCustomRenderProcessHandler.OnProcessMessageReceived}

procedure TCustomRenderProcessHandler.OnBrowserCreated(
  const browser: ICefBrowser);
begin
  mujGlobalBrowser:=browser;
  //inherited OnBrowserCreated(browser);
end;


{zpracuje message poslaný  do browser procesu z libovolného procesu (zde z render procesu)}
procedure TForm1.ChromiumProcessMessageReceived(Sender: TObject;
  const Browser: ICefBrowser; sourceProcess: TCefProcessId;
  const message: ICefProcessMessage; out Result: Boolean);

  var
   mujFrame: ICefFrame;
   event:TCefMouseEvent;
   aType:TCefMouseButtonType;
   clickCount:integer;
   pomString: String;
  begin
    case message.Name  of
     'hodnota' :
          begin
            Memo1.Append(string(timetostr(Time)
                     +' Hodnota: '+UTF16toUTF8(message.GetArgumentList.GetString(0))));
            Result := True;
          end;
    'listenerAdded' :
          begin
            Memo1.Append(string(timetostr(Time))+' listener added');
          end;
    'click' :
         begin
           Memo1.Append(timetostr(Time)+ ' Click: '
                                 +string(message.GetArgumentList.GetString(0)));
           Result := True;
         end;
    'v8_zkouska' :
         begin
          Memo1.Append(timetostr(Time)+ ' v8_zkouska: '
                                +string(message.GetArgumentList.GetString(0)));
          handSets:=string(message.GetArgumentList.GetString(0));
          Memo1.Append(string(timetostr(Time))+' Handsets obtained');
          frmVyberHandsets.ShowModal;
          pomString:= inttostr(frmVyberHandsets.RadioGroup1.ItemIndex);
          mujFrame:=Chromium.Browser.GetMainFrame;
          mujFrame.ExecuteJavaScript(UTF8ToUTF16('document.getElementById("hs_phonebook_transf_radio_'+
                                      pomString+'").checked = true; '),mujFrame.GetURL(), 0);
          pomString:=frmVyberHandsets.RadioGroup1.Items.ValueFromIndex[strtoint(pomString)];
          Memo1.Append(string(timetostr(Time))+' Chosen handset: '+ (pomString));
          Memo2.Append(string(timetostr(Time))+' Chosen handset: '+ (pomString));
          //Chromium.SetFocus;
          //Chromium.Browser.Host.SendFocusEvent(14);


          if seznamDoPocitace then
            begin
              Memo1.Append(string(timetostr(Time))+' Preparing download to the computer :-)');
              mujFrame:=Chromium.Browser.GetMainFrame;
              mujFrame.ExecuteJavaScript('start_tdt_download();',
                                           mujFrame.GetURL(), 0);
              seznamDoPocitace:=false;
            end;
          if seznamDoTelefonu then
            begin
              // Chromium.Hide;
              // Memo1.Append(string(timetostr(Time))+'Schovávám Chromium :-)');
               event.x:=700;           //   440  výběr sluchátka 1
               event.y:=307;           //   275  výběr sluchátka 2
               event.modifiers:=[];
               aType:=MBT_LEFT;
               //mojeMouseUp:=true;
               clickCount:=1;
               Browser.Host.SendMouseClickEvent(event, aType, false, clickCount); // u MBT_RIGHT stačí pouze jedno volání s MouseUp:=true :-)))
               Browser.Host.SendMouseClickEvent(event, aType, true, clickCount);
               Memo1.Append(string(timetostr(Time))+' Custom Click na výběr souboru :-)');
               // custom click vyvolá obsluhu std obsluhu file input dialogu
               // tzn. TMainform.ChromiumFileDialog hledej v kódu nahoře :-)
              seznamDoTelefonu:=false;
            end;
         end
    else
      Result:=False;
    end;
  end;

procedure TForm1.ChromiumTitleChange(Sender : TObject; const Browser : ICefBrowser;
          const title : ustring);
begin
  // Caption := 'Browser - ' + UTF8Encode(title);
end;

procedure TForm1.EUrlKeyDown(Sender : TObject; var Key : Word; Shift : TShiftState);
begin
  If Key = VK_RETURN then BGoClick(Sender);
end;



 initialization
 CefRenderProcessHandler := TCustomRenderProcessHandler.Create; // pro přístup k DOM
 // ********************************************************** from former mainCEF
 // ********************************************************** END
end.

