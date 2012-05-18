//
//  SGGraphBaseViewController.h
//  SGGraphViewController
//
//  Created by Michele Amati on 5/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SGGraphBaseViewController : UIViewController <UIWebViewDelegate> {
    
    // The webview used to show the sencha configured page
    UIWebView *webview;
    // The path to the bundle 
    NSString *htmlIndex;
    // File system position of javascript files
    NSString *baseURL;
}

/*
 * Size is passed to sencha framework, and is not related to the frame
 * of the controller.
 * Data is an array of dictionaries (all with the same model):
 *      (string) key -> (string | numeric) value
 * How this data is used is specified in the implementation of 'getJSTextSeries'.
 */
- (id)initWithSize:(CGSize)size andData:(NSArray *)data;

// Load the html into the webview.
- (void)showChart;

/*
 * Method that child class MUST implement.
 */
- (NSString *)getJSTextSeries;

@end






//        //>>>>>>>>>>>>>>>>>>>>
//        NSDictionary *data_1 = [[NSDictionary alloc] initWithObjectsAndKeys:@"metric one",@"name",
//                                [[NSNumber alloc]initWithInt:1],@"data1",
//                                [[NSNumber alloc]initWithInt:1],@"data2",
//                                nil];
//        NSDictionary *data_2 = [[NSDictionary alloc] initWithObjectsAndKeys:@"metric two",@"name",
//                                [[NSNumber alloc]initWithInt:4],@"data1",
//                                [[NSNumber alloc]initWithInt:1],@"data2",
//                                nil];
//        NSDictionary *data_3 = [[NSDictionary alloc] initWithObjectsAndKeys:@"metric three",@"name",
//                                [[NSNumber alloc]initWithInt:8],@"data1",
//                                [[NSNumber alloc]initWithInt:1],@"data2",
//                                nil];
//        
//        NSArray *data = [[NSArray alloc] initWithObjects:data_1,data_2,data_3, nil];
//        //<<<<<<<<<<<<<<<<<<<<<<
