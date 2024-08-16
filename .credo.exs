%{
  configs: [
    %{
      name: "default",
      files: %{
        included: ["lib/", "src/", "test/"],
        excluded: [~r"/_build/", ~r"/deps/"]
      },
      requires: [],
      strict: true,
      color: true,
      checks: [
        # Disable checks
        {Credo.Check.Readability.ModuleDoc, false},
        {Credo.Check.Warning.NameRedeclarationByAssignment, false},

        # Set priority for checks
        {Credo.Check.Refactor.Nesting, priority: :low},
        {Credo.Check.Design.DuplicatedCode, priority: :high},

        # Configure checks
        {Credo.Check.Consistency.LineEndings, []},
        {Credo.Check.Readability.MaxLineLength, max_length: 100},
        {Credo.Check.Readability.ModuleDoc, false},
      ]
    }
  ]
}
