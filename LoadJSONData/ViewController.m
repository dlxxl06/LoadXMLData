//
//  ViewController.m
//  LoadJSONData
//
//  Created by admin on 15/9/17.
//  Copyright (c) 2015年 admin. All rights reserved.
//

#import "ViewController.h"
#import "DLXBook.h"
#import "NSArray+log.h"
#import "DLXTableViewCell.h"
#import "DLXLoginViewController.h"
#import "DLXParserXML.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate,NSXMLParserDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataList;
    
    NSMutableString *_appendString;
    DLXBook *_curBook;
}
@end

#define kWIFIHeight 20
#define kToolBarHeight 44
#define kTabBarHeight 49

@implementation ViewController

-(void)loadView
{
    
    self.view = [[UIView alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    //列表
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kWIFIHeight, self.view.bounds.size.width, self.view.bounds.size.height-kWIFIHeight-kToolBarHeight-kTabBarHeight) style:UITableViewStylePlain];
    [_tableView setRowHeight:80.0f];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    //_tableView
    [self.view addSubview:_tableView];
    
    //工具条
    UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height-kToolBarHeight-kTabBarHeight, self.view.bounds.size.width, kToolBarHeight)];
    [toolBar setBarTintColor:[UIColor lightGrayColor]];
    [self.view addSubview:toolBar];
    
    
    
    //从JSON 加载 工具条
    UIBarButtonItem *JSONItem = [[UIBarButtonItem alloc]initWithTitle:@"从JSON加载" style:UIBarButtonItemStylePlain target:self action:@selector(loadDataWithJSON)];
    
    UIBarButtonItem *XMLItem = [[UIBarButtonItem alloc]initWithTitle:@"从XML加载" style:UIBarButtonItemStylePlain target:self action:@selector(loadDataWithXML)];
    
    //间隔符
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBar setItems:@[spaceItem,JSONItem,spaceItem,XMLItem,spaceItem]];
    
    _dataList = [NSMutableArray array];
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!_onLine)
    {
        DLXLoginViewController *loginController = [[DLXLoginViewController alloc]init];
        [loginController setSuperViewController:self];
        [self presentViewController:loginController animated:NO completion:nil];
    }
}

#pragma mark -私有方法
#pragma mark json按钮点击事件
-(void)loadDataWithJSON
{
    /*
        丛服务器加载数据，只需一次
     */
    NSString *connUrl =@"json_ws.asmx/GetBookInfo";
    NSString *urlString =[NSString stringWithFormat:@"%@%@",kBasicURL,connUrl];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:2.0f];
    NSURLResponse *response =nil;
    NSError *error = nil;
    
   NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if (data!=nil)
    {
        [self dealJSONWithData:data];
    }
    else if (!data && !error)
        NSLog(@"活见鬼了");
    else
        NSLog(@"%@",[error localizedDescription]);
    
    //从缓存中读取内容
}
#pragma mark - 加载JOSN
-(void)dealJSONWithData:(NSData *)data
{
    
    
    NSArray *datas = (NSArray *)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments  error:nil];
    [_dataList removeAllObjects];
   // NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:datas.count];
    for (NSDictionary *dict in datas)
    {
        DLXBook *b = [[DLXBook alloc]init];
        [b setValuesForKeysWithDictionary:dict];
        [_dataList addObject:b];
    }
    //_dataList = tempArray ;
    // NSLog(@"%@",_dataList);
    [_tableView reloadData];
    
}
#pragma mark -加载XML
-(void)loadDataWithXML
{

    NSString *connUrl =@"json_ws.asmx/GetBookInfoXML";
    NSString *urlString =[NSString stringWithFormat:@"%@%@",kBasicURL,connUrl];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:2.0f];
    NSURLResponse *response =nil;
    NSError *error = nil;
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if (data!=nil)
    {
        //[self dealJSONWithData:data];
        
        DLXParserXML *myParser = [[DLXParserXML alloc]init];
        
        [myParser setNodeName:@"Book"];
        [myParser setChildElementArr:@[@"name",@"price",@"imageURL",@"author"]];
        
        NSArray *result = [myParser parserXMLSynchronous:data classStr:@"DLXBook"];
        
        _dataList = [NSMutableArray arrayWithArray:result];
        [_tableView reloadData];
        
    }
    else if (!data && !error)
        NSLog(@"活见鬼了");
    else
        NSLog(@"%@",[error localizedDescription]);

}

#pragma mark tableView的数据源代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataList.count;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static  NSString *cellID = @"myCell";
    DLXTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[DLXTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    
    DLXBook *book = _dataList[indexPath.row];
    if (!book.cacheImage)
    {
         UIImage *DefaultImg = [UIImage imageNamed:@"user_default.png"];
        book.cacheImage = DefaultImg;
        [self downLoadImageWithIndexPath:indexPath];
        
    }
    [cell.imageView setImage:book.cacheImage];
    [cell.textLabel setText:book.name];
    [cell.detailTextLabel setText:book.author];
    [cell.priceLabel setText:[NSString stringWithFormat:@"$%.2lf",book.price]];
    return cell;
}
#pragma mark -从服务器下载图片
-(void)downLoadImageWithIndexPath:(NSIndexPath *)indexPath
{
    DLXBook *book = _dataList[indexPath.row];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kBasicURL,book.imageURL];
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (data)
        {
             UIImage *image = [UIImage imageWithData:data];
            book.cacheImage = image;
            [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    }];
}
@end
