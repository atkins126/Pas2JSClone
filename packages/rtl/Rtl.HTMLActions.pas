unit Rtl.HTMLActions;

{$mode ObjFPC}
{$H+}

interface

uses
  {$ifdef pas2js}
  web,
  {$endif}
  RTL.HTMLEventNames, Classes, SysUtils, Rtl.HTMLUtils;

Type
   {$ifndef pas2js}
   TJSEvent = Class(TObject);
   TJSElement = class(TObject);
   TJSHTMLElement = class(TJSElement);
   TJSHTMLElementArray = array of TJSHTMLElement;

   {$endif}
   THTMLNotifyEvent = Procedure (Sender : TObject; Event : TJSEvent) of object;
   THTMLCustomElementActionList = Class;

   { THTMLElementAction }

   { THTMLCustomElementAction }

   TForeachHTMLElementDataEx = {$ifdef pas2js}reference to {$endif} procedure (aElement : TJSHTMLElement; aData : TObject);
   TForeachHTMLElementData = {$ifdef pas2js}reference to {$endif} procedure (aElement : TJSHTMLElement);

   THTMLCustomElementAction = class(TComponent)
   private
     FActionList: THTMLCustomElementActionList;
     FCSSSelector: String;
     FCustomEvents: String;
     FElementID: String;
     FElement : TJSHTMLElement;
     FElements: TJSHTMLElementArray;
     FEvents: THTMLEvents;
     FOnExecute: THTMLNotifyEvent;
     FPreventDefault: Boolean;
     FStopPropagation: Boolean;
     FBeforeBind : TNotifyEvent;
     FAfterBind : TNotifyEvent;
     function GetChecked: Boolean;
     function GetDisabled: Boolean;
     function GetIndex: Integer;
     procedure SetActionList(AValue: THTMLCustomElementActionList);
     procedure SetChecked(AValue: Boolean);
     procedure SetCSSSelector(AValue: String);
     procedure SetCustomEvents(AValue: String);
     procedure SetDisabled(AValue: Boolean);
     procedure SetElementID(AValue: String);
     procedure SetIndex(AValue: Integer);
   Protected
     function GetValue: String; virtual;
     procedure SetValue(AValue: String); virtual;
     procedure SetParentComponent(AParent: TComponent); override;
     procedure ReadState(Reader: TReader); override;
     Procedure BindElementEvents; virtual;
     Procedure DoBind;
     Procedure DoBeforeBind; virtual;
     Procedure DoAfterBind; virtual;

   Public
     Destructor Destroy; override;
     Class Function GetElementChecked(aElement : TJSHTMLElement) : boolean; virtual;
     Class Function GetElementDisabled(aElement : TJSHTMLElement) : boolean; virtual;
     Class Function GetElementValue(aElement : TJSHTMLElement) : String; virtual;
     Class Procedure SetElementValue(aElement : TJSHTMLElement; const aValue : String; asHTML : Boolean = false); virtual;
     Class Procedure SetElementChecked(aElement : TJSHTMLElement; const aValue : Boolean); virtual;
     Class Procedure SetElementDisabled(aElement : TJSHTMLElement; const aValue : Boolean); virtual;
     function GetParentComponent: TComponent; override;
     function HasParent: Boolean; override;
     Procedure Bind;
     Procedure ClearValue; virtual;
     Procedure FocusControl; virtual;
     Procedure BindEvents(aEl : TJSElement); virtual;
     procedure HandleEvent(Event: TJSEvent); virtual;
     Procedure ForEach(aCallback : TForeachHTMLElementDataEx; aData : TObject); overload;
     Procedure ForEach(aCallback : TForeachHTMLElementData); overload;
     Procedure AddClass(const aClass : String);
     Procedure RemoveClass(const aClass : String);
     Procedure ToggleClass(const aClass : String);
     Property ActionList : THTMLCustomElementActionList Read FActionList Write SetActionList;
     Property Element : TJSHTMLElement Read FElement;
     Property Elements : TJSHTMLElementArray Read FElements;
     Property Index : Integer Read GetIndex Write SetIndex;
     // When reading, only the first value is returned in case of multiple elements.
     // When writing, the value is set on all elements.
     Property Value : String Read GetValue Write SetValue;
     property checked : Boolean Read GetChecked write SetChecked;
     property Disabled : Boolean Read GetDisabled Write SetDisabled;
   Public
     // These can be published in descendents
     Property Events : THTMLEvents Read FEvents Write FEvents;
     Property CustomEvents : String Read FCustomEvents Write SetCustomEvents;
     Property ElementID : String Read FElementID Write SetElementID;
     Property CSSSelector : String Read FCSSSelector Write SetCSSSelector;
     Property OnExecute : THTMLNotifyEvent Read FOnExecute Write FOnExecute;
     Property PreventDefault : Boolean Read FPreventDefault Write FPreventDefault default false;
     Property StopPropagation : Boolean Read FStopPropagation Write FStopPropagation default false;
     property BeforeBind : TNotifyEvent Read FBeforeBind Write FAfterBind;
     Property AfterBind : TNotifyEvent Read FAfterBind Write FAfterBind;
   end;
   THTMLCustomElementActionClass = Class of THTMLCustomElementAction;
   THTMLCustomElementActionArray = Array of THTMLCustomElementAction;

   THTMLElementAction = Class(THTMLCustomElementAction)
   Published
     Property Events;
     Property CustomEvents;
     Property ElementID;
     Property CSSSelector;
     Property PreventDefault;
     Property StopPropagation;
     Property OnExecute;
     Property BeforeBind;
     Property AfterBind;
   end;
   THTMLElementActionClass = class of THTMLElementAction;

   THTMLGLobalNotifyEvent = Procedure (Sender : TObject; Event : TJSEvent; var Handled: Boolean) of object;

   { THTMLCustomElementActionList }

   THTMLCustomElementActionList = class(TComponent,IHTMLClient)
   private
     FAfterBind: TNotifyEVent;
     FBeforeBind: TNotifyEVent;
     FList : TFPList;
     FOnExecute: THTMLGLobalNotifyEvent;
     function GetAction(aIndex: Integer): THTMLCustomElementAction;
     function GetActionsCount: Integer;
   Protected
     class function CreateAction(aOwner : TComponent) : THTMLCustomElementAction; virtual;
     function GetActionIndex(aAction : THTMLCustomElementAction) : Integer;
     Procedure SetActionIndex(aAction : THTMLCustomElementAction; aValue : Integer);
     procedure GetChildren(Proc: TGetChildProc; Root: TComponent); override;
     Procedure AddAction(aAction: THTMLCustomElementAction); virtual;
     Procedure RemoveAction(aAction: THTMLCustomElementAction); virtual;
     Function ExecuteAction(aAction: THTMLCustomElementAction; aEvent : TJSEvent) : Boolean; virtual;
     procedure DoBeforeBind; virtual;
     procedure DoAfterBind; virtual;
     procedure HTMLLoaded; virtual;
     procedure HTMLRendered; virtual;
   Public
     Constructor Create(aOwner : TComponent); override;
     Destructor Destroy; override;
     Procedure Clear;
     Procedure Bind;
     Function IndexOfElementID(aID : String; StartAt : Integer = 0) : Integer;
     Function FindActionByElementID(aID : String; StartAt : Integer = 0) : THTMLCustomElementAction;
     Function GetActionsForElementID(aID : String) : THTMLCustomElementActionArray;
     Function NewAction(aOwner: TComponent) : THTMLCustomElementAction;
     Function ActionByName(aName : String) : THTMLCustomElementAction;
     Property Actions[aIndex: Integer] : THTMLCustomElementAction Read GetAction;
     Property ActionCount : Integer Read GetActionsCount;
   Protected
     Property OnExecute : THTMLGLobalNotifyEvent Read FOnExecute Write FOnExecute;
     Property BeforeBind : TNotifyEVent Read FBeforeBind Write FBeforeBind;
     Property AfterBind : TNotifyEVent Read FAfterBind Write FAfterBind;
   end;

   THTMLElementActionList = Class(THTMLCustomElementActionList)
   Published
     Property OnExecute;
     Property BeforeBind;
     Property AfterBind;
   end;


implementation

uses StrUtils;

{ ----------------------------------------------------------------------
  THTMLCustomElementActionList
  ----------------------------------------------------------------------}


function THTMLCustomElementActionList.GetAction(aIndex: Integer
  ): THTMLCustomElementAction;
begin
  Result:=THTMLCustomElementAction(FList[aIndex])
end;

function THTMLCustomElementActionList.GetActionsCount: Integer;
begin
  Result:=FList.Count;
end;

function THTMLCustomElementActionList.GetActionIndex(
  aAction: THTMLCustomElementAction): Integer;
begin
  Result:=FList.IndexOf(aAction);
end;

procedure THTMLCustomElementActionList.SetActionIndex(
  aAction: THTMLCustomElementAction; aValue: Integer);

Var
  Old : Integer;

begin
  Old:=GetActionIndex(aAction);
  if Old<>aValue then
    FList.Move(Old,aValue);
end;

procedure THTMLCustomElementActionList.GetChildren(Proc: TGetChildProc;
  Root: TComponent);

Var
  I : Integer;
  aAction : THTMLCustomElementAction;

begin
  If Proc=Nil then
    exit;
  for I := 0 to ActionCount - 1 do
    begin
    aAction:=Actions[I];
    if (aAction.Owner=Root) then
      Proc(aAction);
    end;
end;

procedure THTMLCustomElementActionList.AddAction(
  aAction: THTMLCustomElementAction);
begin
  FList.Add(aAction);
end;

procedure THTMLCustomElementActionList.RemoveAction(
  aAction: THTMLCustomElementAction);
begin
  FList.Remove(aAction);
end;

function THTMLCustomElementActionList.ExecuteAction(
  aAction: THTMLCustomElementAction; aEvent: TJSEvent): Boolean;
begin
  Result:=False;
  if Assigned(FOnExecute) then
    FOnExecute(aAction,aEvent,Result);
end;

procedure THTMLCustomElementActionList.DoBeforeBind;
begin
  if assigned(FBeforeBind) then
    FBeforeBind(Self);
end;

procedure THTMLCustomElementActionList.DoAfterBind;
begin
  if assigned(FAfterBind) then
    FAfterBind(Self);
end;

constructor THTMLCustomElementActionList.Create(aOwner: TComponent);
begin
  inherited Create(aOwner);
  FList:=TFPList.Create;
end;

destructor THTMLCustomElementActionList.Destroy;
begin
  Clear;
  FreeAndNil(FList);
  inherited Destroy;
end;

procedure THTMLCustomElementActionList.Clear;

Var
  A : THTMLCustomElementAction;

begin
  While ActionCount>0 do
    begin
    A:=Actions[ActionCount-1];
    A.Free;
    end;
end;

procedure THTMLCustomElementActionList.Bind;

Var
  I : Integer;

begin
  DoBeforeBind;
  For I:=0 to ActionCount-1 do
     Actions[I].Bind;
  DoAfterBind;
end;

function THTMLCustomElementActionList.IndexOfElementID(aID: String;
  StartAt: Integer): Integer;
begin
  Result:=StartAt;
  if Result<0 then
    Result:=0;
  While (Result<ActionCount) and (GetAction(Result).ElementID<>aID) do
    Inc(Result);
  If Result>=ActionCount then
    Result:=-1;
end;

function THTMLCustomElementActionList.FindActionByElementID(aID: String;
  StartAt: Integer): THTMLCustomElementAction;

Var
  Idx : Integer;

begin
  Idx:=IndexOfElementID(aID,StartAt);
  if Idx=-1 then
    Result:=Nil
  else
    Result:=GetAction(Idx);
end;

function THTMLCustomElementActionList.GetActionsForElementID(aID: String): THTMLCustomElementActionArray;

Var
  Idx,aCount : Integer;

begin
  SetLength(Result,10);
  Idx:=IndexOfElementID(aID,0);
  aCount:=0;
  While (Idx<>-1) do
    begin
    if Length(Result)<=aCount then
      SetLength(Result,Length(Result)+10);
    Result[aCount]:=GetAction(Idx);
    Inc(aCount);
    Idx:=IndexOfElementID(aID,Idx+1);
    end;
  SetLength(Result,aCount);
end;

function THTMLCustomElementActionList.NewAction(aOwner: TComponent
  ): THTMLCustomElementAction;
begin
  Result:=CreateAction(aOwner);
  Result.ActionList:=Self;
end;

class function THTMLCustomElementActionList.CreateAction(aOwner: TComponent
  ): THTMLCustomElementAction;
begin
  Result:=THTMLElementAction.Create(aOwner);
end;

function THTMLCustomElementActionList.ActionByName(aName: String
  ): THTMLCustomElementAction;

Var
  I : Integer;

begin
  Result:=Nil;
  I:=ActionCount-1;
  While (Result=Nil) and (I>=0) do
    begin
    Result:=Actions[i];
    If Not SameText(Result.Name,aName) then
      Result:=Nil;
    Dec(I);
    end;
end;

{ ----------------------------------------------------------------------
  THTMLCustomElementAction
  ----------------------------------------------------------------------}


procedure THTMLCustomElementAction.SetActionList(AValue: THTMLCustomElementActionList);

begin
  if (aValue=FActionList) then exit;
  if Assigned(FActionList) then
    FActionList.RemoveAction(Self);
  FActionList:=aValue;
  if Assigned(FActionList) then
    FActionList.AddAction(Self);
end;

procedure THTMLCustomElementAction.SetChecked(AValue: Boolean);

  procedure DoSetChecked(aElement: TJSHTMLElement);
  begin
    SetElementChecked(aElement,aValue);
  end;

begin
  ForEach(@DoSetChecked);
end;

function THTMLCustomElementAction.GetIndex: Integer;
begin
  if Assigned(FActionList) then
    Result:=FActionList.GetActionIndex(Self)
  else
    Result:=-1;
end;

function THTMLCustomElementAction.GetChecked: Boolean;
begin
  if (Length(FElements)>0) and Assigned (FElements[0]) then
    Result:=GetElementChecked(FElements[0]);
end;

function THTMLCustomElementAction.GetDisabled: Boolean;
begin
  if (Length(FElements)>0) and Assigned (FElements[0]) then
    Result:=GetElementDisabled(FElements[0]);
end;

function THTMLCustomElementAction.GetValue: String;
begin
  if (Length(FElements)>0) and Assigned (FElements[0]) then
    Result:=GetElementValue(FElements[0]);
end;

procedure THTMLCustomElementAction.SetIndex(AValue: Integer);
begin
  FActionList.SetActionIndex(Self,aValue);
end;

procedure THTMLCustomElementAction.SetValue(AValue: String);

  procedure DoSetValue(aElement: TJSHTMLElement);
  begin
    SetElementValue(aElement,aValue);
  end;

begin
  ForEach(@DoSetValue);
end;

function THTMLCustomElementAction.GetParentComponent: TComponent;
begin
  if ActionList <> nil then
    Result := ActionList
  else
    Result := inherited GetParentComponent;
end;

destructor THTMLCustomElementAction.Destroy;
begin
  if Assigned(ActionList) then
    ActionList.RemoveAction(Self);
  Inherited;
end;

class function THTMLCustomElementAction.GetElementChecked(
  aElement: TJSHTMLElement): boolean;
begin
  Result:=aElement.IsChecked;
end;

class function THTMLCustomElementAction.GetElementDisabled(
  aElement: TJSHTMLElement): boolean;
begin
  Result:=aElement.IsDisabled;
end;

class function THTMLCustomElementAction.GetElementValue(aElement: TJSHTMLElement
  ): String;
begin
  Result:=aElement.InputValue;
end;

procedure THTMLCustomElementActionList.HTMLLoaded;
begin
  // Do nothing
end;

procedure THTMLCustomElementActionList.HTMLRendered;
begin
  Bind;
end;

class procedure THTMLCustomElementAction.SetElementValue(
  aElement: TJSHTMLElement; const aValue: String; asHTML: Boolean);
begin
  if AsHTML then
    begin
    if Assigned(aElement) then
      aElement.InnerHTML:=aValue
    else
      Console.Debug('('+ClassName+') : Attempting to set value "'+aValue+'" on nil element.');
    end
  else
    aElement.InputValue:=aValue;
end;

class procedure THTMLCustomElementAction.SetElementChecked(
  aElement: TJSHTMLElement; const aValue: Boolean);
begin
  aElement.IsChecked:=aValue;
end;

class procedure THTMLCustomElementAction.SetElementDisabled(
  aElement: TJSHTMLElement; const aValue: Boolean);
begin
  aElement.IsDisabled:=aValue;
end;

procedure THTMLCustomElementAction.SetCSSSelector(AValue: String);
begin
  if (FCSSSelector=aValue) then exit;
  FCSSSelector:=aValue;
  If Not (csDesigning in ComponentState) then
    Bind;
end;

procedure THTMLCustomElementAction.SetCustomEvents(AValue: String);
begin
  if (FCustomEvents=aValue) then exit;
  FCustomEvents:=aValue;
  If Not (csDesigning in ComponentState) then
    BindElementEvents;
end;

procedure THTMLCustomElementAction.SetDisabled(AValue: Boolean);
  procedure DoSetChecked(aElement: TJSHTMLElement);
  begin
    SetElementDisabled(aElement,aValue);
  end;

begin
  ForEach(@DoSetChecked);
end;

procedure THTMLCustomElementAction.SetElementID(AValue: String);
begin
  if (FElementID=aValue) then exit;
  FElementID:=aValue;
  If Not (csDesigning in ComponentState) then
    Bind;
end;

procedure THTMLCustomElementAction.DoBeforeBind;

begin
  If Assigned(FBeforeBind) then
    FBeforeBind(Self);
end;

procedure THTMLCustomElementAction.DoAfterBind;

begin
   If Assigned(FAfterBind) then
    FAfterBind(Self);
end;


procedure THTMLCustomElementAction.ForEach(
  aCallback: TForeachHTMLElementDataEx; aData: TObject);

Var
  El : TJSHTMLElement;

begin
  For el in FElements do
    if El<>Nil then
      aCallBack(El,aData);
end;

procedure THTMLCustomElementAction.ForEach(aCallback: TForeachHTMLElementData);
Var
  El : TJSHTMLElement;

begin
  For el in FElements do
    if El<>Nil then
      aCallBack(El);
end;


procedure THTMLCustomElementAction.SetParentComponent(AParent: TComponent);
begin
  if not(csLoading in ComponentState) and (AParent is THTMLCustomElementActionList) then
    ActionList := THTMLCustomElementActionList(AParent);
end;

procedure THTMLCustomElementAction.ReadState(Reader: TReader);

begin
  inherited ReadState(Reader);
  if Reader.Parent is THTMLCustomElementActionList then
    ActionList := THTMLCustomElementActionList(Reader.Parent);
end;

function THTMLCustomElementAction.HasParent: Boolean;
begin
  if Assigned(ActionList) then
    Result:=True
  else
    Result:=inherited HasParent;
end;

{ ----------------------------------------------------------------------
  The methods in this last part are either empty or implemented,
  depending on whether the unit is used in FPC (IDE) or pas2js
  ----------------------------------------------------------------------}


{$ifdef pas2js}

procedure THTMLCustomElementAction.BindElementEvents;

Var
  El : TJSHTMLElement;

begin
  For el in FElements do
    if Assigned(El) then
      BindEvents(El);
end;

procedure THTMLCustomElementAction.Bind;

begin
  DoBeforeBind;
  DoBind;
  DoAfterBind;
end;

procedure THTMLCustomElementAction.DoBind;

Var
  Nodes : TJSNodeList;
  I : Integer;

begin
  FElement:=Nil;
  FElements:=Nil;
  if ElementID<>'' then
    begin
    FElement:=TJSHTMLElement(document.getElementById(ElementID));
    FElements:=[FElement];
    end
  else if CSSSelector<>'' then
    begin
    Nodes:=document.querySelectorAll(CSSSelector);
    SetLength(FElements,Nodes.length);
    For I:=0 to Nodes.length-1 do
      Felements[I]:=TJSHTMLElement(Nodes.item(I));
    end;
  BindElementEvents;
  DoAfterBind;
end;


procedure THTMLCustomElementAction.ClearValue;
begin
  Value:='';
end;

procedure THTMLCustomElementAction.FocusControl;
begin
  If (ElementID<>'') and Assigned(Element) then
    Element.focus;
end;

procedure THTMLCustomElementAction.HandleEvent(Event: TJSEvent);

Var
  isHandled : Boolean;

begin
  isHandled:=False;
  if Assigned(ActionList) then
    IsHandled:=ActionList.ExecuteAction(Self,Event);
  If (Not IsHandled) and Assigned(FOnExecute) then
    FonExecute(Self,Event);
  if StopPropagation then
    Event.stopPropagation;
  if PreventDefault then
    Event.preventDefault;
end;
procedure THTMLCustomElementAction.AddClass(const aClass: String);
begin
  ForEach(procedure (aEl : TJSHTMLElement)
    begin
    aEl.classList.add(aClass);
    end
  );
end;

procedure THTMLCustomElementAction.RemoveClass(const aClass: String);
begin
  ForEach(procedure (aEl : TJSHTMLElement)
    begin
    aEl.classList.Remove(aClass);
    end
  );
end;

procedure THTMLCustomElementAction.ToggleClass(const aClass: String);
begin
  ForEach(procedure (aEl : TJSHTMLElement)
    begin
    aEl.classList.toggle(aClass);
    end
  );
end;

procedure THTMLCustomElementAction.BindEvents(aEl: TJSElement);

Const
  Delims = [',',' '];

var
  H : THTMLEvent;
  I,aCount : Integer;
  S : String;

begin
  For h in THTMLEvent do
    if H in Events then
      aEl.addEventListener(HTMLEventNameArray[H],@HandleEvent)
    else
      aEl.removeEventListener(HTMLEventNameArray[H],@HandleEvent);
  aCount:=WordCount(CustomEvents,Delims);
  For I:=1 to aCount do
    begin
    S:=ExtractWord(I,CustomEvents,Delims);
    aEl.addEventListener(S,@HandleEvent);
    end;
end;

{$else}

procedure THTMLCustomElementAction.BindElementEvents;
begin

end;


procedure THTMLCustomElementAction.Bind;
begin

end;

procedure THTMLCustomElementAction.HandleEvent(Event: TJSEvent);
begin

end;

procedure THTMLCustomElementAction.AddClass(const aClass: String);
begin
end;

procedure THTMLCustomElementAction.RemoveClass(const aClass: String);
begin

end;

procedure THTMLCustomElementAction.ToggleClass(const aClass: String);

begin

end;

procedure THTMLCustomElementAction.BindEvents(aEl: TJSElement);

begin

end;

{$endif}

end.

