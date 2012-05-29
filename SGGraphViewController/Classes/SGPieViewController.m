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
    int tempSlices = (int)[self.dataSource numberOfSlicesInPie];
    for (int slice=0; slice<tempSlices; slice++) {
        NSDictionary *newSlice = [[NSDictionary alloc]initWithObjectsAndKeys:
                                  [self.dataSource labelForSlice:slice],@"key",
                                  [self.dataSource valueForSlice:slice],@"value",nil];
        [_pie addObject:newSlice];
    }
    
    CGSize content = CGSizeMake(800, self.view.frame.size.height);
    
    [self setupChartWithSize:content data:_pie];
    [self showChart];
}

- (NSString *)getJSTextSeries
{        
    return @"series:[{"
    "type:'pie',"
    "angleField:'value',"
    "label:{field:'key',"
    "display:'rotate',"
    "contrast:true,"
    "font:'18px Arial'}}]";
    
    /*
     Human readable version... 
     
     @"series: [{
     type: 'pie',
     angleField: 'value',
     label: {
        field: 'key',
        display: 'rotate',
        contrast: true,
        font: '18px Arial'
     }}]";
     */
}

- (NSString *)getJSTextAxes
{
    // We don't want axes in our pie.
    return nil;
}

@end
