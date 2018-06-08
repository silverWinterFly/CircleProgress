//
//  CircleProgressView.m
//  环形颜色渐变进度条制作
//
//  Created by yun xiao on 2018/6/7.
//  Copyright © 2018年 zwl. All rights reserved.
//

#import "CircleProgressView.h"//环形颜色渐变进度条

@interface CircleProgressView ()

@end

@implementation CircleProgressView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //初始设置
        [self initialization];
    }
    
    return self;
}
//初始化方法
- (instancetype)initWithFrame:(CGRect)frame
                   startAngle:(CGFloat)startAngle{
    self = [super initWithFrame:frame];
    
    if (self) {
        //设定开始角度
        _startAngle  = startAngle;
    }
    
    return self;
}
/**
 @param startColor 开始颜色
 @param endColor 结束颜色
 */
- (instancetype)initWithFrame:(CGRect)frame
                   startColor:(UIColor *)startColor
                     endColor:(UIColor *)endColor
                   startAngle:(CGFloat)startAngle{
    
    self = [super initWithFrame:frame];
    if (self) {
        //设定开始角度
        _startAngle  = startAngle;
    }
    
    return self;
}
//初始化设置
- (void)initialization {
    
#pragma mark 按制作由简到繁的顺序，标注了需要用到的属性
#pragma mark 1 初步制作，如果你没有动画，颜色渐变等要求的画，看这一部分就够了。
    //进度
    _progress           = 0.0;
    //进度条宽度
    _strokeWidth = 10;
    //进度条宽度
    _strokeColor = [UIColor blueColor];
    //半径
    _radius     = MIN(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))/2.0;
    //初始角度
    _startAngle = CircleDegreeToRadian(-90);
    //进度条两端是否是圆角样式
    _isRoundStyle = YES;
    //进度条顺逆时针方向，默认为顺时针
    _isClockDirection = NO;
}

//绘制部分，一切绘图都在这个方法里进行，不要写到别的地方去。
-(void)drawRect:(CGRect)rect {
    
    //画图  事实上直接把方法在这里就行，只是习惯保持系统方法的整洁干净，免的以后有需要改的时候麻烦
    [self drawOurSetWithRect:rect];
}

//画图
- (void)drawOurSetWithRect:(CGRect)rect{
    
#pragma mark 按制作由简到繁的顺序，标注了需要用到的属性
#pragma mark 1 初步制作，如果你没有动画，颜色渐变等要求的画，看这一部分就够了。
    //获取上下文，相当于画布
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //环形进度条的中心点
    CGPoint center = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
    //画扇形
    /**
     此处仅对CGContextAddArc这个主要需要的方法详细解释一下，想要对CG理深一步了解的话，请自行去查阅相关资料
     
     CGContextAddArc(CGContextRef  _Nullable c,
     CGFloat x,
     CGFloat y,
     CGFloat radius,
     CGFloat startAngle,
     CGFloat endAngle,
     int clockwise)
     c           当前图形
     x           圆弧的中心点坐标x
     y           曲线控制点的y坐标
     radius      指定点的x坐标值
     startAngle  弧的起点与正X轴的夹角，
     endAngle    弧的终点与正X轴的夹角
     clockwise   指定1创建一个顺时针的圆弧，或是指定0创建一个逆时针圆弧
     */
    if (self.isRoundStyle) {
        //圆角  系统默认为方的
        CGContextSetLineCap(ctx, kCGLineCapRound);
    }
    //设置线条宽度
    CGContextSetLineWidth(ctx, self.strokeWidth);
    //设置线条颜色
    CGContextSetStrokeColorWithColor(ctx, self.strokeColor.CGColor);
    //设置中心填充颜色
    CGContextSetFillColorWithColor(ctx, [UIColor clearColor].CGColor);
   
    //添加路径
    CGContextAddArc(ctx,
                    center.x,
                    center.y,
                    self.radius-self.strokeWidth/2.0,
                    self.startAngle,
                    self.startAngle + M_PI*2*self.progress,
                    self.isClockDirection);
    
    //开始渲染绘制图形（画图）kCGPathFillStroke这个模式的意思是描边和填充部分都要绘制
    /**
     具体效果，自行尝试
     kCGPathFill,//填充
     kCGPathEOFill,//奇偶填充
     kCGPathStroke,//描边
     kCGPathFillStroke,//填充 描边
     kCGPathEOFillStroke//奇偶填充 描边
     */
    CGContextDrawPath(ctx, kCGPathFillStroke);
}

//设置进度
- (void)setProgress:(CGFloat)progress {
    
    //先判定一下角度
    progress = progress>1.0?1.0:progress;
    progress = progress<0.0?0.0:progress;
    if (_progress == progress) {//相等结束
        return;
    }
    
    //当前进度
    _progress = progress;
    //标记重绘，当屏幕刷新的时候会自动调取drawrect方法
    /**
     ios 屏幕刷新1秒60次。
     */
    [self setNeedsDisplay];
}

#pragma mark 一些属性设置，其实这些东西没必要设置，只是演示一下怎么处理属性的改变
/**
 真需要改变的时候，直接改变属性，然后主动刷新下进度就行（比如设置下进度条）。当然这样写比较好，在定义一些复杂的类（属性比较多，层次比较多时），这样些可以提高代码可读性，令代码整体看起来更漂亮。
 */
//开始角度
- (void)setStartAngle:(CGFloat)startAngle {
    if (_startAngle != startAngle) {
        _startAngle = startAngle;
        [self setNeedsDisplay];
    }
}
//线条宽度
- (void)setStrokeWidth:(CGFloat)strokeWidth {
    if (_strokeWidth != strokeWidth) {
        _strokeWidth = strokeWidth;
        [self setNeedsDisplay];
    }
}

@end
