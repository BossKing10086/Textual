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

typedef NS_ENUM(NSUInteger, IRCChannelType) {
	IRCChannelChannelType = 0,
	IRCChannelPrivateMessageType,
};

#pragma mark -
#pragma mark Immutable Object

@interface IRCChannelConfig : NSObject <NSCopying, NSMutableCopying>
@property (readonly) BOOL autoJoin;
@property (readonly) BOOL ignoreGeneralEventMessages;
@property (readonly) BOOL ignoreHighlights;
@property (readonly) BOOL ignoreInlineMedia;
@property (readonly) BOOL pushNotifications;
@property (readonly) BOOL showTreeBadgeCount;
@property (readonly) IRCChannelType type;
@property (readonly, copy) NSString *channelName;
@property (readonly, copy) NSString *uniqueIdentifier;
@property (readonly, copy, nullable) NSString *defaultModes;
@property (readonly, copy, nullable) NSString *defaultTopic;
@property (readonly, copy, nullable) NSString *secretKey;
@property (readonly, copy, nullable) NSString *secretKeyFromKeychain;

+ (IRCChannelConfig *)seedWithName:(NSString *)channelName;

- (instancetype)initWithDictionary:(NSDictionary<NSString *, id> *)dic NS_DESIGNATED_INITIALIZER;
- (NSDictionary<NSString *, id> *)dictionaryValue;
@end

#pragma mark -
#pragma mark Mutable Object

@interface IRCChannelConfigMutable : IRCChannelConfig
@property (nonatomic, assign, readwrite) BOOL autoJoin;
@property (nonatomic, assign, readwrite) BOOL ignoreGeneralEventMessages;
@property (nonatomic, assign, readwrite) BOOL ignoreHighlights;
@property (nonatomic, assign, readwrite) BOOL ignoreInlineMedia;
@property (nonatomic, assign, readwrite) BOOL pushNotifications;
@property (nonatomic, assign, readwrite) BOOL showTreeBadgeCount;
@property (nonatomic, copy, readwrite) NSString *channelName;
@property (nonatomic, copy, readwrite, nullable) NSString *defaultModes;
@property (nonatomic, copy, readwrite, nullable) NSString *defaultTopic;
@property (nonatomic, copy, readwrite, nullable) NSString *secretKey;
@end

NS_ASSUME_NONNULL_END
