import Guidelines

print("typed reference:", Something.string.reference)

do {
    try throwConceptViolation()
} catch let violation as GuidelineViolationError {
    print("caught violation:", violation)
    print("reference:", violation.reference)
    print("reasoning:", violation.reasoning ?? "nil")
} catch {
    print("unexpected error:", error)
}
