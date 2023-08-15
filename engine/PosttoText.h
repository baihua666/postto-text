#ifndef __POSTTO_TEXT_POSTTO_TEXT_H__
#define __POSTTO_TEXT_POSTTO_TEXT_H__

#define POSTTO_TEXT_ERROR_SUCCESS			0
#define POSTTO_TEXT_ERROR_UNKNOWN			-1
#define POSTTO_TEXT_ERROR_EFFECT_NOT_EXIST	-100

//当前字体不支持的字符
#define POSTTO_TEXT_ERROR_CHARACTER_NOT_SUPPORT_BY_FONT	-200

#define POSTTO_TEXT_EXPORT(ret)				ret

#ifdef __cplusplus
extern "C" {
#endif

	//ptt short for postto text
	typedef struct tagPttRect
	{
		int left;
		int top;
		int width;
		int height;
	} pttRect;

	typedef struct tagPttSize
	{
		int width;
		int height;
	} pttSize;

#define POSTTO_TEXT_EFFECT_FLAG_STROKE		1
#define POSTTO_TEXT_EFFECT_FLAG_SHADOW		(1<<1)

	typedef struct tagPttFontConfig
	{
		//RGBA
		uint32_t color;
		int32_t flag;
	} pttFontConfig;

	typedef struct tagPttEffectConfig
	{
		pttFontConfig fontConfig;
	} pttEffectConfig;
//change by tb, IOS表情字符使用两个字符表示,
//    	typedef uint32_t pttUniChar;
//	typedef uint16_t pttUniChar;
    
    typedef struct tagPttUniChar
    {
        void* data;
        char length;
    } pttUniChar;
    
	POSTTO_TEXT_EXPORT(const char*) pttVersionName();
	POSTTO_TEXT_EXPORT(int) pttVersion();

	POSTTO_TEXT_EXPORT(int) pttInitialize(
		const char* szFontDir,
		const char* szEffectDir);
	POSTTO_TEXT_EXPORT(void) pttUninitialize();

	POSTTO_TEXT_EXPORT(int) pttLoadAllEffect();
	POSTTO_TEXT_EXPORT(unsigned int) pttGetEffectCount();
	POSTTO_TEXT_EXPORT(const char*) pttGetEffectName(unsigned int ix);

	POSTTO_TEXT_EXPORT(int) pttLoadEffect(const char* szName);
	POSTTO_TEXT_EXPORT(unsigned int) pttGetEffectDirCount();
	POSTTO_TEXT_EXPORT(const char*) pttGetEffectNameInDir(unsigned int index);

	typedef struct tagPttFontSize
	{
		short pixelWidth;
		short pixelHeight;
		float pointWidth;
		float pointHeight;
	} pttFontSize;
    
    //字体阴影
    typedef struct tagPttShadow
    {
        pttSize shadowOffset;      // offset in user space of the shadow from the original drawing
        int shadowBlurRadius; // blur radius of the shadow in default user space units
        uint32_t shadowColor;
    } pttShadow;

	typedef void* pttSection;
	POSTTO_TEXT_EXPORT(int) pttCreateSection(
		pttSection* lpSection,
		const pttSize* lpCanvasSize,
		const pttRect* lpRegion,
		float angle,
		const char* szFontName,
		const pttFontSize* lpFontSize,
		const char* szEffectName,
		const pttEffectConfig *lpConfig);
	POSTTO_TEXT_EXPORT(void) pttReleaseSection(
		pttSection section
	);

	typedef void* pttLine;
	POSTTO_TEXT_EXPORT(int) pttAddLineToSection(
		pttSection section,
		pttLine* lpLine,
		const pttRect* lpRegion);
	POSTTO_TEXT_EXPORT(void) pttReleaseLine(
		pttLine line
	);

	POSTTO_TEXT_EXPORT(int) pttAddCharToLine(
		pttLine line,
		pttUniChar * lpChar,
		const pttRect* lpRegion
	);

	typedef void* pttAnimator;
	POSTTO_TEXT_EXPORT(int) pttCreateAnim(
		pttAnimator* lpAnim
	);
	POSTTO_TEXT_EXPORT(void) pttReleaseAnim(
		pttAnimator anim
	);
	POSTTO_TEXT_EXPORT(int) pttAddSectionToAnim(
		pttAnimator anim,
		pttSection section
	);
	POSTTO_TEXT_EXPORT(int) pttStartAnim(
		pttAnimator anim
	);
	POSTTO_TEXT_EXPORT(int) pttAnimElapseTime(
		pttAnimator anim,
		unsigned int ms
	);
	POSTTO_TEXT_EXPORT(int) pttRenderAnim(
		pttAnimator anim
	);

	POSTTO_TEXT_EXPORT(void) pttResetAnim(
		pttAnimator anim
	);
    
    POSTTO_TEXT_EXPORT(void) pttGetShadow(
        pttShadow * lpPttShadow
    );
    
    POSTTO_TEXT_EXPORT(unsigned int) pttGetTotalTime(
        pttAnimator anim
    );
    
    //获取自定义变量的值
    POSTTO_TEXT_EXPORT(int) pttGetFloatVariable(
        const char* szEffectName,
        const char* szVariableName,
        float* lpValue
    );


    //创建CHAR
    pttUniChar* pttInitUniChar(char length);
    
    //销毁CHAR
    void pttReleaseUniChar(pttUniChar* lpPttUniChar);

#ifdef POSTTO_TEXT_PLATFORM_IOS 
#ifdef __OBJC__
#define OBJC_CLASS(name) @class name
#else
#define OBJC_CLASS(name) typedef struct objc_object name
#endif

	OBJC_CLASS(NSAttributedString);
    OBJC_CLASS(NSShadow);


    /// lpFrame
    //画布大小，对应GLVIEWPORT的大小
    //不能设置太大，否则会导致OPENGL性能消耗变大，内存使用过大导致程序会被系统回收
	POSTTO_TEXT_EXPORT(int) pttCreateSectionFromString(
		pttSection* lpSection,
		const CGSize* lpFrame,
		NSAttributedString* attrstr,
		const CGRect* lpRegion,
        float angle,
		const char *szEffectName,
		const pttEffectConfig *lpConfig);

	POSTTO_TEXT_EXPORT(int) pttAddLineFromString(
		pttSection Section,
		pttLine* lpLine,
		NSAttributedString* attrstr,
		const CGRect* lpRegion);
    
    POSTTO_TEXT_EXPORT(NSShadow*) pttGetSystemShadow();
    
    
#endif //POSTTO_TEXT_PLATFORM_IOS


#ifdef __cplusplus
}
#endif

#endif //__POSTTO_TEXT_POSTTO_TEXT_H__
