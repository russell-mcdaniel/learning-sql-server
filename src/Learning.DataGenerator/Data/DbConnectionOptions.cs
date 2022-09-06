namespace Learning.DataGenerator.Data
{
    /// <summary>
    /// 
    /// </summary>
    /// <remarks>
    /// At the time of implementation, there is no consensus for how to cleanly
    /// resolve CS8618 for the class properties. See discussion:
    /// 
    /// https://stackoverflow.com/questions/58086779/nullable-reference-types-and-the-options-pattern
    ///
    /// C# 11 in .NET 7 will have a "required" modifier for properties to resolve this.
    /// </remarks>
    public class DbConnectionOptions
    {
        public string DataSource { get; set; }

        public string InitialCatalog { get; set; }

        public string Password { get; set; }

        public string UserID { get; set; }
    }
}
