---
name: creating-pr-description
description: Systematic workflow for filling out PR templates with complete documentation and analysis
---

# Creating PR Descriptions

This skill guides you through filling out pull request templates that follow best practices and include all required information. Assumes the PR has been created manually (usually as a draft) and needs a complete description.

## Prerequisites

- Authenticated `gh` CLI access
- Access to `.github/PULL_REQUEST_TEMPLATE.md`
- Draft PR already created (or branch ready for PR)
- PR number from the draft PR

## Core Principles

1. **Fetch Data First**: Use the fetch-pr-data skill to gather all information
2. **Systematic Analysis**: Analyze code changes before writing descriptions
3. **Template Preservation**: Maintain exact template structure (1:1 copy)
4. **Reference Guidelines**: Read impact and test plan guidelines before writing
5. **Complete Information**: Never skip sections, mark "N/A" if not applicable

## Workflow Steps

### Step 1: Get the Template

Copy the PR template to work with:
```bash
cp .github/PULL_REQUEST_TEMPLATE.md pr-description.txt
```

**Why**: Working with a copy prevents accidental template modifications.

### Step 2: Create Draft PR (if needed)

If you haven't created the PR yet:
```bash
gh pr create --draft \
  --title "WIP: [Brief Description]" \
  --body "Draft PR - filling out template" \
  > draft_pr_info.txt && cat draft_pr_info.txt
```

**Important**:
- Use `--base BRANCH_NAME` if targeting non-main branch
- The PR number will be in `draft_pr_info.txt`
- Write output to file first, then read it (terminal can be unreliable)

### Step 3: Fetch PR Data

**IF NEEDED: Use the `fetch-pr-data` skill** to gather all PR information. This will create files:
- `pr_{pr_number}_info.json` - PR details, files, reviews
- `pr_{pr_number}_diff.txt` - Complete code diff
- `pr_{pr_number}_review_comments.json` - Inline comments
- `pr_{pr_number}_diff_stats.txt` - Change statistics
- `pr_{pr_number}_checks.txt` - CI status

See the fetch-pr-data skill for detailed information on what each file contains and how to use it.

### Step 4: Analyze Code Changes

Based on gathered information, systematically analyze:

**Scope Analysis**:
- Number of files changed
- Total lines added/removed
- Affected directories/modules

**Type Classification**:
- New features (adds new capabilities)
- Bug fixes (corrects existing functionality)
- Refactoring (improves code without changing behavior)
- Tests (adds or modifies tests)
- Documentation (updates docs)

**Risk Assessment**:
- Core systems affected?
- Database migrations?
- API contract changes?
- Backward compatibility concerns?

**Customer Impact**:
- User-facing changes?
- Internal/developer-only changes?
- Performance implications?
- Security considerations?

### Step 5: Fill Standard Sections

Fill these sections based on your analysis:

**Summary**:
- Write 2-3 sentences explaining what and why
- Reference commit messages and file changes
- Be specific about the problem solved

**Jira Task**:
- Use provided ticket URL, or
- Write "No ticket needed" with brief justification

**Public Release Notes**:
- If customer-facing: Write concise user-facing description
- If internal: Write "No customer-facing changes"

**Release Change Category**:
Select exactly one:
- [1] Internal Only - Tests, build scripts, refactoring, tooling
- [2] Bug Fix - Fixes existing functionality, errors, performance
- [3] New Feature - Adds new user-facing capabilities
- [4] Feature Enhancement - Improves existing features
- [5] Feature Deprecated - Removes functionality
- [6] Not Needed - No customer impact

**Behind Feature Flag**:
Scan code for feature flag patterns:
- `featureFlag`, `feature-flag`, `FeatureFlag`
- Configuration files with flag definitions
- Conditional rendering based on flags
- Environment-specific toggles

Check these locations:
- `environments/common/npm/feature-flags/src/types.ts` - Flag names
- `environments/common/npm/feature-flags/src/flags.ts` - DevelopmentOnly/Experimental

Select one:
- [1] Yes - With Feature Flag (list flag names)
- [2] Partial - Some changes behind flag
- [3] No - Not using feature flag

**Feature Flags**:
- List found flags, or
- Write "None"

**Checkboxes**:
Auto-tick relevant boxes based on your changes:
- Tests added/updated?
- Documentation updated?
- Backward compatible?
- Database migrations?

### Step 6: Write Impact Analysis

**CRITICAL**: Read the impact analysis guidelines first:

[How to write impact analysis](environments/rulebank/general/impact-analysis.md)
[How to access the impact level](environments/rulebank/general/impact-level.md)


Based on guidelines, write impact analysis with length appropriate to level:
- **Low Impact** (A paragraph): Minor changes, well-isolated
- **Medium Impact** (2-3 paragraph): Moderate changes, some dependencies
- **High Impact** (Depends on change, be explicit but not verbose): Major changes, system-wide effects
Note that behind FF always suggests a lower impact level since it has limited visibility to customers.

Select impact level:
- [ ] 1 - High: Core system changes, significant risk
- [ ] 2 - Medium: Moderate scope, some risk
- [ ] 3 - Low: Isolated changes, minimal risk
- [ ] 4 - No-op: No functional changes

### Step 7: Write Test Plan

**CRITICAL**: Read the test plan guidelines first:

[How to write a test plan](environments/rulebank/general/test-plan.md)
Note that the test-plan is for manual testing for Developers (Write Dev Only: [the test plan]) often something like, test endpoint directly, run migrations up and down if applicable etc.
and QA Test:
These are tests that our QA colleagues execute mannually from the frontend, rarely do they also test from postman.
If there's a FF involved it should inclue the various cases.


Write appropriate test plan based on change type:

**For New Features**:
- Manual testing steps (numbered list)
- Edge cases tested
- Integration points verified

**For Bug Fixes**:
- Reproduction steps for original bug
- Verification that bug is fixed
- Related functionality checked

**For Refactoring**:
- Existing functionality verified
- No behavior changes confirmed

**For API Changes**:
- Contract compatibility verified
- Client impact assessed

### Step 8: Template Preservation Rules

🚨 **CRITICAL**: Your PR description must be a 1:1 copy of the template with only:
- Content filled in (text after headers)
- Appropriate checkboxes ticked `[x]`
- Do not use sub headers, it breaks the CI check parser (like ### QA test within ## Test Plan)

**You MUST preserve**:
✅ All section headers exactly as they appear
✅ All markdown formatting and spacing
✅ All bullet points and structure
✅ All checkbox options (tick only one per section)

**Example of correct checkbox handling**:
```
## Level of Impact
Please select exactly one option.

- [ ] 1 - High
- [x] 2 - Medium  ← Only tick the appropriate box
- [ ] 3 - Low
- [ ] 4 - No-op
```

### Step 9: Present for Review

Present the complete filled template to the user and ask:
1. "Does this accurately describe your changes?"
2. "Would you like any sections revised?"
3. "Ready to create the final PR?"

Wait for user confirmation before proceeding.

### Step 10: Create Final PR

Once approved:

1. **Update PR with complete description**:
   ```bash
   gh pr edit {PR-number} \
     --title "[Category]: [Concise summary]" \
     --body-file pr-description.txt \
     > pr_edit_result.txt && cat pr_edit_result.txt
   ```

   **Title Format**: Use the appropriate category prefix:
   - `Copilot`: General Copilot features
   - `AI Agents`: AI agent configuration, management, or execution
   - `AiTools`: Changes only to our service

   Examples:
   - `Copilot(UI): fix parallel tool approval UI collapse behavior`
   - `AI Agents(permissions): add granular permissions for custom roles`
   - `AiTools(dependency): add stations-crud dependency`

2. **Mark as ready for review**:
   ```bash
   gh pr ready {PR-number} > pr_ready_result.txt && cat pr_ready_result.txt
   ```

3. **Verify PR was updated**:
   ```bash
   gh pr view {PR-number}
   ```

4. **Clean up temporary files**:
   ```bash
   rm pr-description.txt draft_pr_info.txt pr_*
   ```

## Anti-Patterns to Avoid

❌ **Don't skip analysis**: Never fill template before analyzing code
❌ **Don't modify template structure**: Preserve exact formatting
❌ **Don't skip guideline reading**: Impact and test plans need context
❌ **Don't assume tool output**: Always write to file and read back
❌ **Don't rush to ready**: Keep as draft until template is complete
❌ **Don't forget cleanup**: Remove temporary files after completion

1. **Read guidelines every time**: Impact and test requirements evolve
2. **Be thorough in analysis**: 5 minutes analyzing saves 30 minutes of back-and-forth
3. **Write to files**: Terminal output can be truncated or fail silently
4. **Keep it systematic**: Follow steps in order, don't skip
5. **Ask for clarification**: If change type is unclear, ask before assuming
