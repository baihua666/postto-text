[TOC]

##package.json
字效定义,定义于源码 TextEffectLoader.cpp
```
{
	"name":string,
    "version":integer,
    "preview":string,
    "variable":{
    	string:float,
        ...
    },
    "total_time":integer,
    "resource":{
    	"shader":{
        	id:object,
            ...
        },
        "program":{
        	id:object,
            ...
        },
        "texture":{
        	id:object,
            ...
        },
        "glyph":{
        	id:object,
            ...
        },
        "color":{
        	id:object,
            ...
        },
        "curve":{
        	id:object,
            ...
        }
    },
    "section":object,
    "line":object,
    "char":object
}
```
###name
名字
###version
版本
###preview
预览文件的相对路径
###variable
变量定义
###total_time
总时长(毫秒)


###shader
[shader](#shader)定义
###program
[program](#program)定义
###texture
[纹理](#tex)定义
###glyph
[字模纹理](#glyph)定义
###color
[颜色](#color)定义
###curve
[曲线](#curve)定义

###section
[section](#sectionlayout)布局定义

###line
[line](#linelayou)布局定义

###char
[char](#charlayout)布局定义


##<a name="layoutpiece"></a>layout piece
布局对象的定义, 定义于源码 LayoutPiece.cpp
```
{
	"create_at":expression,
    "destroy_at":expression,
    "alpha":expression,
    "transaction":{
    	"translate":[expression, expression],
        "scale":[expression, expression],
        "rotate":[expression, expression, expression, expression, expression]
    },
    "model_size":[expression, expression],
    "animation":[object,...],
}
```
###create_at
基于布局对象的创建时间（毫秒）
###destroy_at
基于布局对象的销毁时间（毫秒）
###alpha
对象的alpha值
###transaction
基于布局对象的位置
####translate
中心点相对布局对象中心点的偏移
####scale
大小相对布局对象的缩放
####rotate
相对布局对象的旋转
+ 旋转不变点的横坐标
+ 旋转不变点的纵坐标
+ 与x轴夹角
+ 与y轴夹角
+ 与z轴夹角


###model_size
在该对象坐标系中，渲染模型的包围矩形的宽高
###animtion
定义该对象上的[动画](#anim)

###可用变量
定义于源码 LayoutPiece.cpp
+ obj.alpha
+ obj.translate.x
+ obj.translate.y
+ obj.scale.x
+ obj.scale.y
+ obj.rotate.cx
+ obj.rotate.cy
+ obj.rotate.angle.x
+ obj.rotate.angle.y
+ obj.rotate.angle.z
+ obj.model_size.x
+ obj.model_size.y

##<a name="sectionlayout"></a>section layout
```
{
	layoutpiece,
    "pieces":[
    	object,...
    ]
}
```
继承自[layout piece](#layoutpiece)
###pieces
定义section layout上的[渲染对象](#renderpiece)
###可用变量
定义于源码SectionPieceContext.cpp
+ 继承layout piece的可用变量
+ section.line_count
+ section.char_count
+ section.in_canvas.translate.x
+ section.in_canvas.translate.y
+ section.in_canvas.scale.x
+ section.in_canvas.scale.y


##<a name="linelayout"></a>line layout
```
{
	layoutpiece,
    "pieces":[
    	object,...
    ]
}
```
继承自[layout piece](#layoutpiece)
###pieces
定义line layout上的[渲染对象](#renderpiece)
###可用变量
定义于源码LinePieceContext.cpp
+ 继承section layout 的可用变量
+ line.char_count
+ line.in_section.index
+ line.in_canvas.translate.x
+ line.in_canvas.translate.y
+ line.in_canvas.scale.x
+ line.in_canvas.scale.y
+ line.in_section.translate.x
+ line.in_section.translate.y
+ line.in_section.scale.x
+ line.in_section.scale.y

##<a name="charlayout"></a>char layout
```
{
	layoutpiece,
    "pieces":[
    	object,...
    ]
}
```
继承自[layout piece](#layoutpiece)
###pieces
定义char layout上的[渲染对象](#renderpiece)
###可用变量
定义于源码CharPieceContext.cpp
+ 继承line layout 的可用变量
+ char.in_section.index
+ char.in_line.index
+ char.in_canvas.translate.x
+ char.in_canvas.translate.y
+ char.in_canvas.scale.x
+ char.in_canvas.scale.y
+ char.in_section.translate.x
+ char.in_section.translate.y
+ char.in_section.scale.x
+ char.in_section.scale.y
+ char.in_line.translate.x
+ char.in_line.translate.y
+ char.in_line.scale.x
+ char.in_line.scale.y
+ 

##<a name="renderpiece"></a>render piece
渲染对象, 定义于源码RenderPieceContext.cpp
```
{
	"zorder":expression,
    "create_if":expression,
    "textures":[
    	{
        	"id":string,
        	"region":{
            	"left":expression,
                "top":expression,
                "width":expression,
                "height":expression
            },
            "progress":expression
        },
        ...
    ],
    "colors":[string,...],
    "program_id":string
}
```
###zorder
渲染对象的zorder值
###create_if
当该条件表达式满足时，该对象才会创建
###textures
该对象使用的纹理对象的id，包含已定义的texture；如果该对象位于char layout上，还可包含已定义的glyph
####id
引用的纹理对象的id
####region
纹理对象的区域，完整区域为0,0,1,1,缺省为完整区域
####progress
纹理的进度，对于不变的纹理，progress不起作用；对于关键帧纹理，progress指定了使用第几帧的图像
###colors
该对象使用的颜色的id，包含已定义的color
###program_id
该对象使用的程序id，包含已定义的program
###可用变量
定义于源码RenderPieceContext.cpp
+ 继承该对象处于的layout的可用变量


##<a name="anim"></a>animation
动画定义
```
{
	"type":string,
    "start_time":expression,
    "loop":expression,
    "loop_wait_time":expression
}
```
###type
动画的类型
###start_time
相对于对象创建时间的动画开始时间（毫秒）
###loop
循环次数
###loop_wait_time
一次循环之后开始下一次循环之前的等待时间（毫秒）
###可用变量
+ 继承对象的可用变量
+ anim.cur_loop
+ anim.loop

###动画类型
####复合动画
```
{
	animation,
    "sub":[objection,...]
}
```
+ sub定义要复合的各子动画（也可以为复合动画）

#####serial
串行,顺次执行子动画，上一个执行完了所有loop之后执行一下个


####值动画
```
{
	animation,
    "duration":expression,
    "curve_id":string,
    "value":[expression,...]
}
```
+ duration 定义动画的持续时间（毫秒）
+ curve_id 定义动画使用差值曲线，包含在curve中定义的曲线id
+ value 定义目标值的数组

#####alpha
value指定对象 alpha的目标值
#####translate
value指定对象 translate的目标值
#####scale
value指定对象 scale的目标值
#####rotate
value指定对象 rotate的目标值
#####model_size
value指定对象 model size的目标值
#####tex_progress
```
{
	value animation,
    "tex_index":integer
}
```
+ tex_index 指定动画作用的纹理索引（在对象的textures中第几个定义的纹理）

#####tex_region
```
{
	value animation,
    "tex_index":integer
}
```
+ tex_index 指定动画作用的纹理索引（在对象的textures中第几个定义的纹理）


##<a name="tex"></a>texture
定义纹理
```
{
	"type":string
}
```
+ type 纹理的类型

###key_region
按区域划分的关键帧纹理，整张位图切分为若干相同大小的区域，每个区域为一帧
```
{
	"type":"key_region",
	"path":string,
    "hor_frame":integer,
    "ver_frame":integer
}
```
+ path 指定纹理图片的相对路径
+ hor_frame 指定图片中每行包含的帧数， 缺省为1
+ ver_frame 指定图片中每列包含的帧数， 缺省位1


##<a name="glyph"></a>glyph
定义字模纹理，字模纹理只能被位于 char layout 中的渲染对象使用， 字模纹理包含若干字符对应的不同纹理， 渲染对象使用该对象位于的char layout对应的字符在字模纹理中对应的纹理； 比如字体中对应的字模。
```
{
	"type":string
}
```
+ type 字模纹理的类型

###font
定义字体中的完整字模纹理
```
{
	"type":"font",
    "color_space":string,
    "color_id":string
}
```
+ color_space 颜色空间值
	+ "gray": 字模的灰度纹理
	+ "rgba": 字模使用指定32位颜色值渲染得到的纹理，颜色值由 color_id指定
+ color_id 渲染字模使用的颜色值，包含已经在color中定义的id

###font_path
与font 字模纹理配置相同，不同的是，font_path是关键帧纹理，对应progress的纹理图像是ttf字体对应进度的字模部分路径，用于模拟笔画效果
```
{
	"type":"font",
    "color_space":string,
    "color_id":string
}
```

##<a name="color"></a>color
定义颜色值

###直接定义的颜色值
```
[r,g,b,a]
```
通过分量值（0~255）定义颜色值

###混合颜色值
通过将以定义的颜色以指定方式改变得到新的颜色
```
{
	"type":string
}
```
+ type 指定混合颜色的方式

####mix
alpha混合多种颜色
```
{
	"type":"mix",
    "source":[{"color":[r,g,b,a], "color_id":string, "alpha":integer},...]
}
```
+ source指定要混合的多个颜色，以定义顺序相反的顺序逐个混合
	+ color 和 color_id 分别以直接定义和引用已定义的颜色的方式指定要混合的颜色，二者选其一
	+ alpha 定义该颜色混合时的const alpha值(0~255)


##<a name="curve"></a>curve
定义曲线
```
{
	"type":string
}
```
+ type 曲线的类型

###bezier
三次贝塞尔曲线
```
{
	"type":"bezier",
    "control":[float, float, float, float]
}
```
+ control 预定义曲线的两个端点分别为(0,0), (1,1), 顺次定义控制点1的x,y 和控制点2的x,y;访问[http://cubic-bezier.com](http://cubic-bezier.com) 可视化的生成控制点的值


##<a name="shader"></a>shader
定义着色器代码片段
```
{
	"type":string,
    "source":string
}
```
+ type 着色器的类型
	+ "vs": 顶点着色器
	+ "fs": 片段着色器
+ source 代码的相对路径

##<a name="program"></a>program
```
{
	"vs":string,
    "vs_id":string,
    "fs":string,
    "fs_id":string
}
```
+ vs 和 vs_id 定义program的顶点着色器，通过源码路径或已定义的着色器id指定，二者选其一
+ fs 和 fs_id 定义program的片段着色器，通过源码路径或已定义的着色器id指定，二者选其一


##<a name="exp"></a>expression
表达式, 定义于源码Expression.cpp, ConditionEpxression.cpp
+ <a name="singleexp"></a>single expression
string 单一表达式，可用的运算符包括：
	+ 四则运算符 + - * /
	+ 取负单目运算符 -
	+ 结合符号 ()
	+ 取余 %
	+ 取随机数 #
	+ 双目逻辑运算符 && || == != > >= < <=
	+ 取反单目逻辑运算符 !
+ <a name="conexp"></a>condition expression
```
{
	single expression:expression,
    ...
    "default":expression
}
```
key为[条件表达式](#singleexp), value为该条件下的[值表达式](#exp)；计算时，首先顺次计算条件表达式，当结果为true时，执行对应的值表达式作为结果；如果没有任何条件表达式为true，执行"default"对应的值表达式。


##预定义的资源
###预定义的shader
定义于源代码DefaultShader.cpp
+ "vs.default" 预定义的顶点着色器
+ "fs.default.first_texture" 渲染第一个纹理
+ "fs.default.first_color" 渲染第一个颜色
+ "fs.default.first_color_first_mask" 以第一个纹理为mask渲染第一个颜色

###预定义的color
+ "color.font" 指定的字体颜色
