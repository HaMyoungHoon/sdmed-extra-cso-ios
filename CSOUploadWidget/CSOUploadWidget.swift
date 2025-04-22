//
//  CSOUploadWidget.swift
//  CSOUploadWidget
//
//  Created by 하명훈 on 4/21/25.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct CSOUploadWidgetEntry: TimelineEntry {
    let date: Date
    let state: UploadAttributes.ContentState
    init(_ date: Date, _ entry: UploadAttributes.ContentState) {
        self.date = date
        self.state = entry
    }
}
struct CSOUploadWidgetProvider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> CSOUploadWidgetEntry {
        CSOUploadWidgetEntry(Date(), UploadAttributes.ContentState(0, "placeholder", "content"))
    }
    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> CSOUploadWidgetEntry {
        CSOUploadWidgetEntry(Date(), UploadAttributes.ContentState(0, "snapshot", "content"))
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<CSOUploadWidgetEntry> {
        var entries: [CSOUploadWidgetEntry] = []
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = CSOUploadWidgetEntry(entryDate, UploadAttributes.ContentState(0, "snapshot", "content"))
            entries.append(entry)
        }

        return Timeline(entries: entries, policy: .atEnd)
    }
}
struct CSOUploadWidgetEntryView : View {
    var context: CSOUploadWidgetProvider.Entry
    init(_ context: CSOUploadWidgetProvider.Entry) {
        self.context = context
    }

    var body: some View {
        VStack {
            HStack {
                Text(context.state.title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 0)
                ProgressView(value: context.state.progress, total: 1)
                    .progressViewStyle(CircularProgressViewStyle())
                    .tint(.accentColor)
                    .scaleEffect(0.5)
                    .padding(0)
            }.frame(alignment: .top)
            Text(context.state.content)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 0)
            Spacer()
        }
        .padding(0)
    }
}

struct CSOUploadWidget: Widget {
    let kind: String = "CSOUploadWidget"
    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: CSOUploadWidgetProvider()) { context in
            CSOUploadWidgetEntryView(context)
                .containerBackground(.fill.tertiary, for: .widget)
        }
    }
}


#Preview(as: .systemSmall) {
    CSOUploadWidget()
} timeline: {
    CSOUploadWidgetEntry(Date(), UploadAttributes.ContentState(0, "timeline", "content"))
}
