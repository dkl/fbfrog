#pragma once

extern "C"

const A = 1

#define B() 1
#define C(a) 1
#define D f()
#define E A

type UDT1
	field as long
end type

const FIELD_1 = 1
const FIELD_2 = 2
const A1 = 1
const A2 = 1 + (2 * 3)

#define B1(x) x
#define B2() x
#define B3
#define C1 x

declare sub cool2(byval as long)

#define C2 cool2(1)
#define D1 sizeof(long)

end extern
