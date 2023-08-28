{
    This file is part of the Pas2JS run time library.
    Copyright (c) 2017-2020 by the Pas2JS development team.

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}

{$mode objfpc}
{$modeswitch externalclass}

unit Web;

interface

uses Types, JS, weborworker;

Type
  // Forward definitions
  TJSHTMLElement = Class;
  TJSWindow = class;
  TJSDOMTokenList = class;
  TJSXPathResult = CLass;
  TJSNodeList = class;
  TJSDocument = class;
  TJSElement = class;
  TJSCSSStyleSheet = Class;
  TJSNodeFilter = Class;

  TJSMouseEvent = Class;
  TJSWheelEvent = Class;
  TJSKeyBoardEvent = class;
  TJSPointerEvent = Class;
  TJSUIEvent = class;
  TJSTouchEvent = Class;
  TJSPermissions = class;
  TJSFileSystemFileHandle = class;
  TJSFileSystemFileHandleArray = array of TJSFileSystemFileHandle;
  TJSFileSystemDirectoryHandle = class;
  TJSFileSystemDirectoryHandleArray = array of TJSFileSystemDirectoryHandle;
  TJSShowOpenFilePickerOptions = class;
  TJSShowSaveFilePickerOptions = class;

  TJSServiceWorker = weborworker.TJSServiceWorker;
  TJSServiceWorkerRegistration = weborworker.TJSServiceWorkerRegistration;
  TJSMessageEvent = weborworker.TJSMessageEvent;
  TJSMessagePortArray = TJSMessagePortDynArray;

  { TEventListenerEvent }

(*
TEventListenerEvent = class external name 'EventListener_Event' (TJSObject)
  private
    FTarget: TJSEventTarget; external name 'target';
  public
    Property target: TJSEventTarget Read FTarget;
  end;
*)
  TJSEvent = weborworker.TJSEvent;
  TEventListenerEvent = TJSEvent;
  TJSBlob = weborworker.TJSBlob;

  TJSEventHandler = reference to function(Event: TEventListenerEvent): boolean; safecall;
  TJSRawEventHandler = reference to Procedure(Event: TJSEvent); safecall;

  TJSEventTarget = weborworker.TJSEventTarget;

  TJSNode = class external name 'Node' (TJSEventTarget)
  Private
    FBaseURI : String; external name 'baseURI';
    FChildNodes: TJSNodeList; external name 'childNodes';
    FFirstChild : TJSNode; external name 'firstChild';
    FNextSibling : TJSNode; external name 'nextSibling';
    FNodeName : String; external name 'nodeName';
    FNodeType : NativeInt; external name 'nodeType';
    FOwnerDocument : TJSDocument; external name 'ownerDocument';
    FParentElement : TJSElement; external name 'parentElement';
    FParentNode : TJSNode; external name 'parentNode';
    FPreviousSibling : TJSNode; external name 'previousSibling';
  Public 
    Const
      ELEMENT_NODE 	=1;
      TEXT_NODE 	=3;
      PROCESSING_INSTRUCTION_NODE = 	7;
      COMMENT_NODE 	=8;
      DOCUMENT_NODE 	=9;
      DOCUMENT_TYPE_NODE 	= 10;
      DOCUMENT_FRAGMENT_NODE  = 11;

      DOCUMENT_POSITION_DISCONNECTED 	= 1;
      DOCUMENT_POSITION_PRECEDING 	= 2;
      DOCUMENT_POSITION_FOLLOWING 	= 4;
      DOCUMENT_POSITION_CONTAINS 	= 8;
      DOCUMENT_POSITION_CONTAINED_BY 	= 16;
      DOCUMENT_POSITION_IMPLEMENTATION_SPECIFIC = 32;
  Public  
    nodeValue: string;
    innerText : string;
    textContent : string;
    function appendChild(aChild : TJSNode) : TJSNode;
    function cloneNode(deep:  boolean): TJSNode;
    function compareDocumentPosition(aNode : TJSNode) : NativeInt;
    function contains(aNode : TJSNode) : boolean;
    function hasChildNodes : boolean;
    function insertBefore(newNode, referenceNode : TJSNode) : TJSNode;
    function isDefaultNameSpace(aNameSpaceURI : String) : Boolean;
    function isEqualNode(aNode : TJSNode) : boolean;
    function isSameNode(aNode : TJSNode) : boolean;
    function lookupNamespaceURI(aPrefix : string) : string;
    function lookupPrefix(aPrefix : string) : string;
    procedure normalize;
    function removeChild(aChild: TJSNode) : TJSNode;
    function replaceChild(aNewChild, aOldChild : TJSNode) : TJSNode;
    property baseURI : string read FBaseURI;
    property childNodes : TJSNodeList read FChildNodes;
    property firstChild : TJSNode Read FFirstChild;
    property nextSibling : TJSNode Read FNextSibling;
    property nodeName : String Read FNodeName;
    property nodeType : NativeInt Read FNodeType;
    property ownerDocument : TJSDocument read FOwnerDocument;    
    property parentElement : TJSElement read FParentElement;
    property parentNode : TJSNode read FParentNode;
    property previousSibling : TJSNode Read FPreviousSibling;
  end;


  TJSNodeListCallBack = reference to procedure (currentValue : TJSNode; currentIndex: NativeInt; list : TJSNodeList);
  TJSNodeListEvent = TJSNodeListCallBack;

  TJSNodeList = class external name 'NodeList' (TJSObject)
  Private
    FLength : NativeInt; external name 'length';
  Public
    procedure forEach(const aCallBack : TJSNodeListCallBack);
    function item(aIndex : NativeInt) : TJSNode;
    Property length : NativeInt Read FLength;
    Property Nodes [aIndex : NativeInt] : TJSNode Read item; default;
  end;

  TJSAttr = class external name 'Attr' (TJSNode)
  Private
    fLocalName : String; external name 'localName';
    fNameSpaceURI : String external name 'namespaceURI';
    fPrefix : string; external name 'prefix';
    fName : string; external name 'name';
    fSpecified : Boolean; external name 'specified';
  public
    value : JSValue;
    property localName : String Read fLocalName;
    property namespaceURI : string Read fNameSpaceURI;
    property prefix : string read fPrefix;
    property name : string Read fName;
    property specified : boolean Read fSpecified; // Useless, always true
  end;


  TJSNamedNodeMap = class external name 'NamedNodeMap'  (TJSObject)
  Public
    function getNamedItem(aName : string) : TJSAttr;
    Property Attrs[aIndex : String] : TJSattr Read getNamedItem; default;
  end;
  
  TJSHTMLCollection = class external name 'HTMLCollection'  (TJSObject)
  Private
    FLength : NativeInt; external name 'length';
  public
    Function item(aIndex : Integer) : TJSNode;
    Function namedItem(aName : string) : TJSNode;
    property Items[aIndex : Integer] : TJSNode Read item; default;
    property NamedItems[aName : String] : TJSNode Read namedItem; 
    Property length : NativeInt Read FLength;
  end;  
  
  TJSDOMString = String;

  TDOMTokenlistCallBack = Procedure (Current : JSValue; currentIndex : NativeInt; list : TJSDOMTokenList);
  
  // Interface
  TJSDOMTokenList = class external name 'DOMTokenList'  (TJSObject)
  Private
    FLength : NativeInt; external name 'length';
  public
    Procedure add(aToken : TJSDOMString); varargs;
    Procedure remove(aToken : TJSDOMString); varargs;
    function item(aIndex : NativeInt) : String;
    function contains(aToken : TJSDOMString) : Boolean;
    Procedure replace(aOldToken, ANewToken : TJSDOMString);
    function supports(aToken : TJSDOMString) : Boolean;
    function toggle(aToken : TJSDOMString) : Boolean;
    // entries,keys, values
    procedure forEach(const callback: TDOMTokenlistCallBack);
    property length : NativeInt read FLength;
  end;

  TJSDOMRect = class external name 'DOMRect'  (TJSObject)
  public
    left,top,right,bottom,x,y,width,height : double;
    {$IFDEF FIREFOX}
    constructor New;
    {$ENDIF}
  end;

  TJSClientRect = record
    left,top,right,bottom : double;
    {$IFDEF FIREFOX}
    width, height: double;
    {$ENDIF}
  end;
  
  TJSClientRectArray = array of TJSClientRect;
  
  TJSElement = class external name 'Element' (TJSNode)
  Private
    FAttributes : TJSNamedNodeMap; external name 'attributes';
    FChildElementCount : NativeInt; external name 'childElementCount';
    FChildren : TJSHTMLCollection; external name 'children';
    FClassList : TJSDOMTokenList; external name 'classList';
    FCLientHeight : NativeInt; external name 'clientHeight';
    FCLientLeft : NativeInt; external name 'clientLeft';
    FCLientTop : NativeInt; external name 'clientTop';
    FCLientWidth : NativeInt; external name 'clientWidth';
    FFirstElementChild : TJSElement; external name 'firstElementChild';
    FLastElementChild : TJSElement; external name 'lastElementChild';
    FLocalName : string; external name 'localName';
    FNameSpaceURI : String; external name 'namespaceURI';
    FNextElementSibling : TJSElement; external name 'nextElementSibling';
    FPreviousElementSibling : TJSElement; external name 'previousElementSibling';
    FPrefix : String; external name 'prefix';
    FScrollHeight : NativeInt; external name 'scrollHeight';
{$IFDEF FIREFOX}
    FScrollLeftMax : NativeInt; external name 'scrollLeftMax';
    FScrollTopMax : NativeInt; external name 'scrollTopMax';
{$endif}
    FScrollWidth : NativeInt; external name 'scrollWidth';
    FTagName : string; external name 'tagName';
  Public
    name : string;
    className : string;
    id : string;
    innerHTML : String;
    outerHTML : string;
    scrollLeft : NativeInt;
    scrollTop : NativeInt;
    procedure append(aText : String); overload;
    procedure append(aNode : TJSElement); overload;
    procedure append(aText : String; aNode : TJSElement); varargs; overload;
    procedure append(aNode1,aNode2: TJSElement); varargs; overload;
    function getAttribute(aName : string) : string;
    function getAttributeNode(aName : string) : TJSAttr;
    function getAttributeNodeNS(aNameSpace, aName : string) : TJSAttr;
    function getAttributeNS(aNameSpace, aName : string) : string;
    function getBoundingClientRect : TJSDOMRect;
    function getClientRects : TJSClientRectArray;
    function getElementsByClassName(aClassName: string) : TJSHTMLCollection;
    function getElementsByTagNameNS(aNameSpace, aTagName : String): TJSHTMLCollection;
    function getElementsByTagName(aTagName : String): TJSHTMLCollection;
    function hasAttribute(aName : String) : Boolean;
    function hasAttributeNS(aNameSpace,aName : String) : Boolean;
    function hasAttributes : Boolean;
    function insertAdjacentElement(aPosition : string; aElement : TJSElement) : TJSElement;
    procedure insertAdjacentHTML(aPosition,aHTML : string);
    procedure insertAdjacentText(aPosition,aText : string);
    function matches(aSelectorString : String) : Boolean;
    function querySelector(aSelectors : String) : TJSElement;
    function querySelectorAll(aSelectors : String) : TJSNodeList;
    procedure remove; overload;
    procedure releasePointerCapture(evID : JSValue);
    procedure removeAttribute(aName: string);
    procedure removeAttributeNS(aNameSpace,aName: string);
    function removeAttributeNode(aAttr : TJSAttr) : TJSAttr;
    procedure setAttribute(aName : string; AValue : String);
    function setAttributeNode(aNode: TJSAttr) : TJSAttr;
    function setAttributeNodeNS(aNode: TJSAttr) : TJSAttr;
    procedure setAttributeNS(aNameSpace,aName : string; AValue : String);
    procedure setCapture(retargetToElement : Boolean);
    procedure setPointerCapture(pointerID : JSValue);
    procedure requestFullScreen;    
    Property attributes : TJSNamedNodeMap read FAttributes;
    Property childElementCount : NativeInt Read FChildElementCount;
    Property children : TJSHTMLCollection Read FChildren;
    Property classList : TJSDOMTokenList read FClassList;
    property clientHeight : NativeInt read FClientHeight;
    property clientLeft : NativeInt read FClientLeft;
    property clientTop : NativeInt read FClientTop;
    property clientWidth : NativeInt read FClientWidth;
    property firstElementChild : TJSElement Read FFirstElementChild;
    property lastElementChild : TJSElement Read FLastElementChild;
    property localName : string Read FLocalName;
    property namespaceURI : String read FNameSpaceURI;
    property nextElementSibling : TJSElement Read FNextElementSibling;
    property previousElementSibling : TJSElement Read FPreviousElementSibling;
    property prefix : String read FPrefix;
    property scrollHeight : NativeInt Read FScrollHeight;
{$IFDEF FIREFOX}
    property scrollLeftMax  : NativeInt Read FScrollLeftMax;
    property scrollTopMax  : NativeInt Read FScrollTopMax;
{$ENDIF}
    property scrollWidth : NativeInt Read FScrollWidth;
    property tagName : String read FTagName;
    Property Attrs[aName : string] : String read getAttribute write setAttribute; default;
  end;
   
  TJSElementCreationOptions = record
    named : string;
  end;
 
  TJSDocumentType = class external name 'DocumentType' (TJSNode)
  private
    FName : String; external name 'name';
    FPublicID : String; external name 'publicId';
    FSystemID : String; external name 'systemId';
  public
    property name : String read FName;
    property publicId : String Read FPublicID;
    property systemId : String read FSystemID;
  end;

  TJSDOMImplementation  = class external name 'DocumentImplementation'  (TJSObject)
  Public  
    function createDocument(aNamespaceURI, aQualifiedNameStr : String; aDocumentType : TJSDocumentType) : TJSDocument;
    function createDocumentType(aQualifiedNameStr,aPublicId,aSystemId : String) : TJSDocumentType;
    function createHTMLDocument(aTitle : String) : TJSDocument;
  end;

  TJSLocation = class external name 'Location'  (TJSObject)
  Private
    FOrigin : string; external name 'origin';
  Public
    hash : string;
    host : string;
    hostname : string;
    href : string;
    password : string;
    pathname : string;
    port : string;
    protocol : string;
    search : string;
    username : string;
    procedure assign(aURL : String); overload;
    procedure reload(aForce : Boolean);
    procedure replace(aURL : String);
    property origin : string read FOrigin;
  end;
  
  TJSCSSStyleDeclaration = class; // forward

  TJSStyleSheet = class external name 'StyleSheet' (TJSEventTarget)
  Private
    FHRef : String; external name 'href';
    FOwnerNode : TJSNode; external name 'ownerNode';
    FParentStyleSheet : TJSStyleSheet; external name 'parentStyleSheet';
    FTitle : String; external name 'title';
    FType : String; external name 'type';
  Public
    disabled : String;
    Property href : String read FHRef;
    property ownerNode : TJSNode Read FOwnerNode;
    property parentStyleSheet : TJSStyleSheet read FParentStyleSheet;
    property title : string Read FTitle;
    property _type : String read FType;
  end;

  TJSCSSRule = class external name 'CSSRule'  (TJSObject)
  Private
    FCSSText : String; external name 'cssText';
    FParentStyleSheet : TJSCSSStyleSheet; external name 'parentStyleSheet';
    FparentRule : TJSCSSRule; external name 'parentRule';
  Public
    property cssText : String Read FCSSText;
    property parentRule : TJSCSSRule read FparentRule;
    property parentStyleSheet : TJSCSSStyleSheet Read FParentStyleSheet;
  end;

  TJSCSSStyleRule = class external name 'CSSStyleRule' (TJSCSSRule)
  private
    FStyle: TJSCSSStyleDeclaration; external name 'style';
  public
    selectorText: String;
    property style: TJSCSSStyleDeclaration read FStyle;
  end;
  
  TJSCSSRuleList = Class external name 'CSSRuleList'  (TJSObject)
  Private
    FLength : NativeInt; external name 'length';
  Public
    function item(index : NativeInt) : TJSCSSRule;
    property length : NativeInt Read FLength;
    Property items[aIndex : NativeInt] : TJSCSSRule read item; default;
  end;
  
  
  TJSCSSStyleSheet = class external name 'CSSStyleSheet' (TJSStyleSheet)
  Private
    FCSSRules : TJSCSSRuleList; external name 'cssRules';
  Public
    procedure deleteRule(aIndex : NativeInt);
    function insertRule(aRule : String; aIndex : NativeInt) : NativeInt;
    Property cssRules : TJSCSSRuleList read FCSSRules;
  end;

  TJSStyleSheetList = Class external name 'StyleSheetList'  (TJSObject)
  Private
    FLength : NativeInt; external name 'length';
  Public
    function item(index : NativeInt) : TJSStyleSheet;
    property length : NativeInt Read FLength;
    Property items[aIndex : NativeInt] : TJSStyleSheet read item; default;
  end;

  { TJSDocumentFragment }

  TJSDocumentFragment = Class external name 'DocumentFragment' (TJSNode)
  private
    FchildElementCount: Integer; external name 'childElementCount';
    Fchildren: TJSHTMLCollection; external name 'children';
    FfirstElementChild: TJSElement; external name 'firstElementChild';
    FlastElementChild: TJSElement; external name 'lastElementChild';
  public
    constructor new;
    function querySelector(aSelector : String) : TJSElement;
    function querySelectorAll(aSelector : String) : TJSNodeList;
    property childElementCount : Integer read FchildElementCount;
    property children : TJSHTMLCollection read Fchildren;
    property firstElementChild : TJSElement read FfirstElementChild;
    property lastElementChild : TJSElement read FlastElementChild;
  end;

  TJSEventInit = weborworker.TJSEventInit;

  { TJSEventHelper }

  TJSEventHelper = class helper for TJSEvent
  private
    function GetCurrentTargetElement: TJSElement;
    function GetCurrentTargetHTMLElement: TJSHTMLElement;
    function GetTargetElement: TJSElement;
    function GetTargetHTMLElement: TJSHTMLElement;
  Public
    property currentTargetElement : TJSElement Read GetCurrentTargetElement;
    property currentTargetHTMLElement : TJSHTMLElement Read GetCurrentTargetHTMLElement;
    property targetElement : TJSElement Read GetTargetElement;
    property targetHTMLElement : TJSHTmlElement Read GetTargetHTMLElement;
  end;


  TJSXPathExpression = class external name 'XPathExpression'  (TJSObject)
  Public
    function evaluate(contextNode : TJSNode; aType : NativeInt; aResult : TJSXPathResult) : TJSXPathResult;
    function evaluateWithContext(contextNode : TJSNode; aPosition, aSize, aType : NativeInt; aResult : TJSXPathResult) : TJSXPathResult;
  end;

  TJSXPathNSResolver = class external name 'XPathNSResolver'  (TJSObject)
  Public
    function lookupNamespaceURI(prefix : string) : string;
  end;

  { TJSCharacterData }

  TJSCharacterData = class external name 'CharacterData' (TJSNode)
  private
    FnextElementSibling: TJSElement; external name 'nextElementSibling';
    FpreviousElementSibling: TJSElement; external name 'previousElementSibling';
  public
    property nextElementSibling : TJSElement read FnextElementSibling;
    property previousElementSibling : TJSElement read FpreviousElementSibling;
  end;


  TJSProcessingInstruction = class external name 'ProcessingInstruction' (TJSCharacterData);

  { TJSRange }

  TJSRange = class external name 'Range'  (TJSObject)
  private
    FCollapsed: boolean; external name 'collapsed';
    FcommonAncestorContainer: TJSNode; external name 'commonAncestorContainer';
    FendContainer: TJSNode; external name 'endContainer';
    FEndOffset: NativeInt; external name 'endOffset';
    FstartContainer: TJSNode; external name 'startContainer';
    FstartOffset: NativeInt; external name 'startOffset';
  Public
    const
      END_TO_END     = 0;
      END_TO_START   = 1;
      START_TO_END   = 2;
      START_TO_START = 3;
  Public
    constructor new;
    function cloneContents : TJSDocumentFragment;
    function cloneRange : TJSRange;
    procedure collapse;
    function compareBoundaryPoints(aHow : NativeInt) : NativeInt;
    function createContextualFragment(aTagstring : String) : TJSDocumentFragment;
    procedure deleteContents;
    procedure detach;
    function extractContents : TJSDocumentFragment;
    procedure insertNode(aNode : TJSNode);
    procedure selectNode(aNode : TJSNode);
    procedure selectNodeContents(aNode : TJSNode);
    procedure setEnd(aEndNode : TJSNode; aEndOffset : NativeInt); 
    procedure setEndAfter(aEndNode : TJSNode);
    procedure setEndBefore(aEndNode : TJSNode);
    procedure setStart(aStartNode : TJSNode; aStartOffset : NativeInt); 
    procedure setStartAfter(aStartNode : TJSNode);
    procedure setStartBefore(aStartNode : TJSNode);
    procedure surroundContents(aNode : TJSNode);
    property collapsed : boolean read FCollapsed;
    property commonAncestorContainer : TJSNode read FcommonAncestorContainer ;
    property endContainer : TJSNode read FendContainer;
    property endOffset : NativeInt Read FEndOffset;
    property startContainer : TJSNode read FstartContainer;
    property startOffset : NativeInt Read FstartOffset;
  end;


  { TJSTreeWalker }

  TJSTreeWalker = class external name 'TreeWalker' (TJSObject)
  private
    FCurrentNode: TJSNode; external name 'currentNode';
    FexpandEntityReference: Boolean; external name 'expandEntityReference';
    FFilter: TJSNodeFilter; external name 'filter';
    FRoot: TJSNode; external name 'root';
    FWhatToShow: NativeInt; external name 'whatToShow';
  Public
    function firstChild : TJSNode;
    function lastChild : TJSNode;
    function nextNode : TJSNode;
    function nextSibling : TJSNode;
    function parentNode : TJSNode;
    function previousNode : TJSNode;
    function previousSibling : TJSNode;

    property root : TJSNode read FRoot;
    property whatToShow : NativeInt read FWhatToShow;
    property filter : TJSNodeFilter Read FFilter;
    property expandEntityReference : Boolean Read FexpandEntityReference;
    property currentNode : TJSNode Read FCurrentNode;
  end;

  TJSNodeFilter = class external name 'NodeFilter'  (TJSObject)
    const
      SHOW_ALL                    = -1;
      SHOW_ATTRIBUTE              = 2;
      SHOW_CDATA_SECTION          = 8;
      SHOW_COMMENT                = 128;
      SHOW_DOCUMENT               = 256;
      SHOW_DOCUMENT_FRAGMENT      = 1024;
      SHOW_DOCUMENT_TYPE          = 512;
      SHOW_ELEMENT                = 1;
      SHOW_ENTITY                 = 32;
      SHOW_ENTITY_REFERENCE       = 16;
      SHOW_NOTATION               = 2048;
      SHOW_PROCESSING_INSTRUCTION = 64;
      SHOW_TEXT                   = 4;
    function acceptNode (aNode : TJSNode) : NativeInt;
  end;

  TJSXPathResult = class external name 'XPathResult'  (TJSObject)
  private class var
    FANY_TYPE : Integer; external name 'ANY_TYPE';
    FNUMBER_TYPE : Integer; external name 'NUMBER_TYPE';
    FSTRING_TYPE : Integer; external name 'STRING_TYPE';
    FBOOLEAN_TYPE : Integer; external name 'BOOLEAN_TYPE';
    FUNORDERED_NODE_ITERATOR_TYPE : Integer; external name 'UNORDERED_NODE_ITERATOR_TYPE';
    FORDERED_NODE_ITERATOR_TYPE : Integer; external name 'ORDERED_NODE_ITERATOR_TYPE';
    FUNORDERED_NODE_SNAPSHOT_TYPE : Integer; external name 'UNORDERED_NODE_SNAPSHOT_TYPE';
    FORDERED_NODE_SNAPSHOT_TYPE : Integer; external name 'ORDERED_NODE_SNAPSHOT_TYPE';
    FANY_UNORDERED_NODE_TYPE : Integer; external name 'ANY_UNORDERED_NODE_TYPE';
    FFIRST_ORDERED_NODE_TYPE : Integer; external name 'FIRST_ORDERED_NODE_TYPE';
  public
    class property ANY_TYPE: Integer read FANY_TYPE;
    class property NUMBER_TYPE: Integer read FNUMBER_TYPE;
    class property STRING_TYPE: Integer read FSTRING_TYPE;
    class property BOOLEAN_TYPE: Integer read FBOOLEAN_TYPE;
    class property UNORDERED_NODE_ITERATOR_TYPE: Integer read FUNORDERED_NODE_ITERATOR_TYPE;
    class property ORDERED_NODE_ITERATOR_TYPE: Integer read FORDERED_NODE_ITERATOR_TYPE;
    class property UNORDERED_NODE_SNAPSHOT_TYPE: Integer read FUNORDERED_NODE_SNAPSHOT_TYPE;
    class property ORDERED_NODE_SNAPSHOT_TYPE: Integer read FORDERED_NODE_SNAPSHOT_TYPE;
    class property ANY_UNORDERED_NODE_TYPE: Integer read FANY_UNORDERED_NODE_TYPE;
    class property FIRST_ORDERED_NODE_TYPE: Integer read FFIRST_ORDERED_NODE_TYPE;
  private
    FBooleanValue : Boolean; external name 'booleanValue';
    FNumberValue : Double; external name 'numberValue';
    FResultType : NativeInt; external name 'resultType';
    FSingleNodeValue : TJSNode;  external name 'singleNodeValue';
    FSnaphotLength : NativeInt; external name 'snapshotLength';
    FStringValue : String; external name 'stringValue';
  public  
    Function iterateNext : TJSNode;
    Function snapshotItem(Index: NativeInt) : TJSNode;
    Property booleanValue : Boolean Read FBooleanValue;
    Property numberValue : Double Read FNumberValue;
    property resultType : NativeInt Read FResultType;
    Property singleNodeValue : TJSNode Read FSingleNodeValue;
    property snapshotLength : NativeInt read FSnaphotLength;
    property stringValue : String Read FStringValue;
  end;

  TJSSelection = class external name 'Selection'  (TJSObject)
  Private
    FanchorNode : TJSNode ; external name 'anchorNode';
    FanchorOffset : NativeInt ; external name 'anchorOffset';
    FfocusNode : TJSNode ; external name 'focusNode';
    FfocusOffset : NativeInt ; external name 'focusOffset';
    FisCollapsed : Boolean ; external name 'isCollapsed';
    FrangeCount : NativeInt ; external name 'rangeCount';
    Ftype : String ; external name 'type';
  Public
    function getRangeAt(aIndex : NativeInt) : TJSRange;
    procedure collapse(aParentNode : TJSNode; Offset : NativeInt);
    procedure extend(aParentNode : TJSNode; Offset : NativeInt);
    procedure collapseToStart;
    procedure collapseToEnd;
    procedure selectAllChildren(aParentNode : TJSNode);
    procedure addRange(aRange : TJSRange);
    procedure removeRange(aRange : TJSRange);
    procedure removeAllRanges;
    procedure deleteFromDocument;
    function containsNode(aNode : TJSNode; aPartlyContained : Boolean) : Boolean;
    procedure setBaseAndExtent(aAnchorNode : TJSNode; aAnchorOffset : NativeInt; aFocusNode : TJSNode; aFocusOffset : NativeInt);
    property anchorNode : TJSNode read FAnchorNode;
    property anchorOffset : NativeInt read FAnchorOffset;
    property focusNode : TJSNode read FFocusNode;
    property focusOffset : NativeInt read FFocusOffset;
    property isCollapsed : Boolean read FIsCollapsed;
    property rangeCount : NativeInt read FRangeCount;
    property _type : String Read FType;
  end;
  TJSNameSpaceMapperCallback = function (aNameSpace : string ) : String;

  TJSHTMLFile = class;
  TJSHTMLFileList = Class;

  { TJSDataTransferItem }

  TJSDataTransferItemCallBack = reference to Procedure(aData : String); safecall;

  TJSDataTransferItem = class external name 'DataTransferItem'  (TJSObject)
  private
    FKind: String; external name 'kind';
    FType: string; external name 'type';
  Public
    function getAsFile : TJSHTMLFile;
    Procedure getAsString(aCallBack : TJSDataTransferItemCallBack);
    property Kind : String read FKind;
    property _Type : string read FType;
  end;

  TJSDataTransferItemList = class external name 'DataTransferItemList'  (TJSObject)
  private
    FLength: NativeInt; external name 'length';
    function getitem(aIndex : nativeInt) : TJSDataTransferItem ; external name '[]';
  Public
    Function add(aData : string; AType: string) : TJSDataTransferItem; overload;
    Function add(aFile : TJSHTMLFile) : TJSDataTransferItem; overload;
    Procedure clear;
    procedure remove(aIndex : integer);
    property length : NativeInt read FLength;
    property Items[aIndex : NativeInt] : TJSDataTransferItem Read getitem; default;
  end;

  { TJSDataTransfer }

  TJSDataTransfer = class external name 'DataTransfer'  (TJSObject)
  private
    FFiles: TJSHTMLFileList; external name 'files';
    FItems: TJSDataTransferItemList; external name 'items';
    FTypes: TJSStringDynArray; external name 'types';
  Public
    dropEffect : string;
    effectAllowed : string;
    Procedure clearData; overload;
    Procedure clearData(aFormat : string); overload;
    function getData(aFormat : string) : String;
    procedure setData(aFormat : String; aData : String);
    procedure setDragImage(aImage: TJSElement; xOffset,yOffset : integer);
    property files : TJSHTMLFileList Read FFiles;
    property items : TJSDataTransferItemList read FItems;
    property types : TJSStringDynArray read FTypes;
  end;

  { TJSDragEvent }

  TJSDragEvent = class external name 'DragEvent' (TJSEvent)
  Private
    FDataTransfer: TJSDataTransfer; external name 'dataTransfer';
    FrelatedTarget : TJSEventTarget external name 'relatedTarget';
    FscreenX : NativeInt external name 'screenX';
    FscreenY : NativeInt external name 'screenY';
    FclientX : NativeInt external name 'clientX';
    FclientY : NativeInt external name 'clientY';
    Fbutton : NativeInt external name 'button';
    Fbuttons : NativeInt external name 'buttons';
    FctrlKey : Boolean external name 'ctrlKey';
    FshiftKey : Boolean external name 'shiftKey';
    FaltKey  : Boolean external name 'altKey';
    FmetaKey  : Boolean external name 'metaKey';
  Public
    Property relatedTarget : TJSEventTarget Read FRelatedTarget;
    Property screenX : NativeInt Read FScreenX;
    Property screenY : NativeInt Read FScreenY;
    Property clientX : NativeInt Read FClientX;
    Property clientY : NativeInt Read FClientY;
    Property button : NativeInt Read FButton;
    Property buttons : NativeInt Read FButtons;
    Property ctrlKey : Boolean Read FctrlKey;
    Property shiftKey : Boolean Read FshiftKey;
    Property altKey  : Boolean Read FaltKey;
    Property metaKey  : Boolean Read FmetaKey;
    property dataTransfer : TJSDataTransfer Read FDataTransfer;
  end;
  TJSDragDropEventHandler = reference to function(aEvent: TJSDragEvent) : Boolean; safecall;
  THTMLClickEventHandler = reference to function(aEvent : TJSMouseEvent) : boolean; safecall;

  TJSClipBoardEvent = Class external name 'ClipboardEvent' (TJSEvent)
  Private
    FClipboardData: TJSDataTransfer external name 'clipboardData';
  Public
    Property ClipBoardData : TJSDataTransfer Read FClipBoardData;
  end;

  { Various events }

  TJSFocusEvent = Class(TJSEvent)
  private
    FrelatedTarget : TJSElement external name 'relatedTarget';
  public
    property relatedTarget : TJSElement Read FrelatedTarget;
  end;

  TJSAnimationEvent = Class(TJSEvent);
  TJSLoadEvent = Class(TJSEvent);

  TJSErrorEvent = class external name 'ErrorEvent' (TJSEvent)
  Private
    Fmessage : String external name 'message';
    Ffilename : string external name 'filename';
    Flineno : integer external name 'lineno';
    Fcolno : integer external name 'colno';
    Ferror : TJSObject external name 'error';
  Public
    Property message : String read FMessage;
    property filename : string Read FFileName;
    property lineno : integer read FLineNo;
    Property colno : integer read FColNo;
    Property error : TJSObject read FError;
  end;

  TJSPageTransitionEvent = class(TJSEvent)
  end;

  TJSHashChangeEvent = class external name 'HashChangeEvent' (TJSEvent)
  Private
    FnewURL : String external name 'newURL';
    FoldURL : String external name 'oldURL';
  public
    property newURL : String Read FNewURL;
    property oldURL : String Read FOldURL;
  end;

  TJSPopStateEvent = class external name 'PopStateEvent'  (TJSEvent)
  Private
    FState : JSValue; external name 'state';
  Public
    property state : JSValue read FState;
  end;

  TJSStorageEvent = class external name 'StorageEvent' (TJSEvent)
  private
    Fkey : String external name 'key';
    FoldValue : String external name 'oldValue';
    FnewValue : String external name 'newValue';
    Furl : String external name 'url';
    FstorageArea : String external name 'storageArea';
  public
    Property key : String Read FKey;
    Property oldValue : String Read FOldValue;
    Property newValue : String Read FNewValue;
    Property url : String Read FURL;
    Property storageArea : String Read FstorageArea;
  end;

  { TJSProgressEvent }

  TJSProgressEvent = class external name 'ProgressEvent' (TJSEvent)
  Private
    FlengthComputable : Boolean external name 'lengthComputable';
    Floaded : NativeUINT external name 'loaded';
    FTotal : NativeUINT external name 'Total';
  Public
    property lengthComputable : Boolean Read FlengthComputable;
    property loaded : NativeUINT Read FLoaded;
    property Total : NativeUINT Read FTotal;
  end;

  TJSCloseEvent = class external name 'CloseEvent' (TJSEvent)
  private
    fcode: Word; external name 'code';
    freason: TJSDOMString; external name 'reason';
    fwasClean: Boolean; external name 'wasClean';
  public
    property code: Word read fcode;
    property reason: TJSDOMString read freason;
    property wasClean: Boolean read fwasClean;
  end; 

  TJSPageTransitionEventHandler = reference to function(aEvent : TJsPageTransitionEvent) : boolean; safecall;
  TJSHashChangeEventhandler = reference to function(aEvent : TJSHashChangeEvent) : boolean; safecall;
  TJSMouseWheelEventHandler = reference to function(aEvent : TJSWheelEvent) : boolean; safecall;
  TJSMouseEventHandler = reference to function(aEvent : TJSMouseEvent) : boolean; safecall;
  THTMLAnimationEventHandler = reference to function(aEvent : TJSAnimationEvent) : boolean; safecall;
  TJSErrorEventHandler = reference to function(aEvent : TJSErrorEvent) : boolean; safecall;
  TJSFocusEventHandler = reference to function(aEvent : TJSFocusEvent) : boolean; safecall;
  TJSKeyEventhandler = reference to function (aEvent : TJSKeyBoardEvent) : boolean; safecall;
  TJSLoadEventhandler = reference to function (aEvent : TJSLoadEvent) : boolean; safecall;
  TJSPointerEventHandler = reference to function(aEvent : TJSPointerEvent) : boolean; safecall;
  TJSUIEventHandler = reference to function(aEvent : TJSUIEvent) : Boolean; safecall;
  TJSPopStateEventHandler = reference to function(aEvent : TJSPopStateEvent) : Boolean; safecall;
  TJSStorageEventHandler = reference to function(aEvent : TJSStorageEvent) : Boolean; safecall;
  TJSProgressEventhandler =  reference to function(aEvent : TJSProgressEvent) : Boolean; safecall;
  TJSTouchEventHandler = reference to function(aEvent : TJSTouchEvent) : boolean; safecall;

  TJSDocument = class external name 'Document' (TJSNode)
  Private
    fActiveElement : TJSElement; external name 'activeElement';
    FCharacterSet: String; external name 'characterSet';
    FChildElementCount: NativeInt; external name 'childElementCount';
    FCompatMode: String; external name 'compatMode';
    FCurrentScript: TJSElement; external name 'currentScript';
    FDefaultView: TJSWindow; external name 'defaultView';
    FDocType: TJSDocumentType; external name 'docrype';
    FDocumentElement: TJSElement; external name 'documentElement';
    FDocumentURI: String; external name 'documentURI';
    FEmbeds: TJSHTMLCollection; external name 'embeds';
    FFirstElementChild : TJSElement; external name 'firstElementChild';
    FForms: TJSHTMLCollection; external name 'forms';
    FFullScreenElement: TJSElement; external name 'fullscreenElement';
    FFullscreenEnabled: Boolean; external name 'fullscreenEnabled';
    FHead: TJSElement; external name 'head';
    FHidden: Boolean; external name 'hidden';
    FImages: TJSHTMLCollection; external name 'images';
    FImplementation: TJSDOMImplementation; external name 'implementation';
    FLastElementChild : TJSElement; external name 'lastElementChild';
    FLastModified: String; external name 'lastModified';
    FLastStyleSheetSet: String; external name 'lastStyleSheetSet';
    FLinks: TJSHTMLCollection; external name 'links';
    FLocation: TJSLocation; external name 'location';
    FLocationString: String; external name 'location';
    FPlugins: TJSHTMLCollection; external name 'plugins';
    FPointerLockElement: TJSElement; external name 'pointerLockElement';
    FPreferredStyleSheetSet: String; external name 'preferredStyleSheetSet';
    FReadyState: String; external name 'readyState';
    FReferrer: String; external name 'referrer';
    FScripts: TJSHTMLCollection; external name 'scripts';
    FStyleSheets: TJSStyleSheetList; external name 'styleSheets';
    FStyleSheetSets: TJSValueDynArray; external name 'styleSheetSets';
    FURL: String; external name 'URL';
    FVisibilityState: string; external name 'visibilityState';
  Public
    function adoptNode(aExternalNode : TJSNode) : TJSNode;
    procedure close;
    function createAttribute(aName : string) : TJSAttr;
    function createCDATASection(S : String) : TJSNode;
    function createComment(S : String) : TJSNode;
    function createDocumentFragment : TJSDocumentFragment;
    function createElement(tagName : string) : TJSElement; overload;
    function createElement(tagName : string; const options : TJSElementCreationOptions) : TJSElement; overload;
    function createElementNS(aNameSpace,tagName : string) : TJSElement; overload;
    function createElementNS(aNameSpace,tagName : string; const options : TJSElementCreationOptions) : TJSElement; overload;
    function createEvent(aType : string) : TJSEvent;
    function createExpression(xPathText : String; aNameSpaceMapper: TJSNameSpaceMapperCallback) : TJSXPathExpression;
    function createNSResolver(aNode : TJSNode) : TJSXPathNSResolver;
    function createProcessingInstruction(target, data : String) : TJSProcessingInstruction;
    function createRange : TJSRange;
    function createTextNode(S : String) : TJSNode;
    function createTreeWalker(root : TJSNode; whatToShow : NativeInt; filter : TJSNodeFilter) : TJSTreeWalker;
    function elementFromPoint(x,y : integer) : TJSElement;
    procedure enableStyleSheetsForSet(aSet : String);
    function evaluate(xpathExpression : String; ContextNode : TJSNode; NameSpaceResolver : TJSNamespaceMapperCallBack; resultType : NativeInt; aResult : TJSXPathResult) : TJSXPathResult;
    function execCommand(aCommandName : String; aShowDefaultUI : Boolean; AValueArgument : String) : boolean; overload;
    function execCommand(aCommandName : String; aShowDefaultUI : Boolean) : boolean; overload;
    Procedure exitFullScreen;
    function getElementById(aID : String) : TJSElement;
    function getHTMLElementById(aID : String) : TJSHTMLElement; external name 'getElementById';
    function getElementsByClassName(aNames : string) : TJSHTMLCollection;
    function getElementsByName(aName : String) : TJSNodeList;
    function getElementsByTagName(aName : String) : TJSHTMLCollection;
    function getElementsByTagNameNS(aNameSpace,aName : String) : TJSHTMLCollection;
    function getSelection : TJSSelection;
    function hasFocus : boolean;
    function importNode(aExternalNode : TJSNode; Deep: boolean) : TJSNode;
    function querySelector(aSelectors : String) : TJSElement;
    function querySelectorAll(aSelectors : String) : TJSNodeList;
    procedure open;
    procedure releaseCapture;
    procedure write(aLine : string);
    procedure writeln(aLine : String);
  Public
    body : TJSElement;
    cookie: TJSString;
    designMode : string;
    dir : string;
    domain : string;
    selectedStyleSheetSet : string;
    title : string;
    onabort : TJSEventHandler;
    onblur : TJSEventHandler;
    oncancel : TJSEventHandler;
    oncanplay : TJSEventHandler;
    oncanplaythrough : TJSEventHandler;
    onchange : TJSEventHandler;
    onclick: THTMLClickEventHandler;
    onclose : TJSEventHandler;
    oncontextmenu : TJSEventHandler;
    oncuechange : TJSEventHandler;
    ondblclick : THTMLClickEventHandler;
    ondrag : TJSDragDropEventHandler;
    ondragend : TJSDragDropEventHandler;
    ondragenter : TJSDragDropEventHandler;
    ondragexit : TJSDragDropEventHandler;
    ondragover : TJSDragDropEventHandler;
    ondragleave : TJSDragDropEventHandler;
    ondragstart: TJSDragDropEventHandler;
    ondrop : TJSDragDropEventHandler;
    ondurationchange : TJSEventHandler;
    onemptied : TJSEventHandler;
    onended : TJSEventHandler;
    onerror : TJSErrorEventHandler;
    onfocus : TJSFocusEventhandler;
    ongotpointercapture : TJSPointerEventHandler;
    oninput : TJSEventhandler;
    oninvalid : TJSEventhandler;
    onkeydown : TJSKeyEventhandler;
    onkeypress : TJSKeyEventhandler;
    onkeyup : TJSKeyEventhandler;
    onload : TJSEventhandler;
    onloadeddata : TJSEventhandler;
    onloadedmetadata : TJSEventhandler;
    onloadend : TJSProgressEventhandler;
    onloadstart : TJSProgressEventhandler;
    onlostpointercapture : TJSPointerEventHandler;
    onmessage : TJSEventHandler;
    onmousedown : TJSMouseEventHandler;
    onmouseenter : TJSMouseEventHandler;
    onmouseleave : TJSMouseEventHandler;
    onmousemove : TJSMouseEventHandler;
    onmouseout : TJSMouseEventHandler;
    onmouseover : TJSMouseEventHandler;
    onmouseup : TJSMouseEventHandler;
    onmousewheel : TJSMouseEventHandler;
    onpause : TJSEventHandler;
    onplay : TJSEventHandler;
    onplaying : TJSEventHandler;
    onpointercancel : TJSPointerEventHandler;
    onpointerdown : TJSPointerEventHandler;
    onpointerenter : TJSPointerEventHandler;
    onpointerleave : TJSPointerEventHandler;
    onpointermove : TJSPointerEventHandler;
    onpointerout : TJSPointerEventHandler;
    onpointerover : TJSPointerEventHandler;
    onpointerup : TJSPointerEventHandler;
    onpointerlockchange : TJSPointerEventHandler;
    onprogress : TJSProgressEventhandler;
    onreset : TJSUIEventHandler;
    onratechange : TJSEventHandler;
    onscroll : TJSUIEventHandler;
    onseekend : TJSEventHandler;
    onseeking : TJSEventHandler;
    onselect : TJSEventHandler;
    onselectionchange : TJSEventHandler;
    onsshow : TJSEventHandler;
    onsubmit : TJSEventHandler;
    onunload : TJSUIEventHandler;
    onwaiting : TJSEventHandler;
    touchstart : TJSTouchEventHandler;
    touchend : TJSTouchEventHandler;
    touchmove : TJSTouchEventHandler;
    touchcancel : TJSTouchEventHandler;
    Property activeElement : TJSElement Read FActiveElement;
    Property characterSet : String Read FCharacterSet;
    property childElementCount : NativeInt Read FChildElementCount;
    property compatMode : String Read FCompatMode;
    property currentScript : TJSElement Read FCurrentScript;
    property defaultView : TJSWindow Read FDefaultView;
    property doctype : TJSDocumentType read FDocType;
    property documentElement : TJSElement read FDocumentElement;
    property documentURI : String Read FDocumentURI;
    property embeds : TJSHTMLCollection Read FEmbeds;
    property firstElementChild : TJSElement Read FFirstElementChild;
    property lastElementChild : TJSElement Read FLastElementChild;
    property Forms : TJSHTMLCollection Read FForms;
    property fullscreenElement : TJSElement Read FFullScreenElement;
    property fullscreenEnabled : Boolean Read FFullscreenEnabled;
    property head : TJSElement read FHead;
    Property hidden : Boolean read FHidden;
    property images : TJSHTMLCollection Read FImages;
    property _implementation : TJSDOMImplementation Read FImplementation;
    property lastModified : String Read FLastModified;
    property lastStyleSheetSet : String read FLastStyleSheetSet;
    property links : TJSHTMLCollection Read FLinks;
    property location : TJSLocation read FLocation;
    Property LocationString : String Read FURL Write FLocationString; // On purpose
    property plugins : TJSHTMLCollection Read FPlugins;
    property pointerLockElement : TJSElement Read FPointerLockElement;
    property preferredStyleSheetSet : String Read FPreferredStyleSheetSet;
    Property readyState : String Read FReadyState;
    Property referrer : String Read FReferrer;
    property scripts : TJSHTMLCollection Read FScripts;
    property styleSheets : TJSStyleSheetList Read FStyleSheets;
    property styleSheetSets : TJSValueDynArray Read FStyleSheetSets; // No type documented ?
    Property URL : String Read FURL;
    property visibilityState : string read FVisibilityState;
  end;

  TJSConsole = weborworker.TJSConsole;

//  TJSBufferSource = class external name 'BufferSource' end;
//  TJSTypedArray = class external name 'TypedArray' end;

  // Forward class definitions
  KeyType = weborworker.TJSCryptoKeyType;
  KeyUsage = weborworker.TJSCryptoKeyUsage;

  NamedCurve = weborworker.TJSCryptoNamedCurve;
  BigInteger = weborworker.TJSCryptoBigInteger;

  KeyFormat = weborworker.TJSCryptoKeyFormat;
  // Union of object, DOMString


  Algorithm = weborworker.TJSCryptoAlgorithm;
  AesCbcParams = weborworker.TJSCryptoAesCbcParams;
  AesCtrParams = weborworker.TJSCryptoAesCtrParams;
  AesGcmParams = weborworker.TJSCryptoAesGcmParams;
  HmacImportParams = weborworker.TJSCryptoHmacImportParams;
  Pbkdf2Params = weborworker.TJSCryptoPbkdf2Params;
  RsaHashedImportParams = weborworker.TJSCryptoRsaHashedImportParams;
  AesKeyGenParams = weborworker.TJSCryptoAesKeyGenParams;
  HmacKeyGenParams = weborworker.TJSCryptoHmacKeyGenParams;
  RsaHashedKeyGenParams = weborworker.TJSCryptoRsaHashedKeyGenParams;
  RsaOaepParams = weborworker.TJSCryptoRsaOaepParams;
  RsaPssParams = weborworker.TJSCryptoRsaPssParams;
  DhKeyGenParams = weborworker.TJSCryptoDhKeyGenParams;
  EcKeyGenParams = weborworker.TJSCryptoEcKeyGenParams;
  AesDerivedKeyParams = weborworker.TJSCryptoAesDerivedKeyParams;
  HmacDerivedKeyParams = weborworker.TJSCryptoHmacDerivedKeyParams;
  EcdhKeyDeriveParams = weborworker.TJSCryptoEcdhKeyDeriveParams;
  DhKeyDeriveParams = weborworker.TJSCryptoDhKeyDeriveParams;
  DhImportKeyParams = weborworker.TJSCryptoDhImportKeyParams;

  EcdsaParams = weborworker.TJSCryptoEcdsaParams;
  EcKeyImportParams = weborworker.TJSCryptoEcKeyImportParams;

  CryptoKeyPair = weborworker.TJSCryptoKeyPair;
  HkdfParams = weborworker.TJSCryptoHkdfParams;
  RsaOtherPrimesInfo = weborworker.TJSCryptoRsaOtherPrimesInfo;
  TRsaOtherPrimesInfoDynArray = weborworker.TJSCryptoRsaOtherPrimesInfoDynArray;
  TKeyUsageDynArray = weborworker.TJSCryptoKeyUsageDynArray;
  TJSCryptoKey = weborworker.TJSCryptoKey;
  TJSSubtleCrypto = weborworker.TJSSubtleCrypto;
  TJSCrypto = weborworker.TJSCrypto;

  { TJSHistory }

  TJSHistory = class external name 'History'  (TJSObject)
  private
    FLength: NativeInt; external name 'length';
{$IFDEF FIREFOX}
    FState : JSValue; external name 'state';
{$ENDIF}
  Public
    procedure back;
    procedure forward;
    procedure go(aIndex : NativeInt);
    procedure go;
    procedure pushState(aState : jsValue; aTitle : String; AURL : String);
    procedure pushState(aState : jsValue; aTitle : String);
    procedure replaceState(aState : jsValue; aTitle : String; AURL : String);
    procedure replaceState(aState : jsValue; aTitle : String);
    procedure replaceState(aState : jsValue);
{$IFDEF FIREFOX}
    property state : JSValue read FState;
{$ENDIF}
    property length: NativeInt read FLength;
  end;

  { IndexedDB - moved to weborworker}

  TJSIDBTransactionMode = weborworker.TJSIDBTransactionMode;
  TJSIDBTransaction = weborworker.TJSIDBTransaction;
  TJSIDBKeyRange = weborworker.TJSIDBKeyRange;
  TJSIDBIndexParameters = weborworker.TJSIDBIndexParameters;
  TJSIDBIndex = weborworker.TJSIDBIndex;
  TJSIDBCursorDirection = weborworker.TJSIDBCursorDirection;
  TJSIDBCursor = weborworker.TJSIDBCursor;
  TJSIDBObjectStore = weborworker.TJSIDBObjectStore;
  TJSIDBRequest = weborworker.TJSIDBRequest;
  TJSIDBOpenDBRequest = weborworker.TJSIDBOpenDBRequest;
  TJSCreateObjectStoreOptions = weborworker.TJSCreateObjectStoreOptions;
  TIDBDatabase = weborworker.TIDBDatabase;
  TJSIDBFactory = weborworker.TJSIDBFactory;

  { TJSStorage }

  TJSStorage = class external name 'Storage' (TJSEventTarget)
  private
    FLength: NativeInt; external name 'length';
  public
    function key(aIndex : Integer) : String;
    function getItem(aKeyName : string) : string;
    procedure setItem(aKeyName : string; aValue : string);
    procedure removeItem(aKeyName : string);
    procedure clear;
    property Keys[AIndex : Integer] : String read key;
    property Items[aKeyName: String] : String read getItem write setItem; default;
    property length : NativeInt Read FLength;
  end;

  // Fake object, used for objects whose visible can be checked
  TJSVisibleItem = class external name 'IVisible'  (TJSObject)
  Private
    FVisible : boolean; external name 'visible';
  Public
    Property visible : boolean read FVisible;
  end;
  
  TJSLocationBar = class external name 'LocationBar' (TJSVisibleItem);
  TJSMenuBar = class external name 'MenuBar' (TJSVisibleItem);
  TJSToolBar = class external name 'ToolBar' (TJSVisibleItem);
  TJSPersonalBar = class external name 'PersonalBar' (TJSVisibleItem);
  TJSScrollBars = class external name 'ScrollBars' (TJSVisibleItem);

  TJSPositionError = record
    code : integer;
    message : string;
  end;

  TJSPositionOptions = record
    enableHighAccuracy : boolean;
    timeout : integer;
    maximumAge : integer;
  end;

  TJSCoordinates = record
    latitude : double;
    longitude : double;
    altitude : double;
    accuracy : double;
    altitudeAccuracy : double;
    heading : double;
    speed : double;
  end;

  TJSPosition = record
    coords : TJSCoordinates;
    timestamp : String;
  end;

  TJSGeoLocationCallback = procedure (aPosition : TJSPosition);
  TJSGeoLocationEvent = procedure (aPosition : TJSPosition) of object;
  TJSGeoLocationErrorCallback = procedure (aValue : TJSPositionError);
  TJSGeoLocationErrorEvent = procedure (aValue : TJSPositionError) of object;

  TJSGeoLocation  = class external name 'GeoLocation'  (TJSObject)
  Public
    Procedure getCurrentPosition(ASuccess : TJSGeoLocationCallback); overload;
    Procedure getCurrentPosition(ASuccess : TJSGeoLocationCallback;aError : TJSGeoLocationErrorCallback); overload;
    Procedure getCurrentPosition(ASuccess : TJSGeoLocationCallback;aError : TJSGeoLocationErrorCallback; AOptions : TJSPositionOptions); overload;
    Function watchPosition(ASuccess : TJSGeoLocationCallback) : NativeInt; overload;
    Function watchPosition(ASuccess : TJSGeoLocationCallback;aError : TJSGeoLocationErrorCallback) : NativeInt; overload;
    Function watchPosition(ASuccess : TJSGeoLocationCallback;aError : TJSGeoLocationErrorCallback; AOptions : TJSPositionOptions) : NativeInt; overload;
    procedure clearWatch(AID : NativeInt);
  end;

  TJSMediaStreamTrack = class external name 'MediaStreamTrack' (TJSEventTarget)
  end;

  TJSMediaDevices = class external name 'MediaDevices' (TJSEventTarget)
  end;

  TJSWorker = weborworker.TJSWorker;


  { TJSSharedWorker }

  TJSSharedWorker = class external name 'SharedWorker' (TJSEventTarget)
  private
    FPort: TJSMessagePort; external name 'port';
  Public
    constructor new(aURL : String); overload;
    constructor new(aURL : String; aName : string); overload;
    property port : TJSMessagePort Read FPort;
  end;

  TJSExtendableEvent = weborworker.TJSExtendableEvent;
  TJSClient = weborworker.TJSClient;
  TJSExtendableMessageEvent = weborworker.TJSExtendableMessageEvent;

  TJSServiceWorkerContainerOptions = record
    scope : string;
  end;

  { TJSServiceWorkerContainer }

  TJSServiceWorkerContainer = class external name 'ServiceWorkerContainer'  (TJSObject)
  private
    FController: TJSServiceWorker; external name 'controller';
    FReady: TJSPromise; external name 'ready';
  Public
    function register(aURL : String) : TJSPromise; overload;
    function register(aURL : String; aOptions : TJSServiceWorkerContainerOptions) : TJSPromise; overload;
    function getRegistration(aURL : String) : TJSPromise; overload;
    function getRegistration : TJSPromise; overload;
    function getRegistrations : TJSPromise;
    property controller : TJSServiceWorker read FController;
    property ready : TJSPromise read FReady;
  end;

  TJSClipboardItemOptions = Class external name 'Object' (TJSObject)
    presentationStyle : String;
  end;

  TJSClipBoardItem = Class external name 'ClipboardItem' (TJSObject)
    constructor new(aData : TJSObject; aOptions : TJSOBject); overload;
    constructor new(aData : TJSObject; aOptions : TJSClipboardItemOptions); overload;
    constructor new(aData : TJSObject); overload;
  end;

  TJSClipBoard = class external name 'Clipboard' (TJSEventTarget)
    Function read : TJSPromise;
    Function readText : TJSPromise;
    Function write(Data : Array of TJSClipBoardItem) : TJSPromise;
    Function writeText(aText : String) : TJSPromise;
  end;

  { TJSNavigator }

  TJSNavigator = class external name 'Navigator'  (TJSObject)
{$IFDEF FIREFOX}
    FbuildID : String ; external name 'buildID';
    FOSCPU : String ; external name 'oscpu';
    FproductSub : string; external name 'productSub';
    FVendor : string; external name 'vendor';
{$ENDIF}
  private
    FCookieEnabled: Boolean; external name 'cookieEnabled';
    FGeoLocation: TJSGeoLocation; external name 'geolocation';
    FLanguage: String; external name 'language';
    FMaxTouchPoints: NativeInt; external name 'maxTouchPoints';
    FMediaDevices: TJSMediaDevices; external name 'mediaDevices';
    FOnline: boolean; external name 'onLine';
    FPlatform: string; external name 'platform';
    FServiceWorker: TJSServiceWorkerContainer; external name 'serviceWorker';
    FStorage: TJSStorageManager; external name 'storage';
    FUserAgent: string; external name 'userAgent';
    fClipBoard : TJSClipBoard; external name 'clipboard';
    FPermissions: TJSPermissions; external name 'permissions';
  public
    function getBattery : TJSPromise;
    function requestMediaKeySystemAccess(aKeySystem : String; supportedConfigurations : TJSValueDynArray) : TJSPromise;
    Procedure registerContentHandler(aMimeType,aURI,aTitle : string);
    Procedure registerProtocolHandler(aProtocol,aURI,aTitle : string);
    Procedure vibrate(aPattern : NativeInt);
    Procedure vibrate(aPattern : Array of NativeInt);
{$IFDEF FIREFOX}
    property buildID : String read FBuildID;
    property oscpu : string read FOSCPU;
    property productSub: string read FproductSub;
    property vendor : string read Fvendor;
{$ENDIF}
    property cookieEnabled : Boolean read FCookieEnabled;
    property geoLocation : TJSGeoLocation Read FGeoLocation;
    property language : String read FLanguage;
    property maxTouchPoints : NativeInt read FMaxTouchPoints;
    property mediaDevices : TJSMediaDevices read FMediaDevices;
    property onLine : boolean read FOnline;
    property platform : string read FPlatform;
    property userAgent : string read FUserAgent;
    property serviceWorker : TJSServiceWorkerContainer read FServiceWorker;
    property ClipBoard : TJSClipBoard Read FCLipboard;
    property permissions: TJSPermissions read FPermissions;
    property storage : TJSStorageManager Read FStorage;
  end;

  { TJSTouchEvent }
  TTouchCoord = longint;

  TJSTouch = class external name 'Touch'  (TJSObject)
  private
    FClientX: TTouchCoord; external name 'clientX';
    FClientY: TTouchCoord; external name 'clientY';
    FIDentifier: longint; external name 'identifier';
    FPageX: TTouchCoord; external name 'pageX';
    FPageY: TTouchCoord; external name 'pageY';
    FScreenX: TTouchCoord; external name 'screenX';
    FScreenY: TTouchCoord; external name 'screenY';
    FTarget: TJSElement; external name 'target';
  Public
    Property identifier : longint read FIDentifier;
    Property ScreenX : TTouchCoord Read FScreenX;
    Property ScreenY : TTouchCoord Read FScreenY;
    Property ClientX : TTouchCoord Read FClientX;
    Property ClientY : TTouchCoord Read FClientY;
    Property PageX : TTouchCoord Read FPageX;
    Property PageY : TTouchCoord Read FPageY;
    Property Target : TJSElement Read FTarget;
  end;

  { TJSTouchList }

  TJSTouchList = class external name 'TouchList' (TJSObject)
  private
    FLength: NativeInt; external name 'length';
  Public
    function item (aIndex : Integer) : TJSTouch;
    property length : NativeInt Read FLength;
    Property Touches[AIndex : Integer] : TJSTouch Read item; default;
  end;


  TJSPerformance = class external name 'Performance' (TJSObject);

  TJSScreen = class external name 'Screen' (TJSObject)
  private
    FavailHeight: Integer; external name 'availHeight';
    FavailWidth: Integer; external name 'availWidth';
    FcolorDepth: Integer; external name 'colorDepth';
    FPixelDepth: Integer; external name 'pixelDepth';
    Fheight: Integer; external name 'height';
    Fwidth: Integer; external name 'width';
  public
  { Properties declarations }
    property availHeight: Integer read FavailHeight;
    property availWidth: Integer read FavailWidth;
    property colorDepth: Integer read FcolorDepth;
    property pixelDepth: Integer read FPixelDepth;
    property height: Integer read Fheight;
    property width: Integer read Fwidth;
  end;



  TJSURLSearchParams = weborworker.TJSURLSearchParams;
  TJSURL = weborworker.TJSURL;
  TJSURLDynArray = weborworker.TJSURLDynArray;


  TJSTimerCallBack = weborworker.TJSTimerCallBack;


  { TJSMediaQueryList }

  TJSMediaQueryList = class external name 'MediaQueryList' (TJSObject)
  private
    FMatches: Boolean; external name 'matches';
    FMedia: String; external name 'media';
  Public
    Property matches : Boolean Read FMatches;
    Property media : String Read FMedia;
  end;

  TJSReadableStream = weborworker.TJSReadableStream;
  TJSWritableStream = weborworker.TJSWritableStream;
  TJSBody = weborworker.TJSBody;

  TJSResponse = weborworker.TJSResponse;

  TJSDOMHighResTimeStamp = Double;
  TFrameRequestCallback = reference to procedure (aTime: TJSDOMHighResTimeStamp);

  TJSPostMessageOptions = class external name 'Object' (TJSObject)
    targetOrigin : string;
    transfer : TJSValueDynArray;
  end;

  TJSIdleCallbackOptions = class
  public
    timeout: Cardinal;
  end;

  TJSIdleDeadline = class external name 'IdleDeadline'
  private
    FDidTimeout: Boolean; external name 'didTimeout';
  public
    function timeRemaining: TJSDOMHighResTimeStamp;

    property didTimeout: Boolean read FDidTimeout;
  end;

  TJSCache = weborworker.TJSCache;
  TJSCacheStorage = weborworker.TJSCacheStorage;

  TJSWindowArray = Array of TJSWindow;
  TIdleCallbackProc = reference to procedure(idleDeadline: TJSIdleDeadline);

  { TJSWindow }

  TJSWindow = class external name 'Window' (TJSObject)
  Private
    FClosed: boolean; external name 'closed';
    FConsole : TJSConsole;  external name 'console';
    FCrypto: TJSCrypto; external name 'crypto';
    FDevicePixelRatio: Double; external name 'devicePixelRatio';
    FDocument: TJSDocument; external name 'document';
    FFrameElement: TJSElement; external name 'frameElement';
    FFrames: TJSWindowArray; external name 'frames';
    FHistory: TJSHistory; external name 'history';
    FIndexedDB: TJSIDBFactory; external name 'indexedDB';
    FInnerheight: NativeInt; external name 'innerHeight';
    FInnerWidth: NativeInt; external name 'innerWidth';
    FLength: NativeInt; external name 'length';
    FLocalStorage: TJSStorage; external name 'localStorage';
    FLocation: TJSLocation; external name 'location';
    FLocationBar: TJSLocationBar; external name 'locationbar';
    FLocationString: string; external name 'location';
    FMenuBar: TJSMenuBar; external name 'menubar';
    FNavigator: TJSNavigator; external name 'navigator';
    FOpener: TJSWindow; external name 'opener';
    FOuterheight: NativeInt; external name 'outerHeight';
    FOuterWidth: NativeInt; external name 'outerWidth';
    FParent: TJSWindow; external name 'parent';
    FPerformance: TJSPerformance; external name 'Performance';
    FPersonalBar: TJSPersonalBar; external name 'personalbar';
    FScreen: TJSScreen; external name 'screen';
    FScreenX: NativeInt; external name 'screenX';
    FScreenY: NativeInt; external name 'screenY';
    FScrollbar: TJSScrollBars; external name 'scrollbar';
    FScrollX: NativeInt; external name 'scrollX';
    FScrollY: NativeInt; external name 'scrollY';
    FSelf: TJSWindow; external name 'self';
    FSessionStorage: TJSStorage; external name 'sessionStorage';
    FToolBar: TJSToolBar; external name 'toolbar';
    FTop: TJSWindow; external name 'top';
    FURL: TJSURL; external name 'URL';
  Public
    fullSreen : Boolean;   
    name : string;
    status : string;
    onabort : TJSEventHandler;
    onafterprint : TJSEventHandler;
    onbeforeprint : TJSEventHandler;
    onbeforeinstallprompt : TJSEventHandler;
    onbeforeunloadprompt : TJSEventHandler;
    onblur : TJSEventHandler;
    onchange : TJSEventHandler;
    onclick: THTMLClickEventHandler;
    onclose : TJSEventHandler;
    oncontextmenu : TJSEventHandler;
    ondblclick : THTMLClickEventHandler;
    onerror : TJSErrorEventHandler;
    onfocus : TJSFocusEventhandler;
    onhashchange : TJSHashChangeEventhandler;
    oninput : TJSEventhandler;
    onkeydown : TJSKeyEventhandler;
    onkeypress : TJSKeyEventhandler;
    onkeyup : TJSKeyEventhandler;
    onlanguagechange : TJSEventhandler;
    onload : TJSEventhandler;
    onloadend : TJSLoadEventhandler;
    onloadstart : TJSLoadEventhandler;
    onmessage : TJSEventHandler;
    onmousedown : TJSMouseEventHandler;
    onmouseenter : TJSMouseEventHandler;
    onmouseleave : TJSMouseEventHandler;
    onmousemove : TJSMouseEventHandler;
    onmouseout : TJSMouseEventHandler;
    onmouseover : TJSMouseEventHandler;
    onmouseup : TJSMouseEventHandler;
    onmousewheel : TJSMouseEventHandler;
    onoffline : TJSEventHandler;
    ononline : TJSEventHandler;
    onpagehide : TJSPageTransitionEventHandler;
    onpageshow : TJSPageTransitionEventHandler;
    onpaint : TJSEventHandler;
    onpointercancel : TJSPointerEventHandler;
    onpointerdown : TJSPointerEventHandler;
    onpointerenter : TJSPointerEventHandler;
    onpointerleave : TJSPointerEventHandler;
    onpointermove : TJSPointerEventHandler;
    onpointerout : TJSPointerEventHandler;
    onpointerover : TJSPointerEventHandler;
    onpointerup : TJSPointerEventHandler;
    onpointerlockchange : TJSPointerEventHandler;
    onprogress : TJSProgressEventhandler;
    onpopstate : TJSPopStateEventHandler;
    onreset : TJSUIEventHandler;
    onresize : TJSUIEventHandler;
    onscroll : TJSUIEventHandler;
    onselect : TJSEventHandler;
    onselectionchange : TJSEventHandler;
    onstorage : TJSStorageEventHandler;
    onsubmit : TJSEventHandler;
    onunload : TJSUIEventHandler;
    touchstart : TJSTouchEventHandler;
    touchend : TJSTouchEventHandler;
    touchmove : TJSTouchEventHandler;
    touchcancel : TJSTouchEventHandler;
    procedure addEventListener(aname : string; aListener : TJSEventHandler);
    procedure addEventListener(aname : string; aListener : TJSRawEventHandler);
    procedure addEventListener(aname : string; aListener : JSValue);
    Procedure alert(Const Msg : String);
    Function atob(Const aValue : string) : string;
    procedure blur;
    Procedure clearInterval(aID: NativeInt);
    Procedure clearTimeout(aID: NativeInt);
    Function btoa(Const aValue : string) : string;
    procedure cancelAnimationFrame(aHandle: Integer);
    Procedure close;
    Function confirm(Const aMsg : String) :  boolean;
    function fetch(resource: String; init: TJSObject): TJSPromise; overload; external name 'fetch';
    //function fetch(resource: String): TJSPromise; overload; external name 'fetch';
    function fetch(resource: String): TJSResponse; {$IFNDEF SkipAsync}async;{$ENDIF} overload; external name 'fetch';
    function fetch(resource: TJSObject; init: TJSObject): TJSPromise; overload; external name 'fetch';
    function fetch(resource: TJSObject): TJSPromise; overload; external name 'fetch';
    function asyncfetch(resource: String): TJSResponse; {$IFNDEF SkipAsync}async;{$ENDIF} overload; external name 'fetch';
    function asyncfetch(resource: TJSObject; init: TJSObject): TJSResponse; {$IFNDEF SkipAsync} async;{$ENDIF} overload; external name 'fetch';
    function asyncfetch(resource: TJSObject): TJSResponse;  {$IFNDEF SkipAsync}async;{$ENDIF}  overload;external name 'fetch';
    procedure focus;
    Function getComputedStyle(aElement : TJSElement) : TJSCSSStyleDeclaration; overload;
    Function getComputedStyle(aElement,aPseudoElement : TJSElement) : TJSCSSStyleDeclaration; overload;
    function getSelection : TJSSelection;
    function matchMedia(aQuery : String) : TJSMediaQueryList;
    procedure moveBy(x,y : NativeInt);
    procedure moveTo(x,y : NativeInt);
    function open : TJSWindow;
    function open(Const aURL : String) : TJSWindow; overload;
    function open(Const aURL,aTarget : String) : TJSWindow; overload;
    function open(Const aURL,aTarget : String; AOptions : TJSObject) : TJSWindow; overload;
    procedure postMessage(aMessage : JSValue);
    procedure postMessage(aMessage : JSValue; aOptions : TJSPostMessageOptions);
    procedure postMessage(aMessage : JSValue; aTransfer : TJSValueDynArray);
    procedure postMessage(aMessage : JSValue; aTarget : string);
    procedure postMessage(aMessage : JSValue; aTarget : string; aTransfer : TJSValueDynArray);
    procedure print;
    function prompt(const aMessage : String) : String; overload;
    function prompt(const aMessage,aDefault : String) : String; overload;
    procedure removeEventListener(aname : string; aListener : TJSEventHandler);
    procedure removeEventListener(aname : string; aListener : JSValue);
    function requestAnimationFrame(aCallback: TFrameRequestCallback): Integer;
    procedure resizeBy(aWidth,aHeight : NativeInt);
    procedure resizeTo(aWidth,aHeight : NativeInt);
    procedure scrollBy(x,y : NativeInt);
    procedure scrollTo(x,y : NativeInt);
    Function setInterval(ahandler : TJSTimerCallBack; aInterval : NativeUInt) : NativeInt; varargs;
    Function setTimeout(ahandler : TJSTimerCallBack; aTimeout : NativeUInt) : NativeInt; varargs;
    Function setTimeout(ahandler : TJSTimerCallBack) : NativeInt;
    procedure stop;
    procedure cancelIdleCallback(handle: NativeInt);
    function requestIdleCallback(handler: TIdleCallbackProc): NativeInt; overload;
    function requestIdleCallback(handler: TIdleCallbackProc; options: TJSIdleCallbackOptions): NativeInt; overload;
    function showOpenFilePicker: TJSFileSystemFileHandleArray; async; overload;
    function showOpenFilePicker(options: TJSShowOpenFilePickerOptions): TJSFileSystemFileHandleArray; async; overload;
    function showSaveFilePicker: TJSFileSystemFileHandle; async; overload;
    function showSaveFilePicker(options: TJSShowSaveFilePickerOptions): TJSFileSystemFileHandle; async; overload;
    function FileSystemDirectoryHandle: TJSFileSystemDirectoryHandleArray; async;
    { public properties }
    property console : TJSConsole Read FConsole;
    property closed : boolean read FClosed;
    property crypto : TJSCrypto Read FCrypto;
    property devicePixelRatio : Double read FDevicePixelRatio;
    property document : TJSDocument read FDocument;
    property frameElement : TJSElement Read FFrameElement;
    Property frames  : TJSWindowArray read FFrames;
    Property history : TJSHistory read FHistory;
    Property indexedDB : TJSIDBFactory read FIndexedDB;
    Property innerHeight : NativeInt Read FInnerheight;
    Property innerWidth : NativeInt Read FInnerWidth;
    Property length : NativeInt Read FLength;
    Property localStorage : TJSStorage Read FLocalStorage;
    property location : TJSLocation Read FLocation;
    Property locationString : String read FLocationString write FLocationString;
    property locationbar : TJSLocationBar Read FLocationBar;
    property menubar : TJSMenuBar Read FMenuBar;
    property navigator : TJSNavigator Read FNavigator;
    property opener : TJSWindow read FOpener;
    Property outerHeight : NativeInt Read FOuterheight;
    Property outerWidth : NativeInt Read FOuterWidth;
    Property parent : TJSWindow Read FParent;
    Property Performance : TJSPerformance Read FPerformance;
    property personalbar : TJSPersonalBar Read FPersonalBar;
    property screen : TJSScreen read FScreen;
    property screenX : NativeInt read FScreenX;
    Property screenY : NativeInt read FScreenY;
    Property scrollbar : TJSScrollBars Read FScrollbar;
    property scrollX : NativeInt read FScrollX;
    Property scrollY : NativeInt read FScrollY;
    Property _Self : TJSWindow read FSelf;
    Property sessionStorage : TJSStorage Read FSessionStorage;
    property toolbar : TJSToolBar Read FToolBar;
    property top : TJSWindow Read FTop;
    property URL : TJSURL Read FURL;
  end;

  { TJSCSSStyleDeclaration }

  TJSCSSStyleDeclaration = class external name 'CSSStyleDeclaration'  (TJSObject)
  private
    FLength: NativeInt; external name 'length';
    FParentRule: TJSCSSRule; external name 'parentRule';
  public
    cssText : string;
    function item(aIndex : Integer) : string;
    function removeProperty(const aProperty : String) : string;
    function getPropertyPriority(const aProperty : String) : string;
    function getPropertyValue(const aProperty : String) : string;
    procedure setProperty(const aProperty,aValue : String);overload;
    procedure setProperty(const aProperty,aValue,aPriority : string); overload;
    property length : NativeInt read FLength;
    property parentRule : TJSCSSRule read FParentRule;
  end;

  TJSScrollIntoViewOptions = class external name 'Object'  (TJSObject)
    behaviour : string;
    block : string;
    inline_ : string; external name 'inline';
  end;


  { TJSHTMLElement }

  TJSDatasetMap = class external name 'Object' (TJSObject)
  Private
    function GetProps(Name: String): String; external name '[]';
    procedure SetProps(Name: String; const AValue: String); external name '[]';
  Public
    property Map[Name: String]: string read GetProps write SetProps; default;
  end;

  TJSHTMLElement = class external name 'HTMLElement' (TJSElement)
  private
    FDataset: TJSDatasetMap ; external name 'dataset';
    FDatasetObj: TJSObject ; external name 'dataset';
    FIsContentEditable: Boolean ; external name 'isContentEditable';
    FOffsetHeight: Double; external name 'offsetHeight';
    FOffsetLeft: Double; external name 'offsetLeft';
    FOffsetParent: TJSElement; external name 'offsetParent';
    FOffsetTop: Double; external name 'offsetTop';
    FOffsetWidth: Double; external name 'offsetWidth';
  Public
    accessKey : string;
    contentEditable : string;
    dir : string;
    draggable : boolean;
    hidden : boolean;
    lang : string;
    spellcheck : boolean;
    style : TJSCSSStyleDeclaration;
    tabIndex : Integer;
    title: string;
    onabort : TJSEventHandler;
    onanimationcancel: THTMLAnimationEventHandler;
    onanimationend: THTMLAnimationEventHandler;
    onblur : TJSEventHandler;
    oncancel : TJSEventHandler;
    oncanplay : TJSEventHandler;
    oncanplaythrough : TJSEventHandler;
    onchange : TJSEventHandler;
    onclick: THTMLClickEventHandler;
    onclose : TJSEventHandler;
    oncontextmenu : TJSEventHandler;
    ondblclick : THTMLClickEventHandler;
    ondrag : TJSDragDropEventHandler;
    ondragend : TJSDragDropEventHandler;
    ondragenter : TJSDragDropEventHandler;
    ondragexit : TJSDragDropEventHandler;
    ondragover : TJSDragDropEventHandler;
    ondragleave : TJSDragDropEventHandler;
    ondragstart: TJSDragDropEventHandler;
    ondrop : TJSDragDropEventHandler;
    onerror : TJSErrorEventHandler;
    onfocus : TJSFocusEventhandler;
    ondurationchange : TJSEventHandler;
    onemptied : TJSEventHandler;
    onended : TJSEventHandler;
    ongotpointercapture : TJSPointerEventHandler;
    oninput : TJSEventhandler;
    oninvalid : TJSEventhandler;
    onkeydown : TJSKeyEventhandler;
    onkeypress : TJSKeyEventhandler;
    onkeyup : TJSKeyEventhandler;
    onload : TJSEventhandler;
    onloadeddata : TJSEventhandler;
    onloadedmetadata : TJSEventhandler;
    onloadend : TJSLoadEventhandler;
    onloadstart : TJSLoadEventhandler;
    onlostpointercapture : TJSPointerEventHandler;
    onmousedown : TJSMouseEventHandler;
    onmouseenter : TJSMouseEventHandler;
    onmouseleave : TJSMouseEventHandler;
    onmousemove : TJSMouseEventHandler;
    onmouseout : TJSMouseEventHandler;
    onmouseover : TJSMouseEventHandler;
    onmouseup : TJSMouseEventHandler;
    onmousewheel : TJSMouseEventHandler;
    onpause : TJSPointerEventHandler;
    onplay : TJSPointerEventHandler;
    onplaying : TJSPointerEventHandler;
    onpointercancel : TJSPointerEventHandler;
    onpointerdown : TJSPointerEventHandler;
    onpointerenter : TJSPointerEventHandler;
    onpointerleave : TJSPointerEventHandler;
    onpointermove : TJSPointerEventHandler;
    onpointerout : TJSPointerEventHandler;
    onpointerover : TJSPointerEventHandler;
    onpointerup : TJSPointerEventHandler;
    onpointerlockchange : TJSPointerEventHandler;
    onprogress : TJSProgressEventhandler;
    onseeked : TJSEventHandler;
    onseeking : TJSEventHandler;
    onreset : TJSUIEventHandler;
    onscroll : TJSUIEventHandler;
    onselect : TJSEventHandler;
    onselectstart : TJSEventHandler;
    onselectionchange : TJSEventHandler;
    onshow : TJSEventHandler;
    onstalled : TJSEventHandler;
    ontimeupdate : TJSEventHandler;
    ontouchstart: TJSTouchEventHandler;
    ontouchmove: TJSTouchEventHandler;
    ontouchcancel: TJSTouchEventHandler;
    ontouchend: TJSTouchEventHandler;
    ontransitioncancel : TJSEventHandler;
    ontransitionend : TJSEventHandler;
    onvolumechange : TJSEventHandler;
    onsubmit : TJSEventHandler;
    onwheel : TJSMouseWheelEventHandler;
    onwaiting : TJSEventHandler;
    touchstart : TJSTouchEventHandler;
    touchend : TJSTouchEventHandler;
    touchmove : TJSTouchEventHandler;
    touchcancel : TJSTouchEventHandler;
    Procedure blur;
    Procedure focus;
    Procedure click;
    procedure scrollIntoView; overload;
    procedure scrollIntoView(alignToTop : Boolean);
    procedure scrollIntoView(aObj : TJSObject);
    procedure scrollIntoView(Opts: TJSScrollIntoViewOptions);
    property dataset : TJSDatasetMap read FDataset;
    property datasetObj : TJSObject read FDatasetObj;
    property isContentEditable : Boolean read FIsContentEditable;
    property offsetHeight : Double Read FOffsetHeight;
    property offsetLeft : Double Read FOffsetLeft;
    property offsetTop : Double Read FOffsetTop;
    property offsetWidth : Double Read FOffsetWidth;
    property offsetParent : TJSElement Read FOffsetParent;
  end;
  TJSHTMLElementArray = Array of TJSHTMLElement;

  TJSHTMLDivElement = class external name 'HTMLDivElement' (TJSHTMLElement)
  end;

  TJSHTMLFormControlsCollection = class external name 'HTMLFormControlsCollection' (TJSHTMLCollection)
  Public
    function namedItem(S : String) : TJSElement; reintroduce; external name 'namedItem';
    property Items[S : String] : TJSElement read namedItem; default;
  end;

  { TJSHTMLFormElement }

  TJSHTMLFormElement = class external name 'HTMLFormElement' (TJSHTMLElement)
  private
    FElements: TJSHTMLFormControlsCollection; external name 'elements';
    FLength: NativeInt; external name 'length';
  Public
    Procedure reset;
    function reportValidity : Boolean;
    function checkValidity : Boolean;
    procedure requestSubmit;
    procedure requestSubmit(aElement : TJSHTMLElement);
    procedure submit;
    method : string;
    target : string;
    action : string;
    encoding : string;
    enctype : string;
    acceptCharset :  string;
    autocomplete : string;
    noValidate : boolean;
    property elements : TJSHTMLFormControlsCollection read FElements;
    Property length : NativeInt Read FLength;
  end;

  { TJSValidityState }

  TJSValidityState = class external name 'ValidityState'  (TJSObject)
  private
    FBadInput: Boolean; external name 'badInput';
    FCustomError: Boolean; external name 'customError';
    FPatternMismatch: Boolean; external name 'patternMisMatch';
    FRangeOverflow: Boolean; external name 'rangeOverflow';
    FRangeUnderflow: Boolean; external name 'rangeUnderflow';
    FStepMismatch: Boolean; external name 'stepMismatch';
    FTooLong: Boolean; external name 'tooLong';
    FTooShort: Boolean; external name 'tooShort';
    FTypeMismatch: Boolean; external name 'typeMisMatch';
    FValid: Boolean; external name 'valid';
    FValueMissing: Boolean; external name 'valueMissing';
  public
    property badInput : Boolean read FBadInput;
    property customError : Boolean read FCustomError;
    property patternMisMatch : Boolean read FPatternMismatch;
    property rangeOverflow : Boolean read FRangeOverflow;
    property rangeUnderflow : Boolean read FRangeUnderflow;
    property stepMismatch : Boolean read FStepMismatch;
    property tooLong : Boolean read FTooLong;
    property tooShort : Boolean read FTooShort;
    property typeMisMatch : Boolean read FTypeMismatch;
    property valid : Boolean Read FValid;
    property valueMissing : Boolean read FValueMissing;
  end;


  { TJSHTMLFile }

  TJSHTMLFile = class external name 'File' (TJSBlob)
  private
    FLastModified: NativeInt; external name 'lastModified';
    FLastModifiedDate: TJSDate; external name 'lastModifiedDate';
    FName: string; external name 'name';
  public
    constructor New(ABits: JSValue; AName: string); overload;
    constructor New(ABits: JSValue; AName: string; AOptions: TJSObject); overload;
    property lastModified: NativeInt read FLastModified;
    property lastModifiedDate : TJSDate read FLastModifiedDate; deprecated;
    property name: String read FName;
  end;

  { TJSHTMLFileList }

  TJSHTMLFileList = class external name 'FileList' (TJSEventTarget)
  private
    FLength: NativeInt; external name 'length';
  Public
    function item(aIndex : NativeInt) : TJSHTMLFile;
    property length : NativeInt read FLength;
    property Files[aIndex : NativeInt] : TJSHTMLFile Read item; default;
  end;

   { TJSHTMLInputElement }
  // https://html.spec.whatwg.org/multipage/forms.html#the-input-element

  TJSHTMLInputElement = class external name 'HTMLInputElement' (TJSHTMLElement)
  private
    FFiles: TJSHTMLFileList; external name 'files';
    FForm: TJSHTMLFormElement; external name 'form';
    FLabels: TJSNodeList; external name 'labels';
    FList: TJSHTMLElement; external name 'list';
    FValidationmMessage: string; external name 'validationMessage';
    FValidity: TJSValidityState; external name 'validity';
    FWillValidate: boolean; external name 'willValidate';
  Public
    procedure select;
    procedure setCustomValidity(aText : string);
    procedure stepUp; overload;
    procedure stepUp(n : Integer); overload;
    function checkValidity : Boolean;
    function reportValidity : Boolean;
    procedure setSelectionRange(selectionStart, selectionEnd: NativeInt) ; overload;
    procedure setSelectionRange(selectionStart, selectionEnd: NativeInt; Direction : string) ; overload;
    procedure setRangeText(aText : string; selectionStart, selectionEnd: NativeInt) ; overload;
    procedure setRangeText(aText : string; selectionStart, selectionEnd: NativeInt; Direction : string) ; overload;
  Public
    accept : string;
    allowDirs : boolean;
    align : string;
    alt : string;
    autofocus : boolean;
    autocapitalize : string;
    autocomplete : string;
    defaultValue : string;
    defaultChecked : string;
    checked : boolean;
    dirName : string;
    disabled : boolean;
    formAction : string;
    formEncType : string;
    formMethod : string;
    formNoValidate : Boolean;
    formTarget : string;
    height : string;
    indeterminate : boolean;
    inputMode : string;
    max : string;
    maxLength : NativeInt;
    min : string;
    minLength : NativeInt;
    multiple : boolean;
    pattern : string;
    placeholder : string;
    readOnly : boolean;
    required : boolean;
    size : NativeInt;
    src : string;
    step : string;
    _type : string; external name 'type';
    selectionStart : NativeInt;
    selectionEnd : NativeInt;
    selectionDirection : string;
    useMap : string;
    value : string;
    width : string;
    property files : TJSHTMLFileList Read FFiles;
    property form : TJSHTMLFormElement read FForm;
    property labels : TJSNodeList read FLabels;
    property list : TJSHTMLElement Read FList;
    property validationMessage : string read FValidationmMessage;
    property willValidate : boolean read FWillValidate;
    property validity : TJSValidityState read FValidity;
  end;

  TJSDOMSettableTokenList = class external name 'DOMSettableTokenList' (TJSDOMTokenList)
  private
    fvalue: TJSDOMString; external name 'value';
  public
    property value: TJSDOMString read fvalue; // readonly
  end;

  TJSHTMLOutputElement = class external name 'HTMLOutputElement' (TJSHTMLElement)
  private
    flabels: TJSNodeList; external name 'labels';
    fform: TJSHTMLFormElement; external name 'form';
    ftype: TJSDOMString; external name 'type';
    fdefaultValue: TJSDOMString; external name 'defaultValue';
    fvalue: TJSDOMString; external name 'value';
    fwillValidate: Boolean; external name 'willValidate';
    fvalidity: TJSValidityState; external name 'validity';
    fvalidationMessage: TJSDOMString; external name 'validationMessage';
  public
    htmlFor: TJSDOMSettableTokenList;
    function checkValidity: Boolean;
    function reportValidity: Boolean;
    procedure setCustomValidity(error: TJSDOMString);
  public
    property labels: TJSNodeList read flabels;
    property form: TJSHTMLFormElement read fform;
    property type_: TJSDOMString read ftype;
    property defaultValue: TJSDOMString read fdefaultValue;
    property value: TJSDOMString read fvalue write fvalue;
    property willValidate: Boolean read fwillValidate;
    property validity: TJSValidityState read fvalidity;
    property validationMessage: TJSDOMString read fvalidationMessage;
  end;

  { TJSHTMLImageElement }

  TJSHTMLImageElement = class external name 'Image' (TJSHTMLElement)
  Private
    FComplete: boolean; external name 'complete';
    FCurrentSrc: String; external name 'currentSrc';
    FNaturalHeight: NativeUInt; external name 'naturalHeight';
    FNaturalWidth: NativeUInt; external name 'naturalWidth';
    FX: NativeInt; external name 'x';
    FY: NativeInt; external name 'y';
  Public
    constructor New(x,y : Cardinal); overload;
    alt: String;
    crossOrigin: String;
    decoding: String;
    height: NativeUInt;
    isMap: boolean;
    referrerPolicy: String;
    src: String;
    sizes: String;
    srcset: String;
    useMap: String;
    width: NativeUInt;
    function decode : TJSPromise;
    property complete: boolean read FComplete;
    property currentSrc: String read FCurrentSrc;
    property naturalHeight: NativeUInt read FNaturalHeight;
    property naturalWidth: NativeUInt read FNaturalWidth;
    property x: NativeInt read FX;
    property y: NativeInt read FY;
  end;

  TJSHTMLLinkElement = class external name 'HTMLLinkElement'(TJSHTMLElement)
  Private
    frelList: TJSDOMTokenList; external name 'relList';
    fsizes: TJSDOMSettableTokenList {TJSDOMTokenList}; external name 'sizes';
  Public
    href: string;
    crossOrigin: string;
    rel: string;
    as_: string; external name 'as';
    media: string;
    integrity: string;
    hreflang: string;
    type_: string external name 'type';
    imageSrcset: string;
    imageSizes: string;
    referrerPolicy: string;
    disabled: string;
    charset: string deprecated; // obsolete
    rev: string deprecated; // obsolete property
    target: string deprecated; // obsolete property
    Property relList: TJSDOMTokenList read frelList;
    Property sizes: TJSDOMSettableTokenList{TJSDOMTokenList} read fsizes;
  end;

  { TJSHTMLAnchorElement }

  TJSHTMLAnchorElement = class external name 'HTMLAnchorElement' (TJSHTMLElement)
  Private
    FOrigin: string;external name 'origin';
    frelList: TJSDOMTokenList; external name 'relList';
  Public
    href: string;
    download: string;
    hash: string;
    host: string;
    hostname: string;
    hreflang: string;
    media: string ;
    password: string;
    Protocol: string;
    referrerPolicy : string;
    rel: string ;
    rev: string deprecated; // obsolete property
    target: string ;
    text : string;
    type_ : string external name 'type';
    username : string;
    Property relList: TJSDOMTokenList read frelList;
    Property origin: string Read FOrigin;
  end;

  { TJSHTMLMenuElement }

  TJSHTMLMenuElement = class external name 'HTMLMenuElement' (TJSHTMLElement) //  uhm... should it be declared? it is experimental at Mozilla docs...
  end;

  { TJSHTMLButtonElement }

  TJSHTMLButtonElement = class external name 'HTMLButtonElement' (TJSHTMLElement)
  private
    FForm: TJSHTMLFormElement; external name 'form';
    FLabels: TJSNodeList; external name 'labels';
    FValidationmMessage: String; external name 'validationMessage';
    FValidity: TJSValidityState; external name 'validity';
    FWillValidate: boolean; external name 'willValidate';
  Public
    autofocus : boolean;
    disabled : boolean;
    formAction : String;
    formEnctype : String;
    formMethod : String;
    formNoValidate : Boolean;
    formTarget : String;
    menu: TJSHTMLMenuElement;
    _type : String; external name 'type';
    value : string;
  Public
    property form : TJSHTMLFormElement Read FForm;
    property labels : TJSNodeList Read FLabels;
    property validationMessage : String Read FValidationmMessage;
    property validity : TJSValidityState Read FValidity;
    property willValidate : boolean read FWillValidate;
  end;

  TJSHTMLLabelElement = class external name 'HTMLLabelElement' (TJSHTMLElement)
  Private
    FForm: TJSHTMLFormElement; external name 'form';
    FControl : TJSHTMLElement; external name 'control';
  Public
    For_ : String; external name 'htmlFor';
    property Control : TJSHTMLElement Read FControl;
    property Form : TJSHTMLFormElement read FForm;
  end;

  { TJSHTMLTextAreaElement }

  TJSHTMLTextAreaElement = class external name 'HTMLTextAreaElement' (TJSHTMLElement)
  private
    FForm: TJSHTMLFormElement; external name 'form';
    FTextLength: NativeInt; external name 'textKength';
    FType: String; external name 'type';
    FValidationMessage: String; external name 'validationMessage';
    FValidity: TJSValidityState;  external name 'validity';
    FWillValidate: boolean; external name 'willValidate';
  Public
    defaultValue : string;
    value : string;
    rows : cardinal;
    cols : cardinal;
    autofocus : boolean;
    disabled : boolean;
    maxLength : nativeInt;
    placeholder: String;
    readOnly : Boolean;
    required : Boolean;
    selectionStart : Cardinal;
    selectionEnd : Cardinal;
    selectionDirection : String;
    wrap : string;
    Property Form : TJSHTMLFormElement Read FForm;
    Property Type_: String Read FType;
    Property textLength : NativeInt Read FTextLength;
    Property validity : TJSValidityState Read FValidity;
    property willValidate : boolean read FWillValidate;
    property validationMessage : String Read FValidationMessage;
  end;

  { TJSHTMLEmbedElement }

  TJSHTMLEmbedElement = class external name 'HTMLEmbedElement' (TJSHTMLElement)
  Public
    height: String;
    src: String;
    _type : String; external name 'type';
    width: String;
  end;

  { TJSHTMLOptionElement }

  TJSHTMLOptionElement = class external name 'Option' (TJSHTMLElement)
  private
    FForm: TJSHTMLFormElement; external name 'form';
    FIndex: NativeInt; external name 'index';
  Public
    Constructor New; overload;
    Constructor New(aText : String); overload;
    Constructor New(aText,aValue : String); overload;
    Constructor New(aText,aValue : String; aDefaultSelected : Boolean); overload;
    Constructor New(aText,aValue : String; aDefaultSelected,Selected : Boolean); overload;
  Public
    defaultSelected : boolean;
    disabled : boolean;
    _label : string ; external name 'label';
    selected : boolean;
    text : string;
    value : string;
    property index : NativeInt Read FIndex;
    property form : TJSHTMLFormElement Read FForm;
  end;

  TJSHTMLOptGroupElement = class external name 'HTMLOptGroupElement' (TJSHTMLElement)
  end;

  TJSHTMLOptionsCollection = class external name 'HTMLOptionsCollection' (TJSHTMLCollection)
  end;

  { TJSHTMLSelectElement }

  TJSHTMLSelectElement = Class external name 'HTMLSelectElement' (TJSHTMLElement)
  private
    FForm: TJSHTMLFormElement; external name 'form';
    FLabels: TJSNodeList; external name 'labels';
    FLength: NativeInt; external name 'length';
    FOptions: TJSHTMLOptionsCollection; external name 'options';
    FSelectedOptions: TJSHTMLCollection; external name 'selectedOptions';
    FType: String; external name 'type';
    FValidationMessage: string; external name 'validationMessage';
    FValidity: TJSValidityState; external name 'validity';
    fwillValidate: Boolean; external name 'willValidate';
  Public
    Procedure add(anItem : TJSHTMLOptionElement); overload;
    Procedure add(anItem, before : TJSHTMLOptionElement); overload;
    function item(aIndex : NativeInt): TJSHTMLOptionElement;
    function namedItem(aName : String): TJSHTMLOptionElement;
    procedure remove(aIndex : NativeInt); overload;
    procedure checkValidity;
    procedure setCustomValidity(aMessage : String);
  Public
    autofocus : Boolean;
    disabled : Boolean;
    multiple : boolean;
    required: boolean;
    selectedIndex : NativeInt;
    size : NativeInt;
    value : string;
    property length : NativeInt read FLength;
    Property options : TJSHTMLOptionsCollection read FOptions;
    Property selectedOptions : TJSHTMLCollection read FSelectedOptions;
    Property form : TJSHTMLFormElement read FForm;
    property labels : TJSNodeList Read FLabels;
    property _type : String Read FType;
    property validity : TJSValidityState Read FValidity;
    property validationMessage : string Read FValidationMessage;
    property willValidate : Boolean read fwillValidate;
  end;

  { TJSHTMLTableElement }

  TJSHTMLTableSectionElement = class;
  TJSHTMLTableRowElement = class;

  TJSHTMLTableElement = Class external name 'HTMLTableElement'(TJSHTMLElement)
  private
    FAlign: String; external name 'align';
    FBGColor: String; external name 'bgColor';
    FBorder: String; external name 'border';
    FCaption: TJSHTMLElement; external name 'caption';
    FCellPadding: String; external name 'cellPadding';
    FCellSpacing: String; external name 'cellSpacing';
    FFrame: String; external name 'frame';
    FRows: TJSHTMLCollection; external name 'rows';
    FRules: String; external name 'rules';
    FSummary: String; external name 'summary';
    FTBodies: TJSHTMLCollection; external name 'tBodies';
    FTfoot: TJSHTMLTableSectionElement; external name 'tfoot';
    FTHead: TJSHTMLTableSectionElement; external name 'tHead';
    FWidth: String; external name 'width';
  public
  { Methods }
    function createCaption: TJSHTMLElement;
    function createTFoot: TJSHTMLTableSectionElement;
    function createTHead: TJSHTMLTableSectionElement;
    procedure deleteCaption;
    procedure deleteRow(index: Integer);
    procedure deleteTFoot;
    procedure deleteTHead;
    function insertRow(index: Integer): TJSHTMLTableRowElement;
  { Properties }
    property align: String read FAlign write FAlign;
    property bgColor: String read FBGColor write FBGColor;
    property border: String read FBorder write FBorder;
    property caption: TJSHTMLElement read FCaption;
    property cellPadding: String read FCellPadding write FCellPadding;
    property cellSpacing: String read FCellSpacing write FCellSpacing;
    property frame: String read FFrame write FFrame;
    property rows: TJSHTMLCollection read FRows;
    property rules: String read FRules write FRules;
    property summary: String read FSummary write FSummary;
    property tBodies: TJSHTMLCollection read FTBodies;
    property tfoot: TJSHTMLTableSectionElement read FTfoot;
    property tHead: TJSHTMLTableSectionElement read FTHead;
    property width: String read FWidth write FWidth;
  end;

  { TJSHTMLTableSectionElement }

  TJSHTMLTableSectionElement = Class external name 'HTMLTableSectionElement' (TJSHTMLElement)
  private
    Falign: String; external name 'align';
    Frows: TJSHTMLCollection external name 'rows';
    Fch: String; external name 'ch';
    FchOff: String; external name 'chOff';
    FvAlign: String; external name 'vAlign';
  public
  { Methods }
    procedure deleteRow(index: Integer);
    function insertRow(index: Integer): TJSHTMLTableRowElement;
  { Properties }
    property align: String read Falign write Falign;
    property rows: TJSHTMLCollection read Frows;
    property ch: String read Fch write Fch;
    property chOff: String read FchOff write FchOff;
    property vAlign: String read FvAlign write FvAlign;
  end;

  { TJSHTMLTableCellElement }

  TJSHTMLTableCellElement = Class external name 'HTMLTableCellElement' (TJSHTMLElement)
  private
    Fabbr: String; external name 'abbr';
    Falign: String; external name 'align';
    Faxis: String; external name 'axis';
    FbgColor: String; external name 'bgColor';
    FcellIndex: Integer; external name 'cellIndex';
    Fch: String; external name 'ch';
    FchOff: String; external name 'chOff';
    FcolSpan: Integer; external name 'colSpan';
    Fheaders: String; external name 'headers';
    Fheight: String; external name 'height';
    FnoWrap: Boolean; external name 'noWrap';
    FrowSpan: Integer; external name 'rowSpan';
    Fscope: String; external name 'scope';
    FvAlign: String; external name 'vAlign';
    Fwidth: String; external name 'width';
  public
  { Properties }
    property abbr: String read Fabbr write Fabbr;
    property align: String read Falign write Falign;
    property axis: String read Faxis write Faxis;
    property bgColor: String read FbgColor write FbgColor;
    property cellIndex: Integer read FcellIndex;
    property ch: String read Fch write Fch;
    property chOff: String read FchOff write FchOff;
    property colSpan: Integer read FcolSpan write FcolSpan;
    property headers: String read Fheaders;
    property height: String read Fheight write Fheight;
    property noWrap: Boolean read FnoWrap write FnoWrap;
    property rowSpan: Integer read FrowSpan write FrowSpan;
    property scope: String read Fscope write Fscope;
    property vAlign: String read FvAlign write FvAlign;
    property width: String read Fwidth write Fwidth;
  end;

  { TJSHTMLTableRowElement }

  TJSHTMLTableRowElement = Class external name 'HTMLTableRowElement' (TJSHTMLElement)
  private
    Falign: String; external name 'align';
    FbgColor: String; external name 'bgColor';
    Fcells: TJSHTMLCollection; external name 'cells';
    Fch: String; external name 'ch';
    FchOff: String; external name 'chOff';
    FrowIndex: Integer; external name 'rowIndex';
    FsectionRowIndex: Integer; external name 'sectionRowIndex';
    FvAlign: String; external name 'vAlign';
  public
  { Methods }
    procedure deleteCell(index: Integer);
    function insertCell(index: Integer): TJSHTMLTableCellElement;
  { Properties }
    property align: String read Falign write Falign;
    property bgColor: String read FbgColor write FbgColor;
    property cells: TJSHTMLCollection read Fcells;
    property ch: String read Fch write Fch;
    property chOff: String read FchOff write FchOff;
    property rowIndex: Integer read FrowIndex;
    property sectionRowIndex: Integer read FsectionRowIndex;
    property vAlign: String read FvAlign write FvAlign;
  end;

  { TJSHTMLTableDataCellElement }

  TJSHTMLTableDataCellElement = Class external name 'HTMLTableDataCellElement' (TJSHTMLElement)
  private
    Fabbr: String; external name 'abbr';
  public
  { Properties }
    property abbr: String read Fabbr write Fabbr;
  end;


  TJSCanvasRenderingContext2D = Class;

  THTMLCanvasToBlobCallback = Reference to function (aBlob : TJSBlob) : boolean; safecall;

  TJSHTMLCanvasElement = Class external name 'HTMLCanvasElement' (TJSHTMLElement)
  Public
    height : integer;
    width : integer;
    Function getContext(contextType : string) : TJSObject;
    Function getContext(contextType : string; contextAttributes : TJSObject) : TJSObject;
    Function getContextAs2DContext(contextType : string; contextAttributes : TJSObject) : TJSCanvasRenderingContext2D; external name 'getContext';
    Function getContextAs2DContext(contextType : string) : TJSCanvasRenderingContext2D; external name 'getContext';
    Procedure toBlob (aCallBack : THTMLCanvasToBlobCallback; aMimeType : String); overload;
    Procedure toBlob (aCallBack : THTMLCanvasToBlobCallback; aMimeType : String; aQuality : Double); overload;
    Function toDataURL : String; overload;
    Function toDataURL(aMimeType : String) : String; overload;
    Function toDataURL(aMimeType : String; aQuality : Double) : String; overload;
  end;
  


  TJSHTMLProgressElement = class external name 'HTMLProgressElement' (TJSHTMLElement)
  private
    Fposition: Double; external name 'position';
    Flabels: TJSNodeList; external name 'labels';
  public
    max: Double;
    value: Double;
    property position: Double read Fposition;
    property labels: TJSNodeList read Flabels;
  end;
  Type

  { TJSDOMException }

  TJSDOMException = class external name 'DOMException' (TJSObject)
  private
    FCode: Integer; external name 'code';
    FMessage: String; external name 'message';
    FName: string; external name 'name';
  Public
    Property code : Integer Read FCode;
    Property Message : String Read FMessage;
    Property name : string Read FName;
  end;

  { TJSFileReader }

  TJSFileReader = class external name 'FileReader' (TJSEventTarget)
  private
    FError: TJSDOMException; external name 'error';
    fReadyState: Integer; external name 'readyState';
    FResult: JSValue; external name 'result';
  Public
    Const EMPTY : Integer;
    Const LOADING : Integer;
    Const DONE : Integer;
  Public
    onabort : TJSEventHandler;
    onerror : TJSEventHandler;
    onload : TJSEventHandler;
    onloadstart : TJSEventHandler;
    onloadend : TJSEventHandler;
    onprogress : TJSEventHandler;
  Public
    constructor new;
    Procedure abort;
    procedure readAsArrayBuffer(Blob: TJSBlob);
    procedure readAsBinaryString(Blob: TJSBlob);
    procedure readAsDataURL(Blob: TJSBlob);
    procedure readAsText(Blob: TJSBlob; encoding : string);
    procedure readAsText(Blob: TJSBlob);
    property Error : TJSDOMException read FError;
    Property readyState : Integer Read fReadyState;
    property Result : JSValue Read FResult;
  end;

  TCanvasCoordType = double; // Is in fact a number.

  // Opaque objects
  TJSCanvasGradient = class external name 'CanvasGradient'  (TJSObject)
  end;

  TJSCanvasPattern = class external name 'CanvasPattern'  (TJSObject)
  end;

  TJSPath2D = class external name 'Path2D'  (TJSObject)
  Public
    constructor new; overload;
    constructor new(aPath : TJSPath2D); overload;
    constructor new(SVGPath : String); overload;
    Procedure addPath(aPath : TJSPath2D);
    procedure arc(x,y, radius,startAngle,endAngle : TCanvasCoordType); overload;
    procedure arc(x,y, radius,startAngle,endAngle : TCanvasCoordType; antiClockWise : boolean); overload;
    procedure arcTo(x1,y1,x2,y2,radius : TCanvasCoordType); overload;
    procedure bezierCurveTo(cp1x,cp1y,cp2x,cp2y,x,y : TCanvasCoordType); overload;
    Procedure closePath;
    procedure ellipse(x, y, radiusX, radiusY : TCanvasCoordType; rotation, startAngle, endAngle : Double); overload;
    procedure ellipse(x, y, radiusX, radiusY : TCanvasCoordType; rotation, startAngle, endAngle : Double; anticlockwise : Boolean); overload;
    Procedure lineTo(X,Y : TCanvasCoordType);
    Procedure moveTo(X,Y : TCanvasCoordType);
    procedure quadraticCurveTo(cpx,cpy,x,y : TCanvasCoordType);
    procedure rect(x,y,awidth,aheight: TCanvasCoordType); overload;
  end;

  { TJSImageData }

  TJSImageData = class external name 'ImageData'  (TJSObject)
  private
    FData: TJSUint8ClampedArray; external name 'data';
    FHeight: Integer; external name 'height';
    FWidth: Integer; external name 'width';
  Public
    constructor new(awidth,aheight : integer); overload;
    constructor new(anArray :TJSUint8ClampedArray; awidth,aheight : integer); overload;
    property data : TJSUint8ClampedArray read FData;
    property height : Integer Read FHeight;
    property width : Integer Read FWidth;
  end;


  TJSTextMetrics = class external name 'TextMetrics' (TJSObject)
    width : TCanvasCoordType;
    actualBoundingBoxLeft : TCanvasCoordType;
    actualBoundingBoxRight : TCanvasCoordType;
    fontBoundingBoxAscent : TCanvasCoordType;
    fontBoundingBoxDescent : TCanvasCoordType;
    actualBoundingBoxAscent : TCanvasCoordType;
    actualBoundingBoxDescent : TCanvasCoordType;
    emHeightAscent : TCanvasCoordType;
    emHeightDescent : TCanvasCoordType;
    hangingBaseline : TCanvasCoordType;
    alphabeticBaseline : TCanvasCoordType;
    ideographicBaseline : TCanvasCoordType;
  end;

  { TJSCanvasRenderingContext2D }
  TJSCanvasRenderingContext2D = class external name 'CanvasRenderingContext2D'  (TJSObject)
  private
    FCanvas: TJSHTMLCanvasElement; external name 'canvas';
    FfillStyleColor: String; external name 'fillStyle';
    FfillStyleGradient: TJSCanvasGradient; external name 'fillStyle';
    FfillStylePattern: TJSCanvasPattern; external name 'fillStyle';
    FimageSmoothingEnabled: Boolean; external name 'imageSmoothingEnabled';
    FstrokeStyleColor: String; external name 'strokeStyle';
    FstrokeStyleGradient: TJSCanvasGradient; external name 'strokeStyle';
    FstrokeStylePattern: TJSCanvasPattern; external name 'strokeStyle';
  Public
    fillStyle : JSValue;
    font : string;
    globalAlpha : double;
    globalCompositeOperation : String;
    lineCap : string;
    lineDashOffset : Double;
    lineJoin : String;
    lineWidth : Double;
    miterLimit : Double;
    shadowBlur : Double;
    shadowColor : String;
    shadowOffsetX : Double;
    shadowOffsetY : Double;
    strokeStyle : JSValue;
    textAlign : String;
    textBaseline : String;
    procedure arc(x,y, radius,startAngle,endAngle : TCanvasCoordType); overload;
    procedure arc(x,y, radius,startAngle,endAngle : TCanvasCoordType; antiClockWise : boolean); overload;
    procedure arcTo(x1,y1,x2,y2,radius : TCanvasCoordType); overload;
    procedure beginPath;
    procedure bezierCurveTo(cp1x,cp1y,cp2x,cp2y,x,y : TCanvasCoordType); overload;
    procedure clearRect(x,y,width,height : TCanvasCoordType);
    procedure clip; overload;
    procedure clip(aFillRule : String); overload;
    procedure clip(aPath : TJSPath2D); overload;
    procedure closePath;
    function createImageData(aWidth,aHeight : Integer) : TJSImageData; overload;
    function createImageData(aImage : TJSImageData) : TJSImageData; overload;
    function createLinearGradient(x0,y0,x1,y1 : TCanvasCoordType) : TJSCanvasGradient;
    function createPattern(aImage : TJSObject; repetition : string) : TJSCanvasPattern;
    function createRadialGradient(x0,y0,r0,x1,y1,r1 : TCanvasCoordType) : TJSCanvasGradient;
    procedure drawFocusIfNeeded(aElement : TJSElement); overload;
    procedure drawFocusIfNeeded(aPath : TJSPath2D; aElement : TJSElement); overload;
    procedure drawImage(image : TJSObject; dx,dy : TCanvasCoordType); overload;
    procedure drawImage(image : TJSObject; dx,dy,dwidth,dheight : TCanvasCoordType); overload;
    procedure drawImage(image : TJSObject; sx,sy,sWidth,sHeight,dx,dy,dwidth,dheight : TCanvasCoordType); overload;
    procedure ellipse(x, y, radiusX, radiusY : TCanvasCoordType; rotation, startAngle, endAngle : Double); overload;
    procedure ellipse(x, y, radiusX, radiusY : TCanvasCoordType; rotation, startAngle, endAngle : Double; anticlockwise : Boolean); overload;
    procedure fill; overload;
    procedure fill(aRule : String); overload;
    procedure fill(aPath : TJSPath2D); overload;
    procedure fill(aPath : TJSPath2D;aRule : String); overload;
    procedure fillRect(x,y,awidth,aheight: TCanvasCoordType); overload;
    procedure fillText(aText : string; x,y : TCanvasCoordType); overload;
    procedure fillText(aText : string; x,y, aMaxWidth : TCanvasCoordType); overload;
    function getImageData(x,y,awidth,aheight: TCanvasCoordType) : TJSImageData; overload;
    function getLineDash : TJSArray;
    function isPointInPath(x,y : TCanvasCoordType) : Boolean; overload;
    function isPointInPath(x,y : TCanvasCoordType; aFillRule : String) : Boolean; overload;
    function isPointInPath(aPath : TJSPath2D; x,y : TCanvasCoordType) : Boolean; overload;
    function isPointInPath(aPath : TJSPath2D; x,y : TCanvasCoordType; aFillRule : String) : Boolean; overload;
    function isPointInStroke(x,y : TCanvasCoordType) : Boolean; overload;
    function isPointInStroke(aPath : TJSPath2D; x,y : TCanvasCoordType) : Boolean; overload;
    procedure lineTo(x,y : TCanvasCoordType);
    function measureText(S : String) : TJSTextMetrics;
    procedure moveTo(x,y : TCanvasCoordType);
    procedure putImageData(aData : TJSImageData; x,y: TCanvasCoordType) ; overload;
    procedure putImageData(aData : TJSImageData; x,y,dityX,dirtyY,dirtyWidth,dirtyHeight: TCanvasCoordType) ; overload;
    procedure quadraticCurveTo(cpx,cpy,x,y : TCanvasCoordType);
    procedure rect(x,y,awidth,aheight: TCanvasCoordType); overload;
    procedure restore;
    procedure rotate(anAngle : double);
    procedure save;
    procedure scale(x,y : double);
    procedure setLineDash(segments : TJSArray); overload;
    procedure setLineDash(segments : array of integer); overload;
    procedure setTransform(a,b,c,d,e,f : double);
    procedure stroke; overload;
    procedure stroke(aPath : TJSPath2D); overload;
    procedure strokeRect(x,y,awidth,aheight: TCanvasCoordType);
    procedure strokeText(aText : string; x,y : TCanvasCoordType); overload;
    procedure strokeText(aText : string; x,y, aMaxWidth : TCanvasCoordType); overload;
    procedure transform(a,b,c,d,e,f : double);
    procedure translate(x,y : TCanvasCoordType);

    property canvas : TJSHTMLCanvasElement Read FCanvas;
    property fillStyleAsColor : String Read FfillStyleColor Write FfillStyleColor;
    property fillStyleAsGradient : TJSCanvasGradient Read FfillStyleGradient Write FfillStyleGradient;
    property fillStyleAsPattern : TJSCanvasPattern Read FfillStylePattern Write FfillStylePattern;
    property imageSmoothingEnabled : Boolean Read FimageSmoothingEnabled Write FimageSmoothingEnabled;
    property strokeStyleAsColor : String Read FstrokeStyleColor Write FstrokeStyleColor;
    property strokeStyleAsGradient : TJSCanvasGradient Read FstrokeStyleGradient Write FstrokeStyleGradient;
    property strokeStyleAsPattern : TJSCanvasPattern Read FstrokeStylePattern Write FstrokeStylePattern;
  end;
  
  TJSImageBitmap = class external name 'ImageBitmap'  (TJSObject)
  public
    procedure    close();
  end;

  TJSOffscreenCanvasRenderingContext2D = class external name 'CanvasRenderingContext2D'  (TJSCanvasRenderingContext2D)
  private
  Public
     { subclassing TJSCanvasRenderingContext2D just in case some new methods are required}
  end;

  TJSHTMLOffscreenCanvasElement = Class external name 'OffscreenCanvas' (TJSHTMLCanvasElement)
  Public
    constructor New(x,y : Cardinal); overload;
    { getContextAs2DContext reintroduced here to return the subclassed context }
    Function getContextAs2DContext(contextType : string; contextAttributes : TJSObject) : TJSOffscreenCanvasRenderingContext2D; external name 'getContext'; reintroduce;
    Function getContextAs2DContext(contextType : string) : TJSOffscreenCanvasRenderingContext2D; external name 'getContext'; reintroduce;
    function transferToImageBitmap: TJSImageBitmap;
  end;
  

  { TJSHTMLIFrameElement }

  TJSHTMLIFrameElement = Class external name 'HTMLIFrameElement' (TJSHTMLElement)
  private
    FAllowPaymentRequest: Boolean; external name 'allowPaymentRequest';
    FContentDocument: TJSDocument; external name 'contentDocument';
    FContentWindow: TJSWindow; external name 'contentWindow';
    FSandbox: string; external name 'sandbox';
  Public
    height : string;
    src : string;
    srcdoc : string;
    width : string;
    Property allowPaymentRequest : Boolean Read FAllowPaymentRequest;
    property contentWindow : TJSWindow Read FContentWindow;
    property contentDocument : TJSDocument Read FContentDocument;
    property sandbox : string read FSandbox;
  end;

  TJSHTMLScriptElement = Class external name 'HTMLScriptElement' (TJSHTMLElement)
  Public
    type_ : String external name 'type';
    src : String;
    charset : string;
    integrity : string;
    async : boolean;
    defer : boolean;
    text : string;
    crossOrigin : string;
    referrerPolicy : string;
    noModule : boolean;
  end;




  TJSXMLHttpRequestEventTarget = class external name 'XMLHttpRequestEventTarget' (TJSEventTarget)
  end;

  TJSXMLHttpRequestUpload = class external name 'XMLHttpRequestUpload' (TJSXMLHttpRequestEventTarget)
  end;

  { TJSXMLHttpRequest }
  TJSOnReadyStateChangeHandler = reference to procedure; safecall;

  TJSXMLHttpRequest = class external name 'XMLHttpRequest' (TJSXMLHttpRequestEventTarget)
  private
    FReadyState: NativeInt; external name 'readyState';
    FResponse: JSValue; external name 'response';
    FResponseText: string; external name 'responseText';
    FResponseType: string; external name 'responseType';
    FresponseURL: string; external name 'responseURL';
    FresponseXML: TJSDocument; external name 'responseXML';
    FUpload: TJSXMLHttpRequestUpload; external name 'upload';
    FStatus : integer; external name 'status';
    FStatusText : string; external name 'statusText';
  public
    const
      UNSENT           = 0;
      OPENED           = 1;
      HEADERS_RECEIVED = 2;
      LOADING          = 3;
      DONE             = 4;
  public
    timeout : LongWord;
    withCredentials : Boolean;
    onreadystatechange : TJSOnReadyStateChangeHandler;
    constructor new;
    procedure abort;
    function getResponseHeader(aName : string) : String;
    function getAllResponseHeaders : String;
    procedure open(aMethod,aURL : String); overload;
    procedure open(aMethod,aURL : String; Async : Boolean); overload;
    procedure open(aMethod,aURL : String; Async : Boolean; AUserame : String); overload;
    procedure open(aMethod,aURL : String; Async : Boolean; AUserame,APassword : String); overload;
    procedure overrideMimeType(aType : String);
    procedure send(aBody : jsValue);overload;
    procedure send;overload;
    procedure setRequestHeader(aName, AValue : string);

    property readyState : NativeInt read FReadyState;
    property ResponseHeaders[aName : string] : string Read getResponseHeader;
    property responseXML : TJSDocument read FresponseXML;
    property responseURL : string read FresponseURL;
    property responseType : string read FResponseType Write FResponseType;
    property response : JSValue Read FResponse;
    property responseText : string read FResponseText;
    property Status : integer read FStatus;
    property StatusText : string read FStatusText;
    property upload : TJSXMLHttpRequestUpload read FUpload;

  end;

  { TJSUIEvent }

  TJSUIEvent = class external name 'UIEvent' (TJSEvent)
  private
    FDetail: NativeInt; external name 'detail';
    FView: TJSWindow; external name 'view';
  Public
    property detail : NativeInt read FDetail;
    property view : TJSWindow read FView;
  end;

  { TJSMouseEvent }

  TJSMouseEvent = class external name 'MouseEvent' (TJSUIEvent)
  private
    FAltKey: Boolean; external name 'altKey';
    FBUtton: NativeInt; external name 'button';
    FBUttons: NativeInt; external name 'buttons';
    FClientX: Double; external name 'clientX';
    FClientY: Double; external name 'clientY';
    FCtrlKey: Boolean; external name 'ctrlKey';
    FMetaKey: Boolean; external name 'metaKey';
    FmovementX: Double; external name 'movementX';
    FmovementY: Double; external name 'movementY';
    FoffsetX: Double; external name 'offsetX';
    FoffsetY: Double; external name 'offsetY';
    FRegion: String; external name 'region';
    FRelatedTarget: TJSEventTarget; external name 'relatedTarget';
    FscreenX: Double; external name 'screenX';
    FscreenY: Double; external name 'screenY';
    FShiftKey: Boolean; external name 'shiftKey';
  Public
    function getModifierState(keyArg: String): boolean;
    Property altKey : Boolean read FAltKey;
    Property button: NativeInt read FBUtton;
    Property buttons: NativeInt read FBUttons;
    property clientX : Double read FClientX;
    property clientY : Double read FClientY;
    property ctrlKey : Boolean read FCtrlKey;
    property metaKey : Boolean read FMetaKey;
    property movementX : Double read FmovementX;
    property movementY : Double read FmovementY;
    property offsetX : Double read FoffsetX;
    property offsetY : Double read FoffsetY;
{$IFDEF FIREFOX}
    property pageX : Double read FpageX;
    property pageY : Double read FpageY;
{$ENDIF}
    property region : String read FRegion;
    property relatedTarget : TJSEventTarget read FRelatedTarget;
    property screenX : Double read FscreenX;
    property screenY : Double read FscreenY;
    property shiftKey : Boolean read FShiftKey;
    property x : Double read FClientX;
    property y : Double read FClientY;
  end;

  { TJSWheelEvent }
  TJSWheelEventInit = record
    deltaX : Double;
    deltaY : Double;
    deltaZ : Double;
    deltaMode : NativeInt;
  end;

  TJSWheelEvent = class external name 'WheelEvent' (TJSMouseEvent)
  private
    FDeltaMode: NativeInt; external name 'deltaMode';
    FDeltaX: Double; external name 'deltaX';
    FDeltaY: Double; external name 'deltaY';
    FDeltaZ: Double; external name 'deltaZ';
  Public
    constructor new(atype : String); overload;
    constructor new(atype : String; aInit : TJSWheelEventInit); overload;
    Property deltaX : Double Read FDeltaX;
    Property deltaY : Double Read FDeltaY;
    Property deltaZ : Double Read FDeltaZ;
    Property deltaMode : NativeInt Read FDeltaMode;
  end;

  TJSPointerEvent = Class external name 'PointerEvent' (TJSMouseEvent);

  TJSTouchEvent = Class external name 'TouchEvent'(TJSUIEvent)
  private
    FAltKey: Boolean; external name 'altKey';
    FChangedTouches: TJSTouchList; external name 'changedTouches';
    FCtrlKey: Boolean; external name 'ctrlKey';
    FMetaKey: Boolean; external name 'metaKey';
    FShiftKey: Boolean; external name 'shiftKey';
    FTargetTouches: TJSTouchList; external name 'targetTouches';
    FTouches: TJSTouchList; external name 'touches';
  Public
    Property altKey : Boolean Read FAltKey;
    Property ctrlKey : Boolean Read FCtrlKey;
    Property metaKey : Boolean Read FMetaKey;
    Property shiftKey : Boolean Read FShiftKey;
    property changedTouches : TJSTouchList Read FChangedTouches;
    property touches : TJSTouchList Read FTouches;
    property targetTouches : TJSTouchList Read FTargetTouches;
  end;


  // Namespace for standard key names.
  // See list at https://developer.mozilla.org/en-US/docs/Web/API/KeyboardEvent/key/Key_Values
  TJSKeyNames = Class
  Const
    Alt = 'Alt';
    AltGraph = 'AltGraph';
    CapsLock = 'CapsLock';
    Control = 'Control';
    Fn = 'Fn';
    FnLock = 'FnLock';
    Hyper = 'Hyper';
    Meta = 'Meta';
    NumLock = 'NumLock';
    ScrollLock = 'ScrollLock';
    Shift = 'Shift';
    Super = 'Super';
    Symbol = 'Symbol';
    SymbolLock = 'SymbolLock';
    Enter = 'Enter';
    Tab = 'Tab';
    Space = 'Space';
    ArrowDown = 'ArrowDown';
    ArrowLeft = 'ArrowLeft';
    ArrowRight = 'ArrowRight';
    ArrowUp = 'ArrowUp';
    _End = 'End';
    Home = 'Home';
    PageDown = 'PageDown';
    PageUp = 'PageUp';
    BackSpace = 'Backspace';
    Clear = 'Clear';
    Copy = 'Copy';
    CrSel = 'CrSel';
    Cut = 'Cut';
    Delete = 'Delete';
    EraseEof = 'EraseEof';
    ExSel = 'ExSel';
    Insert = 'Insert';
    Paste = 'Paste';
    Redo = 'Redo';
    Undo = 'Undo';
    Accept = 'Accept';
    Again = 'Again';
    Attn = 'Attn';
    Cancel = 'Cancel';
    ContextMenu = 'Contextmenu';
    Escape = 'Escape';
    Execute = 'Execute';
    Find = 'Find';
    Finish = 'Finish';
    Help = 'Help';
    Pause = 'Pause';
    Play = 'Play';
    Props = 'Props';
    Select = 'Select';
    ZoomIn = 'ZoomIn';
    ZoomOut = 'ZoomOut';
    BrightnessDown = 'BrightnessDown';
    BrightnessUp = 'BrightnessUp';
    Eject = 'Eject';
    LogOff = 'LogOff';
    Power = 'Power';
    PowerOff = 'PowerOff';
    PrintScreen = 'PrintScreen';
    Hibernate = 'Hibernate';
    Standby = 'Standby';
    WakeUp = 'WakeUp';
    AllCandidates = 'AllCandidates';
    Alphanumeric =  'Alphanumeric';
    CodeInput = 'CodeInput';
    Compose = 'Compose';
    Convert = 'Convert';
    Dead = 'Dead';
    FinalMode = 'FinalMode';
    GroupFirst = 'GroupFirst';
    GroupLast = 'GroupLast';
    GroupNext = 'GroupNext';
    GroupPrevious = 'GroupPrevious';
    ModelChange = 'ModelChange';
    NextCandidate = 'NextCandidate';
    NonConvert = 'NonConvert';
    PreviousCandidate = 'PreviousCandidate';
    Process = 'Process';
    SingleCandidate = 'SingleCandidate';
    HangulMode = 'HangulMode';
    HanjaMode = 'HanjaMode';
    JunjaMode = 'JunjaMode';
    Eisu = 'Eisu';
    Hankaku = 'Hankaku';
    Hiranga = 'Hiranga';
    HirangaKatakana = 'HirangaKatakana';
    KanaMode = 'KanaMode';
    Katakana = 'Katakana';
    Romaji = 'Romaji';
    Zenkaku = 'Zenkaku';
    ZenkakuHanaku = 'ZenkakuHanaku';
    F1 = 'F1';
    F2 = 'F2';
    F3 = 'F3';
    F4 = 'F4';
    F5 = 'F5';
    F6 = 'F6';
    F7 = 'F7';
    F8 = 'F8';
    F9 = 'F9';
    F10 = 'F10';
    F11 = 'F11';
    F12 = 'F12';
    F13 = 'F13';
    F14 = 'F14';
    F15 = 'F15';
    F16 = 'F16';
    F17 = 'F17';
    F18 = 'F18';
    F19 = 'F19';
    F20 = 'F20';
    Soft1 = 'Soft1';
    Soft2 = 'Soft2';
    Soft3 = 'Soft3';
    Soft4 = 'Soft4';
    Decimal = 'Decimal';
    Key11 = 'Key11';
    Key12 = 'Key12';
    Multiply = 'Multiply';
    Add = 'Add';
    NumClear = 'Clear';
    Divide = 'Divide';
    Subtract = 'Subtract';
    Separator = 'Separator';
    AppSwitch = 'AppSwitch';
    Call = 'Call';
    Camera = 'Camera';
    CameraFocus = 'CameraFocus';
    EndCall = 'EndCall';
    GoBack = 'GoBack';
    GoHome = 'GoHome';
    HeadsetHook = 'HeadsetHook';
    LastNumberRedial = 'LastNumberRedial';
    Notification = 'Notification';
    MannerMode = 'MannerMode';
    VoiceDial = 'VoiceDial';
    // TODO : Multimedia keys
    // TODO : Audio control keys
    // TODO : TV control keys
    // TODO : Media controller keys
    // TODO : Speech recognition keys
    // TODO : Document keys
    // TODO : Application selector keys
    // TODO : Browser Control keys
  end;


  { TJSKeyboardEvent }

  TJSKeyboardEvent = class external name 'KeyboardEvent' (TJSUIEvent)
  private
    FAltKey: Boolean; external name 'altKey';
    FCode: string; external name 'code';
    FCtrlKey: Boolean; external name 'ctrlKey';
    FIsComposing: Boolean;  external name 'isComposing';
    FKey: String; external name 'key';
    FLocale: string; external name 'locale';
    FLocation: NativeInt; external name 'location';
    FMetaKey: Boolean; external name 'metaKey';
    FRepeat: Boolean; external name 'repeat';
    FShiftKey: Boolean; external name 'shiftKey';
  Public
    function getModifierState(aKey : string) : Boolean;
    property code : string read FCode;
    Property altKey : Boolean read FAltKey;
    property ctrlKey : Boolean read FCtrlKey;
    property isComposing : Boolean read FIsComposing;
    property Key : String read FKey;
    property locale : string read FLocale;
    property location : NativeInt read FLocation;
    property metaKey : Boolean read FMetaKey;
    property _repeat : Boolean read FRepeat;
    property shiftKey : Boolean read FShiftKey;
  end;

  { MutationObserver }

  TJSMutationObserver = Class;

  TJSMutationRecord = record
    type_ : string;
    target : TJSNode;
    addedNodes : TJSNodeList;
    removedNodes : TJSNodeList;
    previousSibling : TJSNode;
    nextSibling : TJSNode;
    attributeName : String;
    attributeNamespace : String;
    oldValue : String;
  end;

  TJSMutationRecordArray = array of TJSMutationRecord;
  TJSMutationCallback = reference to procedure(mutations: TJSMutationRecordArray; observer: TJSMutationObserver); safecall;

  TJSMutationObserverInit = record
    attributes: boolean;
    attributeOldValue: boolean;
    characterData: boolean;
    characterDataOldValue: boolean;
    childList: boolean;
    subTree: boolean;
    attributeFilter: TJSArray;
  end;

  TJSMutationObserver = class external name 'MutationObserver' (TJSObject)
  public
    { constructor }
    constructor new(mutationCallback: TJSMutationCallback); overload;
    { public methods }
    procedure observe(target: TJSNode); overload;
    procedure observe(target: TJSNode; options: TJSMutationObserverInit); overload;
    procedure observe(target: TJSNode; options: TJSObject); overload;
    procedure disconnect;
    function takeRecords: TJSMutationRecordArray;
  end;


  { --------------------------------------------------------------------
    TJSWebSocket
    --------------------------------------------------------------------}



  TJSWebSocket = class external name 'WebSocket'  (TJSEventTarget)
  Private
    Furl : String; external name 'url';
    FreadyState : Cardinal; external name 'readyState';
    FbufferedAmount : NativeInt; external name 'bufferedAmount';
    Fextensions : String; external name 'extensions';
    Fprotocol : String; external name 'protocol';
  Public
    Const
      CONNECTING = 0;
      OPEN = 1;
      CLOSING = 2;
      CLOSED = 3;
  Public
    onopen : TJSEventHandler;
    onerror : TJSEventHandler;
    onclose : TJSEventHandler;
    onmessage : TJSEventHandler;
    binaryType : String;
    constructor new(url : String); overload;
    constructor new(url : String; protocol: String); overload;
    constructor new(url : String; protocols: array of String); overload;
    Procedure close; overload;
    Procedure close(code : Cardinal); overload;
    Procedure close(code : Cardinal; reason : String); overload;
    Procedure send(data : String);
    Procedure send(data : TJSBlob);
    Procedure send(data : TJSArrayBuffer);
    Procedure send(data : TJSTypedArray);
    Property url : String Read Furl;
    Property readyState : Cardinal Read FreadyState;
    Property bufferedAmount : NativeInt Read FbufferedAmount;
    Property extensions : String Read Fextensions;
    Property protocol : String Read Fprotocol;
  end;

  TJSHTMLAudioTrack = class external name 'AudioTrack' (TJSObject)
  end;

  TJSHTMLAudioTrackList = class external name 'AudioTrackList' (TJSObject)
    FLength : Integer; external name 'length';
    function getitem(aIndex : nativeInt) : TJSHTMLAudioTrack ; external name '[]';
  Public
    onaddtrack : TJSEventHandler;
    onchange : TJSEventHandler;
    onremovetrack : TJSEventHandler;
    Property Length : Integer Read FLength;
    Property tracks [aIndex : NativeInt] : TJSHTMLAudioTrack read Getitem;
  end;

  TJSHTMLVideoTrack = class external name 'VideoTrack' (TJSObject)
  end;

  TJSHTMLVideoTrackList = class external name 'VideoTrackList' (TJSObject)
    FLength : Integer; external name 'length';
    function getitem(aIndex : nativeInt) : TJSHTMLVideoTrack ; external name '[]';
  Public
    onaddtrack : TJSEventHandler;
    onchange : TJSEventHandler;
    onremovetrack : TJSEventHandler;
    Property Length : Integer Read FLength;
    Property tracks [aIndex : NativeInt] : TJSHTMLVideoTrack read Getitem;
  end;

  TJSHTMLTextTrack = class external name 'TextTrack' (TJSObject)
  end;

  TJSHTMLTextTrackList = class external name 'TextTrackList' (TJSObject)
    FLength : Integer; external name 'length';
    function getitem(aIndex : nativeInt) : TJSHTMLTextTrack ; external name '[]';
  Public
    onaddtrack : TJSEventHandler;
    onchange : TJSEventHandler;
    onremovetrack : TJSEventHandler;
    Property Length : Integer Read FLength;
    Property tracks [aIndex : NativeInt] : TJSHTMLTextTrack read Getitem;
  end;


  { TJSHTMLMediaElement }
  TJSMEdiaError = class external name 'MediaError' (TJSObject)
    code : NativeInt;
    message : string;
  end;

  TJSHTMLMediaStream = class external name 'MediaStream' (TJSObject);

  TJSHTMLMediaController = class external name 'MediaController' (TJSObject);

  TJSHTMLMediaElement = Class external name 'HTMLMediaElement' (TJSHTMLElement)
  private
    FAudioTracks: TJSHTMLAudioTrackList; external name 'audioTracks';
    FVideoTracks: TJSHTMLVideoTrackList; external name 'videoTracks';
    FTextTracks: TJSHTMLTextTrackList; external name 'textTracks';
    FControlsList: TJSDOMTokenList; external name 'controlslist';
    FCurrentSrc: String; external name 'currentSrc';
    FDuration: Double; external name 'duration';
    FEnded: Boolean;external name 'ended';
    FError: TJSMEdiaError; external name 'error';
    FNetworkState: NativeInt; external name 'networkState';
    FPaused: boolean; external name 'paused';
    FReadyState: NativeInt; external name 'readyState';
    FSeeking: boolean; external name 'seeking';
    FSinkID: string; external name 'sinkId';
  Public
    autoplay : Boolean;
    buffered : Boolean;
    controls : Boolean;
    controller : TJSHTMLMediaController;
    crossOrigin : String;
    currentTime : Double;
    defaultMuted : boolean;
    defaultPlaybackRate : Double;
    disableRemotePlayback : Boolean;
    loop : boolean;
    mediaGroup : string;
    muted : boolean;
    preload : string;
    preservesPitch : boolean;
    src : string;
    srcObject : TJSHTMLMediaStream;
    volume : double;
    onencrypted : TJSEventHandler;
    onwaitingforkey : TJSEventHandler;
    function canPlayType(aType : String) : String;
    Function captureStream : TJSHTMLMediaStream;
    Procedure play;
    Procedure load;
    Procedure pause;

    Property AudioTracks : TJSHTMLAudioTrackList Read FAudioTracks;
    Property Controlslist : TJSDOMTokenList Read FControlsList;
    Property CurrentSrc : String Read FCurrentSrc;
    Property Duration : Double read FDuration;
    Property Ended : Boolean read FEnded;
    Property Error : TJSMEdiaError read FError;
    property networkState : NativeInt read FNetworkState;
    property paused : boolean read FPaused;
    property readyState : NativeInt read FReadyState;
    property seeking : boolean read FSeeking;
    property sinkID : string read FSinkID;
    Property TextTracks : TJSHTMLTextTrackList Read FTextTracks;
    Property VideoTracks : TJSHTMLVideoTrackList Read FVideoTracks;
  end;

  TJSHTMLAudioElement = Class external name 'HTMLAudioElement' (TJSHTMLMediaElement)

  end;

  TJSHTMLVideoElement = Class external name 'HTMLVideoElement' (TJSHTMLMediaElement)
  end;

  { TJSHTMLStyleElement }

  TJSHTMLStyleElement = class external name 'HTMLStyleElement' (TJSHTMLElement)
  private
    FSheet: TJSStyleSheet; external name 'sheet';
  public
    media : string;
    type_ : string; external name 'style';
    disabled : boolean;
    property sheet : TJSStyleSheet read FSheet;
  end;


  TJSFormDataEntryValue = String;
  TJSFormDataEntryValueArray = Array of TJSFormDataEntryValue;

  TJSFormData = Class external name 'FormData' (TJSObject)
    constructor new;
    constructor new(aForm : TJSHTMLElement);
    Procedure append(const aName,aValue : String);
    Procedure append(const aName : String; aBlob : TJSBlob);
    Procedure delete(const aName : String);
    Function entries : TJSFormDataEntryValueArray;
    Function get(const aName : String): TJSFormDataEntryValue;
    function has(const aName : String): Boolean;
    Function keys : TStringDynArray; reintroduce;
    Procedure set_(const aName,aValue : String); external name 'set';
    Procedure set_(const aName : String; aBlob : TJSBlob); external name 'set';
    Function getAll(const aName : String) : TJSFormDataEntryValueArray;
    Function values : TJSValueDynArray; reintroduce;
    Property Entry[const aIndex : String] : TJSFormDataEntryValue read Get;
  end;

  TJSHTMLTemplateElement = class external name 'HTMLTemplateElement' (TJSHTMLElement)
    content : TJSHTMLElement;
  end;

    TJSHTMLOrXMLDocument = Class external name 'Document' (TJSDocument)
  end;

  TJSHTMLDocument = Class external name 'HTMLDocument' (TJSHTMLOrXMLDocument)
  end;

  TJSXMLDocument = Class external name 'HTMLDocument' (TJSHTMLOrXMLDocument)
  end;

  TDOMParser = Class external name 'DOMParser' (TJSObject)
  Public
    Function parseFromString (aString,aMimetype : String): TJSHTMLOrXMLDocument;
  end;


  TOnChangeProcedure = reference to procedure;

  TJSPermissionDescriptor = class external name 'Object' (TJSObject)
  public
    name: String;
    userVisibleOnly: Boolean;
    sysex: Boolean;
  end;

  TJSPermissionStatus = class external name 'PermissionStatus' (TJSObject)
  private
    FState: String; external name 'state';
  public
    onchange: TOnChangeProcedure;
    property state: String read FState;
  end;

  TJSPermissions = class external name 'Permissions' (TJSObject)
  public
    function query(descriptor: TJSPermissionDescriptor): TJSPermissionStatus; async;
  end;

  TJSFileSystemHandlePermissionDescriptor = class external name 'Object' (TJSObject)
  public
    mode: String;
  end;

  TJSFileSystemCreateWritableOptions = class external name 'Object' (TJSObject)
  public
    keepExistingData: Boolean;
  end;

  TJSFileSystemWritableFileStream = class;

  TJSFileSystemHandle = class external name 'FileSystemHandle' (TJSObject)
  private
    FKind: String; external name 'kind';
    FName: String; external name 'name';
  public
    function isSameEntry(const Handle: TJSFileSystemHandle): Boolean;
    function queryPermission(descriptor: TJSFileSystemHandlePermissionDescriptor): String;
    function requestPermission(descriptor: TJSFileSystemHandlePermissionDescriptor): String;

    property kind: String read FKind;
    property name: String read FName;
  end;

  TJSFileSystemFileHandle = class external name 'FileSystemFileHandle' (TJSFileSystemHandle)
  public
    function getFile: TJSHTMLFile; async;
    function createWritable: TJSFileSystemWritableFileStream; overload;
    function createWritable(options: TJSFileSystemCreateWritableOptions): TJSFileSystemWritableFileStream; overload;
  end;

  TJSGetFileHandleOptions = class external name 'Object'
  public
    create: Boolean;

    constructor new;
  end;

  TJSRemoveEntryOptions = class external name 'Object' (TJSObject)
    recursive: Boolean;
  end;

  TJSFileSystemDirectoryHandle = class external name 'FileSystemDirectoryHandle' (TJSFileSystemHandle)
  public
    function entries: TJSObject;
    function getDirectoryHandle(name: String): TJSFileSystemDirectoryHandle; async; overload;
    function getDirectoryHandle(name: String; options: TJSGetFileHandleOptions): TJSFileSystemDirectoryHandle; async; overload;
    function getFileHandle(name: String): TJSFileSystemFileHandle; async; overload;
    function getFileHandle(name: String; options: TJSGetFileHandleOptions): TJSFileSystemFileHandle; async; overload;
    function keys: TJSFileSystemDirectoryHandleArray; reintroduce;
    function removeEntry(name: String): TJSPromise;
    function removeEntry(name: String; options: TJSRemoveEntryOptions): TJSPromise;
    function resolve(possibleDescendant: String): TStringDynArray; async;
    function values(possibleDescendant: String): TJSFileSystemDirectoryHandleArray; reintroduce; async;
  end;

  TJSFileSystemWritableFileStream = class external name 'FileSystemWritableFileStream' (TJSWritableStream)
  public
    function seek(position: NativeInt): TJSPromise;
    function write(data: JSValue): TJSPromise;
    function truncate(size: NativeInt): TJSPromise;
  end;

  TJSShowOpenFilePickerTypeOptions = class external name 'Object' (TJSObject)
  public
    description: String;
    accept: TJSObject;
  end;

  TJSShowOpenFilePickerOptions = class external name 'Object' (TJSObject)
  public
    multiple: Boolean;
    excludeAcceptAllOption: Boolean;
    types: array of TJSShowOpenFilePickerTypeOptions;
  end;

  TJSShowSaveFilePickerOptionsAccept = class external name 'Object' (TJSObject)
  public
    description: String;
    accept: TStringDynArray;
  end;

  TJSShowSaveFilePickerOptions = class external name 'Object' (TJSObject)
  public
    excludeAcceptAllOption: Boolean;
    accept: array of TJSShowSaveFilePickerOptionsAccept;
  end;

  TJSXSLTProcessor = class external name 'XSLTProcessor' (TJSObject)
  Public
    procedure importStylesheet(aStyle: TJSNode);
    function transformToFragment(aSource: TJSNode; aOutput: TJSDocument): TJSDocumentFragment;
    function transformToDocument(aSource: TJSNode): TJSDocument;
    procedure setParameter(aNamespaceURI: String; aLocalName: String; aValue: String);
    function getParameter(aNamespaceURI: String; aLocalName: String): String;
    procedure removeParameter(aNamespaceURI: String; aLocalName: String);
    procedure clearParameters;
    procedure reset;
  end;

  TJSXMLSerializer = class external name 'XMLSerializer' (TJSObject)
  public
    function serializeToString(aRoot: TJSNode): string;
  end;


var
  document : TJSDocument; external name 'document';
  window : TJSWindow; external name 'window';
  console : TJSConsole; external name 'window.console';
  caches : TJSCacheStorage; external name 'caches';
  serviceWorker : TJSServiceWorker; external name 'window.navigator.serviceWorker';

Function HasServiceWorker : Boolean;

implementation

Function HasServiceWorker : Boolean;
begin
  if jsvalue(window.navigator.serviceWorker) then
    exit(true)
  else
    exit(false);
end;

{ TJSEventHelper }

function TJSEventHelper.GetCurrentTargetElement: TJSElement;
begin
  Result:=TJSElement(CurrentTarget);
end;

function TJSEventHelper.GetCurrentTargetHTMLElement: TJSHTMLElement;
begin
  Result:=TJSHTMLElement(CurrentTarget);
end;

function TJSEventHelper.GetTargetElement: TJSElement;
begin
  Result:=TJSElement(Target);
end;

function TJSEventHelper.GetTargetHTMLElement: TJSHTMLElement;
begin
  Result:=TJSHTMLElement(Target);
end;

end.
