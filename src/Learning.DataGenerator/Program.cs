using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Learning.DataGenerator;
using Learning.DataGenerator.Data;

using var host = Host.CreateDefaultBuilder(args)
    .ConfigureServices((context, services) =>
    {
            services.AddSingleton<IEntityRepository, EntityRepository>();
            services.AddHostedService<Generator>();
        })
    .Build();

await host.RunAsync();
