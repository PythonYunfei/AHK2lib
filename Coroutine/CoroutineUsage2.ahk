#Include Coroutine.ahk
class ObjS {
	Yield(vl){

	}
}
class Sum extends ObjS{
	SumN2(arr){
		s:=0
		for i,x in arr{
			this.Yield(&x)
			s+=x**2
		}
		; this.Yield(s)
		this.Yield(&s)
		return s
	}
}
SumN3(arr){  ;only for example
	for &x in arr{
		; if not x is VarRef{
		; 	return x
		; }
		; %x%:=%x%**(3/2)
		x:=x**(3/2)
	}
}
cc:=Sum()
s0:=cc.SumN2([1,2,3])
OutputDebug("SumN2:  " s0)
fc:=CoroutineIter(cc,'SumN2',[1,2,3])
s:=SumN3(fc)
OutputDebug("SumN3:   " s)
