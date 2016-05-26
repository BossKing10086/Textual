/* ********************************************************************* 
                  _____         _               _
                 |_   _|____  _| |_ _   _  __ _| |
                   | |/ _ \ \/ / __| | | |/ _` | |
                   | |  __/>  <| |_| |_| | (_| | |
                   |_|\___/_/\_\\__|\__,_|\__,_|_|

 Copyright (c) 2010 - 2016 Codeux Software, LLC & respective contributors.
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

@interface TVCMainWindowChannelViewSubview ()
@property (nonatomic, assign) NSUInteger itemIndex;
@property (nonatomic, assign) BOOL overlayVisible;
@property (nonatomic, copy) NSString *uniqueIdentifier;
@property (nonatomic, weak) NSView *webView;
@property (nonatomic, weak) TVCMainWindowChannelView *parentView;
@property (nonatomic, strong, nullable) TVCMainWindowChannelViewSubviewOverlayView *overlayView;
@end

@interface TVCMainWindowChannelView ()
@property (nonatomic, assign) NSUInteger itemIndexSelected;

- (void)selectionChangeTo:(NSUInteger)itemIndex;
@end

@implementation TVCMainWindowChannelView

NSComparisonResult sortSubviews(TVCMainWindowChannelViewSubview *firstView,
								TVCMainWindowChannelViewSubview *secondView,
								void *context)
{
	NSUInteger itemIndex1 = firstView.itemIndex;
	NSUInteger itemIndex2 = secondView.itemIndex;

	if (itemIndex1 < itemIndex2) {
		return NSOrderedAscending;
	} else if (itemIndex1 > itemIndex2) {
		return NSOrderedDescending;
	}

	return NSOrderedSame;
}

- (void)awakeFromNib
{
	self.delegate = (id)self;
}

- (void)resetSubviews
{
	NSArray *subviews = self.subviews.copy;

	for (NSView *subview in subviews) {
		[subview removeFromSuperview];
	}
}

- (void)populateSubviews
{
	/* Get list of views selected by the user */
	TVCMainWindow *mainWindow = self.mainWindow;

	NSArray *selectedItems = mainWindow.selectedItems;

	NSUInteger selectedItemsCount = selectedItems.count;

	if (selectedItemsCount == 0) {
		[self resetSubviews];

		self.itemIndexSelected = NSNotFound;

		return;
	}

	/* Make a list of subviews that already exist to compare when adding
	 or removing views so that we do not have to destroy entire backing. */
	NSMutableDictionary *subviews = nil;

	for (TVCMainWindowChannelViewSubview *subview in self.subviews) {
		NSString *uniqueIdentifier = subview.uniqueIdentifier;

		if (subviews == nil) {
			subviews = [NSMutableDictionary dictionary];
		}

		[subviews setObject:subview forKey:uniqueIdentifier];
	}

	/* Once selectedItems is processed, the value of subviewsUnclaimed will
	 be subviews that are no longer selected */
	NSMutableDictionary *subviewsUnclaimed = nil;

	if (subviews) {
		subviewsUnclaimed = subviews.mutableCopy;
	}

	/* Enumerate views that the user has selected */
	IRCTreeItem *itemSelected = mainWindow.selectedItem;

	__block NSUInteger itemSelectedIndex = 0;

	[selectedItems enumerateObjectsUsingBlock:^(IRCTreeItem *item, NSUInteger index, BOOL *stop) {
		NSString *uniqueIdentifier = item.uniqueIdentifier;

		TVCMainWindowChannelViewSubview *subview = nil;

		BOOL subviewIsNew = YES;

		if (subviews) {
			subview = subviews[uniqueIdentifier];

			if (subview) {
				subviewIsNew = NO;

				[subviewsUnclaimed removeObjectForKey:uniqueIdentifier];
			}
		}

		if (subview == nil) {
			subview = [self subviewForItem:item];
		}

		NSView *webView = [self webViewForItem:item];

		subview.itemIndex = index;

		if (itemSelected == item) {
			itemSelectedIndex = index;

			subview.overlayVisible = NO;
		} else {
			subview.overlayVisible = YES;
		}

		subview.uniqueIdentifier = uniqueIdentifier;

		subview.webView = webView;

		if (subviewIsNew) {
			[self addSubview:subview];
		}
	}];

	self.itemIndexSelected = itemSelectedIndex;

	/* Remove subviews that are no longer selected */
	if (subviewsUnclaimed) {
		for (NSString *itemIdentifier in subviewsUnclaimed) {
			TVCMainWindowChannelViewSubview *subview = subviewsUnclaimed[itemIdentifier];

			[subview removeFromSuperview];
		}

		subviewsUnclaimed = nil;
	}

	/* Sort views */
	if (subviews) {
		[self sortSubviewsUsingFunction:sortSubviews context:nil];

		subviews = nil;
	}

	/* Size views */
	[self adjustSubviews];
}

- (void)selectionChangeTo:(NSUInteger)itemIndex
{
	TVCMainWindow *mainWindow = self.mainWindow;

	NSArray *selectedItems = mainWindow.selectedItems;

	NSArray *subviews = self.subviews.copy;

	NSUInteger itemIndexSelected = self.itemIndexSelected;

	IRCTreeItem *newItem = selectedItems[itemIndex];

	TVCMainWindowChannelViewSubview *newItemView = subviews[itemIndex];
	TVCMainWindowChannelViewSubview *oldItemView = subviews[itemIndexSelected];

	newItemView.overlayVisible = NO;
	oldItemView.overlayVisible = YES;

	self.itemIndexSelected = itemIndex;

	[mainWindow channelViewSelectionChangeTo:newItem];
}

- (NSView *)webViewForItem:(IRCTreeItem *)item
{
	return item.viewController.backingView.webView;
}

- (TVCMainWindowChannelViewSubview *)subviewForItem:(IRCTreeItem *)item
{
	NSRect splitViewFrame = self.frame;

	splitViewFrame.origin.x = 0.0;
	splitViewFrame.origin.y = 0.0;

	  TVCMainWindowChannelViewSubview *overlayView =
	[[TVCMainWindowChannelViewSubview alloc] initWithFrame:splitViewFrame];

	overlayView.parentView = self;

	return overlayView;
}

- (CGFloat)splitView:(NSSplitView *)splitView constrainSplitPosition:(CGFloat)proposedPosition ofSubviewAt:(NSInteger)dividerIndex
{
#define _minimumPosition		22.0

	if (dividerIndex > 0) {
		NSArray *subviews = self.subviews;

		NSView *upperView = subviews[(dividerIndex - 1)];

		NSRect upperViewFrame = upperView.frame;

		CGFloat minimumPosition = (NSMaxY(upperViewFrame) + self.dividerThickness + _minimumPosition);

		if (proposedPosition < minimumPosition) {
			proposedPosition = minimumPosition;
		}
	}

	if (proposedPosition < _minimumPosition) {
		return _minimumPosition;
	}

	return proposedPosition;

#undef _minimumPosition
}

- (NSLayoutPriority)holdingPriorityForSubviewAtIndex:(NSInteger)subviewIndex
{
	return 1.0;
}

- (BOOL)splitView:(NSSplitView *)splitView canCollapseSubview:(NSView *)subview
{
	return NO;
}

- (CGFloat)dividerThickness
{
	return 2.0;
}

- (NSColor *)dividerColor
{
	NSColor *dividerColor = TVCMainWindowSplitViewDividerColor;

	if ([TPCPreferences invertSidebarColors]) {
		dividerColor = dividerColor.invertedColor;
	}

	return dividerColor;
}

@end

#pragma mark -
#pragma mark Overlay View

@implementation TVCMainWindowChannelViewSubview

- (instancetype)initWithFrame:(NSRect)frameRect
{
	if ((self = [super initWithFrame:frameRect])) {
		self.translatesAutoresizingMaskIntoConstraints = NO;

		return self;
	}

	return nil;
}

- (void)setWebView:(NSView *)webView
{
	if (self->_webView != webView) {
		self->_webView = webView;

		[self setupWebView:self->_webView];
	}
}

- (void)setupWebView:(NSView *)webView
{
	NSParameterAssert(webView != nil);

	[self addSubview:webView];

	[self addConstraints:
	 [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[webView]-0-|"
											 options:NSLayoutFormatDirectionLeadingToTrailing
											 metrics:nil
											   views:NSDictionaryOfVariableBindings(webView)]];

	[self addConstraints:
	 [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[webView(>=22)]-0-|"
											 options:NSLayoutFormatDirectionLeadingToTrailing
											 metrics:nil
											   views:NSDictionaryOfVariableBindings(webView)]];
}

- (void)addOverlayView
{
	  TVCMainWindowChannelViewSubviewOverlayView *overlayView =
	[[TVCMainWindowChannelViewSubviewOverlayView alloc] initWithFrame:self.frame];

	overlayView.translatesAutoresizingMaskIntoConstraints = NO;

	[self addSubview:overlayView];

	[self addConstraints:
	 [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[overlayView]-0-|"
											 options:NSLayoutFormatDirectionLeadingToTrailing
											 metrics:nil
											   views:NSDictionaryOfVariableBindings(overlayView)]];

	[self addConstraints:
	 [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[overlayView]-0-|"
											 options:NSLayoutFormatDirectionLeadingToTrailing
											 metrics:nil
											   views:NSDictionaryOfVariableBindings(overlayView)]];

	self.overlayView = overlayView;
}

- (void)toggleOverlayView
{
	if (self.overlayVisible == NO) {
		if ( self.overlayView) {
			[self.overlayView removeFromSuperview];
			 self.overlayView = nil;
		}
	} else {
		[self addOverlayView];
	}
}

- (void)setOverlayVisible:(BOOL)overlayVisible
{
	if (self->_overlayVisible != overlayVisible) {
		self->_overlayVisible = overlayVisible;

		[self toggleOverlayView];
	}
}

- (void)mouseDownSelectionChange
{
	[self.parentView selectionChangeTo:self.itemIndex];
}

- (void)mouseDown:(NSEvent *)theEvent
{
	if (self.overlayVisible) {
		[self mouseDownSelectionChange];
	} else {
		[super mouseDown:theEvent];
	}
}

- (void)rightMouseDown:(NSEvent *)theEvent
{
	if (self.overlayVisible) {
		[self mouseDownSelectionChange];
	} else {
		[super rightMouseDown:theEvent];
	}
}

- (void)otherMouseDown:(NSEvent *)theEvent
{
	if (self.overlayVisible) {
		[self mouseDownSelectionChange];
	} else {
		[super otherMouseDown:theEvent];
	}
}

- (nullable NSView *)hitTest:(NSPoint)aPoint
{
	if (NSPointInRect(aPoint, self.frame) == NO) {
		return nil;
	}

	if (self.overlayVisible) {
		return self.overlayView;
	}

	return [super hitTest:aPoint];
}

@end

#pragma mark -

@implementation TVCMainWindowChannelViewSubviewOverlayView

- (void)mouseDown:(NSEvent *)theEvent
{
	[self.superview mouseDown:theEvent];
}

- (void)rightMouseDown:(NSEvent *)theEvent
{
	[self.superview rightMouseDown:theEvent];
}

- (void)otherMouseDown:(NSEvent *)theEvent
{
	[self.superview otherMouseDown:theEvent];
}

- (void)drawRect:(NSRect)dirtyRect
{
	if ([self needsToDrawRect:dirtyRect] == NO) {
		return;
	}

	NSColor *backgroundColor = nil;

	if ([TPCPreferences invertSidebarColors]) {
		backgroundColor = [NSColor colorWithCalibratedWhite:0.0 alpha:0.4];
	} else {
		backgroundColor = [NSColor colorWithCalibratedWhite:0.0 alpha:0.2];
	}

	[backgroundColor set];

	[NSBezierPath fillRect:dirtyRect];
}

- (nullable NSView *)hitTest:(NSPoint)aPoint
{
	return self;
}

@end

NS_ASSUME_NONNULL_END
