//
//  DLXBook.m
//  LoadJSONData
//
//  Created by admin on 15/9/17.
//  Copyright (c) 2015年 admin. All rights reserved.
//

#import "DLXBook.h"

@implementation DLXBook

-(NSString *)description
{
    return  [NSString stringWithFormat:@"%@,%@,%@,%@,%.2lf",[super description],_author,_imageURL,_name,_price ];

}
@end
