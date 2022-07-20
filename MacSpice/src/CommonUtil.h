//
//  CommonUtil.h
//  Sender
//
//  Created by djpark on 14. 1. 28..
//
//

#import <Foundation/Foundation.h>

@interface CommonUtil : NSObject

+ (void) showSpinnerAlertView:(NSString *)str;
+ (void) cancelSpinnerAlertView;
+ (void) cancelSpinnerAlertView:(NSString *)errorStr errorState:(BOOL)isError;
+ (NSString*) bundleSeedID;
+ (void) saveKeyChainData:(id)object forKey:(id)key;
+ (id) loadKeyChainData:(id)key;

@end
