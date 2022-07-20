/*!
 * @header ISignPlus.h
 * ISign+ 의 SSO(Single Sign On) 기능을 모바일에서 사용하기 위한 기능을 제공하는 라이브러리.
 * @charset utf-8
 * @copyright ⓒ2016 Penta Security Systems Inc. All rights reserved.
 * @author HA JI YOON
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/*!
 * @typedef SymmetricAlgorithm
 * @brief 대칭키 암호화 알고리즘
 */
typedef enum {
    SEED = 0,
    ARIA,
    AES
} SymmetricAlgorithm;

/*!
 * @typedef CharacterSetEncoding
 * @brief 문자셋
 */
typedef enum {
    EUC_KR = 0,
    UTF_8,
    UTF_16,
    ISO_8895_1,
    US_ASCII,
    KSC5601
} CharacterSetEncoding;

extern NSString* const IOS_TOKEN_PREFIX;
extern NSString* const IOS_LOGOUT_PREFIX;

/*!
 * @class ISignPlus
 * @abstract ISign+ 의 SSO 관련 기능을 제공한다.
 * @discussion 이 객체를 사용하려면 Keychain Sharing과 App Transport Security 관련 설정이 필요하다
 * <p>Keychain Sharing</p>
 * <ol type="1">
 * <li> 프로젝트 설정 -> Capabilities -> Keychain Sharing 을 켠다.
 * <li> Keychain Groups 에 로그인 정보를 공유할 앱에서 사용할 Group 을 등록한다 (ex. com.pentasecurity.KeychainAppSuite)
 * </ol>
 * <p>App Transport Security</p>
 * <ol type="1">
 * <li> 특정 도메인만 허용 : Info.plist - App Transport Security Settings - Exception Domains 에 해당 도메인 등록.
 *   <ul>
 *      <li> 예외로 등록한 도메인 아래에 어떤 기능을 예외로 할 것인지 설정해야 한다.
 *      <li> 기본적으로는 NSExceptionAllowsInsecureHTTPLoads 만 설정하면 되지만, 상세설정은 <a href="https://developer.apple.com/library/ios/documentation/General/Reference/InfoPlistKeyReference/Articles/CocoaKeys.html#//apple_ref/doc/uid/TP40009251-SW44">Exception domains dictionary keys</a> 를 참고하여 추가한다.
 *      <li> 이 기능은 IP의 경우 사용할 수 없다. (<a href="https://developer.apple.com/library/ios/documentation/General/Reference/InfoPlistKeyReference/Articles/CocoaKeys.html#//apple_ref/doc/uid/TP40009251-SW33">CococaKeys - NSAppTransportSecurity</a>)
 *   </ul>
 * <li> ATS 기능 비활성화 : Info.plist - App Transport Security Settings - Allows Arbitrary Loads 를 YES로 등록.
 * </ol>
 * <p>App Transport Security에 대한 정보는 위 링크 외에도 인터넷에 많으므로, 상세한 정보는 인터넷으로 찾아보는 것이 좋다.</p>
 */
@interface ISignPlus : NSObject

#pragma mark 설정 관련 함수

/*!
 * @discussion 필수 설정과 함께 초기화한다.
 * @param aServer       서버의 주소 (ex. login.pentasecurity.com)
 * @param aSsid         서비스 ID. ISign+ 매뉴얼 참조.
 * @param aPublicKeyB64 로그인 정보 암호화를 위한 서버 공개키
 * @param aService      토큰 정보 공유를 위한 서비스 명 (고객 임의의 문자열 사용. Keychain Sharing 참조)
 * @param aGroup        [Bundle Seed ID] + [Keychain Sharing에 등록한 Keychain Group] <br />
 *                      (ex. QWVW6Y84W4.com.pentasecurity.KeychainAppSuite)
 * @return 초기화 된 객체
 */
- (id)initWithServer:(NSString *)aServer protocol:(NSString *)aProtocol ssid:(NSString *)aSsid publicKey:(NSString *)aPublicKeyB64
             service:(NSString *)aService group:(NSString *)aGroup;

/*!
 * @discussion 서버 정보를 설정한다.
 * @param aServer       서버의 주소 (ex. login.pentasecurity.com)
 * @param aSsid         서비스 ID. ISign+ 매뉴얼 참조.
 * @param aPublicKeyB64 로그인 정보 암호화를 위한 서버 공개키
 * @return 설정 성공 여부
 */
- (BOOL)setServer:(NSString *)aServer protocol:(NSString *)aProtocol ssid:(NSString *)aSsid publicKey:(NSString *)aPublicKeyB64;

/*!
 * @discussion Keychain Sharing 관련 정보를 설정한다.
 * @param aService      토큰 정보 공유를 위한 서비스 명 (고객 임의의 문자열 사용. Keychain Sharing 참조)
 * @param aGroup        [Bundle Seed ID] + [Keychain Sharing에 등록한 Keychain Group] <br />
 *                      (ex. QWVW6Y84W4.com.pentasecurity.KeychainAppSuite)
 * @return 설정 성공 여부
 */
- (BOOL)setKeychain:(NSString *)aService group:(NSString *)aGroup;

/*!
 * @discussion 데이터 암호화에 사용하는 대칭키 암호화 알고리즘을 설정한다. (기본값 : SEED)
 * @param aSymmAlg  대칭키 암호화 알고리즘
 */
- (void)setSymmetricAlgorithm:(SymmetricAlgorithm)aSymmAlg;

/*!
 * @discussion 문자열의 문자셋을 설정한다. (기본값 : EUC_KR)
 * @param aCharset  문자셋
 */
- (void)setCharacterSetEncoding:(CharacterSetEncoding)aCharset;

/*!
 * @discussion 로그를 출력할 TextView를 설정한다. (개발용)
 * @param textView  로그가 출력될 TextView
 */
- (void)setLogViewer:(UITextView *)textView;

- (void)enableLog:(BOOL)enable;


#pragma mark 앱에서 사용할 기능

/*!
 * @discussion 현재 유효한 세션을 가지고 있는지 확인한다.
 * @return 유효한 세션을 가지고 있는지에 대한 결과
 */
- (BOOL)hasValidSession;

/*!
 * @discussion 주어진 ID와 패스워드로 로그인한다.
 * @param userID        사용자 ID
 * @param userPassword  사용자 패스워드
 * @return 로그인 결과
 */
- (BOOL)loginId:(NSString *)userID password:(NSString *)userPassword toIssacWeb:(BOOL)aToIssacWeb;

/*!
 * @discussion  ISign+ 에서 로그아웃한다.
 * @return 로그아웃 결과
 */
- (BOOL)logout;

/*!
 * @discussion ISign+ 서버에 정보를 요청한다.
 * @param aRequestArray  요청할 데이터들.
 * @return 요청한 데이터에 대한 결과값 (key, value 형식의 NSDictionary 객체)
 */
- (NSDictionary *)requestSsoData:(NSArray *)aRequestArray;

/*!
 * @discussion SSO 정보를 통해 업무서버에 접근한다.
 * @param serviceUrl    업무서버 주소
 * @return WebView에 사용할 NSURLRequest 객체
 */
- (NSURLRequest *)getRequestForWebView:(NSString *)serviceUrl;

/*!
 * @discussion WebView를 통해 전달받은 토큰 정보를 저장한다.
 * @param response  전달받은 토큰 정보 (ios:setLoginData: 로 시작하는 값)
 * @return 토큰 정보 저장 결과
 */
- (BOOL)saveTokenFromWebView:(NSString *)response;

/*!
 * @discussion 토큰 정보를 저장한다.
 * @param token  토큰 정보 (ex. secureSessionId=XXX&secureToken=YYYY)
 * @return 토큰 정보 저장 결과
 */
- (BOOL)saveTokenFromKeyValue:(NSString *)token;

@end
