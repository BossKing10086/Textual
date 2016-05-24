/* ********************************************************************* 
                  _____         _               _
                 |_   _|____  _| |_ _   _  __ _| |
                   | |/ _ \ \/ / __| | | |/ _` | |
                   | |  __/>  <| |_| |_| | (_| | |
                   |_|\___/_/\_\\__|\__,_|\__,_|_|

 Copyright (c) 2008 - 2010 Satoshi Nakagawa <psychs AT limechat DOT net>
 Copyright (c) 2010 - 2015 Codeux Software, LLC & respective contributors.
        Please see Acknowledgements.pdf for additional information.

 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions
 are met:

    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of Textual and/or "Codeux Software, LLC", nor the 
      names of its contributors may be used to endorse or promote products 
      derived from this software without specific prior written permission.

 THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
 FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 SUCH DAMAGE.

 *********************************************************************** */

#import "TextualApplication.h"

NS_ASSUME_NONNULL_BEGIN

TEXTUAL_EXTERN NSUInteger const IRCConnectionDefaultServerPort;
TEXTUAL_EXTERN NSUInteger const IRCConnectionDefaultProxyPort;

typedef NS_ENUM(NSUInteger, IRCConnectionSocketProxyType) {
	IRCConnectionSocketNoProxyType = 0,
	IRCConnectionSocketSystemSocksProxyType = 1,
	IRCConnectionSocketSocks4ProxyType = 4,
	IRCConnectionSocketSocks5ProxyType = 5,
	IRCConnectionSocketHTTPProxyType = 6,
	IRCConnectionSocketHTTPSProxyType = 7,
	IRCConnectionSocketTorBrowserType = 8
};

#pragma mark -
#pragma mark Immutable Object

@interface IRCClientConfig : NSObject <NSCopying, NSMutableCopying>
@property (readonly) BOOL autoConnect;
@property (readonly) BOOL autoReconnect;
@property (readonly) BOOL autoSleepModeDisconnect;
@property (readonly) BOOL autojoinWaitsForNickServ;
@property (readonly) BOOL connectionPrefersIPv6;
@property (readonly) BOOL connectionPrefersModernCiphers;

#if TEXTUAL_BUILT_WITH_ICLOUD_SUPPORT == 1
@property (readonly) BOOL excludedFromCloudSyncing;
#endif

@property (readonly) BOOL hideNetworkUnavailabilityNotices;
@property (readonly) BOOL performDisconnectOnPongTimer;
@property (readonly) BOOL performDisconnectOnReachabilityChange;
@property (readonly) BOOL performPongTimer;
@property (readonly) BOOL prefersSecuredConnection;
@property (readonly) BOOL saslAuthenticationUsesExternalMechanism;
@property (readonly) BOOL sendAuthenticationRequestsToUserServ;
@property (readonly) BOOL sendWhoCommandRequestsToChannels;
@property (readonly) BOOL setInvisibleModeOnConnect;
@property (readonly) BOOL sidebarItemExpanded;
@property (readonly) BOOL validateServerCertificateChain;
@property (readonly) BOOL zncIgnoreConfiguredAutojoin;
@property (readonly) BOOL zncIgnorePlaybackNotifications;
@property (readonly) BOOL zncIgnoreUserNotifications;
@property (readonly) IRCConnectionSocketProxyType proxyType;
@property (readonly) NSStringEncoding fallbackEncoding;
@property (readonly) NSStringEncoding primaryEncoding;
@property (readonly) NSTimeInterval lastMessageServerTime;
@property (readonly) NSUInteger floodControlDelayTimerInterval;
@property (readonly) NSUInteger floodControlMaximumMessages;
@property (readonly) uint16_t proxyPort;
@property (readonly) uint16_t serverPort;
@property (readonly, copy) NSString *connectionName;
@property (readonly, copy) NSString *nickname;
@property (readonly, copy) NSString *normalLeavingComment;
@property (readonly, copy) NSString *realName;
@property (readonly, copy) NSString *serverAddress;
@property (readonly, copy) NSString *sleepModeLeavingComment;
@property (readonly, copy) NSString *uniqueIdentifier;
@property (readonly, copy) NSString *username;
@property (readonly, copy, nullable) NSString *awayNickname;
@property (readonly, copy, nullable) NSString *nicknamePassword;
@property (readonly, copy, nullable) NSString *nicknamePasswordFromKeychain;
@property (readonly, copy, nullable) NSString *proxyAddress;
@property (readonly, copy, nullable) NSString *proxyPassword;
@property (readonly, copy, nullable) NSString *proxyPasswordFromKeychain;
@property (readonly, copy, nullable) NSString *proxyUsername;
@property (readonly, copy, nullable) NSString *serverPassword;
@property (readonly, copy, nullable) NSString *serverPasswordFromKeychain;
@property (readonly, copy, nullable) NSArray<IRCAddressBookEntry *> *ignoreList;
@property (readonly, copy, nullable) NSArray<IRCChannelConfig *> *channelList;
@property (readonly, copy, nullable) NSArray<IRCHighlightMatchCondition *> *highlightList;
@property (readonly, copy, nullable) NSArray<NSString *> *alternateNicknames;
@property (readonly, copy, nullable) NSArray<NSString *> *loginCommands;
@property (readonly, copy, nullable) NSData *identityClientSideCertificate;

- (instancetype)initWithDictionary:(NSDictionary<NSString *, id> *)dic NS_DESIGNATED_INITIALIZER;
- (NSDictionary<NSString *, id> *)dictionaryValue;
@end

#pragma mark -
#pragma mark Mutable Object

@interface IRCClientConfigMutable : IRCClientConfig
@property (nonatomic, assign, readwrite) BOOL autoConnect;
@property (nonatomic, assign, readwrite) BOOL autoReconnect;
@property (nonatomic, assign, readwrite) BOOL autoSleepModeDisconnect;
@property (nonatomic, assign, readwrite) BOOL autojoinWaitsForNickServ;
@property (nonatomic, assign, readwrite) BOOL connectionPrefersIPv6;
@property (nonatomic, assign, readwrite) BOOL connectionPrefersModernCiphers;

#if TEXTUAL_BUILT_WITH_ICLOUD_SUPPORT == 1
@property (nonatomic, assign, readwrite) BOOL excludedFromCloudSyncing;
#endif

@property (nonatomic, assign, readwrite) BOOL hideNetworkUnavailabilityNotices;
@property (nonatomic, assign, readwrite) BOOL performDisconnectOnPongTimer;
@property (nonatomic, assign, readwrite) BOOL performDisconnectOnReachabilityChange;
@property (nonatomic, assign, readwrite) BOOL performPongTimer;
@property (nonatomic, assign, readwrite) BOOL prefersSecuredConnection;
@property (nonatomic, assign, readwrite) BOOL saslAuthenticationUsesExternalMechanism;
@property (nonatomic, assign, readwrite) BOOL sendAuthenticationRequestsToUserServ;
@property (nonatomic, assign, readwrite) BOOL sendWhoCommandRequestsToChannels;
@property (nonatomic, assign, readwrite) BOOL setInvisibleModeOnConnect;
@property (nonatomic, assign, readwrite) BOOL sidebarItemExpanded;
@property (nonatomic, assign, readwrite) BOOL validateServerCertificateChain;
@property (nonatomic, assign, readwrite) BOOL zncIgnoreConfiguredAutojoin;
@property (nonatomic, assign, readwrite) BOOL zncIgnorePlaybackNotifications;
@property (nonatomic, assign, readwrite) BOOL zncIgnoreUserNotifications;
@property (nonatomic, assign, readwrite) IRCConnectionSocketProxyType proxyType;
@property (nonatomic, assign, readwrite) NSStringEncoding fallbackEncoding;
@property (nonatomic, assign, readwrite) NSStringEncoding primaryEncoding;
@property (nonatomic, assign, readwrite) NSTimeInterval lastMessageServerTime;
@property (nonatomic, assign, readwrite) NSUInteger floodControlDelayTimerInterval;
@property (nonatomic, assign, readwrite) NSUInteger floodControlMaximumMessages;
@property (nonatomic, assign, readwrite) uint16_t proxyPort;
@property (nonatomic, assign, readwrite) uint16_t serverPort;
@property (nonatomic, copy, readwrite) NSString *connectionName;
@property (nonatomic, copy, readwrite) NSString *nickname;
@property (nonatomic, copy, readwrite) NSString *normalLeavingComment;
@property (nonatomic, copy, readwrite) NSString *realName;
@property (nonatomic, copy, readwrite) NSString *serverAddress;
@property (nonatomic, copy, readwrite) NSString *sleepModeLeavingComment;
@property (nonatomic, copy, readwrite) NSString *username;
@property (nonatomic, copy, nullable, readwrite) NSString *awayNickname;
@property (nonatomic, copy, nullable, readwrite) NSString *nicknamePassword;
@property (nonatomic, copy, nullable, readwrite) NSString *proxyAddress;
@property (nonatomic, copy, nullable, readwrite) NSString *proxyPassword;
@property (nonatomic, copy, nullable, readwrite) NSString *proxyUsername;
@property (nonatomic, copy, nullable, readwrite) NSString *serverPassword;
@property (nonatomic, copy, nullable, readwrite) NSArray<IRCAddressBookEntry *> *ignoreList;
@property (nonatomic, copy, nullable, readwrite) NSArray<IRCChannelConfig *> *channelList;
@property (nonatomic, copy, nullable, readwrite) NSArray<IRCHighlightMatchCondition *> *highlightList;
@property (nonatomic, copy, nullable, readwrite) NSArray<NSString *> *alternateNicknames;
@property (nonatomic, copy, nullable, readwrite) NSArray<NSString *> *loginCommands;
@property (nonatomic, copy, nullable, readwrite) NSData *identityClientSideCertificate;
@end

NS_ASSUME_NONNULL_END
