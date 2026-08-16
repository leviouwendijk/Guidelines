## On snake or camel:

As stated before, although camelCase is very swift-ly, we can prefer snake_case when:

1. it makes the call site more ergonomic, or look better
2. there is a local pattern we'd like to keep
3. the functions are more 'internal' facing (sometimes i then purposefully distinguish them in one file) -- but this does not mean that they cannot be public-facing
4. (important): it makes integration with other interfaces easier (we may desire snake case in Codable situations where we'd otherwise need to add an extra rawvalue string by hand). If we can avoid that, this improves alignment, homogeneity, and ergonomics.
