#ifndef TEST_H
#define TEST_H

#define A               1
#define B               2
#define C _
                        3

/' PP expressions '/
#if (!defined(FOO_BAR) && THIS_IS_INSANE >= 123) _
    || (OH_MAN_WHATS_THE_PRECEDENCE < 5 && (defined(OK) _
                                            || defined(I_DONT_KNOW)))
	#define PPMERGE(a, b) a##b
	#define PPSTRINGIZE(a) #a

#	if X == 4294967295UL || X == 0.1e+1
#		define HOORAY
#	endif
#endif

#endif