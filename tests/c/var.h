// @fbfrog -whitespace -nonamefixup

int __a_normal_variable;

static int __a_static_variable;

static int __extern_variables;
extern int a;
extern int *a;
extern int ****a, b, *c, d, e;

static int __initializer;
static int aa = 123;
int bb = 123;
static void *p = 0;
static int (*p)(void) = &f;
static int (*p)(int i = 123) = 0;
static int a[10] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 };

static int __nested_id;
extern int (a);
extern int ((a));
extern int (((a)));
extern int *(a);
extern int ****((a)), (b), *((c)), (d), (e);

static int __nested_declarator;
extern int (*a);
extern int ((****a)), ((*c));

static int __arrays;
static int a[1];
static int a[10];
static int a[2][2];
static int a[2][2][2];
static int a[2][3][4][5][6];
static void (*p[4])(void);
static void (*p[2][3])(void);
int a[10];
extern int a[10];
static int a[10+10+10*2+1];

static int __various_procptr_vars;
extern void (*a)(void);
extern int (*a)(int);
extern int (*a)(int a), (*b)(int a), c;
extern int a, (*b)(int a), c, (*d)(int a);
extern int **(*a)(int);
extern void (*a)(void (*a)(void));
extern int ***(*p)(int ***(*)(int ***));

static int __procptr_nested_declarator;
extern void   (*    p    )   (void);
extern void  ((*    p    ))  (void);
extern void (((*    p    ))) (void);
extern void   (*   (p)   )   (void);
extern void  ((*   (p)   ))  (void);
extern void (((*   (p)   ))) (void);
extern void   (*  ((p))  )   (void);
extern void  ((*  ((p))  ))  (void);
extern void (((*  ((p))  ))) (void);
extern void   (* (((p))) )   (void);
extern void  ((* (((p))) ))  (void);
extern void (((* (((p))) ))) (void);

static int __procptr_nested_declarator_with_consts;
extern void   (* const    p    )   (void);
extern void  ((* const    p    ))  (void);
extern void (((* const    p    ))) (void);
extern void   (* const   (p)   )   (void);
extern void  ((* const   (p)   ))  (void);
extern void (((* const   (p)   ))) (void);
extern void   (* const  ((p))  )   (void);
extern void  ((* const  ((p))  ))  (void);
extern void (((* const  ((p))  ))) (void);
extern void   (* const (((p))) )   (void);
extern void  ((* const (((p))) ))  (void);
extern void (((* const (((p))) ))) (void);

static int __procptrptr_nested_declarator;
extern void   (*   (*    p    )   )  (void);
extern void  ((*   (*    p    )   )) (void);
extern void (((*   (*    p    )   )))(void);
extern void   (*  ((*    p    ))  )  (void);
extern void  ((*  ((*    p    ))  )) (void);
extern void (((*  ((*    p    ))  )))(void);
extern void   (* (((*    p    ))) )  (void);
extern void  ((* (((*    p    ))) )) (void);
extern void (((* (((*    p    ))) )))(void);
extern void   (*   (*   (p)   )   )  (void);
extern void  ((*   (*   (p)   )   )) (void);
extern void (((*   (*   (p)   )   )))(void);
extern void   (*  ((*   (p)   ))  )  (void);
extern void  ((*  ((*   (p)   ))  )) (void);
extern void (((*  ((*   (p)   ))  )))(void);
extern void   (* (((*   (p)   ))) )  (void);
extern void  ((* (((*   (p)   ))) )) (void);
extern void (((* (((*   (p)   ))) )))(void);
extern void   (*   (*  ((p))  )   )  (void);
extern void  ((*   (*  ((p))  )   )) (void);
extern void (((*   (*  ((p))  )   )))(void);
extern void   (*  ((*  ((p))  ))  )  (void);
extern void  ((*  ((*  ((p))  ))  )) (void);
extern void (((*  ((*  ((p))  ))  )))(void);
extern void   (* (((*  ((p))  ))) )  (void);
extern void  ((* (((*  ((p))  ))) )) (void);
extern void (((* (((*  ((p))  ))) )))(void);
extern void   (*   (* (((p))) )   )  (void);
extern void  ((*   (* (((p))) )   )) (void);
extern void (((*   (* (((p))) )   )))(void);
extern void   (*  ((* (((p))) ))  )  (void);
extern void  ((*  ((* (((p))) ))  )) (void);
extern void (((*  ((* (((p))) ))  )))(void);
extern void   (* (((* (((p))) ))) )  (void);
extern void  ((* (((* (((p))) ))) )) (void);
extern void (((* (((* (((p))) ))) )))(void);

static int __procptrptr_nested_declarator_consts_1;
extern void   (*   (* const    p    )   )  (void);
extern void  ((*   (* const    p    )   )) (void);
extern void (((*   (* const    p    )   )))(void);
extern void   (*  ((* const    p    ))  )  (void);
extern void  ((*  ((* const    p    ))  )) (void);
extern void (((*  ((* const    p    ))  )))(void);
extern void   (* (((* const    p    ))) )  (void);
extern void  ((* (((* const    p    ))) )) (void);
extern void (((* (((* const    p    ))) )))(void);
extern void   (*   (* const   (p)   )   )  (void);
extern void  ((*   (* const   (p)   )   )) (void);
extern void (((*   (* const   (p)   )   )))(void);
extern void   (*  ((* const   (p)   ))  )  (void);
extern void  ((*  ((* const   (p)   ))  )) (void);
extern void (((*  ((* const   (p)   ))  )))(void);
extern void   (* (((* const   (p)   ))) )  (void);
extern void  ((* (((* const   (p)   ))) )) (void);
extern void (((* (((* const   (p)   ))) )))(void);
extern void   (*   (* const  ((p))  )   )  (void);
extern void  ((*   (* const  ((p))  )   )) (void);
extern void (((*   (* const  ((p))  )   )))(void);
extern void   (*  ((* const  ((p))  ))  )  (void);
extern void  ((*  ((* const  ((p))  ))  )) (void);
extern void (((*  ((* const  ((p))  ))  )))(void);
extern void   (* (((* const  ((p))  ))) )  (void);
extern void  ((* (((* const  ((p))  ))) )) (void);
extern void (((* (((* const  ((p))  ))) )))(void);
extern void   (*   (* const (((p))) )   )  (void);
extern void  ((*   (* const (((p))) )   )) (void);
extern void (((*   (* const (((p))) )   )))(void);
extern void   (*  ((* const (((p))) ))  )  (void);
extern void  ((*  ((* const (((p))) ))  )) (void);
extern void (((*  ((* const (((p))) ))  )))(void);
extern void   (* (((* const (((p))) ))) )  (void);
extern void  ((* (((* const (((p))) ))) )) (void);
extern void (((* (((* const (((p))) ))) )))(void);

static int __procptrptr_nested_declarator_consts_2;
extern void   (* const   (*    p    )   )  (void);
extern void  ((* const   (*    p    )   )) (void);
extern void (((* const   (*    p    )   )))(void);
extern void   (* const  ((*    p    ))  )  (void);
extern void  ((* const  ((*    p    ))  )) (void);
extern void (((* const  ((*    p    ))  )))(void);
extern void   (* const (((*    p    ))) )  (void);
extern void  ((* const (((*    p    ))) )) (void);
extern void (((* const (((*    p    ))) )))(void);
extern void   (* const   (*   (p)   )   )  (void);
extern void  ((* const   (*   (p)   )   )) (void);
extern void (((* const   (*   (p)   )   )))(void);
extern void   (* const  ((*   (p)   ))  )  (void);
extern void  ((* const  ((*   (p)   ))  )) (void);
extern void (((* const  ((*   (p)   ))  )))(void);
extern void   (* const (((*   (p)   ))) )  (void);
extern void  ((* const (((*   (p)   ))) )) (void);
extern void (((* const (((*   (p)   ))) )))(void);
extern void   (* const   (*  ((p))  )   )  (void);
extern void  ((* const   (*  ((p))  )   )) (void);
extern void (((* const   (*  ((p))  )   )))(void);
extern void   (* const  ((*  ((p))  ))  )  (void);
extern void  ((* const  ((*  ((p))  ))  )) (void);
extern void (((* const  ((*  ((p))  ))  )))(void);
extern void   (* const (((*  ((p))  ))) )  (void);
extern void  ((* const (((*  ((p))  ))) )) (void);
extern void (((* const (((*  ((p))  ))) )))(void);
extern void   (* const   (* (((p))) )   )  (void);
extern void  ((* const   (* (((p))) )   )) (void);
extern void (((* const   (* (((p))) )   )))(void);
extern void   (* const  ((* (((p))) ))  )  (void);
extern void  ((* const  ((* (((p))) ))  )) (void);
extern void (((* const  ((* (((p))) ))  )))(void);
extern void   (* const (((* (((p))) ))) )  (void);
extern void  ((* const (((* (((p))) ))) )) (void);
extern void (((* const (((* (((p))) ))) )))(void);

static int __procptrptr_nested_declarator_consts_3;
extern void   (* const   (* const    p    )   )  (void);
extern void  ((* const   (* const    p    )   )) (void);
extern void (((* const   (* const    p    )   )))(void);
extern void   (* const  ((* const    p    ))  )  (void);
extern void  ((* const  ((* const    p    ))  )) (void);
extern void (((* const  ((* const    p    ))  )))(void);
extern void   (* const (((* const    p    ))) )  (void);
extern void  ((* const (((* const    p    ))) )) (void);
extern void (((* const (((* const    p    ))) )))(void);
extern void   (* const   (* const   (p)   )   )  (void);
extern void  ((* const   (* const   (p)   )   )) (void);
extern void (((* const   (* const   (p)   )   )))(void);
extern void   (* const  ((* const   (p)   ))  )  (void);
extern void  ((* const  ((* const   (p)   ))  )) (void);
extern void (((* const  ((* const   (p)   ))  )))(void);
extern void   (* const (((* const   (p)   ))) )  (void);
extern void  ((* const (((* const   (p)   ))) )) (void);
extern void (((* const (((* const   (p)   ))) )))(void);
extern void   (* const   (* const  ((p))  )   )  (void);
extern void  ((* const   (* const  ((p))  )   )) (void);
extern void (((* const   (* const  ((p))  )   )))(void);
extern void   (* const  ((* const  ((p))  ))  )  (void);
extern void  ((* const  ((* const  ((p))  ))  )) (void);
extern void (((* const  ((* const  ((p))  ))  )))(void);
extern void   (* const (((* const  ((p))  ))) )  (void);
extern void  ((* const (((* const  ((p))  ))) )) (void);
extern void (((* const (((* const  ((p))  ))) )))(void);
extern void   (* const   (* const (((p))) )   )  (void);
extern void  ((* const   (* const (((p))) )   )) (void);
extern void (((* const   (* const (((p))) )   )))(void);
extern void   (* const  ((* const (((p))) ))  )  (void);
extern void  ((* const  ((* const (((p))) ))  )) (void);
extern void (((* const  ((* const (((p))) ))  )))(void);
extern void   (* const (((* const (((p))) ))) )  (void);
extern void  ((* const (((* const (((p))) ))) )) (void);
extern void (((* const (((* const (((p))) ))) )))(void);

void f1(void) {
	int a;
	static int b;
}
