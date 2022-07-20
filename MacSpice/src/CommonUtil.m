//
//  CommonUtil.m
//  Sender
//
//  Created by djpark on 14. 1. 28..
//
//

#import "CommonUtil.h"
//#import "KeychainItemWrapper.h"

//@implementation CommonUtil
//
//static UIAlertView *progressAlert;
//static UIActivityIndicatorView *spinner;
//
//#pragma mark - 스피너 팝업 Show
//+ (void) showSpinnerAlertView:(NSString *)str {
//    progressAlert =[[UIAlertView alloc] initWithTitle:@"\n" message:str delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
//    [progressAlert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
//    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
//    spinner.center = CGPointMake(progressAlert.bounds.size.width / 2, progressAlert.bounds.size.height - 50);
//    [spinner startAnimating];
//    [progressAlert addSubview:spinner];
//    [spinner release];
//}
//
//#pragma mark - 스피너 팝업 Cancel
//+ (void) cancelSpinnerAlertView {
//    [NSThread sleepForTimeInterval:1.0f];
//    if ([spinner isAnimating]) {
//        [progressAlert dismissWithClickedButtonIndex:0 animated:YES];
//    }
//}
//
//#pragma mark - 스피너 팝업 에러시
//+ (void) cancelSpinnerAlertView:(NSString *)errorStr errorState:(BOOL)isError {
//    [NSThread sleepForTimeInterval:1.0f];
//    if ([spinner isAnimating]) {
////        [spinner stopAnimating];
//        [progressAlert dismissWithClickedButtonIndex:0 animated:YES];
//    }
//    if (isError) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"\n" message:errorStr delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
//        [alert show];
//        [alert release];
//    }
//}
//
//+ (NSString *) bundleSeedID {
//    NSDictionary *query = [NSDictionary dictionaryWithObjectsAndKeys:
//                           kSecClassGenericPassword, kSecClass,
//                           @"bundleSeedID", kSecAttrAccount,
//                           @"", kSecAttrService,
//                           (id)kCFBooleanTrue, kSecReturnAttributes,
//                           nil];
//    CFDictionaryRef result = nil;
//    OSStatus status = SecItemCopyMatching((CFDictionaryRef)query, (CFTypeRef *)&result);
//    if (status == errSecItemNotFound)
//        status = SecItemAdd((CFDictionaryRef)query, (CFTypeRef *)&result);
//    if (status != errSecSuccess)
//        return nil;
//    NSString *accessGroup = [(NSDictionary *)result objectForKey:kSecAttrAccessGroup];
//    NSArray *components = [accessGroup componentsSeparatedByString:@"."];
//    NSString *bundleSeedID = [[components objectEnumerator] nextObject];
//    CFRelease(result);
//    return bundleSeedID;
//}
//
//+ (void) saveKeyChainData:(id)object forKey:(id)key {
//    NSString *comIDStr = @"7DV2PG485K";
//
//    KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:@"Account Number" accessGroup:[NSString stringWithFormat:@"%@.%@", comIDStr, key]];
//    [wrapper setObject:object forKey:(NSString*)kSecValueData];
//    [wrapper release];
//}
//
//+ (id) loadKeyChainData:(id)key {
////    NSLog(@"load keychain try 1");
//    NSString *retString = nil;
//    NSString *comIDStr = @"7DV2PG485K";
//
//    KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:@"Account Number" accessGroup:[NSString stringWithFormat:@"%@.%@", comIDStr, key]];
//    retString = [wrapper objectForKey:(NSString *)kSecValueData];
//    [wrapper release];
////    NSLog(@"load keychain try retString : %@", retString);
//    return retString;
//}
//
//
//@end
