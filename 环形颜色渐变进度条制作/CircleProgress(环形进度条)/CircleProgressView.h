//
//  CircleProgressView.h
//  环形颜色渐变进度条制作
//
//  Created by yun xiao on 2018/6/7.
//  Copyright © 2018年 zwl. All rights reserved.
//

#import <UIKit/UIKit.h>

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

/**
 初始化方法
 
 @param frame 坐标
 @param startAngle 开始角度
 @return self
 */
- (instancetype)initWithFrame:(CGRect)frame
                   startAngle:(CGFloat)startAngle;

@end
