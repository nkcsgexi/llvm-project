// RUN: mlir-opt -spirv-lower-abi-attrs -verify-diagnostics %s -o - | FileCheck %s

module attributes {
  spv.target_env = #spv.target_env<
    #spv.vce<v1.0, [Kernel, Addresses], []>,
    {max_compute_workgroup_invocations = 128 : i32,
     max_compute_workgroup_size = dense<[128, 128, 64]> : vector<3xi32>}>
} {
  spv.module Physical64 OpenCL {
    // CHECK-LABEL: spv.module
    //       CHECK:   spv.func [[FN:@.*]](
    //  CHECK-SAME:     {{%.*}}: f32
    //  CHECK-SAME:     {{%.*}}: !spv.ptr<!spv.struct<!spv.array<12 x f32>>, CrossWorkgroup>
    //       CHECK:   spv.EntryPoint "Kernel" [[FN]]
    //       CHECK:   spv.ExecutionMode [[FN]] "LocalSize", 32, 1, 1
    spv.func @kernel(
      %arg0: f32,
      %arg1: !spv.ptr<!spv.struct<!spv.array<12 x f32>>, CrossWorkgroup>) "None"
    attributes {spv.entry_point_abi = {local_size = dense<[32, 1, 1]> : vector<3xi32>}} {
      spv.Return
    }
  }
}
