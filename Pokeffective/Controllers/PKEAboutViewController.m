//
//  PKEAboutViewController.m
//  Pokeffective
//
//  Created by Renzo Crisóstomo on 09/03/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import "PKEAboutViewController.h"
#import <TSMessages/TSMessage.h>
#import <VTAcknowledgementsViewController/VTAcknowledgementsViewController.h>
#import <Accounts/ACAccountStore.h>
#import <Accounts/ACAccountType.h>
#import <Social/SLRequest.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <libextobjc/EXTScope.h>

@interface PKEAboutViewController () <MFMailComposeViewControllerDelegate>

- (void)follow;
- (void)email;
- (void)acknowledgements;

@end

@implementation PKEAboutViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath
                                  animated:true];
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 1:
                [self follow];
                break;
            case 2:
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/ruenzuo"]];
                break;
            case 3:
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://ruenzuo.github.io/"]];
                break;
            case 4:
                [self email];
                break;
        }
    }
    else if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:
                [self acknowledgements];
                break;
        }
    }
}

- (void)follow
{
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    @weakify(self);
    [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error) {
        @strongify(self);
        if(granted) {
            NSArray *accounts = [accountStore accountsWithAccountType:accountType];
            if ([accounts count] > 0) {
                ACAccount *twitterAccount = [accounts objectAtIndex:0];
                NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
                [parameters setValue:@"ruenzuo" forKey:@"screen_name"];
                [parameters setValue:@"true" forKey:@"follow"];
                SLRequest *postRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                                            requestMethod:SLRequestMethodPOST
                                                                      URL:[NSURL URLWithString:@"https://api.twitter.com/1.1/friendships/create.json"]
                                                               parameters:parameters];
                [postRequest setAccount:twitterAccount];
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:true];
                [postRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:false];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        @strongify(self);
                        if ([urlResponse statusCode] == 200) {
                            [TSMessage showNotificationInViewController:self
                                                                  title:@"Success"
                                                               subtitle:@"You're now following me on Twitter."
                                                                   type:TSMessageNotificationTypeSuccess
                                                               duration:2.0f
                                                   canBeDismissedByUser:YES];
                        }
                        else {
                            [TSMessage showNotificationInViewController:self
                                                                  title:@"Error"
                                                               subtitle:@"Something wrong happened. Try this later."
                                                                   type:TSMessageNotificationTypeError
                                                               duration:2.0f
                                                   canBeDismissedByUser:YES];
                        }
                    });
                }];
            }
            else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [TSMessage showNotificationInViewController:self
                                                          title:@"Error"
                                                       subtitle:@"It seems that you don't have a Twitter account configured."
                                                           type:TSMessageNotificationTypeError
                                                       duration:2.0f
                                           canBeDismissedByUser:YES];
                });
            }
        }
    }];
}

- (void)email
{
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
        [controller setToRecipients:@[@"renzo.crisostomo@me.com"]];
        [controller setMailComposeDelegate:self];
        [self presentViewController:controller
                           animated:true
                         completion:nil];
    }
    else {
        [TSMessage showNotificationInViewController:self
                                              title:@"Error"
                                           subtitle:@"No email account configured."
                                               type:TSMessageNotificationTypeError
                                           duration:2.0f
                               canBeDismissedByUser:YES];
    }
}

- (void)acknowledgements
{
    UIViewController *viewController = [VTAcknowledgementsViewController acknowledgementsViewController];
    [self.navigationController pushViewController:viewController
                                         animated:true];
}

#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    if (result == MFMailComposeResultSent) {
        [TSMessage showNotificationInViewController:self
                                              title:@"Success"
                                           subtitle:@"You have send me an email."
                                               type:TSMessageNotificationTypeSuccess
                                           duration:2.0f
                               canBeDismissedByUser:YES];
    }
    else if (result == MFMailComposeResultFailed) {
        [TSMessage showNotificationInViewController:self
                                              title:@"Error"
                                           subtitle:@"Something wrong happened. Try this later."
                                               type:TSMessageNotificationTypeError
                                           duration:2.0f
                               canBeDismissedByUser:YES];
    }
    [self dismissViewControllerAnimated:true
                             completion:nil];
}

@end
