''
'' Parsing of AST dumps, generated by emitFile() in AST dump mode. It's FB code
'' with some extensions to be able to represent the additional information
'' stored in the AST.
''

#include once "fbfrog.bi"

declare function imStructCompound( ) as ASTNODE ptr
declare function imProcDecl( byval is_procptr as integer ) as ASTNODE ptr

dim shared as integer x

private sub imOops( )
	print "error: unknown construct in AST dump, at this token:"
	print tkDumpOne( x ) & ", line " & tkGetLineNum( x )
	end 1
end sub

private function imSkip( byval y as integer ) as integer
	do
		y += 1

		select case( tkGet( y ) )
		case TK_SPACE, TK_COMMENT

		case else
			exit do
		end select
	loop

	function = y
end function

private sub hSkip( )
	x = imSkip( x )
end sub

private function hMatch( byval tk as integer ) as integer
	if( tkGet( x ) = tk ) then
		function = TRUE
		hSkip( )
	end if
end function

private sub hExpect( byval tk as integer )
	if( tkGet( x ) <> tk ) then
		imOops( )
	end if
end sub

private sub hExpectAndSkip( byval tk as integer )
	hExpect( tk )
	hSkip( )
end sub

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

type FBOPINFO
	level		as integer
	is_leftassoc	as integer
end type

'' FB operator precedence (higher value = higher precedence)
dim shared as FBOPINFO fbopinfo(ASTCLASS_LOGOR to ASTCLASS_UNARYPLUS) = _
{ _
	(10, TRUE ), _ '' ASTCLASS_LOGOR
	(10, TRUE ), _ '' ASTCLASS_LOGAND
	(12, TRUE ), _ '' ASTCLASS_BITOR
	(11, TRUE ), _ '' ASTCLASS_BITXOR
	(13, TRUE ), _ '' ASTCLASS_BITAND
	(15, TRUE ), _ '' ASTCLASS_EQ
	(15, TRUE ), _ '' ASTCLASS_NE
	(15, TRUE ), _ '' ASTCLASS_LT
	(15, TRUE ), _ '' ASTCLASS_LE
	(15, TRUE ), _ '' ASTCLASS_GT
	(15, TRUE ), _ '' ASTCLASS_GE
	(17, TRUE ), _ '' ASTCLASS_SHL
	(17, TRUE ), _ '' ASTCLASS_SHR
	(16, TRUE ), _ '' ASTCLASS_ADD
	(16, TRUE ), _ '' ASTCLASS_SUB
	(19, TRUE ), _ '' ASTCLASS_MUL
	(19, TRUE ), _ '' ASTCLASS_DIV
	(18, TRUE ), _ '' ASTCLASS_MOD
	( 0, TRUE ), _ '' ASTCLASS_LOGNOT
	(14, TRUE ), _ '' ASTCLASS_BITNOT
	(20, TRUE ), _ '' ASTCLASS_NEGATE
	(20, TRUE )  _ '' ASTCLASS_UNARYPLUS
}

'' FB expression parser based on precedence climbing
private function imExpression _
	( _
		byval is_pp as integer, _
		byval level as integer = 0 _
	) as ASTNODE ptr

	'' Unary prefix operators
	var astclass = -1
	select case( tkGet( x ) )
	case KW_NOT    : astclass = ASTCLASS_BITNOT    '' NOT
	case TK_MINUS  : astclass = ASTCLASS_NEGATE    '' -
	case TK_PLUS   : astclass = ASTCLASS_UNARYPLUS '' +
	end select

	dim as ASTNODE ptr a
	if( astclass >= 0 ) then
		hSkip( )
		a = astNew( astclass, imExpression( is_pp, fbopinfo(astclass).level ) )
	else
		'' Atoms
		select case( tkGet( x ) )
		'' '(' Expression ')'
		case TK_LPAREN
			hSkip( )

			'' Expression
			a = imExpression( is_pp )

			'' ')'
			hExpectAndSkip( TK_RPAREN )

		case TK_OCTNUM, TK_DECNUM, TK_HEXNUM, TK_DECFLOAT
			a = hNumberLiteral( x )
			hSkip( )

		'' DEFINED '(' Identifier ')'
		case KW_DEFINED
			if( is_pp = FALSE ) then
				imOops( )
			end if
			hSkip( )

			'' '('
			hExpectAndSkip( TK_LPAREN )

			'' Identifier
			hExpect( TK_ID )
			a = astNew( ASTCLASS_ID, tkGetText( x ) )
			hSkip( )

			'' ')'
			hExpectAndSkip( TK_RPAREN )

			a = astNew( ASTCLASS_DEFINED, a )

		'' IIF '(' Expression ',' Expression ',' Expression ')'
		case KW_IIF
			hSkip( )

			'' '('
			hExpectAndSkip( TK_LPAREN )

			a = imExpression( is_pp )

			'' ','
			hExpectAndSkip( TK_COMMA )

			var b = imExpression( is_pp )

			'' ','
			hExpectAndSkip( TK_COMMA )

			var c = imExpression( is_pp )

			'' ')'
			hExpectAndSkip( TK_RPAREN )

			a = astNew( ASTCLASS_IIF, a, b, c )

		case else
			imOops( )
		end select
	end if

	'' Infix operators
	do
		select case as const( tkGet( x ) )
		case KW_ORELSE   : astclass = ASTCLASS_LOGOR  '' ORELSE
		case KW_ANDALSO  : astclass = ASTCLASS_LOGAND '' ANDALSO
		case KW_OR       : astclass = ASTCLASS_BITOR  '' OR
		case KW_XOR      : astclass = ASTCLASS_BITXOR '' XOR
		case KW_AND      : astclass = ASTCLASS_BITAND '' AND
		case TK_EQ       : astclass = ASTCLASS_EQ     '' =
		case TK_LTGT     : astclass = ASTCLASS_NE     '' <>
		case TK_LT       : astclass = ASTCLASS_LT     '' <
		case TK_LTEQ     : astclass = ASTCLASS_LE     '' <=
		case TK_GT       : astclass = ASTCLASS_GT     '' >
		case TK_GTEQ     : astclass = ASTCLASS_GE     '' >=
		case KW_SHL      : astclass = ASTCLASS_SHL    '' SHL
		case KW_SHR      : astclass = ASTCLASS_SHR    '' SHR
		case TK_PLUS     : astclass = ASTCLASS_ADD    '' +
		case TK_MINUS    : astclass = ASTCLASS_SUB    '' -
		case TK_STAR     : astclass = ASTCLASS_MUL    '' *
		case TK_SLASH    : astclass = ASTCLASS_DIV    '' /
		case KW_MOD      : astclass = ASTCLASS_MOD    '' MOD
		case else        : exit do
		end select

		'' Higher/same level means process now (takes precedence),
		'' lower level means we're done and the parent call will
		'' continue. The first call will start with level 0.
		var oplevel = fbopinfo(astclass).level
		if( oplevel < level ) then
			exit do
		end if
		if( fbopinfo(astclass).is_leftassoc ) then
			oplevel += 1
		end if

		'' operator
		hSkip( )

		'' rhs
		var b = imExpression( is_pp, oplevel )

		a = astNew( astclass, a, b )
	loop

	function = a
end function

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

private function imPPDirective( ) as ASTNODE ptr
	'' '#'
	hSkip( )

	var tk = tkGet( x )
	select case( tk )
	case KW_DEFINE
		hSkip( )

		'' Identifier
		hExpect( TK_ID )
		function = astNew( ASTCLASS_PPDEFINE, tkGetText( x ) )
		hSkip( )

	case KW_INCLUDE
		hSkip( )

		'' "filename"
		hExpect( TK_STRING )
		function = astNew( ASTCLASS_PPINCLUDE, tkGetText( x ) )
		hSkip( )

	case KW_IF, KW_ELSEIF
		hSkip( )

		'' Expression
		var t = imExpression( TRUE )

		function = astNew( iif( tk = KW_IF, ASTCLASS_PPIF, ASTCLASS_PPELSEIF ), t )

	case KW_IFDEF, KW_IFNDEF
		hSkip( )

		'' Identifier?
		hExpect( TK_ID )
		var t = astNew( ASTCLASS_ID, tkGetText( x ) )
		hSkip( )

		t = astNew( ASTCLASS_DEFINED, t )
		if( tk = KW_IFNDEF ) then
			t = astNew( ASTCLASS_LOGNOT, t )
		end if
		function = astNew( ASTCLASS_PPIF, t )

	case KW_ELSE
		hSkip( )
		function = astNew( ASTCLASS_PPELSE )

	case KW_ENDIF
		hSkip( )
		function = astNew( ASTCLASS_PPENDIF )

	case else
		imOops( )
	end select

	hExpectAndSkip( TK_EOL )
end function

private sub imConstMod( byref dtype as integer )
	'' [CONST]
	if( tkGet( x ) = KW_CONST ) then
		hSkip( )
		dtype = typeSetIsConst( dtype )
	end if
end sub

private sub imDataType( byref dtype as integer, byref subtype as ASTNODE ptr )
	dtype = TYPE_NONE
	subtype = NULL

	'' [CONST]
	var is_const = hMatch( KW_CONST )

	'' base data type
	select case( tkGet( x ) )
	case KW_ANY      : dtype = TYPE_ANY      : hSkip( )
	case KW_BYTE     : dtype = TYPE_BYTE     : hSkip( )
	case KW_UBYTE    : dtype = TYPE_UBYTE    : hSkip( )
	case KW_SHORT    : dtype = TYPE_SHORT    : hSkip( )
	case KW_USHORT   : dtype = TYPE_USHORT   : hSkip( )
	case KW_LONG     : dtype = TYPE_LONG     : hSkip( )
	case KW_ULONG    : dtype = TYPE_ULONG    : hSkip( )
	case KW_INTEGER  : dtype = TYPE_INTEGER  : hSkip( )
	case KW_UINTEGER : dtype = TYPE_UINTEGER : hSkip( )
	case KW_LONGINT  : dtype = TYPE_LONGINT  : hSkip( )
	case KW_ULONGINT : dtype = TYPE_ULONGINT : hSkip( )
	case KW_SINGLE   : dtype = TYPE_SINGLE   : hSkip( )
	case KW_DOUBLE   : dtype = TYPE_DOUBLE   : hSkip( )
	case KW_ZSTRING  : dtype = TYPE_ZSTRING  : hSkip( )
	case TK_ID       : dtype = TYPE_UDT      : hSkip( )

	'' TYPEOF '(' DataType ')'
	case KW_TYPEOF
		hSkip( )

		'' '('
		hExpectAndSkip( TK_LPAREN )

		'' DataType
		imDataType( dtype, subtype )

		'' ')'
		hExpectAndSkip( TK_RPAREN )

	'' [DECLARE] SUB|FUNCTION '(' Parameters ')' [AS FunctionResultDataType]
	'' (function pointer types)
	'' Special syntax: Allowing DECLARE in data type to indicate a procedure
	'' type instead of a procedure pointer type.
	case KW_DECLARE, KW_SUB, KW_FUNCTION
		var is_declare = FALSE
		if( tkGet( x ) = KW_DECLARE ) then
			is_declare = TRUE
			hSkip( )
		end if

		dtype = iif( is_declare, TYPE_PROC, typeAddrOf( TYPE_PROC ) )
		subtype = imProcDecl( TRUE )

	case else
		imOops( )
	end select

	if( is_const ) then
		dtype = typeSetIsConst( dtype )
	end if

	'' ([CONST] PTR)*
	do
		'' [CONST]
		is_const = hMatch( KW_CONST )

		'' PTR?
		if( hMatch( KW_PTR ) = FALSE ) then
			if( is_const ) then
				imOops( )
			end if
			exit do
		end if
		dtype = typeAddrOf( dtype )

		if( is_const ) then
			dtype = typeSetIsConst( dtype )
		end if
	loop
end sub

enum
	DECL_DIMSHARED = 0
	DECL_DIMEXTERN
	DECL_EXTERN
	DECL_PARAM
	DECL_FIELD
end enum

private function imVarDecl( byval decl as integer ) as ASTNODE ptr
	dim as string id

	'' [Identifier]
	if( decl = DECL_PARAM ) then
		if( tkGet( x ) = TK_ID ) then
			id = *tkGetText( x )
			hSkip( )
		end if
	else
		hExpect( TK_ID )
		id = *tkGetText( x )
		hSkip( )
	end if

	dim as integer astclass
	select case( decl )
	case DECL_DIMSHARED, DECL_DIMEXTERN, DECL_EXTERN
		astclass = ASTCLASS_VAR
	case DECL_PARAM
		astclass = ASTCLASS_PARAM
	case DECL_FIELD
		astclass = ASTCLASS_FIELD
	case else
		assert( FALSE )
	end select
	var t = astNew( astclass, id )

	select case( decl )
	case DECL_EXTERN
		t->attrib or= ASTATTRIB_EXTERN
	case DECL_DIMSHARED
		t->attrib or= ASTATTRIB_PRIVATE
	end select

	'' AS
	hExpectAndSkip( KW_AS )

	'' DataType
	imDataType( t->dtype, t->subtype )

	function = t
end function

private function imTypeMemberOrPP( ) as ASTNODE ptr
	select case( tkGet( x ) )
	case TK_HASH  '' #
		function = imPPDirective( )
	case KW_TYPE, KW_UNION
		'' Disambiguate: type AS DataType vs. TYPE : ... : END TYPE
		if( tkGet( imSkip( x ) ) <> KW_AS ) then
			function = imStructCompound( )
		else
			function = imVarDecl( DECL_FIELD )
		end if
	case else
		function = imVarDecl( DECL_FIELD )
	end select
end function

private function imStructCompound( ) as ASTNODE ptr
	'' TYPE|UNION
	var topkw = tkGet( x )
	hSkip( )

	'' [Identifier]
	dim as string id
	if( tkGet( x ) = TK_ID ) then
		id = *tkGetText( x )
		hSkip( )
	end if

	hExpectAndSkip( TK_EOL )

	var struct = astNew( iif( topkw = KW_UNION, ASTCLASS_UNION, ASTCLASS_STRUCT ) )

	'' body
	do
		'' END TYPE|UNION?
		if( tkGet( x ) = KW_END ) then
			if( tkGet( imSkip( x ) ) = topkw ) then
				exit do
			end if
		end if

		astAddChild( struct, imTypeMemberOrPP( ) )
	loop

	'' END TYPE|UNION
	hExpectAndSkip( KW_END )
	hExpectAndSkip( topkw )
	hExpectAndSkip( TK_EOL )

	function = struct
end function

'' Identifier ['=' Expression]
private function imEnumConst( ) as ASTNODE ptr
	hExpect( TK_ID )
	var enumconst = astNew( ASTCLASS_ENUMCONST, tkGetText( x ) )
	hSkip( )

	'' '='?
	if( tkGet( x ) = TK_EQ ) then
		hSkip( )

		'' Expression
		astAddChild( enumconst, imExpression( FALSE ) )
	end if

	hExpectAndSkip( TK_EOL )

	function = enumconst
end function

private function imEnumCompound( ) as ASTNODE ptr
	'' ENUM
	hSkip( )

	'' [Identifier]
	dim as string id
	if( tkGet( x ) = TK_ID ) then
		id = *tkGetText( x )
		hSkip( )
	end if

	hExpectAndSkip( TK_EOL )

	var t = astNew( ASTCLASS_ENUM )

	'' body
	do
		'' END ENUM?
		if( tkGet( x ) = KW_END ) then
			if( tkGet( imSkip( x ) ) = KW_ENUM ) then
				exit do
			end if
		end if

		astAddChild( t, imEnumConst( ) )
	loop

	'' END ENUM
	hExpectAndSkip( KW_END )
	hExpectAndSkip( KW_ENUM )
	hExpectAndSkip( TK_EOL )

	function = t
end function

'' '...' | BYVAL [Identifier] AS DataType
private function imParamDecl( ) as ASTNODE ptr
	'' '...'?
	if( tkGet( x ) = TK_ELLIPSIS ) then
		hSkip( )
		function = astNew( ASTCLASS_PARAM )
	else
		'' BYVAL
		hExpectAndSkip( KW_BYVAL )

		function = imVarDecl( DECL_PARAM )
	end if
end function

'' '(' Parameter (',' Parameter)* ')'
private sub imParamList( byval proc as ASTNODE ptr )
	TRACE( x )
	'' '('
	hExpectAndSkip( TK_LPAREN )

	'' not just '()'?
	if( tkGet( x ) <> TK_RPAREN ) then
		do
			TRACE( x )
			'' Parameter
			astAddChild( proc, imParamDecl( ) )

			'' ','?
		loop while( hMatch( TK_COMMA ) )
	end if

	'' ')'
	TRACE( x )
	hExpectAndSkip( TK_RPAREN )
end sub

'' SUB|FUNCTION [Identifier] '(' Parameters ')' [AS FunctionResultDataType]
private function imProcDecl( byval is_procptr as integer ) as ASTNODE ptr
	TRACE( x )

	'' SUB|FUNCTION
	var prockw = tkGet( x )
	select case( prockw )
	case KW_SUB, KW_FUNCTION

	case else
		imOops( )
	end select
	hSkip( )

	TRACE( x )

	dim id as string
	if( is_procptr = FALSE ) then
		'' Identifier
		hExpect( TK_ID )
		id = *tkGetText( x )
		hSkip( )
	end if

	var proc = astNew( ASTCLASS_PROC, id )

	TRACE( x )

	'' '(' Parameters ')'
	imParamList( proc )

	TRACE( x )

	'' [AS FunctionResultDataType]
	if( prockw = KW_FUNCTION ) then
		'' AS
		hExpectAndSkip( KW_AS )

		'' DataType
		imDataType( proc->dtype, proc->subtype )
	end if

	TRACE( x )

	function = proc
end function

private function imCompoundOrStatement( ) as ASTNODE ptr
	TRACE( x )

	select case( tkGet( x ) )
	case TK_HASH  '' #
		function = imPPDirective( )

	case KW_TYPE, KW_UNION
		function = imStructCompound( )

	case KW_ENUM
		function = imEnumCompound( )

	case KW_DIM
		hSkip( )

		'' SHARED|EXTERN
		dim as integer decl
		select case( tkGet( x ) )
		case KW_SHARED
			decl = DECL_DIMSHARED
		case KW_EXTERN
			decl = DECL_DIMEXTERN
		case else
			imOops( )
		end select
		hSkip( )

		function = imVarDecl( decl )

		hExpectAndSkip( TK_EOL )

	case KW_EXTERN
		hSkip( )
		function = imVarDecl( DECL_EXTERN )

		hExpectAndSkip( TK_EOL )

	case KW_DECLARE
		'' DECLARE
		hSkip( )

		function = imProcDecl( FALSE )

		hExpectAndSkip( TK_EOL )

	case TK_EOL
		hSkip( )

	case TK_EOF

	case else
		imOops( )
	end select
end function

private function imToplevel( ) as ASTNODE ptr
	var group = astNew( ASTCLASS_GROUP )

	x = imSkip( -1 )
	while( tkGet( x ) <> TK_EOF )
		astAddChild( group, imCompoundOrStatement( ) )
	wend

	function = group
end function

function importFile( byref file as string ) as ASTNODE ptr
	tkInit( )
	lexLoadFile( 0, file, TRUE )
	function = imToplevel( )
	tkEnd( )
end function
