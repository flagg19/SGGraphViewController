//
//  SGPieViewController.m
//  SGGraphViewController
//
//  Created by Michele Amati on 5/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SGPieViewController.h"

@interface SGPieViewController ()

- (NSString *)slicesLabelFormatter:(NSString *)text;

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

- (NSString *)slicesLabelFormatter:(NSString *)text
{
    static NSString *value = @"{value}";
    static NSString *key = @"{key}";
    
    // Forming a correct javascript chain of strings
    NSString *tempSplit = [text stringByReplacingOccurrencesOfString:value withString:@"'+record.get('value')+'"];
    tempSplit = [tempSplit stringByReplacingOccurrencesOfString:key withString:@"'+record.get('key')+'"];
    return [NSString stringWithFormat:@"'%@'",tempSplit];
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
    NSString *labelRenderer = ([self.dataSource respondsToSelector:@selector(formatSlicesLabels)])
    ? [NSString stringWithFormat:
       @",renderer:function(value){"
       "var index=store.find('key',value);"
       "var record=store.getAt(index);"
       "return %@;}",
       [self slicesLabelFormatter:[self.dataSource formatSlicesLabels]]]
    : [NSString string];
    
    return [NSString stringWithFormat:
            @"series:[{"
            "type:'pie',"
            "angleField:'value',"
            "showInLegend:true,"
            "label:{"
            "field:'key',"
            "contrast:true,"
            "font:'16px Arial',"
            "display:'center'"
            "%@"
            "}}]",labelRenderer];
}

- (NSString *)getJSTextInteractions
{
    return @"interactions:[{type:'rotate'}]";
}

- (NSString *)getJSTextLegend
{
    return ([self.dataSource respondsToSelector:@selector(shouldShowLegend)] && [self.dataSource shouldShowLegend])
    ? @"legend:{position:'bottom'}"
    : nil;
}

- (NSString *)getJSTextAxes
{
    // We don't want axes in our pie.
    return nil;
}

@end
