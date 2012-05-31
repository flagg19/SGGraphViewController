//
//  SGGraphBaseViewController.h
//  SGGraphViewController
//
//  Created by Michele Amati on 5/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGAxis.h"

@interface SGGraphBaseViewController : UIViewController <UIWebViewDelegate> {
    
    // The webview used to show the sencha configured page
    UIWebView *webview;
    // The path to the bundle 
    NSString *htmlIndex;
    // File system position of javascript files
    NSString *baseURL;
    
    @private    
    /* Chart related data */
    CGSize _size;
    
    NSArray *_data;
}

// Passed to sencha framework, it's not related to the controller frame 
@property (nonatomic, assign) CGSize chartSize;

/*
 * Data is an array of dictionaries (all with the same model):
 * (string) key -> (string | numeric) value
 * How this data is used is specified in the implementation of 'getJSTextSeries'.
 */ 
- (void)setupChartWithData:(NSArray *)data;
// Load the html into the webview.
- (void)showChart;

/*
 * Functions that child class MUST implement.
 */
- (NSString *)getJSTextSeries;
- (NSString *)getJSTextAxes;
- (NSString *)getJSTextInteractions;
- (NSString *)getJSTextLegend;
- (void)reloadData;

@end

