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
    [self.view addSubview:cpView];
    self.cpView = cpView;
    
    //添加一个滑动条, 控制进度，看效果
    UISlider *sV = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 10)];
    [self.view addSubview:sV];
    sV.center = CGPointMake(cpView.center.x, cpView.center.y+70);
    [sV addTarget:self action:@selector(progressValueChange:) forControlEvents:UIControlEventValueChanged];
}

//进度值改变
- (void)progressValueChange:(UISlider *)sV{
    //改变进度条的值
    self.cpView.progress = sV.value;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
