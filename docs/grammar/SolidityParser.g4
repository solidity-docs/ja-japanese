/**
 * Solidityは、Ethereumプラットフォーム上でスマートコントラクトを実装するための、静的型付けでコントラクト指向の高水準言語です。
 */
parser grammar SolidityParser;

options { tokenVocab=SolidityLexer; }

/**
 * Solidityでは、プラグマ、importディレクティブ、コントラクト、インターフェース、ライブラリ、構造体、列挙型、定数などの定義が可能です。
 */
sourceUnit: (
	pragmaDirective
	| importDirective
	| usingDirective
	| contractDefinition
	| interfaceDefinition
	| libraryDefinition
	| functionDefinition
	| constantVariableDeclaration
	| structDefinition
	| enumDefinition
	| userDefinedValueTypeDefinition
	| errorDefinition
)* EOF;

//@doc: inline
pragmaDirective: Pragma PragmaToken+ PragmaSemicolon;

/**
 * importディレクティブは、異なるファイルから識別子をインポートします。
 */
importDirective:
	Import (
		(path (As unitAlias=identifier)?)
		| (symbolAliases From path)
		| (Mul As unitAlias=identifier From path)
	) Semicolon;
//@doc: inline
//@doc:name aliases
importAliases: symbol=identifier (As alias=identifier)?;
/**
 * インポートするファイルのパス。
 */
path: NonEmptyStringLiteral;
/**
 * インポートするシンボルのエイリアスのリスト。
 */
symbolAliases: LBrace aliases+=importAliases (Comma aliases+=importAliases)* RBrace;

/**
 * コントラクトのトップレベルの定義。
 */
contractDefinition:
	Abstract? Contract name=identifier
	inheritanceSpecifierList?
	LBrace contractBodyElement* RBrace;
/**
 * インターフェースのトップレベルの定義。
 */
interfaceDefinition:
	Interface name=identifier
	inheritanceSpecifierList?
	LBrace contractBodyElement* RBrace;
/**
 * ライブラリのトップレベルの定義。
 */
libraryDefinition: Library name=identifier LBrace contractBodyElement* RBrace;

//@doc:inline
inheritanceSpecifierList:
	Is inheritanceSpecifiers+=inheritanceSpecifier
	(Comma inheritanceSpecifiers+=inheritanceSpecifier)*?;
/**
 * コントラクトとインターフェースの継承指定子です。
 * オプションでベースコンストラクタの引数を与えることができます。
 */
inheritanceSpecifier: name=identifierPath arguments=callArgumentList?;

/**
 * コントラクト、インターフェース、ライブラリで使用可能な宣言。
 *
 * インターフェースとライブラリはコンストラクタを含むことができず、インターフェースは状態変数を含むことができず、ライブラリはフォールバック、receive関数、非定数の状態変数を含むことができないことに注意してください。
 */
contractBodyElement:
	constructorDefinition
	| functionDefinition
	| modifierDefinition
	| fallbackFunctionDefinition
	| receiveFunctionDefinition
	| structDefinition
	| enumDefinition
	| userDefinedValueTypeDefinition
	| stateVariableDeclaration
	| eventDefinition
	| errorDefinition
	| usingDirective;
//@doc:inline
namedArgument: name=identifier Colon value=expression;
/**
 * 関数や類似の呼び出し可能なオブジェクトを呼び出す際の引数。
 * 引数はカンマで区切られたリストか、名前付き引数のマップとして与えられます。
 */
callArgumentList: LParen ((expression (Comma expression)*)? | LBrace (namedArgument (Comma namedArgument)*)? RBrace) RParen;
/**
 * 適格な名称。
 */
identifierPath: identifier (Period identifier)*;

/**
 * モディファイアの呼び出し。
 * モディファイアが引数を取らない場合、引数リストは完全にスキップすることができます（開閉括弧を含む）。
 */
modifierInvocation: identifierPath callArgumentList?;
/**
 * 関数と関数型のビジビリティ。
 */
visibility: Internal | External | Private | Public;
/**
 * 関数の引数や戻り値などのパラメータのリスト。
 */
parameterList: parameters+=parameterDeclaration (Comma parameters+=parameterDeclaration)*;
//@doc:inline
parameterDeclaration: type=typeName location=dataLocation? name=identifier?;
/**
 * コンストラクタの定義。
 * 常に実装を提供する必要があります。
 * internalあるいはpublicの指定は非推奨であることに注意してください。
 */
constructorDefinition
locals[boolean payableSet = false, boolean visibilitySet = false]
:
	Constructor LParen (arguments=parameterList)? RParen
	(
		modifierInvocation
		| {!$payableSet}? Payable {$payableSet = true;}
		| {!$visibilitySet}? Internal {$visibilitySet = true;}
		| {!$visibilitySet}? Public {$visibilitySet = true;}
	)*
	body=block;

/**
 * 関数型に対するミュータビリティの指定。
 * ミュータビリティが指定されていない場合は、デフォルトのミュータビリティ「non-payable」が指定される。
 */
stateMutability: Pure | View | Payable;
/**
 * 関数、モディファイア、状態変数に使用されるオーバーライド指定子。
 * オーバーライドされる複数のベースコントラクトにあいまいな宣言がある場合、基本コントラクトの完全なリストを指定する必要があります。
 */
overrideSpecifier: Override (LParen overrides+=identifierPath (Comma overrides+=identifierPath)* RParen)?;
/**
<<<<<<< HEAD
 * コントラクト、ライブラリ、インターフェース関数の定義。
 * 関数が定義されているコンテキストによっては、さらなる制約が適用される場合があります。
 * 例えば、インターフェイスの関数は未実装、つまりボディブロックを含んではなりません。
=======
 * The definition of contract, library, interface or free functions.
 * Depending on the context in which the function is defined, further restrictions may apply,
 * e.g. functions in interfaces have to be unimplemented, i.e. may not contain a body block.
>>>>>>> english/develop
 */
functionDefinition
locals[
	boolean visibilitySet = false,
	boolean mutabilitySet = false,
	boolean virtualSet = false,
	boolean overrideSpecifierSet = false,
]
:
	Function (identifier | Fallback | Receive)
	LParen (arguments=parameterList)? RParen
	(
		{!$visibilitySet}? visibility {$visibilitySet = true;}
		| {!$mutabilitySet}? stateMutability {$mutabilitySet = true;}
		| modifierInvocation
		| {!$virtualSet}? Virtual {$virtualSet = true;}
		| {!$overrideSpecifierSet}? overrideSpecifier {$overrideSpecifierSet = true;}
	 )*
	(Returns LParen returnParameters=parameterList RParen)?
	(Semicolon | body=block);

/**
<<<<<<< HEAD
 * フリー関数の定義。
 */
 freeFunctionDefinition:
 	Function (identifier | Fallback | Receive)
 	LParen (arguments=parameterList)? RParen
 	stateMutability?
 	(Returns LParen returnParameters=parameterList RParen)?
 	(Semicolon | body=block);

/**
 * モディファイアの定義。
 * モディファイアの本体ブロック内では、アンダースコアは識別子として使用できませんが、モディファイアが適用される関数本体のプレースホルダー文として使用できることに注意してください。
=======
 * The definition of a modifier.
 * Note that within the body block of a modifier, the underscore cannot be used as identifier,
 * but is used as placeholder statement for the body of a function to which the modifier is applied.
>>>>>>> english/develop
 */
modifierDefinition
locals[
	boolean virtualSet = false,
	boolean overrideSpecifierSet = false
]
:
	Modifier name=identifier
	(LParen (arguments=parameterList)? RParen)?
	(
		{!$virtualSet}? Virtual {$virtualSet = true;}
		| {!$overrideSpecifierSet}? overrideSpecifier {$overrideSpecifierSet = true;}
	)*
	(Semicolon | body=block);

/**
 * fallback関数の定義。
 */
fallbackFunctionDefinition
locals[
	boolean visibilitySet = false,
	boolean mutabilitySet = false,
	boolean virtualSet = false,
	boolean overrideSpecifierSet = false,
	boolean hasParameters = false
]
:
	kind=Fallback LParen (parameterList { $hasParameters = true; } )? RParen
	(
		{!$visibilitySet}? External {$visibilitySet = true;}
		| {!$mutabilitySet}? stateMutability {$mutabilitySet = true;}
		| modifierInvocation
		| {!$virtualSet}? Virtual {$virtualSet = true;}
		| {!$overrideSpecifierSet}? overrideSpecifier {$overrideSpecifierSet = true;}
	)*
	( {$hasParameters}? Returns LParen returnParameters=parameterList RParen | {!$hasParameters}? )
	(Semicolon | body=block);

/**
 * receive関数の定義。
 */
receiveFunctionDefinition
locals[
	boolean visibilitySet = false,
	boolean mutabilitySet = false,
	boolean virtualSet = false,
	boolean overrideSpecifierSet = false
]
:
	kind=Receive LParen RParen
	(
		{!$visibilitySet}? External {$visibilitySet = true;}
		| {!$mutabilitySet}? Payable {$mutabilitySet = true;}
		| modifierInvocation
		| {!$virtualSet}? Virtual {$virtualSet = true;}
		| {!$overrideSpecifierSet}? overrideSpecifier {$overrideSpecifierSet = true;}
	 )*
	(Semicolon | body=block);

/**
 * 構造体の定義。ソースユニット、コントラクト、ライブラリ、インターフェースのトップレベルで定義できます。
 */
structDefinition: Struct name=identifier LBrace members=structMember+ RBrace;
/**
 * 名前付き構造体メンバの宣言。
 */
structMember: type=typeName name=identifier Semicolon;
/**
 * enumの定義。ソースユニット、コントラクト、ライブラリ、インターフェースのトップレベルで定義できます。
 */
enumDefinition:	Enum name=identifier LBrace enumValues+=identifier (Comma enumValues+=identifier)* RBrace;
/**
 * ユーザー定義の値型を定義。ソースユニット、コントラクト、ライブラリ、インターフェースのトップレベルで定義できます。
 */
userDefinedValueTypeDefinition:
	Type name=identifier Is elementaryTypeName[true] Semicolon;

/**
 * 状態変数の宣言。
 */
stateVariableDeclaration
locals [boolean constantnessSet = false, boolean visibilitySet = false, boolean overrideSpecifierSet = false]
:
	type=typeName
	(
		{!$visibilitySet}? Public {$visibilitySet = true;}
		| {!$visibilitySet}? Private {$visibilitySet = true;}
		| {!$visibilitySet}? Internal {$visibilitySet = true;}
		| {!$constantnessSet}? Constant {$constantnessSet = true;}
		| {!$overrideSpecifierSet}? overrideSpecifier {$overrideSpecifierSet = true;}
		| {!$constantnessSet}? Immutable {$constantnessSet = true;}
	)*
	name=identifier
	(Assign initialValue=expression)?
	Semicolon;

/**
 * 定数変数の宣言。
 */
constantVariableDeclaration
:
	type=typeName
	Constant
	name=identifier
	Assign initialValue=expression
	Semicolon;

/**
 * イベントのパラメータ。
 */
eventParameter: type=typeName Indexed? name=identifier?;
/**
 * イベントの定義。コントラクト、ライブラリ、インターフェースで定義できます。
 */
eventDefinition:
	Event name=identifier
	LParen (parameters+=eventParameter (Comma parameters+=eventParameter)*)? RParen
	Anonymous?
	Semicolon;

/**
 * エラーのパラメータ。
 */
errorParameter: type=typeName name=identifier?;
/**
 * エラーの定義。
 */
errorDefinition:
	Error name=identifier
	LParen (parameters+=errorParameter (Comma parameters+=errorParameter)*)? RParen
	Semicolon;

/**
 * Operators that users are allowed to implement for some types with `using for`.
 */
userDefinableOperator:
	BitAnd
	| BitNot
	| BitOr
	| BitXor
	| Add
	| Div
	| Mod
	| Mul
	| Sub
	| Equal
	| GreaterThan
	| GreaterThanOrEqual
	| LessThan
	| LessThanOrEqual
	| NotEqual;

/**
 * Using directive to attach library functions and free functions to types.
 * Can occur within contracts and libraries and at the file level.
 */
usingDirective: Using (identifierPath | (LBrace identifierPath (As userDefinableOperator)? (Comma identifierPath (As userDefinableOperator)?)* RBrace)) For (Mul | typeName) Global? Semicolon;
/**
 * 型名には、基本型、関数型、マッピング型、ユーザ定義型（コントラクトや構造体など）、配列型があります。
 */
typeName: elementaryTypeName[true] | functionTypeName | mappingType | identifierPath | typeName LBrack expression? RBrack;
elementaryTypeName[boolean allowAddressPayable]: Address | {$allowAddressPayable}? Address Payable | Bool | String | Bytes | SignedIntegerType | UnsignedIntegerType | FixedBytes | Fixed | Ufixed;
functionTypeName
locals [boolean visibilitySet = false, boolean mutabilitySet = false]
:
	Function LParen (arguments=parameterList)? RParen
	(
		{!$visibilitySet}? visibility {$visibilitySet = true;}
		| {!$mutabilitySet}? stateMutability {$mutabilitySet = true;}
	)*
	(Returns LParen returnParameters=parameterList RParen)?;

/**
 * 単一の変数の宣言。
 */
variableDeclaration: type=typeName location=dataLocation? name=identifier;
dataLocation: Memory | Storage | Calldata;

/**
 * 複合式。
 * インデックスアクセス、インデックス範囲アクセス、メンバーアクセス、関数呼び出し（関数呼び出しオプション付き）、型変換、単項式または二項式、比較または代入、三項式、new式（コントラクトの作成または動的メモリ配列の割り当て）、タプル、インライン配列、一次式（識別子、リテラル、型名など）であることが可能です。
 */
expression:
	expression LBrack index=expression? RBrack # IndexAccess
	| expression LBrack startIndex=expression? Colon endIndex=expression? RBrack # IndexRangeAccess
	| expression Period (identifier | Address) # MemberAccess
	| expression LBrace (namedArgument (Comma namedArgument)*)? RBrace # FunctionCallOptions
	| expression callArgumentList # FunctionCall
	| Payable callArgumentList # PayableConversion
	| Type LParen typeName RParen # MetaType
	| (Inc | Dec | Not | BitNot | Delete | Sub) expression # UnaryPrefixOperation
	| expression (Inc | Dec) # UnarySuffixOperation
	|<assoc=right> expression Exp expression # ExpOperation
	| expression (Mul | Div | Mod) expression # MulDivModOperation
	| expression (Add | Sub) expression # AddSubOperation
	| expression (Shl | Sar | Shr) expression # ShiftOperation
	| expression BitAnd expression # BitAndOperation
	| expression BitXor expression # BitXorOperation
	| expression BitOr expression # BitOrOperation
	| expression (LessThan | GreaterThan | LessThanOrEqual | GreaterThanOrEqual) expression # OrderComparison
	| expression (Equal | NotEqual) expression # EqualityComparison
	| expression And expression # AndOperation
	| expression Or expression # OrOperation
	|<assoc=right> expression Conditional expression Colon expression # Conditional
	|<assoc=right> expression assignOp expression # Assignment
	| New typeName # NewExpr
	| tupleExpression # Tuple
	| inlineArrayExpression # InlineArray
 	| (
		identifier
		| literal
		| literalWithSubDenomination
		| elementaryTypeName[false]
	  ) # PrimaryExpression
;

//@doc:inline
assignOp: Assign | AssignBitOr | AssignBitXor | AssignBitAnd | AssignShl | AssignSar | AssignShr | AssignAdd | AssignSub | AssignMul | AssignDiv | AssignMod;
tupleExpression: LParen (expression? ( Comma expression?)* ) RParen;
/**
 * インライン配列式は、含まれる式の共通型の静的な大きさの配列を示します。
 */
inlineArrayExpression: LBrack (expression ( Comma expression)* ) RBrack;

/**
 * 通常の非キーワード識別子以外に、'from' や 'error' などのキーワードも識別子として使用することができます。
 */
identifier: Identifier | From | Error | Revert | Global;

literal: stringLiteral | numberLiteral | booleanLiteral | hexStringLiteral | unicodeStringLiteral;

literalWithSubDenomination: numberLiteral SubDenomination;

booleanLiteral: True | False;
/**
 * 完全な文字列リテラルは、1つまたは複数の連続した引用符で囲まれた文字列で構成されています。
 */
stringLiteral: (NonEmptyStringLiteral | EmptyStringLiteral)+;
/**
 * 1つまたは複数の連続した16進文字列で構成される完全な16進文字列リテラル。
 */
hexStringLiteral: HexString+;
/**
 * 1つまたは複数の連続したUnicode文字列で構成される完全なUnicode文字列リテラル。
 */
unicodeStringLiteral: UnicodeStringLiteral+;

/**
 * 数値リテラルは10進数または16進数で、単位は任意です。
 */
numberLiteral: DecimalNumber | HexNumber;

/**
 * 波括弧で囲まれた文のブロック。独自のスコープを持ちます。
 */
block:
	LBrace ( statement | uncheckedBlock )* RBrace;

uncheckedBlock: Unchecked block;

statement:
	block
	| simpleStatement
	| ifStatement
	| forStatement
	| whileStatement
	| doWhileStatement
	| continueStatement
	| breakStatement
	| tryStatement
	| returnStatement
	| emitStatement
	| revertStatement
	| assemblyStatement
;

//@doc:inline
simpleStatement: variableDeclarationStatement | expressionStatement;
/**
 * if文。else部はオプション。
 */
ifStatement: If LParen expression RParen statement (Else statement)?;
/**
 * for文。init、condition、post-loop部はオプション。
 */
forStatement: For LParen (simpleStatement | Semicolon) (expressionStatement | Semicolon) expression? RParen statement;
whileStatement: While LParen expression RParen statement;
doWhileStatement: Do statement While LParen expression RParen Semicolon;
/**
 * continue文。for、while、do-whileループ内でのみ使用可能。
 */
continueStatement: Continue Semicolon;
/**
 * break文。for、while、do-whileループ内でのみ使用可能。
 */
breakStatement: Break Semicolon;
/**
 * try文。含まれる式は、外部関数呼び出しまたはコントラクトの作成である必要があります。
 */
tryStatement: Try expression (Returns LParen returnParameters=parameterList RParen)? block catchClause+;
/**
 * try文のcatch句。
 */
catchClause: Catch (identifier? LParen (arguments=parameterList) RParen)? block;

returnStatement: Return expression? Semicolon;
/**
 * emit文。含まれる式は、イベントを参照する必要があります。
 */
emitStatement: Emit expression callArgumentList Semicolon;
/**
 * revert文。含まれる式は、エラーを参照する必要があります。
 */
revertStatement: Revert expression callArgumentList Semicolon;
/**
 * インラインアセンブリブロック。
 * インラインアセンブリブロックのコンテンツは、別の字句解析器（scanner/lexer）を使用します。
 * つまり、インラインアセンブリブロックの内部では、キーワードと許可された識別子のセットが異なります。
 */
assemblyStatement: Assembly AssemblyDialect? assemblyFlags? AssemblyLBrace yulStatement* YulRBrace;

/**
 * Assembly flags.
 * Comma-separated list of double-quoted strings as flags.
 */
assemblyFlags: AssemblyBlockLParen AssemblyFlagString (AssemblyBlockComma AssemblyFlagString)* AssemblyBlockRParen;

//@doc:inline
variableDeclarationList: variableDeclarations+=variableDeclaration (Comma variableDeclarations+=variableDeclaration)*;
/**
 * 変数宣言で使用される変数名のタプルです。
 * 空のフィールドを含むことができます。
 */
variableDeclarationTuple:
	LParen
		(Comma* variableDeclarations+=variableDeclaration)
		(Comma (variableDeclarations+=variableDeclaration)?)*
	RParen;
/**
 * 変数宣言文。
 * 単一の変数は初期値なしで宣言できますが、変数のタプルは初期値付きでしか宣言できません。
 */
variableDeclarationStatement: ((variableDeclaration (Assign expression)?) | (variableDeclarationTuple Assign expression)) Semicolon;
expressionStatement: expression Semicolon;

mappingType: Mapping LParen key=mappingKeyType name=identifier? DoubleArrow value=typeName name=identifier? RParen;
/**
 * マッピングのキーとして使用できるのは、基本型またはユーザー定義型のみです。
 */
mappingKeyType: elementaryTypeName[false] | identifierPath;

/**
 * インラインアセンブリブロック内のYul文。
 * continue文とbreak文は、forループ内でのみ有効です。
 * leave文は、関数のボディの中でのみ有効です。
 */
yulStatement:
	yulBlock
	| yulVariableDeclaration
	| yulAssignment
	| yulFunctionCall
	| yulIfStatement
	| yulForStatement
	| yulSwitchStatement
	| YulLeave
	| YulBreak
	| YulContinue
	| yulFunctionDefinition;

yulBlock: YulLBrace yulStatement* YulRBrace;

/**
 * 1つまたは複数のYul変数の宣言で、初期値は任意。
 * 複数の変数が宣言されている場合、初期値として有効なのは関数呼び出しのみです。
 */
yulVariableDeclaration:
	(YulLet variables+=YulIdentifier (YulAssign yulExpression)?)
	| (YulLet variables+=YulIdentifier (YulComma variables+=YulIdentifier)* (YulAssign yulFunctionCall)?);

/**
 * どんな式でも1つのYul変数に代入できますが、複数代入する場合は右辺に関数呼び出しが必要です。
 */
yulAssignment: yulPath YulAssign yulExpression | (yulPath (YulComma yulPath)+) YulAssign yulFunctionCall;

yulIfStatement: YulIf cond=yulExpression body=yulBlock;

yulForStatement: YulFor init=yulBlock cond=yulExpression post=yulBlock body=yulBlock;

//@doc:inline
yulSwitchCase: YulCase yulLiteral yulBlock;
/**
 * Yul switch文は、default-caseのみ（非推奨）、または1つ以上のnon-default case（オプションでdefault-caseが続く）から構成できます。
 */
yulSwitchStatement:
	YulSwitch yulExpression
	(
		(yulSwitchCase+ (YulDefault yulBlock)?)
		| (YulDefault yulBlock)
	);

yulFunctionDefinition:
	YulFunction YulIdentifier
	YulLParen (arguments+=YulIdentifier (YulComma arguments+=YulIdentifier)*)? YulRParen
	(YulArrow returnParameters+=YulIdentifier (YulComma returnParameters+=YulIdentifier)*)?
	body=yulBlock;

/**
 * インラインアセンブリ内ではドットのない識別子しか宣言できませんが、ドットを含むパスはインラインアセンブリブロックの外の宣言を参照できます。
 */
yulPath: YulIdentifier (YulPeriod (YulIdentifier | YulEVMBuiltin))*;
/**
 * 戻り値のある関数の呼び出しは、代入や変数宣言の右辺としてのみ発生します。
 */
yulFunctionCall: (YulIdentifier | YulEVMBuiltin) YulLParen (yulExpression (YulComma yulExpression)*)? YulRParen;
yulBoolean: YulTrue | YulFalse;
yulLiteral: YulDecimalNumber | YulStringLiteral | YulHexNumber | yulBoolean | YulHexStringLiteral;
yulExpression: yulPath | yulFunctionCall | yulLiteral;
