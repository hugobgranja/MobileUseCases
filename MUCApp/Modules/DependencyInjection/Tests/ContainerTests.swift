@testable import DependencyInjection
import Foundation
import Testing

struct Test {
    class TestObject {
        let dependency: TestDependency

        init(_ dependency: TestDependency) {
            self.dependency = dependency
        }
    }

    class TestDependency {
        init() {}
    }

    private let sut: Container = Container()

    @Test("Transient service registration and resolution")
    func testTransientService() {
        sut.register(TestDependency.self) { _ in
            return TestDependency()
        }

        sut.register(TestObject.self) { r in
            return TestObject(r.resolve(TestDependency.self))
        }

        let firstInstance = sut.resolve(TestObject.self)
        let secondInstance = sut.resolve(TestObject.self)

        #expect(firstInstance !== secondInstance)
    }

    @Test("Singleton service registration and resolution")
    func testSingletonService() {
        sut.register(TestDependency.self) { _ in
            return TestDependency()
        }

        sut.register(
            TestObject.self,
            lifetime: .singleton
        ) { r in
            return TestObject(r.resolve(TestDependency.self))
        }

        let firstInstance = sut.resolve(TestObject.self)
        let secondInstance = sut.resolve(TestObject.self)

        #expect(firstInstance === secondInstance)
    }

    @Test(
        "Weak service registration and resolution",
        .disabled("NSMapTable does not immediately release values")
    )
    func testWeakService() {
        sut.register(TestDependency.self) { _ in
            return TestDependency()
        }

        sut.register(
            TestObject.self,
            lifetime: .weak
        ) { r in
            return TestObject(r.resolve(TestDependency.self))
        }

        var firstInstance: TestObject? = sut.resolve(TestObject.self)
        var secondInstance: TestObject? = sut.resolve(TestObject.self)

        // Check that the same instances are returned
        #expect(firstInstance === secondInstance)

        // Simulate release of references
        firstInstance = nil
        secondInstance = nil

        #expect(throws: DIError.serviceNotFound) {
            try sut.resolveThrowing(TestObject.self)
        }
    }

    @Test("Auto registration")
    func testAutoRegister() throws {
        sut.autoRegister(TestDependency.self, using: TestDependency.init)
        sut.autoRegister(TestObject.self, using: TestObject.init)
        _ = try #require(try sut.resolveThrowing(TestObject.self))
    }

    @Test("ResolveThrowing an unregistered service should throw")
    func testResolvingUnregisteredService() {
        #expect(throws: DIError.serviceNotFound) {
            try sut.resolveThrowing(TestObject.self)
        }
    }
}
