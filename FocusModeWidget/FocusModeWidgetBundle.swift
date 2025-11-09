//
//  FocusModeWidgetBundle.swift
//  FocusModeWidget
//
//  Created by Tejeshwer Singh on 09/11/25.
//

import WidgetKit
import SwiftUI

@main
struct FocusModeWidgetBundle: WidgetBundle {
    var body: some Widget {
        FocusModeWidget()
        FocusModeWidgetControl()
        FocusModeWidgetLiveActivity()
    }
}
