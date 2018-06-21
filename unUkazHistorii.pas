unit unUkazHistorii;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil,  vte_edittree,VirtualTrees,
   Forms, Controls, Graphics, Dialogs, Menus;

type

  PTreeData = ^TTreeData;    { Ukazatel na data v node }
  TTreeData = record
    Column0: String;
  end;

  { TfrmUkazHistorii }

  TfrmUkazHistorii = class(TForm)
    menuItemClear: TMenuItem;
    menuItemUndo: TMenuItem;
    popUpVetRootNode: TPopupMenu;
    popUpVetItem: TPopupMenu;
    VET: TVirtualEditTree;
    vetRedo: TVirtualEditTree;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure menuItemClearClick(Sender: TObject);
    procedure menuItemUndoClick(Sender: TObject);
    procedure VETChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure VETFocusChanged(Sender: TBaseVirtualTree; Node: PVirtualNode;
                               Column: TColumnIndex);
    procedure VETFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure VETGetNodeDataSize(Sender: TBaseVirtualTree;
                                 var NodeDataSize: Integer);
    procedure VETGetPopupMenu(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; const P: TPoint; var AskParent: Boolean;
      var aPopupMenu: TPopupMenu);
    procedure VETGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: String);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  frmUkazHistorii: TfrmUkazHistorii;

implementation

{$R *.frm}

uses Unit1;
{ TfrmUkazHistorii }



{ OnChange }
procedure TfrmUkazHistorii.VETChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
//var pom,pom2: string;
begin
 VeT.Refresh;
    //str(VET.FocusedNode^.ChildCount,pom);
    //str(VET.getnodelevel(VET.FocusedNode),pom2);
    //Memo1.Clear;
    //Memo1.Append('Node level:' + pom2);
    //Memo1.Append('Child count:' + pom);
end;

procedure TfrmUkazHistorii.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
 // Application.ReleaseComponent(frmUkazHistorii);
end;

procedure TfrmUkazHistorii.FormCreate(Sender: TObject);
var
  XNodeRoot: PVirtualNode;
  Data: PTreeData;
begin
  // vet.Header.Columns.Items[0].Text:='Položky historie';
  //VET.NodeDataSize:=SizeOf(TTreeData);
  //XNodeRoot:=VET.AddChild(nil);
  //Data := VET.GetNodeData(XnodeRoot);
  //Data^.Column0:= 'Root';
end;

procedure TfrmUkazHistorii.menuItemClearClick(Sender: TObject);
begin
 // tady to by mělo být součástí Controlleru (MVC) a ne View :-)
 form1.undoPolozky.historyVector.Clear;
 form1.redoPolozky.historyVector.Clear;
 form1.undoPolozky.printHistoryVector;
 form1.redoPolozky.printHistoryVector;
end;

procedure TfrmUkazHistorii.menuItemUndoClick(Sender: TObject);
var
  vybrane: TNodeArray;
  indexVybraneNode: Cardinal;

begin
  vybrane:=vet.GetSortedSelection(False);
  indexVybraneNode:=vybrane[0]^.Index;
  vybrane:=nil;  // uvolní paměť
  // tady to by mělo být součástí Controlleru (MVC) a ne View :-)
  // kopíruj vybranou položku historie na konec undoPolozky:
  Form1.undoPolozky.historyVector.PushBack(
    Form1.undoPolozky.historyVector[indexVybraneNode]);
  // vymaž vybranou položku z undoPoložky
  Form1.undoPolozky.historyVector.Erase(indexVybraneNode);
  // zavolej normální undo
  Form1.MenuItemUndo.Click;
end;

{ OnFokusChanged }
procedure TfrmUkazHistorii.VETFocusChanged(Sender: TBaseVirtualTree; Node: PVirtualNode;
  Column: TColumnIndex);

begin
VeT.Refresh;
end;

{ OnFreeNode }
procedure TfrmUkazHistorii.VETFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
var
  Data: PTreeData;
begin
  Data:=VET.GetNodeData(Node);
  if Assigned(Data) then
  begin
    Data^.Column0 := '';
  end;
end;

 { OnGetNodeDataSize }
procedure TfrmUkazHistorii.VETGetNodeDataSize(Sender: TBaseVirtualTree;
  var NodeDataSize: Integer);
begin
   NodeDataSize := SizeOf(TTreeData);
end;

procedure TfrmUkazHistorii.VETGetPopupMenu(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; const P: TPoint;
  var AskParent: Boolean; var aPopupMenu: TPopupMenu);
var
  level: Cardinal;
  Data: PTreeData;
begin
  AskParent:=False;
  level:=VET.GetNodeLevel(Node); //Node^.Index;
  Data:=VET.GetNodeData(Node);
  case level of
   0: aPopupMenu:=popUpVetRootNode;
   1:begin
       aPopupMenu:=popUpVetItem;
       if node <> nil then
               aPopupMenu.Items.Items[0].Caption:='Undo History Item name: '+
                                                 Data^.Column0;
     end;
  end;
end;

  { OnGetText - klíčová pro zobrazení sloupce }
procedure TfrmUkazHistorii.VETGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
  Column: TColumnIndex; TextType: TVSTTextType; var CellText: String);
var
  Data: PTreeData;
begin
  Data := VET.GetNodeData(Node);
  case Column of
    0: CellText := Data^.Column0;
  end
end;

end.

