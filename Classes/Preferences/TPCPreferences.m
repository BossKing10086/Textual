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

NS_ASSUME_NONNULL_BEGIN

NSString * const TPCPreferencesThemeNameDefaultsKey	= @"Theme -> Name";

NSString * const TPCPreferencesThemeFontNameDefaultsKey	= @"Theme -> Font Name";
NSString * const TPCPreferencesThemeFontSizeDefaultsKey	= @"Theme -> Font Size";

NSString * const TPCPreferencesThemeNameMissingLocallyDefaultsKey = @"Theme -> Name -> Did Not Exist During Last Sync";

NSString * const TPCPreferencesThemeFontNameMissingLocallyDefaultsKey = @"Theme -> Font Name -> Did Not Exist During Last Sync";

NSUInteger const TPCPreferencesDictionaryVersion = 600;

@implementation TPCPreferences

#pragma mark -
#pragma mark Default Identity

+ (NSString *)_defaultNicknamePrefix
{
	return [[TPCPreferences defaultPreferences] objectForKey:@"DefaultIdentity -> Nickname"];
}

+ (void)_populateDefaultNickname
{
	/* Using "Guest" as the default nickname may create conflicts as nickname guesses are 
	 exhausted while appending underscores. To fix this, a random number is appended to 
	 the end of the default nickname. */
	NSString *nicknamePrefix = [TPCPreferences _defaultNicknamePrefix];

	NSString *nickname = [nicknamePrefix stringByAppendingFormat:@"%lu", TXRandomNumber(100)];

	[RZUserDefaults() registerDefaults:@{@"DefaultIdentity -> Nickname" : nickname}];
}

+ (NSString *)defaultNickname
{
	return [RZUserDefaults() objectForKey:@"DefaultIdentity -> Nickname"];
}

+ (nullable NSString *)defaultAwayNickname
{
	return [RZUserDefaults() objectForKey:@"DefaultIdentity -> AwayNickname"];
}

+ (NSString *)defaultUsername
{
	return [RZUserDefaults() objectForKey:@"DefaultIdentity -> Username"];
}

+ (NSString *)defaultRealName
{
	return [RZUserDefaults() objectForKey:@"DefaultIdentity -> Realname"];
}

#pragma mark -
#pragma mark General Preferences

+ (NSUInteger)autojoinMaximumChannelJoins
{
	return [RZUserDefaults() unsignedIntegerForKey:@"AutojoinMaximumChannelJoinCount"];
}

+ (NSString *)defaultKickMessage
{
	return [RZUserDefaults() objectForKey:@"ChannelOperatorDefaultLocalization -> Kick Reason"];
}

+ (BOOL)appendReasonToCommonIRCopCommands
{
	return [RZUserDefaults() boolForKey:@"AutomaticallyAppendReasonToCommonIRCopCommands"];
}

+ (NSString *)IRCopDefaultKillMessage
{
	return [RZUserDefaults() objectForKey:@"IRCopDefaultLocalizaiton -> Kill Reason"];
}

+ (NSString *)IRCopDefaultGlineMessage
{
	return [RZUserDefaults() objectForKey:@"IRCopDefaultLocalizaiton -> G:Line Reason"];
}

+ (NSString *)IRCopDefaultShunMessage
{
	return [RZUserDefaults() objectForKey:@"IRCopDefaultLocalizaiton -> Shun Reason"];
}

+ (nullable NSString *)masqueradeCTCPVersion
{
	return [RZUserDefaults() objectForKey:@"ApplicationCTCPVersionMasquerade"];
}

+ (BOOL)channelNavigationIsServerSpecific
{
	return [RZUserDefaults() boolForKey:@"ChannelNavigationIsServerSpecific"];
}

+ (BOOL)setAwayOnScreenSleep
{
	return [RZUserDefaults() boolForKey:@"SetAwayOnScreenSleep"];
}

+ (BOOL)disableSidebarTranslucency
{
	return [RZUserDefaults() boolForKey:@"DisableSidebarTranslucency"];
}

+ (BOOL)hideMainWindowSegmentedController
{
	return [RZUserDefaults() boolForKey:@"DisableMainWindowSegmentedController"];
}

+ (BOOL)autojoinWaitsForNickServ
{
	return [RZUserDefaults() boolForKey:@"AutojoinWaitsForNickservIdentification"];
}

+ (BOOL)logHighlights
{
	return [RZUserDefaults() boolForKey:@"LogHighlights"];
}

+ (BOOL)clearAllOnlyOnActiveServer
{
	return [RZUserDefaults() boolForKey:@"ApplyCommandToAllConnections -> clearall"];
}

#if TEXTUAL_BUILT_WITH_ADVANCED_ENCRYPTION == 1
+ (BOOL)textEncryptionIsOpportunistic
{
	return [RZUserDefaults() boolForKey:@"Off-the-Record Messaging -> Automatically Enable Service"];
}

+ (BOOL)textEncryptionIsRequired
{
	return [RZUserDefaults() boolForKey:@"Off-the-Record Messaging -> Require Encryption"];
}

+ (BOOL)textEncryptionIsEnabled
{
	return [RZUserDefaults() boolForKey:@"Off-the-Record Messaging -> Enable Encryption"];
}
#endif

+ (BOOL)displayServerMOTD
{
	return [RZUserDefaults() boolForKey:@"DisplayServerMessageOfTheDayOnConnect"];
}

+ (BOOL)copyOnSelect
{
	return [RZUserDefaults() boolForKey:@"CopyTextSelectionOnMouseUp"];
}

+ (BOOL)replyToCTCPRequests
{
	return [RZUserDefaults() boolForKey:@"ReplyUnignoredExternalCTCPRequests"];
}

+ (BOOL)autoAddScrollbackMark
{
	return [RZUserDefaults() boolForKey:@"AutomaticallyAddScrollbackMarker"];
}

+ (BOOL)removeAllFormatting
{
	return [RZUserDefaults() boolForKey:@"RemoveIRCTextFormatting"];
}

+ (BOOL)automaticallyDetectHighlightSpam
{
	return [RZUserDefaults() boolForKey:@"AutomaticallyDetectHighlightSpam"];
}

+ (BOOL)disableNicknameColorHashing
{
	return [RZUserDefaults() boolForKey:@"DisableRemoteNicknameColorHashing"];
}

+ (BOOL)nicknameColorHashingComputesRGBValue
{
	return [RZUserDefaults() boolForKey:@"NicknameColorHashingComputesRGBValue"];
}

+ (BOOL)conversationTrackingIncludesUserModeSymbol
{
	return [RZUserDefaults() boolForKey:@"ConversationTrackingIncludesUserModeSymbol"];
}

+ (BOOL)rightToLeftFormatting
{
	return [RZUserDefaults() boolForKey:@"RightToLeftTextFormatting"];
}

+ (BOOL)displayDockBadge
{
	return [RZUserDefaults() boolForKey:@"DisplayDockBadges"];
}

+ (BOOL)amsgAllConnections
{
	return [RZUserDefaults() boolForKey:@"ApplyCommandToAllConnections -> amsg"];
}

+ (BOOL)awayAllConnections
{
	return [RZUserDefaults() boolForKey:@"ApplyCommandToAllConnections -> away"];
}

+ (BOOL)giveFocusOnMessageCommand
{
	return [RZUserDefaults() boolForKey:@"FocusSelectionOnMessageCommandExecution"];
}

+ (BOOL)memberListSortFavorsServerStaff
{
	return [RZUserDefaults() boolForKey:@"MemberListSortFavorsServerStaff"];
}

+ (BOOL)memberListUpdatesUserInfoPopoverOnScroll
{
	return [RZUserDefaults() boolForKey:@"MemberListUpdatesUserInfoPopoverOnScroll"];
}

+ (BOOL)memberListDisplayNoModeSymbol
{
	return [RZUserDefaults() boolForKey:@"DisplayUserListNoModeSymbol"];
}

+ (BOOL)postNotificationsWhileInFocus
{
	return [RZUserDefaults() boolForKey:@"PostNotificationsWhileInFocus"];
}

+ (BOOL)automaticallyFilterUnicodeTextSpam
{
	return [RZUserDefaults() boolForKey:@"AutomaticallyFilterUnicodeTextSpam"];
}

+ (BOOL)nickAllConnections
{
	return [RZUserDefaults() boolForKey:@"ApplyCommandToAllConnections -> nick"];
}

+ (BOOL)confirmQuit
{
	return [RZUserDefaults() boolForKey:@"ConfirmApplicationQuit"];
}

+ (BOOL)rememberServerListQueryStates
{
	return [RZUserDefaults() boolForKey:@"ServerListRetainsQueriesBetweenRestarts"];
}

+ (BOOL)rejoinOnKick
{
	return [RZUserDefaults() boolForKey:@"RejoinChannelOnLocalKick"];
}

+ (BOOL)reloadScrollbackOnLaunch
{
	return [RZUserDefaults() boolForKey:@"ReloadScrollbackOnLaunch"];
}

+ (BOOL)autoJoinOnInvite
{
	return [RZUserDefaults() boolForKey:@"AutojoinChannelOnInvite"];
}

+ (BOOL)connectOnDoubleclick
{
	return [RZUserDefaults() boolForKey:@"ServerListDoubleClickConnectServer"];
}

+ (BOOL)disconnectOnDoubleclick
{
	return [RZUserDefaults() boolForKey:@"ServerListDoubleClickDisconnectServer"];
}

+ (BOOL)joinOnDoubleclick
{
	return [RZUserDefaults() boolForKey:@"ServerListDoubleClickJoinChannel"];
}

+ (BOOL)leaveOnDoubleclick
{
	return [RZUserDefaults() boolForKey:@"ServerListDoubleClickLeaveChannel"];
}

+ (BOOL)logToDisk
{
	return [RZUserDefaults() boolForKey:@"LogTranscript"];
}

+ (BOOL)logToDiskIsEnabled
{
	return ([RZUserDefaults() boolForKey:@"LogTranscript"] &&
			[TPCPathInfo transcriptFolderURL] != nil);
}

+ (BOOL)openBrowserInBackground
{
	return [RZUserDefaults() boolForKey:@"OpenClickedLinksInBackgroundBrowser"];
}

+ (BOOL)showInlineImages
{
	return [RZUserDefaults() boolForKey:@"DisplayEventInLogView -> Inline Media"];
}

+ (BOOL)showJoinLeave
{
	return [RZUserDefaults() boolForKey:@"DisplayEventInLogView -> Join, Part, Quit"];
}

+ (BOOL)commandReturnSendsMessageAsAction
{
	return [RZUserDefaults() boolForKey:@"CommandReturnSendsMessageAsAction"];
}

+ (BOOL)controlEnterSnedsMessage
{
	return [RZUserDefaults() boolForKey:@"ControlEnterSendsMessage"];
}

+ (BOOL)displayPublicMessageCountOnDockBadge
{
	return [RZUserDefaults() boolForKey:@"DisplayPublicMessageCountInDockBadge"];
}

+ (BOOL)highlightCurrentNickname
{
	return [RZUserDefaults() boolForKey:@"TrackNicknameHighlightsOfLocalUser"];
}

+ (BOOL)inputHistoryIsChannelSpecific
{
	return [RZUserDefaults() boolForKey:@"SaveInputHistoryPerSelection"];
}

+ (CGFloat)swipeMinimumLength
{
	return [RZUserDefaults() doubleForKey:@"SwipeMinimumLength"];
}

+ (NSUInteger)trackUserAwayStatusMaximumChannelSize
{
    return [RZUserDefaults() unsignedIntegerForKey:@"TrackUserAwayStatusMaximumChannelSize"];
}

+ (TXTabKeyAction)tabKeyAction
{
	return (TXTabKeyAction)[RZUserDefaults() unsignedIntegerForKey:@"Keyboard -> Tab Key Action"];
}

+ (TXNicknameHighlightMatchType)highlightMatchingMethod
{
	return (TXNicknameHighlightMatchType)[RZUserDefaults() unsignedIntegerForKey:@"NicknameHighlightMatchingType"];
}

+ (TXUserDoubleClickAction)userDoubleClickOption
{
	return (TXUserDoubleClickAction)[RZUserDefaults() unsignedIntegerForKey:@"UserListDoubleClickAction"];
}

+ (TXNoticeSendLocationType)locationToSendNotices
{
	return (TXNoticeSendLocationType)[RZUserDefaults() unsignedIntegerForKey:@"DestinationOfNonserverNotices"];
}

+ (TXCommandWKeyAction)commandWKeyAction
{
	return (TXCommandWKeyAction)[RZUserDefaults() unsignedIntegerForKey:@"Keyboard -> Command+W Key Action"];
}

+ (TXHostmaskBanFormat)banFormat
{
	return (TXHostmaskBanFormat)[RZUserDefaults() unsignedIntegerForKey:@"DefaultBanCommandHostmaskFormat"];
}

+ (TVCMainWindowTextViewFontSize)mainTextViewFontSize
{
	return (TVCMainWindowTextViewFontSize)[RZUserDefaults() unsignedIntegerForKey:@"Main Input Text Field -> Font Size"];
}

+ (BOOL)focusMainTextViewOnSelectionChange
{
	return [RZUserDefaults() boolForKey:@"Main Input Text Field -> Focus When Changing Views"];
}

#pragma mark -
#pragma mark Updates

#if TEXTUAL_BUILT_WITH_SPARKLE_ENABLED == 1
+ (void)setReceiveBetaUpdates:(BOOL)receiveBetaUpdates
{
	[RZUserDefaults() setBool:receiveBetaUpdates forKey:@"ReceiveBetaUpdates"];
}

+ (BOOL)receiveBetaUpdates
{
	return [RZUserDefaults() boolForKey:@"ReceiveBetaUpdates"];
}
#endif

#pragma mark -
#pragma mark Developer Mode

+ (void)setDeveloperModeEnabled:(BOOL)developerModeEnabled
{
	[RZUserDefaults() setBool:developerModeEnabled forKey:@"TextualDeveloperEnvironment"];
}

+ (BOOL)developerModeEnabled
{
	return [RZUserDefaults() boolForKey:@"TextualDeveloperEnvironment"];
}

#pragma mark -
#pragma mark Theme

+ (BOOL)invertSidebarColorsPreferenceUserConfigurable
{
	return [RZUserDefaults() boolForKey:@"Theme -> Invert Sidebar Colors Preference Enabled"];
}

+ (void)setInvertSidebarColorsPreferenceUserConfigurable:(BOOL)invertSidebarColorsPreferenceUserConfigurable
{
	[RZUserDefaults() setBool:invertSidebarColorsPreferenceUserConfigurable forKey:@"Theme -> Invert Sidebar Colors Preference Enabled"];
}

+ (void)setInvertSidebarColors:(BOOL)invertSidebarColors
{
	[RZUserDefaults() boolForKey:@"InvertSidebarColors"];
}

+ (BOOL)invertSidebarColors
{
	if ([themeSettings() invertSidebarColors]) {
		return YES;
	}

	return [RZUserDefaults() boolForKey:@"InvertSidebarColors"];
}

+ (NSString *)themeNameDefault
{
	return [[TPCPreferences defaultPreferences] objectForKey:TPCPreferencesThemeNameDefaultsKey];
}

+ (NSString *)themeName
{
	return [RZUserDefaults() objectForKey:TPCPreferencesThemeNameDefaultsKey];
}

+ (void)setThemeName:(NSString *)value
{
	[RZUserDefaults() setObject:value forKey:TPCPreferencesThemeNameDefaultsKey];
	
	[RZUserDefaults() removeObjectForKey:TPCPreferencesThemeNameMissingLocallyDefaultsKey];
}

+ (void)setThemeNameWithExistenceCheck:(NSString *)value
{
	if ([TPCThemeController themeExists:value]) {
		[TPCPreferences setThemeName:value];
	} else {
		[RZUserDefaults() setBool:YES forKey:TPCPreferencesThemeNameMissingLocallyDefaultsKey];
	}
}

+ (NSString *)themeChannelViewFontNameDefault
{
	return [[TPCPreferences defaultPreferences] objectForKey:TPCPreferencesThemeFontNameDefaultsKey];
}

+ (NSString *)themeChannelViewFontName
{
	return [RZUserDefaults() objectForKey:TPCPreferencesThemeFontNameDefaultsKey];
}

+ (void)setThemeChannelViewFontName:(NSString *)value
{
	[RZUserDefaults() setObject:value forKey:TPCPreferencesThemeFontNameDefaultsKey];
	
	[RZUserDefaults() removeObjectForKey:TPCPreferencesThemeFontNameMissingLocallyDefaultsKey];
}

+ (void)setThemeChannelViewFontNameWithExistenceCheck:(NSString *)value
{
	if ([NSFont fontIsAvailable:value]) {
		[TPCPreferences setThemeChannelViewFontName:value];
	} else {
		[RZUserDefaults() setBool:YES forKey:TPCPreferencesThemeFontNameMissingLocallyDefaultsKey];
	}
}

+ (double)themeChannelViewFontSize
{
	return [RZUserDefaults() doubleForKey:@"Theme -> Font Size"];
}

+ (void)setThemeChannelViewFontSize:(double)value
{
	[RZUserDefaults() setDouble:value forKey:@"Theme -> Font Size"];
}

+ (nullable NSFont *)themeChannelViewFont
{
	return [NSFont fontWithName:[TPCPreferences themeChannelViewFontName]
						   size:[TPCPreferences themeChannelViewFontSize]];
}

+ (BOOL)themeChannelViewFontPreferenceUserConfigurable
{
	return [RZUserDefaults() boolForKey:@"Theme -> Channel Font Preference Enabled"];
}

+ (void)setThemeChannelViewFontPreferenceUserConfigurable:(BOOL)themeChannelViewFontPreferenceUserConfigurable
{
	[RZUserDefaults() setBool:themeChannelViewFontPreferenceUserConfigurable forKey:@"Theme -> Channel Font Preference Enabled"];
}

+ (NSString *)themeNicknameFormatDefault
{
	return [[TPCPreferences defaultPreferences] objectForKey:@"Theme -> Nickname Format"];
}

+ (NSString *)themeNicknameFormat
{
	return [RZUserDefaults() objectForKey:@"Theme -> Nickname Format"];
}

+ (BOOL)themeNicknameFormatPreferenceUserConfigurable
{
	return [RZUserDefaults() boolForKey:@"Theme -> Nickname Format Preference Enabled"];
}

+ (void)setThemeNicknameFormatPreferenceUserConfigurable:(BOOL)themeNicknameFormatPreferenceUserConfigurable
{
	[RZUserDefaults() setBool:themeNicknameFormatPreferenceUserConfigurable forKey:@"Theme -> Nickname Format Preference Enabled"];
}

+ (NSString *)themeTimestampFormatDefault
{
	return [[TPCPreferences defaultPreferences] objectForKey:@"Theme -> Timestamp Format"];
}

+ (NSString *)themeTimestampFormat
{
	return [RZUserDefaults() objectForKey:@"Theme -> Timestamp Format"];
}

+ (BOOL)themeTimestampFormatPreferenceUserConfigurable
{
	return [RZUserDefaults() boolForKey:@"Theme -> Timestamp Format Preference Enabled"];
}

+ (void)setThemeTimestampFormatPreferenceUserConfigurable:(BOOL)themeTimestampFormatPreferenceUserConfigurable
{
	[RZUserDefaults() setBool:themeTimestampFormatPreferenceUserConfigurable forKey:@"Theme -> Timestamp Format Preference Enabled"];
}

+ (double)mainWindowTransparency
{
	return [RZUserDefaults() doubleForKey:@"MainWindowTransparencyLevel"];
}

+ (BOOL)automaticallyReloadCustomThemesWhenTheyChange
{
	return [RZUserDefaults() boolForKey:@"AutomaticallyReloadCustomThemesWhenTheyChange"];
}

+ (BOOL)webKit2Enabled
{
	BOOL canUseWebKit2 = [RZUserDefaults() boolForKey:@"UsesWebKit2WhenAvailable"];

	if (canUseWebKit2 == NO) {
		return NO;
	}

	if ([XRSystemInformation isUsingOSXElCapitanOrLater]) {
		return YES;
	}

	return NO;
}

+ (BOOL)webKit2ProcessPoolSizeLimited
{
	return [RZUserDefaults() boolForKey:@"WKProcessPoolSizeIsLimited"];
}

+ (BOOL)themeChannelViewUsesCustomScrollers
{
	return ([RZUserDefaults() boolForKey:@"WebViewDoNotUsesCustomScrollers"] == NO);
}

#pragma mark -
#pragma mark Completion Suffix

+ (nullable NSString *)tabCompletionSuffix
{
	return [RZUserDefaults() objectForKey:@"Keyboard -> Tab Key Completion Suffix"];
}

+ (void)setTabCompletionSuffix:(NSString *)value
{
	[RZUserDefaults() setObject:value forKey:@"Keyboard -> Tab Key Completion Suffix"];
}

+ (BOOL)tabCompletionDoNotAppendWhitespace
{
	return [RZUserDefaults() boolForKey:@"Tab Completion -> Do Not Use Whitespace for Missing Completion Suffix"];
}

+ (BOOL)tabCompletionCutForwardToFirstWhitespace
{
	return [RZUserDefaults() boolForKey:@"Tab Completion -> Completion Suffix Cut Forward Until Space"];
}

#pragma mark -
#pragma mark Inline Image Size

+ (TXUnsignedLongLong)inlineImagesMaxFilesize
{
	NSUInteger filesizeTag = [RZUserDefaults() unsignedIntegerForKey:@"InlineMediaMaximumFilesize"];

	switch (filesizeTag) {
#define _dv(key, value)		case (key): { return (value); }

		_dv(1, (TXUnsignedLongLong)1048576) // 1 MB
		_dv(2, (TXUnsignedLongLong)2097152) // 2 MB
		_dv(3, (TXUnsignedLongLong)3145728) // 3 MB
		_dv(4, (TXUnsignedLongLong)4194304) // 4 MB
		_dv(5, (TXUnsignedLongLong)5242880) // 5 MB
		_dv(6, (TXUnsignedLongLong)10485760) // 10 MB
		_dv(7, (TXUnsignedLongLong)15728640) // 15 MB
		_dv(8, (TXUnsignedLongLong)20971520) // 20 MB
		_dv(9, (TXUnsignedLongLong)52428800) // 50 MB
		_dv(10, (TXUnsignedLongLong)104857600) // 100 MB

#undef _dv
	}

	return (TXUnsignedLongLong)2097152; // 2 MB
}

+ (NSUInteger)inlineImagesMaxWidth
{
	return [RZUserDefaults() unsignedIntegerForKey:@"InlineMediaScalingWidth"];
}

+ (NSUInteger)inlineImagesMaxHeight
{
	return [RZUserDefaults() unsignedIntegerForKey:@"InlineMediaMaximumHeight"];
}

+ (void)setInlineImagesMaxWidth:(NSUInteger)value
{
	[RZUserDefaults() setUnsignedInteger:value forKey:@"InlineMediaScalingWidth"];
}

+ (void)setInlineImagesMaxHeight:(NSUInteger)value
{
	[RZUserDefaults() setUnsignedInteger:value forKey:@"InlineMediaMaximumHeight"];
}

#pragma mark -
#pragma mark File Transfers

+ (TXFileTransferRequestReplyAction)fileTransferRequestReplyAction
{
	return [RZUserDefaults() unsignedIntegerForKey:@"File Transfers -> File Transfer Request Reply Action"];
}

+ (TXFileTransferIPAddressDetectionMethod)fileTransferIPAddressDetectionMethod
{
	return [RZUserDefaults() unsignedIntegerForKey:@"File Transfers -> File Transfer IP Address Detection Method"];
}

+ (BOOL)fileTransferRequestsAreReversed
{
	return [RZUserDefaults() boolForKey:@"File Transfers -> File Transfer Requests Use Reverse DCC"];
}

+ (BOOL)fileTransfersPreventIdleSystemSleep
{
	return [RZUserDefaults() boolForKey:@"File Transfers -> Idle System Sleep Prevented During File Transfer"];
}

+ (uint16_t)fileTransferPortRangeStart
{
	return [RZUserDefaults() unsignedShortForKey:@"File Transfers -> File Transfer Port Range Start"];
}

+ (void)setFileTransferPortRangeStart:(uint16_t)value
{
	[RZUserDefaults() setUnsignedShort:value forKey:@"File Transfers -> File Transfer Port Range Start"];
}

+ (uint16_t)fileTransferPortRangeEnd
{
	return [RZUserDefaults() unsignedShortForKey:@"File Transfers -> File Transfer Port Range End"];
}

+ (void)setFileTransferPortRangeEnd:(uint16_t)value
{
	[RZUserDefaults() setUnsignedShort:value forKey:@"File Transfers -> File Transfer Port Range End"];
}

+ (nullable NSString *)fileTransferManuallyEnteredIPAddress
{
	return [RZUserDefaults() objectForKey:@"File Transfers -> File Transfer Manually Entered IP Address"];
}

#pragma mark -
#pragma mark Max Log Lines

+ (NSUInteger)scrollbackLimit
{
	return [RZUserDefaults() unsignedIntegerForKey:@"ScrollbackMaximumLineCount"];
}

+ (void)setScrollbackLimit:(NSUInteger)value
{
	[RZUserDefaults() setUnsignedInteger:value forKey:@"ScrollbackMaximumLineCount"];
}

#pragma mark -
#pragma mark Growl

+ (BOOL)soundIsMuted
{
	return [RZUserDefaults() boolForKey:@"Notification Sound Is Muted"];
}

+ (void)setSoundIsMuted:(BOOL)soundIsMuted
{
	[RZUserDefaults() setBool:soundIsMuted forKey:@"Notification Sound Is Muted"];
}

+ (nullable NSString *)_keyForEvent:(TXNotificationType)event
{
	switch (event) {
#define _dv(key, value)		case (key): { return (value); }

		_dv(TXNotificationAddressBookMatchType, @"NotificationType -> Address Book Match")
		_dv(TXNotificationChannelMessageType, @"NotificationType -> Public Message")
		_dv(TXNotificationChannelNoticeType, @"NotificationType -> Public Notice")
		_dv(TXNotificationConnectType, @"NotificationType -> Connected")
		_dv(TXNotificationDisconnectType, @"NotificationType -> Disconnected")
		_dv(TXNotificationHighlightType, @"NotificationType -> Highlight")
		_dv(TXNotificationInviteType, @"NotificationType -> Channel Invitation")
		_dv(TXNotificationKickType, @"NotificationType -> Kicked from Channel")
		_dv(TXNotificationNewPrivateMessageType, @"NotificationType -> Private Message (New)")
		_dv(TXNotificationPrivateMessageType, @"NotificationType -> Private Message")
		_dv(TXNotificationPrivateNoticeType, @"NotificationType -> Private Notice")
		_dv(TXNotificationFileTransferSendSuccessfulType, @"NotificationType -> Successful File Transfer (Sending)")
		_dv(TXNotificationFileTransferReceiveSuccessfulType, @"NotificationType -> Successful File Transfer (Receiving)")
		_dv(TXNotificationFileTransferSendFailedType, @"NotificationType -> Failed File Transfer (Sending)")
		_dv(TXNotificationFileTransferReceiveFailedType, @"NotificationType -> Failed File Transfer (Receiving)")
		_dv(TXNotificationFileTransferReceiveRequestedType, @"NotificationType -> File Transfer Request")

#undef _dv
	}

	return nil;
}

+ (nullable NSString *)soundForEvent:(TXNotificationType)event
{
	NSString *eventKeyPrefix = [TPCPreferences _keyForEvent:event];

	if (eventKeyPrefix == nil) {
		return nil;
	}

	NSString *eventKey = [eventKeyPrefix stringByAppendingString:@" -> Sound"];

	return [RZUserDefaults() objectForKey:eventKey];
}

+ (void)setSound:(nullable NSString *)value forEvent:(TXNotificationType)event
{
	NSString *eventKeyPrefix = [TPCPreferences _keyForEvent:event];

	if (eventKeyPrefix == nil) {
		return;
	}

	NSString *eventKey = [eventKeyPrefix stringByAppendingString:@" -> Sound"];

	[RZUserDefaults() setObject:value forKey:eventKey];
}

+ (BOOL)growlEnabledForEvent:(TXNotificationType)event
{
	NSString *eventKeyPrefix = [TPCPreferences _keyForEvent:event];

	if (eventKeyPrefix == nil) {
		return NO;
	}

	NSString *eventKey = [eventKeyPrefix stringByAppendingString:@" -> Enabled"];

	return [RZUserDefaults() boolForKey:eventKey];
}

+ (void)setGrowlEnabled:(BOOL)value forEvent:(TXNotificationType)event
{
	NSString *eventKeyPrefix = [TPCPreferences _keyForEvent:event];

	if (eventKeyPrefix == nil) {
		return;
	}

	NSString *eventKey = [eventKeyPrefix stringByAppendingString:@" -> Enabled"];

	[RZUserDefaults() setBool:value forKey:eventKey];
}

+ (BOOL)disabledWhileAwayForEvent:(TXNotificationType)event
{
	NSString *eventKeyPrefix = [TPCPreferences _keyForEvent:event];

	if (eventKeyPrefix == nil) {
		return NO;
	}

	NSString *eventKey = [eventKeyPrefix stringByAppendingString:@" -> Disable While Away"];

	return [RZUserDefaults() boolForKey:eventKey];
}

+ (void)setDisabledWhileAway:(BOOL)value forEvent:(TXNotificationType)event
{
	NSString *eventKeyPrefix = [TPCPreferences _keyForEvent:event];

	if (eventKeyPrefix == nil) {
		return;
	}

	NSString *eventKey = [eventKeyPrefix stringByAppendingString:@" -> Disable While Away"];

	[RZUserDefaults() setBool:value forKey:eventKey];
}

+ (BOOL)bounceDockIconForEvent:(TXNotificationType)event
{
	NSString *eventKeyPrefix = [TPCPreferences _keyForEvent:event];

	if (eventKeyPrefix == nil) {
		return NO;
	}
    
    NSString *eventKey = [eventKeyPrefix stringByAppendingString:@" -> Bounce Dock Icon"];
    
    return [RZUserDefaults() boolForKey:eventKey];
}

+ (void)setBounceDockIcon:(BOOL)value forEvent:(TXNotificationType)event
{
	NSString *eventKeyPrefix = [TPCPreferences _keyForEvent:event];

	if (eventKeyPrefix == nil) {
		return;
	}
    
	NSString *eventKey = [eventKeyPrefix stringByAppendingString:@" -> Bounce Dock Icon"];
    
	[RZUserDefaults() setBool:value forKey:eventKey];
}

+ (BOOL)bounceDockIconRepeatedlyForEvent:(TXNotificationType)event
{
	NSString *eventKeyPrefix = [TPCPreferences _keyForEvent:event];

	if (eventKeyPrefix == nil) {
		return NO;
	}

	NSString *eventKey = [eventKeyPrefix stringByAppendingString:@" -> Bounce Dock Icon Repeatedly"];

	return [RZUserDefaults() boolForKey:eventKey];
}

+ (void)setBounceDockIconRepeatedly:(BOOL)value forEvent:(TXNotificationType)event
{
	NSString *eventKeyPrefix = [TPCPreferences _keyForEvent:event];

	if (eventKeyPrefix == nil) {
		return;
	}

	NSString *eventKey = [eventKeyPrefix stringByAppendingString:@" -> Bounce Dock Icon Repeatedly"];

	[RZUserDefaults() setBool:value forKey:eventKey];
}

+ (BOOL)speakEvent:(TXNotificationType)event
{
	NSString *eventKeyPrefix = [TPCPreferences _keyForEvent:event];

	if (eventKeyPrefix == nil) {
		return NO;
	}

	NSString *eventKey = [eventKeyPrefix stringByAppendingString:@" -> Speak"];

	return [RZUserDefaults() boolForKey:eventKey];
}

+ (void)setEventIsSpoken:(BOOL)value forEvent:(TXNotificationType)event
{
	NSString *eventKeyPrefix = [TPCPreferences _keyForEvent:event];

	if (eventKeyPrefix == nil) {
		return;
	}

	NSString *eventKey = [eventKeyPrefix stringByAppendingString:@" -> Speak"];

	[RZUserDefaults() setBool:value forKey:eventKey];
}

#pragma mark -
#pragma mark World

+ (nullable NSDictionary<NSString *, id> *)clientList
{
	return [RZUserDefaults() objectForKey:IRCWorldControllerClientListDefaultsKey];
}

+ (void)setClientList:(nullable NSDictionary<NSString *, id> *)clientList
{
	[RZUserDefaults() setObject:clientList forKey:IRCWorldControllerClientListDefaultsKey];
}

+ (void)_migrateWorldControllerToVersion600
{
#define _defaultsKey @"World Controller Migrated (600)"

	BOOL clientListMigrated = [RZUserDefaults() boolForKey:_defaultsKey];

	if (clientListMigrated) {
		return;
	}

	NSDictionary *worldController = [RZUserDefaults() dictionaryForKey:@"World Controller"];

	NSDictionary<NSString *, id> *clientList = [worldController dictionaryForKey:@"clients"];

	if ([clientList count] > 0) {
		[TPCPreferences setClientList:clientList];
	}

	BOOL soundIsMuted = [worldController boolForKey:@"soundIsMuted"];

	if (soundIsMuted) {
		[TPCPreferences setSoundIsMuted:soundIsMuted];
	}

	[RZUserDefaults() setBool:YES forKey:_defaultsKey];

#endif
}

#pragma mark -
#pragma mark Keywords

static NSArray<NSString *> *_excludeKeywords = nil;
static NSArray<NSString *> *_matchKeywords = nil;

+ (void)_loadExcludeKeywords
{
	NSArray<NSDictionary *> *keywordArrayIn = [RZUserDefaults() arrayForKey:@"Highlight List -> Excluded Matches"];

	NSMutableArray<NSString *> *keywordArrayOut = [NSMutableArray array];

	for (NSDictionary<NSString *, NSString *> *keyword in keywordArrayIn) {
		NSString *s = keyword[@"string"];

		if (s && [s length] > 0) {
			[keywordArrayOut addObject:s];
		}
	}

	_excludeKeywords = [keywordArrayOut copy];
}

+ (void)_loadMatchKeywords
{
	NSArray<NSDictionary *> *keywordArrayIn = [RZUserDefaults() arrayForKey:@"Highlight List -> Primary Matches"];

	NSMutableArray<NSString *> *keywordArrayOut = [NSMutableArray array];

	for (NSDictionary<NSString *, NSString *> *keyword in keywordArrayIn) {
		NSString *s = keyword[@"string"];

		if (s && [s length] > 0) {
			[keywordArrayOut addObject:s];
		}
	}

	_matchKeywords = [keywordArrayOut copy];
}

+ (void)_cleanUpKeywords:(NSString *)key
{
	NSArray<NSDictionary *> *keywordArrayIn = [RZUserDefaults() arrayForKey:key];

	NSMutableArray<NSString *> *keywordArrayOut = [NSMutableArray array];

	for (NSDictionary<NSString *, NSString *> *keyword in keywordArrayIn) {
		NSString *s = keyword[@"string"];

		if (s && [s length] > 0) {
			[keywordArrayOut addObject:s];
		}
	}

	[keywordArrayOut sortUsingSelector:@selector(caseInsensitiveCompare:)];

	NSArra *arrayToSave = [keywordArrayOut stringArrayControllerObjects];

	[RZUserDefaults() setObject:arrayToSave forKey:key];
}

+ (void)cleanUpHighlightKeywords
{
	[TPCPreferences _cleanUpKeywords:@"Highlight List -> Primary Matches"];

	[TPCPreferences _cleanUpKeywords:@"Highlight List -> Excluded Matches"];
}

+ (nullable NSArray<NSString *> *)highlightMatchKeywords
{
	return _matchKeywords;
}

+ (nullable NSArray<NSString *> *)highlightExcludeKeywords
{
	return _excludeKeywords;
}

#pragma mark -
#pragma mark Key-Value Observing

+ (void)observeValueForKeyPath:(NSString *)key ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if ([key isEqualToString:@"Highlight List -> Primary Matches"]) {
		[TPCPreferences _loadMatchKeywords];
	} else if ([key isEqualToString:@"Highlight List -> Excluded Matches"]) {
		[TPCPreferences _loadExcludeKeywords];
	}
}

#pragma mark -
#pragma mark Initialization

+ (NSDictionary<NSString *, id> *)defaultPreferences
{
	return [[NSUserDefaults standardUserDefaults] volatileDomainForName:NSRegistrationDomain];
}

+ (void)initPreferences
{
	[TPCApplicationInfo incrementApplicationRunCount];

	// ====================================================== //

#if TEXTUAL_BUILT_INSIDE_SANDBOX == 0
	[TPCPreferencesUserDefaults migrateKeyValuesAwayFromGroupContainer];
#endif

	NSDictionary *defaults =
	[TPCResourceManager loadContentsOfPropertyListInResources:@"RegisteredUserDefaults"];

	[RZUserDefaults() registerDefaults:defaults];

	[TPCPreferences _migrateWorldControllerToVersion600];

	[TPCPreferences _populateDefaultNickname];

	[RZUserDefaults() addObserver:(id)self forKeyPath:@"Highlight List -> Excluded Matches" options:NSKeyValueObservingOptionNew context:NULL];
	[RZUserDefaults() addObserver:(id)self forKeyPath:@"Highlight List -> Primary Matches" options:NSKeyValueObservingOptionNew context:NULL];

	[TPCPreferences _loadExcludeKeywords];
	[TPCPreferences _loadMatchKeywords];

	/* Sandbox Check */
	[RZUserDefaults() setBool:[TPCApplicationInfo sandboxEnabled]						forKey:@"Security -> Sandbox Enabled"];

	[RZUserDefaults() setBool:[XRSystemInformation isUsingOSXLionOrLater]				forKey:@"System -> Running Mac OS Lion Or Newer"];
	[RZUserDefaults() setBool:[XRSystemInformation isUsingOSXMountainLionOrLater]		forKey:@"System -> Running Mac OS Mountain Lion Or Newer"];
	[RZUserDefaults() setBool:[XRSystemInformation isUsingOSXMavericksOrLater]			forKey:@"System -> Running Mac OS Mavericks Or Newer"];
	[RZUserDefaults() setBool:[XRSystemInformation isUsingOSXYosemiteOrLater]			forKey:@"System -> Running Mac OS Yosemite Or Newer"];
	[RZUserDefaults() setBool:[XRSystemInformation isUsingOSXElCapitanOrLater]			forKey:@"System -> Running Mac OS El Capitan Or Newer"];

#if TEXTUAL_BUILT_WITH_HOCKEYAPP_SDK_ENABLED == 1
	[RZUserDefaults() setBool:YES forKey:@"System -> 3rd-party Services -> Built with HockeyApp Framework"];
#else
	[RZUserDefaults() setBool:NO forKey:@"System -> 3rd-party Services -> Built with HockeyApp Framework"];
#endif

#if TEXTUAL_BUILT_WITH_SPARKLE_ENABLED == 1
	[RZUserDefaults() setBool:YES forKey:@"System -> 3rd-party Services -> Built with Sparkle Framework"];
#else 
	[RZUserDefaults() setBool:NO forKey:@"System -> 3rd-party Services -> Built with Sparkle Framework"];
#endif

#if TEXTUAL_BUILT_WITH_ICLOUD_SUPPORT == 0
	[RZUserDefaults() setBool:NO forKey:@"System -> Built with iCloud Support"];
#else
	if ([XRSystemInformation isUsingOSXMountainLionOrLater]) {
		[RZUserDefaults() setBool:YES forKey:@"System -> Built with iCloud Support"];
	} else {
		[RZUserDefaults() setBool:NO forKey:@"System -> Built with iCloud Support"];
	}
#endif

#if TEXTUAL_BUILT_WITH_LICENSE_MANAGER == 1
	[RZUserDefaults() setBool:YES forKey:@"System -> Built with License Manager Backend"];
#else
	[RZUserDefaults() setBool:NO forKey:@"System -> Built with License Manager Backend"];
#endif

#if TEXTUAL_BUILT_WITH_ADVANCED_ENCRYPTION == 1
	[RZUserDefaults() setBool:YES forKey:@"System -> Built with Off-the-Record Messaging Support"];
#else
	[RZUserDefaults() setBool:NO forKey:@"System -> Built with Off-the-Record Messaging Support"];
#endif

	[RZUserDefaults() setUnsignedInteger:TPCPreferencesDictionaryVersion forKey:@"TPCPreferencesDictionaryVersion"];
}

#pragma mark -
#pragma mark NSTextView Preferences

+ (BOOL)textFieldAutomaticSpellCheck
{
	return [RZUserDefaults() boolForKey:@"TextFieldAutomaticSpellCheck"];
}

+ (void)setTextFieldAutomaticSpellCheck:(BOOL)value
{
	[RZUserDefaults() setBool:value forKey:@"TextFieldAutomaticSpellCheck"];
}

+ (BOOL)textFieldAutomaticGrammarCheck
{
	return [RZUserDefaults() boolForKey:@"TextFieldAutomaticGrammarCheck"];
}

+ (void)setTextFieldAutomaticGrammarCheck:(BOOL)value
{
	[RZUserDefaults() setBool:value forKey:@"TextFieldAutomaticGrammarCheck"];
}

+ (BOOL)textFieldAutomaticSpellCorrection
{
	return [RZUserDefaults() boolForKey:@"TextFieldAutomaticSpellCorrection"];
}

+ (void)setTextFieldAutomaticSpellCorrection:(BOOL)value
{
	[RZUserDefaults() setBool:value forKey:@"TextFieldAutomaticSpellCorrection"];
}

+ (BOOL)textFieldSmartCopyPaste
{
	return [RZUserDefaults() boolForKey:@"TextFieldSmartCopyPaste"];
}

+ (void)setTextFieldSmartCopyPaste:(BOOL)value
{
	[RZUserDefaults() setBool:value forKey:@"TextFieldSmartCopyPaste"];
}

+ (BOOL)textFieldSmartQuotes
{
	return [RZUserDefaults() boolForKey:@"TextFieldSmartQuotes"];
}

+ (void)setTextFieldSmartQuotes:(BOOL)value
{
	[RZUserDefaults() setBool:value forKey:@"TextFieldSmartQuotes"];
}

+ (BOOL)textFieldSmartDashes
{
	return [RZUserDefaults() boolForKey:@"TextFieldSmartDashes"];
}

+ (void)setTextFieldSmartDashes:(BOOL)value
{
	[RZUserDefaults() setBool:value forKey:@"TextFieldSmartDashes"];
}

+ (BOOL)textFieldSmartLinks
{
	return [RZUserDefaults() boolForKey:@"TextFieldSmartLinks"];
}

+ (void)setTextFieldSmartLinks:(BOOL)value
{
	[RZUserDefaults() setBool:value forKey:@"TextFieldSmartLinks"];
}

+ (BOOL)textFieldDataDetectors
{
	return [RZUserDefaults() boolForKey:@"TextFieldDataDetectors"];
}

+ (void)setTextFieldDataDetectors:(BOOL)value
{
	[RZUserDefaults() setBool:value forKey:@"TextFieldDataDetectors"];
}

+ (BOOL)textFieldTextReplacement
{
	return [RZUserDefaults() boolForKey:@"TextFieldTextReplacement"];
}

+ (void)setTextFieldTextReplacement:(BOOL)value
{
	[RZUserDefaults() setBool:value forKey:@"TextFieldTextReplacement"];
}

@end

NS_ASSUME_NONNULL_END
