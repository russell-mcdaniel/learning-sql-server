# learning-sql-server

A learning project for SQL Server.

# Introduction

This repository contains a collection of projects and tools illustrating various SQL Server features and functionality.

Because SQL Server is my primary area of expertise, this repository maintains a different posture compared to the other "learning" repositories in my account. These other repositories generally represent introductory experiments in areas I needed or wanted to explore at the time due to work tasks or simply my own curiosity.

Despite its name, this repository is not intended to provide a structured resource for beginners, although it may contain useful materials to that end nonetheless.

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

By default, the SQL Server instance is exposed on its default port (`1433`). You should be able to connect to it using SQL Server Management Studio or your preferred client using the administrator account (`sa`) and the password configured above.

The container uses custom volumes and custom paths within those volumes. The former makes it easier to preserve data across container instances. The latter prevents a path conflict when SQL Server attempts to create the system databases upon creation of the container when using a custom volume configuration.

# More Information

Notes, references, and additional content is gathered on [the wiki](../../wiki).

To provide feedback and make requests, feel free to create [an issue](../../issues).
