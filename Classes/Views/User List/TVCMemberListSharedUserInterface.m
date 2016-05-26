/* ********************************************************************* 
                  _____         _               _
                 |_   _|____  _| |_ _   _  __ _| |
                   | |/ _ \ \/ / __| | | |/ _` | |
                   | |  __/>  <| |_| |_| | (_| | |
                   |_|\___/_/\_\\__|\__,_|\__,_|_|

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

@interface TVCMemberListSharedUserInterface ()
@property (nonatomic, strong, readwrite) TVCMemberList *memberList;
@property (nonatomic, strong) NSCache *cachedUserMarkBadges;
@end

@implementation TVCMemberListSharedUserInterface

ClassWithDesignatedInitializerInitMethod

- (instancetype)initWithMemberList:(TVCMemberList *)memberList
{
	NSParameterAssert(memberList != nil);

	if ((self = [super init])) {
		self->_memberList = memberList;

		return self;
	}

	return nil;
}

- (BOOL)yosemiteIsUsingVibrantDarkMode
{
	if ([XRSystemInformation isUsingOSXYosemiteOrLater] == NO) {
		return NO;
	}

	NSVisualEffectView *visualEffectView = self.memberList.visualEffectView;

	NSAppearance *currentAppearance = visualEffectView.appearance;

	NSString *appearanceName = currentAppearance.name;

	if ([appearanceName isEqualToString:NSAppearanceNameVibrantDark]) {
		return YES;
	} else {
		return NO;
	}
}

- (NSString *)keyForRetrievingCachedUserMarkBadgeWithSymbol:(NSString *)mark rank:(IRCUserRank)rank
{
	return [NSString stringWithFormat:@"%lu > %@", rank, mark];
}

- (nullable NSImage *)cachedUserMarkBadgeForSymbol:(NSString *)mark rank:(IRCUserRank)rank
{
	if (self.cachedUserMarkBadges == nil) {
		return nil;
	}

	NSString *key = [self keyForRetrievingCachedUserMarkBadgeWithSymbol:mark rank:rank];
		
	return self.cachedUserMarkBadges[key];
}

- (void)cacheUserMarkBadge:(NSImage *)badgeImage forSymbol:(NSString *)mark rank:(IRCUserRank)rank
{
	if (self.cachedUserMarkBadges == nil) {
		self.cachedUserMarkBadges = [NSCache new];
	}
	
	NSString *key = [self keyForRetrievingCachedUserMarkBadgeWithSymbol:mark rank:rank];
	
	[self.cachedUserMarkBadges setObject:badgeImage forKey:key];
}

- (void)invalidateAllUserMarkBadgeCaches
{
	if ( self.cachedUserMarkBadges) {
		[self.cachedUserMarkBadges removeAllObjects];
	}
}

- (nullable NSColor *)memberListBackgroundColorForActiveWindow
{
	return nil;
}

- (nullable NSColor *)memberListBackgroundColorForInactiveWindow
{
	return nil;
}

- (NSColor *)userMarkBadgeBackgroundColor_YDefault // InspIRCd-2.0
{
	return [NSColor colorWithCalibratedRed:0.632 green:0.335 blue:0.226 alpha:1.0];
}

- (NSColor *)userMarkBadgeBackgroundColor_QDefault
{
	return [NSColor colorWithCalibratedRed:0.726 green:0.0 blue:0.0 alpha:1.0];
}

- (NSColor *)userMarkBadgeBackgroundColor_ADefault
{
	return [NSColor colorWithCalibratedRed:0.613 green:0.0 blue:0.347 alpha:1.0];
}

- (NSColor *)userMarkBadgeBackgroundColor_ODefault
{
	return [NSColor colorWithCalibratedRed:0.351 green:0.199 blue:0.609 alpha:1.0];
}

- (NSColor *)userMarkBadgeBackgroundColor_HDefault
{
	return [NSColor colorWithCalibratedRed:0.066 green:0.488 blue:0.074 alpha:1.0];
}

- (NSColor *)userMarkBadgeBackgroundColor_VDefault
{
	return [NSColor colorWithCalibratedRed:0.199 green:0.480 blue:0.609 alpha:1.0];
}

+ (NSColor *)userMarkBadgeBackgroundColorWithAlphaCorrect:(NSString *)defaultsKey
{
	NSColor *defaultColor = [RZUserDefaults() colorForKey:defaultsKey];
	
	if ([XRSystemInformation isUsingOSXYosemiteOrLater]) {
		return [defaultColor colorWithAlphaComponent:0.7];
	} else {
		return  defaultColor;
	}
}

- (NSColor *)userMarkBadgeBackgroundColor_Y // InspIRCd-2.0
{
	return [TVCMemberListSharedUserInterface userMarkBadgeBackgroundColorWithAlphaCorrect:@"User List Mode Badge Colors -> +y"];
}

- (NSColor *)userMarkBadgeBackgroundColor_Q
{
	return [TVCMemberListSharedUserInterface userMarkBadgeBackgroundColorWithAlphaCorrect:@"User List Mode Badge Colors -> +q"];
}

- (NSColor *)userMarkBadgeBackgroundColor_A
{
	return [TVCMemberListSharedUserInterface userMarkBadgeBackgroundColorWithAlphaCorrect:@"User List Mode Badge Colors -> +a"];
}

- (NSColor *)userMarkBadgeBackgroundColor_O
{
	return [TVCMemberListSharedUserInterface userMarkBadgeBackgroundColorWithAlphaCorrect:@"User List Mode Badge Colors -> +o"];
}

- (NSColor *)userMarkBadgeBackgroundColor_H
{
	return [TVCMemberListSharedUserInterface userMarkBadgeBackgroundColorWithAlphaCorrect:@"User List Mode Badge Colors -> +h"];
}

- (NSColor *)userMarkBadgeBackgroundColor_V
{
	return [TVCMemberListSharedUserInterface userMarkBadgeBackgroundColorWithAlphaCorrect:@"User List Mode Badge Colors -> +v"];
}

- (NSFont *)userMarkBadgeFont
{
	return [RZFontManager() fontWithFamily:@"Helvetica" traits:0 weight:15 size:12.5];
}

- (NSFont *)userMarkBadgeFontForRetina
{
	return [RZFontManager() fontWithFamily:@"Helvetica" traits:0 weight:15 size:12.0];
}

- (NSFont *)userMarkBadgeFontSelected
{
	return [RZFontManager() fontWithFamily:@"Helvetica" traits:0 weight:15 size:12.5];
}

- (NSFont *)userMarkBadgeFontSelectedForRetina
{
	return [RZFontManager() fontWithFamily:@"Helvetica" traits:0 weight:15 size:12.0];
}

- (CGFloat)userMarkBadgeWidth
{
	return 20.0;
}

- (CGFloat)userMarkBadgeHeight
{
	return 16.0;
}

@end

#pragma mark -

@implementation TVCMemberListMavericksUserInterfaceBackground

- (void)drawRect:(NSRect)dirtyRect
{
	/* The following is specialized drawing for the normal source list
	 background when inside a backed layer view. */
	TVCMainWindow *mainWindow = self.mainWindow;

	TVCMemberList *memberList = mainWindow.memberList;

	NSColor *backgroundColor = nil;
	
	if (mainWindow.isActiveForDrawing) {
		backgroundColor = memberList.userInterfaceObjects.memberListBackgroundColorForActiveWindow;
	} else {
		backgroundColor = memberList.userInterfaceObjects.memberListBackgroundColorForInactiveWindow;
	}
	
	if ( backgroundColor) {
		[backgroundColor set];
		
		NSRectFill(self.bounds);
	} else {
		NSGradient *backgroundGradient = [NSGradient sourceListBackgroundGradientColor];
		
		[backgroundGradient drawInRect:self.bounds angle:270.0];
	}
}

- (BOOL)isOpaque
{
	return YES;
}

@end

#pragma mark -

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincomplete-implementation"
@implementation TVCMemberListMavericksUserInterface
@end

@implementation TVCMemberListYosemiteUserInterface
@end
#pragma clang diagnostic pop

NS_ASSUME_NONNULL_END
