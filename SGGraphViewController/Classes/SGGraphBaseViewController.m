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

//#define READ_INDEX_JS

@interface SGGraphBaseViewController ()

- (void)initialize;
- (NSString *)getJSTextContainer;
- (NSString *)getJSTextStore;
- (NSString *)getJSTextChart;
- (NSString *)getJSPage;

@end

@implementation SGGraphBaseViewController
@synthesize chartSize = _chartSize;

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

- (id)init
{
    self = [super init];
    if (self) {
        
        // Initializing local vars and loading bundle files
        [self initialize];
    }
    return self;
}

- (void)setupChartWithData:(NSArray *)data
{
    _data = data;
    NSString *fullJSTextPage = [self getJSPage];
    
#ifdef READ_INDEX_JS
    // Using the index.js file included in the bundle for fast changes/debugging purpose
    htmlIndex = [htmlIndex stringByReplacingOccurrencesOfString:@">{graph_javascript}" withString:@" src=\"index.js\">"];
#else
    // Injecting the javascript page into the html    
    htmlIndex = [htmlIndex stringByReplacingOccurrencesOfString:@"{graph_javascript}" withString:fullJSTextPage];
#endif
    
}

- (void)showChart
{
    [webview loadHTMLString:htmlIndex baseURL:[NSURL URLWithString:baseURL]];
}


#pragma mark - Private

- (NSString *)getJSTextStore
{
    static NSString *top = @"var store=new Ext.data.JsonStore({";
    static NSString *fieldsStr = @"fields:";
    static NSString *dataStr = @"data:";
    static NSString *bottom = @"});";
    
    // Adding top js part...
    NSString *store = [NSString stringWithString:top];
    
    // Adding fields
    store = [store stringByAppendingString:fieldsStr];
    store = [store stringByAppendingString:[[[_data objectAtIndex:0] allKeys] JSONString]];
    store = [store addComma];
    
    // Adding data
    store = [store stringByAppendingString:dataStr];
    store = [store stringByAppendingString:[_data JSONString]];
    
    // Closing js part...
    store = [store stringByAppendingString:bottom];
    
    return store;
}

- (NSString *)getJSTextChart
{
    // Writing size info only if they have being setted
    NSString *size = ((self.chartSize.height > 0 && self.chartSize.width > 0))
    ? [NSString stringWithFormat:@"width:%f,height:%f,",self.chartSize.width,self.chartSize.height]
    : [NSString string];
    
    static NSString *bottom = @"});";
    NSString *main = [NSString stringWithFormat:
                      @"var my_chart=new Ext.chart.Chart({"
                      "renderTo:Ext.getBody(),"
                      "%@"
                      "animate:true,"
                      "store:store,",
                      size];
    
    NSString *axesJSText = [self getJSTextAxes];
    NSString *interactionsJSTexs = [self getJSTextInteractions];
    NSString *seriesJSText = [self getJSTextSeries];
    NSString *legendJSText = [self getJSTextLegend];
    
    // Stick together axes + series + some other chart info to form the complete chart code.
    return [NSString stringWithFormat:@"%@%@%@%@%@%@",
            main,
            (axesJSText) ? [axesJSText addComma] : [NSString string],
            (interactionsJSTexs) ? [interactionsJSTexs addComma] : [NSString string],
            (legendJSText) ? [legendJSText addComma] : [NSString string],
            (seriesJSText) ? seriesJSText : [NSString string],
            bottom];
}

- (NSString *)getJSTextContainer
{
    NSString *layout;
    NSString *scroll;
    
    // Using setted size if avable, falling back to a fit layout if not
    if ((self.chartSize.height > 0 && self.chartSize.width > 0)) {
        layout = @"{type:'hbox',"
        "align:'center',"
        "pack:'center'}";
        
        /* 
         * Setting up the scrolling option based on chart size and view size.
         * A workaround to the device rotation problem is to enable scroll if in any 
         * of the possible orentation the chart will need it. 
         */
        
        if (self.chartSize.height > self.view.bounds.size.height || self.chartSize.height > self.view.bounds.size.width) {
            scroll = @"'vertical'";
        }
        if (self.chartSize.width > self.view.bounds.size.height || self.chartSize.width > self.view.bounds.size.width) {
            scroll = (!scroll) ? @"'horizontal'" : @"'both'";
        }
    }
    else {
        scroll = @"false";
        layout = @"'fit'";
    }
    
    return [NSString stringWithFormat:
            @"var my_container=new Ext.Panel({"
            "renderTo:Ext.getBody(),"
            "fullscreen:true,"
            "items:[my_chart],"
            "centered:true,"
            "scroll:%@,"
            "layout:%@"
            "});",
            scroll,
            layout];
}

- (NSString *)getJSPage
{
    // Stick together the store and the chart + some other page setup code to form a complete JS sencha page.
    
    static NSString *top = @"Ext.setup({onReady:function(){";
    static NSString *bottom = @"}});";
    
    return [NSString stringWithFormat:@"%@%@%@%@%@",
            top,
            [self getJSTextStore],
            [self getJSTextChart],
            [self getJSTextContainer],
            bottom];
}


#pragma mark - Subclass overriden methods

- (NSString *)getJSTextSeries
{
    return nil;
}

- (NSString *)getJSTextAxes
{
    return nil;
}

- (NSString *)getJSTextInteractions
{
    return nil;
}

- (NSString *)getJSTextLegend
{
    return nil;
}

- (void)reloadData 
{
    return;
}


#pragma mark - UIWebViewDelegate

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error 
{
    NSLog([error description],nil);
}


@end
