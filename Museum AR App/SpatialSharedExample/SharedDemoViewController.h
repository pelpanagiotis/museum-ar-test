//
//  SharedDemoViewController.h
//  Museum AR App
//
//  Created by Panos Peltekis on 9/12/20.
//  Copyright © 2020 Panos Peltekis. All rights reserved.
//

#import "BaseViewController.h"

@interface SharedDemoViewController : BaseViewController <UITextFieldDelegate>
{
    UIButton *_secondaryButton;
    UITextField *_textEntryControl;
    UITextField *_lastTextField;
}
@end
