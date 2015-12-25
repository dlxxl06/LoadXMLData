//
//  DLXParserXML.m
//  LoadJSONData
//
//  Created by admin on 15/9/18.
//  Copyright (c) 2015年 admin. All rights reserved.
//

#import "DLXParserXML.h"

@interface DLXParserXML()<NSXMLParserDelegate>
{

}

@end

@implementation DLXParserXML

NSMutableArray *dataList;
NSMutableString *appendString;

#pragma mark -数组中存放的类型
Class elementClass;

#pragma mark dataList中的元素
id curMember;

-(NSArray *)parserXMLSynchronous:(NSData *)data classStr:(NSString *)classStr
{
    if (!dataList)
    {
         dataList = [NSMutableArray array];
    }
    if (!appendString)
    {
        appendString = [NSMutableString string];
    }
    [dataList removeAllObjects];
    elementClass = NSClassFromString(classStr);
    NSXMLParser *parser = [[NSXMLParser alloc]initWithData:data];
    [parser setDelegate:self];
       [parser parse];
    return dataList;
}


#pragma mark-NSXMLParser的代理方法
#pragma mark 开始解析
-(void)parserDidStartDocument:(NSXMLParser *)parser
{
    // NSLog(@"开始解析");
    if (!appendString)
    {
        appendString = [NSMutableString string];
    }
    [dataList removeAllObjects];
}
#pragma mark 开始解析元素
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:_nodeName])
    {
        curMember = [[elementClass alloc]init];
    }
    [appendString setString:@""];
}
#pragma mark 找到元素的内容
-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    [appendString appendString:string];
}

#pragma mark 结束解析元素
-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    NSString *result = [NSString stringWithString:appendString];
    if ([elementName isEqualToString:_nodeName])
    {
        [dataList addObject:curMember];
    }
    for (NSInteger i=0; i<_childElementArr.count; i++)
    {
        if ([elementName isEqualToString:_childElementArr[i]])
        {
             [curMember setValue:result forKey:_childElementArr[i]];
        }
    }
}

#pragma mark 结束解析
-(void)parserDidEndDocument:(NSXMLParser *)parser
{
    
}

#pragma mark 解析错误
-(void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    
}

@end
