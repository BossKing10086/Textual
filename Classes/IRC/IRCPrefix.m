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

#import "IRCPrefixInternal.h"

NS_ASSUME_NONNULL_BEGIN

@implementation IRCPrefix

- (id)copyWithZone:(nullable NSZone *)zone
{
	IRCPrefix *object = [[IRCPrefix allocWithZone:zone] init];

	object->_isServer = self.isServer;
	object->_nickname = [self.nickname copyWithZone:zone];
	object->_username = [self.username copyWithZone:zone];
	object->_address = [self.address copyWithZone:zone];
	object->_hostmask = [self.hostmask copyWithZone:zone];

	return object;
}

- (id)mutableCopyWithZone:(nullable NSZone *)zone
{
	IRCPrefixMutable *object = [[IRCPrefixMutable allocWithZone:zone] init];

	[object setIsServer:self.isServer];
	[object setNickname:self.nickname];
	[object setUsername:self.username];
	[object setAddress:self.address];
	[object setHostmask:self.hostmask];

	return object;
}

- (BOOL)isMutable
{
	return NO;
}

@end

#pragma mark -

@implementation IRCPrefixMutable

@dynamic isServer;
@dynamic nickname;
@dynamic username;
@dynamic address;
@dynamic hostmask;

- (BOOL)isMutable
{
	return YES;
}

- (void)setIsServer:(BOOL)isServer
{
	if (self->_isServer != isServer) {
		self->_isServer = isServer;
	}
}

- (void)setNickname:(nullable NSString *)nickname
{
	if (self->_nickname != nickname) {
		self->_nickname = [nickname copy];
	}
}

- (void)setUsername:(nullable NSString *)username
{
	if (self->_username != username) {
		self->_username = [username copy];
	}
}

- (void)setAddress:(nullable NSString *)address
{
	if (self->_address != address) {
		self->_address = [address copy];
	}
}

- (void)setHostmask:(nullable NSString *)hostmask
{
	if (self->_hostmask != hostmask) {
		self->_hostmask = [hostmask copy];
	}
}

@end

NS_ASSUME_NONNULL_END
