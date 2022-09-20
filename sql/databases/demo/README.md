# Demo Database

This database demonstrates focused examples of SQL and SQL Server functionality.

## Design Patterns

### Gaps and Islands

TBD

### Trees and Hierarchies

Objects in the `Tree` schema demonstrate common approaches for modeling and querying hierarchies.

The subject area is product categories for a retail store.

Object names are prefixed with a code that identifies the approach.

* AL = Adjacency List
* CT = Closure Table
* MP = Materialized Path
* NS = Nested Set

#### Use Cases

The following uses cases are implemented for each approach:

| AL | CT | MP | NS | Use Case |
|----|----|----|----|----------|
| :heavy_check_mark: |    |    |    | Get the path for a category. |
| :heavy_check_mark: |    |    |    | Get the path for all categories. |
| :heavy_check_mark: |    |    |    | Get the immediate children of a category. |
| :heavy_check_mark: |    |    |    | Get all children of a category.
| :heavy_check_mark: |    |    |    | Get the parent of a category. |
| :heavy_check_mark: |    |    |    | Insert a category. |
| :heavy_check_mark: |    |    |    | Move a category. |
| :heavy_check_mark: |    |    |    | Delete a category including children. |
| :heavy_check_mark: |    |    |    | Delete a category promoting children. |

Some use cases may have variants that are not covered. Each application often has unique requirements that call for distinct behavior.

#### References

See the [Data Modeling](../../../wiki/Data-Modeling) page in the wiki.
