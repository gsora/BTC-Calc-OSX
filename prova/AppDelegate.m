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

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [_progressMe setHidden:false];
    [_buttonCalcola setEnabled:false];
    [_buttonAggiorna setEnabled:false];
    [_progressMe startAnimation:self];
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // display in 12HR/24HR (i.e. 11:25PM or 23:25) format according to User Settings
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    NSString *currentTime = [dateFormatter stringFromDate:today];
    [_lastUpdate setStringValue: [NSString stringWithFormat: @"Last update:\n %@", currentTime]];
    btcValue = getGoxValueFloat();
    [_progressMe stopAnimation:self];
    [_progressMe setHidden:true];
    [_buttonCalcola setEnabled:true];
    [_buttonAggiorna setEnabled:true];
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
    [_progressMe setHidden:false];
    [_buttonCalcola setEnabled:false];
    [_buttonAggiorna setEnabled:false];
    [_progressMe startAnimation:self];
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // display in 12HR/24HR (i.e. 11:25PM or 23:25) format according to User Settings
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    NSString *currentTime = [dateFormatter stringFromDate:today];
    [_lastUpdate setStringValue: [NSString stringWithFormat: @"Last update:\n %@", currentTime]];
    btcValue = getGoxValueFloat();
    [_progressMe stopAnimation:self];
    [_progressMe setHidden:true];
    [_buttonCalcola setEnabled:true];
    [_buttonAggiorna setEnabled:true];
}
@end
