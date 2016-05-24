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

#import "BuildConfig.h"

#import "TextualApplication.h"

@class IRCExtras;
// @class IRCMessageBatchMessage;
// @class IRCMessageBatchMessageContainer;
@class IRCTimerCommandContext;
@class IRCUserNicknameColorStyleGenerator;
@class TDCAboutDialog;
@class TDCAddressBookSheet;
@class TDCFileTransferDialog;
@class TDCFileTransferDialogTableCell;
// @class TDCFileTransferDialogTransferController;
@class TDCHighlightEntrySheet;
@class TDCLicenseManagerDialog;
@class TDCLicenseManagerMigrateAppStoreSheet;
@class TDCLicenseManagerRecoverLostLicenseSheet;
@class TDCNicknameColorSheet;
@class TDCPreferencesController;
@class TDCPreferencesSoundWrapper;
@class TDCProgressInformationSheet;
@class TDCServerChangeNicknameSheet;
@class TDCServerChannelListDialog;
@class TDCServerHighlightListSheet;
@class TDCServerPropertiesSheet;
@class TDCSheetBase;
@class TDCWelcomeSheet;
@class TDChannelBanListSheet;
@class TDChannelInviteSheet;
@class TDChannelModifyModesSheet;
@class TDChannelModifyTopicSheet;
@class TDChannelPropertiesSheet;
@class THOPluginDispatcher;
@class THOPluginItem;
@class THOPluginManager;
@class TLOEncryptionManager;
@class TLOFileLogger;
@class TLOInputHistory;
@class TLOLicenseManagerDownloader;
@class TLONicknameCompletionStatus;
@class TLOSpeechSynthesizer;
@class TPCResourceManagerDocumentTypeImporter;
@class TVCDockIcon;
@class TVCContentNavigationOutlineView;
@class TVCImageURLoader;
@class TVCLogControllerHistoricLogFile;
@class TVCLogControllerOperationQueue;
@class TVCLogPolicy;
@class TVCLogScriptEventSink;
@class TVCLogViewInternalWK1;
@class TVCLogViewInternalWK2;
@class TVCMainWindowChannelView;
@class TVCMainWindowChannelViewSubview;
@class TVCMainWindowChannelViewSubviewOverlayView;
@class TVCMainWindowSegmentedController;
@class TVCMainWindowSegmentedControllerCell;
@class TVCMainWindowSidebarMavericksSmoothTextField;
@class TVCMainWindowSidebarYosemiteSmoothTextField;
@class TVCMainWindowSidebarYosemtieSmoothTextFieldCell;
@class TVCMainWindowTextViewBackground;
@class TVCMainWindowTextViewContentView;
@class TVCMainWindowTextViewMavericksUserInterace;
@class TVCMainWindowTextViewYosemiteUserInterace;
@class TVCMainWindowTitlebarAccessoryView;
@class TVCMainWindowTitlebarAccessoryViewController;
@class TVCMainWindowTitlebarAccessoryViewLockButton;
@class TVCMemberListCell;
@class TVCMemberListDarkYosemiteUserInterface;
@class TVCMemberListLightYosemiteUserInterface;
@class TVCMemberListMavericksDarkUserInterface;
@class TVCMemberListMavericksLightUserInterface;
@class TVCMemberListMavericksUserInterface;
@class TVCMemberListMavericksUserInterfaceBackground;
@class TVCMemberListRowCell;
@class TVCMemberListSharedUserInterface;
@class TVCMemberListUserInfoPopover;
@class TVCMemberListYosemiteUserInterface;
@class TVCQueuedCertificateTrustPanel;
@class TVCServerListCell;
@class TVCServerListCellChildItem;
@class TVCServerListCellGroupItem;
@class TVCServerListDarkYosemiteUserInterface;
@class TVCServerListLightYosemiteUserInterface;
@class TVCServerListMavericksDarkUserInterface;
@class TVCServerListMavericksLightUserInterface;
@class TVCServerListMavericksUserInterface;
@class TVCServerListMavericksUserInterfaceBackground;
@class TVCServerListRowCell;
@class TVCServerListSharedUserInterface;
@class TVCServerListYosemiteUserInterface;
@class TVCTextViewIRCFormattingMenu;
@class TXMenuControllerMainWindowProxy;
@class TXWindowController;

#import "GCDAsyncSocket.h"
#import "GCDAsyncSocketCipherNames.h"
#import "GCDAsyncSocketExtensions.h"
#import "GRMustache.h"
#import "GRMustacheAvailabilityMacros.h"
#import "GRMustacheConfiguration.h"
#import "GRMustacheContentType.h"
#import "GRMustacheContext.h"
#import "GRMustacheError.h"
#import "GRMustacheFilter.h"
#import "GRMustacheLocalizer.h"
#import "GRMustacheRendering.h"
#import "GRMustacheSafeKeyAccess.h"
#import "GRMustacheTag.h"
#import "GRMustacheTagDelegate.h"
#import "GRMustacheTemplate.h"
#import "GRMustacheTemplateRepository.h"
#import "GRMustacheVersion.h"
#import "GTMEncodeHTML.h"
#import "IRCChannelConfigPrivate.h"
#import "IRCChannelModePrivate.h"
#import "IRCChannelPrivate.h"
#import "IRCClientConfigPrivate.h"
#import "IRCClientPrivate.h"
#import "IRCCommandIndexPrivate.h"
#import "IRCConnectionPrivate.h"
#import "IRCExtrasPrivate.h"
#import "IRCISupportInfoPrivate.h"
// #import "IRCMessageBatchPrivate.h"
#import "IRCMessagePrivate.h"
#import "IRCTimerCommand.h"
#import "IRCTimerCommandPrivate.h"
#import "IRCTreeItemPrivate.h"
#import "IRCUserPrivate.h"
#import "IRCWorldPrivate.h"

#if TEXTUAL_BUILT_WITH_ICLOUD_SUPPORT == 1
#import "IRCWorldPrivateCloudExtension.h"
#endif

#import "NSObjectHelperPrivate.h"
#import "NSTableVIewHelperPrivate.h"
#import "NSViewHelperPrivate.h"
#import "OELReachability.h"
#import "TDCAboutDialogPrivate.h"
#import "TDCAddressBookSheetPrivate.h"
#import "TDCFileTransferDialogPrivate.h"
#import "TDCFileTransferDialogTableCellPrivate.h"
// #import "TDCFileTransferDialogTransferControllerPrivate.h"
#import "TDCHighlightEntrySheetPrivate.h"

#if TEXTUAL_BUILT_WITH_LICENSE_MANAGER == 1
#import "TDCLicenseManagerDialogPrivate.h"
#import "TDCLicenseManagerMigrateAppStoreSheetPrivate.h"
#import "TDCLicenseManagerRecoverLostLicenseSheetPrivate.h"
#endif

#import "TDCNicknameColorSheetPrivate.h"
#import "TDCPreferencesControllerPrivate.h"
#import "TDCPreferencesSoundWrapperPrivate.h"
#import "TDCProgressInformationSheetPrivate.h"
#import "TDCServerChangeNicknameSheetPrivate.h"
#import "TDCServerChannelListDialogPrivate.h"
#import "TDCServerHighlightListSheetPrivate.h"
#import "TDCServerPropertiesSheetPrivate.h"
#import "TDCSheetBasePrivate.h"
#import "TDCWelcomeSheetPrivate.h"
#import "TDChannelBanListSheetPrivate.h"
#import "TDChannelInviteSheetPrivate.h"
#import "TDChannelModifyModesSheetPrivate.h"
#import "TDChannelModifyTopicSheetPrivate.h"
#import "TDChannelPropertiesSheetPrivate.h"
#import "THOPluginDispatcherPrivate.h"
#import "THOPluginItemPrivate.h"
#import "THOPluginManagerPrivate.h"
#import "THOPluginProtocolPrivate.h"
#import "TLOEncryptionManagerPrivate.h"
#import "TLOFileLoggerPrivate.h"
#import "TLOGrowlControllerPrivate.h"
#import "TLOInputHistoryPrivate.h"

#if TEXTUAL_BUILT_WITH_LICENSE_MANAGER == 1
#import "TLOLicenseManagerDownloaderPrivate.h"
#import "TLOLicenseManagerPrivate.h"
#endif

#import "TLONicknameCompletionStatusPrivate.h"
#import "TLOSpeechSynthesizerPrivate.h"
#import "TPCApplicationInfoPrivate.h"
#import "TPCPathInfoPrivate.h"

#if TEXTUAL_BUILT_WITH_ICLOUD_SUPPORT == 1
#import "TPCPreferencesCloudSyncPrivate.h"
#endif

#import "TPCPreferencesImportExportPrivate.h"
#import "TPCPreferencesPrivate.h"
#import "TPCPreferencesUserDefaultsMigratePrivate.h"
#import "TPCPreferencesUserDefaultsPrivate.h"
#import "TPCResourceManagerPrivate.h"
#import "TPCThemeControllerPrivate.h"
#import "TPCThemeSettingsPrivate.h"
#import "TVCContentNavigationOutlineView.h"
#import "TVCDockIconPrivate.h"
#import "TVCImageURLoaderPrivate.h"
#import "TVCLogControllerHistoricLogFilePrivate.h"
#import "TVCLogControllerOperationQueuePrivate.h"
#import "TVCLogControllerPrivate.h"
#import "TVCLogLinePrivate.h"
#import "TVCLogPolicyPrivate.h"
#import "TVCLogScriptEventSinkPrivate.h"
#import "TVCLogViewInternalWK1.h"
#import "TVCLogViewInternalWK2.h"
#import "TVCLogViewPrivate.h"
#import "TVCMainWindowChannelViewPrivate.h"
#import "TVCMainWindowPrivate.h"
#import "TVCMainWindowSegmentedControlPrivate.h"
#import "TVCMainWindowSidebarSmoothTextFieldPrivate.h"
#import "TVCMainWindowSplitViewPrivate.h"
#import "TVCMainWindowTextViewMavericksUserInteracePrivate.h"
#import "TVCMainWindowTextViewPrivate.h"
#import "TVCMainWindowTextViewYosemiteUserInteracePrivate.h"
#import "TVCMainWindowTitlebarAccessoryViewPrivate.h"
#import "TVCMemberListCellPrivate.h"
#import "TVCMemberListMavericksUserInterfacePrivate.h"
#import "TVCMemberListPrivate.h"
#import "TVCMemberListSharedUserInterfacePrivate.h"
#import "TVCMemberListUserInfoPopoverPrivate.h"
#import "TVCMemberListYosemiteUserInterfacePrivate.h"
#import "TVCQueuedCertificateTrustPanelPrivate.h"
#import "TVCServerListCellPrivate.h"
#import "TVCServerListMavericksUserInterfacePrivate.h"
#import "TVCServerListPrivate.h"
#import "TVCServerListSharedUserInterfacePrivate.h"
#import "TVCServerListYosemiteUserInterfacePrivate.h"
#import "TVCTextFormatterMenuPrivate.h"
#import "TVCTextViewWithIRCFormatterPrivate.h"
#import "TXGlobalModelsPrivate.h"
#import "TXMasterControllerPrivate.h"
#import "TXMenuControllerPrivate.h"
#import "TXSharedApplicationPrivate.h"
#import "TXWindowControllerPrivate.h"
#import "WKWebViewPrivate.h"
#import "WebScriptObjectHelperPrivate.h"
