// RUN: %target-swift-frontend -primary-file %s -emit-ir -enable-experimental-concurrency | %FileCheck %s --check-prefix=CHECK --check-prefix=CHECK-%target-ptrsize

// REQUIRES: concurrency

// CHECK: "$s5async1fyyYF"
public func f() async { }

// CHECK: "$s5async1gyyYKF"
public func g() async throws { }

// CHECK: "$s5async1hyyS2iJXEF"
public func h(_: @concurrent (Int) -> Int) { }

public class SomeClass {}

@_silgen_name("swift_task_future_wait")
public func task_future_wait(_ task: __owned SomeClass) async throws -> Int

// CHECK: define{{.*}} swift{{(tail)?}}cc void @"$s5async8testThisyyAA9SomeClassCnYF"(%swift.task* %0, %swift.executor* %1, %swift.context* swiftasync %2)
// CHECK-64: call swiftcc i8* @swift_task_alloc(%swift.task* %{{[0-9]+}}, i64 64)
// CHECK: {{(must)?}}tail call swift{{(tail)?}}cc void @swift_task_future_wait(
public func testThis(_ task: __owned SomeClass) async {
  do {
    let _ = try await task_future_wait(task)
  } catch _ {
    print("error")
  }
}
