//
//  ZHAdvertManager.h
//  MCZongDaiHui
//
//  Created by 李中航 on 2018/5/30.
//  Copyright © 2018年 MC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ZHAdvertManager : NSObject

+ (void)downloadAdvertImageWithUrl:(NSString *)imageUrl imageName:(NSString *)imageName;

+ (BOOL)isFileExistWithFilePath:(NSString *)filePath;

+ (void)getAdvertImage;

+ (NSString *)getFilePathWithImageName:(NSString *)imageName;
@end
