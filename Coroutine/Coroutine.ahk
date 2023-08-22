

class CoroutineIter {
	__New(obj,fn,args*) {
		this.obj:=obj
		,this.fn:=obj.GetMethod(fn).Bind(,args*)
		,this.args:=args
	}
	__Enum(num) {
		obj:=this.obj
		,fn:=this.fn
		,args:=this.args
		,gn:=[gn1,gn2]
		,cv1:=Buffer(A_PtrSize)
		,DllCall('InitializeConditionVariable','ptr',cv1)
		,cv2:=Buffer(A_PtrSize)
		,DllCall('InitializeConditionVariable','ptr',cv2)
		,csL:=Buffer(3*A_PtrSize+24)
		,DllCall('InitializeCriticalSection','ptr',csL)
		,x0:=unset
		,hasnext:=1
		,yieldFn:=yieldBegin
		,gnFn:=gnBegin
		,t:=0
		gnBegin(){
			DllCall('EnterCriticalSection','ptr',csL)
			,gnFn:=gnNormal
			,Sleep(-1)
			,DllCall("CreateThread", "ptr", 0, "uint", 0, "ptr", CallbackCreate(thread2), "ptr", 0, "ptr", 0, "uint", 0)
			,DllCall('SleepConditionVariableCS','ptr',cv1,'ptr',csL,'uint',-1)
			,DllCall('EnterCriticalSection','ptr',csL)
		}
		yieldBegin(){
			DllCall('EnterCriticalSection','ptr',csL)
			,yieldFn:=yieldNormal
			,DllCall('WakeConditionVariable','ptr',cv1)
			,DllCall('SleepConditionVariableCS','ptr',cv2,'ptr',csL,'uint',-1)
			,DllCall('EnterCriticalSection','ptr',csL)
		}
		gnNormal(){
			DllCall('LeaveCriticalSection','ptr',csL)
			,DllCall('WakeConditionVariable','ptr',cv2)
			,DllCall('SleepConditionVariableCS','ptr',cv1,'ptr',csL,'uint',-1)
			,DllCall('EnterCriticalSection','ptr',csL)
		}
		yieldNormal(){
			DllCall('LeaveCriticalSection','ptr',csL)
			,DllCall('WakeConditionVariable','ptr',cv1)
			,DllCall('SleepConditionVariableCS','ptr',cv2,'ptr',csL,'uint',-1)
			,DllCall('EnterCriticalSection','ptr',csL)
		}
		yield(ths,vl){
			x0:=vl
			,yieldFn()
		}
		gn1(&x){
			gnFn()
			,x:=x0
			return hasnext
		}
		gn2(&i,&x){
			gnFn()
			,x:=x0
			,i:=++t
			return hasnext
		}
		thread2(){
			_:=0
			,fn({yield:yield,base:obj})
			,hasnext:=0
			,DllCall('LeaveCriticalSection','ptr',csL)
			,DllCall('WakeConditionVariable','ptr',cv1)
			,DllCall('SleepConditionVariableCS','ptr',cv2,'ptr',csL,'uint',1)
		}
		return gn[num]
	}
}




