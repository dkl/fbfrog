extern "C"

#define INT_(x) x

enum
	AND_ = 0
	OR_ = AND_
	XOR_ = OR_ + 1
end enum

extern     array1(0 to 0) as long
dim shared array1(0 to 0) as long

#define A1 INT_(1)

type DOUBLE_
	a as DOUBLE ptr
end type

declare sub f(byval as DOUBLE)

end extern