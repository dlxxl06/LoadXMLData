//
//  NSArray+log.m
//  LoadJSONData
//
//  Created by admin on 15/9/17.
//  Copyright (c) 2015年 admin. All rights reserved.
//

#import "NSArray+log.h"

@implementation NSArray (log)
-(NSString *)descriptionWithLocale:(id)locale
{
    NSMutableString *mstr = [NSMutableString stringWithFormat:@"%ld\n(",self.count];
    for (NSObject *obj in self)
    {
        [mstr appendFormat:@"\t%@\n",obj];
    }
    
    [mstr appendString:@")"];
    return mstr;
}
@end
