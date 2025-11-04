using Microsoft.Azure.Functions.Worker;
using Microsoft.DurableTask;

namespace function_app;

public static class HelloWorldOrchestrator
{
    [Function(nameof(HelloWorldOrchestrator))]
    public static async Task<string> RunOrchestrator([OrchestrationTrigger] TaskOrchestrationContext context)
    {
        // アクティビティ関数を呼び出して "Hello World" を生成
        var result = await context.CallActivityAsync<string>(nameof(HelloWorldActivity.SayHello), "World");
        
        return result;
    }
}
