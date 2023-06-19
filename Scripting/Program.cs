// See https://aka.ms/new-console-template for more information

using System.Collections.Concurrent;

var events = new ConcurrentDictionary<int, string>();
var client = new HttpClient();

async Task SendRequest(int i)
{
    var data = await client.GetAsync("http://localhost:8080");
    events.TryAdd(i, await data.Content.ReadAsStringAsync());
}


var tasks = new List<Task>();
for (int i = 0; i < 200; i++)
{
    tasks.Add(SendRequest(i));

}

await Task.WhenAll(tasks);
Console.WriteLine($"Count Requests for first server: {events.Count(x => x.Value == "First Server")}");
Console.WriteLine($"Count Requests for second server: {events.Count(x => x.Value == "Second Server")}");
