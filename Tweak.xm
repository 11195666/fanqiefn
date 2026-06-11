#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>
#import <objc/message.h>
#include <substrate.h>

static NSString * const kTargetBundleID = @"com.dragon.read";

// ── 小组件相关 key 关键词 ──
static BOOL isWidgetKey(NSString *key) {
    if (!key || ![key isKindOfClass:[NSString class]]) return NO;
    NSString *lower = [key lowercaseString];
    return [lower containsString:@"widget"] ||
           [lower containsString:@"小组件"];
}

%ctor {
    NSString *bid = [[NSBundle mainBundle] bundleIdentifier];
    if (![bid isEqualToString:kTargetBundleID]) return;
    NSLog(@"[FNNotify] ✅ 已注入番茄小说 — 通知权限伪装 + 小组件伪装已启用");
}

// ── 新通知 API (iOS 10+) ──
%hook UNUserNotificationCenter

+ (void)requestAuthorizationWithOptions:(UNAuthorizationOptions)options
                      completionHandler:(void (^)(BOOL granted, NSError *error))h {
    if (h) {
        h(YES, nil);
    }
}

%end

// ── 通知设置细节 ──
%hook UNNotificationSettings

- (UNAuthorizationStatus)authorizationStatus {
    return UNAuthorizationStatusAuthorized;
}

- (UNNotificationSetting)alertSetting {
    return UNNotificationSettingEnabled;
}

- (UNNotificationSetting)soundSetting {
    return UNNotificationSettingEnabled;
}

- (UNNotificationSetting)badgeSetting {
    return UNNotificationSettingEnabled;
}

- (UNShowPreviewsSetting)showPreviewsSetting {
    return UNShowPreviewsSettingAlways;
}

%end

// ── 远程推送注册 ──
%hook UIApplication

- (BOOL)isRegisteredForRemoteNotifications {
    return YES;
}

- (void)registerForRemoteNotifications {
    // 吞掉注册调用，避免触发系统弹窗
}

// ── 旧版通知 API (兼容老 SDK) ──
- (id)currentUserNotificationSettings {
    Class cls = NSClassFromString(@"UIUserNotificationSettings");
    // settingsForTypes: 7 = Badge(1) | Sound(2) | Alert(4)
    return ((id(*)(Class, SEL, NSUInteger, id))objc_msgSend)(cls, @selector(settingsForTypes:categories:), 7, nil);
}

%end

// ═══════════════════════════════════════════
// 小组件伪装 — 让 app 误以为已添加小组件
// ═══════════════════════════════════════════

// ── NSUserDefaults: 拦截小组件相关 key ──
%hook NSUserDefaults

- (BOOL)boolForKey:(NSString *)key {
    if (isWidgetKey(key)) {
        return YES;
    }
    return %orig;
}

- (id)objectForKey:(NSString *)key {
    if (isWidgetKey(key)) {
        return @YES;
    }
    return %orig;
}

- (NSInteger)integerForKey:(NSString *)key {
    if (isWidgetKey(key)) {
        return 1;
    }
    return %orig;
}

%end

// ── 兜底: 拦截小组件相关 UIAlertController ──
%hook UIAlertController

- (void)setTitle:(NSString *)title {
    if (title && isWidgetKey(title)) {
        NSLog(@"[FNNotify] 🛡 已拦截小组件弹窗: %@", title);
        return;
    }
    %orig;
}

- (void)setMessage:(NSString *)message {
    if (message && isWidgetKey(message)) {
        NSLog(@"[FNNotify] 🛡 已拦截小组件弹窗消息: %@", message);
        return;
    }
    %orig;
}

%end
