//
//  CircleProgressView.h
//  环形颜色渐变进度条制作
//
//  Created by yun xiao on 2018/6/7.
//  Copyright © 2018年 zwl. All rights reserved.
//

#import <UIKit/UIKit.h>

//相关代码解释：https://www.jianshu.com/p/e580ab789a21

//版本号
#define CPVersion @"1.1.1"

//将角度数值转化为角度 d(0-360)
#define CircleDegreeToRadian(d) (d)*(M_PI/180.0)

@interface CircleProgressView : UIView

#pragma mark 按制作由简到繁的顺序，标注了需要用到的属性
#pragma mark 1 初步制作，如果你没有动画，颜色渐变等要求的画，看这一部分就够了。
/**
 进度条进度。0-1之间。
 进度条自然需要一个进度。
 */
@property (nonatomic, assign) CGFloat progress;

/**
 线条(进度条)宽度。
 进度条的宽度，默认为10，可更改。不熟悉CG(Core Graphics绘制)的同学看到这个属性是不是觉得看不顺眼。为什么用stroke形容？慢慢看下去吧。
 */
@property (nonatomic, assign) CGFloat strokeWidth;

/**
 线条(进度条)颜色。
 进度条的颜色，默认为蓝色（我喜欢蓝色），可更改。
 */
@property (nonatomic, strong) UIColor *strokeColor;

/**
 进度条两端是否是圆角样式。
 默认为YES
 */
@property (nonatomic, assign) BOOL isRoundStyle;

/**
 半径。中心点距离视图边界的距离，不包含线宽。
 默认为视图宽或高两者中最小的一半，可更改（实际半径还要再减去线条宽度的一半）
 */
@property (nonatomic, assign) CGFloat radius;

/**
 进度条起点角度。直接传度数，默认为-M_PI/2,即view顶端中心最高点的地方（形象点，以手表为例，就是12点的方向。）
 相关角度知识，本文不讲解，请自行网上查找相关资料了解
 不设终点角度，都说了是环形进度条，自然是一整个圆了。终点角度视起点角度（开始角度）而定。
 */
@property (nonatomic, assign) CGFloat startAngle;

/**
 进度条顺逆时针方向，默认为顺时针，看起来舒服点
 */
@property (nonatomic, assign) BOOL isClockDirection;


#pragma mark 2 这一部分主要是进度条中的动画处理部分，原理就是drawrect的不停重绘，在人眼无法识别的情况下，就是漂亮流畅的动画了。
/**
 不加动画, 默认为NO。
 友情提示，如果你写的页面有类似滑动条的方法控制进度线性增减的画，就将此属性设置为YES,即不加动画。
 */
@property (nonatomic, assign) BOOL isNoAnimated;

/**
 是否从上次数值开始动画。默认为YES，即每次都从上次动画结束开始动画。
 */
@property (nonatomic, assign) BOOL isStartFromLast;

/**
 元素（小块）个数。默认为64，越高线条越平滑，性能越差。64就刚刚好，当然这个属性其实还是看项目的需求而设置的更高或更低。
 */
@property (nonatomic, assign) NSInteger subdivCount;

/**
 动画时长。当animationSameTime为NO时，此属性为动画的最长时间，即progress=1时的动画时间。
 */
@property (nonatomic, assign) CGFloat animationDuration;

/**
 动画是否同等时间。
 为YES则不同进度动画时长都为animationDuration，
 为NO则根据不同进度对应不同动画时长，进度最大时动画时长为animationDuration。
 默认为YES
 */
@property (nonatomic, assign) BOOL animationSameTime;

#pragma mark 3 这一部分主要是进度条中的颜色渐变处理部分。
/**
 是否开启渐变色模式
 默认为NO
 */
//assign
@property (assign, nonatomic) BOOL isGradientStyle;

/**
 线条(进度条)开始颜色。
 进度条的颜色，默认为白色，可更改。
 */
@property (nonatomic, strong) UIColor *startColor;

/**
 线条(进度条)结束颜色。
 进度条的颜色，默认为蓝色（我喜欢蓝色），可更改。
 */
@property (nonatomic, strong) UIColor *endColor;


/**
 初始化方法
 
 @param frame 坐标
 @param startAngle 开始角度
 @return self
 */
- (instancetype)initWithFrame:(CGRect)frame
                   startAngle:(CGFloat)startAngle;

@end
