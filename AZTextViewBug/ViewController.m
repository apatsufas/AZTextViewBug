//
//  ViewController.m
//  AZTextViewBug
//
//  Created by Andreas on 2/2/14.
//  Copyright (c) 2014 Andreas Zimnas. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITextViewDelegate>

@property (nonatomic) IBOutlet UITextView* textView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    
	NSString *longText = @"SCROLL TO THE BOTTOM BEFORE TAPPING. INSTRUCTIONS ARE AT THE BOTTOM.\n\nWhat is iOS\n\nWhen something is designed to work beautifully, it tends to look that way, too.\n\nNothing we’ve ever created has been designed just to look beautiful. That’s approaching the opportunity from the wrong end. Instead, as we reconsidered iOS, our purpose was to create an experience that was simpler, more useful, and more enjoyable — while building on the things people love about iOS. Ultimately, redesigning the way it works led us to redesign the way it looks. Because good design is design that’s in service of the experience.\n\nSimplicity is actually quite complicated.\n\nSimplicity is often equated with minimalism. Yet true simplicity is so much more than just the absence of clutter or the removal of decoration. It’s about offering up the right things, in the right place, right when you need them. It’s about bringing order to complexity. And it’s about making something that always seems to “just work.” When you pick something up for the first time and already know how to do the things you want to do, that’s simplicity.\n\niOS 7 is a pure representation of simplicity.\n\nIt has a new structure, applied across the whole system, that brings clarity to the entire experience. The interface is purposely unobtrusive. Conspicuous ornamentation has been stripped away. Unnecessary bars and buttons have been removed. And in taking away design elements that don’t add value, suddenly there’s greater focus on what matters most: your content.\n\nReplay\n\nYou know good design when you use it.\n\nWe value utility above all else. We don’t add features simply because we can, because it’s technologically possible. We add features only when they’re truly useful. And we add them in a way that makes sense. The new Control Center in iOS 7 is a great example. It gives you one-swipe access to the things you often want to do on a moment’s notice.\n\nWith iOS 7, we took something millions of people already love and refined the experience to make it even more effortless and useful. So the everyday things you need to do are the everyday things you want to do. And iOS 7 lets you work in ways that are instantly familiar, so there’s no need to relearn everything. Your Home screen is still your Home screen, for example. Only now, it takes even better advantage of your Retina display — and the space underneath the display. But you use it in exactly the same way.\n\nTechnology should never get in the way of humanity.\n\nWhen a product is designed properly — when you don’t have to adapt to the technology because it’s already designed around you — you develop a connection with it. It becomes more to you than just a device. iOS 7 invites that kind of connection. Interactions are dynamic. Animations are cinematic. And the experience is lively and spirited in so many unexpected yet perfectly natural ways. Open the Weather app, for example, and you’ll instantly understand. Hail bounces off text, and fog passes in front of it. Storm clouds come into view with a flash of lightning. And suddenly, checking the weather is like looking out a window.\n\nTAP AFTER THE TEXT. AFTER THE KEYBOARD APPEARS, SCROLL SO YOU CAN SEE YOUR TYPING. THEN HIT RETURN -- THE INSERTION POINT WILL BE HIDDEN. IF YOU TYPE IT WILL APPEAR.";
    
	self.textView.text = longText;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:nil object:nil];
}

#pragma mark -
#pragma mark iOS 7 TextView Scroll bug fix

-(void)scrollToCarret:(UITextView*)textView{
    CGRect caretRect = [textView caretRectForPosition:textView.selectedTextRange.end];
    NSLog(@"y %f", caretRect.origin.y);
    caretRect.size.height += textView.textContainerInset.bottom;
    [textView scrollRectToVisible:caretRect animated:NO];
}

- (void)scrollToShowSelection:(UITextView *)textView {
    
	if (textView.selectedRange.location < textView.text.length) {
		NSLog(@"nothing to do");
		return;
	}
    
	NSLog(@"selectedRange.location: %ld", (unsigned long)textView.selectedRange.location);
	CGPoint bottomOffset = CGPointMake(0, textView.contentSize.height - textView.bounds.size.height);
	NSLog(@"bottomOffset.y: %f", bottomOffset.y);
	[textView setContentOffset:bottomOffset animated:YES];
}

#pragma mark -
#pragma mark UITextViewDelegate


- (void)textViewDidChangeSelection:(UITextView *)textView {
    [self scrollToCarret:textView];
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
	if ([text isEqualToString:@"\n"] || [text isEqualToString:@""]) {
		[self performSelector:@selector(scrollToShowSelection:) withObject:textView afterDelay:0.1]; /*Smaller delays are unreliable.*/
	}
    
	return YES;
}

#pragma mark -
#pragma mark Responding to keyboard events

- (void)keyboardWillShow:(NSNotification *)notification {
    
    NSValue *keyboardFrameValue = [notification userInfo][UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardFrame = [keyboardFrameValue CGRectValue];
    
	CGRect r = self.textView.frame;
	r.size.height -= CGRectGetHeight(keyboardFrame);
	self.textView.frame = r;
}

@end
