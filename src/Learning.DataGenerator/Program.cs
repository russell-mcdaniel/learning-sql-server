using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Learning.DataGenerator;
using Learning.DataGenerator.Data;
using Learning.DataGenerator.Generators;

using var host = Host.CreateDefaultBuilder(args)
    .ConfigureServices((context, services) =>
    {
        services.Configure<GeneratorOptions>(
            context.Configuration.GetSection("Generator"));

        services.AddSingleton<IEntityRepository, EntityRepository>();
        services.AddSingleton<IGenerator, Generator>();
        services.AddHostedService<GeneratorService>();
    })
    .Build();

await host.RunAsync();
