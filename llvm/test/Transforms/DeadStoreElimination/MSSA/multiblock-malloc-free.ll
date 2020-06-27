; NOTE: Assertions have been autogenerated by utils/update_test_checks.py

; RUN: opt < %s -basic-aa -dse -enable-dse-memoryssa -S | FileCheck %s

target datalayout = "e-m:e-p:32:32-i64:64-v128:64:128-a:0:32-n32-S64"
declare void @unknown_func()
declare void @llvm.lifetime.start.p0i8(i64, i8* nocapture) nounwind
declare void @llvm.lifetime.end.p0i8(i64, i8* nocapture) nounwind
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* nocapture, i8* nocapture, i64, i1) nounwind
declare void @llvm.memset.p0i8.i64(i8* nocapture, i8, i64, i32, i1) nounwind

declare noalias i8* @calloc(i64, i64) #5
declare noalias i8* @malloc(i64) #0
declare noalias i8* @strdup(i8* nocapture readonly) #1
declare void @free(i8* nocapture) #2

define void @test16(i32* noalias %P) {
; CHECK-LABEL: @test16(
; CHECK-NEXT:    [[P2:%.*]] = bitcast i32* [[P:%.*]] to i8*
; CHECK-NEXT:    store i32 1, i32* [[P]]
; CHECK-NEXT:    br i1 true, label [[BB1:%.*]], label [[BB3:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    store i32 1, i32* [[P]]
; CHECK-NEXT:    br label [[BB3]]
; CHECK:       bb3:
; CHECK-NEXT:    call void @free(i8* [[P2]])
; CHECK-NEXT:    ret void
;
  %P2 = bitcast i32* %P to i8*
  store i32 1, i32* %P
  br i1 true, label %bb1, label %bb3
bb1:
  store i32 1, i32* %P
  br label %bb3
bb3:
  call void @free(i8* %P2)
  ret void
}


define void @test17(i32* noalias %P) {
; CHECK-LABEL: @test17(
; CHECK-NEXT:    [[P2:%.*]] = bitcast i32* [[P:%.*]] to i8*
; CHECK-NEXT:    store i32 1, i32* [[P]]
; CHECK-NEXT:    br i1 true, label [[BB1:%.*]], label [[BB3:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    call void @unknown_func()
; CHECK-NEXT:    store i32 1, i32* [[P]]
; CHECK-NEXT:    br label [[BB3]]
; CHECK:       bb3:
; CHECK-NEXT:    call void @free(i8* [[P2]])
; CHECK-NEXT:    ret void
;
  %P2 = bitcast i32* %P to i8*
  store i32 1, i32* %P
  br i1 true, label %bb1, label %bb3
bb1:
  call void @unknown_func()
  store i32 1, i32* %P
  br label %bb3
bb3:
  call void @free(i8* %P2)
  ret void
}

define void @test6(i32* noalias %P) {
; CHECK-LABEL: @test6(
; CHECK-NEXT:    br i1 true, label [[BB1:%.*]], label [[BB2:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    br label [[BB3:%.*]]
; CHECK:       bb2:
; CHECK-NEXT:    call void @unknown_func()
; CHECK-NEXT:    br label [[BB3]]
; CHECK:       bb3:
; CHECK-NEXT:    store i32 0, i32* [[P:%.*]]
; CHECK-NEXT:    ret void
;
  store i32 0, i32* %P
  br i1 true, label %bb1, label %bb2
bb1:
  br label %bb3
bb2:
  call void @unknown_func()
  br label %bb3
bb3:
  store i32 0, i32* %P
  ret void
}

define void @test19(i32* noalias %P) {
; CHECK-LABEL: @test19(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[ARRAYIDX0:%.*]] = getelementptr inbounds i32, i32* [[P:%.*]], i64 1
; CHECK-NEXT:    [[P3:%.*]] = bitcast i32* [[ARRAYIDX0]] to i8*
; CHECK-NEXT:    call void @llvm.memset.p0i8.i64(i8* align 4 [[P3]], i8 0, i64 28, i1 false)
; CHECK-NEXT:    br i1 true, label [[BB1:%.*]], label [[BB2:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    br label [[BB3:%.*]]
; CHECK:       bb2:
; CHECK-NEXT:    [[ARRAYIDX1:%.*]] = getelementptr inbounds i32, i32* [[P]], i64 1
; CHECK-NEXT:    store i32 1, i32* [[ARRAYIDX1]], align 4
; CHECK-NEXT:    br label [[BB3]]
; CHECK:       bb3:
; CHECK-NEXT:    ret void
;
entry:
  %arrayidx0 = getelementptr inbounds i32, i32* %P, i64 1
  %p3 = bitcast i32* %arrayidx0 to i8*
  call void @llvm.memset.p0i8.i64(i8* %p3, i8 0, i64 28, i32 4, i1 false)
  br i1 true, label %bb1, label %bb2
bb1:
  br label %bb3
bb2:
  %arrayidx1 = getelementptr inbounds i32, i32* %P, i64 1
  store i32 1, i32* %arrayidx1, align 4
  br label %bb3
bb3:
  ret void
}


define void @test20(i32* noalias %P) {
; CHECK-LABEL: @test20(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[ARRAYIDX0:%.*]] = getelementptr inbounds i32, i32* [[P:%.*]], i64 1
; CHECK-NEXT:    [[P3:%.*]] = bitcast i32* [[ARRAYIDX0]] to i8*
; CHECK-NEXT:    [[TMP0:%.*]] = getelementptr inbounds i8, i8* [[P3]], i64 4
; CHECK-NEXT:    call void @llvm.memset.p0i8.i64(i8* align 4 [[TMP0]], i8 0, i64 24, i1 false)
; CHECK-NEXT:    br i1 true, label [[BB1:%.*]], label [[BB2:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    br label [[BB3:%.*]]
; CHECK:       bb2:
; CHECK-NEXT:    br label [[BB3]]
; CHECK:       bb3:
; CHECK-NEXT:    [[ARRAYIDX1:%.*]] = getelementptr inbounds i32, i32* [[P]], i64 1
; CHECK-NEXT:    store i32 1, i32* [[ARRAYIDX1]], align 4
; CHECK-NEXT:    ret void
;
entry:
  %arrayidx0 = getelementptr inbounds i32, i32* %P, i64 1
  %p3 = bitcast i32* %arrayidx0 to i8*
  call void @llvm.memset.p0i8.i64(i8* %p3, i8 0, i64 28, i32 4, i1 false)
  br i1 true, label %bb1, label %bb2
bb1:
  br label %bb3
bb2:
  br label %bb3
bb3:
  %arrayidx1 = getelementptr inbounds i32, i32* %P, i64 1
  store i32 1, i32* %arrayidx1, align 4
  ret void
}


define i32 @test22(i32* %P, i32* noalias %Q, i32* %R) {
; CHECK-LABEL: @test22(
; CHECK-NEXT:    store i32 2, i32* [[P:%.*]]
; CHECK-NEXT:    store i32 3, i32* [[Q:%.*]]
; CHECK-NEXT:    [[L:%.*]] = load i32, i32* [[R:%.*]]
; CHECK-NEXT:    ret i32 [[L]]
;
  store i32 1, i32* %Q
  store i32 2, i32* %P
  store i32 3, i32* %Q
  %l = load i32, i32* %R
  ret i32 %l
}


define void @test23(i32* noalias %P) {
; CHECK-LABEL: @test23(
; CHECK-NEXT:    br i1 true, label [[BB1:%.*]], label [[BB2:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    br label [[BB3:%.*]]
; CHECK:       bb2:
; CHECK-NEXT:    call void @unknown_func()
; CHECK-NEXT:    br label [[BB3]]
; CHECK:       bb3:
; CHECK-NEXT:    store i32 0, i32* [[P:%.*]]
; CHECK-NEXT:    ret void
;
  br i1 true, label %bb1, label %bb2
bb1:
  store i32 0, i32* %P
  br label %bb3
bb2:
  call void @unknown_func()
  br label %bb3
bb3:
  store i32 0, i32* %P
  ret void
}


define void @test24(i32* noalias %P) {
; CHECK-LABEL: @test24(
; CHECK-NEXT:    br i1 true, label [[BB2:%.*]], label [[BB1:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    br label [[BB3:%.*]]
; CHECK:       bb2:
; CHECK-NEXT:    call void @unknown_func()
; CHECK-NEXT:    br label [[BB3]]
; CHECK:       bb3:
; CHECK-NEXT:    store i32 0, i32* [[P:%.*]]
; CHECK-NEXT:    ret void
;
  br i1 true, label %bb2, label %bb1
bb1:
  store i32 0, i32* %P
  br label %bb3
bb2:
  call void @unknown_func()
  br label %bb3
bb3:
  store i32 0, i32* %P
  ret void
}

define i8* @test26() {
; CHECK-LABEL: @test26(
; CHECK-NEXT:  bb1:
; CHECK-NEXT:    br i1 true, label [[BB2:%.*]], label [[BB3:%.*]]
; CHECK:       bb2:
; CHECK-NEXT:    [[M:%.*]] = call noalias i8* @malloc(i64 10)
; CHECK-NEXT:    store i8 1, i8* [[M]]
; CHECK-NEXT:    br label [[BB3]]
; CHECK:       bb3:
; CHECK-NEXT:    [[R:%.*]] = phi i8* [ null, [[BB1:%.*]] ], [ [[M]], [[BB2]] ]
; CHECK-NEXT:    ret i8* [[R]]
;
bb1:
  br i1 true, label %bb2, label %bb3
bb2:
  %m = call noalias i8* @malloc(i64 10)
  store i8 1, i8* %m
  br label %bb3
bb3:
  %r = phi i8* [ null, %bb1 ], [ %m, %bb2 ]
  ret i8* %r
}


define void @test27() {
; CHECK-LABEL: @test27(
; CHECK-NEXT:  bb1:
; CHECK-NEXT:    br i1 true, label [[BB2:%.*]], label [[BB3:%.*]]
; CHECK:       bb2:
; CHECK-NEXT:    [[M:%.*]] = call noalias i8* @malloc(i64 10)
; CHECK-NEXT:    br label [[BB3]]
; CHECK:       bb3:
; CHECK-NEXT:    [[R:%.*]] = phi i8* [ null, [[BB1:%.*]] ], [ [[M]], [[BB2]] ]
; CHECK-NEXT:    ret void
;
bb1:
  br i1 true, label %bb2, label %bb3
bb2:
  %m = call noalias i8* @malloc(i64 10)
  store i8 1, i8* %m
  br label %bb3
bb3:
  %r = phi i8* [ null, %bb1 ], [ %m, %bb2 ]
  ret void
}


define i8* @test28() {
; CHECK-LABEL: @test28(
; CHECK-NEXT:  bb0:
; CHECK-NEXT:    [[M:%.*]] = call noalias i8* @malloc(i64 10)
; CHECK-NEXT:    [[MC0:%.*]] = bitcast i8* [[M]] to i8*
; CHECK-NEXT:    [[MC1:%.*]] = bitcast i8* [[MC0]] to i8*
; CHECK-NEXT:    [[MC2:%.*]] = bitcast i8* [[MC1]] to i8*
; CHECK-NEXT:    [[MC3:%.*]] = bitcast i8* [[MC2]] to i8*
; CHECK-NEXT:    [[MC4:%.*]] = bitcast i8* [[MC3]] to i8*
; CHECK-NEXT:    [[MC5:%.*]] = bitcast i8* [[MC4]] to i8*
; CHECK-NEXT:    [[MC6:%.*]] = bitcast i8* [[MC5]] to i8*
; CHECK-NEXT:    [[M0:%.*]] = bitcast i8* [[MC6]] to i8*
; CHECK-NEXT:    store i8 2, i8* [[M]]
; CHECK-NEXT:    ret i8* [[M0]]
;
bb0:
  %m = call noalias i8* @malloc(i64 10)
  %mc0 = bitcast i8* %m to i8*
  %mc1 = bitcast i8* %mc0 to i8*
  %mc2 = bitcast i8* %mc1 to i8*
  %mc3 = bitcast i8* %mc2 to i8*
  %mc4 = bitcast i8* %mc3 to i8*
  %mc5 = bitcast i8* %mc4 to i8*
  %mc6 = bitcast i8* %mc5 to i8*
  %m0 = bitcast i8* %mc6 to i8*
  store i8 2, i8* %m
  ret i8* %m0
}

%struct.SystemCallMapElementStruct = type { i8*, i32, %struct.NodePtrVecStruct* }
%struct.NodePtrVecStruct = type { i32, i32, %struct.NodeStruct** }
%struct.NodeStruct = type { i32, i32, i8*, i32, i32, %struct.NodeStruct*, %struct.NodeListStruct*, %struct.EdgeListStruct*, i32, i32 }
%struct.NodeListStruct = type { %struct.NodeStruct*, %struct.NodeListStruct* }
%struct.EdgeListStruct = type { i32, %struct.NodeStruct*, %struct.EdgeListStruct* }
%struct.SystemCallMapStruct = type { i32, i32, %struct.SystemCallMapElementStruct** }

declare %struct.NodePtrVecStruct* @NodePtrVec_new(i32)

define noalias %struct.SystemCallMapElementStruct* @SystemCallMapElement_new(i8* nocapture readonly %label, i32 %initialSize) {
; CHECK-LABEL: @SystemCallMapElement_new(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CALL:%.*]] = tail call dereferenceable_or_null(24) i8* @malloc(i64 24) #6
; CHECK-NEXT:    [[TMP0:%.*]] = bitcast i8* [[CALL]] to %struct.SystemCallMapElementStruct*
; CHECK-NEXT:    [[TOBOOL:%.*]] = icmp eq i8* [[CALL]], null
; CHECK-NEXT:    br i1 [[TOBOOL]], label [[CLEANUP:%.*]], label [[IF_THEN:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    [[CALL1:%.*]] = tail call i8* @strdup(i8* [[LABEL:%.*]])
; CHECK-NEXT:    [[LABEL2:%.*]] = bitcast i8* [[CALL]] to i8**
; CHECK-NEXT:    store i8* [[CALL1]], i8** [[LABEL2]], align 8
; CHECK-NEXT:    [[INDEX:%.*]] = getelementptr inbounds i8, i8* [[CALL]], i64 8
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast i8* [[INDEX]] to i32*
; CHECK-NEXT:    store i32 -1, i32* [[TMP1]], align 8
; CHECK-NEXT:    [[TOBOOL4:%.*]] = icmp eq i8* [[CALL1]], null
; CHECK-NEXT:    br i1 [[TOBOOL4]], label [[IF_THEN5:%.*]], label [[IF_END:%.*]]
; CHECK:       if.then5:
; CHECK-NEXT:    tail call void @free(i8* nonnull [[CALL]])
; CHECK-NEXT:    br label [[CLEANUP]]
; CHECK:       if.end:
; CHECK-NEXT:    [[CALL6:%.*]] = tail call %struct.NodePtrVecStruct* @NodePtrVec_new(i32 [[INITIALSIZE:%.*]]) #4
; CHECK-NEXT:    [[NODES:%.*]] = getelementptr inbounds i8, i8* [[CALL]], i64 16
; CHECK-NEXT:    [[TMP2:%.*]] = bitcast i8* [[NODES]] to %struct.NodePtrVecStruct**
; CHECK-NEXT:    store %struct.NodePtrVecStruct* [[CALL6]], %struct.NodePtrVecStruct** [[TMP2]], align 8
; CHECK-NEXT:    [[TOBOOL8:%.*]] = icmp eq %struct.NodePtrVecStruct* [[CALL6]], null
; CHECK-NEXT:    br i1 [[TOBOOL8]], label [[IF_THEN9:%.*]], label [[CLEANUP]]
; CHECK:       if.then9:
; CHECK-NEXT:    tail call void @free(i8* nonnull [[CALL]])
; CHECK-NEXT:    br label [[CLEANUP]]
; CHECK:       cleanup:
; CHECK-NEXT:    [[RETVAL_0:%.*]] = phi %struct.SystemCallMapElementStruct* [ null, [[IF_THEN9]] ], [ null, [[IF_THEN5]] ], [ [[TMP0]], [[IF_END]] ], [ [[TMP0]], [[ENTRY:%.*]] ]
; CHECK-NEXT:    ret %struct.SystemCallMapElementStruct* [[RETVAL_0]]
;
entry:
  %call = tail call dereferenceable_or_null(24) i8* @malloc(i64 24) #4
  %0 = bitcast i8* %call to %struct.SystemCallMapElementStruct*
  %tobool = icmp eq i8* %call, null
  br i1 %tobool, label %cleanup, label %if.then

if.then:                                          ; preds = %entry
  %call1 = tail call i8* @strdup(i8* %label)
  %label2 = bitcast i8* %call to i8**
  store i8* %call1, i8** %label2, align 8
  %index = getelementptr inbounds i8, i8* %call, i64 8
  %1 = bitcast i8* %index to i32*
  store i32 -1, i32* %1, align 8
  %tobool4 = icmp eq i8* %call1, null
  br i1 %tobool4, label %if.then5, label %if.end

if.then5:                                         ; preds = %if.then
  tail call void @free(i8* nonnull %call)
  br label %cleanup

if.end:                                           ; preds = %if.then
  %call6 = tail call %struct.NodePtrVecStruct* @NodePtrVec_new(i32 %initialSize) #2
  %nodes = getelementptr inbounds i8, i8* %call, i64 16
  %2 = bitcast i8* %nodes to %struct.NodePtrVecStruct**
  store %struct.NodePtrVecStruct* %call6, %struct.NodePtrVecStruct** %2, align 8
  %tobool8 = icmp eq %struct.NodePtrVecStruct* %call6, null
  br i1 %tobool8, label %if.then9, label %cleanup

if.then9:                                         ; preds = %if.end
  tail call void @free(i8* nonnull %call)
  br label %cleanup

cleanup:                                          ; preds = %entry, %if.end, %if.then9, %if.then5
  %retval.0 = phi %struct.SystemCallMapElementStruct* [ null, %if.then9 ], [ null, %if.then5 ], [ %0, %if.end ], [ %0, %entry ]
  ret %struct.SystemCallMapElementStruct* %retval.0
}

%struct.BitfieldStruct = type { i32, i8* }

define noalias %struct.BitfieldStruct* @Bitfield_new(i32 %bitsNeeded) {
; CHECK-LABEL: @Bitfield_new(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CALL:%.*]] = tail call dereferenceable_or_null(16) i8* @malloc(i64 16) #6
; CHECK-NEXT:    [[TMP0:%.*]] = bitcast i8* [[CALL]] to %struct.BitfieldStruct*
; CHECK-NEXT:    [[TOBOOL:%.*]] = icmp eq i8* [[CALL]], null
; CHECK-NEXT:    br i1 [[TOBOOL]], label [[CLEANUP:%.*]], label [[IF_END:%.*]]
; CHECK:       if.end:
; CHECK-NEXT:    [[ADD:%.*]] = add nsw i32 [[BITSNEEDED:%.*]], 7
; CHECK-NEXT:    [[DIV:%.*]] = sdiv i32 [[ADD]], 8
; CHECK-NEXT:    [[CONV:%.*]] = sext i32 [[DIV]] to i64
; CHECK-NEXT:    [[CALL1:%.*]] = tail call i8* @calloc(i64 [[CONV]], i64 1) #7
; CHECK-NEXT:    [[BITFIELD:%.*]] = getelementptr inbounds i8, i8* [[CALL]], i64 8
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast i8* [[BITFIELD]] to i8**
; CHECK-NEXT:    store i8* [[CALL1]], i8** [[TMP1]], align 8
; CHECK-NEXT:    [[TOBOOL3:%.*]] = icmp eq i8* [[CALL1]], null
; CHECK-NEXT:    br i1 [[TOBOOL3]], label [[IF_THEN4:%.*]], label [[IF_END5:%.*]]
; CHECK:       if.then4:
; CHECK-NEXT:    tail call void @free(i8* nonnull [[CALL]])
; CHECK-NEXT:    br label [[CLEANUP]]
; CHECK:       if.end5:
; CHECK-NEXT:    [[BITSNEEDED6:%.*]] = bitcast i8* [[CALL]] to i32*
; CHECK-NEXT:    store i32 [[BITSNEEDED]], i32* [[BITSNEEDED6]], align 8
; CHECK-NEXT:    br label [[CLEANUP]]
; CHECK:       cleanup:
; CHECK-NEXT:    [[RETVAL_0:%.*]] = phi %struct.BitfieldStruct* [ [[TMP0]], [[IF_END5]] ], [ null, [[IF_THEN4]] ], [ null, [[ENTRY:%.*]] ]
; CHECK-NEXT:    ret %struct.BitfieldStruct* [[RETVAL_0]]
;
entry:
  %call = tail call dereferenceable_or_null(16) i8* @malloc(i64 16) #4
  %0 = bitcast i8* %call to %struct.BitfieldStruct*
  %tobool = icmp eq i8* %call, null
  br i1 %tobool, label %cleanup, label %if.end

if.end:                                           ; preds = %entry
  %add = add nsw i32 %bitsNeeded, 7
  %div = sdiv i32 %add, 8
  %conv = sext i32 %div to i64
  %call1 = tail call i8* @calloc(i64 %conv, i64 1) #3
  %bitfield = getelementptr inbounds i8, i8* %call, i64 8
  %1 = bitcast i8* %bitfield to i8**
  store i8* %call1, i8** %1, align 8
  %tobool3 = icmp eq i8* %call1, null
  br i1 %tobool3, label %if.then4, label %if.end5

if.then4:                                         ; preds = %if.end
  tail call void @free(i8* nonnull %call)
  br label %cleanup

if.end5:                                          ; preds = %if.end
  %bitsNeeded6 = bitcast i8* %call to i32*
  store i32 %bitsNeeded, i32* %bitsNeeded6, align 8
  br label %cleanup

cleanup:                                          ; preds = %entry, %if.end5, %if.then4
  %retval.0 = phi %struct.BitfieldStruct* [ %0, %if.end5 ], [ null, %if.then4 ], [ null, %entry ]
  ret %struct.BitfieldStruct* %retval.0
}

attributes #0 = { nofree nounwind allocsize(0) }
attributes #1 = { nofree nounwind }
attributes #2 = { nounwind }
attributes #3 = { allocsize(0,1) }
attributes #4 = { allocsize(0) }
attributes #5 = { nofree nounwind allocsize(0,1) }
