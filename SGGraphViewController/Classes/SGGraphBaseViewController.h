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
    SGAxis *_firstAxes;
    SGAxis *_secondAxes;
    NSString *_storeJSText;
    NSString *_seriesJSText;
    NSString *_chartJSText;
    NSString *_axesJSText;
    NSString *_fullJSTextPage;
    NSString *_containerJSText;
    NSString *_interactionsJSTexs;
}

/*
 * Size is passed to sencha framework, and is not related to the frame
 * of the controller.
 * Data is an array of dictionaries (all with the same model):
 *      (string) key -> (string | numeric) value
 * How this data is used is specified in the implementation of 'getJSTextSeries'.
 */ 
- (void)setupChartWithSize:(CGSize)size data:(NSArray *)data;
// Load the html into the webview.
- (void)showChart;

/*
 * Functions that child class MUST implement.
 */
- (NSString *)getJSTextSeries;
- (NSString *)getJSTextAxes;
- (NSString *)getJSTextInteractions;
- (void)reloadData;

@end

