//
//  ExemplePieViewController.m
//  SGGraphViewController
//
//  Created by Michele Amati on 5/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ExemplePieViewController.h"

@interface ExemplePieViewController ()

@end

@implementation ExemplePieViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setDataSource:self];
    [self reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

#pragma mark - SGPieDataSource

- (NSNumber *)numberOfSlicesInPie
{
    return [[NSNumber alloc]initWithInt:5];
}

- (NSString *)labelForSlice:(NSNumber *)num
{
    return [NSString stringWithFormat:@"slice_%d",[num intValue]+1];
}

- (NSNumber *)valueForSlice:(NSNumber *)num
{
    return [[NSNumber alloc]initWithInt:[num intValue]+1];
}

- (BOOL)shouldShowLegend
{
    return YES;
}

- (NSString *)formatSlicesLabels
{
    return @"{value} Crediti";
}


@end
