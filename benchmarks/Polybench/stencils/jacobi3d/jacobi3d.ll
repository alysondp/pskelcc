; ModuleID = 'jacobi3d-base.ll'
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%struct._IO_FILE = type { i32, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, %struct._IO_marker*, %struct._IO_FILE*, i32, i32, i64, i16, i8, [1 x i8], i8*, i64, i8*, i8*, i8*, i8*, i64, i32, [20 x i8] }
%struct._IO_marker = type { %struct._IO_marker*, %struct._IO_FILE*, i32 }
%struct.timezone = type { i32, i32 }
%struct.timeval = type { i64, i64 }

@.str = private unnamed_addr constant [35 x i8] c"Error return from gettimeofday: %d\00", align 1
@.str.1 = private unnamed_addr constant [74 x i8] c"Non-Matching CPU-GPU Outputs Beyond Error Threshold of %4.2f Percent: %d\0A\00", align 1
@stdout = external global %struct._IO_FILE*, align 8
@.str.2 = private unnamed_addr constant [42 x i8] c">> Three dimensional (3D) convolution <<\0A\00", align 1
@.str.3 = private unnamed_addr constant [22 x i8] c"CPU Runtime: %0.6lfs\0A\00", align 1
@.str.4 = private unnamed_addr constant [22 x i8] c"GPU Runtime: %0.6lfs\0A\00", align 1

; Function Attrs: nounwind uwtable
define double @rtclock() #0 {
entry:
  %Tzp = alloca %struct.timezone, align 4
  %Tp = alloca %struct.timeval, align 8
  %call = call i32 @gettimeofday(%struct.timeval* %Tp, %struct.timezone* %Tzp) #3
  %cmp = icmp ne i32 %call, 0
  br i1 %cmp, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %call1 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([35 x i8], [35 x i8]* @.str, i32 0, i32 0), i32 %call)
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  %tv_sec = getelementptr inbounds %struct.timeval, %struct.timeval* %Tp, i32 0, i32 0
  %tmp = load i64, i64* %tv_sec, align 8
  %conv = sitofp i64 %tmp to double
  %tv_usec = getelementptr inbounds %struct.timeval, %struct.timeval* %Tp, i32 0, i32 1
  %tmp1 = load i64, i64* %tv_usec, align 8
  %conv2 = sitofp i64 %tmp1 to double
  %mul = fmul double %conv2, 1.000000e-06
  %add = fadd double %conv, %mul
  ret double %add
}

; Function Attrs: nounwind
declare i32 @gettimeofday(%struct.timeval*, %struct.timezone*) #1

declare i32 @printf(i8*, ...) #2

; Function Attrs: nounwind uwtable
define float @absVal(float %a) #0 {
entry:
  %cmp = fcmp olt float %a, 0.000000e+00
  br i1 %cmp, label %if.then, label %if.else

if.then:                                          ; preds = %entry
  %mul = fmul float %a, -1.000000e+00
  br label %return

if.else:                                          ; preds = %entry
  br label %return

return:                                           ; preds = %if.else, %if.then
  %retval.0 = phi float [ %mul, %if.then ], [ %a, %if.else ]
  ret float %retval.0
}

; Function Attrs: nounwind uwtable
define float @percentDiff(double %val1, double %val2) #0 {
entry:
  %conv = fptrunc double %val1 to float
  %call = call float @absVal(float %conv)
  %conv1 = fpext float %call to double
  %cmp = fcmp olt double %conv1, 1.000000e-02
  br i1 %cmp, label %land.lhs.true, label %if.else

land.lhs.true:                                    ; preds = %entry
  %conv3 = fptrunc double %val2 to float
  %call4 = call float @absVal(float %conv3)
  %conv5 = fpext float %call4 to double
  %cmp6 = fcmp olt double %conv5, 1.000000e-02
  br i1 %cmp6, label %if.then, label %if.else

if.then:                                          ; preds = %land.lhs.true
  br label %return

if.else:                                          ; preds = %land.lhs.true, %entry
  %sub = fsub double %val1, %val2
  %conv8 = fptrunc double %sub to float
  %call9 = call float @absVal(float %conv8)
  %add = fadd double %val1, 0x3E45798EE0000000
  %conv10 = fptrunc double %add to float
  %call11 = call float @absVal(float %conv10)
  %div = fdiv float %call9, %call11
  %call12 = call float @absVal(float %div)
  %mul = fmul float 1.000000e+02, %call12
  br label %return

return:                                           ; preds = %if.else, %if.then
  %retval.0 = phi float [ 0.000000e+00, %if.then ], [ %mul, %if.else ]
  ret float %retval.0
}

; Function Attrs: nounwind uwtable
define void @jacobi3d(i32 %tsteps, i32 %ni, i32 %nj, i32 %nk, float* %A, float* %B) #0 {
entry:
  br label %for.cond

for.cond:                                         ; preds = %for.inc.124, %entry
  %t.0 = phi i32 [ 0, %entry ], [ %inc125, %for.inc.124 ]
  %cmp = icmp slt i32 %t.0, %tsteps
  br i1 %cmp, label %for.body, label %for.end.126

for.body:                                         ; preds = %for.cond
  br label %for.cond.1

for.cond.1:                                       ; preds = %for.inc.86, %for.body
  %j.0 = phi i32 [ 1, %for.body ], [ %inc87, %for.inc.86 ]
  %sub = sub nsw i32 %nj, 1
  %cmp2 = icmp slt i32 %j.0, %sub
  br i1 %cmp2, label %for.body.3, label %for.end.88

for.body.3:                                       ; preds = %for.cond.1
  br label %for.cond.4

for.cond.4:                                       ; preds = %for.inc.83, %for.body.3
  %i.0 = phi i32 [ 1, %for.body.3 ], [ %inc84, %for.inc.83 ]
  %sub5 = sub nsw i32 %ni, 1
  %cmp6 = icmp slt i32 %i.0, %sub5
  br i1 %cmp6, label %for.body.7, label %for.end.85

for.body.7:                                       ; preds = %for.cond.4
  br label %for.cond.8

for.cond.8:                                       ; preds = %for.inc, %for.body.7
  %k.0 = phi i32 [ 1, %for.body.7 ], [ %inc, %for.inc ]
  %sub9 = sub nsw i32 %nk, 1
  %cmp10 = icmp slt i32 %k.0, %sub9
  br i1 %cmp10, label %for.body.11, label %for.end

for.body.11:                                      ; preds = %for.cond.8
  %mul = mul nsw i32 %nk, %nj
  %mul12 = mul nsw i32 %i.0, %mul
  %mul13 = mul nsw i32 %j.0, %nk
  %add = add nsw i32 %mul12, %mul13
  %sub14 = sub nsw i32 %k.0, 1
  %add15 = add nsw i32 %add, %sub14
  %idxprom = sext i32 %add15 to i64
  %arrayidx = getelementptr inbounds float, float* %A, i64 %idxprom
  %tmp = load float, float* %arrayidx, align 4
  %mul16 = fmul float 2.000000e+00, %tmp
  %mul17 = mul nsw i32 %nk, %nj
  %mul18 = mul nsw i32 %i.0, %mul17
  %mul19 = mul nsw i32 %j.0, %nk
  %add20 = add nsw i32 %mul18, %mul19
  %add21 = add nsw i32 %add20, %k.0
  %idxprom22 = sext i32 %add21 to i64
  %arrayidx23 = getelementptr inbounds float, float* %A, i64 %idxprom22
  %tmp1 = load float, float* %arrayidx23, align 4
  %mul24 = fmul float 5.000000e+00, %tmp1
  %add25 = fadd float %mul16, %mul24
  %mul26 = mul nsw i32 %nk, %nj
  %mul27 = mul nsw i32 %i.0, %mul26
  %mul28 = mul nsw i32 %j.0, %nk
  %add29 = add nsw i32 %mul27, %mul28
  %add30 = add nsw i32 %k.0, 1
  %add31 = add nsw i32 %add29, %add30
  %idxprom32 = sext i32 %add31 to i64
  %arrayidx33 = getelementptr inbounds float, float* %A, i64 %idxprom32
  %tmp2 = load float, float* %arrayidx33, align 4
  %mul34 = fmul float -8.000000e+00, %tmp2
  %add35 = fadd float %add25, %mul34
  %sub36 = sub nsw i32 %i.0, 1
  %mul37 = mul nsw i32 %nk, %nj
  %mul38 = mul nsw i32 %sub36, %mul37
  %mul39 = mul nsw i32 %j.0, %nk
  %add40 = add nsw i32 %mul38, %mul39
  %add41 = add nsw i32 %add40, %k.0
  %idxprom42 = sext i32 %add41 to i64
  %arrayidx43 = getelementptr inbounds float, float* %A, i64 %idxprom42
  %tmp3 = load float, float* %arrayidx43, align 4
  %mul44 = fmul float -3.000000e+00, %tmp3
  %add45 = fadd float %add35, %mul44
  %add46 = add nsw i32 %i.0, 1
  %mul47 = mul nsw i32 %nk, %nj
  %mul48 = mul nsw i32 %add46, %mul47
  %mul49 = mul nsw i32 %j.0, %nk
  %add50 = add nsw i32 %mul48, %mul49
  %add51 = add nsw i32 %add50, %k.0
  %idxprom52 = sext i32 %add51 to i64
  %arrayidx53 = getelementptr inbounds float, float* %A, i64 %idxprom52
  %tmp4 = load float, float* %arrayidx53, align 4
  %mul54 = fmul float 6.000000e+00, %tmp4
  %add55 = fadd float %add45, %mul54
  %mul56 = mul nsw i32 %nk, %nj
  %mul57 = mul nsw i32 %i.0, %mul56
  %sub58 = sub nsw i32 %j.0, 1
  %mul59 = mul nsw i32 %sub58, %nk
  %add60 = add nsw i32 %mul57, %mul59
  %add61 = add nsw i32 %add60, %k.0
  %idxprom62 = sext i32 %add61 to i64
  %arrayidx63 = getelementptr inbounds float, float* %A, i64 %idxprom62
  %tmp5 = load float, float* %arrayidx63, align 4
  %mul64 = fmul float -9.000000e+00, %tmp5
  %add65 = fadd float %add55, %mul64
  %mul66 = mul nsw i32 %nk, %nj
  %mul67 = mul nsw i32 %i.0, %mul66
  %add68 = add nsw i32 %j.0, 1
  %mul69 = mul nsw i32 %add68, %nk
  %add70 = add nsw i32 %mul67, %mul69
  %add71 = add nsw i32 %add70, %k.0
  %idxprom72 = sext i32 %add71 to i64
  %arrayidx73 = getelementptr inbounds float, float* %A, i64 %idxprom72
  %tmp6 = load float, float* %arrayidx73, align 4
  %mul74 = fmul float 4.000000e+00, %tmp6
  %add75 = fadd float %add65, %mul74
  %mul76 = mul nsw i32 %nk, %nj
  %mul77 = mul nsw i32 %i.0, %mul76
  %mul78 = mul nsw i32 %j.0, %nk
  %add79 = add nsw i32 %mul77, %mul78
  %add80 = add nsw i32 %add79, %k.0
  %idxprom81 = sext i32 %add80 to i64
  %arrayidx82 = getelementptr inbounds float, float* %B, i64 %idxprom81
  store float %add75, float* %arrayidx82, align 4
  br label %for.inc

for.inc:                                          ; preds = %for.body.11
  %inc = add nsw i32 %k.0, 1
  br label %for.cond.8

for.end:                                          ; preds = %for.cond.8
  br label %for.inc.83

for.inc.83:                                       ; preds = %for.end
  %inc84 = add nsw i32 %i.0, 1
  br label %for.cond.4

for.end.85:                                       ; preds = %for.cond.4
  br label %for.inc.86

for.inc.86:                                       ; preds = %for.end.85
  %inc87 = add nsw i32 %j.0, 1
  br label %for.cond.1

for.end.88:                                       ; preds = %for.cond.1
  br label %for.cond.89

for.cond.89:                                      ; preds = %for.inc.121, %for.end.88
  %j.1 = phi i32 [ 1, %for.end.88 ], [ %inc122, %for.inc.121 ]
  %sub90 = sub nsw i32 %nj, 1
  %cmp91 = icmp slt i32 %j.1, %sub90
  br i1 %cmp91, label %for.body.92, label %for.end.123

for.body.92:                                      ; preds = %for.cond.89
  br label %for.cond.93

for.cond.93:                                      ; preds = %for.inc.118, %for.body.92
  %i.1 = phi i32 [ 1, %for.body.92 ], [ %inc119, %for.inc.118 ]
  %sub94 = sub nsw i32 %ni, 1
  %cmp95 = icmp slt i32 %i.1, %sub94
  br i1 %cmp95, label %for.body.96, label %for.end.120

for.body.96:                                      ; preds = %for.cond.93
  br label %for.cond.97

for.cond.97:                                      ; preds = %for.inc.115, %for.body.96
  %k.1 = phi i32 [ 1, %for.body.96 ], [ %inc116, %for.inc.115 ]
  %sub98 = sub nsw i32 %nk, 1
  %cmp99 = icmp slt i32 %k.1, %sub98
  br i1 %cmp99, label %for.body.100, label %for.end.117

for.body.100:                                     ; preds = %for.cond.97
  %mul101 = mul nsw i32 %nk, %nj
  %mul102 = mul nsw i32 %i.1, %mul101
  %mul103 = mul nsw i32 %j.1, %nk
  %add104 = add nsw i32 %mul102, %mul103
  %add105 = add nsw i32 %add104, %k.1
  %idxprom106 = sext i32 %add105 to i64
  %arrayidx107 = getelementptr inbounds float, float* %B, i64 %idxprom106
  %tmp7 = load float, float* %arrayidx107, align 4
  %mul108 = mul nsw i32 %nk, %nj
  %mul109 = mul nsw i32 %i.1, %mul108
  %mul110 = mul nsw i32 %j.1, %nk
  %add111 = add nsw i32 %mul109, %mul110
  %add112 = add nsw i32 %add111, %k.1
  %idxprom113 = sext i32 %add112 to i64
  %arrayidx114 = getelementptr inbounds float, float* %A, i64 %idxprom113
  store float %tmp7, float* %arrayidx114, align 4
  br label %for.inc.115

for.inc.115:                                      ; preds = %for.body.100
  %inc116 = add nsw i32 %k.1, 1
  br label %for.cond.97

for.end.117:                                      ; preds = %for.cond.97
  br label %for.inc.118

for.inc.118:                                      ; preds = %for.end.117
  %inc119 = add nsw i32 %i.1, 1
  br label %for.cond.93

for.end.120:                                      ; preds = %for.cond.93
  br label %for.inc.121

for.inc.121:                                      ; preds = %for.end.120
  %inc122 = add nsw i32 %j.1, 1
  br label %for.cond.89

for.end.123:                                      ; preds = %for.cond.89
  br label %for.inc.124

for.inc.124:                                      ; preds = %for.end.123
  %inc125 = add nsw i32 %t.0, 1
  br label %for.cond

for.end.126:                                      ; preds = %for.cond
  ret void
}

; Function Attrs: nounwind uwtable
define void @init(float* %A) #0 {
entry:
  br label %for.cond

for.cond:                                         ; preds = %for.inc.18, %entry
  %i.0 = phi i32 [ 0, %entry ], [ %inc19, %for.inc.18 ]
  %cmp = icmp slt i32 %i.0, 2048
  br i1 %cmp, label %for.body, label %for.end.20

for.body:                                         ; preds = %for.cond
  br label %for.cond.1

for.cond.1:                                       ; preds = %for.inc.15, %for.body
  %j.0 = phi i32 [ 0, %for.body ], [ %inc16, %for.inc.15 ]
  %cmp2 = icmp slt i32 %j.0, 2048
  br i1 %cmp2, label %for.body.3, label %for.end.17

for.body.3:                                       ; preds = %for.cond.1
  br label %for.cond.4

for.cond.4:                                       ; preds = %for.inc, %for.body.3
  %k.0 = phi i32 [ 0, %for.body.3 ], [ %inc, %for.inc ]
  %cmp5 = icmp slt i32 %k.0, 2048
  br i1 %cmp5, label %for.body.6, label %for.end

for.body.6:                                       ; preds = %for.cond.4
  %rem = srem i32 %i.0, 12
  %rem7 = srem i32 %j.0, 7
  %mul = mul nsw i32 2, %rem7
  %add = add nsw i32 %rem, %mul
  %rem8 = srem i32 %k.0, 13
  %mul9 = mul nsw i32 3, %rem8
  %add10 = add nsw i32 %add, %mul9
  %conv = sitofp i32 %add10 to float
  %mul11 = mul nsw i32 %i.0, 4194304
  %mul12 = mul nsw i32 %j.0, 2048
  %add13 = add nsw i32 %mul11, %mul12
  %add14 = add nsw i32 %add13, %k.0
  %idxprom = sext i32 %add14 to i64
  %arrayidx = getelementptr inbounds float, float* %A, i64 %idxprom
  store float %conv, float* %arrayidx, align 4
  br label %for.inc

for.inc:                                          ; preds = %for.body.6
  %inc = add nsw i32 %k.0, 1
  br label %for.cond.4

for.end:                                          ; preds = %for.cond.4
  br label %for.inc.15

for.inc.15:                                       ; preds = %for.end
  %inc16 = add nsw i32 %j.0, 1
  br label %for.cond.1

for.end.17:                                       ; preds = %for.cond.1
  br label %for.inc.18

for.inc.18:                                       ; preds = %for.end.17
  %inc19 = add nsw i32 %i.0, 1
  br label %for.cond

for.end.20:                                       ; preds = %for.cond
  ret void
}

; Function Attrs: nounwind uwtable
define void @compareResults(float* %B, float* %B_GPU) #0 {
entry:
  br label %for.cond

for.cond:                                         ; preds = %for.inc.23, %entry
  %i.0 = phi i32 [ 1, %entry ], [ %inc24, %for.inc.23 ]
  %fail.0 = phi i32 [ 0, %entry ], [ %fail.1, %for.inc.23 ]
  %cmp = icmp slt i32 %i.0, 2047
  br i1 %cmp, label %for.body, label %for.end.25

for.body:                                         ; preds = %for.cond
  br label %for.cond.1

for.cond.1:                                       ; preds = %for.inc.20, %for.body
  %j.0 = phi i32 [ 1, %for.body ], [ %inc21, %for.inc.20 ]
  %fail.1 = phi i32 [ %fail.0, %for.body ], [ %fail.2, %for.inc.20 ]
  %cmp2 = icmp slt i32 %j.0, 2047
  br i1 %cmp2, label %for.body.3, label %for.end.22

for.body.3:                                       ; preds = %for.cond.1
  br label %for.cond.4

for.cond.4:                                       ; preds = %for.inc, %for.body.3
  %k.0 = phi i32 [ 1, %for.body.3 ], [ %inc19, %for.inc ]
  %fail.2 = phi i32 [ %fail.1, %for.body.3 ], [ %fail.3, %for.inc ]
  %cmp5 = icmp slt i32 %k.0, 2047
  br i1 %cmp5, label %for.body.6, label %for.end

for.body.6:                                       ; preds = %for.cond.4
  %mul = mul nsw i32 %i.0, 4194304
  %mul7 = mul nsw i32 %j.0, 2048
  %add = add nsw i32 %mul, %mul7
  %add8 = add nsw i32 %add, %k.0
  %idxprom = sext i32 %add8 to i64
  %arrayidx = getelementptr inbounds float, float* %B, i64 %idxprom
  %tmp = load float, float* %arrayidx, align 4
  %conv = fpext float %tmp to double
  %mul9 = mul nsw i32 %i.0, 4194304
  %mul10 = mul nsw i32 %j.0, 2048
  %add11 = add nsw i32 %mul9, %mul10
  %add12 = add nsw i32 %add11, %k.0
  %idxprom13 = sext i32 %add12 to i64
  %arrayidx14 = getelementptr inbounds float, float* %B_GPU, i64 %idxprom13
  %tmp1 = load float, float* %arrayidx14, align 4
  %conv15 = fpext float %tmp1 to double
  %call = call float @percentDiff(double %conv, double %conv15)
  %conv16 = fpext float %call to double
  %cmp17 = fcmp ogt double %conv16, 5.000000e-01
  br i1 %cmp17, label %if.then, label %if.end

if.then:                                          ; preds = %for.body.6
  %inc = add nsw i32 %fail.2, 1
  br label %if.end

if.end:                                           ; preds = %if.then, %for.body.6
  %fail.3 = phi i32 [ %inc, %if.then ], [ %fail.2, %for.body.6 ]
  br label %for.inc

for.inc:                                          ; preds = %if.end
  %inc19 = add nsw i32 %k.0, 1
  br label %for.cond.4

for.end:                                          ; preds = %for.cond.4
  br label %for.inc.20

for.inc.20:                                       ; preds = %for.end
  %inc21 = add nsw i32 %j.0, 1
  br label %for.cond.1

for.end.22:                                       ; preds = %for.cond.1
  br label %for.inc.23

for.inc.23:                                       ; preds = %for.end.22
  %inc24 = add nsw i32 %i.0, 1
  br label %for.cond

for.end.25:                                       ; preds = %for.cond
  %call26 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([74 x i8], [74 x i8]* @.str.1, i32 0, i32 0), double 5.000000e-01, i32 %fail.0)
  ret void
}

; Function Attrs: nounwind uwtable
define i32 @main(i32 %argc, i8** %argv) #0 {
entry:
  %call = call noalias i8* @malloc(i64 0) #3
  %tmp = bitcast i8* %call to float*
  %call1 = call noalias i8* @malloc(i64 0) #3
  %tmp1 = bitcast i8* %call1 to float*
  %tmp2 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8
  %call2 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %tmp2, i8* getelementptr inbounds ([42 x i8], [42 x i8]* @.str.2, i32 0, i32 0))
  call void @init(float* %tmp)
  %call3 = call double @rtclock()
  call void @jacobi3d(i32 5, i32 2048, i32 2048, i32 2048, float* %tmp, float* %tmp1)
  %call4 = call double @rtclock()
  %tmp3 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8
  %sub = fsub double %call4, %call3
  %call5 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %tmp3, i8* getelementptr inbounds ([22 x i8], [22 x i8]* @.str.3, i32 0, i32 0), double %sub)
  %call6 = call double @rtclock()
  %call7 = call i32 (i32, i32, i32, i32, float*, float*, ...) bitcast (i32 (...)* @jacobi3D_GPU_baseline to i32 (i32, i32, i32, i32, float*, float*, ...)*)(i32 5, i32 2048, i32 2048, i32 2048, float* %tmp, float* %tmp1)
  %call8 = call double @rtclock()
  %tmp4 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8
  %sub9 = fsub double %call8, %call6
  %call10 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %tmp4, i8* getelementptr inbounds ([22 x i8], [22 x i8]* @.str.4, i32 0, i32 0), double %sub9)
  %tmp5 = bitcast float* %tmp to i8*
  call void @free(i8* %tmp5) #3
  %tmp6 = bitcast float* %tmp1 to i8*
  call void @free(i8* %tmp6) #3
  ret i32 0
}

; Function Attrs: nounwind
declare noalias i8* @malloc(i64) #1

declare i32 @fprintf(%struct._IO_FILE*, i8*, ...) #2

declare i32 @jacobi3D_GPU_baseline(...) #2

; Function Attrs: nounwind
declare void @free(i8*) #1

attributes #0 = { nounwind uwtable "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+sse,+sse2" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+sse,+sse2" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #2 = { "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+sse,+sse2" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { nounwind }

!llvm.ident = !{!0}

!0 = !{!"clang version 3.7.1 (https://github.com/llvm-mirror/clang.git 0dbefa1b83eb90f7a06b5df5df254ce32be3db4b) (https://github.com/llvm-mirror/llvm.git 33c352b3eda89abc24e7511d9045fa2e499a42e3)"}
