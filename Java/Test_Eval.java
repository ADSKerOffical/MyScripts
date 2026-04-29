import javax.script.ScriptEngine;
import javax.script.ScriptEngineManager;
import javax.script.ScriptException;

public class Main {
	public static String eval(String full_example) {
	    try {
          ScriptEngineManager manager = new ScriptEngineManager();
          ScriptEngine engine = manager.getEngineByName("JavaScript");
          Object obj = engine.eval(full_example);
          return String.valueOf(obj);
	    } catch (ScriptException e) {
	        return "nan";
	    }
	}
	public static void main(String[] args) {
	    System.out.print(eval("2 + 7 * 2"));
	}
}
