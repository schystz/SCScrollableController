//
//  SCScrollableController.m
//  Prototype
//
//  Created by James Russell Orola on 11/11/14.
//  Copyright (c) 2014 schystz. All rights reserved.
//

#import "SCScrollableController.h"

@interface SCScrollableController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@end

@implementation SCScrollableController

# pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapScrollView)];
    [self.scrollView addGestureRecognizer:tapGR];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.scrollView.contentSize = self.view.frame.size;
    NSLog(@"[viewDidAppear] Scrollview contentSize = %@", NSStringFromCGSize(self.scrollView.contentSize));
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    self.scrollView.contentSize = self.view.frame.size;
    NSLog(@"[didRotateFromInterfaceOrientation] Scrollview contentSize = %@", NSStringFromCGSize(self.scrollView.contentSize));
}

#pragma mark - Private Methods

-(void)keyboardWillShow:(NSNotification *)notification {
    [self resizeScrollView:YES withNotification:notification];
}

-(void)keyboardWillHide:(NSNotification *)notification {
    [self resizeScrollView:NO withNotification:notification];
}

- (void)resizeScrollView:(BOOL)keyboardShown withNotification:(NSNotification *)notification {
    NSLog(@"Resizing scroll view...");
    
    NSDictionary *userInfo = [notification userInfo];
    float keyboardHeight = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size.height;
    float duration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    int curve = [[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];
    
    CGRect frame = self.scrollView.frame;
    if (keyboardShown) {
        frame.size.height -= keyboardHeight;
    } else {
        frame.size.height += keyboardHeight;
    }
    
    [UIView animateWithDuration:duration delay:0 options:curve animations:^{
        [self.scrollView setFrame:frame];
    } completion:nil];
    
    NSLog(@"Scrollview frame = %@", NSStringFromCGRect(self.scrollView.frame));
    NSLog(@"Scrollview contentSize = %@", NSStringFromCGSize(self.scrollView.contentSize));
}

- (void)didTapScrollView {
    [self.view endEditing:YES];
}

@end
