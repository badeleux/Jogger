import Quick
import Nimble
@testable import Jogger

struct SnapshotStub: AnyValueContainable {
    let value: Any?
}

class FirebaseMapperSpec: QuickSpec {
    override func spec() {
        describe("mapping records") {
            context("from json file", { 
                it("should return 2 record objects", closure: {
                    let jsonURL = Bundle(for: FirebaseMapperSpec.self).url(forResource: "records", withExtension: "json")!
                    let json = try! JSONSerialization.jsonObject(with: try! Data.init(contentsOf: jsonURL), options: JSONSerialization.ReadingOptions.allowFragments)
                    let firebaseMapper = FirebaseMapper()
                    let snapshot = SnapshotStub(value: json)
                    
                    let recordResults = firebaseMapper.mapToArray(data: snapshot, toArrayWith: Record.self)
                    expect(recordResults.error).to(beNil())
                    expect(recordResults.value).toNot(beNil())
                    expect(recordResults.value!).to(haveCount(2))
                    recordResults.value?.forEach { r in
                        expect(r.date).toNot(beNil())
                        expect(r.distance).toNot(equal(0.0))
                        expect(r.time).toNot(equal(0.0))
                    }
                })
            })
        }
    }
}
