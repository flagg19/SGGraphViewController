//
//  SGPieViewController.m
//  SGGraphViewController
//
//  Created by Michele Amati on 5/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SGPieViewController.h"

@interface SGPieViewController ()

@end

@implementation SGPieViewController
@synthesize dataSource = _dataSource;

- (id)init
{
    if (self = [super init]) {
        // Custom init here...
        _pie = [[NSMutableArray alloc]init];
    }
    return self;
}

#pragma mark - Superclass overriden methods

- (void)reloadData
{
    // No need to bother if no data source has been setted
    if (!self.dataSource)
        return;
    
    // For every slice
    int tempSlices = [[self.dataSource numberOfSlicesInPie]intValue];
    for (int slice=0; slice<tempSlices; slice++) {
        NSDictionary *newSlice = [[NSDictionary alloc]initWithObjectsAndKeys:
                                  [self.dataSource labelForSlice:[[NSNumber alloc]initWithInt:slice]],@"key",
                                  [self.dataSource valueForSlice:[[NSNumber alloc]initWithInt:slice]],@"value",nil];
        [_pie addObject:newSlice];
    }
        
    [self setupChartWithData:_pie];
    [self showChart];
}

- (NSString *)getJSTextSeries
{        
    return @"series:[{"
    "type:'pie',"
    "angleField:'value',"
    ""
    "label:{"
    "field:'key',"
    "contrast:true,"
    "font:'16px Arial',"
    "display: 'rotate',"
    "renderer: function(value){"
    "var index = store.find('key', value);"
    "var record = store.getAt(index);"
    "return record.get('key')+' : '+record.get('value');}"
    "}}]";
}

- (NSString *)getJSTextInteractions
{
    return @"interactions:[{type:'rotate'}]";
}

- (NSString *)getJSTextAxes
{
    // We don't want axes in our pie.
    return nil;
}

@end
