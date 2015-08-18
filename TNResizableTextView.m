//
//  TNResizableTextView.m
//
//  Created by Nikita Took on 25.07.14.
//

#import "TNResizableTextView.h"

@implementation ResizableTextView
- (void) updateConstraints {
    // calculate contentSize manually (ios7 doesn't calculate it before viewDidAppear, and we'll get here before)
    CGSize contentSize = [self sizeThatFits:CGSizeMake(self.frame.size.width, CGFLOAT_MAX)];
    
    // set the height constraint to change textView height
    [self.constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *constraint, NSUInteger idx, BOOL *stop) {
        if (constraint.firstAttribute == NSLayoutAttributeHeight) {
            constraint.constant = contentSize.height;
            *stop = YES;
        }
    }];
    
    [super updateConstraints];
}
@end
