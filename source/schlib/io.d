module schlib.io;
import core.interpolation;

auto writef(Args...)(InterpolationHeader, Args args, InterpolationFooter)
{
    import std.meta;
    enum formatStr = () {
        string fmt = "";
        bool hasArg = false;
        static void doNothing(const(char)[] data) {}
        static foreach(a; Args)
        {{
            static if(is(a == InterpolatedExpression!(S), string S))
            {
                if(hasArg) {
                    // prev arg yet handled
                    fmt ~= "%s";
                }
                hasArg = true;
            }
            static if(is(a == InterpolatedLiteral!(S), string S))
            {
                if(!hasArg || (hasArg && S.length > 1 && S[0] == '%' && S[1] != '%'))
                {
                    // TODO, escape %
                    fmt ~= S;
                }
                else
                {
                    // no specific formatting, use the default.
                    if(hasArg)
                        fmt ~= "%s";
                    fmt ~= S;
                }
                hasArg = false;
            }
        }}
        if(hasArg)
            fmt ~= "%s";
        return fmt;
    }();
    //pragma(msg, formatStr);

    enum argsMixin = () {
        string result = "";
        static foreach(size_t idx; 0 .. Args.length)
        {{
            static if(!is(Args[idx] == InterpolatedExpression!(S), string S) && !is(Args[idx] == InterpolatedLiteral!(S), string S))
                result ~= "args[" ~ idx.stringof ~ "],";
        }}
        return result;
    }();

    static import std.stdio;
    return std.stdio.writef!formatStr(mixin("AliasSeq!(", argsMixin, ")"));
}

unittest {
    int val = 12345;
    writef(i"here is some hex: $(val)%x\n");
    writef(i"here is some hex: $(12345)%x\n");
}

unittest {
    static import std.stdio;
    string name = "Joe";
    int age = 42;
    std.stdio.writef("Hello, %s, your age in hex is %x\n", name, age);
    // with better writef
    writef(i"Hello, $(name), your age in hex is $(age)%x\n");
}

