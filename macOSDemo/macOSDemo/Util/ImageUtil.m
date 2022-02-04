//
//  ImageUtil.m
//  CocoaDownloader
//
//  Created by smile on 2018/12/17.
//  Copyright © 2018 ixuea(http://a.ixuea.com/y). All rights reserved.
//

//图片加载框架
#import <SDWebImage/UIImageView+WebCache.h>

#import "ImageUtil.h"

@implementation ImageUtil

+ (void)showImage:(NSImageView *)view uri:(NSString *)uri{
    [view sd_setImageWithURL:[NSURL URLWithString:uri]
            placeholderImage:nil];
}

@end
