{
    This file is part of the Pas2JS run time library.
    Copyright (c) 2018 by Mattias Gaertner

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}
unit RTTI;

{$mode objfpc}
{$ModeSwitch advancedrecords}

interface

uses
  JS, RTLConsts, Types, SysUtils, TypInfo;

resourcestring
  SErrInvokeInvalidCodeAddr = 'CodeAddress is not a function';
  SErrTypeIsNotEnumerated  = 'Type %s is not an enumerated type';

type
  { TValue }

  TValue = record
  private
    FTypeInfo: TTypeInfo;
    FData: JSValue;
    FReferenceVariableData: Boolean;
    function GetData: JSValue;
    function GetIsEmpty: boolean;
    function GetTypeKind: TTypeKind;

    procedure SetData(const Value: JSValue);
  public
    class function Empty: TValue; static;
    generic class function From<T>(const Value: T): TValue; static;
    class function FromArray(TypeInfo: TTypeInfo; const Values: specialize TArray<TValue>): TValue; static;
    class function FromJSValue(v: JSValue): TValue; static;
    class function FromOrdinal(ATypeInfo: TTypeInfo; AValue: JSValue): TValue; static;
    class procedure Make(const ABuffer: JSValue; const ATypeInfo: PTypeInfo; var Result: TValue); overload; static;
    generic class procedure Make<T>(const Value: T; var Result: TValue); overload; static;

    function AsBoolean: boolean;
    function AsClass: TClass;
    //ToDo: function AsCurrency: Currency;
    function AsExtended: Extended;
    function AsInteger: Integer;
    function AsInterface: IInterface;
    function AsJSValue: JSValue;
    function AsNativeInt: NativeInt;
    function AsObject: TObject;
    function AsOrdinal: NativeInt;
    function AsString: string;
    generic function AsType<T>: T;
    function AsUnicodeString: UnicodeString;
    function Cast(ATypeInfo: TTypeInfo; const EmptyAsAnyType: Boolean = True): TValue; overload;
    generic function Cast<T>(const EmptyAsAnyType: Boolean = True): TValue; overload;
    function IsType(ATypeInfo: TTypeInfo; const EmptyAsAnyType: Boolean = True): Boolean; overload;
    generic function IsType<T>(const EmptyAsAnyType: Boolean = True): Boolean; overload;
    function GetArrayElement(aIndex: SizeInt): TValue;
    function GetArrayLength: SizeInt;
    function IsArray: boolean;
    function IsClass: boolean;
    function IsObject: boolean;
    function IsObjectInstance: boolean;
    function IsOrdinal: boolean;
    function IsType(ATypeInfo: TTypeInfo): boolean;
    function ToString: String;
    function TryCast(ATypeInfo: TTypeInfo; out AResult: TValue; const EmptyAsAnyType: Boolean = True): Boolean;

    procedure SetArrayElement(aIndex: SizeInt; const AValue: TValue);
    procedure SetArrayLength(const Size: SizeInt);

    property IsEmpty: boolean read GetIsEmpty; // check if nil or undefined
    property Kind: TTypeKind read GetTypeKind;
    property TypeInfo: TTypeInfo read FTypeInfo;
  end;

  TRttiType = class;
  TRttiInstanceType = class;
  TRttiInstanceExternalType = class;

  { TRTTIContext }

  TRTTIContext = record
  public
    class function Create: TRTTIContext; static;
    procedure Free;

    function FindType(const AQualifiedName: String): TRttiType;
    function GetType(aTypeInfo: PTypeInfo): TRTTIType; overload;
    function GetType(aClass: TClass): TRTTIType; overload;
    function GetTypes: specialize TArray<TRttiType>;

    class procedure KeepContext; static;
    class procedure DropContext; static;
  end;

  { TRttiObject }

  TRttiObject = class abstract
  private
    FAttributesLoaded: Boolean;
    FAttributes: TCustomAttributeArray;
    FParent: TRttiObject;
    FHandle: Pointer;
  protected
    function LoadCustomAttributes: TCustomAttributeArray; virtual;
  public
    constructor Create(AParent: TRttiObject; AHandle: Pointer); virtual;

    destructor Destroy; override;

    function GetAttributes: TCustomAttributeArray;
    generic function GetAttribute<T: TCustomAttribute>: T;
    function GetAttribute(const Attribute: TCustomAttributeClass): TCustomAttribute;
    generic function HasAttribute<T: TCustomAttribute>: Boolean;
    function HasAttribute(const Attribute: TCustomAttributeClass): Boolean;

    property Attributes: TCustomAttributeArray read GetAttributes;
    property Handle: Pointer read FHandle;
    property Parent: TRttiObject read FParent;
  end;

  { TRttiNamedObject }

  TRttiNamedObject = class(TRttiObject)
  protected
    function GetName: string; virtual;
  public
    property Name: string read GetName;
  end;

  { TRttiMember }

  TMemberVisibility=(
    mvPrivate,
    mvProtected,
    mvPublic,
    mvPublished);

  TRttiMember = class(TRttiNamedObject)
  protected
    function GetMemberTypeInfo: TTypeMember;
    function GetName: String; override;
    function GetParent: TRttiType;
    function GetVisibility: TMemberVisibility; virtual;
    function LoadCustomAttributes: TCustomAttributeArray; override;
  public
    constructor Create(AParent: TRttiType; ATypeInfo: TTypeMember);

    property MemberTypeInfo: TTypeMember read GetMemberTypeInfo;
    property Parent: TRttiType read GetParent;
    property Visibility: TMemberVisibility read GetVisibility;
  end;

  { TRttiField }

  TRttiField = class(TRttiMember)
  private
    function GetFieldType: TRttiType;
    function GetFieldTypeInfo: TTypeMemberField;
  public
    constructor Create(AParent: TRttiType; ATypeInfo: TTypeMember);
    function GetValue(Instance: JSValue): TValue;
    procedure SetValue(Instance: JSValue; const AValue: TValue);
    property FieldType: TRttiType read GetFieldType;
    property FieldTypeInfo: TTypeMemberField read GetFieldTypeInfo;
  end;

  TRttiFieldArray = specialize TArray<TRttiField>;

  { TRttiParameter }

  TRttiParameter = class(TRttiNamedObject)
  private
    FParamType: TRttiType;
    FFlags: TParamFlags;
    FName: String;
  protected
    function GetName: string; override;
  public
    property Flags: TParamFlags read FFlags;
    property ParamType: TRttiType read FParamType;
  end;

  TRttiParameterArray = specialize TArray<TRttiParameter>;

  { TRttiMethod }

  TRttiMethod = class(TRttiMember)
  private
    FParameters: TRttiParameterArray;
    FParametersLoaded: Boolean;

    function GetIsAsyncCall: Boolean;
    function GetIsClassMethod: Boolean;
    function GetIsConstructor: Boolean;
    function GetIsDestructor: Boolean;
    function GetIsExternal: Boolean;
    function GetIsSafeCall: Boolean;
    function GetIsStatic: Boolean;
    function GetIsVarArgs: Boolean;
    function GetMethodKind: TMethodKind;
    function GetMethodTypeInfo: TTypeMemberMethod;
    function GetProcedureFlags: TProcedureFlags;
    function GetReturnType: TRttiType;

    procedure LoadParameters;
  public
    function GetParameters: TRttiParameterArray;
    function Invoke(const Instance: TValue; const Args: array of TValue): TValue;
    function Invoke(const Instance: TObject; const Args: array of TValue): TValue;
    function Invoke(const aClass: TClass; const Args: array of TValue): TValue;

    property IsAsyncCall: Boolean read GetIsAsyncCall;
    property IsClassMethod: Boolean read GetIsClassMethod;
    property IsConstructor: Boolean read GetIsConstructor;
    property IsDestructor: Boolean read GetIsDestructor;
    property IsExternal: Boolean read GetIsExternal;
    property IsSafeCall: Boolean read GetIsSafeCall;
    property IsStatic: Boolean read GetIsStatic;
    property MethodKind: TMethodKind read GetMethodKind;
    property MethodTypeInfo: TTypeMemberMethod read GetMethodTypeInfo;
    property ReturnType: TRttiType read GetReturnType;
  end;

  TRttiMethodArray = specialize TArray<TRttiMethod>;

  { TRttiProperty }

  TRttiProperty = class(TRttiMember)
  private
    function GetPropertyTypeInfo: TTypeMemberProperty;
    function GetPropertyType: TRttiType;
    function GetIsWritable: boolean;
    function GetIsReadable: boolean;
  protected
    function GetVisibility: TMemberVisibility; override;
  public
    constructor Create(AParent: TRttiType; ATypeInfo: TTypeMember);

    function GetValue(Instance: JSValue): TValue;

    procedure SetValue(Instance: JSValue; const AValue: TValue);

    property PropertyTypeInfo: TTypeMemberProperty read GetPropertyTypeInfo;
    property PropertyType: TRttiType read GetPropertyType;
    property IsReadable: boolean read GetIsReadable;
    property IsWritable: boolean read GetIsWritable;
    property Visibility: TMemberVisibility read GetVisibility;
  end;

  TRttiInstanceProperty = class(TRttiProperty)
  end;

  TRttiPropertyArray = specialize TArray<TRttiProperty>;

  { TRttiType }

  TRttiType = class(TRttiNamedObject)
  private
    //FMethods: specialize TArray<TRttiMethod>;
    function GetAsInstance: TRttiInstanceType;
    function GetAsInstanceExternal: TRttiInstanceExternalType;
    function GetDeclaringUnitName: string;
    function GetHandle: TTypeInfo;
    function GetQualifiedName: String;
  protected
    function GetName: string; override;
    //function GetHandle: Pointer; override;
    function GetIsInstance: Boolean;
    function GetIsInstanceExternal: Boolean;
    //function GetIsManaged: Boolean; virtual;
    function GetIsOrdinal: Boolean; virtual;
    function GetIsRecord: Boolean; virtual;
    function GetIsSet: Boolean; virtual;
    function GetTypeKind: TTypeKind; virtual;
    //function GetTypeSize: integer; virtual;
    function GetBaseType: TRttiType; virtual;
    function LoadCustomAttributes: TCustomAttributeArray; override;
  public
    function GetField(const AName: string): TRttiField; virtual;
    function GetFields: TRttiFieldArray; virtual;
    function GetMethods: TRttiMethodArray; virtual;
    function GetMethods(const aName: String): TRttiMethodArray; virtual;
    function GetMethod(const aName: String): TRttiMethod; virtual;
    function GetProperty(const AName: string): TRttiProperty; virtual;
    //function GetIndexedProperty(const AName: string): TRttiIndexedProperty; virtual;
    function GetProperties: TRttiPropertyArray; virtual;
    function GetDeclaredProperties: TRttiPropertyArray; virtual;
    //function GetDeclaredIndexedProperties: TRttiIndexedPropertyArray; virtual;
    function GetDeclaredMethods: TRttiMethodArray; virtual;
    function GetDeclaredFields: TRttiFieldArray; virtual;

    property Handle: TTypeInfo read GetHandle;
    property IsInstance: Boolean read GetIsInstance;
    property IsInstanceExternal: Boolean read GetIsInstanceExternal;
    //property isManaged: Boolean read GetIsManaged;
    property IsOrdinal: Boolean read GetIsOrdinal;
    property IsRecord: Boolean read GetIsRecord;
    property IsSet: Boolean read GetIsSet;
    property BaseType: TRttiType read GetBaseType;
    property AsInstance: TRttiInstanceType read GetAsInstance;
    property AsInstanceExternal: TRttiInstanceExternalType read GetAsInstanceExternal;
    property TypeKind: TTypeKind read GetTypeKind;
    //property TypeSize: integer read GetTypeSize;
    property DeclaringUnitName: string read GetDeclaringUnitName;
    property QualifiedName: String read GetQualifiedName;
  end;

  TRttiTypeClass = class of TRttiType;

  { TRttiStructuredType }

  TRttiStructuredType = class abstract(TRttiType)
  private
    FFields: TRttiFieldArray;
    FMethods: TRttiMethodArray;
    FProperties: TRttiPropertyArray;
  protected
    function GetAncestor: TRttiStructuredType; virtual;
    function GetStructTypeInfo: TTypeInfoStruct;
  public
    constructor Create(AParent: TRttiObject; ATypeInfo: PTypeInfo); override;

    destructor Destroy; override;

    function GetDeclaredFields: TRttiFieldArray; override;
    function GetDeclaredMethods: TRttiMethodArray; override;
    function GetDeclaredProperties: TRttiPropertyArray; override;
    function GetFields: TRttiFieldArray; override;
    function GetMethod(const aName: String): TRttiMethod; override;
    function GetMethods: TRttiMethodArray; override;
    function GetMethods(const aName: String): TRttiMethodArray; override;
    function GetProperties: TRttiPropertyArray; override;
    function GetProperty(const AName: string): TRttiProperty; override;

    property StructTypeInfo: TTypeInfoStruct read GetStructTypeInfo;
  end;

  { TRttiInstanceType }

  TRttiInstanceType = class(TRttiStructuredType)
  private
    function GetAncestorType: TRttiInstanceType;
    function GetClassTypeInfo: TTypeInfoClass;
    function GetMetaClassType: TClass;
  protected
    function GetAncestor: TRttiStructuredType; override;
    function GetBaseType : TRttiType; override;
  public
    constructor Create(AParent: TRttiObject; ATypeInfo: PTypeInfo); override;
    property BaseType : TRttiInstanceType read GetAncestorType;
    property Ancestor: TRttiInstanceType read GetAncestorType;
    property ClassTypeInfo: TTypeInfoClass read GetClassTypeInfo;
    property MetaClassType: TClass read GetMetaClassType;
  end;

  { TRttiInterfaceType }

  TRttiInterfaceType = class(TRttiStructuredType)
  private
    function GetAncestorType: TRttiInterfaceType;
    function GetGUID: TGUID;
    function GetInterfaceTypeInfo: TTypeInfoInterface;
  protected
    function GetAncestor: TRttiStructuredType; override;
    function GetBaseType : TRttiType; override;
  public
    constructor Create(AParent: TRttiObject; ATypeInfo: PTypeInfo); override;

    property BaseType : TRttiInterfaceType read GetAncestorType;
    property Ancestor: TRttiInterfaceType read GetAncestorType;
    property GUID: TGUID read GetGUID;
    property InterfaceTypeInfo: TTypeInfoInterface read GetInterfaceTypeInfo;
  end;

  { TRttiRecordType }

  TRttiRecordType = class(TRttiStructuredType)
  private
    function GetRecordTypeInfo: TTypeInfoRecord;
  protected
    function GetIsRecord: Boolean; override;
  public
    constructor Create(AParent: TRttiObject; ATypeInfo: PTypeInfo); override;

    property RecordTypeInfo: TTypeInfoRecord read GetRecordTypeInfo;
  end;

  { TRttiClassRefType }
  TRttiClassRefType = class(TRttiType)
  private
    function GetClassRefTypeInfo: TTypeInfoClassRef;
    function GetInstanceType: TRttiInstanceType;
    function GetMetaclassType: TClass;
  public
    constructor Create(AParent: TRttiObject; ATypeInfo: PTypeInfo); override;

    property ClassRefTypeInfo: TTypeInfoClassRef read GetClassRefTypeInfo;
    property InstanceType: TRttiInstanceType read GetInstanceType;
    property MetaclassType: TClass read GetMetaclassType;
  end;

  { TRttiInstanceExternalType }

  TRttiInstanceExternalType = class(TRttiType)
  private
    function GetAncestor: TRttiInstanceExternalType;
    function GetExternalName: String;
    function GetExternalClassTypeInfo: TTypeInfoExtClass;
  public
    constructor Create(AParent: TRttiObject; ATypeInfo: PTypeInfo); override;

    property Ancestor: TRttiInstanceExternalType read GetAncestor;
    property ExternalClassTypeInfo: TTypeInfoExtClass read GetExternalClassTypeInfo;
    property ExternalName: String read GetExternalName;
  end;

  { TRttiOrdinalType }

  TRttiOrdinalType = class(TRttiType)
  private
    function GetMaxValue: Integer; virtual;
    function GetMinValue: Integer; virtual;
    function GetOrdType: TOrdType;
    function GetOrdinalTypeInfo: TTypeInfoInteger;
  public
    constructor Create(AParent: TRttiObject; ATypeInfo: PTypeInfo); override;

    property OrdType: TOrdType read GetOrdType;
    property MinValue: Integer read GetMinValue;
    property MaxValue: Integer read GetMaxValue;
    property OrdinalTypeInfo: TTypeInfoInteger read GetOrdinalTypeInfo;
  end;

  { TRttiEnumerationType }

  TRttiEnumerationType = class(TRttiOrdinalType)
  private
    function GetEnumerationTypeInfo: TTypeInfoEnum;
  public
    constructor Create(AParent: TRttiObject; ATypeInfo: PTypeInfo); override;

    property EnumerationTypeInfo: TTypeInfoEnum read GetEnumerationTypeInfo;

    function GetNames: TStringArray;
    generic class function GetName<T>(AValue: T): String; reintroduce;
    generic class function GetValue<T>(const AValue: String): T;
  end;

  { TRttiDynamicArrayType }

  TRttiDynamicArrayType = class(TRttiType)
  private
    function GetDynArrayTypeInfo: TTypeInfoDynArray;
    function GetElementType: TRttiType;
  public
    constructor Create(AParent: TRttiObject; ATypeInfo: PTypeInfo); override;

    property DynArrayTypeInfo: TTypeInfoDynArray read GetDynArrayTypeInfo;
    property ElementType: TRttiType read GetElementType;
  end;

  EInvoke = EJS;

  TVirtualInterfaceInvokeEvent = reference to procedure(Method: TRttiMethod; const Args: specialize TArray<TValue>; out Result: TValue);
  TVirtualInterfaceInvokeEventJS = reference to function(const aMethodName: String; const Args: TJSValueDynArray): JSValue;

  { TVirtualInterface: A class that can implement any IInterface. Any method
    call is handled by the OnInvoke event. }
  TVirtualInterface = class(TInterfacedObject, IInterface)
  private
    FContext: TRttiContext;
    FInterfaceType: TRttiInterfaceType;
    FOnInvoke: TVirtualInterfaceInvokeEvent;
    FOnInvokeJS: TVirtualInterfaceInvokeEventJS;

    function Invoke(const MethodName: String; const Args: TJSValueDynArray): JSValue;
  public
    constructor Create(InterfaceTypeInfo: TTypeInfoInterface); overload;
    constructor Create(InterfaceTypeInfo: TTypeInfoInterface; const InvokeEvent: TVirtualInterfaceInvokeEvent); overload;
    constructor Create(InterfaceTypeInfo: TTypeInfoInterface; const InvokeEvent: TVirtualInterfaceInvokeEventJS); overload;

    destructor Destroy; override;

    function QueryInterface(const iid: TGuid; out obj): Integer; override;

    property OnInvoke: TVirtualInterfaceInvokeEvent read FOnInvoke write FOnInvoke;
    property OnInvokeJS: TVirtualInterfaceInvokeEventJS read FOnInvokeJS write FOnInvokeJS;
  end;

procedure CreateVirtualCorbaInterface(InterfaceTypeInfo: Pointer;
  const MethodImplementation: TVirtualInterfaceInvokeEvent; out IntfVar); assembler;

function Invoke(ACodeAddress: Pointer; const AArgs: TJSValueDynArray;
  ACallConv: TCallConv; AResultType: PTypeInfo; AIsStatic: Boolean;
  AIsConstructor: Boolean): TValue;

implementation

type
  TRttiPoolTypes = class
  private
    FReferenceCount: Integer;
    FTypes: TJSObject; // maps 'modulename.typename' to TRTTIType
  public
    constructor Create;

    destructor Destroy; override;

    function FindType(const AQualifiedName: String): TRttiType;
    function GetType(const ATypeInfo: PTypeInfo): TRTTIType; overload;
    function GetType(const AClass: TClass): TRTTIType; overload;

    class function AcquireContext: TJSObject; static;

    class procedure ReleaseContext; static;
  end;

var
  Pool: TRttiPoolTypes;
  pas: TJSObject; external name 'pas';

procedure CreateVirtualCorbaInterface(InterfaceTypeInfo: Pointer;
  const MethodImplementation: TVirtualInterfaceInvokeEvent; out IntfVar); assembler;
asm
  var IntfType = InterfaceTypeInfo.interface;
  var i = Object.create(IntfType);
  var o = { $name: "virtual", $fullname: "virtual" };
  i.$o = o;
  do {
    var names = IntfType.$names;
    if (!names) break;
    for (var j=0; j<names.length; j++){
      let fnname = names[j];
      i[fnname] = function(){ return MethodImplementation(fnname,arguments); };
    }
    IntfType = Object.getPrototypeOf(IntfType);
  } while(IntfType!=null);
  IntfVar.set(i);
end;

{ TRttiPoolTypes }

constructor TRttiPoolTypes.Create;
begin
  inherited;

  FTypes := TJSObject.new;
end;

destructor TRttiPoolTypes.Destroy;
var
  Key: String;

  RttiObject: TRttiType;

begin
  for key in FTypes do
    if FTypes.hasOwnProperty(key) then
    begin
      RttiObject := TRttiType(FTypes[key]);

      RttiObject.Free;
    end;
end;

function TRttiPoolTypes.FindType(const AQualifiedName: String): TRttiType;
var
  ModuleName, TypeName: String;

  Module: TTypeInfoModule;

  TypeFound: PTypeInfo;

begin
  if FTypes.hasOwnProperty(AQualifiedName) then
    Result := TRttiType(FTypes[AQualifiedName])
  else
  begin
    Result := nil;

    for ModuleName in TJSObject.Keys(pas) do
      if AQualifiedName.StartsWith(ModuleName + '.') then
      begin
        Module := TTypeInfoModule(pas[ModuleName]);
        TypeName := Copy(AQualifiedName, Length(ModuleName) + 2, Length(AQualifiedName));

        if Module.RTTI.HasOwnProperty(TypeName) then
        begin
          TypeFound := PTypeInfo(Module.RTTI[TypeName]);

          Exit(GetType(TypeFound));
        end;
      end;
  end;
end;

function TRttiPoolTypes.GetType(const ATypeInfo: PTypeInfo): TRTTIType;
var
  RttiTypeClass: array[TTypeKind] of TRttiTypeClass = (
    nil, // tkUnknown
    TRttiOrdinalType, // tkInteger
    TRttiOrdinalType, // tkChar
    TRttiType, // tkString
    TRttiEnumerationType, // tkEnumeration
    TRttiType, // tkSet
    TRttiType, // tkDouble
    TRttiType, // tkBool
    TRttiType, // tkProcVar
    TRttiType, // tkMethod
    TRttiType, // tkArray
    TRttiDynamicArrayType, // tkDynArray
    TRttiRecordType, // tkRecord
    TRttiInstanceType, // tkClass
    TRttiClassRefType, // tkClassRef
    TRttiType, // tkPointer
    TRttiType, // tkJSValue
    TRttiType, // tkRefToProcVar
    TRttiInterfaceType, // tkInterface
    TRttiType, // tkHelper
    TRttiInstanceExternalType // tkExtClass
  );

  TheType: TTypeInfo absolute ATypeInfo;

  Name: String;

  Parent: TRttiObject;

begin
  if IsNull(ATypeInfo) or IsUndefined(ATypeInfo) then
    Exit(nil);

  Name := TheType.Name;

  if isModule(TheType.Module) then
    Name := TheType.Module.Name + '.' + Name;

  if FTypes.hasOwnProperty(Name) then
    Result := TRttiType(FTypes[Name])
  else
  begin
    if (TheType.Kind in [tkClass, tkInterface, tkHelper, tkExtClass]) and TJSObject(TheType).hasOwnProperty('ancestor') then
      Parent := GetType(PTypeInfo(TJSObject(TheType)['ancestor']))
    else
      Parent := nil;

    Result := RttiTypeClass[TheType.Kind].Create(Parent, ATypeInfo);

    FTypes[Name] := Result;
  end;
end;

function TRttiPoolTypes.GetType(const AClass: TClass): TRTTIType;
begin
  if AClass = nil then
    Exit(nil);

  Result := GetType(TypeInfo(AClass));
end;

class function TRttiPoolTypes.AcquireContext: TJSObject;
begin
  if not Assigned(Pool) then
    Pool := TRttiPoolTypes.Create;

  Result := Pool.FTypes;

  Inc(Pool.FReferenceCount);
end;

class procedure TRttiPoolTypes.ReleaseContext;
var
  Key: String;

  RttiObject: TRttiType;

begin
  Dec(Pool.FReferenceCount);

  if Pool.FReferenceCount = 0 then
    FreeAndNil(Pool);
end;

{ TRttiDynamicArrayType }

function TRttiDynamicArrayType.GetDynArrayTypeInfo: TTypeInfoDynArray;
begin
  Result := TTypeInfoDynArray(inherited Handle);
end;

function TRttiDynamicArrayType.GetElementType: TRttiType;
begin
  Result := Pool.GetType(DynArrayTypeInfo.ElType);
end;

constructor TRttiDynamicArrayType.Create(AParent: TRttiObject; ATypeInfo: PTypeInfo);
begin
  if not (TTypeInfo(ATypeInfo) is TTypeInfoDynArray) then
    raise EInvalidCast.Create('');

  inherited;
end;

{ TRttiOrdinalType }

function TRttiOrdinalType.GetMaxValue: Integer;
begin
  Result := OrdinalTypeInfo.MaxValue;
end;

function TRttiOrdinalType.GetMinValue: Integer;
begin
  Result := OrdinalTypeInfo.MinValue;
end;

function TRttiOrdinalType.GetOrdType: TOrdType;
begin
  Result := OrdinalTypeInfo.OrdType;
end;

function TRttiOrdinalType.GetOrdinalTypeInfo: TTypeInfoInteger;
begin
  Result := TTypeInfoInteger(inherited Handle);
end;

constructor TRttiOrdinalType.Create(AParent: TRttiObject; ATypeInfo: PTypeInfo);
begin
  if not (TTypeInfo(ATypeInfo) is TTypeInfoInteger) then
    raise EInvalidCast.Create('');

  inherited;
end;

{ TRttiEnumerationType }

function TRttiEnumerationType.GetEnumerationTypeInfo: TTypeInfoEnum;
begin
  Result := TTypeInfoEnum(inherited Handle);
end;

function TRttiEnumerationType.GetNames: TStringArray;
var
  A, NamesSize: Integer;

begin
  NamesSize := GetEnumNameCount(EnumerationTypeInfo);

  SetLength(Result, NamesSize);

  for A := 0 to Pred(NamesSize) do
    Result[A] := EnumerationTypeInfo.EnumType.IntToName[A + MinValue];
end;

generic class function TRttiEnumerationType.GetName<T>(AValue: T): String;

Var
  P : PTypeInfo;

begin
  P:=TypeInfo(T);
  if not (TTypeInfo(P).kind=tkEnumeration) then
    raise EInvalidCast.CreateFmt(SErrTypeIsNotEnumerated,[TTypeInfo(P).Name]);
  Result := GetEnumName(TTypeInfoEnum(P), Integer(JSValue(AValue)));
end;

generic class function TRttiEnumerationType.GetValue<T>(const AValue: String): T;

Var
  P : PTypeInfo;

begin
  P:=TypeInfo(T);
  if not (TTypeInfo(P).kind=tkEnumeration) then
    raise EInvalidCast.CreateFmt(SErrTypeIsNotEnumerated,[TTypeInfo(P).Name]);
  Result := T(JSValue(GetEnumValue(TTypeInfoEnum(TypeInfo(T)), AValue)));
end;

constructor TRttiEnumerationType.Create(AParent: TRttiObject; ATypeInfo: PTypeInfo);
begin
  if not (TTypeInfo(ATypeInfo) is TTypeInfoEnum) then
    raise EInvalidCast.Create('');

  inherited;
end;

{ TValue }

function TValue.GetTypeKind: TTypeKind;
begin
  if TypeInfo=nil then
    Result:=tkUnknown
  else
    Result:=FTypeInfo.Kind;
end;

generic function TValue.AsType<T>: T;
begin
  if IsEmpty then
    Result := Default(T)
  else
    Result := T(AsJSValue)
end;

generic class function TValue.From<T>(const Value: T): TValue;
begin
  Make(Value, System.TypeInfo(T), Result);
end;

class procedure TValue.Make(const ABuffer: JSValue; const ATypeInfo: PTypeInfo; var Result: TValue);
begin
  Result.FData := ABuffer;
  Result.FTypeInfo := ATypeInfo;
end;

generic class procedure TValue.Make<T>(const Value: T; var Result: TValue);
begin
  TValue.Make(Value, System.TypeInfo(T), Result);
end;

function TValue.Cast(ATypeInfo: TTypeInfo; const EmptyAsAnyType: Boolean): TValue;
begin
  if not TryCast(ATypeInfo, Result, EmptyAsAnyType) then
    raise EInvalidCast.Create('');
end;

generic function TValue.Cast<T>(const EmptyAsAnyType: Boolean): TValue;
begin
  Result := Cast(System.TypeInfo(T), EmptyAsAnyType);
end;

function TValue.IsType(ATypeInfo: TTypeInfo; const EmptyAsAnyType: Boolean): Boolean;
var
  AnyValue: TValue;

begin
  Result := TryCast(ATypeInfo, AnyValue, EmptyAsAnyType);
end;

generic function TValue.IsType<T>(const EmptyAsAnyType: Boolean): Boolean;
begin
  Result := IsType(System.TypeInfo(T), EmptyAsAnyType);
end;

function TValue.TryCast(ATypeInfo: TTypeInfo; out AResult: TValue; const EmptyAsAnyType: Boolean): Boolean;

  function ConversionAccepted: TTypeKinds;
  begin
    case TypeInfo.Kind of
      tkString: Exit([tkChar, tkString]);

      tkDouble: Exit([tkInteger, tkDouble]);

      tkEnumeration: Exit([tkInteger, tkEnumeration]);

      else Exit([TypeInfo.Kind]);
    end;
  end;

begin
  if EmptyAsAnyType and IsEmpty then
  begin
    AResult := TValue.Empty;

    if ATypeInfo <> nil then
    begin
      AResult.FTypeInfo := ATypeInfo;

      case ATypeInfo.Kind of
        tkBool: AResult.SetData(False);
        tkChar: AResult.SetData(#0);
        tkString: AResult.SetData(EmptyStr);
        tkDouble,
        tkEnumeration,
        tkInteger: AResult.SetData(0);
      end;

      Exit(True);
    end;
  end;

  if not EmptyAsAnyType and (FTypeInfo = nil) then
    Exit(False);

  if FTypeInfo = ATypeInfo then
  begin
    AResult := Self;
    Exit(True);
  end;

  if ATypeInfo = nil then
    Exit(False);

  if ATypeInfo = System.TypeInfo(TValue) then
  begin
    TValue.Make(Self, System.TypeInfo(TValue), AResult);
    Exit(True);
  end;

  Result := ATypeInfo.Kind in ConversionAccepted;

  if Result then
  begin
    AResult.SetData(FData);
    AResult.FTypeInfo := ATypeInfo;
  end;
end;

class function TValue.FromJSValue(v: JSValue): TValue;
var
  i: NativeInt;
  TypeOfValue: TTypeInfo;

begin
  case jsTypeOf(v) of
    'number':
      if JS.isInteger(v) then
        begin
        i:=NativeInt(v);
        if (i>=low(integer)) and (i<=high(integer)) then
          TypeOfValue:=System.TypeInfo(Integer)
        else
          TypeOfValue:=System.TypeInfo(NativeInt);
        end
      else
        TypeOfValue:=system.TypeInfo(Double);
    'string':  TypeOfValue:=System.TypeInfo(String);
    'boolean': TypeOfValue:=System.TypeInfo(Boolean);
    'object':
      if v=nil then
        Exit(TValue.Empty)
      else if JS.isClass(v) and JS.isExt(v,TObject) then
        TypeOfValue:=System.TypeInfo(TClass(v))
      else if JS.isObject(v) and JS.isExt(v,TObject) then
        TypeOfValue:=System.TypeInfo(TObject(v))
      else if isRecord(v) then
        TypeOfValue:=System.TypeInfo(TObject(v))
      else if TJSArray.IsArray(V) then
        TypeOfValue:=System.TypeInfo(TObject(v))
      else
        raise EInvalidCast.Create('Type not recognized in FromJSValue!');
    else
      TypeOfValue:=System.TypeInfo(JSValue);
  end;

  Make(v, TypeOfValue, Result);
end;

class function TValue.FromArray(TypeInfo: TTypeInfo; const Values: specialize TArray<TValue>): TValue;
var
  A: Integer;

  DynTypeInfo: TTypeInfoDynArray absolute TypeInfo;

  NewArray: TJSArray;

  ElementType: TTypeInfo;

begin
  if TypeInfo.Kind <> tkDynArray then
    raise EInvalidCast.Create('Type not an array in FromArray!');

  ElementType := DynTypeInfo.ElType;
  NewArray := TJSArray.new;
  NewArray.Length := Length(Values);

  for A := 0 to High(Values) do
    NewArray[A] := Values[A].Cast(ElementType).AsJSValue;

  Result.SetData(NewArray);
  Result.FTypeInfo := TypeInfo;
end;

class function TValue.FromOrdinal(ATypeInfo: TTypeInfo; AValue: JSValue): TValue;
begin
  if (ATypeInfo = nil) or not (ATypeInfo.Kind in [tkBool, tkEnumeration, tkInteger]) then
    raise EInvalidCast.Create('Invalid type in FromOrdinal');

  if ATypeInfo.Kind = tkBool then
    TValue.Make(AValue = True, ATypeInfo, Result)
  else
    TValue.Make(NativeInt(AValue), ATypeInfo, Result);
end;

function TValue.IsObject: boolean;
begin
  Result:=IsEmpty or (TypeInfo.Kind=tkClass);
end;

function TValue.AsObject: TObject;
begin
  if IsObject or (IsClass and not JS.IsObject(GetData)) then
    Result := TObject(GetData)
  else
    raise EInvalidCast.Create(SErrInvalidTypecast);
end;

function TValue.IsObjectInstance: boolean;
begin
  Result:=(TypeInfo<>nil) and (TypeInfo.Kind=tkClass);
end;

function TValue.IsArray: boolean;
begin
  case Kind of
    tkDynArray: Exit(True);
    tkArray: Exit(Length(TTypeInfoStaticArray(FTypeInfo).Dims) = 1);
    else Result := False;
  end;
end;

function TValue.IsClass: boolean;
var
  k: TTypeKind;
begin
  k:=Kind;
  Result := (k = tkClassRef) or ((k in [tkClass,tkUnknown]) and not JS.IsObject(GetData));
end;

function TValue.AsClass: TClass;
begin
  if IsClass then
    Result := TClass(GetData)
  else
    raise EInvalidCast.Create(SErrInvalidTypecast);
end;

function TValue.IsOrdinal: boolean;
begin
  Result := IsEmpty or (Kind in [tkBool, tkInteger, tkChar, tkEnumeration]);
end;

function TValue.AsOrdinal: NativeInt;
begin
  if IsOrdinal then
    Result:=NativeInt(GetData)
  else
    raise EInvalidCast.Create(SErrInvalidTypecast);
end;

function TValue.AsBoolean: boolean;
begin
  if (Kind = tkBool) then
    Result:=boolean(GetData)
  else
    raise EInvalidCast.Create(SErrInvalidTypecast);
end;

function TValue.AsInteger: Integer;
begin
  if JS.isInteger(GetData) then
    Result:=NativeInt(GetData)
  else
    raise EInvalidCast.Create(SErrInvalidTypecast);
end;

function TValue.AsNativeInt: NativeInt;
begin
  if JS.isInteger(GetData) then
    Result:=NativeInt(GetData)
  else
    raise EInvalidCast.Create(SErrInvalidTypecast);
end;

function TValue.AsInterface: IInterface;
var
  k: TTypeKind;
begin
  k:=Kind;
  if k = tkInterface then
    Result := IInterface(GetData)// ToDo
  else if (k in [tkClass, tkClassRef, tkUnknown]) and not JS.isObject(GetData) then
    Result := Nil
  else
    raise EInvalidCast.Create(SErrInvalidTypecast);
end;

function TValue.AsString: string;
begin
  if js.isString(GetData) then
    Result:=String(GetData)
  else
    raise EInvalidCast.Create(SErrInvalidTypecast);
end;

function TValue.AsUnicodeString: UnicodeString;
begin
  Result:=AsString;
end;

function TValue.AsExtended: Extended;
begin
  if js.isNumber(GetData) then
    Result:=Double(GetData)
  else
    raise EInvalidCast.Create(SErrInvalidTypecast);
end;

function TValue.ToString: String;
begin
  case Kind of
    tkString: Result := AsString;
    tkInteger: Result := IntToStr(AsNativeInt);
    tkBool: Result := BoolToStr(AsBoolean, True);
  else
    Result := '';
  end;
end;

function TValue.GetArrayLength: SizeInt;
begin
  if IsArray then
    Exit(Length(TJSValueDynArray(GetData)));

  raise EInvalidCast.Create(SErrInvalidTypecast);
end;

function TValue.GetArrayElement(aIndex: SizeInt): TValue;
begin
  if IsArray then
  begin
    case Kind of
      tkArray: Result.FTypeInfo:=TTypeInfoStaticArray(FTypeInfo).ElType;
      tkDynArray: Result.FTypeInfo:=TTypeInfoDynArray(FTypeInfo).ElType;
    end;

    Result.SetData(TJSValueDynArray(GetData)[aIndex]);
  end
  else
    raise EInvalidCast.Create(SErrInvalidTypecast);
end;

procedure TValue.SetArrayLength(const Size: SizeInt);
var
  NewArray: TJSValueDynArray;

begin
  NewArray := TJSValueDynArray(GetData);

  SetLength(NewArray, Size);

  SetData(NewArray);
end;

procedure TValue.SetArrayElement(aIndex: SizeInt; const AValue: TValue);

begin
  if IsArray then
    TJSValueDynArray(GetData)[aIndex] := AValue.AsJSValue
  else
    raise EInvalidCast.Create(SErrInvalidTypecast);
end;

function TValue.IsType(ATypeInfo: TTypeInfo): boolean;
begin
  Result := ATypeInfo = TypeInfo;
end;

function TValue.GetData: JSValue;
begin
  if FReferenceVariableData then
    Result := TReferenceVariable(FData).Get
  else
    Result := FData;
end;

procedure TValue.SetData(const Value: JSValue);
begin
  if FReferenceVariableData then
    TReferenceVariable(FData).&Set(Value)
  else
    FData := Value;
end;

function TValue.GetIsEmpty: boolean;
begin
  if (TypeInfo=nil) or (GetData=Undefined) or (GetData=nil) then
    exit(true);
  case TypeInfo.Kind of
  tkDynArray:
    Result:=GetArrayLength=0;
  else
    Result:=false;
  end;
end;

function TValue.AsJSValue: JSValue;
begin
  Result := GetData;
end;

class function TValue.Empty: TValue;
begin
  Result.SetData(nil);
  Result.FTypeInfo := nil;
end;

{ TRttiStructuredType }

function TRttiStructuredType.GetMethods: TRttiMethodArray;
var
  A, Start: Integer;

  BaseClass: TRttiStructuredType;

  Declared: TRttiMethodArray;

begin
  BaseClass := Self;
  Result := nil;
  while Assigned(BaseClass) do
  begin
    Declared := BaseClass.GetDeclaredMethods;
    Start := Length(Result);
    SetLength(Result, Start + Length(Declared));
    for A := Low(Declared) to High(Declared) do
      Result[Start + A] := Declared[A];
    BaseClass := BaseClass.GetAncestor;
  end;
end;

function TRttiStructuredType.GetMethods(const aName: String): TRttiMethodArray;
var
  Method: TRttiMethod;
  MethodCount: Integer;

begin
  MethodCount := 0;
  for Method in GetMethods do
    if aName = Method.Name then
      Inc(MethodCount);
  SetLength(Result, MethodCount);
  for Method in GetMethods do
    if aName = Method.Name then
    begin
      Dec(MethodCount);
      Result[MethodCount] := Method;
    end;
end;

function TRttiStructuredType.GetProperties: TRttiPropertyArray;
var
  A, Start: Integer;

  BaseClass: TRttiStructuredType;

  Declared: TRttiPropertyArray;

begin
  BaseClass := Self;
  Result := nil;

  while Assigned(BaseClass) do
  begin
    Declared := BaseClass.GetDeclaredProperties;
    Start := Length(Result);

    SetLength(Result, Start + Length(Declared));

    for A := Low(Declared) to High(Declared) do
      Result[Start + A] := Declared[A];

    BaseClass := BaseClass.GetAncestor;
  end;
end;

function TRttiStructuredType.GetMethod(const aName: String): TRttiMethod;
var
  Method: TRttiMethod;

begin
  for Method in GetMethods do
    if aName = Method.Name then
      Exit(Method);
end;

function TRttiStructuredType.GetProperty(const AName: string): TRttiProperty;
var
  Prop: TRttiProperty;
  lName: String;

begin
  lName := LowerCase(AName);
  for Prop in GetProperties do
    if lowercase(Prop.Name) = lName then
      Exit(Prop);
  Result:=nil;
end;

function TRttiStructuredType.GetDeclaredProperties: TRttiPropertyArray;
var
  A, PropCount: Integer;

begin
  if not Assigned(FProperties) then
  begin
    PropCount := StructTypeInfo.PropCount;

    SetLength(FProperties, PropCount);

    for A := 0 to Pred(PropCount) do
      FProperties[A] := TRttiProperty.Create(Self, StructTypeInfo.GetProp(A));
  end;

  Result := FProperties;
end;

function TRttiStructuredType.GetAncestor: TRttiStructuredType;
begin
  Result := nil;
end;

function TRttiStructuredType.GetStructTypeInfo: TTypeInfoStruct;
begin
  Result:=TTypeInfoStruct(inherited Handle);
end;

constructor TRttiStructuredType.Create(AParent: TRttiObject; ATypeInfo: PTypeInfo);
begin
  if not (TTypeInfo(ATypeInfo) is TTypeInfoStruct) then
    raise EInvalidCast.Create('');

  inherited;
end;

destructor TRttiStructuredType.Destroy;
var
  Method: TRttiMethod;

  Prop: TRttiProperty;

begin
  for Method in FMethods do
    Method.Free;

  for Prop in FProperties do
    Prop.Free;

  inherited Destroy;
end;

function TRttiStructuredType.GetDeclaredMethods: TRttiMethodArray;
var
  A, MethodCount: Integer;

begin
  if not Assigned(FMethods) then
  begin
    MethodCount := StructTypeInfo.MethodCount;
    SetLength(FMethods, MethodCount);

    for A := 0 to Pred(MethodCount) do
      FMethods[A] := TRttiMethod.Create(Self, StructTypeInfo.GetMethod(A));
  end;

  Result := FMethods;
end;

function TRttiStructuredType.GetDeclaredFields: TRttiFieldArray;
var
  A, FieldCount: Integer;

begin
  if not Assigned(FFields) then
  begin
    FieldCount := StructTypeInfo.FieldCount;

    SetLength(FFields, FieldCount);

    for A := 0 to Pred(FieldCount) do
      FFields[A] := TRttiField.Create(Self, StructTypeInfo.GetField(A));
  end;

  Result := FFields;
end;

function TRttiStructuredType.GetFields: TRttiFieldArray;
var
  A, Start: Integer;

  BaseClass: TRttiStructuredType;

  Declared: TRttiFieldArray;

begin
  BaseClass := Self;
  Result := nil;

  while Assigned(BaseClass) do
  begin
    Declared := BaseClass.GetDeclaredFields;
    Start := Length(Result);

    SetLength(Result, Start + Length(Declared));

    for A := Low(Declared) to High(Declared) do
      Result[Start + A] := Declared[A];

    BaseClass := BaseClass.GetAncestor;
  end;
end;

{ TRttiInstanceType }

function TRttiInstanceType.GetClassTypeInfo: TTypeInfoClass;
begin
  Result:=TTypeInfoClass(inherited Handle);
end;

function TRttiInstanceType.GetMetaClassType: TClass;
begin
  Result:=ClassTypeInfo.ClassType;
end;

function TRttiInstanceType.GetAncestor: TRttiStructuredType;
begin
  Result := GetAncestorType;
end;

function TRttiInstanceType.GetBaseType: TRttiType;
begin
  Result:=GetAncestorType;
end;

function TRttiInstanceType.GetAncestorType: TRttiInstanceType;
begin
  Result := inherited Parent as TRttiInstanceType;
end;

constructor TRttiInstanceType.Create(AParent: TRttiObject; ATypeInfo: PTypeInfo);
begin
  if not (TTypeInfo(ATypeInfo) is TTypeInfoClass) then
    raise EInvalidCast.Create('');

  inherited;
end;

{ TRttiInterfaceType }

constructor TRttiInterfaceType.Create(AParent: TRttiObject; ATypeInfo: PTypeInfo);
begin
  if not (TTypeInfo(ATypeInfo) is TTypeInfoInterface) then
    raise EInvalidCast.Create('');

  inherited;
end;

function TRttiInterfaceType.GetGUID: TGUID;
var
  GUID: String;

begin
  GUID := InterfaceTypeInfo.InterfaceInfo.GUID;

  TryStringToGUID(GUID, Result);
end;

function TRttiInterfaceType.GetInterfaceTypeInfo: TTypeInfoInterface;
begin
  Result := TTypeInfoInterface(inherited Handle);
end;

function TRttiInterfaceType.GetAncestor: TRttiStructuredType;
begin
  Result := GetAncestorType;
end;

function TRttiInterfaceType.GetBaseType: TRttiType;
begin
  Result := GetAncestorType;
end;

function TRttiInterfaceType.GetAncestorType: TRttiInterfaceType;
begin
  Result := Pool.GetType(InterfaceTypeInfo.Ancestor) as TRttiInterfaceType;
end;

{ TRttiRecordType }

function TRttiRecordType.GetRecordTypeInfo: TTypeInfoRecord;
begin
  Result := TTypeInfoRecord(inherited Handle);
end;

function TRttiRecordType.GetIsRecord: Boolean;
begin
  Result := True;
end;

constructor TRttiRecordType.Create(AParent: TRttiObject; ATypeInfo: PTypeInfo);
begin
  if not (TTypeInfo(ATypeInfo) is TTypeInfoRecord) then
    raise EInvalidCast.Create('');

  inherited;
end;

{ TRttiClassRefType }

constructor TRttiClassRefType.Create(AParent: TRttiObject; ATypeInfo: PTypeInfo);
begin
  if not (TTypeInfo(ATypeInfo) is TTypeInfoClassRef) then
    raise EInvalidCast.Create('');

  inherited;
end;

function TRttiClassRefType.GetClassRefTypeInfo: TTypeInfoClassRef;
begin
  Result := TTypeInfoClassRef(inherited Handle);
end;

function TRttiClassRefType.GetInstanceType: TRttiInstanceType;
begin
  Result := Pool.GetType(ClassRefTypeInfo.InstanceType) as TRttiInstanceType;
end;

function TRttiClassRefType.GetMetaclassType: TClass;
begin
  Result := InstanceType.MetaClassType;
end;

{ TRttiInstanceExternalType }

function TRttiInstanceExternalType.GetAncestor: TRttiInstanceExternalType;
begin
  Result := Pool.GetType(ExternalClassTypeInfo.Ancestor) as TRttiInstanceExternalType;
end;

function TRttiInstanceExternalType.GetExternalClassTypeInfo: TTypeInfoExtClass;
begin
  Result := TTypeInfoExtClass(inherited Handle);
end;

function TRttiInstanceExternalType.GetExternalName: String;
begin
  Result := ExternalClassTypeInfo.JSClassName;
end;

constructor TRttiInstanceExternalType.Create(AParent: TRttiObject; ATypeInfo: PTypeInfo);
begin
  if not (TTypeInfo(ATypeInfo) is TTypeInfoExtClass) then
    raise EInvalidCast.Create('');

  inherited;
end;

{ TRTTIContext }

class function TRTTIContext.Create: TRTTIContext;
begin
  Pool.AcquireContext;
end;

procedure TRTTIContext.Free;
begin
  Pool.ReleaseContext;
end;

function TRTTIContext.GetType(aTypeInfo: PTypeInfo): TRttiType;
begin
  Result := Pool.GetType(aTypeInfo);
end;

function TRTTIContext.GetType(aClass: TClass): TRTTIType;
begin
  Result := Pool.GetType(aClass);
end;

function TRTTIContext.FindType(const AQualifiedName: String): TRttiType;
begin
  Result := Pool.FindType(AQualifiedName);
end;

function TRTTIContext.GetTypes: specialize TArray<TRttiType>;
var
  ModuleName, ClassName: String;

  ModuleTypes: TJSObject;

begin
  for ModuleName in TJSObject.Keys(pas) do
  begin
    ModuleTypes := TTypeInfoModule(pas[ModuleName]).RTTI;

    for ClassName in ModuleTypes do
      if TJSObject(ModuleTypes[ClassName]).HasOwnProperty('name') and (ClassName[1] <> '$') then
        GetType(PTypeInfo(ModuleTypes[ClassName]));
  end;

  Result := specialize TArray<TRttiType>(TJSObject.Values(Pool.FTypes));
end;

class procedure TRTTIContext.KeepContext;
begin
  Pool.AcquireContext;
end;

class procedure TRTTIContext.DropContext;
begin
  Pool.ReleaseContext;
end;

{ TRttiObject }

constructor TRttiObject.Create(AParent: TRttiObject; AHandle: Pointer);
begin
  FParent := AParent;
  FHandle := AHandle;
end;

destructor TRttiObject.Destroy;
var
  Attribute: TCustomAttribute;
begin
  for Attribute in FAttributes do
    Attribute.Free;

  FAttributes := nil;

  inherited Destroy;
end;

function TRttiObject.LoadCustomAttributes: TCustomAttributeArray;
begin
  Result := nil;
end;

function TRttiObject.GetAttributes: TCustomAttributeArray;
begin
  if not FAttributesLoaded then
  begin
    FAttributes := LoadCustomAttributes;
    FAttributesLoaded := True;
  end;

  Result := FAttributes;
end;

function TRttiObject.GetAttribute(const Attribute: TCustomAttributeClass): TCustomAttribute;
var
  CustomAttribute: TCustomAttribute;

begin
  Result := nil;

  for CustomAttribute in GetAttributes do
    if CustomAttribute is Attribute then
      Exit(CustomAttribute);
end;

generic function TRttiObject.GetAttribute<T>: T;

begin
  Result := T(GetAttribute(TCustomAttributeClass(T.ClassType)));
end;

function TRttiObject.HasAttribute(const Attribute: TCustomAttributeClass): Boolean;
begin
  Result := GetAttribute(Attribute) <> nil;
end;

generic function TRttiObject.HasAttribute<T>: Boolean;
begin
  Result := HasAttribute(TCustomAttributeClass(T.ClassType));
end;

{ TRttiNamedObject }

function TRttiNamedObject.GetName: string;
begin
  Result:='';
end;

{ TRttiMember }

function TRttiMember.GetName: string;
begin
  Result := MemberTypeInfo.Name;
end;

function TRttiMember.GetParent: TRttiType;
begin
  Result := TRttiType(inherited Parent);
end;

function TRttiMember.GetVisibility: TMemberVisibility;
begin
  Result := mvPublished;
end;

constructor TRttiMember.Create(AParent: TRttiType; ATypeInfo: TTypeMember);
begin
  if not (ATypeInfo is TTypeMember) then
    raise EInvalidCast.Create('');

  inherited Create(AParent, ATypeInfo);
end;

function TRttiMember.LoadCustomAttributes: TCustomAttributeArray;
begin
  Result := GetRTTIAttributes(MemberTypeInfo.Attributes);
end;

function TRttiMember.GetMemberTypeInfo: TTypeMember;
begin
  Result := TTypeMember(inherited Handle);
end;

{ TRttiField }

constructor TRttiField.Create(AParent: TRttiType; ATypeInfo: TTypeMember);
begin
  if not (ATypeInfo is TTypeMemberField) then
    raise EInvalidCast.Create('');

  inherited;
end;

function TRttiField.GetFieldType: TRttiType;
begin
  Result := Pool.GetType(FieldTypeInfo.TypeInfo);
end;

function TRttiField.GetFieldTypeInfo: TTypeMemberField;
begin
  Result := TTypeMemberField(inherited Handle);
end;

function TRttiField.GetValue(Instance: JSValue): TValue;
var
  JSInstance: TJSObject absolute Instance;

begin
  Result := TValue.FromJSValue(JSInstance[Name]);
end;

procedure TRttiField.SetValue(Instance: JSValue; const AValue: TValue);
var
  JSInstance: TJSObject absolute Instance;

begin
  JSInstance[Name] := AValue.Cast(FieldType.Handle, True).ASJSValue;
end;

{ TRttiParameter }

function TRttiParameter.GetName: String;
begin
  Result := FName;
end;

{ TRttiMethod }

function TRttiMethod.GetMethodTypeInfo: TTypeMemberMethod;
begin
  Result := TTypeMemberMethod(inherited Handle);
end;

function TRttiMethod.GetIsClassMethod: Boolean;
begin
  Result:=MethodTypeInfo.MethodKind in [mkClassFunction,mkClassProcedure];
end;

function TRttiMethod.GetIsConstructor: Boolean;
begin
  Result:=MethodTypeInfo.MethodKind=mkConstructor;
end;

function TRttiMethod.GetIsDestructor: Boolean;
begin
  Result:=MethodTypeInfo.MethodKind=mkDestructor;
end;

function TRttiMethod.GetIsExternal: Boolean;
begin
  Result := pfExternal in GetProcedureFlags;
end;

function TRttiMethod.GetIsStatic: Boolean;
begin
  Result := pfStatic in GetProcedureFlags;
end;

function TRttiMethod.GetIsVarArgs: Boolean;
begin
  Result := pfVarargs in GetProcedureFlags;
end;

function TRttiMethod.GetIsAsyncCall: Boolean;
begin
  Result := (pfAsync in GetProcedureFlags) or Assigned(ReturnType) and ReturnType.IsInstanceExternal and (ReturnType.AsInstanceExternal.ExternalName = 'Promise');
end;

function TRttiMethod.GetIsSafeCall: Boolean;
begin
  Result := pfSafeCall in GetProcedureFlags;
end;

function TRttiMethod.GetMethodKind: TMethodKind;
begin
  Result:=MethodTypeInfo.MethodKind;;
end;

function TRttiMethod.GetProcedureFlags: TProcedureFlags;
const
  PROCEDURE_FLAGS: array[TProcedureFlag] of NativeInt = (1, 2, 4, 8, 16);

var
  Flag: TProcedureFlag;

  ProcedureFlags: NativeInt;

begin
  ProcedureFlags := MethodTypeInfo.ProcSig.Flags;
  Result := [];

  for Flag := Low(PROCEDURE_FLAGS) to High(PROCEDURE_FLAGS) do
    if PROCEDURE_FLAGS[Flag] and ProcedureFlags > 0 then
      Result := Result + [Flag];
end;

function TRttiMethod.GetReturnType: TRttiType;
begin
  Result := Pool.GetType(MethodTypeInfo.ProcSig.ResultType);
end;

procedure TRttiMethod.LoadParameters;
const
  FLAGS_CONVERSION: array[TParamFlag] of NativeInt = (1, 2, 4, 8, 16, 32);

var
  A: Integer;

  Flag: TParamFlag;

  Param: TProcedureParam;

  RttiParam: TRttiParameter;

  MethodParams: TProcedureParams;

begin
  FParametersLoaded := True;
  MethodParams := MethodTypeInfo.ProcSig.Params;

  SetLength(FParameters, Length(MethodParams));

  for A := Low(FParameters) to High(FParameters) do
  begin
    Param := MethodParams[A];
    RttiParam := TRttiParameter.Create(Self, Param);
    RttiParam.FName := Param.Name;
    RttiParam.FParamType := Pool.GetType(Param.TypeInfo);

    for Flag := Low(FLAGS_CONVERSION) to High(FLAGS_CONVERSION) do
      if FLAGS_CONVERSION[Flag] and Param.Flags > 0 then
        RttiParam.FFlags := RttiParam.FFlags + [Flag];

    FParameters[A] := RttiParam;
  end;
end;

function TRttiMethod.GetParameters: TRttiParameterArray;
begin
  if not FParametersLoaded then
    LoadParameters;

  Result := FParameters;
end;

function TRttiMethod.Invoke(const Instance: TValue; const Args: array of TValue): TValue;
var
  A: Integer;

  ReturnHandle: PTypeInfo;

  AArgs: TJSValueDynArray;

begin
  if Assigned(ReturnType) then
    Result.FTypeInfo := ReturnType.Handle;

  SetLength(AArgs, Length(Args));

  for A := Low(Args) to High(Args) do
    AArgs[A] := Args[A].AsJSValue;

  Result.SetData(TJSFunction(TJSObject(Instance.AsJSValue)[Name]).apply(TJSObject(Instance.AsJSValue), AArgs));
end;

function TRttiMethod.Invoke(const Instance: TObject; const Args: array of TValue): TValue;

var
  v : TValue;

begin
  TValue.make(Instance,Instance.ClassInfo,v);
  Result:=Invoke(v,Args);
end;

function TRttiMethod.Invoke(const aClass: TClass; const Args: array of TValue
  ): TValue;
var
  v : TValue;

begin
  TValue.make(aClass,aClass.ClassInfo,v);
  Result:=Invoke(V,Args);
end;

{ TRttiProperty }

constructor TRttiProperty.Create(AParent: TRttiType; ATypeInfo: TTypeMember);
begin
  if not (ATypeInfo is TTypeMemberProperty) then
    raise EInvalidCast.Create('');

  inherited;
end;

function TRttiProperty.GetPropertyTypeInfo: TTypeMemberProperty;
begin
  Result := TTypeMemberProperty(inherited Handle);
end;

function TRttiProperty.GetValue(Instance: JSValue): TValue;
var
  JSObject: TJSObject absolute Instance;

begin
  TValue.Make(GetJSValueProp(JSObject, PropertyTypeInfo), PropertyType.Handle, Result);
end;

procedure TRttiProperty.SetValue(Instance: JSValue; const AValue: TValue);
var
  JSInstance: TJSObject absolute Instance;

begin
  SetJSValueProp(JSInstance, PropertyTypeInfo, AValue.Cast(PropertyType.Handle, True).AsJSValue);
end;

function TRttiProperty.GetPropertyType: TRttiType;
begin
  Result := Pool.GetType(PropertyTypeInfo.TypeInfo);
end;

function TRttiProperty.GetIsWritable: boolean;
begin
  Result := PropertyTypeInfo.Setter<>'';
end;

function TRttiProperty.GetIsReadable: boolean;
begin
  Result := PropertyTypeInfo.Getter<>'';
end;

function TRttiProperty.GetVisibility: TMemberVisibility;
begin
  // At this moment only published rtti-property-info is supported by pas2js
  Result := mvPublished;
end;

{ TRttiType }

function TRttiType.GetName: string;
begin
  Result := Handle.Name;
end;

function TRttiType.GetIsInstance: boolean;
begin
  Result:=Self is TRttiInstanceType;
end;

function TRttiType.GetIsInstanceExternal: boolean;
begin
  Result:=Self is TRttiInstanceExternalType;
end;

function TRttiType.GetIsOrdinal: boolean;
begin
  Result:=false;
end;

function TRttiType.GetIsRecord: boolean;
begin
  Result:=false;
end;

function TRttiType.GetIsSet: boolean;
begin
  Result:=false;
end;

function TRttiType.GetTypeKind: TTypeKind;
begin
  Result:=Handle.Kind;
end;

function TRttiType.GetHandle: TTypeInfo;
begin
  Result := TTypeInfo(inherited Handle);
end;

function TRttiType.GetBaseType: TRttiType;
begin
  Result:=Nil;
end;

function TRttiType.GetAsInstance: TRttiInstanceType;
begin
  Result := Self as TRttiInstanceType;
end;

function TRttiType.GetAsInstanceExternal: TRttiInstanceExternalType;
begin
  Result := Self as TRttiInstanceExternalType;
end;

function TRttiType.LoadCustomAttributes: TCustomAttributeArray;
begin
  Result:=GetRTTIAttributes(Handle.Attributes);
end;

function TRttiType.GetDeclaredProperties: TRttiPropertyArray;
begin
  Result:=nil;
end;

function TRttiType.GetProperties: TRttiPropertyArray;
begin
  Result:=nil;
end;

function TRttiType.GetProperty(const AName: string): TRttiProperty;
begin
  Result:=nil;
  if AName='' then ;
end;

function TRttiType.GetMethods: TRttiMethodArray;
begin
  Result:=nil;
end;

function TRttiType.GetMethods(const aName: String): TRttiMethodArray;
begin
  Result:=nil;
end;

function TRttiType.GetMethod(const aName: String): TRttiMethod;
begin
  Result:=nil;
  if aName='' then ;
end;

function TRttiType.GetDeclaredMethods: TRttiMethodArray;
begin
  Result:=nil;
end;

function TRttiType.GetDeclaredFields: TRttiFieldArray;
begin
  Result:=nil;
end;

function TRttiType.GetField(const AName: string): TRttiField;
var
  AField: TRttiField;

begin
  Result:=nil;
  for AField in GetFields do
    if AField.Name = AName then
      Exit(AField);
end;

function TRttiType.GetFields: TRttiFieldArray;
begin
  Result := nil;
end;

function TRttiType.GetDeclaringUnitName: String;
begin
  Result := Handle.Module.Name;
end;

function TRttiType.GetQualifiedName: String;
begin
  Result := Format('%s.%s', [DeclaringUnitName, Name]);
end;

{ TVirtualInterface }

constructor TVirtualInterface.Create(InterfaceTypeInfo: TTypeInfoInterface);
var
  SelfInterfaceObject, InterfaceObject: TInterfaceObject;

  Method: TRttiMethod;

  MethodName: String;

begin
  FContext := TRttiContext.Create;
  FInterfaceType := FContext.GetType(InterfaceTypeInfo) as TRttiInterfaceType;

  if FInterfaceType.InterfaceTypeInfo.InterfaceInfo.kind <> 'com' then
    raise EInvalidCast.Create;

  InterfaceObject := TInterfaceObject(TJSObject.Create(FInterfaceType.InterfaceTypeInfo.InterfaceInfo));
  InterfaceObject.Obj := Self;

  for Method in FInterfaceType.GetMethods do
  begin
    asm
      let MethodName = Method.GetName();
    end;

    InterfaceObject[MethodName] :=
      function: JSValue
      begin
        Result := TVirtualInterface(TInterfaceObject(JSThis).Obj).Invoke(MethodName, TJSValueDynArray(JSValue(JSArguments)));
      end;
  end;

  InterfaceObject['_AddRef'] := @_AddRef;
  InterfaceObject['_Release'] := @_Release;
  InterfaceObject['QueryInterface'] := @QueryInterface;

  SelfInterfaceObject := TInterfaceObject(Self);
  SelfInterfaceObject.InterfaceMaps := TJSObject.New;
  SelfInterfaceObject.InterfaceMaps[GUIDToString(IInterface)] := InterfaceObject;
  SelfInterfaceObject.InterfaceMaps[FInterfaceType.Guid.ToString] := TJSObject.New;
  SelfInterfaceObject.Interfaces := TJSObject.New;
  SelfInterfaceObject.Interfaces[FInterfaceType.Guid.ToString] := InterfaceObject;
end;

constructor TVirtualInterface.Create(InterfaceTypeInfo: TTypeInfoInterface; const InvokeEvent: TVirtualInterfaceInvokeEvent);
begin
  Create(InterfaceTypeInfo);

  OnInvoke := InvokeEvent;
end;

constructor TVirtualInterface.Create(InterfaceTypeInfo: TTypeInfoInterface; const InvokeEvent: TVirtualInterfaceInvokeEventJS);
begin
  Create(InterfaceTypeInfo);

  OnInvokeJS := InvokeEvent;
end;

destructor TVirtualInterface.Destroy;
begin
  FContext.Free;

  inherited;
end;

function TVirtualInterface.QueryInterface(const iid: TGuid; out obj): Integer;
begin
  Result := inherited QueryInterface(iid, obj);
end;

function TVirtualInterface.Invoke(const MethodName: String; const Args: TJSValueDynArray): JSValue;
var
  Method: TRttiMethod;

  Return: TValue;

  function GenerateParams: specialize TArray<TValue>;
  var
    A: Integer;

    Return: TValue;

    Param: TRttiParameter;

    Parameters: specialize TArray<TRttiParameter>;

  begin
    Parameters := Method.GetParameters;

    SetLength(Result, Length(Parameters));

    for A := Low(Parameters) to High(Parameters) do
    begin
      Param := Parameters[A];

      TValue.Make(Args[A], Param.ParamType.Handle, Result[A]);

      Result[A].FReferenceVariableData := (pfVar in Param.Flags) or (pfOut in Param.Flags);
    end;
  end;

begin
  if Assigned(FOnInvokeJS) then
    Result := FOnInvokeJS(MethodName, Args)
  else
  begin
    Method := FInterfaceType.GetMethod(MethodName);

    FOnInvoke(Method, GenerateParams, Return);

    Result := Return.AsJSValue;
  end;
end;

function Invoke(ACodeAddress: Pointer; const AArgs: TJSValueDynArray;
  ACallConv: TCallConv; AResultType: PTypeInfo; AIsStatic: Boolean;
  AIsConstructor: Boolean): TValue;
begin
  if ACallConv=ccReg then ;
  if AIsStatic then ;
  if AIsConstructor then
    raise EInvoke.Create('not supported');
  if isFunction(ACodeAddress) then
    begin
    Result.FData := TJSFunction(ACodeAddress).apply(nil, AArgs);
    if AResultType<>nil then
      Result.FTypeInfo:=AResultType
    else
      Result.FTypeInfo:=TypeInfo(JSValue);
    end
  else
    raise EInvoke.Create(SErrInvokeInvalidCodeAddr);
end;

end.

