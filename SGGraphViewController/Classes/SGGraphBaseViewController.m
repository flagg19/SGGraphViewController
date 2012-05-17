//
//  SGGraphBaseViewController.m
//  SGGraphViewController
//
//  Created by Michele Amati on 5/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SGGraphBaseViewController.h"

@interface SGGraphBaseViewController ()

- (void)initialize;

@end

@implementation SGGraphBaseViewController
@synthesize webview = _webview;

- (void)initialize
{
    self.webview = [[UIWebView alloc] init];
}

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        [self initialize];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

 


@end
