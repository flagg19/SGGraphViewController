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

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

#pragma mark - Superclass overriden methods

- (NSString *)getJSTextSeries
{
    return @"series: [{\
    type: 'pie',\
    angleField: 'data2',\
    showInLegend: true,\
    label: {\
    field: 'name',\
    display: 'rotate',\
    contrast: true,\
    font: '18px Arial'\
    }}]";
}

@end
