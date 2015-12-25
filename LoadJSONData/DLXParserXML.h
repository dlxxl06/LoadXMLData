//
//  DLXParserXML.h
//  LoadJSONData
//
//  Created by admin on 15/9/18.
//  Copyright (c) 2015年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DLXParserXML : NSObject
-(NSArray *)parserXMLSynchronous:(NSData *)data classStr:(NSString *)classStr;
@property (nonatomic,strong) NSString *nodeName;
@property (nonatomic,strong) NSArray *childElementArr;

@end
