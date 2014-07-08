// @fbfrog -select -case __FB_DOS__ -define DOS -case __FB_LINUX__ -define LINUX -case __FB_WIN32__ -define WIN32 -endselect

static int vardoslinuxwin32;

#ifdef DOS
	static int vardos;
	struct UDTdos {
		int fielddos;
	};
#elif defined LINUX
	static int varlinux;
	struct UDTlinux {
		int fieldlinux;
	};
#elif defined WIN32
	static int varwin32;
	struct UDTwin32 {
		int fieldwin32;
	};
#else
	#error "invalid target"
#endif

#if defined DOS || defined LINUX
	static int vardoslinux;

	struct UDTdoslinux1 {
		int fielddoslinux;
	};

	struct UDTdoslinux2 {
		#ifdef DOS
			int fielddos;
		#else
			int fieldlinux;
		#endif
	};
#endif

struct UDTdoslinuxwin32 {
	int fielddoslinuxwin32;
};

struct UDTfielddoslinuxwin32 {
	#ifdef DOS
		int fielddos;
	#elif defined LINUX
		int fieldlinux;
	#elif defined WIN32
		int fieldwin32;
	#endif
};
