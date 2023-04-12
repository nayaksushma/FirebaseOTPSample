//
//  ViewController.m
//  FirebaseOTPSample
//
//  Created by Sushma on 2023-04-06.
//

#import "ViewController.h"
@import FirebaseCore;
@import FirebaseAuth;

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *verificationCodeTextField;
@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
}

- (IBAction)didTapLogin:(id)sender {

  //User's phone number.
  NSString *userPhoneNumber = self.phoneNumberTextField.text;
  //Send a verification code to the user's phone
  [[FIRPhoneAuthProvider provider] verifyPhoneNumber:userPhoneNumber
                                          UIDelegate:nil
                                          completion:^(NSString * _Nullable verificationID, NSError * _Nullable error) {
    if (error) {

      NSLog(@"Error = %@", error.localizedDescription);
      NSString *errorAlert = [NSString stringWithFormat:@"Error - %@!!", error.localizedDescription];
      [self showAlert:errorAlert];
      return;
    }
    // Sign in using the verificationID and the code sent to the user
    // ...
    NSLog(@"Completion with verification ID = %@", verificationID);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:verificationID forKey:@"authVerificationID"];

  }];
}
- (IBAction)didTapCompleteWithOTP:(id)sender {

  NSString *verificationCode = self.verificationCodeTextField.text;
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  NSString *verificationID = [defaults stringForKey:@"authVerificationID"];

  FIRAuthCredential *credential = [[FIRPhoneAuthProvider provider]
                                   credentialWithVerificationID:verificationID
                                   verificationCode:verificationCode];


  //3.Sign in the user with the FIRPhoneAuthCredential object:

  [[FIRAuth auth] signInWithCredential:credential
                            completion:^(FIRAuthDataResult * _Nullable authResult,
                                         NSError * _Nullable error) {

    if (error) {
      // ...
      NSLog(@"Error - Auth signInWithCredential = %@", error);
      NSString *errorAlert = [NSString stringWithFormat:@"Error - %@!!", error.localizedDescription];
      [self showAlert:errorAlert];
      return;
    }
    // User successfully signed in. Get user data from the FIRUser object
    if (authResult == nil) { return; }
    FIRUser *user = authResult.user;
    // ...
    [self showAlert:@"Successfully Authenticated!!"];
    NSLog(@"Authenticated user = %@", user.phoneNumber);
  }];
}


-(void)showAlert:(NSString *)alertMessage {
  UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Alert"
                                                                 message:alertMessage
                                                          preferredStyle:UIAlertControllerStyleAlert];

  UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * action) {}];

  [alert addAction:defaultAction];
  [self presentViewController:alert animated:YES completion:nil];
}

@end
