//
//  AppIntent.swift
//  extra.cso.ios
//
//  Created by 하명훈 on 4/21/25.
//

import Foundation
import WidgetKit
import AppIntents

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource { "Configuration" }
    static var description: IntentDescription { "description" }
    
    @Parameter(title: "content", default: "")
    var content: String
}
