//
//  TouchBar.h
//  touchbar-browser-helper
//
//  Created by Alexsander Akers on 2/13/17.
//  Modified by Viktor Strate Kløvedal on 07/11/2020.
//
//  Copyright © 2017 Alexsander Akers. All rights reserved.
//  https://github.com/a2/touch-baer/blob/master/TouchBarTest/TouchBar.h
//

#import <AppKit/AppKit.h>

extern void DFRElementSetControlStripPresenceForIdentifier(_Nonnull NSTouchBarItemIdentifier, BOOL);
extern void DFRSystemModalShowsCloseBoxWhenFrontMost(BOOL);

@interface NSTouchBarItem ()
+ (void)addSystemTrayItem:(nullable NSTouchBarItem *)item;
+ (void)removeSystemTrayItem:(nullable NSTouchBarItem *)item;
@end

@interface NSTouchBar ()

// macOS 10.14 and above
+ (void)presentSystemModalTouchBar:(nullable NSTouchBar *)touchBar placement:(long long)placement systemTrayItemIdentifier:(nullable NSTouchBarItemIdentifier)identifier NS_AVAILABLE_MAC(10.14);;
+ (void)presentSystemModalTouchBar:(nullable NSTouchBar *)touchBar systemTrayItemIdentifier:(nullable NSTouchBarItemIdentifier)identifier NS_AVAILABLE_MAC(10.14);
+ (void)dismissSystemModalTouchBar:(nullable NSTouchBar *)touchBar NS_AVAILABLE_MAC(10.14);
+ (void)minimizeSystemModalTouchBar:(nullable NSTouchBar *)touchBar NS_AVAILABLE_MAC(10.14);

// macOS 10.13 and below
+ (void)presentSystemModalFunctionBar:(nullable NSTouchBar *)touchBar placement:(long long)placement systemTrayItemIdentifier:(nullable NSTouchBarItemIdentifier)identifier NS_DEPRECATED_MAC(10.12.2, 10.14);
+ (void)presentSystemModalFunctionBar:(nullable NSTouchBar *)touchBar systemTrayItemIdentifier:(nullable NSTouchBarItemIdentifier)identifier NS_DEPRECATED_MAC(10.12.2, 10.14);
+ (void)dismissSystemModalFunctionBar:(nullable NSTouchBar *)touchBar NS_DEPRECATED_MAC(10.12.2, 10.14);
+ (void)minimizeSystemModalFunctionBar:(nullable NSTouchBar *)touchBar NS_DEPRECATED_MAC(10.12.2, 10.14);

@end
