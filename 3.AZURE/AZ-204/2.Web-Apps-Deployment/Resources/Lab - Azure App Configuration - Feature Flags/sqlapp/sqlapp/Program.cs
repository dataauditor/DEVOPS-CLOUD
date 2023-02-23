using sqlapp.Services;
using Microsoft.FeatureManagement;

var builder = WebApplication.CreateBuilder(args);

var connectionString = "Endpoint=https://appconfig1000233.azconfig.io;Id=E0j2-l8-s0:ywglWz9a/tngma/7q5/S;Secret=QA16TLCFkzE7j+BmvBnm/zlC2VJ/X4HqViAuA/PMHeQ=";

builder.Host.ConfigureAppConfiguration(builder =>
{
    //Connect to your App Config Store using the connection string
    builder.AddAzureAppConfiguration(options =>
                    options.Connect(connectionString).UseFeatureFlags());
});


builder.Services.AddTransient<IProductService, ProductService>();

builder.Services.AddRazorPages();
builder.Services.AddFeatureManagement();
var app = builder.Build();



// Configure the HTTP request pipeline.
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Error");
    // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
    app.UseHsts();
}


app.UseHttpsRedirection();
app.UseStaticFiles();

app.UseRouting();

app.UseAuthorization();

app.MapRazorPages();

app.Run();
