from cpython.ref cimport PyObject, Py_INCREF, Py_DECREF

def getcallingfunction():
   import sys
   return sys._getframe(1).f_code
   
def getgc():
   import gc
   return gc.get_objects()
   
def getloadedmodules():
  import gc, types
  modules = []
  for modul in gc.get_objects():
      if isinstance(modul, types.ModuleType):
         try:
             modules.append(modul.__name__)
         except Exception:
             pass
  return modules



cpdef object get_from_id(size_t addr):
  cdef PyObject* ptr = <PyObject*> addr

  if ptr != NULL:
    return <object>ptr
  else:
    return None
