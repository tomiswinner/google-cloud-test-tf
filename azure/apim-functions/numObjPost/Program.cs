using Microsoft.Azure.Functions.Worker;
using Microsoft.Azure.Functions.Worker.Http;
using Microsoft.Extensions.Hosting;
using System.Text.Json;

var host = new HostBuilder()
    .ConfigureFunctionsWorkerDefaults()
    .Build();

host.Run();

public class NumberPostFunction
{
    [Function("NumberPost")]
    public async Task<HttpResponseData> Run(
        [HttpTrigger(AuthorizationLevel.Anonymous, "post")] HttpRequestData req,
        FunctionContext executionContext)
    {
        var response = req.CreateResponse(System.Net.HttpStatusCode.OK);
        response.Headers.Add("Content-Type", "application/json; charset=utf-8");

        var requestBody = await new StreamReader(req.Body).ReadToEndAsync();
        var number = JsonSerializer.Deserialize<double>(requestBody);

        var result = new { value = number };
        var json = JsonSerializer.Serialize(result);
        response.WriteString(json);

        return response;
    }
}

public class ObjectPostFunction
{
    [Function("ObjectPost")]
    public async Task<HttpResponseData> Run(
        [HttpTrigger(AuthorizationLevel.Anonymous, "post")] HttpRequestData req,
        FunctionContext executionContext)
    {
        var response = req.CreateResponse(System.Net.HttpStatusCode.OK);
        response.Headers.Add("Content-Type", "application/json; charset=utf-8");

        var requestBody = await new StreamReader(req.Body).ReadToEndAsync();
        var obj = JsonSerializer.Deserialize<RequestObject>(requestBody);

        var result = new { data = obj?.Data };
        var json = JsonSerializer.Serialize(result);
        response.WriteString(json);

        return response;
    }
}

public class RequestObject
{
    public DataObject? Data { get; set; }
}

public class DataObject
{
    public string? String { get; set; }
    public int? Integer { get; set; }
}

public class BoolPostFunction
{
    [Function("BoolPost")]
    public async Task<HttpResponseData> Run(
        [HttpTrigger(AuthorizationLevel.Anonymous, "post")] HttpRequestData req,
        FunctionContext executionContext)
    {
        var response = req.CreateResponse(System.Net.HttpStatusCode.OK);
        response.Headers.Add("Content-Type", "application/json; charset=utf-8");

        var requestBody = await new StreamReader(req.Body).ReadToEndAsync();
        var requestObj = JsonSerializer.Deserialize<BoolRequest>(requestBody);

        var result = new { value = requestObj?.Value };
        var json = JsonSerializer.Serialize(result);
        response.WriteString(json);

        return response;
    }
}

public class BoolRequest
{
    public bool? Value { get; set; }
}

public class ArrPostFunction
{
    [Function("ArrPost")]
    public async Task<HttpResponseData> Run(
        [HttpTrigger(AuthorizationLevel.Anonymous, "post")] HttpRequestData req,
        FunctionContext executionContext)
    {
        var response = req.CreateResponse(System.Net.HttpStatusCode.OK);
        response.Headers.Add("Content-Type", "application/json; charset=utf-8");

        var requestBody = await new StreamReader(req.Body).ReadToEndAsync();
        var requestObj = JsonSerializer.Deserialize<ArrayRequest>(requestBody);

        var result = new { value = requestObj?.Value };
        var json = JsonSerializer.Serialize(result);
        response.WriteString(json);

        return response;
    }
}

public class ArrayRequest
{
    public string[]? Value { get; set; }
}

public class DeleteFunction
{
    [Function("Delete")]
    public async Task<HttpResponseData> Run(
        [HttpTrigger(AuthorizationLevel.Anonymous, "delete")] HttpRequestData req,
        FunctionContext executionContext)
    {
        var response = req.CreateResponse(System.Net.HttpStatusCode.OK);
        response.Headers.Add("Content-Type", "application/json; charset=utf-8");

        var requestBody = await new StreamReader(req.Body).ReadToEndAsync();
        var requestObj = JsonSerializer.Deserialize<StringRequest>(requestBody);

        var result = new { value = requestObj?.Value };
        var json = JsonSerializer.Serialize(result);
        response.WriteString(json);

        return response;
    }
}

public class PatchFunction
{
    [Function("Patch")]
    public async Task<HttpResponseData> Run(
        [HttpTrigger(AuthorizationLevel.Anonymous, "patch")] HttpRequestData req,
        FunctionContext executionContext)
    {
        var response = req.CreateResponse(System.Net.HttpStatusCode.OK);
        response.Headers.Add("Content-Type", "application/json; charset=utf-8");

        var requestBody = await new StreamReader(req.Body).ReadToEndAsync();
        var requestObj = JsonSerializer.Deserialize<StringRequest>(requestBody);

        var result = new { value = requestObj?.Value };
        var json = JsonSerializer.Serialize(result);
        response.WriteString(json);

        return response;
    }
}

public class StringRequest
{
    public string? Value { get; set; }
}

public class StrPostFunction
{
    [Function("StrPost")]
    public async Task<HttpResponseData> Run(
        [HttpTrigger(AuthorizationLevel.Anonymous, "post")] HttpRequestData req,
        FunctionContext executionContext)
    {
        var response = req.CreateResponse(System.Net.HttpStatusCode.OK);
        response.Headers.Add("Content-Type", "application/json; charset=utf-8");

        var requestBody = await new StreamReader(req.Body).ReadToEndAsync();
        var requestObj = JsonSerializer.Deserialize<StringRequest>(requestBody);

        var result = new { value = requestObj?.Value };
        var json = JsonSerializer.Serialize(result);
        response.WriteString(json);

        return response;
    }
}

