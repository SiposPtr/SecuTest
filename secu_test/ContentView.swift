//
//  ContentView.swift
//  secu_test
//
//  Created by Péter Sipos on 2025. 07. 21..
//

import SwiftUI
import IOSSecuritySuite

struct SecurityCheck: Identifiable {
    let id = UUID()
    let title: String
    let passed: Bool
}

struct ContentView: View {
    @State private var results: [SecurityCheck] = []
    @State private var isPresented: Bool = false

    var body: some View {
        NavigationView {
            List(results) { result in
                HStack {
                    Text(result.title)
                    Spacer()
                    Text(result.passed ? "✅" : "🚨")
                }
            }
            .navigationTitle("iOS Security Checks")
            .onAppear {
                runSecurityChecks()
            }
            .toolbar {
                // Leading button
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isPresented = true
                        runSecurityChecks()
                        isPresented = false
                    } label: {
                        Image(systemName: "arrow.clockwise")
                    }

                }
            }

        }
    }
    
    func runSecurityChecks() {
        var tempResults: [SecurityCheck] = []
        
        // Jailbreak
        let jb = IOSSecuritySuite.amIJailbrokenWithFailMessage()
        tempResults.append(SecurityCheck(title: "Jailbreak Detection", passed: !jb.jailbroken))
        // Debugger
        IOSSecuritySuite.denyDebugger()
        tempResults.append(SecurityCheck(title: "Debugger Detection", passed: !IOSSecuritySuite.amIDebugged()))
        
        // Emulator
        tempResults.append(SecurityCheck(title: "Emulator Detection", passed: !IOSSecuritySuite.amIRunInEmulator()))
        
        // Reverse Engineering
        tempResults.append(SecurityCheck(title: "Reverse Engineering", passed: !IOSSecuritySuite.amIReverseEngineered()))
        
        // Proxy
        tempResults.append(SecurityCheck(title: "Proxy Detection", passed: !IOSSecuritySuite.amIProxied()))
        
        // Lockdown Mode
        tempResults.append(SecurityCheck(title: "Lockdown Mode", passed: !IOSSecuritySuite.amIInLockdownMode()))
        
        
        // Tampering (dummy values – update these!)
        let tampering = IOSSecuritySuite.amITampered([
            .bundleID("sipos.secu-test2"),
            .mobileProvision("2482f5fb830070b46f471cd00a59081960ffb999048ab3af57fbb23787a4f04d"),
            .machO("YourApp", "81c5d9214ccf9a1569919cc2ed2bfcdcd33b5edd3312ac33c4c4ffa7e1ebe708")
        ])
        tempResults.append(SecurityCheck(title: "Tampering Check", passed: !tampering.result))
        
        // Breakpoint
        func testFunc() {}
        typealias TestFuncType = @convention(thin) () -> ()
        let funcAddr = unsafeBitCast(testFunc as TestFuncType, to: UnsafeMutableRawPointer.self)
        let hasBp = IOSSecuritySuite.hasBreakpointAt(funcAddr, functionSize: nil)
        tempResults.append(SecurityCheck(title: "Breakpoint Detection", passed: !hasBp))
        
        // Watchpoint
        let hasWatchpoint = IOSSecuritySuite.hasWatchpoint()
        tempResults.append(SecurityCheck(title: "Watchpoint Detection", passed: !hasWatchpoint))
        
        // Apply results to UI
        results = tempResults
    }
}


#Preview {
    ContentView()
}
