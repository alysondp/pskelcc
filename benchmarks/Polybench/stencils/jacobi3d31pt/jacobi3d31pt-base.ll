; ModuleID = 'jacobi3d31pt.c'
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%struct._IO_FILE = type { i32, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, %struct._IO_marker*, %struct._IO_FILE*, i32, i32, i64, i16, i8, [1 x i8], i8*, i64, i8*, i8*, i8*, i8*, i64, i32, [20 x i8] }
%struct._IO_marker = type { %struct._IO_marker*, %struct._IO_FILE*, i32 }
%struct.timezone = type { i32, i32 }
%struct.timeval = type { i64, i64 }

@.str = private unnamed_addr constant [35 x i8] c"Error return from gettimeofday: %d\00", align 1
@.str.1 = private unnamed_addr constant [51 x i8] c"Expected: %f, received: %f at position [%d,%d,%d]\0A\00", align 1
@.str.2 = private unnamed_addr constant [74 x i8] c"Non-Matching CPU-GPU Outputs Beyond Error Threshold of %4.2f Percent: %d\0A\00", align 1
@stdout = external global %struct._IO_FILE*, align 8
@.str.3 = private unnamed_addr constant [29 x i8] c">> 3D 7PT Jacobi Stencil <<\0A\00", align 1
@.str.4 = private unnamed_addr constant [22 x i8] c"CPU Runtime: %0.6lfs\0A\00", align 1

; Function Attrs: nounwind uwtable
define double @rtclock() #0 {
entry:
  %Tzp = alloca %struct.timezone, align 4
  %Tp = alloca %struct.timeval, align 8
  %stat = alloca i32, align 4
  %call = call i32 @gettimeofday(%struct.timeval* %Tp, %struct.timezone* %Tzp) #3
  store i32 %call, i32* %stat, align 4
  %0 = load i32, i32* %stat, align 4
  %cmp = icmp ne i32 %0, 0
  br i1 %cmp, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %1 = load i32, i32* %stat, align 4
  %call1 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([35 x i8], [35 x i8]* @.str, i32 0, i32 0), i32 %1)
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  %tv_sec = getelementptr inbounds %struct.timeval, %struct.timeval* %Tp, i32 0, i32 0
  %2 = load i64, i64* %tv_sec, align 8
  %conv = sitofp i64 %2 to double
  %tv_usec = getelementptr inbounds %struct.timeval, %struct.timeval* %Tp, i32 0, i32 1
  %3 = load i64, i64* %tv_usec, align 8
  %conv2 = sitofp i64 %3 to double
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
  %retval = alloca float, align 4
  %a.addr = alloca float, align 4
  store float %a, float* %a.addr, align 4
  %0 = load float, float* %a.addr, align 4
  %cmp = fcmp olt float %0, 0.000000e+00
  br i1 %cmp, label %if.then, label %if.else

if.then:                                          ; preds = %entry
  %1 = load float, float* %a.addr, align 4
  %mul = fmul float %1, -1.000000e+00
  store float %mul, float* %retval
  br label %return

if.else:                                          ; preds = %entry
  %2 = load float, float* %a.addr, align 4
  store float %2, float* %retval
  br label %return

return:                                           ; preds = %if.else, %if.then
  %3 = load float, float* %retval
  ret float %3
}

; Function Attrs: nounwind uwtable
define float @percentDiff(double %val1, double %val2) #0 {
entry:
  %retval = alloca float, align 4
  %val1.addr = alloca double, align 8
  %val2.addr = alloca double, align 8
  store double %val1, double* %val1.addr, align 8
  store double %val2, double* %val2.addr, align 8
  %0 = load double, double* %val1.addr, align 8
  %conv = fptrunc double %0 to float
  %call = call float @absVal(float %conv)
  %conv1 = fpext float %call to double
  %cmp = fcmp olt double %conv1, 1.000000e-02
  br i1 %cmp, label %land.lhs.true, label %if.else

land.lhs.true:                                    ; preds = %entry
  %1 = load double, double* %val2.addr, align 8
  %conv3 = fptrunc double %1 to float
  %call4 = call float @absVal(float %conv3)
  %conv5 = fpext float %call4 to double
  %cmp6 = fcmp olt double %conv5, 1.000000e-02
  br i1 %cmp6, label %if.then, label %if.else

if.then:                                          ; preds = %land.lhs.true
  store float 0.000000e+00, float* %retval
  br label %return

if.else:                                          ; preds = %land.lhs.true, %entry
  %2 = load double, double* %val1.addr, align 8
  %3 = load double, double* %val2.addr, align 8
  %sub = fsub double %2, %3
  %conv8 = fptrunc double %sub to float
  %call9 = call float @absVal(float %conv8)
  %4 = load double, double* %val1.addr, align 8
  %add = fadd double %4, 0x3E45798EE0000000
  %conv10 = fptrunc double %add to float
  %call11 = call float @absVal(float %conv10)
  %div = fdiv float %call9, %call11
  %call12 = call float @absVal(float %div)
  %mul = fmul float 1.000000e+02, %call12
  store float %mul, float* %retval
  br label %return

return:                                           ; preds = %if.else, %if.then
  %5 = load float, float* %retval
  ret float %5
}

; Function Attrs: nounwind uwtable
define void @jacobi3d31pt(i32 %tsteps, i32 %x, i32 %y, i32 %z, float* %A, float* %B) #0 {
entry:
  %tsteps.addr = alloca i32, align 4
  %x.addr = alloca i32, align 4
  %y.addr = alloca i32, align 4
  %z.addr = alloca i32, align 4
  %A.addr = alloca float*, align 8
  %B.addr = alloca float*, align 8
  %t = alloca i32, align 4
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  %k = alloca i32, align 4
  %c0 = alloca float, align 4
  %c1 = alloca float, align 4
  %c2 = alloca float, align 4
  %c3 = alloca float, align 4
  %c4 = alloca float, align 4
  %c5 = alloca float, align 4
  %c6 = alloca float, align 4
  store i32 %tsteps, i32* %tsteps.addr, align 4
  store i32 %x, i32* %x.addr, align 4
  store i32 %y, i32* %y.addr, align 4
  store i32 %z, i32* %z.addr, align 4
  store float* %A, float** %A.addr, align 8
  store float* %B, float** %B.addr, align 8
  store float 0x3FC99999A0000000, float* %c0, align 4
  store float 2.000000e+00, float* %c1, align 4
  store float 0x3FC99999A0000000, float* %c2, align 4
  store float 2.000000e+00, float* %c3, align 4
  store float 0x3FC99999A0000000, float* %c4, align 4
  store float 2.000000e+00, float* %c5, align 4
  store float 0x3FC99999A0000000, float* %c6, align 4
  store i32 0, i32* %t, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc.364, %entry
  %0 = load i32, i32* %t, align 4
  %1 = load i32, i32* %tsteps.addr, align 4
  %cmp = icmp slt i32 %0, %1
  br i1 %cmp, label %for.body, label %for.end.366

for.body:                                         ; preds = %for.cond
  store i32 5, i32* %i, align 4
  br label %for.cond.1

for.cond.1:                                       ; preds = %for.inc.326, %for.body
  %2 = load i32, i32* %i, align 4
  %3 = load i32, i32* %z.addr, align 4
  %sub = sub nsw i32 %3, 5
  %cmp2 = icmp slt i32 %2, %sub
  br i1 %cmp2, label %for.body.3, label %for.end.328

for.body.3:                                       ; preds = %for.cond.1
  store i32 5, i32* %j, align 4
  br label %for.cond.4

for.cond.4:                                       ; preds = %for.inc.323, %for.body.3
  %4 = load i32, i32* %j, align 4
  %5 = load i32, i32* %y.addr, align 4
  %sub5 = sub nsw i32 %5, 5
  %cmp6 = icmp slt i32 %4, %sub5
  br i1 %cmp6, label %for.body.7, label %for.end.325

for.body.7:                                       ; preds = %for.cond.4
  store i32 5, i32* %k, align 4
  br label %for.cond.8

for.cond.8:                                       ; preds = %for.inc, %for.body.7
  %6 = load i32, i32* %k, align 4
  %7 = load i32, i32* %x.addr, align 4
  %sub9 = sub nsw i32 %7, 5
  %cmp10 = icmp slt i32 %6, %sub9
  br i1 %cmp10, label %for.body.11, label %for.end

for.body.11:                                      ; preds = %for.cond.8
  %8 = load float, float* %c0, align 4
  %9 = load i32, i32* %i, align 4
  %add = add nsw i32 %9, 5
  %10 = load i32, i32* %x.addr, align 4
  %11 = load i32, i32* %y.addr, align 4
  %mul = mul nsw i32 %10, %11
  %mul12 = mul nsw i32 %add, %mul
  %12 = load i32, i32* %j, align 4
  %13 = load i32, i32* %x.addr, align 4
  %mul13 = mul nsw i32 %12, %13
  %add14 = add nsw i32 %mul12, %mul13
  %14 = load i32, i32* %k, align 4
  %add15 = add nsw i32 %add14, %14
  %idxprom = sext i32 %add15 to i64
  %15 = load float*, float** %A.addr, align 8
  %arrayidx = getelementptr inbounds float, float* %15, i64 %idxprom
  %16 = load float, float* %arrayidx, align 4
  %mul16 = fmul float %8, %16
  %17 = load float, float* %c1, align 4
  %18 = load i32, i32* %i, align 4
  %sub17 = sub nsw i32 %18, 5
  %19 = load i32, i32* %x.addr, align 4
  %20 = load i32, i32* %y.addr, align 4
  %mul18 = mul nsw i32 %19, %20
  %mul19 = mul nsw i32 %sub17, %mul18
  %21 = load i32, i32* %j, align 4
  %22 = load i32, i32* %x.addr, align 4
  %mul20 = mul nsw i32 %21, %22
  %add21 = add nsw i32 %mul19, %mul20
  %23 = load i32, i32* %k, align 4
  %add22 = add nsw i32 %add21, %23
  %idxprom23 = sext i32 %add22 to i64
  %24 = load float*, float** %A.addr, align 8
  %arrayidx24 = getelementptr inbounds float, float* %24, i64 %idxprom23
  %25 = load float, float* %arrayidx24, align 4
  %mul25 = fmul float %17, %25
  %add26 = fadd float %mul16, %mul25
  %26 = load float, float* %c0, align 4
  %27 = load i32, i32* %i, align 4
  %add27 = add nsw i32 %27, 4
  %28 = load i32, i32* %x.addr, align 4
  %29 = load i32, i32* %y.addr, align 4
  %mul28 = mul nsw i32 %28, %29
  %mul29 = mul nsw i32 %add27, %mul28
  %30 = load i32, i32* %j, align 4
  %31 = load i32, i32* %x.addr, align 4
  %mul30 = mul nsw i32 %30, %31
  %add31 = add nsw i32 %mul29, %mul30
  %32 = load i32, i32* %k, align 4
  %add32 = add nsw i32 %add31, %32
  %idxprom33 = sext i32 %add32 to i64
  %33 = load float*, float** %A.addr, align 8
  %arrayidx34 = getelementptr inbounds float, float* %33, i64 %idxprom33
  %34 = load float, float* %arrayidx34, align 4
  %mul35 = fmul float %26, %34
  %add36 = fadd float %add26, %mul35
  %35 = load float, float* %c1, align 4
  %36 = load i32, i32* %i, align 4
  %sub37 = sub nsw i32 %36, 4
  %37 = load i32, i32* %x.addr, align 4
  %38 = load i32, i32* %y.addr, align 4
  %mul38 = mul nsw i32 %37, %38
  %mul39 = mul nsw i32 %sub37, %mul38
  %39 = load i32, i32* %j, align 4
  %40 = load i32, i32* %x.addr, align 4
  %mul40 = mul nsw i32 %39, %40
  %add41 = add nsw i32 %mul39, %mul40
  %41 = load i32, i32* %k, align 4
  %add42 = add nsw i32 %add41, %41
  %idxprom43 = sext i32 %add42 to i64
  %42 = load float*, float** %A.addr, align 8
  %arrayidx44 = getelementptr inbounds float, float* %42, i64 %idxprom43
  %43 = load float, float* %arrayidx44, align 4
  %mul45 = fmul float %35, %43
  %add46 = fadd float %add36, %mul45
  %44 = load float, float* %c0, align 4
  %45 = load i32, i32* %i, align 4
  %add47 = add nsw i32 %45, 3
  %46 = load i32, i32* %x.addr, align 4
  %47 = load i32, i32* %y.addr, align 4
  %mul48 = mul nsw i32 %46, %47
  %mul49 = mul nsw i32 %add47, %mul48
  %48 = load i32, i32* %j, align 4
  %49 = load i32, i32* %x.addr, align 4
  %mul50 = mul nsw i32 %48, %49
  %add51 = add nsw i32 %mul49, %mul50
  %50 = load i32, i32* %k, align 4
  %add52 = add nsw i32 %add51, %50
  %idxprom53 = sext i32 %add52 to i64
  %51 = load float*, float** %A.addr, align 8
  %arrayidx54 = getelementptr inbounds float, float* %51, i64 %idxprom53
  %52 = load float, float* %arrayidx54, align 4
  %mul55 = fmul float %44, %52
  %add56 = fadd float %add46, %mul55
  %53 = load float, float* %c1, align 4
  %54 = load i32, i32* %i, align 4
  %sub57 = sub nsw i32 %54, 3
  %55 = load i32, i32* %x.addr, align 4
  %56 = load i32, i32* %y.addr, align 4
  %mul58 = mul nsw i32 %55, %56
  %mul59 = mul nsw i32 %sub57, %mul58
  %57 = load i32, i32* %j, align 4
  %58 = load i32, i32* %x.addr, align 4
  %mul60 = mul nsw i32 %57, %58
  %add61 = add nsw i32 %mul59, %mul60
  %59 = load i32, i32* %k, align 4
  %add62 = add nsw i32 %add61, %59
  %idxprom63 = sext i32 %add62 to i64
  %60 = load float*, float** %A.addr, align 8
  %arrayidx64 = getelementptr inbounds float, float* %60, i64 %idxprom63
  %61 = load float, float* %arrayidx64, align 4
  %mul65 = fmul float %53, %61
  %add66 = fadd float %add56, %mul65
  %62 = load float, float* %c0, align 4
  %63 = load i32, i32* %i, align 4
  %add67 = add nsw i32 %63, 2
  %64 = load i32, i32* %x.addr, align 4
  %65 = load i32, i32* %y.addr, align 4
  %mul68 = mul nsw i32 %64, %65
  %mul69 = mul nsw i32 %add67, %mul68
  %66 = load i32, i32* %j, align 4
  %67 = load i32, i32* %x.addr, align 4
  %mul70 = mul nsw i32 %66, %67
  %add71 = add nsw i32 %mul69, %mul70
  %68 = load i32, i32* %k, align 4
  %add72 = add nsw i32 %add71, %68
  %idxprom73 = sext i32 %add72 to i64
  %69 = load float*, float** %A.addr, align 8
  %arrayidx74 = getelementptr inbounds float, float* %69, i64 %idxprom73
  %70 = load float, float* %arrayidx74, align 4
  %mul75 = fmul float %62, %70
  %add76 = fadd float %add66, %mul75
  %71 = load float, float* %c1, align 4
  %72 = load i32, i32* %i, align 4
  %sub77 = sub nsw i32 %72, 2
  %73 = load i32, i32* %x.addr, align 4
  %74 = load i32, i32* %y.addr, align 4
  %mul78 = mul nsw i32 %73, %74
  %mul79 = mul nsw i32 %sub77, %mul78
  %75 = load i32, i32* %j, align 4
  %76 = load i32, i32* %x.addr, align 4
  %mul80 = mul nsw i32 %75, %76
  %add81 = add nsw i32 %mul79, %mul80
  %77 = load i32, i32* %k, align 4
  %add82 = add nsw i32 %add81, %77
  %idxprom83 = sext i32 %add82 to i64
  %78 = load float*, float** %A.addr, align 8
  %arrayidx84 = getelementptr inbounds float, float* %78, i64 %idxprom83
  %79 = load float, float* %arrayidx84, align 4
  %mul85 = fmul float %71, %79
  %add86 = fadd float %add76, %mul85
  %80 = load float, float* %c0, align 4
  %81 = load i32, i32* %i, align 4
  %add87 = add nsw i32 %81, 1
  %82 = load i32, i32* %x.addr, align 4
  %83 = load i32, i32* %y.addr, align 4
  %mul88 = mul nsw i32 %82, %83
  %mul89 = mul nsw i32 %add87, %mul88
  %84 = load i32, i32* %j, align 4
  %85 = load i32, i32* %x.addr, align 4
  %mul90 = mul nsw i32 %84, %85
  %add91 = add nsw i32 %mul89, %mul90
  %86 = load i32, i32* %k, align 4
  %add92 = add nsw i32 %add91, %86
  %idxprom93 = sext i32 %add92 to i64
  %87 = load float*, float** %A.addr, align 8
  %arrayidx94 = getelementptr inbounds float, float* %87, i64 %idxprom93
  %88 = load float, float* %arrayidx94, align 4
  %mul95 = fmul float %80, %88
  %add96 = fadd float %add86, %mul95
  %89 = load float, float* %c1, align 4
  %90 = load i32, i32* %i, align 4
  %sub97 = sub nsw i32 %90, 1
  %91 = load i32, i32* %x.addr, align 4
  %92 = load i32, i32* %y.addr, align 4
  %mul98 = mul nsw i32 %91, %92
  %mul99 = mul nsw i32 %sub97, %mul98
  %93 = load i32, i32* %j, align 4
  %94 = load i32, i32* %x.addr, align 4
  %mul100 = mul nsw i32 %93, %94
  %add101 = add nsw i32 %mul99, %mul100
  %95 = load i32, i32* %k, align 4
  %add102 = add nsw i32 %add101, %95
  %idxprom103 = sext i32 %add102 to i64
  %96 = load float*, float** %A.addr, align 8
  %arrayidx104 = getelementptr inbounds float, float* %96, i64 %idxprom103
  %97 = load float, float* %arrayidx104, align 4
  %mul105 = fmul float %89, %97
  %add106 = fadd float %add96, %mul105
  %98 = load float, float* %c2, align 4
  %99 = load i32, i32* %i, align 4
  %100 = load i32, i32* %x.addr, align 4
  %101 = load i32, i32* %y.addr, align 4
  %mul107 = mul nsw i32 %100, %101
  %mul108 = mul nsw i32 %99, %mul107
  %102 = load i32, i32* %j, align 4
  %add109 = add nsw i32 %102, 5
  %103 = load i32, i32* %x.addr, align 4
  %mul110 = mul nsw i32 %add109, %103
  %add111 = add nsw i32 %mul108, %mul110
  %104 = load i32, i32* %k, align 4
  %add112 = add nsw i32 %add111, %104
  %idxprom113 = sext i32 %add112 to i64
  %105 = load float*, float** %A.addr, align 8
  %arrayidx114 = getelementptr inbounds float, float* %105, i64 %idxprom113
  %106 = load float, float* %arrayidx114, align 4
  %mul115 = fmul float %98, %106
  %add116 = fadd float %add106, %mul115
  %107 = load float, float* %c3, align 4
  %108 = load i32, i32* %i, align 4
  %109 = load i32, i32* %x.addr, align 4
  %110 = load i32, i32* %y.addr, align 4
  %mul117 = mul nsw i32 %109, %110
  %mul118 = mul nsw i32 %108, %mul117
  %111 = load i32, i32* %j, align 4
  %sub119 = sub nsw i32 %111, 5
  %112 = load i32, i32* %x.addr, align 4
  %mul120 = mul nsw i32 %sub119, %112
  %add121 = add nsw i32 %mul118, %mul120
  %113 = load i32, i32* %k, align 4
  %add122 = add nsw i32 %add121, %113
  %idxprom123 = sext i32 %add122 to i64
  %114 = load float*, float** %A.addr, align 8
  %arrayidx124 = getelementptr inbounds float, float* %114, i64 %idxprom123
  %115 = load float, float* %arrayidx124, align 4
  %mul125 = fmul float %107, %115
  %add126 = fadd float %add116, %mul125
  %116 = load float, float* %c2, align 4
  %117 = load i32, i32* %i, align 4
  %118 = load i32, i32* %x.addr, align 4
  %119 = load i32, i32* %y.addr, align 4
  %mul127 = mul nsw i32 %118, %119
  %mul128 = mul nsw i32 %117, %mul127
  %120 = load i32, i32* %j, align 4
  %add129 = add nsw i32 %120, 4
  %121 = load i32, i32* %x.addr, align 4
  %mul130 = mul nsw i32 %add129, %121
  %add131 = add nsw i32 %mul128, %mul130
  %122 = load i32, i32* %k, align 4
  %add132 = add nsw i32 %add131, %122
  %idxprom133 = sext i32 %add132 to i64
  %123 = load float*, float** %A.addr, align 8
  %arrayidx134 = getelementptr inbounds float, float* %123, i64 %idxprom133
  %124 = load float, float* %arrayidx134, align 4
  %mul135 = fmul float %116, %124
  %add136 = fadd float %add126, %mul135
  %125 = load float, float* %c3, align 4
  %126 = load i32, i32* %i, align 4
  %127 = load i32, i32* %x.addr, align 4
  %128 = load i32, i32* %y.addr, align 4
  %mul137 = mul nsw i32 %127, %128
  %mul138 = mul nsw i32 %126, %mul137
  %129 = load i32, i32* %j, align 4
  %sub139 = sub nsw i32 %129, 4
  %130 = load i32, i32* %x.addr, align 4
  %mul140 = mul nsw i32 %sub139, %130
  %add141 = add nsw i32 %mul138, %mul140
  %131 = load i32, i32* %k, align 4
  %add142 = add nsw i32 %add141, %131
  %idxprom143 = sext i32 %add142 to i64
  %132 = load float*, float** %A.addr, align 8
  %arrayidx144 = getelementptr inbounds float, float* %132, i64 %idxprom143
  %133 = load float, float* %arrayidx144, align 4
  %mul145 = fmul float %125, %133
  %add146 = fadd float %add136, %mul145
  %134 = load float, float* %c2, align 4
  %135 = load i32, i32* %i, align 4
  %136 = load i32, i32* %x.addr, align 4
  %137 = load i32, i32* %y.addr, align 4
  %mul147 = mul nsw i32 %136, %137
  %mul148 = mul nsw i32 %135, %mul147
  %138 = load i32, i32* %j, align 4
  %add149 = add nsw i32 %138, 3
  %139 = load i32, i32* %x.addr, align 4
  %mul150 = mul nsw i32 %add149, %139
  %add151 = add nsw i32 %mul148, %mul150
  %140 = load i32, i32* %k, align 4
  %add152 = add nsw i32 %add151, %140
  %idxprom153 = sext i32 %add152 to i64
  %141 = load float*, float** %A.addr, align 8
  %arrayidx154 = getelementptr inbounds float, float* %141, i64 %idxprom153
  %142 = load float, float* %arrayidx154, align 4
  %mul155 = fmul float %134, %142
  %add156 = fadd float %add146, %mul155
  %143 = load float, float* %c3, align 4
  %144 = load i32, i32* %i, align 4
  %145 = load i32, i32* %x.addr, align 4
  %146 = load i32, i32* %y.addr, align 4
  %mul157 = mul nsw i32 %145, %146
  %mul158 = mul nsw i32 %144, %mul157
  %147 = load i32, i32* %j, align 4
  %sub159 = sub nsw i32 %147, 3
  %148 = load i32, i32* %x.addr, align 4
  %mul160 = mul nsw i32 %sub159, %148
  %add161 = add nsw i32 %mul158, %mul160
  %149 = load i32, i32* %k, align 4
  %add162 = add nsw i32 %add161, %149
  %idxprom163 = sext i32 %add162 to i64
  %150 = load float*, float** %A.addr, align 8
  %arrayidx164 = getelementptr inbounds float, float* %150, i64 %idxprom163
  %151 = load float, float* %arrayidx164, align 4
  %mul165 = fmul float %143, %151
  %add166 = fadd float %add156, %mul165
  %152 = load float, float* %c2, align 4
  %153 = load i32, i32* %i, align 4
  %154 = load i32, i32* %x.addr, align 4
  %155 = load i32, i32* %y.addr, align 4
  %mul167 = mul nsw i32 %154, %155
  %mul168 = mul nsw i32 %153, %mul167
  %156 = load i32, i32* %j, align 4
  %add169 = add nsw i32 %156, 2
  %157 = load i32, i32* %x.addr, align 4
  %mul170 = mul nsw i32 %add169, %157
  %add171 = add nsw i32 %mul168, %mul170
  %158 = load i32, i32* %k, align 4
  %add172 = add nsw i32 %add171, %158
  %idxprom173 = sext i32 %add172 to i64
  %159 = load float*, float** %A.addr, align 8
  %arrayidx174 = getelementptr inbounds float, float* %159, i64 %idxprom173
  %160 = load float, float* %arrayidx174, align 4
  %mul175 = fmul float %152, %160
  %add176 = fadd float %add166, %mul175
  %161 = load float, float* %c3, align 4
  %162 = load i32, i32* %i, align 4
  %163 = load i32, i32* %x.addr, align 4
  %164 = load i32, i32* %y.addr, align 4
  %mul177 = mul nsw i32 %163, %164
  %mul178 = mul nsw i32 %162, %mul177
  %165 = load i32, i32* %j, align 4
  %sub179 = sub nsw i32 %165, 2
  %166 = load i32, i32* %x.addr, align 4
  %mul180 = mul nsw i32 %sub179, %166
  %add181 = add nsw i32 %mul178, %mul180
  %167 = load i32, i32* %k, align 4
  %add182 = add nsw i32 %add181, %167
  %idxprom183 = sext i32 %add182 to i64
  %168 = load float*, float** %A.addr, align 8
  %arrayidx184 = getelementptr inbounds float, float* %168, i64 %idxprom183
  %169 = load float, float* %arrayidx184, align 4
  %mul185 = fmul float %161, %169
  %add186 = fadd float %add176, %mul185
  %170 = load float, float* %c2, align 4
  %171 = load i32, i32* %i, align 4
  %172 = load i32, i32* %x.addr, align 4
  %173 = load i32, i32* %y.addr, align 4
  %mul187 = mul nsw i32 %172, %173
  %mul188 = mul nsw i32 %171, %mul187
  %174 = load i32, i32* %j, align 4
  %add189 = add nsw i32 %174, 1
  %175 = load i32, i32* %x.addr, align 4
  %mul190 = mul nsw i32 %add189, %175
  %add191 = add nsw i32 %mul188, %mul190
  %176 = load i32, i32* %k, align 4
  %add192 = add nsw i32 %add191, %176
  %idxprom193 = sext i32 %add192 to i64
  %177 = load float*, float** %A.addr, align 8
  %arrayidx194 = getelementptr inbounds float, float* %177, i64 %idxprom193
  %178 = load float, float* %arrayidx194, align 4
  %mul195 = fmul float %170, %178
  %add196 = fadd float %add186, %mul195
  %179 = load float, float* %c3, align 4
  %180 = load i32, i32* %i, align 4
  %181 = load i32, i32* %x.addr, align 4
  %182 = load i32, i32* %y.addr, align 4
  %mul197 = mul nsw i32 %181, %182
  %mul198 = mul nsw i32 %180, %mul197
  %183 = load i32, i32* %j, align 4
  %sub199 = sub nsw i32 %183, 1
  %184 = load i32, i32* %x.addr, align 4
  %mul200 = mul nsw i32 %sub199, %184
  %add201 = add nsw i32 %mul198, %mul200
  %185 = load i32, i32* %k, align 4
  %add202 = add nsw i32 %add201, %185
  %idxprom203 = sext i32 %add202 to i64
  %186 = load float*, float** %A.addr, align 8
  %arrayidx204 = getelementptr inbounds float, float* %186, i64 %idxprom203
  %187 = load float, float* %arrayidx204, align 4
  %mul205 = fmul float %179, %187
  %add206 = fadd float %add196, %mul205
  %188 = load float, float* %c4, align 4
  %189 = load i32, i32* %i, align 4
  %190 = load i32, i32* %x.addr, align 4
  %191 = load i32, i32* %y.addr, align 4
  %mul207 = mul nsw i32 %190, %191
  %mul208 = mul nsw i32 %189, %mul207
  %192 = load i32, i32* %j, align 4
  %193 = load i32, i32* %x.addr, align 4
  %mul209 = mul nsw i32 %192, %193
  %add210 = add nsw i32 %mul208, %mul209
  %194 = load i32, i32* %k, align 4
  %add211 = add nsw i32 %194, 5
  %add212 = add nsw i32 %add210, %add211
  %idxprom213 = sext i32 %add212 to i64
  %195 = load float*, float** %A.addr, align 8
  %arrayidx214 = getelementptr inbounds float, float* %195, i64 %idxprom213
  %196 = load float, float* %arrayidx214, align 4
  %mul215 = fmul float %188, %196
  %add216 = fadd float %add206, %mul215
  %197 = load float, float* %c5, align 4
  %198 = load i32, i32* %i, align 4
  %199 = load i32, i32* %x.addr, align 4
  %200 = load i32, i32* %y.addr, align 4
  %mul217 = mul nsw i32 %199, %200
  %mul218 = mul nsw i32 %198, %mul217
  %201 = load i32, i32* %j, align 4
  %202 = load i32, i32* %x.addr, align 4
  %mul219 = mul nsw i32 %201, %202
  %add220 = add nsw i32 %mul218, %mul219
  %203 = load i32, i32* %k, align 4
  %sub221 = sub nsw i32 %203, 5
  %add222 = add nsw i32 %add220, %sub221
  %idxprom223 = sext i32 %add222 to i64
  %204 = load float*, float** %A.addr, align 8
  %arrayidx224 = getelementptr inbounds float, float* %204, i64 %idxprom223
  %205 = load float, float* %arrayidx224, align 4
  %mul225 = fmul float %197, %205
  %add226 = fadd float %add216, %mul225
  %206 = load float, float* %c4, align 4
  %207 = load i32, i32* %i, align 4
  %208 = load i32, i32* %x.addr, align 4
  %209 = load i32, i32* %y.addr, align 4
  %mul227 = mul nsw i32 %208, %209
  %mul228 = mul nsw i32 %207, %mul227
  %210 = load i32, i32* %j, align 4
  %211 = load i32, i32* %x.addr, align 4
  %mul229 = mul nsw i32 %210, %211
  %add230 = add nsw i32 %mul228, %mul229
  %212 = load i32, i32* %k, align 4
  %add231 = add nsw i32 %212, 4
  %add232 = add nsw i32 %add230, %add231
  %idxprom233 = sext i32 %add232 to i64
  %213 = load float*, float** %A.addr, align 8
  %arrayidx234 = getelementptr inbounds float, float* %213, i64 %idxprom233
  %214 = load float, float* %arrayidx234, align 4
  %mul235 = fmul float %206, %214
  %add236 = fadd float %add226, %mul235
  %215 = load float, float* %c5, align 4
  %216 = load i32, i32* %i, align 4
  %217 = load i32, i32* %x.addr, align 4
  %218 = load i32, i32* %y.addr, align 4
  %mul237 = mul nsw i32 %217, %218
  %mul238 = mul nsw i32 %216, %mul237
  %219 = load i32, i32* %j, align 4
  %220 = load i32, i32* %x.addr, align 4
  %mul239 = mul nsw i32 %219, %220
  %add240 = add nsw i32 %mul238, %mul239
  %221 = load i32, i32* %k, align 4
  %sub241 = sub nsw i32 %221, 4
  %add242 = add nsw i32 %add240, %sub241
  %idxprom243 = sext i32 %add242 to i64
  %222 = load float*, float** %A.addr, align 8
  %arrayidx244 = getelementptr inbounds float, float* %222, i64 %idxprom243
  %223 = load float, float* %arrayidx244, align 4
  %mul245 = fmul float %215, %223
  %add246 = fadd float %add236, %mul245
  %224 = load float, float* %c4, align 4
  %225 = load i32, i32* %i, align 4
  %226 = load i32, i32* %x.addr, align 4
  %227 = load i32, i32* %y.addr, align 4
  %mul247 = mul nsw i32 %226, %227
  %mul248 = mul nsw i32 %225, %mul247
  %228 = load i32, i32* %j, align 4
  %229 = load i32, i32* %x.addr, align 4
  %mul249 = mul nsw i32 %228, %229
  %add250 = add nsw i32 %mul248, %mul249
  %230 = load i32, i32* %k, align 4
  %add251 = add nsw i32 %230, 3
  %add252 = add nsw i32 %add250, %add251
  %idxprom253 = sext i32 %add252 to i64
  %231 = load float*, float** %A.addr, align 8
  %arrayidx254 = getelementptr inbounds float, float* %231, i64 %idxprom253
  %232 = load float, float* %arrayidx254, align 4
  %mul255 = fmul float %224, %232
  %add256 = fadd float %add246, %mul255
  %233 = load float, float* %c5, align 4
  %234 = load i32, i32* %i, align 4
  %235 = load i32, i32* %x.addr, align 4
  %236 = load i32, i32* %y.addr, align 4
  %mul257 = mul nsw i32 %235, %236
  %mul258 = mul nsw i32 %234, %mul257
  %237 = load i32, i32* %j, align 4
  %238 = load i32, i32* %x.addr, align 4
  %mul259 = mul nsw i32 %237, %238
  %add260 = add nsw i32 %mul258, %mul259
  %239 = load i32, i32* %k, align 4
  %sub261 = sub nsw i32 %239, 3
  %add262 = add nsw i32 %add260, %sub261
  %idxprom263 = sext i32 %add262 to i64
  %240 = load float*, float** %A.addr, align 8
  %arrayidx264 = getelementptr inbounds float, float* %240, i64 %idxprom263
  %241 = load float, float* %arrayidx264, align 4
  %mul265 = fmul float %233, %241
  %add266 = fadd float %add256, %mul265
  %242 = load float, float* %c4, align 4
  %243 = load i32, i32* %i, align 4
  %244 = load i32, i32* %x.addr, align 4
  %245 = load i32, i32* %y.addr, align 4
  %mul267 = mul nsw i32 %244, %245
  %mul268 = mul nsw i32 %243, %mul267
  %246 = load i32, i32* %j, align 4
  %247 = load i32, i32* %x.addr, align 4
  %mul269 = mul nsw i32 %246, %247
  %add270 = add nsw i32 %mul268, %mul269
  %248 = load i32, i32* %k, align 4
  %add271 = add nsw i32 %248, 2
  %add272 = add nsw i32 %add270, %add271
  %idxprom273 = sext i32 %add272 to i64
  %249 = load float*, float** %A.addr, align 8
  %arrayidx274 = getelementptr inbounds float, float* %249, i64 %idxprom273
  %250 = load float, float* %arrayidx274, align 4
  %mul275 = fmul float %242, %250
  %add276 = fadd float %add266, %mul275
  %251 = load float, float* %c5, align 4
  %252 = load i32, i32* %i, align 4
  %253 = load i32, i32* %x.addr, align 4
  %254 = load i32, i32* %y.addr, align 4
  %mul277 = mul nsw i32 %253, %254
  %mul278 = mul nsw i32 %252, %mul277
  %255 = load i32, i32* %j, align 4
  %256 = load i32, i32* %x.addr, align 4
  %mul279 = mul nsw i32 %255, %256
  %add280 = add nsw i32 %mul278, %mul279
  %257 = load i32, i32* %k, align 4
  %sub281 = sub nsw i32 %257, 2
  %add282 = add nsw i32 %add280, %sub281
  %idxprom283 = sext i32 %add282 to i64
  %258 = load float*, float** %A.addr, align 8
  %arrayidx284 = getelementptr inbounds float, float* %258, i64 %idxprom283
  %259 = load float, float* %arrayidx284, align 4
  %mul285 = fmul float %251, %259
  %add286 = fadd float %add276, %mul285
  %260 = load float, float* %c4, align 4
  %261 = load i32, i32* %i, align 4
  %262 = load i32, i32* %x.addr, align 4
  %263 = load i32, i32* %y.addr, align 4
  %mul287 = mul nsw i32 %262, %263
  %mul288 = mul nsw i32 %261, %mul287
  %264 = load i32, i32* %j, align 4
  %265 = load i32, i32* %x.addr, align 4
  %mul289 = mul nsw i32 %264, %265
  %add290 = add nsw i32 %mul288, %mul289
  %266 = load i32, i32* %k, align 4
  %add291 = add nsw i32 %266, 1
  %add292 = add nsw i32 %add290, %add291
  %idxprom293 = sext i32 %add292 to i64
  %267 = load float*, float** %A.addr, align 8
  %arrayidx294 = getelementptr inbounds float, float* %267, i64 %idxprom293
  %268 = load float, float* %arrayidx294, align 4
  %mul295 = fmul float %260, %268
  %add296 = fadd float %add286, %mul295
  %269 = load float, float* %c5, align 4
  %270 = load i32, i32* %i, align 4
  %271 = load i32, i32* %x.addr, align 4
  %272 = load i32, i32* %y.addr, align 4
  %mul297 = mul nsw i32 %271, %272
  %mul298 = mul nsw i32 %270, %mul297
  %273 = load i32, i32* %j, align 4
  %274 = load i32, i32* %x.addr, align 4
  %mul299 = mul nsw i32 %273, %274
  %add300 = add nsw i32 %mul298, %mul299
  %275 = load i32, i32* %k, align 4
  %sub301 = sub nsw i32 %275, 1
  %add302 = add nsw i32 %add300, %sub301
  %idxprom303 = sext i32 %add302 to i64
  %276 = load float*, float** %A.addr, align 8
  %arrayidx304 = getelementptr inbounds float, float* %276, i64 %idxprom303
  %277 = load float, float* %arrayidx304, align 4
  %mul305 = fmul float %269, %277
  %add306 = fadd float %add296, %mul305
  %278 = load float, float* %c6, align 4
  %279 = load i32, i32* %i, align 4
  %280 = load i32, i32* %x.addr, align 4
  %281 = load i32, i32* %y.addr, align 4
  %mul307 = mul nsw i32 %280, %281
  %mul308 = mul nsw i32 %279, %mul307
  %282 = load i32, i32* %j, align 4
  %283 = load i32, i32* %x.addr, align 4
  %mul309 = mul nsw i32 %282, %283
  %add310 = add nsw i32 %mul308, %mul309
  %284 = load i32, i32* %k, align 4
  %add311 = add nsw i32 %add310, %284
  %idxprom312 = sext i32 %add311 to i64
  %285 = load float*, float** %A.addr, align 8
  %arrayidx313 = getelementptr inbounds float, float* %285, i64 %idxprom312
  %286 = load float, float* %arrayidx313, align 4
  %mul314 = fmul float %278, %286
  %add315 = fadd float %add306, %mul314
  %287 = load i32, i32* %i, align 4
  %288 = load i32, i32* %x.addr, align 4
  %289 = load i32, i32* %y.addr, align 4
  %mul316 = mul nsw i32 %288, %289
  %mul317 = mul nsw i32 %287, %mul316
  %290 = load i32, i32* %j, align 4
  %291 = load i32, i32* %x.addr, align 4
  %mul318 = mul nsw i32 %290, %291
  %add319 = add nsw i32 %mul317, %mul318
  %292 = load i32, i32* %k, align 4
  %add320 = add nsw i32 %add319, %292
  %idxprom321 = sext i32 %add320 to i64
  %293 = load float*, float** %B.addr, align 8
  %arrayidx322 = getelementptr inbounds float, float* %293, i64 %idxprom321
  store float %add315, float* %arrayidx322, align 4
  br label %for.inc

for.inc:                                          ; preds = %for.body.11
  %294 = load i32, i32* %k, align 4
  %inc = add nsw i32 %294, 1
  store i32 %inc, i32* %k, align 4
  br label %for.cond.8

for.end:                                          ; preds = %for.cond.8
  br label %for.inc.323

for.inc.323:                                      ; preds = %for.end
  %295 = load i32, i32* %j, align 4
  %inc324 = add nsw i32 %295, 1
  store i32 %inc324, i32* %j, align 4
  br label %for.cond.4

for.end.325:                                      ; preds = %for.cond.4
  br label %for.inc.326

for.inc.326:                                      ; preds = %for.end.325
  %296 = load i32, i32* %i, align 4
  %inc327 = add nsw i32 %296, 1
  store i32 %inc327, i32* %i, align 4
  br label %for.cond.1

for.end.328:                                      ; preds = %for.cond.1
  store i32 5, i32* %i, align 4
  br label %for.cond.329

for.cond.329:                                     ; preds = %for.inc.361, %for.end.328
  %297 = load i32, i32* %i, align 4
  %298 = load i32, i32* %z.addr, align 4
  %sub330 = sub nsw i32 %298, 5
  %cmp331 = icmp slt i32 %297, %sub330
  br i1 %cmp331, label %for.body.332, label %for.end.363

for.body.332:                                     ; preds = %for.cond.329
  store i32 5, i32* %j, align 4
  br label %for.cond.333

for.cond.333:                                     ; preds = %for.inc.358, %for.body.332
  %299 = load i32, i32* %j, align 4
  %300 = load i32, i32* %y.addr, align 4
  %sub334 = sub nsw i32 %300, 5
  %cmp335 = icmp slt i32 %299, %sub334
  br i1 %cmp335, label %for.body.336, label %for.end.360

for.body.336:                                     ; preds = %for.cond.333
  store i32 5, i32* %k, align 4
  br label %for.cond.337

for.cond.337:                                     ; preds = %for.inc.355, %for.body.336
  %301 = load i32, i32* %k, align 4
  %302 = load i32, i32* %x.addr, align 4
  %sub338 = sub nsw i32 %302, 5
  %cmp339 = icmp slt i32 %301, %sub338
  br i1 %cmp339, label %for.body.340, label %for.end.357

for.body.340:                                     ; preds = %for.cond.337
  %303 = load i32, i32* %i, align 4
  %304 = load i32, i32* %x.addr, align 4
  %305 = load i32, i32* %y.addr, align 4
  %mul341 = mul nsw i32 %304, %305
  %mul342 = mul nsw i32 %303, %mul341
  %306 = load i32, i32* %j, align 4
  %307 = load i32, i32* %x.addr, align 4
  %mul343 = mul nsw i32 %306, %307
  %add344 = add nsw i32 %mul342, %mul343
  %308 = load i32, i32* %k, align 4
  %add345 = add nsw i32 %add344, %308
  %idxprom346 = sext i32 %add345 to i64
  %309 = load float*, float** %B.addr, align 8
  %arrayidx347 = getelementptr inbounds float, float* %309, i64 %idxprom346
  %310 = load float, float* %arrayidx347, align 4
  %311 = load i32, i32* %i, align 4
  %312 = load i32, i32* %x.addr, align 4
  %313 = load i32, i32* %y.addr, align 4
  %mul348 = mul nsw i32 %312, %313
  %mul349 = mul nsw i32 %311, %mul348
  %314 = load i32, i32* %j, align 4
  %315 = load i32, i32* %z.addr, align 4
  %mul350 = mul nsw i32 %314, %315
  %add351 = add nsw i32 %mul349, %mul350
  %316 = load i32, i32* %k, align 4
  %add352 = add nsw i32 %add351, %316
  %idxprom353 = sext i32 %add352 to i64
  %317 = load float*, float** %A.addr, align 8
  %arrayidx354 = getelementptr inbounds float, float* %317, i64 %idxprom353
  store float %310, float* %arrayidx354, align 4
  br label %for.inc.355

for.inc.355:                                      ; preds = %for.body.340
  %318 = load i32, i32* %k, align 4
  %inc356 = add nsw i32 %318, 1
  store i32 %inc356, i32* %k, align 4
  br label %for.cond.337

for.end.357:                                      ; preds = %for.cond.337
  br label %for.inc.358

for.inc.358:                                      ; preds = %for.end.357
  %319 = load i32, i32* %j, align 4
  %inc359 = add nsw i32 %319, 1
  store i32 %inc359, i32* %j, align 4
  br label %for.cond.333

for.end.360:                                      ; preds = %for.cond.333
  br label %for.inc.361

for.inc.361:                                      ; preds = %for.end.360
  %320 = load i32, i32* %i, align 4
  %inc362 = add nsw i32 %320, 1
  store i32 %inc362, i32* %i, align 4
  br label %for.cond.329

for.end.363:                                      ; preds = %for.cond.329
  br label %for.inc.364

for.inc.364:                                      ; preds = %for.end.363
  %321 = load i32, i32* %t, align 4
  %inc365 = add nsw i32 %321, 1
  store i32 %inc365, i32* %t, align 4
  br label %for.cond

for.end.366:                                      ; preds = %for.cond
  ret void
}

; Function Attrs: nounwind uwtable
define void @init(float* %A, i32 %x, i32 %y, i32 %z, i32 %offset_x, i32 %offset_y, i32 %offset_z) #0 {
entry:
  %A.addr = alloca float*, align 8
  %x.addr = alloca i32, align 4
  %y.addr = alloca i32, align 4
  %z.addr = alloca i32, align 4
  %offset_x.addr = alloca i32, align 4
  %offset_y.addr = alloca i32, align 4
  %offset_z.addr = alloca i32, align 4
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  %k = alloca i32, align 4
  store float* %A, float** %A.addr, align 8
  store i32 %x, i32* %x.addr, align 4
  store i32 %y, i32* %y.addr, align 4
  store i32 %z, i32* %z.addr, align 4
  store i32 %offset_x, i32* %offset_x.addr, align 4
  store i32 %offset_y, i32* %offset_y.addr, align 4
  store i32 %offset_z, i32* %offset_z.addr, align 4
  store i32 0, i32* %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc.37, %entry
  %0 = load i32, i32* %i, align 4
  %1 = load i32, i32* %z.addr, align 4
  %cmp = icmp slt i32 %0, %1
  br i1 %cmp, label %for.body, label %for.end.39

for.body:                                         ; preds = %for.cond
  store i32 0, i32* %j, align 4
  br label %for.cond.1

for.cond.1:                                       ; preds = %for.inc.34, %for.body
  %2 = load i32, i32* %j, align 4
  %3 = load i32, i32* %y.addr, align 4
  %cmp2 = icmp slt i32 %2, %3
  br i1 %cmp2, label %for.body.3, label %for.end.36

for.body.3:                                       ; preds = %for.cond.1
  store i32 0, i32* %k, align 4
  br label %for.cond.4

for.cond.4:                                       ; preds = %for.inc, %for.body.3
  %4 = load i32, i32* %k, align 4
  %5 = load i32, i32* %x.addr, align 4
  %cmp5 = icmp slt i32 %4, %5
  br i1 %cmp5, label %for.body.6, label %for.end

for.body.6:                                       ; preds = %for.cond.4
  %6 = load i32, i32* %i, align 4
  %7 = load i32, i32* %offset_z.addr, align 4
  %cmp7 = icmp slt i32 %6, %7
  br i1 %cmp7, label %if.then, label %lor.lhs.false

lor.lhs.false:                                    ; preds = %for.body.6
  %8 = load i32, i32* %j, align 4
  %9 = load i32, i32* %offset_y.addr, align 4
  %cmp8 = icmp slt i32 %8, %9
  br i1 %cmp8, label %if.then, label %lor.lhs.false.9

lor.lhs.false.9:                                  ; preds = %lor.lhs.false
  %10 = load i32, i32* %i, align 4
  %11 = load i32, i32* %z.addr, align 4
  %12 = load i32, i32* %offset_z.addr, align 4
  %sub = sub nsw i32 %11, %12
  %cmp10 = icmp sge i32 %10, %sub
  br i1 %cmp10, label %if.then, label %lor.lhs.false.11

lor.lhs.false.11:                                 ; preds = %lor.lhs.false.9
  %13 = load i32, i32* %j, align 4
  %14 = load i32, i32* %y.addr, align 4
  %15 = load i32, i32* %offset_y.addr, align 4
  %sub12 = sub nsw i32 %14, %15
  %cmp13 = icmp sge i32 %13, %sub12
  br i1 %cmp13, label %if.then, label %lor.lhs.false.14

lor.lhs.false.14:                                 ; preds = %lor.lhs.false.11
  %16 = load i32, i32* %k, align 4
  %17 = load i32, i32* %offset_x.addr, align 4
  %cmp15 = icmp slt i32 %16, %17
  br i1 %cmp15, label %if.then, label %lor.lhs.false.16

lor.lhs.false.16:                                 ; preds = %lor.lhs.false.14
  %18 = load i32, i32* %k, align 4
  %19 = load i32, i32* %x.addr, align 4
  %20 = load i32, i32* %offset_x.addr, align 4
  %sub17 = sub nsw i32 %19, %20
  %cmp18 = icmp sge i32 %18, %sub17
  br i1 %cmp18, label %if.then, label %if.else

if.then:                                          ; preds = %lor.lhs.false.16, %lor.lhs.false.14, %lor.lhs.false.11, %lor.lhs.false.9, %lor.lhs.false, %for.body.6
  %21 = load i32, i32* %i, align 4
  %22 = load i32, i32* %x.addr, align 4
  %23 = load i32, i32* %y.addr, align 4
  %mul = mul nsw i32 %22, %23
  %mul19 = mul nsw i32 %21, %mul
  %24 = load i32, i32* %j, align 4
  %25 = load i32, i32* %x.addr, align 4
  %mul20 = mul nsw i32 %24, %25
  %add = add nsw i32 %mul19, %mul20
  %26 = load i32, i32* %k, align 4
  %add21 = add nsw i32 %add, %26
  %idxprom = sext i32 %add21 to i64
  %27 = load float*, float** %A.addr, align 8
  %arrayidx = getelementptr inbounds float, float* %27, i64 %idxprom
  store float 0.000000e+00, float* %arrayidx, align 4
  br label %if.end

if.else:                                          ; preds = %lor.lhs.false.16
  %28 = load i32, i32* %i, align 4
  %29 = load i32, i32* %j, align 4
  %add22 = add nsw i32 %28, %29
  %30 = load i32, i32* %x.addr, align 4
  %31 = load i32, i32* %k, align 4
  %sub23 = sub nsw i32 %30, %31
  %add24 = add nsw i32 %add22, %sub23
  %conv = sitofp i32 %add24 to float
  %mul25 = fmul float %conv, 1.000000e+01
  %32 = load i32, i32* %x.addr, align 4
  %conv26 = sitofp i32 %32 to float
  %div = fdiv float %mul25, %conv26
  %33 = load i32, i32* %i, align 4
  %34 = load i32, i32* %x.addr, align 4
  %35 = load i32, i32* %y.addr, align 4
  %mul27 = mul nsw i32 %34, %35
  %mul28 = mul nsw i32 %33, %mul27
  %36 = load i32, i32* %j, align 4
  %37 = load i32, i32* %x.addr, align 4
  %mul29 = mul nsw i32 %36, %37
  %add30 = add nsw i32 %mul28, %mul29
  %38 = load i32, i32* %k, align 4
  %add31 = add nsw i32 %add30, %38
  %idxprom32 = sext i32 %add31 to i64
  %39 = load float*, float** %A.addr, align 8
  %arrayidx33 = getelementptr inbounds float, float* %39, i64 %idxprom32
  store float %div, float* %arrayidx33, align 4
  br label %if.end

if.end:                                           ; preds = %if.else, %if.then
  br label %for.inc

for.inc:                                          ; preds = %if.end
  %40 = load i32, i32* %k, align 4
  %inc = add nsw i32 %40, 1
  store i32 %inc, i32* %k, align 4
  br label %for.cond.4

for.end:                                          ; preds = %for.cond.4
  br label %for.inc.34

for.inc.34:                                       ; preds = %for.end
  %41 = load i32, i32* %j, align 4
  %inc35 = add nsw i32 %41, 1
  store i32 %inc35, i32* %j, align 4
  br label %for.cond.1

for.end.36:                                       ; preds = %for.cond.1
  br label %for.inc.37

for.inc.37:                                       ; preds = %for.end.36
  %42 = load i32, i32* %i, align 4
  %inc38 = add nsw i32 %42, 1
  store i32 %inc38, i32* %i, align 4
  br label %for.cond

for.end.39:                                       ; preds = %for.cond
  ret void
}

; Function Attrs: nounwind uwtable
define i32 @checkResult(float* %a, float* %ref, i32 %dimx, i32 %dimy, i32 %dimz) #0 {
entry:
  %retval = alloca i32, align 4
  %a.addr = alloca float*, align 8
  %ref.addr = alloca float*, align 8
  %dimx.addr = alloca i32, align 4
  %dimy.addr = alloca i32, align 4
  %dimz.addr = alloca i32, align 4
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  %k = alloca i32, align 4
  store float* %a, float** %a.addr, align 8
  store float* %ref, float** %ref.addr, align 8
  store i32 %dimx, i32* %dimx.addr, align 4
  store i32 %dimy, i32* %dimy.addr, align 4
  store i32 %dimz, i32* %dimz.addr, align 4
  store i32 0, i32* %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc.36, %entry
  %0 = load i32, i32* %i, align 4
  %1 = load i32, i32* %dimz.addr, align 4
  %cmp = icmp slt i32 %0, %1
  br i1 %cmp, label %for.body, label %for.end.38

for.body:                                         ; preds = %for.cond
  store i32 0, i32* %j, align 4
  br label %for.cond.1

for.cond.1:                                       ; preds = %for.inc.33, %for.body
  %2 = load i32, i32* %j, align 4
  %3 = load i32, i32* %dimy.addr, align 4
  %cmp2 = icmp slt i32 %2, %3
  br i1 %cmp2, label %for.body.3, label %for.end.35

for.body.3:                                       ; preds = %for.cond.1
  store i32 0, i32* %k, align 4
  br label %for.cond.4

for.cond.4:                                       ; preds = %for.inc, %for.body.3
  %4 = load i32, i32* %k, align 4
  %5 = load i32, i32* %dimx.addr, align 4
  %cmp5 = icmp slt i32 %4, %5
  br i1 %cmp5, label %for.body.6, label %for.end

for.body.6:                                       ; preds = %for.cond.4
  %6 = load i32, i32* %i, align 4
  %7 = load i32, i32* %dimx.addr, align 4
  %mul = mul nsw i32 %6, %7
  %8 = load i32, i32* %dimy.addr, align 4
  %mul7 = mul nsw i32 %mul, %8
  %9 = load i32, i32* %j, align 4
  %10 = load i32, i32* %dimx.addr, align 4
  %mul8 = mul nsw i32 %9, %10
  %add = add nsw i32 %mul7, %mul8
  %11 = load i32, i32* %k, align 4
  %add9 = add nsw i32 %add, %11
  %idxprom = sext i32 %add9 to i64
  %12 = load float*, float** %a.addr, align 8
  %arrayidx = getelementptr inbounds float, float* %12, i64 %idxprom
  %13 = load float, float* %arrayidx, align 4
  %14 = load i32, i32* %i, align 4
  %15 = load i32, i32* %dimx.addr, align 4
  %mul10 = mul nsw i32 %14, %15
  %16 = load i32, i32* %dimy.addr, align 4
  %mul11 = mul nsw i32 %mul10, %16
  %17 = load i32, i32* %j, align 4
  %18 = load i32, i32* %dimx.addr, align 4
  %mul12 = mul nsw i32 %17, %18
  %add13 = add nsw i32 %mul11, %mul12
  %19 = load i32, i32* %k, align 4
  %add14 = add nsw i32 %add13, %19
  %idxprom15 = sext i32 %add14 to i64
  %20 = load float*, float** %ref.addr, align 8
  %arrayidx16 = getelementptr inbounds float, float* %20, i64 %idxprom15
  %21 = load float, float* %arrayidx16, align 4
  %cmp17 = fcmp une float %13, %21
  br i1 %cmp17, label %if.then, label %if.end

if.then:                                          ; preds = %for.body.6
  %22 = load i32, i32* %i, align 4
  %23 = load i32, i32* %dimx.addr, align 4
  %mul18 = mul nsw i32 %22, %23
  %24 = load i32, i32* %dimy.addr, align 4
  %mul19 = mul nsw i32 %mul18, %24
  %25 = load i32, i32* %j, align 4
  %26 = load i32, i32* %dimx.addr, align 4
  %mul20 = mul nsw i32 %25, %26
  %add21 = add nsw i32 %mul19, %mul20
  %27 = load i32, i32* %k, align 4
  %add22 = add nsw i32 %add21, %27
  %idxprom23 = sext i32 %add22 to i64
  %28 = load float*, float** %ref.addr, align 8
  %arrayidx24 = getelementptr inbounds float, float* %28, i64 %idxprom23
  %29 = load float, float* %arrayidx24, align 4
  %conv = fpext float %29 to double
  %30 = load i32, i32* %i, align 4
  %31 = load i32, i32* %dimx.addr, align 4
  %mul25 = mul nsw i32 %30, %31
  %32 = load i32, i32* %dimy.addr, align 4
  %mul26 = mul nsw i32 %mul25, %32
  %33 = load i32, i32* %j, align 4
  %34 = load i32, i32* %dimx.addr, align 4
  %mul27 = mul nsw i32 %33, %34
  %add28 = add nsw i32 %mul26, %mul27
  %35 = load i32, i32* %k, align 4
  %add29 = add nsw i32 %add28, %35
  %idxprom30 = sext i32 %add29 to i64
  %36 = load float*, float** %a.addr, align 8
  %arrayidx31 = getelementptr inbounds float, float* %36, i64 %idxprom30
  %37 = load float, float* %arrayidx31, align 4
  %conv32 = fpext float %37 to double
  %38 = load i32, i32* %i, align 4
  %39 = load i32, i32* %j, align 4
  %40 = load i32, i32* %k, align 4
  %call = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([51 x i8], [51 x i8]* @.str.1, i32 0, i32 0), double %conv, double %conv32, i32 %38, i32 %39, i32 %40)
  store i32 0, i32* %retval
  br label %return

if.end:                                           ; preds = %for.body.6
  br label %for.inc

for.inc:                                          ; preds = %if.end
  %41 = load i32, i32* %k, align 4
  %inc = add nsw i32 %41, 1
  store i32 %inc, i32* %k, align 4
  br label %for.cond.4

for.end:                                          ; preds = %for.cond.4
  br label %for.inc.33

for.inc.33:                                       ; preds = %for.end
  %42 = load i32, i32* %j, align 4
  %inc34 = add nsw i32 %42, 1
  store i32 %inc34, i32* %j, align 4
  br label %for.cond.1

for.end.35:                                       ; preds = %for.cond.1
  br label %for.inc.36

for.inc.36:                                       ; preds = %for.end.35
  %43 = load i32, i32* %i, align 4
  %inc37 = add nsw i32 %43, 1
  store i32 %inc37, i32* %i, align 4
  br label %for.cond

for.end.38:                                       ; preds = %for.cond
  store i32 1, i32* %retval
  br label %return

return:                                           ; preds = %for.end.38, %if.then
  %44 = load i32, i32* %retval
  ret i32 %44
}

; Function Attrs: nounwind uwtable
define void @compareResults(float* %B, float* %B_GPU) #0 {
entry:
  %B.addr = alloca float*, align 8
  %B_GPU.addr = alloca float*, align 8
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  %k = alloca i32, align 4
  %fail = alloca i32, align 4
  store float* %B, float** %B.addr, align 8
  store float* %B_GPU, float** %B_GPU.addr, align 8
  store i32 0, i32* %fail, align 4
  store i32 0, i32* %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc.23, %entry
  %0 = load i32, i32* %i, align 4
  %cmp = icmp slt i32 %0, 128
  br i1 %cmp, label %for.body, label %for.end.25

for.body:                                         ; preds = %for.cond
  store i32 0, i32* %j, align 4
  br label %for.cond.1

for.cond.1:                                       ; preds = %for.inc.20, %for.body
  %1 = load i32, i32* %j, align 4
  %cmp2 = icmp slt i32 %1, 128
  br i1 %cmp2, label %for.body.3, label %for.end.22

for.body.3:                                       ; preds = %for.cond.1
  store i32 0, i32* %k, align 4
  br label %for.cond.4

for.cond.4:                                       ; preds = %for.inc, %for.body.3
  %2 = load i32, i32* %k, align 4
  %cmp5 = icmp slt i32 %2, 128
  br i1 %cmp5, label %for.body.6, label %for.end

for.body.6:                                       ; preds = %for.cond.4
  %3 = load i32, i32* %i, align 4
  %mul = mul nsw i32 %3, 16384
  %4 = load i32, i32* %j, align 4
  %mul7 = mul nsw i32 %4, 128
  %add = add nsw i32 %mul, %mul7
  %5 = load i32, i32* %k, align 4
  %add8 = add nsw i32 %add, %5
  %idxprom = sext i32 %add8 to i64
  %6 = load float*, float** %B.addr, align 8
  %arrayidx = getelementptr inbounds float, float* %6, i64 %idxprom
  %7 = load float, float* %arrayidx, align 4
  %conv = fpext float %7 to double
  %8 = load i32, i32* %i, align 4
  %mul9 = mul nsw i32 %8, 16384
  %9 = load i32, i32* %j, align 4
  %mul10 = mul nsw i32 %9, 128
  %add11 = add nsw i32 %mul9, %mul10
  %10 = load i32, i32* %k, align 4
  %add12 = add nsw i32 %add11, %10
  %idxprom13 = sext i32 %add12 to i64
  %11 = load float*, float** %B_GPU.addr, align 8
  %arrayidx14 = getelementptr inbounds float, float* %11, i64 %idxprom13
  %12 = load float, float* %arrayidx14, align 4
  %conv15 = fpext float %12 to double
  %call = call float @percentDiff(double %conv, double %conv15)
  %conv16 = fpext float %call to double
  %cmp17 = fcmp ogt double %conv16, 5.000000e-01
  br i1 %cmp17, label %if.then, label %if.end

if.then:                                          ; preds = %for.body.6
  %13 = load i32, i32* %fail, align 4
  %inc = add nsw i32 %13, 1
  store i32 %inc, i32* %fail, align 4
  br label %if.end

if.end:                                           ; preds = %if.then, %for.body.6
  br label %for.inc

for.inc:                                          ; preds = %if.end
  %14 = load i32, i32* %k, align 4
  %inc19 = add nsw i32 %14, 1
  store i32 %inc19, i32* %k, align 4
  br label %for.cond.4

for.end:                                          ; preds = %for.cond.4
  br label %for.inc.20

for.inc.20:                                       ; preds = %for.end
  %15 = load i32, i32* %j, align 4
  %inc21 = add nsw i32 %15, 1
  store i32 %inc21, i32* %j, align 4
  br label %for.cond.1

for.end.22:                                       ; preds = %for.cond.1
  br label %for.inc.23

for.inc.23:                                       ; preds = %for.end.22
  %16 = load i32, i32* %i, align 4
  %inc24 = add nsw i32 %16, 1
  store i32 %inc24, i32* %i, align 4
  br label %for.cond

for.end.25:                                       ; preds = %for.cond
  %17 = load i32, i32* %fail, align 4
  %call26 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([74 x i8], [74 x i8]* @.str.2, i32 0, i32 0), double 5.000000e-01, i32 %17)
  ret void
}

; Function Attrs: nounwind uwtable
define i32 @main(i32 %argc, i8** %argv) #0 {
entry:
  %retval = alloca i32, align 4
  %argc.addr = alloca i32, align 4
  %argv.addr = alloca i8**, align 8
  %tsteps = alloca i32, align 4
  %x = alloca i32, align 4
  %y = alloca i32, align 4
  %z = alloca i32, align 4
  %t_start = alloca double, align 8
  %t_end = alloca double, align 8
  %A = alloca float*, align 8
  %B = alloca float*, align 8
  store i32 0, i32* %retval
  store i32 %argc, i32* %argc.addr, align 4
  store i8** %argv, i8*** %argv.addr, align 8
  store i32 10, i32* %tsteps, align 4
  store i32 128, i32* %x, align 4
  store i32 128, i32* %y, align 4
  store i32 128, i32* %z, align 4
  %call = call noalias i8* @calloc(i64 2628072, i64 4) #3
  %0 = bitcast i8* %call to float*
  store float* %0, float** %A, align 8
  %call1 = call noalias i8* @calloc(i64 2628072, i64 4) #3
  %1 = bitcast i8* %call1 to float*
  store float* %1, float** %B, align 8
  %2 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8
  %call2 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %2, i8* getelementptr inbounds ([29 x i8], [29 x i8]* @.str.3, i32 0, i32 0))
  %3 = load float*, float** %A, align 8
  call void @init(float* %3, i32 138, i32 138, i32 138, i32 5, i32 5, i32 5)
  %call3 = call double @rtclock()
  store double %call3, double* %t_start, align 8
  %4 = load i32, i32* %tsteps, align 4
  %5 = load i32, i32* %x, align 4
  %add = add nsw i32 %5, 10
  %6 = load i32, i32* %y, align 4
  %add4 = add nsw i32 %6, 10
  %7 = load i32, i32* %z, align 4
  %add5 = add nsw i32 %7, 10
  %8 = load float*, float** %A, align 8
  %9 = load float*, float** %B, align 8
  call void @jacobi3d31pt(i32 %4, i32 %add, i32 %add4, i32 %add5, float* %8, float* %9)
  %call6 = call double @rtclock()
  store double %call6, double* %t_end, align 8
  %10 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8
  %11 = load double, double* %t_end, align 8
  %12 = load double, double* %t_start, align 8
  %sub = fsub double %11, %12
  %call7 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %10, i8* getelementptr inbounds ([22 x i8], [22 x i8]* @.str.4, i32 0, i32 0), double %sub)
  %13 = load float*, float** %A, align 8
  %14 = bitcast float* %13 to i8*
  call void @free(i8* %14) #3
  %15 = load float*, float** %B, align 8
  %16 = bitcast float* %15 to i8*
  call void @free(i8* %16) #3
  ret i32 0
}

; Function Attrs: nounwind
declare noalias i8* @calloc(i64, i64) #1

declare i32 @fprintf(%struct._IO_FILE*, i8*, ...) #2

; Function Attrs: nounwind
declare void @free(i8*) #1

attributes #0 = { nounwind uwtable "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+sse,+sse2" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+sse,+sse2" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #2 = { "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+sse,+sse2" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { nounwind }

!llvm.ident = !{!0}

!0 = !{!"clang version 3.7.1 (http://llvm.org/git/clang.git 0dbefa1b83eb90f7a06b5df5df254ce32be3db4b) (http://llvm.org/git/llvm.git 33c352b3eda89abc24e7511d9045fa2e499a42e3)"}
