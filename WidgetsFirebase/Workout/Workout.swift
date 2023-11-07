//
//  Workout.swift
//  Workout
//
//  Created by Balaji on 30/09/21.
//

import WidgetKit
import SwiftUI
import Intents
import Firebase

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {

        // Fetching Data from Firebase for Every 15 Mins...
        let date = Date()
        
        let nextUpdate = Calendar.current.date(byAdding: .minute, value: 15, to: date)!
        
        fetchFromDB { work in
                    
            let entry = SimpleEntry(date: date, configuration: configuration, workoutData: work)
            
            let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
            
            completion(timeline)
        }
    }
    
    // Firebase Data...
    func fetchFromDB(completion: @escaping (WorkoutModel)->()){
        
        // You can fetch the current user Data like...
        guard let _ = try? Auth.auth().getStoredUser(forAccessGroup: "\(teamID).com.kavsoft.WidgetsFirebase") else{
            completion(WorkoutModel(daysValue: [], maxValue: 0,error: "Please Login!"))
            return
        }
        
        let db = Firestore.firestore().collection("Workout").document("XrpO2ipFmJLxZB08dDZL")
        
        db.getDocument { snap, err in
            guard let doc = snap?.data() else{
                completion(WorkoutModel(daysValue: [], maxValue: 0,error: err?.localizedDescription ?? ""))
                return
            }
            
            let maxValue = doc["Max"] as? String ?? ""
            
            var daysValue: [Int] = []
            
            for index in 1...7{
                let day = doc["Day\(index)"] as? String ?? ""
                daysValue.append(Int(day) ?? 0)
            }
            
            completion(WorkoutModel(daysValue: daysValue, maxValue: Int(maxValue) ?? 0))
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
    var workoutData: WorkoutModel?
}

struct WorkoutEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        
        GeometryReader{proxy in
            
            ZStack{
                
                if let work = entry.workoutData{
                    
                    if work.error == ""{
                        
                        // Graph...
                        GraphView(work: work,size: proxy.size)
                    }
                    else{
                        // Showing Error
                        Text(work.error)
                            
                    }
                }
                else{
                    // Loading View...
                    Text("Fetching Data...")
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
        .padding(.horizontal)
        .padding(.vertical,8)
    }
    
    @ViewBuilder
    func GraphView(work: WorkoutModel,size: CGSize)->some View{
        
        // Graph...
        HStack(spacing: 10){
            
            // Colors
            let colors: [Color] = [.red,.blue,.green,.yellow,.purple,.pink]
            
            ForEach(work.daysValue,id: \.self){day in
                
                VStack{
                    
                    RoundedRectangle(cornerRadius: 8)
                        .fill(colors.randomElement()!)
                        .frame(height: CGFloat(day) / CGFloat(work.maxValue) * (size.height - 40))
                    
                    Text("\(day)")
                        .font(.caption.bold())
                        .frame(height: 40)
                }
                .frame(maxHeight: .infinity,alignment: .bottom)
            }
        }
    }
}

// WorkOut Model....
struct WorkoutModel: Identifiable{
    var id = UUID().uuidString
    var daysValue: [Int]
    var maxValue: Int
    var error: String = ""
}

@main
struct Workout: Widget {
    
    // Dont forget to enable key chain Sharing for widget....
    
    // Intializing Firebase....
    init(){
        FirebaseApp.configure()
        do{
        
            try Auth.auth().useUserAccessGroup("\(teamID).com.kavsoft.WidgetsFirebase")
        }
        catch{
            print(error.localizedDescription)
        }
    }
    
    let kind: String = "Workout"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            WorkoutEntryView(entry: entry)
        }
        .supportedFamilies([.systemLarge])
        .configurationDisplayName("Workout")
        .description("Workout Graph.")
    }
}

struct Workout_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
