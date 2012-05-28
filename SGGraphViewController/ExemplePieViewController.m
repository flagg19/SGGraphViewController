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

- (int)numberOfSlicesInPie
{
    return 3;
}

- (NSString *)labelForSlice:(int)num
{
    return [NSString stringWithFormat:@"slice_%d",num];
}

- (NSNumber *)valueForSlice:(int)num
{
    return [[NSNumber alloc]initWithInt:num];
}

@end
