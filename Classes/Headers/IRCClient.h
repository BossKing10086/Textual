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

#import "IRCTreeItem.h"

#import "TVCLogLine.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, IRCClientConnectMode) {
	IRCClientConnectNormalMode = 0,
	IRCClientConnectRetryMode,
	IRCClientConnectReconnectMode,
	IRCClientConnectBadSSLCertificateMode,
};

typedef NS_ENUM(NSUInteger, IRCClientDisconnectMode) {
	IRCClientDisconnectNormalMode = 0,
	IRCClientDisconnectComputerSleepMode,
	IRCClientDisconnectBadSSLCertificateMode,
	IRCClientDisconnectReachabilityChangeMode,
	IRCClientDisconnectServerRedirectMode,
};

typedef NS_OPTIONS(NSUInteger, ClientIRCv3SupportedCapacities) {
	ClientIRCv3SupportedCapacityAwayNotify				= 1 << 0, // YES if away-notify CAP supported
	ClientIRCv3SupportedCapacityIdentifyCTCP			= 1 << 1, // YES if identify-ctcp CAP supported
	ClientIRCv3SupportedCapacityIdentifyMsg				= 1 << 2, // YES if identify-msg CAP supported
	ClientIRCv3SupportedCapacityMultiPreifx				= 1 << 3, // YES if multi-prefix CAP supported
	ClientIRCv3SupportedCapacityServerTime				= 1 << 4, // YES if server-time CAP supported
	ClientIRCv3SupportedCapacityUserhostInNames			= 1 << 5, // YES if userhost-in-names CAP supported
	ClientIRCv3SupportedCapacityWatchCommand			= 1 << 6, // YES if the WATCH command is supported
	ClientIRCv3SupportedCapacityIsInSASLNegotiation		= 1 << 7, // YES if in SASL CAP authentication request
	ClientIRCv3SupportedCapacityIsIdentifiedWithSASL	= 1 << 8, // YES if SASL authentication was successful
	ClientIRCv3SupportedCapacityZNCSelfMessage			= 1 << 14, // YES if the ZNC vendor specific CAP supported
	ClientIRCv3SupportedCapacityZNCPlaybackModule		= 1 << 15, // YES if the ZNC vendor specific CAP supported
	ClientIRCv3SupportedCapacityBatch					= 1 << 16, // YES if batch CAP supported
	ClientIRCv3SupportedCapacityZNCCertInfoModule		= 1 << 17  // YES if the ZNC vendor specific CAP supported
};

typedef void (^IRCClientPrintToWebViewCompletionBlock)(BOOL isHighlight);

TEXTUAL_EXTERN NSString * const IRCClientConfigurationWasUpdatedNotification;
TEXTUAL_EXTERN NSString * const IRCClientChannelListWasModifiedNotification;

@interface IRCClient : IRCTreeItem
@property (getter=isReconnecting, readonly) BOOL reconnecting;
@property (readonly) BOOL autojoinInProgress;			// YES if autojoin is in progress
@property (readonly) BOOL connectionIsSecured;			// Yes if socket is connected using SSL
@property (readonly) BOOL hasIRCopAccess;				// YES if local user is IRCop
@property (readonly) BOOL isAutojoined;					// YES if autojoin has been completed
@property (readonly) BOOL isAway;						// YES if Textual has knowledge of local user being away
@property (readonly) BOOL isConnected;					// YES if socket is connected
@property (readonly) BOOL isConnecting;					// YES if socket is connecting. Set to NO on raw numeric 001.
@property (readonly) BOOL isIdentifiedWithNickServ;		// YES if NickServ identification was successful
@property (readonly) BOOL isLoggedIn;					// YES if connected to server. Set to YES on raw numeric 001.
@property (readonly) BOOL isQuitting;					// YES if connection to IRC server is being quit
@property (readonly) BOOL isWaitingForNickServ;			// YES if NickServ identification is pending
@property (readonly) BOOL isZNCBouncerConnection;		// YES if Textual detected that this connection is ZNC based
@property (readonly) BOOL reconnectEnabled;				// YES if reconnection is allowed
@property (readonly) BOOL serverHasNickServ;			// YES if NickServ service was found on server
@property (readonly) ClientIRCv3SupportedCapacities capacities;
@property (readonly) IRCClientConnectMode connectType;
@property (readonly) IRCClientDisconnectMode disconnectType;
@property (readonly) IRCISupportInfo *supportInfo;
@property (readonly) NSTimeInterval lastMessageReceived;			// The time at which the last of any incoming data was received.
@property (readonly) NSTimeInterval lastMessageServerTime;			// The time of the last message received that contained a server-time CAP.
@property (readonly) NSUInteger channelCount;
@property (readonly, copy) IRCClientConfig *config;
@property (readonly, copy) NSArray<IRCChannel *> *channelList;
@property (readonly, copy, nullable) NSArray<IRCHighlightLogEntry *> *cachedHighlights;
@property (readonly, copy, nullable) NSData *zncBouncerCertificateChainData;
@property (readonly, copy, nullable) NSString *localHostmask;
@property (readonly, copy, nullable) NSString *localNickname;
@property (readonly, copy, nullable) NSString *networkAddress;
@property (readonly, copy, nullable) NSString *networkName; // Only returns the actual network name or nil.
@property (readonly, copy, nullable) NSString *networkNameAlt; // Will return the configured name if the actual name is not available.
@property (readonly, copy, nullable) NSString *preAwayNickname; // Nickname before away was set.
@property (readonly, nullable) IRCChannel *lastSelectedChannel; // If this is the selected client, then the value of this property is the current selection. If the current client is not selected, then this value is either its previous selection or nil.

- (void)connect;
- (void)connect:(IRCClientConnectMode)mode;
- (void)connect:(IRCClientConnectMode)mode preferringIPv6:(BOOL)preferIPv6;

- (void)disconnect;
- (void)quit;
- (void)quitWithComment:(NSString *)comment;
- (void)cancelReconnect;

- (BOOL)isCapacityAvailable:(NSString *)cap;

- (BOOL)isCapacityEnabled:(ClientIRCv3SupportedCapacities)capacity;

@property (readonly, copy) NSString *enabledCapacitiesStringValue;

- (void)joinChannel:(IRCChannel *)channel;
- (void)joinChannel:(IRCChannel *)channel password:(NSString *)password;
- (void)joinUnlistedChannel:(NSString *)channel;
- (void)joinUnlistedChannel:(NSString *)channel password:(NSString *)password;
- (void)forceJoinChannel:(NSString *)channel password:(NSString *)password;
- (void)partChannel:(IRCChannel *)channel;
- (void)partChannel:(IRCChannel *)channel withComment:(NSString *)comment;
- (void)partUnlistedChannel:(NSString *)channel;
- (void)partUnlistedChannel:(NSString *)channel withComment:(NSString *)comment;

- (void)sendWhois:(NSString *)nickname;
- (void)changeNickname:(NSString *)newNickname;
- (void)kick:(NSString *)nickname inChannel:(IRCChannel *)channel;
- (void)sendCTCPQuery:(NSString *)target command:(NSString *)command text:(nullable NSString *)text;
- (void)sendCTCPReply:(NSString *)target command:(NSString *)command text:(nullable NSString *)text;
- (void)sendCTCPPing:(NSString *)target;

- (void)toggleAwayStatus:(BOOL)setAway;
- (void)toggleAwayStatus:(BOOL)setAway withComment:(NSString *)comment;

- (void)createChannelListWindow;
- (void)createChannelInviteExceptionListSheet;
- (void)createChannelBanExceptionListSheet;
- (void)createChannelBanListSheet;

- (void)presentCertificateTrustInformation;

- (void)closeDialogs;

- (nullable IRCChannel *)findChannel:(NSString *)name;
- (nullable IRCChannel *)findChannelOrCreate:(NSString *)name;
- (nullable IRCChannel *)findChannelOrCreate:(NSString *)name isPrivateMessage:(BOOL)isPrivateMessage;

- (nullable NSData *)convertToCommonEncoding:(NSString *)data;
- (nullable NSString *)convertFromCommonEncoding:(NSData *)data;

- (NSString *)formatNickname:(NSString *)nickname inChannel:(IRCChannel *)channel;
- (NSString *)formatNickname:(NSString *)nickname inChannel:(IRCChannel *)channel withFormat:(nullable NSString *)format;

- (BOOL)nicknameIsZNCUser:(NSString *)nickname;
- (NSString *)nicknameAsZNCUser:(NSString *)nickname;

- (nullable IRCAddressBookEntry *)checkIgnoreAgainstHostmask:(NSString *)hostmask withMatches:(NSArray<NSString *> *)matches;

- (BOOL)outputRuleMatchedInMessage:(NSString *)message inChannel:(IRCChannel *)channel withLineType:(TVCLogLineType)type;

#pragma mark -

- (void)sendCommand:(id)string;
- (void)sendCommand:(id)string completeTarget:(BOOL)completeTarget target:(nullable NSString *)targetChannelName;
- (void)sendText:(NSAttributedString *)string asCommand:(NSString *)command toChannel:(IRCChannel *)channel;
- (void)sendText:(NSAttributedString *)string asCommand:(NSString *)command toChannel:(IRCChannel *)channel withEncryption:(BOOL)encryptText;

- (void)sendLine:(NSString *)string;
- (void)send:(NSString *)string, ...;

- (void)sendPrivmsg:(NSString *)message toChannel:(IRCChannel *)channel; // Invoke -sendText: with proper values
- (void)sendAction:(NSString *)message toChannel:(IRCChannel *)channel;
- (void)sendNotice:(NSString *)message toChannel:(IRCChannel *)channel;

/* When using -sendPrivmsgToSelectedChannel:, if the actual selected channel in the main
 window is not owned by this client, then the message will be sent to the server console. */
/* The method obviously does not work as expected so it has been marked as deprecated.
 However, it will remain functional for plugin authors who wish to use it. */
- (void)sendPrivmsgToSelectedChannel:(NSString *)message TEXTUAL_DEPRECATED("Use sendPrivmsg:toChannel: instead");

#pragma mark -

// nil channel = server console
- (void)print:(NSString *)messageBody by:(nullable NSString *)nickname inChannel:(nullable id)channel;
- (void)print:(NSString *)messageBody by:(nullable NSString *)nickname inChannel:(nullable id)channel asCommand:(NSString *)command;
- (void)print:(NSString *)messageBody by:(nullable NSString *)nickname inChannel:(nullable id)channel asCommand:(NSString *)command receivedAt:(NSDate *)receivedAt;
- (void)print:(NSString *)messageBody by:(nullable NSString *)nickname inChannel:(nullable id)channel asCommand:(NSString *)command receivedAt:(NSDate *)receivedAt isEncrypted:(BOOL)isEncrypted;
- (void)print:(NSString *)messageBody by:(nullable NSString *)nickname inChannel:(nullable id)channel asCommand:(NSString *)command receivedAt:(NSDate *)receivedAt isEncrypted:(BOOL)isEncrypted withReferenceMessage:(nullable IRCMessage *)referenceMessage;
- (void)print:(NSString *)messageBody by:(nullable NSString *)nickname inChannel:(nullable id)channel asCommand:(NSString *)command receivedAt:(NSDate *)receivedAt isEncrypted:(BOOL)isEncrypted withReferenceMessage:(nullable IRCMessage *)referenceMessage completionBlock:(nullable IRCClientPrintToWebViewCompletionBlock)completionBlock;

- (void)printDebugInformationToConsole:(NSString *)message;
- (void)printDebugInformationToConsole:(NSString *)message asCommand:(NSString *)command;

- (void)printDebugInformation:(NSString *)message;
- (void)printDebugInformation:(NSString *)message asCommand:(NSString *)command;

- (void)printDebugInformation:(NSString *)message inChannel:(IRCChannel *)channel;
- (void)printDebugInformation:(NSString *)message inChannel:(IRCChannel *)channel asCommand:(NSString *)command;
@end

NS_ASSUME_NONNULL_END
