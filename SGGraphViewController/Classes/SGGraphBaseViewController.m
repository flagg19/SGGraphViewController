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
- (void)getJSTextContainer;
- (void)getJSTextStore;
- (void)getJSTextChart;
- (void)getJSPage;

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
    // Using setted size if avable, falling back to view's bounds otherwise
    _size = (self.chartSize.height > 0 && self.chartSize.width > 0)
    ? _chartSize
    : self.view.bounds.size;
    
    _data = data;
    
    /* 
     * Building the JS page, piece by piece.
     * WARNING do not change the order of this calls, each on use the previous
     * resutls setted in the global vars of this class to work.
     */
    [self getJSTextStore];
    
    // Functions that will be implemented in subclass to provide specialized charts
    _axesJSText = [self getJSTextAxes];
    _seriesJSText = [self getJSTextSeries];
    _interactionsJSTexs = [self getJSTextInteractions];
    
    // Continue building the js page...
    [self getJSTextChart];
    [self getJSTextContainer];
    [self getJSPage];
    
    #ifdef READ_INDEX_JS
    // Using the index.js file included in the bundle for fast changes/debugging purpose
    htmlIndex = [htmlIndex stringByReplacingOccurrencesOfString:@">{graph_javascript}" withString:@" src=\"index.js\">"];
    #else
    // Injecting the javascript page into the html    
    htmlIndex = [htmlIndex stringByReplacingOccurrencesOfString:@"{graph_javascript}" withString:_fullJSTextPage];
    #endif
    
}

- (void)showChart
{
    [webview loadHTMLString:htmlIndex baseURL:[NSURL URLWithString:baseURL]];
}


#pragma mark - Private

- (void)getJSTextStore
{
    if (!_data || [_data count] == 0) {
        _storeJSText = nil;
        return;
    }
    
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
    
    _storeJSText = store;
}

- (void)getJSTextChart
{
    // Stick together the axes and the series + some other chart info to form the complete chart code.
    
    static NSString *bottom = @"});";
    NSString *main = [NSString stringWithFormat:
                      @"var my_chart=new Ext.chart.Chart({"
                      "renderTo:Ext.getBody(),"
                      "width:%f,"
                      "height:%f,"
                      "animate:true,"
                      "store:store,",
                      _size.width,_size.height];
    
    _chartJSText = [NSString stringWithFormat:@"%@%@%@%@%@",
                    main,
                    (_axesJSText) ? [_axesJSText addComma] : [NSString string],
                    (_interactionsJSTexs) ? [_interactionsJSTexs addComma] : [NSString string],
                    _seriesJSText,
                    bottom];
}

- (void)getJSTextContainer
{
    /* 
     * Setting up the scrolling option based on chart size and view size.
     * A workaround to the device rotation problem is to enable scroll if in any 
     * of the possible orentation the chart will need it. 
     */
    
    NSString *scroll = [NSString string];
    if (_size.height > self.view.bounds.size.height || _size.height > self.view.bounds.size.width) {
        scroll = @"vertical";
    }
    if (_size.width > self.view.bounds.size.height || _size.width > self.view.bounds.size.width) {
        scroll = ([scroll isEqualToString:[NSString string]]) ? @"horizontal" : @"both";
    }
    
    _containerJSText = [NSString stringWithFormat:
    @"var my_container = new Ext.Panel({"
    "renderTo:Ext.getBody(),"
    "fullscreen: true,"
    "items: [my_chart],"
    "centered: true,"
    "scroll: '%@',"
    "layout: {"
    "type: 'hbox',"
    "align: 'center',"
    "pack: 'center'"
    "}});",scroll];
}

- (void)getJSPage
{
    // Stick together the store and the chart + some other page setup code to form a complete JS sencha page.
    
    static NSString *top = @"Ext.setup({onReady:function(){";
    static NSString *bottom = @"}});";
    
    _fullJSTextPage = [NSString stringWithFormat:@"%@%@%@%@%@",top,_storeJSText,_chartJSText,_containerJSText,bottom];
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
