import SwiftUI
import WatchKit
import Foundation
import HealthKit
import WatchConnectivity

public struct BeepTestTimerView: View {
    @State private var workoutSession: HKWorkoutSession?
    @State private var timer: Timer?
    @State private var countdownTimer: Timer?
    @State private var isRunning: Bool = false
    @State private var totalShuttlesCompleted: Int = 0
    @State private var totalElapsedTime: Int = 0
    @State private var levelElapsedTime: Int = 0
    @State private var countdownTime: Int = 0
    @State private var previousLevel: Int = 0

    let healthStore = HKHealthStore()
    let shuttlesPerLevel = [7, 8, 8, 9, 9, 10, 10, 11, 11, 11, 12, 12, 13, 13, 13, 14, 14, 15, 15, 16, 16]
    var prefixSum: [Int]{
        var runningSum = 0
        return shuttlesPerLevel.map { element in
            runningSum += element
            return runningSum
        }
    }
    public var body: some View {
        VStack {
            HStack() {
                VStack {
                    Text("Level").foregroundColor(.secondary)
                    Text("\(currentLevel)").font(.largeTitle).bold()
                }
                Spacer()
                VStack {
                    Text("VO2 Max").font(.footnote).foregroundColor(.secondary)
                    Text("\(v02MaxFormatted)").bold()
                    Text("\(totalElapsedTime)").bold() 
                }
                Spacer()
                VStack {
                    Text("Shuttle").foregroundColor(.secondary)
                    Text("\(currentShuttle)").font(.largeTitle).bold()
                }
            }
            Spacer()
            Button(action: {
                startCountdown()
            }) {
                Text(isRunning ? "Stop" : "Start")
                    .font(.title)
                    .padding()
            }.buttonStyle(.bordered).tint(isRunning ? .red : .green)

        }
    }
    
    var stageSpeed: Double {
        if(currentLevel == 1) {
            return 8.0
        }
        return (Double(currentLevel) - 1) * 0.5 + 8.5
    }
    
    var stageSpeedFormatted: String {
        return String(format: "%.1f", stageSpeed)
    }
                 
    var shuttleTime: Double {
        return Double(72) / Double(stageSpeed)
    }
    
    var numberOfShuttles: Int {
        return Int(stageSpeed * 0.9)
    }
    

    var v02Max: Double {
        return  18.043461 + (0.3689295 * Double(totalShuttlesCompleted)) + (-0.000349 * Double(totalShuttlesCompleted) * Double(totalShuttlesCompleted))
    }
    
    var v02MaxFormatted: String {
        return String(format:"%.1f", v02Max)
    }

    var currentLevel: Int {
        return LevelModel().getCurrentLevel(sumOfShuttles: prefixSum, totalShuttlesCompleted: totalShuttlesCompleted)
    }
    
    var currentShuttle: Int {
        return LevelModel().getCurrentShuttle(totalShuttlesCompleted: totalShuttlesCompleted, prefixSum: prefixSum, currentLevel: currentLevel)
    }
    
    func getStageSpeedForLevel(level: Int) -> Double {
        if(level == 1) {
            return 8.0
        }
        return (Double(level) - 1) * 0.5 + 8.5
    }
    
    func startCountdown() {
        isRunning.toggle()
        let interfaceDevice = WKInterfaceDevice.current()
        interfaceDevice.play(.start)

        if isRunning {
            countdownTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                if countdownTime > 0 {
                    countdownTime -= 1
                } else {
                    countdownTimer?.invalidate()
                    startWorkout()
                }
            }
        } else {
            interfaceDevice.play(.stop)
            totalElapsedTime = 0
            levelElapsedTime = 0
            countdownTime = 1
            timer?.invalidate()
            countdownTimer?.invalidate()
            totalShuttlesCompleted = 1
            workoutSession?.stopActivity(with: Date())
        }
      
    }
    
    func startWorkout() {
        guard HKHealthStore.isHealthDataAvailable() else {
            print("HealthKit is not available on this device.")
            return
        }

        let workoutConfiguration = HKWorkoutConfiguration()
        workoutConfiguration.activityType = .running
        workoutConfiguration.locationType = .outdoor
        do {
            workoutSession = try HKWorkoutSession(healthStore: healthStore, configuration: workoutConfiguration)
            workoutSession?.startActivity(with: Date())
            startTimer()
        } catch {
            print("Unable to start workout session. \(error.localizedDescription)")
        }
    }
    
    func startTimer() {
        let interfaceDevice = WKInterfaceDevice.current()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if self.currentLevel != self.previousLevel {
                self.levelElapsedTime = 0
                self.previousLevel = self.currentLevel
            }
            self.totalElapsedTime += 1
            self.levelElapsedTime += 1
            if self.levelElapsedTime % Int(self.shuttleTime) == 0 {
                self.totalShuttlesCompleted += 1
                interfaceDevice.play(.notification)
            }
            
        }
    }
}

struct LevelModel {
    func getCurrentLevel(sumOfShuttles: [Int], totalShuttlesCompleted: Int) -> Int {
        for (index, value) in sumOfShuttles.enumerated() {
            if(index < sumOfShuttles.count - 1) {
                let nextElement = sumOfShuttles[index + 1]
                if value <= totalShuttlesCompleted && totalShuttlesCompleted < nextElement {
                    return index + 2
                }
            }
        }
        return 1
        
    }
    
    func getCurrentShuttle(totalShuttlesCompleted: Int, prefixSum: [Int], currentLevel: Int) -> Int {
        if(currentLevel == 1) {
            return totalShuttlesCompleted
        }
        let shuttle = totalShuttlesCompleted - prefixSum[currentLevel - 2]
        return shuttle
    }
}

struct BeepTestTimerView_Previews: PreviewProvider {
    static var previews: some View {
        BeepTestTimerView()
    }
}

