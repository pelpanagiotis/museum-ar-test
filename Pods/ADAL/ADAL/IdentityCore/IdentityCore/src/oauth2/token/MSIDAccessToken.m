// Copyright (c) Microsoft Corporation.
// All rights reserved.
//
// This code is licensed under the MIT License.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files(the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and / or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions :
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "MSIDAccessToken.h"
#import "MSIDAADTokenResponse.h"
#import "NSOrderedSet+MSIDExtensions.h"
#import "MSIDAADV1TokenResponse.h"
#import "MSIDAADV2TokenResponse.h"
#import "MSIDUserInformation.h"
#import "NSDate+MSIDExtensions.h"

//in seconds, ensures catching of clock differences between the server and the device
static NSUInteger s_expirationBuffer = 300;

@interface MSIDAccessToken()

@property (readwrite) NSString *target;

@end

@implementation MSIDAccessToken

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    MSIDAccessToken *item = [super copyWithZone:zone];
    item->_expiresOn = [_expiresOn copyWithZone:zone];
    item->_cachedAt = [_cachedAt copyWithZone:zone];
    item->_accessToken = [_accessToken copyWithZone:zone];
    item->_target = [_target copyWithZone:zone];

    return item;
}

#pragma mark - NSObject

- (BOOL)isEqual:(id)object
{
    if (self == object)
    {
        return YES;
    }
    
    if (![object isKindOfClass:MSIDAccessToken.class])
    {
        return NO;
    }
    
    return [self isEqualToItem:(MSIDAccessToken *)object];
}

- (NSUInteger)hash
{
    NSUInteger hash = [super hash];
    hash = hash * 31 + self.expiresOn.hash;
    hash = hash * 31 + self.accessToken.hash;
    hash = hash * 31 + self.target.hash;
    hash = hash * 31 + self.cachedAt.hash;
    return hash;
}

- (BOOL)isEqualToItem:(MSIDAccessToken *)token
{
    if (!token)
    {
        return NO;
    }
    
    BOOL result = [super isEqualToItem:token];
    result &= (!self.expiresOn && !token.expiresOn) || [self.expiresOn isEqualToDate:token.expiresOn];
    result &= (!self.accessToken && !token.accessToken) || [self.accessToken isEqualToString:token.accessToken];
    result &= (!self.target && !token.target) || [self.target isEqualToString:token.target];
    result &= (!self.cachedAt && !token.cachedAt) || [self.cachedAt isEqualToDate:token.cachedAt];

    return result;
}

#pragma mark - Cache

- (instancetype)initWithTokenCacheItem:(MSIDCredentialCacheItem *)tokenCacheItem
{
    self = [super initWithTokenCacheItem:tokenCacheItem];
    
    if (self)
    {
        _expiresOn = tokenCacheItem.expiresOn;
        _cachedAt = tokenCacheItem.cachedAt;
        _accessToken = tokenCacheItem.secret;

        if (!_accessToken)
        {
            MSID_LOG_ERROR(nil, @"Trying to initialize access token when missing access token field");
            return nil;
        }
        
        _target = tokenCacheItem.target;
        
        if (!_target)
        {
            MSID_LOG_ERROR(nil, @"Trying to initialize access token when missing target field");
            return nil;
        }
    }
    
    return self;
}

- (MSIDCredentialCacheItem *)tokenCacheItem
{
    MSIDCredentialCacheItem *cacheItem = [super tokenCacheItem];
    cacheItem.expiresOn = self.expiresOn;
    cacheItem.cachedAt = self.cachedAt;
    cacheItem.secret = self.accessToken;
    cacheItem.target = self.target;
    cacheItem.credentialType = MSIDAccessTokenType;
    return cacheItem;
}

#pragma mark - Token type

- (MSIDCredentialType)credentialType
{
    return MSIDAccessTokenType;
}

#pragma mark - Expiry

- (BOOL)isExpiredWithExpiryBuffer:(NSUInteger)expiryBuffer
{
    if (self.cachedAt && [[NSDate date] compare:self.cachedAt] == NSOrderedAscending)
    {
        return YES;
    }

    NSDate *nowPlusBuffer = [NSDate dateWithTimeIntervalSinceNow:expiryBuffer];
    return [self.expiresOn compare:nowPlusBuffer] == NSOrderedAscending;
}

- (BOOL)isExpired
{
    return [self isExpiredWithExpiryBuffer:s_expirationBuffer];
}

- (NSDate *)extendedExpireTime
{
    return _additionalServerInfo[MSID_EXTENDED_EXPIRES_ON_CACHE_KEY];
}

- (BOOL)isExtendedLifetimeValid
{
    NSDate *extendedExpiresOn = self.extendedExpireTime;
    
    //extended lifetime is only valid if it contains an access token
    if (extendedExpiresOn && ![NSString msidIsStringNilOrBlank:self.accessToken])
    {
        return [extendedExpiresOn compare:[NSDate date]] == NSOrderedDescending;
    }
    
    return NO;
}

#pragma mark - Resource/scopes

- (NSString *)resource
{
    return _target;
}

- (void)setResource:(NSString *)resource
{
    _target = resource;
}

- (NSOrderedSet<NSString *> *)scopes
{
    return [_target msidScopeSet];
}

- (void)setScopes:(NSOrderedSet<NSString *> *)scopes
{
    _target = [scopes msidToString];
}

#pragma mark - Description

- (NSString *)description
{
    NSString *baseDescription = [super description];
    return [baseDescription stringByAppendingFormat:@"(access token=%@, expiresOn=%@, target=%@)", _PII_NULLIFY(_accessToken), _expiresOn, _target];
}

@end
