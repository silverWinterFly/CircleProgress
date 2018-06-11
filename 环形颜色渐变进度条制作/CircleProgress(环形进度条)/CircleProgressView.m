//
//  CircleProgressView.m
//  环形颜色渐变进度条制作
//
//  Created by yun xiao on 2018/6/7.
//  Copyright © 2018年 zwl. All rights reserved.
//

#import "CircleProgressView.h"//环形颜色渐变进度条

@interface CircleProgressView ()

#pragma mark 2 这一部分主要是进度条中的动画处理部分，原理就是drawrect的不停重绘，在人眼无法识别的情况下，就是漂亮流畅的动画了。
/**
 定时器，如果你是用UISlider控件来控制进度的话，那么只要在设置进度的时候，标记一下需要重绘，就会给人一种动画感。因为UISlider的值变化是连续变化。但如果你需要让进度直接从0.3->0.8就不行了，这个时候你就需要一个动画来给用户更好的体验。而CADisplayLink定时器这时就是你必不可少的动画利器在。他的优缺点此处不多言，自己上网查，一大堆。这里只说一句，CADisplayLink是基于屏幕刷新而制定的。
 */
@property (nonatomic, strong) CADisplayLink *playLink;

/**
 当前进度，顾名思义，在动画过程中，每次屏幕刷新重绘时相对应的进度值
 */
@property (nonatomic, assign) CGFloat currentProgress;

/**
 增加的进度度值，一句话，动画时每次屏幕刷新，当前进度所增加的值
 */
@property (nonatomic, assign) CGFloat increaseProgressValue;

/**
 是否巅倒反转，进度值不单单会增长，也会减少。所以动画不单单需要前进增长，也要能后退缩短。
 */
@property (nonatomic, assign) BOOL isReverse;

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
    _strokeWidth        = 10;
    //进度条宽度
    _strokeColor        = [UIColor blueColor];
    //半径
    _radius             = MIN(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))/2.0;
    //初始角度
    _startAngle         = CircleDegreeToRadian(-90);
    //进度条两端是否是圆角样式
    _isRoundStyle       = YES;
    //进度条顺逆时针方向，默认为顺时针
    _isClockDirection   = NO;
    
#pragma mark 2 这一部分主要是进度条中的动画处理部分，原理就是drawrect的不停重绘，在人眼无法识别的情况下，就是漂亮流畅的动画了。
    //需要动画
    _isNoAnimated           = NO;
    //新动画结束时，从上次动画结束的位置开始动画
    _isStartFromLast        = YES;
    //动画时的被分割的块数
    _subdivCount = 64;
    //动画默认时长
    _animationDuration      = 2;
    //不同动画的时长是否相同
    _animationSameTime      = YES;
    
#pragma mark 3 这一部分主要是进度条中的颜色渐变处理部分。
    /*
     选择了渐变色后，线条颜色就不用管了
     */
    //是否开启渐变色模式
    _isGradientStyle = YES;
    //开始颜色
    _startColor = [UIColor whiteColor];
    //结束颜色
    _endColor   = [UIColor blueColor];
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
    //设置中心填充颜色
    CGContextSetFillColorWithColor(ctx, [UIColor clearColor].CGColor);
    if (!self.isGradientStyle) {//不使用渐变色
        //设置线条颜色
        CGContextSetStrokeColorWithColor(ctx, self.strokeColor.CGColor);
    }
    
    
#pragma mark 2 这一部分主要是进度条中的动画处理部分，原理就是drawrect的不停重绘，在人眼无法识别的情况下，就是漂亮流畅的动画了。
    //每一小块的角度（弧度值）
    float perAngle = M_PI*2*self.currentProgress/self.subdivCount;
    
    //当前开始角度
    float currentStartAngle;
    //当前结束角度
    float currentOverAngle;
    
    //当前颜色
    UIColor *currentColor;
    for (NSInteger i = 0; i<self.subdivCount; i++) {
        if (self.isGradientStyle) {
            #pragma mark 3 这一部分主要是进度条中的颜色渐变处理部分。
            //获取当前渐变色
            currentColor = [self getGradientColor:i*1.0/self.subdivCount];
            //设置线条颜色
            CGContextSetStrokeColorWithColor(ctx, currentColor.CGColor);
        }
        //当前开始角度
        currentStartAngle = self.startAngle+perAngle*i;
        //当前结束角度
        currentOverAngle  = currentStartAngle + perAngle;
        //添加路径
        CGContextAddArc(ctx,
                        center.x,
                        center.y,
                        self.radius-self.strokeWidth/2.0,
                        currentStartAngle,
                        currentOverAngle,
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
}

//设置进度
- (void)setProgress:(CGFloat)progress {
    
    //先判定一下角度
    progress = progress>1.0?1.0:progress;
    progress = progress<0.0?0.0:progress;
    if (_progress == progress) {//相等结束
        return;
    }
    
    //当前进度，如果要求从上次结束的动画开始的话，将当前进度设置为上次的进度值。否则设为0.0
    self.currentProgress = self.isStartFromLast==YES?self.progress:0.0;
    
    //对比传进来的进度值与当前进度，以确定动画是否为后退动画，不明白这句代码意思的，多看两遍，你就明白其中的逻辑了。
    self.isReverse = progress<self.currentProgress?YES:NO;
    
    //当前进度
    _progress = progress;
    
    if (self.isNoAnimated) {//不需要动画
        //直接将当前进度值设置为本次进度值
        self.currentProgress = self.progress;
        //标记重绘，当屏幕刷新的时候会自动调取drawrect方法
        /**
         ios 屏幕刷新1秒60次。
         */
        [self setNeedsDisplay];
    }else {//需要动画
        //这里要做的事就有点多了，慢慢看就懂了
        CGFloat pinLv = 60;//屏幕每秒刷新的次数（有兴趣的可以了解一下）
        //是否从上次结束开始动画
        if (self.isStartFromLast) {//是（从上次结束开始动画）
            if (self.animationSameTime) {
                //这里注释说明下，要不然，逻辑就容易迷糊了
                /**
                 首先，要记得在这里的都是需要动画的。其次如果前面的逻辑你理解清晰的话，那这里就容易理解多了。
                 self.progress - self.currentProgress，这个减式是为了求出，这一段动画的动画距离（弧度）。（有正负之分，关系到动画是前进还是后退）
                 pinLv*self.animationDuration这个是动画的时间，千万要理解，这个乘式的含义。接下来我们要用的是CADisplayLink定时器。一秒60次。如果直接用self.animationDuration作分母忘了乘以频率的话，呵呵……
                 */
                //每次动画增加的值
                self.increaseProgressValue = (self.progress - self.currentProgress)/(pinLv*self.animationDuration);
            }else {
                //如果你能领会上面的代码这里你一定懂。如果想不通，可以看一下下面的CADisplayLink定时器相关方法
                self.increaseProgressValue = self.isReverse == YES ? -1.0/(pinLv*_animationDuration):1.0/(pinLv*_animationDuration);
            }
        }else {//不是
            //从0开始动画
            if (self.animationSameTime) {
                //理解了上面的代码你就懂
                self.increaseProgressValue = self.progress/(pinLv*self.animationDuration);
            }else {
                //理上你懂
                self.increaseProgressValue = 1.0/(pinLv*_animationDuration);
            }
        }
        
        
        
        //重置定时器
        if (self.playLink) {
            [self.playLink invalidate];
            self.playLink = nil;
        }
        //CADisplayLink定时器使用方法，不解释，自查，可以关注下preferredFramesPerSecond、frameInterval这两个属性（想优化代码性能的话）
        CADisplayLink *playLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(countingAction)];
        [playLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
        self.playLink = playLink;
    }
}
//定时器方法
- (void)countingAction{
    
    //当前进度设置每次动画都要加一份增加值
    self.currentProgress += self.increaseProgressValue;
    [self setNeedsDisplay];
    
    /**
     判断动画是否该结束了
     */
    if (self.isStartFromLast) {
        if (self.isReverse) {//倒退动画
            if (self.currentProgress <= self.progress) {//当前进度值小于等于目标进度值时结束
                [self dealWithLast];
            }
        } else {
            if (self.currentProgress >= self.progress) {//当前进度值大于等于目标进度值时结束
                [self dealWithLast];
            }
        }
    } else {
        if (self.currentProgress >= self.progress) {//当前进度值大于等于目标进度值时结束
            [self dealWithLast];
        }
    }
    
}
//最后一次动画内容
- (void)dealWithLast {
    //调节一下进度值
    self.currentProgress = self.progress;
    
    //注销定时器
    [self.playLink invalidate];
    self.playLink = nil;
    
    //标记刷新（动画增长）
    [self setNeedsDisplay];
}
#pragma mark 3 这一部分主要是进度条中的颜色渐变处理部分。
//获取当前颜色
- (UIColor *)getGradientColor:(CGFloat)current{
    /*
     此处讲解一下，线性颜色获取原理
     一个颜色是由R\G\B\A四个要素组成，即由红、绿、蓝、透明度四个元素组成，掌控了这4个要素，你就掌控了这个颜色，所以定义2个float型的4位数组c1,c2用来存储这2个颜色的4个要素。
     然后该如何获取开始与结束颜色的这4个要素呢，不用急，系统已经给我们准备好了方法：
     - (BOOL)getRed:(nullable CGFloat *)red green:(nullable CGFloat *)green blue:(nullable CGFloat *)blue alpha:(nullable CGFloat *)alpha NS_AVAILABLE_IOS(5_0);
     用这个方法就能获取一个颜色的4个要素。也就是下方的1，2步。
     等你获取了开始，结束颜色的这4个要素后，我们就可以进行第3步，用系统的方法：
     + (UIColor *)colorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;
     制造一个在当前进度的开始结束之间的相应颜色出来。哦，什么是当前进度啊，就是方法参数current（0～1）之间。为0时是开始颜色，为1时是结束颜色。
     */
    
    //1
    CGFloat c1[4];
    CGFloat c2[4];
    //2
    [_startColor getRed:&c1[0] green:&c1[1] blue:&c1[2] alpha:&c1[3]];
    [_endColor getRed:&c2[0] green:&c2[1] blue:&c2[2] alpha:&c2[3]];
    
    //3
    return [UIColor colorWithRed:current*c2[0]+(1-current)*c1[0] green:current*c2[1]+(1-current)*c1[1] blue:current*c2[2]+(1-current)*c1[2] alpha:current*c2[3]+(1-current)*c1[3]];
}
#pragma mark 一些属性设置，其实这些东西没必要设置，只是演示一下怎么处理属性的改变
/**
 真需要改变的时候，直接改变属性，然后主动刷新下进度就行（比如设置下进度条）。当然这样写比较好，在定义一些复杂的类（属性比较多，层次比较多时），这样些可以提高代码可读性，令代码整体看起来更漂亮。这里只是随便两个做例子，有想加的比如颜色什么的自己加
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
