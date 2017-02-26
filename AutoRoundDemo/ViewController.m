//
//  ViewController.m
//  AutoRoundDemo
//
//  Created by 李亚东 on 2017/2/24.
//  Copyright © 2017年 李亚东. All rights reserved.
//

#import "ViewController.h"

#define Screen_width        ([UIScreen mainScreen].bounds.size.width)
#define Screen_Height       ([UIScreen mainScreen].bounds.size.height)

#define final_width        (Screen_width > Screen_Height ? Screen_Height : Screen_width)
#define final_Height       (Screen_width < Screen_Height ? Screen_Height : Screen_width)

@interface ViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *myScrollview;
@property (nonatomic, strong) UIPageControl *myPageControl;
@property (nonatomic, strong) NSTimer *myTimer;

@end

@implementation ViewController

#pragma mark -- lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.myScrollview];
    [self.view addSubview:self.myPageControl];
    
    //    图片的宽
    CGFloat imageW = self.myScrollview.frame.size.width;
    //    图片高
    CGFloat imageH = self.myScrollview.frame.size.height;
    //    图片的Y
    CGFloat imageY = 0;
    //    图片中数
    NSInteger totalCount = 5;
    //   1.添加5张图片
    for (int i = 0; i < totalCount; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        //        图片X
        CGFloat imageX = i * imageW;
        //        设置frame
        imageView.frame = CGRectMake(imageX, imageY, imageW, imageH);
        //        设置图片
        NSString *name = [NSString stringWithFormat:@"auto%d.jpeg", i + 1];
        imageView.image = [UIImage imageNamed:name];
        //        隐藏指示条
        self.myScrollview.showsHorizontalScrollIndicator = NO;
        
        [self.myScrollview addSubview:imageView];
    }
    
    //    2.设置scrollview的滚动范围
    CGFloat contentW = totalCount *imageW;
    //不允许在垂直方向上进行滚动
    self.myScrollview.contentSize = CGSizeMake(contentW, 0);
    
    //    3.设置分页
    self.myScrollview.pagingEnabled = YES;
    
    //    4.监听scrollview的滚动
    self.myScrollview.delegate = self;
    
    [self addTimer];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)nextImage
{
    int page = (int)self.myPageControl.currentPage;
    if (page == 4) {
        page = 0;
    } else {
        page++;
    }
    UIApplication *app=[UIApplication sharedApplication];
    app.applicationIconBadgeNumber=123;    //  滚动scrollview
    CGFloat x = page * self.myScrollview.frame.size.width;
    self.myScrollview.contentOffset = CGPointMake(x, 0);
}

// scrollview滚动的时候调用
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"滚动中");
    //    计算页码
    //    页码 = (contentoffset.x + scrollView一半宽度)/scrollView宽度
    CGFloat scrollviewW =  scrollView.frame.size.width;
    CGFloat x = scrollView.contentOffset.x;
    int page = (x + scrollviewW / 2) /  scrollviewW;
    self.myPageControl.currentPage = page;
}
// 开始拖拽的时候调用
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //    关闭定时器(注意点; 定时器一旦被关闭,无法再开启)
    //    [self.timer invalidate];
    [self removeTimer];
}


/**
 *  开启定时器
 */
- (void)addTimer{
    
    self.myTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
   }
/**
 *  关闭定时器
 */
- (void)removeTimer
{
    [self.myTimer invalidate];
}
#pragma mark -- lazyLoad
- (UIScrollView *)myScrollview {
    if (!_myScrollview) {
        _myScrollview = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _myScrollview.frame = CGRectMake(0, 50, final_width, final_width / 2);
        _myScrollview.delegate = self;
        _myScrollview.contentSize = CGSizeMake(final_width * 5, final_width / 2);
        _myScrollview.backgroundColor = [UIColor yellowColor];
    }
    return _myScrollview;
}

- (UIPageControl *)myPageControl {
    if (!_myPageControl) {
        _myPageControl = [[UIPageControl alloc] initWithFrame:CGRectMake((final_width - 70) / 2, final_width / 2 - 20 + 50, 70, 20)];
//        _myPageControl.backgroundColor = [UIColor blueColor];
        _myPageControl.numberOfPages = 5;
    }
    return _myPageControl;
}


@end
