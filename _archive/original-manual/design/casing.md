## Casing:

### Hard Rules

* never input emoji characters

### Indentation Conventions

* use 4 spaces for indentation
* maintain relative indentation to source (not to violate it)

### Length

* prefer short symbols (that are still clear) over long ones:

  * not:

    ```swift
    isAnAllowedTypeToSend
    ```

  * but:

    ```swift
    isAllowedType
    ```

### Nesting

* most times in swift we make use of camelcase, but sometimes it doesn't look nice or type nice in APIs

* we therefore may prefer nesting (if we can without exhausting length) or, if really preferred, use snake_case locally instead

* we try to make user-facing APIs clear and descriptive, but not lengthy:

* instead of:

  ```swift
  CostEstimator.estimateCost()
  ```

* we tend to prefer

  ```swift
  CostEstimator.estimate()
  ```

* and sometimes where we have types:

* instead of:

  ```swift
  CostEstimator.estimateTokens()
  ```

* we prefer:

  ```swift
  CostEstimator.estimate.tokens()
  ```

* or, depending on what makes more sense:

  ```swift
  CostEstimator.tokens.estimate()
  ```

* or, if use remains clear:

  ```swift
  CostEstimator.tokens()
  ```

  since Estimator is already in parent symbol

* some decision making for that:

* is there parental clarity, or should we introduce it to clean children symbols up?

* if we nest, which category makes more sense? which do we intuitively order and reason outward from, or alternatively: which do we have neighboring variants of that we can sort it by?

* meaning:

  ```swift
  CostEstimator.tokens.input()
  CostEstimator.tokens.output()
  CostEstimator.tokens.reasoning()
  ```

* only makes sense when there is something planned / a sibling for tokens

* otherwise we should probably do:

  ```swift
  TokenCostEstimator.input()
  TokenCostEstimator.output()
  TokenCostEstimator.reasoning()
  ```

### Codable-intended Enums (actual IO-facing)

For anything IO related, that we must convert, say, from Swift to JSON, or to another interface that requires snake_case conventions, we must try to design this preemptively with alignment.

Meaning we do not want to create elaborate codingkeys or string rawvalue where we can avoid it by simply aligning the symbol itself to the output format.

Example:

```swift
public enum SomeSettingType: String, Sendable, Codable {
    case settingParameter = "setting_parameter"
    case settingParameterDeviating = "setting_parameter_deviating"
    case alternativeSetting = "alt_setting"
}
```

Is not to our liking. Instead we prefer:

```swift
public enum SomeSettingType: String, Sendable, Codable {
    case setting_parameter
    case setting_parameter_deviating
    case alt_setting
}
```

So that we implicitly align with other interfaces without extra work that buys us little..
