//
//  PKEAboutViewController.m
//  Pokeffective
//
//  Created by Renzo Crisóstomo on 09/03/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import "PKEAboutViewController.h"
#import "PKEPokemonManager.h"
#import "PKEIAPHelper.h"
#import "iLink.h"

@interface PKEAboutViewController () <MFMailComposeViewControllerDelegate>

- (void)follow;
- (void)email;
- (void)acknowledgements;
- (void)shareOnFacebook;
- (void)shareOnTwitter;
- (void)rateOnAppStore;
- (void)onDidRestoreCompletedTransactionsNotification:(NSNotification *)notification;

@end

@implementation PKEAboutViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onDidRestoreCompletedTransactionsNotification:)
                                                     name:DidRestoreCompletedTransactionsNotification
                                                   object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:DidRestoreCompletedTransactionsNotification
                                                  object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Public Methods

- (IBAction)onTapExitButton:(id)sender
{
    [self dismissViewControllerWithFadebackAnimationCompletion:nil];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    if ([[PKEPokemonManager sharedManager] isIAPContentAvailable]) {
        if ([indexPath section] == 0 &&
            [indexPath row] == 0) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath
                                  animated:true];
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0: {
                if ([[PKEPokemonManager sharedManager] isIAPContentAvailable]) {
                    [TSMessage showNotificationInViewController:self
                                                          title:@"Success"
                                                       subtitle:@"This content is already restored and available."
                                                           type:TSMessageNotificationTypeSuccess
                                                       duration:3.0f
                                           canBeDismissedByUser:YES];
                }
                else {
                    [[PKEPokemonManager sharedManager] restoreCompletedTransactions];
                }
                break;
            }
        }
    }
    if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:
                [self shareOnFacebook];
                break;
            case 1:
                [self shareOnTwitter];
                break;
            case 2:
                [self rateOnAppStore];
                break;
        }
    }
    if (indexPath.section == 2) {
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
    else if (indexPath.section == 3) {
        switch (indexPath.row) {
            case 0:
                [self acknowledgements];
                break;
            case 1:
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/veekun/pokedex"]];
                break;
        }
    }
}

#pragma mark - Private Methods

- (void)shareOnFacebook
{
    SLComposeViewController *facebookStatus = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    [facebookStatus setInitialText:@"Check PokeApp in the AppStore!"];
    [facebookStatus addURL:[[iLink sharedInstance] iLinkGetAppURLforSharing]];
    [self presentViewController:facebookStatus
                       animated:YES
                     completion:nil];
}

- (void)shareOnTwitter
{
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    [accountStore requestAccessToAccountsWithType:accountType
                                          options:nil
                                       completion:^(BOOL granted, NSError *error) {
                                           if(granted) {
                                               NSArray *accounts = [accountStore accountsWithAccountType:accountType];
                                               if ([accounts count] > 0) {
                                                   SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
                                                   [tweetSheet setInitialText:@"Check PokeApp in the AppStore!"];
                                                   [tweetSheet addURL:[[iLink sharedInstance] iLinkGetAppURLforSharing]];
                                                   [self presentViewController:tweetSheet
                                                                      animated:YES
                                                                    completion:nil];
                                               }
                                               else {
                                                   dispatch_async(dispatch_get_main_queue(), ^{
                                                       [TSMessage showNotificationInViewController:self
                                                                                             title:@"Error"
                                                                                          subtitle:@"It seems that you don't have a Twitter account configured."
                                                                                              type:TSMessageNotificationTypeError
                                                                                          duration:3.0f
                                                                              canBeDismissedByUser:YES];
                                                   });
                                               }
        }
    }];
}

- (void)rateOnAppStore
{
    [[iLink sharedInstance] iLinkOpenRatingsPageInAppStore];
}

- (void)follow
{
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    [accountStore requestAccessToAccountsWithType:accountType
                                          options:nil
                                       completion:^(BOOL granted, NSError *error) {
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
                    @weakify(self);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        @strongify(self);
                        if ([urlResponse statusCode] == 200) {
                            [TSMessage showNotificationInViewController:self
                                                                  title:@"Success"
                                                               subtitle:@"You're now following me on Twitter."
                                                                   type:TSMessageNotificationTypeSuccess
                                                               duration:3.0f
                                                   canBeDismissedByUser:YES];
                        }
                        else {
                            [TSMessage showNotificationInViewController:self
                                                                  title:@"Error"
                                                               subtitle:@"Something wrong happened. Try this later."
                                                                   type:TSMessageNotificationTypeError
                                                               duration:3.0f
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
                                                       duration:3.0f
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
                                           duration:3.0f
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
                                           duration:3.0f
                               canBeDismissedByUser:YES];
    }
    else if (result == MFMailComposeResultFailed) {
        [TSMessage showNotificationInViewController:self
                                              title:@"Error"
                                           subtitle:@"Something wrong happened. Try this later."
                                               type:TSMessageNotificationTypeError
                                           duration:3.0f
                               canBeDismissedByUser:YES];
    }
    [self dismissViewControllerAnimated:true
                             completion:nil];
}

#pragma mark - NSNotificationCenter

- (void)onDidRestoreCompletedTransactionsNotification:(NSNotification *)notification
{
    [[self tableView] reloadData];
}

@end
