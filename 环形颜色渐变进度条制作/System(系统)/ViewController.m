//
//  ViewController.m
//  环形颜色渐变进度条制作
//
//  Created by yun xiao on 2018/6/7.
//  Copyright © 2018年 zwl. All rights reserved.
//

#import "ViewController.h"
#import "CircleProgressView.h"//环形颜色渐变进度条

@interface ViewController ()

//strong    环形颜色渐变进度条
@property (strong, nonatomic) CircleProgressView *cpView;

//strong
@property (strong, nonatomic) UITextField *animationTestTF;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //构建一个环形颜色渐变进度条添加到view上,中心点为屏幕中心。
    CircleProgressView *cpView = [[CircleProgressView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    cpView.center = CGPointMake(self.view.frame.size.width/2., self.view.frame.size.height/2.);
    //给他一个淡灰色背景方便观察效果
    cpView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    //对于进度条的各种设置都可以在这里进行。
    //例，进度条两端是否为圆角
    cpView.isRoundStyle = NO;
    //将时间改为0.8s
    cpView.animationDuration = 0.8;
    //动画时间不等同，看效果
//    cpView.animationSameTime = NO;
    [self.view addSubview:cpView];
    cpView.layer.masksToBounds = YES;
    cpView.layer.cornerRadius = 50;

    self.cpView = cpView;
    
    //添加一个滑动条, 控制进度，看效果
    UISlider *sV = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 10)];
    [self.view addSubview:sV];
    sV.center = CGPointMake(cpView.center.x, cpView.center.y+70);
    [sV addTarget:self action:@selector(progressValueChange:) forControlEvents:UIControlEventValueChanged];
    
    
    //在头上加个输入框测试动画功能。
    UITextField *animationTestTF = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    animationTestTF.keyboardType = UIKeyboardTypeDecimalPad;
    [self.view addSubview:animationTestTF];
    animationTestTF.backgroundColor = [UIColor groupTableViewBackgroundColor];
    animationTestTF.center = CGPointMake(cpView.center.x-40, cpView.center.y-70-50);
    self.animationTestTF = animationTestTF;
    //确定输入进度值按钮
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(0, 0, 30, 30);
    sureBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    [sureBtn setTitle:@"sure" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    sureBtn.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:sureBtn];
    sureBtn.center = CGPointMake(animationTestTF.frame.size.width+animationTestTF.frame.origin.x+40, animationTestTF.center.y);
    [sureBtn addTarget:self action:@selector(sureThisProgress) forControlEvents:UIControlEventTouchUpInside];
}

//进度值改变
- (void)progressValueChange:(UISlider *)sV{
    if (!self.cpView.isNoAnimated) {//注，此时记得不要加动画。
        self.cpView.isNoAnimated = YES;
    }
    //改变进度条的值
    self.cpView.progress = sV.value;
}
//确定按键方法
- (void)sureThisProgress{
    self.cpView.isNoAnimated = NO;
    if (self.animationTestTF.text&&self.animationTestTF.text.length) {
        //改变进度条的值
        self.cpView.progress = self.animationTestTF.text.floatValue;
    }
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
