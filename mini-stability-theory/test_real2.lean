import Init
def test : Float := (0 : Float)
def cmp (x y : Float) : Bool := x > y
#eval test
#eval cmp (3 : Float) (2 : Float)
