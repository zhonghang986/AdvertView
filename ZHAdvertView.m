//
//  ZHAdvertView.m
//  MCZongDaiHui
//
//  Created by 李中航 on 2018/5/30.
//  Copyright © 2018年 MC. All rights reserved.
//

#import "ZHAdvertView.h"

@interface ZHAdvertView()
@property (nonatomic, strong) UIImageView *adVertView; // 广告图

@property (nonatomic, strong) UIButton * countBt; // 倒计时按钮

@property (nonatomic, assign) int count;

@property (nonatomic, strong) dispatch_source_t timer;
@end

static int const showtime = 3;
@implementation ZHAdvertView


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // 广告图片
        _adVertView = [[UIImageView alloc] initWithFrame:frame];
        _adVertView.userInteractionEnabled = YES;
        _adVertView.contentMode = UIViewContentModeScaleAspectFill;
        _adVertView.clipsToBounds = YES;
        
        // 为广告页面添加点击手势，跳到广告对应的详情页面
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushAdvertDetail)];
        
        [_adVertView addGestureRecognizer:tap];
        
        // 跳过倒计时按钮
        CGFloat btnW = 60;
        CGFloat btnH = 30;
        _countBt = [[UIButton alloc] initWithFrame:CGRectMake(Main_Screen_Width - btnW - 24, btnH, btnW, btnH)];
        [_countBt addTarget:self action:@selector(removeAdvertView) forControlEvents:(UIControlEventTouchUpInside)];
        
        [_countBt setTitle:[NSString stringWithFormat:@"跳过%d", showtime] forState:(UIControlStateNormal)];
        
        _countBt.titleLabel.font = [UIFont systemFontOfSize:15];
        
        [_countBt setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        
        _countBt.backgroundColor = [UIColor colorWithRed:38 /255.0 green:38 /255.0 blue:38 /255.0 alpha:0.6];
        
        _countBt.layer.cornerRadius = 4;
        
        [self addSubview:_adVertView];
        
        [self addSubview:_countBt];
    }
    
    return self;
}

- (void)show {
   
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];

    __weak typeof(self) weakSelf = self;
    
    __block int timeout = showtime;
    
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
    dispatch_source_set_timer(_timer, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(_timer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (timeout <= 0) {
                dispatch_source_cancel(_timer);
                [weakSelf removeAdvertView];
            }
            else {
                [_countBt setTitle:[NSString stringWithFormat:@"跳过%d", timeout] forState:(UIControlStateNormal)];
                timeout--;
            }
        });

    });
    dispatch_resume(_timer);
}

- (void)pushAdvertDetail {
    [self removeFromSuperview];
    
    // 只需要在首页中接收通知，然后做就相应的跳转
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ZHAdvertView" object:nil userInfo:nil];
}

- (void)removeAdvertView {
    // 停掉定时器
    dispatch_source_cancel(_timer);
    
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


- (void)setFilePath:(NSString *)filePath {
    _filePath = filePath;
    _adVertView.image = [UIImage imageWithContentsOfFile:filePath];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
