import sys
import warnings
def hooktrace(func, traceName, onFire):
    if hasattr(func, "__code__"):
      def fortrace(frame, event, arg):
          if event == traceName and func.__code__ == frame.f_code:
              # arg → what return event 'return'
              onFire(arg, frame.f_code)
          return fortrace
      sys.settrace(fortrace)
    else:
        warnings.warn("This feature is not yet available on C functions")

def test():
    return "called"

def te(a, code):
    print("Detected", a, code.co_name)
hooktrace(test, "return", te)
a = test() # Detect called test
