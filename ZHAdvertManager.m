//
//  ZHAdvertManager.m
//  MCZongDaiHui
//
//  Created by 李中航 on 2018/5/30.
//  Copyright © 2018年 MC. All rights reserved.
//

#import "ZHAdvertManager.h"
#import "ZHAdvertView.h"
@implementation ZHAdvertManager

/**
 *   判断文件是否存在
 */
+ (BOOL)isFileExistWithFilePath:(NSString *)filePath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL isDirectory = FALSE;
    
    return [fileManager fileExistsAtPath:filePath isDirectory:&isDirectory];
}

/**
 *   初始化广告页面
 */
+ (void)getAdvertImage {
    
    NSArray *imageArray = @[@"http://img1.126.net/channel6/2016/022471/0805/2.jpg?dpi=6401136", @"http://image.woshipm.com/wp-files/2016/08/555670852352118156.jpg"];
    NSString *imageUrl = imageArray[0];

    // 获取图片名
    NSArray *stringArr = [imageUrl componentsSeparatedByString:@"/"];
    NSString *imageName = stringArr.lastObject;
    
    // 拼接沙盒路径
    NSString *filePath = [self getFilePathWithImageName:imageName];
    BOOL isExist = [self isFileExistWithFilePath:filePath];
    
    
    if (!isExist){// 如果该图片不存在，则删除老图片，下载新图片
        
        [self downloadAdvertImageWithUrl:imageUrl imageName:imageName];
        
    }
    
    
}
/**
 *   下载图片
 */
+ (void)downloadAdvertImageWithUrl:(NSString *)imageUrl imageName:(NSString *)imageName {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
        
        UIImage *image = [UIImage imageWithData:data];
        
        NSString *filePath = [self getFilePathWithImageName:imageName];
        
        if ([UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self deleteOldImage];
                [[NSUserDefaults standardUserDefaults] setValue:imageName forKey:adImageName];
                
                [[NSUserDefaults standardUserDefaults] synchronize];
            });
            
        }
        
    });
}
/**
 *  删除旧图片
 */
+ (void)deleteOldImage {
    NSString *imageName = [[NSUserDefaults standardUserDefaults] objectForKey:adImageName];
    
    if (imageName) {
        NSString *filePath = [self getFilePathWithImageName:imageName];
        
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    }
}

/**
 *   根据图片路径拼接文件路径
 */
+ (NSString *)getFilePathWithImageName:(NSString *)imageName {
    if (imageName) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        
        NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:imageName];
        return filePath;
    }
    
    return nil;
    
}
@end
