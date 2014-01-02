//
//  AppDelegate.m
//  prova
//
//  Created by Gianguido Sorà on 02/01/14.
//  Copyright (c) 2014 Gianguido Sorà. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

float getGoxValueFloat(void);
float getBitstampValueFloat(void);
float getTheRockTradingValueFloat(void);
//NSString *getGoxValueStr(void);

// Mt.Gox value defined as a global float
float btcValue = 0.0;

//NSString *getGoxValueStr(void) {
//    NSURLRequest *goxJSONRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://data.mtgox.com/api/2/BTCUSD/money/ticker_fast"]];
//    NSData *goxJSONResponse = [NSURLConnection sendSynchronousRequest:goxJSONRequest returningResponse:nil error:nil];
//    NSError *jsonParsingError = nil;
//    NSMutableDictionary *goxData = [NSJSONSerialization JSONObjectWithData:goxJSONResponse options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:&jsonParsingError];
//    NSLog(@"Called getGoxValueFloat, got BTC value from Mt.Gox: (float)%@", goxData[@"data"][@"last"][@"display_short"]);
//    NSString *valueStr = goxData[@"data"][@"last"][@"display_short"];
//    return valueStr;
//}

float getGoxValueFloat(void) {
    NSURLRequest *goxJSONRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://data.mtgox.com/api/2/BTCUSD/money/ticker_fast"]];
    NSData *goxJSONResponse = [NSURLConnection sendSynchronousRequest:goxJSONRequest returningResponse:nil error:nil];
    NSError *jsonParsingError = nil;
    NSMutableDictionary *goxData = [NSJSONSerialization JSONObjectWithData:goxJSONResponse options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:&jsonParsingError];
    NSLog(@"Called getGoxValueFloat, got BTC value from Mt.Gox: (float)%@", goxData[@"data"][@"last"][@"value"]);
    NSNumber *conversionFactor = goxData[@"data"][@"last"][@"value"];
    float value = [conversionFactor floatValue];
    return value;
}

float getBitstampValueFloat(void) {
    NSURLRequest *bstampJSONRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.bitstamp.net/api/ticker/"]];
    NSData *bstampJSONResponse = [NSURLConnection sendSynchronousRequest:bstampJSONRequest returningResponse:nil error:nil];
    NSError *jsonParsingError = nil;
    NSMutableDictionary *bstampData = [NSJSONSerialization JSONObjectWithData:bstampJSONResponse options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:&jsonParsingError];
    NSLog(@"Called getBitstampValueFloat, got BTC value from Bitstamp: (float)%@", bstampData[@"last"]);
    NSNumber *conversionFactor = bstampData[@"last"];
    float value = [conversionFactor floatValue];
    return value;
}

float getTheRockTradingValueFloat(void) {
    NSURLRequest *trtJSONRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.therocktrading.com/api/ticker/BTCEUR"]];
    NSData *trtJSONResponse = [NSURLConnection sendSynchronousRequest:trtJSONRequest returningResponse:nil error:nil];
    NSError *jsonParsingError = nil;
    NSDictionary *trtData = [NSJSONSerialization JSONObjectWithData:trtJSONResponse options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:&jsonParsingError];
    NSArray *fetched = [trtData objectForKey:@"result"];
    NSNumber *conversionFactor;
    for (NSArray *arr in fetched) {
        conversionFactor = [arr valueForKey:@"last"];
    }
    //NSLog(@"Called getBitstampValueFloat, got BTC value from TheRockTrading: (float)%@", fetched);
    float value = [conversionFactor floatValue];
    return value;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [self.progressMe setHidden:false];
    [self.buttonCalcola setEnabled:false];
    [self.buttonAggiorna setEnabled:false];
    [self.progressMe startAnimation:self];
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // display in 12HR/24HR (i.e. 11:25PM or 23:25) format according to User Settings
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    NSString *currentTime = [dateFormatter stringFromDate:today];
    [_lastUpdate setStringValue: [NSString stringWithFormat: @"Last conversion rate update: %@", currentTime]];
    btcValue = getGoxValueFloat();
    [self.progressMe stopAnimation:self];
    [self.progressMe setHidden:true];
    [self.buttonCalcola setEnabled:true];
    [self.buttonAggiorna setEnabled:true];
}

- (IBAction)actionCalcola:(id)sender {
    float input = [_textInput floatValue];
    if (input <= 0) {
        NSAlert *alert = [[NSAlert alloc] init];
        [alert addButtonWithTitle:@"OK"];
        [alert setMessageText:@"What"];
        [alert setInformativeText:@"Are you serious?"];
        [alert setAlertStyle:NSWarningAlertStyle];
        [alert beginSheetModalForWindow:[self window] modalDelegate:self didEndSelector:nil contextInfo:nil];
        [_labelOut setStringValue: @""];
        [_textInput setStringValue: @""];
    } else {
        // approximation to nearest:
        // floorf(valToApprox * 100 + 0.5) / 100;
        float result = floorf((input * btcValue) * 100 + 0.5) / 100;
        [_labelOut setStringValue: [NSString stringWithFormat: @"%.2f%c", result, '$']];
    }
}
- (IBAction)actionAggiorna:(id)sender {
    [_progressMe setHidden:NO];
    [_progressMe startAnimation:self];
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // display in 12HR/24HR (i.e. 11:25PM or 23:25) format according to User Settings
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    NSString *currentTime = [dateFormatter stringFromDate:today];
    [_lastUpdate setStringValue: [NSString stringWithFormat: @"Last conversion rate update: %@", currentTime]];

    if ([_btcSource indexOfSelectedItem] == 0) {
        NSLog(@"Selected Mt.Gox as BTC value update source");
        btcValue = getGoxValueFloat();
    } else if([_btcSource indexOfSelectedItem] == 1) {
        NSLog(@"Selected Bitstamp as BTC value update source");
        btcValue = getBitstampValueFloat();
    } else if([_btcSource indexOfSelectedItem] == 2) {
        NSLog(@"Selected TheRockTrading as BTC value update source");
        btcValue = getTheRockTradingValueFloat();
    }
    
    [_progressMe stopAnimation:self];
    [_progressMe setHidden:YES];
}
@end
