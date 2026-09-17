var builder = WebApplication.CreateBuilder(args);
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();
builder.Services.AddCors(options =>
{
    options.AddDefaultPolicy(policy =>
        policy.AllowAnyOrigin()
              .AllowAnyHeader()
              .AllowAnyMethod());
});

var app = builder.Build();

// Swagger is available in Docker as well as locally for this exercise.
app.UseSwagger();
app.UseSwaggerUI();
app.UseCors();

var minions = new[]
{
    // Made the most popular minions
    new Minion(1, "Kevin", "Leader"),
    new Minion(2, "Stuart", "Musician"),
    new Minion(3, "Bob", "Teddy bear enthusiast"),
};

app.MapGet("/api/minions", () => TypedResults.Ok(minions));
app.MapGet("/healthz", () => TypedResults.Ok(new { status = "ok" }));

app.Run();

record Minion(int Id, string Name, string Role);
