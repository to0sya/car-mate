using Microsoft.AspNetCore.Identity.Data;
using Newtonsoft.Json;
using Npgsql;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddCors();
 
// Add services to the container.
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();


app.UseCors(build => build
    .AllowAnyOrigin()
    .AllowAnyMethod()
    .AllowAnyHeader()
);


// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();



string userLogin = "admin";
string userPassword = "1111";

app.MapGet("/user/login", (string login, string password, HttpContext context) =>
{
    if (login.Equals(userLogin) && password.Equals(userPassword))
    {
        context.Response.StatusCode = StatusCodes.Status200OK;
        return JsonConvert.SerializeObject(new { success = true });
    }

    context.Response.StatusCode = StatusCodes.Status401Unauthorized;
    return JsonConvert.SerializeObject(new { success = false });

}).WithOpenApi();

app.MapGet("/user/expenses", () =>
{
    List<dynamic> expenses = new List<dynamic>();
    
    using (var connection =
           new NpgsqlConnection(
               "Host=localhost;Port=5432;Database=car_mate;Username=postgres;Password=1111;IncludeErrorDetail=true;"))
    {
        connection.Open();
        using (var command = new NpgsqlCommand("SELECT type, cost, expense_date FROM expenses;", connection))
        {
            using (var reader = command.ExecuteReader())
            {
                while (reader.Read())
                {
                    expenses.Add(new
                    {
                        type = reader.GetString(0),
                        cost = reader.GetDecimal(1),
                        expense_date = DateOnly.FromDateTime(reader.GetDateTime(2))
                    });
                }
            }
        }
    }

    return expenses;
});



app.MapPost("/user/expenses", (string type, double cost, string date) =>
{
    using (var connection =
           new NpgsqlConnection(
               "Host=localhost;Port=5432;Database=car_mate;Username=postgres;Password=1111;IncludeErrorDetail=true;"))
    {
        connection.Open();
        using (var command = new NpgsqlCommand(@"INSERT INTO expenses(type, cost, expense_date) 
                                                        VALUES(@type, @cost, @date)", connection))
        {
            command.Parameters.AddWithValue("@type", type);
            command.Parameters.AddWithValue("@cost", cost);
            command.Parameters.AddWithValue("@date", DateOnly.Parse(date));

            command.ExecuteNonQuery();
        }
    }

    return JsonConvert.SerializeObject(new { success = true });
});

app.Run();