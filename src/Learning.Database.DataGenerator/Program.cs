using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Learning.Database.DataGenerator;
using Learning.Database.DataGenerator.Data;

using var host = Host.CreateDefaultBuilder(args)
    .ConfigureServices((context, services) =>
    {
            services.AddSingleton<IEntityRepository, EntityRepository>();
            services.AddHostedService<Generator>();
        })
    .Build();

await host.RunAsync();
