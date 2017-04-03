import Quick
import Nimble
@testable import Jogger

struct SnapshotStub: AnyChildrenEnumerable {
    var children: NSEnumerator
}

struct SnapshotValueStub: AnyKeyValueContainable {
    var value: Any?
    var key: String
    
}

class FirebaseMapperSpec: QuickSpec {
    override func spec() {
        describe("mapping records") {
            context("from json file", { 
                it("should return 2 record objects", closure: {
                    let jsonURL = Bundle(for: FirebaseMapperSpec.self).url(forResource: "records", withExtension: "json")!
                    let arrayJSON = try! JSONSerialization.jsonObject(with: try! Data.init(contentsOf: jsonURL), options: JSONSerialization.ReadingOptions.allowFragments) as! [[String : Any]]
                    let json = arrayJSON.map { SnapshotValueStub(value: $0, key: "id") }
                    let firebaseMapper = FirebaseMapper()
                    let snapshot = SnapshotStub(children: NSArray(array: json).objectEnumerator())
                    
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
