//
//  ImageUtil.m
//  CocoaDownloader
//
//  Created by smile on 2018/12/17.
//  Copyright © 2018 ixuea. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>

#import "ImageUtil.h"

@implementation ImageUtil

+ (void)showImage:(UIImageView *)view uri:(NSString *)uri{
    [view sd_setImageWithURL:[NSURL URLWithString:uri]
            placeholderImage:nil];
}

@end
