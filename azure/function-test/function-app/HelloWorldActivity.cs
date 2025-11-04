using Microsoft.Azure.Functions.Worker;
using Microsoft.DurableTask;

namespace function_app;

public static class HelloWorldActivity
{
    [Function(nameof(SayHello))]
    public static string SayHello([ActivityTrigger] string name)
    {
        return $"Hello {name}!";
    }
}
