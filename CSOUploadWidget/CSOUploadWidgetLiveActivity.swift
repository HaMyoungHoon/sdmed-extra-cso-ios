//
//  CSOUploadWidgetLiveActivity.swift
//  CSOUploadWidget
//
//  Created by 하명훈 on 4/21/25.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct CSOUploadWidgetLiveEntryView : View {
    var context: UploadAttributes.ContentState
    init(_ context: UploadAttributes.ContentState) {
        self.context = context
    }

    var body: some View {
        VStack {
            HStack {
                Text(context.title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 0)
                ProgressView(value: context.progress, total: 1)
                    .progressViewStyle(CircularProgressViewStyle())
                    .tint(.accentColor)
            }.frame(alignment: .top)
            Text(context.content)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 0)
            Spacer()
        }
        .padding()
        .activityBackgroundTint(Color.cyan)
        .activitySystemActionForegroundColor(Color.black)
    }
}

struct CSOUploadWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: UploadAttributes.self) { context in
            CSOUploadWidgetLiveEntryView(context.state)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    Text(context.state.title)
                }
                DynamicIslandExpandedRegion(.trailing) {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text(context.state.content)
                }
            } compactLeading: {
                Text(context.state.title)
            } compactTrailing: {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .tint(.accentColor)
            } minimal: {
                Text("⬇️")
            }
            .keylineTint(Color.red)
        }
    }
}

extension UploadAttributes {
    fileprivate static var preview: UploadAttributes {
        UploadAttributes(UUID().uuidString)
    }
}
extension UploadAttributes.ContentState {
    fileprivate static var sample1: UploadAttributes.ContentState {
        UploadAttributes.ContentState(0, "🚀 CSO Upload Widget", "Just uploaded!")
    }
    fileprivate static var sample2: UploadAttributes.ContentState {
        UploadAttributes.ContentState(0.25, "🚀 CSO Upload Widget", "Just uploaded!")
    }
    fileprivate static var sample3: UploadAttributes.ContentState {
        UploadAttributes.ContentState(0.5, "🚀 CSO Upload Widget", "Just uploaded!")
    }
    fileprivate static var sample4: UploadAttributes.ContentState {
        UploadAttributes.ContentState(0.75, "🚀 CSO Upload Widget", "Just uploaded!")
    }
    fileprivate static var sample5: UploadAttributes.ContentState {
        UploadAttributes.ContentState(1, "🚀 CSO Upload Widget", "Just uploaded!")
    }
}

#Preview("noti", as: .content, using: UploadAttributes.preview) {
    CSOUploadWidgetLiveActivity()
} contentStates: {
    UploadAttributes.ContentState.sample1
    UploadAttributes.ContentState.sample2
    UploadAttributes.ContentState.sample3
    UploadAttributes.ContentState.sample4
    UploadAttributes.ContentState.sample5
}
