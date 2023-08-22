#Include <Coroutine\Coroutine>

class ObjS{
	Yield(vl){

	}
}
class Action1 extends ObjS{
	func1(){  ;Return a7 in Fibonacci array.
		a1:=0,a2:=1
		loop 5{
			a:=a1+a2
			,this.Yield(a)
			a1:=a2,a2:=a
		}
		return a
	}
}

SumN2(arr){
	s:=0
	for i,x in arr{
		s+=x**2
	}
	return s
}
cc:=Action1()
OutputDebug('a7 in Fibonacci array:   ' cc.func1())
fc:=CoroutineIter(cc,'func1')
; Persistent()
; DllCall("CreateThread", "ptr", 0, "uint", 0, "ptr", CallbackCreate(()=>SumN2(fc)), "ptr", 0, "ptr", 0, "uint", 0)
s:=SumN2(fc)
outputdebug('CoroutineSUM: ' s)
