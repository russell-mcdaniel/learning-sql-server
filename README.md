# Learning SQL Server

This repository contains a collection of projects, code, and information illustrating various SQL Server features and practices. The details of implementations and practices are often subjective and as such, this content simply reflects my own experience and opinions. Yours may vary and feedback is welcome (see below).

Because SQL Server is my primary area of expertise*, this repository maintains a different posture compared to the other "learning" repositories in my account. The other repositories generally represent introductory experiments in areas I needed or wanted to explore at the time due to project tasks or simply my own curiosity.

Despite its name, this repository is not intended to provide a structured resource for beginners. However, over time I hope to be able to provide content for all levels of SQL Server practitioners. SQL Server is a large and continually growing platform, so there is *always* more to learn.

\* <sub>I use the term "expert" loosely. The real experts can be [found here](../../wiki/Experts).</sub>

# Getting Started

Clone the repository.

Configure the Docker container for SQL Server.

1. **Configure the `sa` password.**

   Create a file named `mssql-password.env` under `/platform/docker/config`.

   Add the following line to the file replacing `{password}` with a strong password for the `sa` account for the SQL Server instance.

   ```
   SA_PASSWORD={password}
   ```

   **NOTE:** This file is included in `.gitignore` so that the password is not included in the repository.

1. **Start the container.**

   From a PowerShell command prompt, start the container:

   ```
   > .\Start.ps1
   ```

   The SQL Server instance is exposed on its default port (`1433`). You can connect to it using SQL Server Management Studio or your preferred client using the administrator account (`sa`) and the password configured above.

1. **Configure data volume permissions.**

   The container uses custom volumes and configures custom paths for SQL Server within those volumes. The former helps preserve data across container instances. The latter prevents a path conflict during creation of the SQL Server system databases when using a custom volume configuration.

   Finally, to be able to create databases, the SQL Server process user must be granted ownership of the `mssql` folder and its children on the custom volume.

   From a PowerShell command prompt, execute this command:

   ```
   > docker exec -u 0 learning-sql-server-mssql-1 bash -c "chown -Rv mssql /var/opt/lss/mssql"
   ```

Now you're ready to deploy [the database](../../wiki/Learning-Database).

# More Information

Guidance, notes, and additional resources can be found on [the wiki](../../wiki).

To provide feedback and make requests, feel free to create [an issue](../../issues).
