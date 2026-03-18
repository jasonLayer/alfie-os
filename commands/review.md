Review the current branch changes using Compound Engineering's multi-agent review.

## Core Engine

**Invoke the Compound Engineering review skill now:**

```
skill: compound-engineering:ce-review
args: $ARGUMENTS
```

Follow the CE review process completely — target determination, worktree setup, parallel review agents, ultra-thinking deep dive, simplification review, findings synthesis, and todo creation. The CE engine handles all of this.

## Alfie Addition: Definition of Done Check

After the CE review completes, also verify these Alfie-specific items:
- [ ] TDD was followed? (tests exist for all new production code)
- [ ] Auth/access constraints verified (if applicable)?
- [ ] At least 1 learning codified in docs/ (if applicable)?
- [ ] Release notes ready (if applicable)?

Flag any missing items as P2 findings.
