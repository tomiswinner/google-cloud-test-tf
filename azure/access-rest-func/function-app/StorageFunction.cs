using System;
using System.Collections.Generic;
using System.Net;
using System.Threading.Tasks;
using Azure.Storage.Blobs;
using Azure.Storage.Blobs.Models;
using Microsoft.Azure.Functions.Worker;
using Microsoft.Azure.Functions.Worker.Http;
using Microsoft.Extensions.Logging;

namespace StorageAccessFunction;

public class StorageFunction
{
    private readonly ILogger _logger;

    public StorageFunction(ILoggerFactory loggerFactory)
    {
        _logger = loggerFactory.CreateLogger<StorageFunction>();
    }

    [Function("ListBlobs")]
    public async Task<HttpResponseData> ListBlobs(
        [HttpTrigger(AuthorizationLevel.Function, "get", Route = "blobs/{containerName}")] HttpRequestData req,
        string containerName)
    {
        _logger.LogInformation("Listing blobs in container: {ContainerName}", containerName);

        var connectionString = Environment.GetEnvironmentVariable("StorageConnectionString");
        var blobServiceClient = new BlobServiceClient(connectionString);
        var containerClient = blobServiceClient.GetBlobContainerClient(containerName);

        var response = req.CreateResponse(HttpStatusCode.OK);
        response.Headers.Add("Content-Type", "application/json");

        var blobs = new List<string>();
        await foreach (BlobItem blob in containerClient.GetBlobsAsync())
        {
            blobs.Add(blob.Name);
        }

        await response.WriteAsJsonAsync(new { container = containerName, blobs });
        return response;
    }

    [Function("UploadBlob")]
    public async Task<HttpResponseData> UploadBlob(
        [HttpTrigger(AuthorizationLevel.Function, "post", Route = "blobs/{containerName}/{blobName}")] HttpRequestData req,
        string containerName,
        string blobName)
    {
        _logger.LogInformation("Uploading blob: {BlobName} to container: {ContainerName}", blobName, containerName);

        var connectionString = Environment.GetEnvironmentVariable("StorageConnectionString");
        var blobServiceClient = new BlobServiceClient(connectionString);
        var containerClient = blobServiceClient.GetBlobContainerClient(containerName);
        
        await containerClient.CreateIfNotExistsAsync();
        var blobClient = containerClient.GetBlobClient(blobName);

        await blobClient.UploadAsync(req.Body, overwrite: true);

        var response = req.CreateResponse(HttpStatusCode.Created);
        await response.WriteAsJsonAsync(new { message = "Uploaded", container = containerName, blob = blobName });
        return response;
    }

    [Function("ListContainers")]
    public async Task<HttpResponseData> ListContainers(
        [HttpTrigger(AuthorizationLevel.Function, "get", Route = "containers")] HttpRequestData req)
    {
        _logger.LogInformation("Listing all containers");

        var connectionString = Environment.GetEnvironmentVariable("StorageConnectionString");
        var blobServiceClient = new BlobServiceClient(connectionString);

        var response = req.CreateResponse(HttpStatusCode.OK);
        response.Headers.Add("Content-Type", "application/json");

        var containers = new List<string>();
        await foreach (var container in blobServiceClient.GetBlobContainersAsync())
        {
            containers.Add(container.Name);
        }

        await response.WriteAsJsonAsync(new { containers });
        return response;
    }
}

