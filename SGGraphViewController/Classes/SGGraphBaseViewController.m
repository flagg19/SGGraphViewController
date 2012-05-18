//
//  SGGraphBaseViewController.m
//  SGGraphViewController
//
//  Created by Michele Amati on 5/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SGGraphBaseViewController.h"
#import "NSString+Additions.h"
#import "JSONKit.h"

@interface SGGraphBaseViewController ()

- (void)initialize;

- (NSString *)getJSTextStore:(NSArray *)data;
- (NSString *)getJSTextChartWithSize:(CGSize)size;
- (NSString *)getJSPageWithStore:(NSString *)store andChart:(NSString *)chart;

@end

@implementation SGGraphBaseViewController

- (void)initialize
{
    // Initializing istance vars
    webview = [[UIWebView alloc] init];
    self.view = webview;
    webview.delegate = self;

    // Initializing html page to load
    NSError *error = nil;
    baseURL = [NSString stringWithFormat:@"%@/Sencha.bundle/", [[NSBundle mainBundle] bundleURL]];
    htmlIndex = [NSString stringWithContentsOfFile:[NSString stringWithFormat:@"%@/Sencha.bundle/index.html", [[NSBundle mainBundle] bundlePath]]
                                               encoding:NSUTF8StringEncoding
                                                  error:&error];
    if (error)
    {
        NSLog([error localizedDescription],nil);
        NSLog([error localizedFailureReason],nil);
    }
    
    // TOTO: the title is the html tag title, don't known if it could be usefull to set it
    htmlIndex = [htmlIndex stringByReplacingOccurrencesOfString:@"{title}" withString:@"SGGraph"];
}

- (id)initWithSize:(CGSize)size andData:(NSArray *)data
{
    self = [super init];
    if (self) {
        
        // Initializing local vars and loading bundle files
        [self initialize];
        
        // Building javascript chart page
        NSString *jsIndex = [self getJSPageWithStore:[self getJSTextStore:data] andChart:[self getJSTextChartWithSize:size]];
        
        // Injecting the javascript page into the html
        htmlIndex = [htmlIndex stringByReplacingOccurrencesOfString:@"{graph_javascript}" withString:jsIndex];
    }
    return self;
}

- (void)showChart
{
    [webview loadHTMLString:htmlIndex baseURL:[NSURL URLWithString:baseURL]];
}


#pragma mark - Private

- (NSString *)getJSTextStore:(NSArray *)data
{
    if (!data || [data count] == 0) {
        return nil;
    }
    
    static NSString *top = @"var store=new Ext.data.JsonStore({";
    static NSString *fieldsStr = @"fields:";
    static NSString *dataStr = @"data:";
    static NSString *bottom = @"});";
    
    // Adding top js part...
    NSString *store = [NSString stringWithString:top];
    
    // Adding fields
    store = [store stringByAppendingString:fieldsStr];
    store = [store stringByAppendingString:[[[data objectAtIndex:0] allKeys] JSONString]];
    store = [store addComma];
    
    // Adding data
    store = [store stringByAppendingString:dataStr];
    store = [store stringByAppendingString:[data JSONString]];
    
    // Closing js part...
    store = [store stringByAppendingString:bottom];
    
    return store;
}

- (NSString *)getJSTextChartWithSize:(CGSize)size
{
    static NSString *bottom = @"});";
    NSString *main = [NSString stringWithFormat:
                      @"new Ext.chart.Chart({\
                      renderTo: Ext.getBody(),\
                      width: %f,\
                      height: %f,\
                      store: store,",size.width,size.height];
    
    // getJSTextSeries will be implemented in subclass to provide specialized charts
    return [NSString stringWithFormat:@"%@%@%@",main,[self getJSTextSeries],bottom];
}

- (NSString *)getJSPageWithStore:(NSString *)store andChart:(NSString *)chart
{
    static NSString *top = @"Ext.setup({onReady:function(){";
    static NSString *bottom = @"}});";
    
    // Putting all things together...
    return [NSString stringWithFormat:@"%@%@%@%@",top,store,chart,bottom];
}

#pragma mark - Subclass overriden methods

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

#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error 
{
    NSLog([error description],nil);
}


@end
