# Workflows by phase

All calls need the `organization_id` from `listOrganizations` unless noted. Follow `cursor` on every `list*` call until it is empty.

## Phase 1 — Organization context

1. `getOrganizationContext` — read current sections.
2. For each empty or thin section, ask the template questions (`org-context-templates.md`) or read files the user provides.
3. Show the drafted section. On approval: `updateOrganizationContext` with only the sections you changed.

## Phase 2 — Framework

1. `listFrameworks`. If the target framework (e.g. SOC 2) exists, use it.
2. If not, ask the user to add it from SOC2Start's framework library in the app (library frameworks come with their controls). Use `addFramework` + `addControl` only for a custom framework the user defines.
3. `listControls` with `filter.framework_id` to load all controls.

## Phase 3 — Gap analysis

For each control:
1. `listControlMeasures` (measures already linked) and `listControlDocuments`.
2. Classify: **Covered** (linked measure `IMPLEMENTED`), **Partial** (linked measure not implemented, or missing evidence), **Gap** (nothing linked).
3. Use the org context to propose which existing or new measure fits.

Present a table before changing anything:

| Control | Status | Existing measures | Proposed action |
|---|---|---|---|

Optionally save it as a `REPORT` document (`addDocument`, classification `CONFIDENTIAL`).

## Phase 4 — Measures

1. `listMeasures` with `filter.query` to find a match before creating.
2. `addMeasure` (`name`, `category`, `description`). Write the description as what the organization actually does: tool, owner, cadence.
3. `linkMeasure` (`measure_id`, `resource_id` = control ID). One measure can cover many controls.
4. `updateMeasure` → `state`:
   - `IMPLEMENTED` — user confirms it operates today
   - `IN_PROGRESS` / `NOT_STARTED` — planned
   - `NOT_APPLICABLE` — record the reason in the description
   - `NOT_IMPLEMENTED` — decided not to do; should map to an accepted risk
5. `listMeasureEvidences` to see what proof exists. Evidence comes from the platform, integrations or uploads — never fabricate it.

Starter measure categories: Access control, Asset management, Business continuity, Change management, Cryptography, Data protection, HR security, Incident management, Logging & monitoring, Network security, Physical security, Risk management, Secure development, Vendor management, Governance.

## Phase 5 — Policies and procedures

Starter set (adjust to framework and company size):

| Document | Type |
|---|---|
| Information Security Policy | POLICY |
| Acceptable Use Policy | POLICY |
| Access Control Policy | POLICY |
| Change Management Policy | POLICY |
| Data Classification & Handling Policy | POLICY |
| Encryption Policy | POLICY |
| Backup Policy | POLICY |
| Vendor Management Policy | POLICY |
| Risk Management Policy | POLICY |
| Human Resources Security Policy | POLICY |
| Secure Development Policy | POLICY |
| Logging & Monitoring Policy | POLICY |
| Incident Response Plan | PLAN |
| Business Continuity & Disaster Recovery Plan | PLAN |
| Code of Conduct | GOVERNANCE |

Steps per document:
1. `listDocuments` with `filter.query` — skip or update if it exists.
2. Draft from the template below using org context facts.
3. `addDocument` (`title`, `content`, `document_type`, `classification: INTERNAL`).
4. `linkMeasure` for each measure the policy governs (`resource_id` = document ID).
5. After user review: `publishDocument`
   - `minor: true` for small edits (no approval flow)
   - `minor: false` + `approver_ids` to request approval (confirm first — notifies approvers)
   - `changelog` always set, e.g. "Initial version".
6. Employee acknowledgement: `requestDocumentVersionSignature` / `sendSigningNotifications` — confirm first.

### Policy template

```markdown
# <Policy name>

| Field | Value |
|---|---|
| Owner | <role> |
| Approved by | <role> |
| Effective date | <date> |
| Review cadence | Annual |

## Purpose
<Why this policy exists, one or two sentences.>

## Scope
<Systems, data, people covered. Reference the in-scope system from the org context.>

## Roles and responsibilities
| Role | Responsibility |
|---|---|

## Policy
<Numbered statements. Each is specific and testable: who does what, with which tool, how often.>
1. 
2. 

## Exceptions
Exceptions require written approval from <role>, are recorded with a reason and expiry date, and are reviewed <cadence>.

## Enforcement
Violations may result in disciplinary action up to and including termination.

## Related documents
- <linked policies / procedures>

## Version history
| Version | Date | Author | Changes |
|---|---|---|---|
| 1.0 | | | Initial version |
```

## Phase 6 — People

1. `listUsers`. Ask for missing people with name, email, role.
2. `inviteUser` / `createUser` — **confirm first** (sends email).
3. Record owners on measures, risks, vendors, data and assets using profile IDs from `listUsers`.
4. Training: if training is tracked in SOC2Start's built-in module, nothing to do; if tracked elsewhere, record a `createSecurityTrainingSnapshot` with real completion data the user provides.
5. Optional: device posture snapshots (`createDevicePostureSnapshot` / `createDevicePostureFleetSnapshot`) from the user's MDM data; access reviews (`createAccessSource`, `createAccessReviewCampaign`, `startAccessReviewCampaign` — confirm before starting).

## Phase 7 — Vendors (third parties)

1. Build the list from the user, the architecture section, finance/expense exports or SSO app lists. Typical: cloud provider, identity provider, source control, CI/CD, monitoring, email, chat, HR/payroll, CRM, support desk, LLM providers.
2. `listThirdParties` to avoid duplicates.
3. `addThirdParty` with `name`, `category`, `website_url`, `description` (what it's used for), owners. Add `trust_page_url`, `data_processing_agreement_url`, `certifications` only if known.
4. `addThirdPartyService` for specific services used (optional).
5. `vetThirdParty` (`id`, `website_url`) — runs in the background with the org's LLM key; **confirm first**. Check results later with `listThirdPartyRiskAssessments`.
6. `linkMeasure` vendor-management measures to critical vendors.
7. `publishThirdPartyList` when the register is reviewed (confirm first).

## Phase 8 — Data and assets

1. Data: `addDatum` (`name`, `data_classification`, `owner_id`, `third_party_ids` where it's stored or processed). Examples: customer account data, customer content, employee records, application logs, financial records, source code.
2. Assets: `addAsset` (`name`, `asset_type` PHYSICAL/VIRTUAL, `amount`, `owner_id`, `data_types_stored`, `third_party_ids`). Examples: production cloud account, laptops, databases.
3. `publishDataList` / `publishAssetList` after review (confirm first).
4. Privacy programs (GDPR etc.): `addProcessingActivity`, `addDataProtectionImpactAssessment`, `addTransferImpactAssessment`, `addRightsRequest` as needed.

## Phase 9 — Risks

1. `listRisks`. Draft risks from the org context — each one tied to a real asset, vendor or process. Typical: credential compromise, cloud misconfiguration, data loss, vendor outage, insider misuse, unpatched dependencies, key-person dependency, ransomware on endpoints.
2. Show a table (risk, likelihood 1–5, impact 1–5, treatment, mitigating measures) for user approval. Scores are the user's call.
3. `addRisk` (`name`, `category`, `treatment`, `inherent_likelihood`, `inherent_impact`, residual values, `owner_id`).
4. `linkMeasure` mitigating measures to each risk.
5. `publishRiskList` after review (confirm first).
6. Structured assessments (optional): `addRiskAssessment` → scopes, processes, threats, scenarios; `getRiskAssessmentScopeMermaidChart` for a diagram.

## Phase 10 — Tasks

1. Turn every Gap/Partial from phase 3 and every open question into a task.
2. `addTask` (`name`, `description`, `measure_id`, `assigned_to_id`, `deadline`, `priority`). Ask for owners and dates — don't guess.
3. `listTasks` for status; `updateTask` as work completes.

## Phase 11 — Audit readiness

1. Readiness check: `listMeasures` by `state`; for each in-scope control, confirm a linked `IMPLEMENTED` measure with evidence (`listMeasureEvidences`) and a published policy.
2. Summarize: % controls covered, measures missing evidence, unpublished policies, open tasks by owner.
3. `addAudit` (`framework_id`, `name`, `state`, `valid_from`/`valid_until` once known). Type 1 is a point in time; Type 2 needs an observation window (typically 3–12 months) where measures operate and produce evidence.
4. Findings from the auditor or internal review: `addFinding`, `linkFindingAudit`, `addFindingComment`.
5. Trust center: `getTrustCenter`; add documents with `trust_center_visibility` PRIVATE (NDA-gated) or PUBLIC; `addTrustCenterReference` for customer logos; `updateTrustCenter` to activate. **Confirm every trust center change** — it is public-facing.

## Ongoing (after onboarding)

| Cadence | Activity |
|---|---|
| Weekly | `listTasks` — overdue items by owner |
| Monthly | Measures still `IN_PROGRESS`; new vendors; evidence gaps |
| Quarterly | Access review campaign; risk register review |
| Annual | Policy review and re-publish; risk assessment; training |
