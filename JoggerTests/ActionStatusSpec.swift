import Quick
import Nimble
import ReactiveSwift
import Result
@testable import Jogger

class ActionStatusSpec: QuickSpec {
    override func spec() {
        describe("action status") { 
            it("sends loading once started", closure: {
                let never = SignalProducer<(),NoError>.never
                var status: ActionStatus<NoError> = .none
                never.on(statusChanged: { (s: ActionStatus<NoError>) in
                    status = s
                }).start()
                expect(status.isLoading).toEventually(beTrue())
            })
            
            context("producer returns error", { 
                it("sends action status with error", closure: {
                    let never = SignalProducer<(), NSError>.init(error: NSError.unknownError())
                    var status: ActionStatus<NSError> = .none
                    never.on(statusChanged: { (s: ActionStatus<NSError>) in
                        status = s
                    }).start()
                    expect(status.error).toNotEventually(beNil())
                    expect(status.error?.code).toEventually(equal(NSError.unknownError().code))
                })
            })
            
            context("producer returns data", {
                it("sends action status with data", closure: {
                    let never = SignalProducer<Int,NoError>.empty
                    var status: ActionStatus<NoError> = .none
                    never.on(statusChanged: { (s: ActionStatus<NoError>) in
                        status = s
                    }).start()
                    expect(status.completed).toEventually(beTrue())
                })
            })
        }
    }
}
