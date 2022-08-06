lexer grammar SolidityLexer;

/**
 * 将来Solidityで使用するために予約されたキーワード。
 */
ReservedKeywords:
	'after' | 'alias' | 'apply' | 'auto' | 'byte' | 'case' | 'copyof' | 'default' | 'define' | 'final'
	| 'implements' | 'in' | 'inline' | 'let' | 'macro' | 'match' | 'mutable' | 'null' | 'of'
	| 'partial' | 'promise' | 'reference' | 'relocatable' | 'sealed' | 'sizeof' | 'static'
	| 'supports' | 'switch' | 'typedef' | 'typeof' | 'var';

Pragma: 'pragma' -> pushMode(PragmaMode);
Abstract: 'abstract';
Anonymous: 'anonymous';
Address: 'address';
As: 'as';
Assembly: 'assembly' -> pushMode(AssemblyBlockMode);
Bool: 'bool';
Break: 'break';
Bytes: 'bytes';
Calldata: 'calldata';
Catch: 'catch';
Constant: 'constant';
Constructor: 'constructor';
Continue: 'continue';
Contract: 'contract';
Delete: 'delete';
Do: 'do';
Else: 'else';
Emit: 'emit';
Enum: 'enum';
Error: 'error'; // not a real keyword
Revert: 'revert'; // not a real keyword
Event: 'event';
External: 'external';
Fallback: 'fallback';
False: 'false';
Fixed: 'fixed' | ('fixed' [1-9][0-9]* 'x' [1-9][0-9]*);
From: 'from'; // not a real keyword
/**
 * 固定長のバイト型。
 */
FixedBytes:
	'bytes1' | 'bytes2' | 'bytes3' | 'bytes4' | 'bytes5' | 'bytes6' | 'bytes7' | 'bytes8' |
	'bytes9' | 'bytes10' | 'bytes11' | 'bytes12' | 'bytes13' | 'bytes14' | 'bytes15' | 'bytes16' |
	'bytes17' | 'bytes18' | 'bytes19' | 'bytes20' | 'bytes21' | 'bytes22' | 'bytes23' | 'bytes24' |
	'bytes25' | 'bytes26' | 'bytes27' | 'bytes28' | 'bytes29' | 'bytes30' | 'bytes31' | 'bytes32';
For: 'for';
Function: 'function';
Hex: 'hex';
If: 'if';
Immutable: 'immutable';
Import: 'import';
Indexed: 'indexed';
Interface: 'interface';
Internal: 'internal';
Is: 'is';
Library: 'library';
Mapping: 'mapping';
Memory: 'memory';
Modifier: 'modifier';
New: 'new';
/**
 * 数値の単位表記。
 */
NumberUnit: 'wei' | 'gwei' | 'ether' | 'seconds' | 'minutes' | 'hours' | 'days' | 'weeks' | 'years';
Override: 'override';
Payable: 'payable';
Private: 'private';
Public: 'public';
Pure: 'pure';
Receive: 'receive';
Return: 'return';
Returns: 'returns';
/**
 * サイズが決められた符号付き整数型。
 * intはint256のエイリアスです。
 */
SignedIntegerType:
	'int' | 'int8' | 'int16' | 'int24' | 'int32' | 'int40' | 'int48' | 'int56' | 'int64' |
	'int72' | 'int80' | 'int88' | 'int96' | 'int104' | 'int112' | 'int120' | 'int128' |
	'int136' | 'int144' | 'int152' | 'int160' | 'int168' | 'int176' | 'int184' | 'int192' |
	'int200' | 'int208' | 'int216' | 'int224' | 'int232' | 'int240' | 'int248' | 'int256';
Storage: 'storage';
String: 'string';
Struct: 'struct';
True: 'true';
Try: 'try';
Type: 'type';
Ufixed: 'ufixed' | ('ufixed' [1-9][0-9]+ 'x' [1-9][0-9]+);
Unchecked: 'unchecked';
/**
 * サイズが決められた符号無し整数型。
 * uintはuint256のエイリアスです。
 */
UnsignedIntegerType:
	'uint' | 'uint8' | 'uint16' | 'uint24' | 'uint32' | 'uint40' | 'uint48' | 'uint56' | 'uint64' |
	'uint72' | 'uint80' | 'uint88' | 'uint96' | 'uint104' | 'uint112' | 'uint120' | 'uint128' |
	'uint136' | 'uint144' | 'uint152' | 'uint160' | 'uint168' | 'uint176' | 'uint184' | 'uint192' |
	'uint200' | 'uint208' | 'uint216' | 'uint224' | 'uint232' | 'uint240' | 'uint248' | 'uint256';
Using: 'using';
View: 'view';
Virtual: 'virtual';
While: 'while';

LParen: '(';
RParen: ')';
LBrack: '[';
RBrack: ']';
LBrace: '{';
RBrace: '}';
Colon: ':';
Semicolon: ';';
Period: '.';
Conditional: '?';
DoubleArrow: '=>';
RightArrow: '->';

Assign: '=';
AssignBitOr: '|=';
AssignBitXor: '^=';
AssignBitAnd: '&=';
AssignShl: '<<=';
AssignSar: '>>=';
AssignShr: '>>>=';
AssignAdd: '+=';
AssignSub: '-=';
AssignMul: '*=';
AssignDiv: '/=';
AssignMod: '%=';

Comma: ',';
Or: '||';
And: '&&';
BitOr: '|';
BitXor: '^';
BitAnd: '&';
Shl: '<<';
Sar: '>>';
Shr: '>>>';
Add: '+';
Sub: '-';
Mul: '*';
Div: '/';
Mod: '%';
Exp: '**';

Equal: '==';
NotEqual: '!=';
LessThan: '<';
GreaterThan: '>';
LessThanOrEqual: '<=';
GreaterThanOrEqual: '>=';
Not: '!';
BitNot: '~';
Inc: '++';
Dec: '--';
//@doc:inline
DoubleQuote: '"';
//@doc:inline
SingleQuote: '\'';

/**
 * 印字可能な文字に制限された、クォートで囲まれた空でない文字列リテラル。
 */
NonEmptyStringLiteral: '"' DoubleQuotedStringCharacter+ '"' | '\'' SingleQuotedStringCharacter+ '\'';
/**
 * 空の文字列リテラル
 */
EmptyStringLiteral: '"' '"' | '\'' '\'';

// Note that this will also be used for Yul string literals.
//@doc:inline
fragment DoubleQuotedStringCharacter: DoubleQuotedPrintable | EscapeSequence;
// Note that this will also be used for Yul string literals.
//@doc:inline
fragment SingleQuotedStringCharacter: SingleQuotedPrintable | EscapeSequence;
/**
 * シングルクォート、バックスラッシュ以外の印字可能な文字。
 */
fragment SingleQuotedPrintable: [\u0020-\u0026\u0028-\u005B\u005D-\u007E];
/**
 * ダブルクォート、バックスラッシュ以外の印刷可能な文字。
 */
fragment DoubleQuotedPrintable: [\u0020-\u0021\u0023-\u005B\u005D-\u007E];
/**
  * エスケープシーケンス。
  * 一般的な1文字のエスケープシーケンスとは別に、改行もエスケープできます。
  * また、4桁の16進数のUnicodeエスケープ \uXXXX と2桁の16進数のエスケープシーケンス \xXX が使用可能です。
  */
fragment EscapeSequence:
	'\\' (
		['"\\nrt\n\r]
		| 'u' HexCharacter HexCharacter HexCharacter HexCharacter
		| 'x' HexCharacter HexCharacter
	);
/**
 * 任意のUnicode文字を使用できるシングルクォートで囲まれた文字列リテラル。
 */
UnicodeStringLiteral:
	'unicode"' DoubleQuotedUnicodeStringCharacter* '"'
	| 'unicode\'' SingleQuotedUnicodeStringCharacter* '\'';
//@doc:inline
fragment DoubleQuotedUnicodeStringCharacter: ~["\r\n\\] | EscapeSequence;
//@doc:inline
fragment SingleQuotedUnicodeStringCharacter: ~['\r\n\\] | EscapeSequence;

// Note that this will also be used for Yul hex string literals.
/**
 * 16進文字列は、偶数長の16進数の数字で構成され、アンダースコアを用いてグループ化できる必要があります。
 */
HexString: 'hex' (('"' EvenHexDigits? '"') | ('\'' EvenHexDigits? '\''));
/**
 * 16進数は、プレフィックスと、アンダースコアで区切られた任意の数の16進数の数字で構成されています。
 */
HexNumber: '0' 'x' HexDigits;
//@doc:inline
fragment HexDigits: HexCharacter ('_'? HexCharacter)*;
//@doc:inline
fragment EvenHexDigits: HexCharacter HexCharacter ('_'? HexCharacter HexCharacter)*;
//@doc:inline
fragment HexCharacter: [0-9A-Fa-f];

/**
 * 10進数リテラルは、アンダースコアで区切られた10進数の数字と、オプションで正または負の指数で構成されています。
 * 桁に小数点が含まれている場合、リテラルは固定小数点型となります。
 */
DecimalNumber: (DecimalDigits | (DecimalDigits? '.' DecimalDigits)) ([eE] '-'? DecimalDigits)?;
//@doc:inline
fragment DecimalDigits: [0-9] ('_'? [0-9])* ;


/**
 * Solidityの識別子は、アルファベット、ドル記号、アンダースコアで始まる必要があり、最初の記号の後であれば数字を含むことができます。
 */
Identifier: IdentifierStart IdentifierPart*;
//@doc:inline
fragment IdentifierStart: [a-zA-Z$_];
//@doc:inline
fragment IdentifierPart: [a-zA-Z0-9$_];

WS: [ \t\r\n\u000C]+ -> skip ;
COMMENT: '/*' .*? '*/' -> channel(HIDDEN) ;
LINE_COMMENT: '//' ~[\r\n]* -> channel(HIDDEN);

mode AssemblyBlockMode;

//@doc:inline
AssemblyDialect: '"evmasm"';
AssemblyLBrace: '{' -> popMode, pushMode(YulMode);

AssemblyBlockWS: [ \t\r\n\u000C]+ -> skip ;
AssemblyBlockCOMMENT: '/*' .*? '*/' -> channel(HIDDEN) ;
AssemblyBlockLINE_COMMENT: '//' ~[\r\n]* -> channel(HIDDEN) ;

mode YulMode;

YulBreak: 'break';
YulCase: 'case';
YulContinue: 'continue';
YulDefault: 'default';
YulFalse: 'false';
YulFor: 'for';
YulFunction: 'function';
YulIf: 'if';
YulLeave: 'leave';
YulLet: 'let';
YulSwitch: 'switch';
YulTrue: 'true';
YulHex: 'hex';

/**
 * EVMのオペコードに対応するYulのビルトイン関数。
 */
YulEVMBuiltin:
	'stop' | 'add' | 'sub' | 'mul' | 'div' | 'sdiv' | 'mod' | 'smod' | 'exp' | 'not'
	| 'lt' | 'gt' | 'slt' | 'sgt' | 'eq' | 'iszero' | 'and' | 'or' | 'xor' | 'byte'
	| 'shl' | 'shr' | 'sar' | 'addmod' | 'mulmod' | 'signextend' | 'keccak256'
	| 'pop' | 'mload' | 'mstore' | 'mstore8' | 'sload' | 'sstore' | 'msize' | 'gas'
	| 'address' | 'balance' | 'selfbalance' | 'caller' | 'callvalue' | 'calldataload'
	| 'calldatasize' | 'calldatacopy' | 'extcodesize' | 'extcodecopy' | 'returndatasize'
	| 'returndatacopy' | 'extcodehash' | 'create' | 'create2' | 'call' | 'callcode'
	| 'delegatecall' | 'staticcall' | 'return' | 'revert' | 'selfdestruct' | 'invalid'
	| 'log0' | 'log1' | 'log2' | 'log3' | 'log4' | 'chainid' | 'origin' | 'gasprice'
	| 'blockhash' | 'coinbase' | 'timestamp' | 'number' | 'difficulty' | 'gaslimit'
	| 'basefee';

YulLBrace: '{' -> pushMode(YulMode);
YulRBrace: '}' -> popMode;
YulLParen: '(';
YulRParen: ')';
YulAssign: ':=';
YulPeriod: '.';
YulComma: ',';
YulArrow: '->';

/**
 * Yul識別子は、アルファベット、ドル記号、アンダースコア、数字で構成されますが、数字で始めることはできません。
 * インラインアセンブリでは、ユーザー定義識別子にドットを使用することはできません。
 * ドットを含む識別子で構成される式については、yulPathを参照してください。
 */
YulIdentifier: YulIdentifierStart YulIdentifierPart*;
//@doc:inline
fragment YulIdentifierStart: [a-zA-Z$_];
//@doc:inline
fragment YulIdentifierPart: [a-zA-Z0-9$_];
/**
 * Yulの16進数リテラルは、プレフィックスと1桁以上の16進数で構成されています。
 */
YulHexNumber: '0' 'x' [0-9a-fA-F]+;
/**
 * Yulの10進数リテラルは、0または先頭の0を除いた任意の10進数の数字列です。
 */
YulDecimalNumber: '0' | ([1-9] [0-9]*);
/**
 * Yulの文字列リテラルは、1つ以上のダブルクォートまたはシングルクォートで囲まれた文字列からなり、それぞれエスケープされていない改行やエスケープされていないダブルクォートやシングルクォート以外のエスケープシーケンスや印字可能な文字が含まれることがある。
 */
YulStringLiteral:
	'"' DoubleQuotedStringCharacter* '"'
	| '\'' SingleQuotedStringCharacter* '\'';
//@doc:inline
YulHexStringLiteral: HexString;

YulWS: [ \t\r\n\u000C]+ -> skip ;
YulCOMMENT: '/*' .*? '*/' -> channel(HIDDEN) ;
YulLINE_COMMENT: '//' ~[\r\n]* -> channel(HIDDEN) ;

mode PragmaMode;

/**
 * Pragmaトークン。
 * セミコロン以外のあらゆる種類の記号を含むことができます。
 * 現在、Solidityパーサーはこのサブセットしか許さないことに注意してください。
 */
//@doc:name pragma-token
//@doc:no-diagram
PragmaToken: ~[;]+;
PragmaSemicolon: ';' -> popMode;

PragmaWS: [ \t\r\n\u000C]+ -> skip ;
PragmaCOMMENT: '/*' .*? '*/' -> channel(HIDDEN) ;
PragmaLINE_COMMENT: '//' ~[\r\n]* -> channel(HIDDEN) ;
