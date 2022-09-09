namespace Learning.DataGenerator.Core
{
    /// <summary>
    /// Provides AddRange() on IList<T>.
    /// </summary>
    /// <remarks>
    /// Regarding lack of AddRange() on IList<T>:
    /// https://stackoverflow.com/questions/11538259/why-doesnt-ilist-support-addrange
    /// https://stackoverflow.com/questions/13158121/how-to-add-a-range-of-items-to-an-ilist
    /// https://stackoverflow.com/questions/69441825/why-is-addrange-missing-in-ienumerable-icollection-ilist
    /// </remarks>
    internal static class IListExtensions
    {
        internal static void AddRange<T>(this IList<T> list, IEnumerable<T> items)
        {
            if (list is null)
                throw new ArgumentNullException(nameof(list));

            if (items is null)
                throw new ArgumentNullException(nameof(items));

            if (list is List<T> asList)
            {
                asList.AddRange(items);
            }
            else
            {
                foreach (var item in items)
                {
                    list.Add(item);
                }
            }
        }
    }
}
