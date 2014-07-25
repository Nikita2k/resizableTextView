resizableTextView
=================

ResizableTextView is UITextView subclass that helps you in creating UITextView conforming to its content.

This solution allows you to encapsulate all size-changing related code in sepparate class (and remove it from controllers, making them thinner and more beautiful).


See discussion and my answer here: http://stackoverflow.com/a/24950357/2759361

Here is local version (just in case :)


Explanation & Usage
=================
This works with iOs7 (and I do believe it will work with iOs8) and with autolayout. You don't need magic numbers, disable layout and stuff like that. Short and elegant solution.

I think, that all constraint-related code should go to updateConstraints method. So, let's make our own ResizableTextView.

The first problem we meet here is that don't know real content size before viewDidLoad method. We can take long and buggy road and calculate it based on font size, line breaks, etc. But we need robust solution, so we'll do:

	CGSize contentSize = [self sizeThatFits:CGSizeMake(self.frame.size.width, FLT_MAX)];

So now we know real contentSize no matter where we are: before or after viewDidLoad. Now add height constraint on textView (via storyboard or code, no matter how). We'll adjust that value with our contentSize.height:

	[self.constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *constraint, NSUInteger idx, BOOL *stop) {
	    if (constraint.firstAttribute == NSLayoutAttributeHeight) {
	        constraint.constant = contentSize.height;
	        *stop = YES;
	    }
	}];

The last thing to do is to tell superclass to updateConstraints.

	[super updateConstraints];
	
Now our class looks like:

ResizableTextView.m

	- (void) updateConstraints {
	    CGSize contentSize = [self sizeThatFits:CGSizeMake(self.frame.size.width, FLT_MAX)];
	
	    [self.constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *constraint, NSUInteger idx, BOOL *stop) {
	        if (constraint.firstAttribute == NSLayoutAttributeHeight) {
	            constraint.constant = contentSize.height;
	            *stop = YES;
	        }
	    }];
	
	    [super updateConstraints];
	}

Pretty and clean, right? And you don't have to deal with that code in your controllers!

But wait! Y NO ANIMATION!

You can easily animate changes to make textView stretch smoothly. Here is an example:

    [self.view layoutIfNeeded];
    // do your own text change here.
    self.infoTextView.text = [NSString stringWithFormat:@"%@, %@", self.infoTextView.text, self.infoTextView.text];
    [self.infoTextView setNeedsUpdateConstraints];
    [self.infoTextView updateConstraintsIfNeeded];
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        [self.view layoutIfNeeded];
    } completion:nil];
