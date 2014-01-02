//
//  AppDelegate.h
//  prova
//
//  Created by Gianguido Sorà on 02/01/14.
//  Copyright (c) 2014 Gianguido Sorà. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSTextField *textInput;
@property (weak) IBOutlet NSTextField *labelOut;
@property (weak) IBOutlet NSButton *buttonCalcola;
- (IBAction)actionCalcola:(id)sender;
@property (weak) IBOutlet NSButton *buttonAggiorna;
- (IBAction)actionAggiorna:(id)sender;
@property (weak) IBOutlet NSTextField *lastUpdate;
@property (weak) IBOutlet NSProgressIndicator *progressMe;

@end
