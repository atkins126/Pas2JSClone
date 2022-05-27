{
  JOB - JS Object Bridge for Webassembly

  These types and constants are shared between pas2js and webassembly.
}
unit JOB_Shared;

interface

type
  TJOBObjectID = NativeInt;

// invoke results
type
  TJOBResult = longint;
const
  JOBResult_None = 0;
  JOBResult_Success = 1;
  JOBResult_UnknownObjId = 2;
  JOBResult_NotAFunction = 3;
  JOBResult_WrongArgs = 4;
  JOBResult_Undefined = 5;
  JOBResult_Null = 6;
  JOBResult_Boolean = 7;
  JOBResult_Double = 8;
  JOBResult_String = 9;
  JOBResult_Function = 10;
  JOBResult_Object = 11;
  JOBResult_BigInt = 12;
  JOBResult_Symbol = 13;

  JOBResultLast = 13;

  JOBResult_Names: array[0..JOBResultLast] of string = (
    'None',
    'Success',
    'UnknownObjId',
    'NotAFunction',
    'WrongArgs',
    'Undefined',
    'Null',
    'Boolean',
    'Double',
    'String',
    'Function',
    'Object',
    'BigInt',
    'Symbol'
    );

  JOBExportName = 'job';
  JOBFn_InvokeNoResult = 'invoke_noresult';
  JOBFn_InvokeBooleanResult = 'invoke_boolresult';
  JOBFn_InvokeDoubleResult = 'invoke_doubleresult';
  JOBFn_InvokeStringResult = 'invoke_stringresult';
  JOBFn_GetStringResult = 'get_stringresult';
  JOBFn_ReleaseStringResult = 'release_stringresult';
  JOBFn_InvokeObjectResult = 'invoke_objectresult';
  JOBFn_ReleaseObject = 'release_object';
  JOBFn_InvokeJSValueResult = 'invoke_jsvalueresult';

  JOBArgNone = 0;
  JOBArgLongint = 1;
  JOBArgDouble = 2;
  JOBArgTrue = 3;
  JOBArgFalse = 4;
  JOBArgChar = 5; // followed by a word
  JOBArgUTF8String = 6; // followed by length and pointer
  JOBArgUnicodeString = 7; // followed by length and pointer
  JOBArgNil = 8;
  JOBArgPointer = 9;
  JOBArgObject = 10; // followed by ObjectID

  JOBInvokeCall = 0; // call function
  JOBInvokeGet = 1; // read property
  JOBInvokeSet = 2; // set property
  JOBInvokeNew = 3; // new operator

  JOBInvokeNames: array[0..3] of string = (
    'Call',
    'Get',
    'Set',
    'New'
    );

  JOBObjIdDocument = -1;
  JOBObjIdWindow = -2;
  JOBObjIdConsole = -3;
  JOBObjIdCaches = -4;
  JOBObjIdObject = -5;
  JOBObjIdFunction = -6;
  JOBObjIdDate = -7;
  JOBObjIdString = -8;
  JOBObjIdArray = -9;
  JOBObjIdArrayBuffer = -10;
  JOBObjIdInt8Array = -11;
  JOBObjIdUint8Array = -12;
  JOBObjIdUint8ClampedArray = -13;
  JOBObjIdInt16Array = -13;
  JOBObjIdUint16Array = -14;
  JOBObjIdInt32Array = -16;
  JOBObjIdFloat32Array = -17;
  JOBObjIdFloat64Array = -18;
  JOBObjIdJSON = -19;
  JOBObjIdPromise = -20;

  JObjIdBird = -21;

implementation

end.
