/**
Copyright (c) 2015-present, Facebook, Inc. All rights reserved.

Redistribution and use in source and binary forms, with or without modification,
are permitted provided that the following conditions are met:

 * Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.

 * Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.

 * Neither the name Facebook nor the names of its contributors may be used to
   endorse or promote products derived from this software without specific
   prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


Additional Grant of Patent Rights Version 2

"Software" means the React Native software distributed by Facebook, Inc.

Facebook, Inc. (“Facebook”) hereby grants to each recipient of the Software
(“you”) a perpetual, worldwide, royalty-free, non-exclusive, irrevocable
(subject to the termination provision below) license under any Necessary
Claims, to make, have made, use, sell, offer to sell, import, and otherwise
transfer the Software. For avoidance of doubt, no license is granted under
Facebook's rights in any patent claims that are infringed by (i) modifications
to the Software made by you or any third party or (ii) the Software in
combination with any software or other technology.

The license granted hereunder will terminate, automatically and without notice,
if you (or any of your subsidiaries, corporate affiliates or agents) initiate
directly or indirectly, or take a direct financial interest in, any Patent
Assertion: (i) against Facebook or any of its subsidiaries or corporate
affiliates, (ii) against any party if such Patent Assertion arises in whole or
in part from any software, technology, product or service of Facebook or any of
its subsidiaries or corporate affiliates, or (iii) against any party relating
to the Software. Notwithstanding the foregoing, if Facebook or any of its
subsidiaries or corporate affiliates files a lawsuit alleging patent
infringement against you in the first instance, and you respond by filing a
patent infringement counterclaim in that lawsuit against that party that is
unrelated to the Software, the license granted hereunder will not terminate
under section (i) of this paragraph due to such counterclaim.

A "Necessary Claim" is a claim of a patent owned by Facebook that is
necessarily infringed by the Software standing alone.

A "Patent Assertion" is any lawsuit or other action alleging direct, indirect,
or contributory infringement or inducement to infringe any patent, including a
cross-claim or counterclaim.
*/

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "RCTLog.h"
#import "RCTRootView.h"

#define TIMEOUT_SECONDS 600
#define TEXT_TO_LOOK_FOR @"Welcome to React Native!"

@interface TestAppTests : XCTestCase

@end

@implementation TestAppTests

- (BOOL)findSubviewInView:(UIView *)view matching:(BOOL(^)(UIView *view))test
{
  if (test(view)) {
    return YES;
  }
  for (UIView *subview in [view subviews]) {
    if ([self findSubviewInView:subview matching:test]) {
      return YES;
    }
  }
  return NO;
}

- (void)testRendersWelcomeScreen
{
  UIViewController *vc = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
  NSDate *date = [NSDate dateWithTimeIntervalSinceNow:TIMEOUT_SECONDS];
  BOOL foundElement = NO;

  __block NSString *redboxError = nil;
  RCTSetLogFunction(^(RCTLogLevel level, RCTLogSource source, NSString *fileName, NSNumber *lineNumber, NSString *message) {
    if (level >= RCTLogLevelError) {
      redboxError = message;
    }
  });

  while ([date timeIntervalSinceNow] > 0 && !foundElement && !redboxError) {
    [[NSRunLoop mainRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
    [[NSRunLoop mainRunLoop] runMode:NSRunLoopCommonModes beforeDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];

    foundElement = [self findSubviewInView:vc.view matching:^BOOL(UIView *view) {
      if ([view.accessibilityLabel isEqualToString:TEXT_TO_LOOK_FOR]) {
        return YES;
      }
      return NO;
    }];
  }

  RCTSetLogFunction(RCTDefaultLogFunction);

  XCTAssertNil(redboxError, @"RedBox error: %@", redboxError);
  XCTAssertTrue(foundElement, @"Couldn't find element with text '%@' in %d seconds", TEXT_TO_LOOK_FOR, TIMEOUT_SECONDS);
}


@end
