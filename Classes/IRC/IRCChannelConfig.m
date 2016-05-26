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

#import "IRCChannelConfigInternal.h"

NS_ASSUME_NONNULL_BEGIN

@implementation IRCChannelConfig

#pragma mark -
#pragma mark Defaults

- (void)populateDefaultsPreflight
{
	NSAssert((self->_objectInitialized == NO), @"Object is already initialized");

	self->_defaults = @{
	  @"autoJoin" : @(YES),
	  @"channelType" : @(IRCChannelChannelType),
	  @"ignoreGeneralEventMessages"	: @(NO),
	  @"ignoreHighlights" : @(NO),
	  @"ignoreInlineMedia" : @(NO),
	  @"pushNotifications" : @(YES),
	  @"showTreeBadgeCount" : @(YES)
	};
}

- (void)populateDefaultsPostflight
{
	NSAssert((self->_objectInitialized == NO), @"Object is already initialized");

	SetVariableIfNilCopy(self->_uniqueIdentifier, [NSString stringWithUUID])
}

- (void)populateDefaultsByAppendingDictionary:(NSDictionary<NSString *, id> *)defaultsToAppend
{
	NSParameterAssert(defaultsToAppend != nil);
	
	NSAssert((self->_objectInitialized == NO), @"Object is already initialized");

	self->_defaults = [self->_defaults dictionaryByAddingEntries:defaultsToAppend];
}

#pragma mark -
#pragma mark Channel Configuration

+ (IRCChannelConfig *)seedWithName:(NSString *)channelName
{
	NSParameterAssert(channelName != nil);

	NSDictionary *dic = @{@"channelName" : channelName};

	  IRCChannelConfig *config =
	[[IRCChannelConfig alloc] initWithDictionary:dic];
		
	return config;
}

- (instancetype)init
{
	return [self initWithDictionary:@{}];
}

- (instancetype)initWithDictionary:(NSDictionary<NSString *, id> *)dic
{
	NSAssert((self->_objectInitialized == NO), @"Object is already initialized");

	if ((self = [super init])) {
		[self populateDefaultsPreflight];

		[self populateDictionaryValues:dic];

		[self populateDefaultsPostflight];

		self->_objectInitialized = YES;

		return self;
	}

	return nil;
}

- (void)populateDictionaryValues:(NSDictionary<NSString *, id> *)dic
{
	NSParameterAssert(dic != nil);

	NSAssert((self->_objectInitialized == NO), @"Object is already initialized");

	NSMutableDictionary<NSString *, id> *defaultsMutable = [self->_defaults mutableCopy];

	[defaultsMutable addEntriesFromDictionary:dic];

	[defaultsMutable assignStringTo:&self->_channelName forKey:@"channelName"];
	[defaultsMutable assignStringTo:&self->_uniqueIdentifier forKey:@"uniqueIdentifier"];

	[defaultsMutable assignUnsignedIntegerTo:&self->_type forKey:@"channelType"];

	if (self->_type == IRCChannelChannelType) {
		/* Load the newest set of keys */
		[defaultsMutable assignBoolTo:&self->_autoJoin forKey:@"autoJoin"];
		[defaultsMutable assignBoolTo:&self->_ignoreGeneralEventMessages forKey:@"ignoreGeneralEventMessages"];
		[defaultsMutable assignBoolTo:&self->_ignoreHighlights forKey:@"ignoreHighlights"];
		[defaultsMutable assignBoolTo:&self->_ignoreInlineMedia forKey:@"ignoreInlineMedia"];
		[defaultsMutable assignBoolTo:&self->_pushNotifications forKey:@"pushNotifications"];
		[defaultsMutable assignBoolTo:&self->_showTreeBadgeCount forKey:@"showTreeBadgeCount"];

		[defaultsMutable assignStringTo:&self->_defaultModes forKey:@"defaultMode"];
		[defaultsMutable assignStringTo:&self->_defaultTopic forKey:@"defaultTopic"];

		/* Load legacy keys (if they exist) */
		[defaultsMutable assignBoolTo:&self->_autoJoin forKey:@"joinOnConnect"];
		[defaultsMutable assignBoolTo:&self->_ignoreGeneralEventMessages forKey:@"ignoreJPQActivity"];
		[defaultsMutable assignBoolTo:&self->_ignoreInlineMedia forKey:@"disableInlineMedia"];
		[defaultsMutable assignBoolTo:&self->_pushNotifications forKey:@"enableNotifications"];
		[defaultsMutable assignBoolTo:&self->_showTreeBadgeCount forKey:@"enableTreeBadgeCountDrawing"];
	}

	/* Sanity check */
	NSParameterAssert(self->_channelName.length > 0);
}

- (NSDictionary<NSString *, id> *)dictionaryValue
{
	return [self dictionaryValue:NO];
}

- (NSDictionary<NSString *, id> *)dictionaryValue:(BOOL)isCloudDictionary
{
	NSMutableDictionary<NSString *, id> *dic = [NSMutableDictionary dictionary];

	if (self.type == IRCChannelChannelType) {
		[dic maybeSetObject:self.defaultModes forKey:@"defaultMode"];
		[dic maybeSetObject:self.defaultTopic forKey:@"defaultTopic"];

		[dic setBool:self.autoJoin forKey:@"autoJoin"];
		[dic setBool:self.ignoreGeneralEventMessages forKey:@"ignoreGeneralEventMessages"];
		[dic setBool:self.ignoreHighlights forKey:@"ignoreHighlights"];
		[dic setBool:self.ignoreInlineMedia forKey:@"ignoreInlineMedia"];
		[dic setBool:self.pushNotifications	forKey:@"pushNotifications"];
		[dic setBool:self.showTreeBadgeCount forKey:@"showTreeBadgeCount"];
	}

	[dic maybeSetObject:self.channelName forKey:@"channelName"];
	[dic maybeSetObject:self.uniqueIdentifier forKey:@"uniqueIdentifier"];

	[dic setUnsignedInteger:self.type forKey:@"channelType"];

	return [dic dictionaryByRemovingDefaults:self->_defaults allowEmptyValues:YES];
}

- (BOOL)isEqual:(id)object
{
	PointerIsEmptyAssertReturn(object, NO)

	if ([object isKindOfClass:[IRCChannelConfig class]] == NO) {
		return NO;
	}

	NSDictionary *s1 = self.dictionaryValue;

	NSDictionary *s2 = ((IRCChannelConfig *)object).dictionaryValue;

	return (NSObjectsAreEqual(s1, s2) &&
			NSObjectsAreEqual(self->_secretKey, ((IRCChannelConfig *)object)->_secretKey));
}

- (NSUInteger)hash
{
	return self.uniqueIdentifier.hash;
}

- (BOOL)isMutable
{
	return NO;
}

- (id)copyWithZone:(nullable NSZone *)zone
{
	  IRCChannelConfig *config =
	[[IRCChannelConfig allocWithZone:zone] initWithDictionary:self.dictionaryValue];

	config->_secretKey = self->_secretKey.copy;

	return config;
}

- (id)mutableCopyWithZone:(nullable NSZone *)zone
{
	  IRCChannelConfigMutable *config =
	[[IRCChannelConfigMutable allocWithZone:zone] initWithDictionary:self.dictionaryValue];

	config.secretKey = self->_secretKey;

	return config;
}

#pragma mark -
#pragma mark Keychain Management

- (nullable NSString *)secretKey
{
	if (self->_secretKey) {
		return self->_secretKey;
	} else {
		return [self secretKeyFromKeychain];
	}
}

- (nullable NSString *)secretKeyFromKeychain
{
	NSString *secretKeyServiceName = [NSString stringWithFormat:@"textual.cjoinkey.%@", self.uniqueIdentifier];

	NSString *kcPassword = [XRKeychain getPasswordFromKeychainItem:@"Textual (Channel JOIN Key)"
													  withItemKind:@"application password"
													   forUsername:nil
													   serviceName:secretKeyServiceName];

	return kcPassword;
}

- (void)writeItemsToKeychain
{
	[self writeSecretKeyToKeychain];
}

- (void)writeSecretKeyToKeychain
{
	if (self->_secretKey == nil) {
		return;
	}

	NSString *secretKeyServiceName = [NSString stringWithFormat:@"textual.cjoinkey.%@", self.uniqueIdentifier];

	[XRKeychain modifyOrAddKeychainItem:@"Textual (Channel JOIN Key)"
						   withItemKind:@"application password"
							forUsername:nil
						withNewPassword:self->_secretKey
							serviceName:secretKeyServiceName];

	self->_secretKey = nil;
}

- (void)destroyKeychainItems
{
	NSString *secretKeyServiceName = [NSString stringWithFormat:@"textual.cjoinkey.%@", self.uniqueIdentifier];

	[XRKeychain deleteKeychainItem:@"Textual (Channel JOIN Key)"
					  withItemKind:@"application password"
					   forUsername:nil
					   serviceName:secretKeyServiceName];

	[self resetTemporaryKeychainItems];
}

- (void)resetTemporaryKeychainItems
{
	self->_secretKey = nil;
}

@end

#pragma mark -

@implementation IRCChannelConfigMutable

@dynamic autoJoin;
@dynamic channelName;
@dynamic defaultModes;
@dynamic defaultTopic;
@dynamic ignoreGeneralEventMessages;
@dynamic ignoreHighlights;
@dynamic ignoreInlineMedia;
@dynamic pushNotifications;
@dynamic secretKey;
@dynamic showTreeBadgeCount;

- (BOOL)isMutable
{
	return YES;
}

- (void)setAutoJoin:(BOOL)autoJoin
{
	if (self->_autoJoin != autoJoin) {
		self->_autoJoin = autoJoin;
	}
}

- (void)setIgnoreGeneralEventMessages:(BOOL)ignoreGeneralEventMessages
{
	if (self->_ignoreGeneralEventMessages != ignoreGeneralEventMessages) {
		self->_ignoreGeneralEventMessages = ignoreGeneralEventMessages;
	}
}

- (void)setIgnoreHighlights:(BOOL)ignoreHighlights
{
	if (self->_ignoreHighlights != ignoreHighlights) {
		self->_ignoreHighlights = ignoreHighlights;
	}
}

- (void)setIgnoreInlineMedia:(BOOL)ignoreInlineMedia
{
	if (self->_ignoreInlineMedia != ignoreInlineMedia) {
		self->_ignoreInlineMedia = ignoreInlineMedia;
	}
}

- (void)setPushNotifications:(BOOL)pushNotifications
{
	if (self->_pushNotifications != pushNotifications) {
		self->_pushNotifications = pushNotifications;
	}
}

- (void)setShowTreeBadgeCount:(BOOL)showTreeBadgeCount
{
	if (self->_showTreeBadgeCount != showTreeBadgeCount) {
		self->_showTreeBadgeCount = showTreeBadgeCount;
	}
}

- (void)setChannelName:(NSString *)channelName
{
	if (self->_channelName != channelName) {
		self->_channelName = channelName.copy;
	}
}

- (void)setDefaultModes:(nullable NSString *)defaultModes
{
	if (self->_defaultModes != defaultModes) {
		self->_defaultModes = defaultModes.copy;
	}
}

- (void)setDefaultTopic:(nullable NSString *)defaultTopic
{
	if (self->_defaultTopic != defaultTopic) {
		self->_defaultTopic = defaultTopic.copy;
	}
}

- (void)setSecretKey:(nullable NSString *)secretKey
{
	if (self->_secretKey != secretKey) {
		self->_secretKey = secretKey.copy;
	}
}

@end

NS_ASSUME_NONNULL_END
