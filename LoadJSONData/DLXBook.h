//
//  DLXBook.h
//  LoadJSONData
//
//  Created by admin on 15/9/17.
//  Copyright (c) 2015年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DLXBook : NSObject
@property (nonatomic,strong) NSString *author;
@property (nonatomic,strong) NSString *imageURL;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,assign)  CGFloat price;

@property (nonatomic,strong) UIImage *cacheImage;
@end
