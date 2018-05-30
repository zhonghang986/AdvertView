//
//  ZHAdvertView.h
//  MCZongDaiHui
//
//  Created by 李中航 on 2018/5/30.
//  Copyright © 2018年 MC. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const adImageName = @"adImageName";

static NSString *const adUrl = @"adUrl";

@interface ZHAdvertView : UIView

/**
 *   显示广告页面方法
 */
- (void)show;

/**
 *   图片路径
 */
@property (nonatomic, copy) NSString *filePath;
@end
