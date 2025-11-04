using Microsoft.Azure.Functions.Worker;
using Microsoft.Azure.Functions.Worker.Http;
using Microsoft.DurableTask;
using Microsoft.DurableTask.Client;
using System.Net;

namespace function_app;

public static class HelloWorldHttpStart
{
    [Function("HelloWorldHttpStart")]
    public static async Task<HttpResponseData> Run(
        [HttpTrigger(AuthorizationLevel.Anonymous, "get", "post")] HttpRequestData req,
        [DurableClient] DurableTaskClient client,
        FunctionContext executionContext)
    {
        // オーケストレーションを開始
        string instanceId = await client.ScheduleNewOrchestrationInstanceAsync(
            nameof(HelloWorldOrchestrator));

        // レスポンスを作成
        var response = req.CreateResponse(HttpStatusCode.OK);
        response.Headers.Add("Content-Type", "application/json");
        
        var responseBody = new
        {
            instanceId = instanceId,
            statusQueryGetUri = client.CreateCheckStatusResponse(req, instanceId).Headers.GetValues("Location").FirstOrDefault()
        };

        await response.WriteStringAsync(System.Text.Json.JsonSerializer.Serialize(responseBody));

        return response;
    }
}
