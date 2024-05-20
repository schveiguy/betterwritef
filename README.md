# Better Writef

This library is a small wrapper around `std.stdio.writef` that uses compile time rewrites to call writef with the given parameters and the correct format string.

Best demonstrated with an example:

```d
import std.stdio;
import schlib.io;

void main()
{
    string name = "Joe";
    int age = 42;
    writef("Hello, %s, your age in hex is %x\n", name, age);
    // with better writef
    writef(i"Hello, $(name), your age in hex is $(age)%x\n");
}
```

Note that the format string is passed at compile time always, so you will get compiler errors for malformed strings.

Also note that only writef is overloaded for now. If this becomes more popular, I might add the others.
