# SOC2Start MCP tool map

Tools grouped by area. Names match the MCP server; some clients prefix them (e.g. `soc2start__listControls`). ⚠ = confirm with the user before calling (irreversible, notifies people, or public-facing).

## Organization and people
- `listOrganizations`, `getOrganizationContext`, `updateOrganizationContext`, `getOrganizationLLMConfiguration`
- `listUsers`, `getUser`, `updateUser`, `updateMembership`
- ⚠ `inviteUser`, `createUser`, `archiveUser`, `removeUser`
- `listOperatorOrganizations`, `listOperatorIdentities`, ⚠ `assignOperator`, ⚠ `revokeOperator`
- SCIM: `getSCIMConfiguration`, `getSCIMBridge`, `listSCIMEvents`, ⚠ `createSCIMConfiguration`, ⚠ `updateSCIMBridge`, ⚠ `regenerateSCIMToken`, ⚠ `deleteSCIMConfiguration`

## Frameworks and controls
- `listFrameworks`, `getFramework`, `addFramework`, `updateFramework`
- `listControls`, `getControl`, `addControl`, `updateControl`, `linkControl`, `unlinkControl`
- `listControlMeasures`, `listControlDocuments`, `listControlAudits`, `listControlObligations`
- Statement of Applicability: `listStatementsOfApplicability`, `getStatementOfApplicability`, `addStatementOfApplicability`, `updateStatementOfApplicability`, `addApplicabilityStatement`, `updateApplicabilityStatement`, ⚠ `publishStatementOfApplicability`

## Measures and evidence
- `listMeasures`, `getMeasure`, `addMeasure`, `updateMeasure`, ⚠ `deleteMeasure`
- `linkMeasure`, `unlinkMeasure` (target: control, risk, document or third party)
- `listMeasureControls`, `listMeasureDocuments`, `listMeasureRisks`, `listMeasureTasks`, `listMeasureEvidences`
- Device posture: `createDevicePostureSnapshot`, `createDevicePostureFleetSnapshot`, `listDevicePostureCheckMeasureMappings`, `upsertDevicePostureCheckMeasureMapping`
- Training: `createSecurityTrainingSnapshot`

## Documents (policies, procedures, plans)
- `listDocuments`, `getDocument`, `addDocument`, `updateDocument`
- `listDocumentVersions`, `getDocumentVersion`, ⚠ `deleteDocumentDraft`
- ⚠ `publishDocument` (approval flow when `minor: false` + approvers)
- Approvals: `listDocumentVersionApprovalQuorums`, `listDocumentVersionApprovalDecisions`, ⚠ `voidDocumentVersionApproval`
- Signatures: `listDocumentVersionSignatures`, ⚠ `requestDocumentVersionSignature`, ⚠ `sendSigningNotifications`, ⚠ `cancelSignatureRequest`
- ⚠ `archiveDocument`, `unarchiveDocument`, ⚠ `deleteDocument`

## Risks
- `listRisks`, `getRisk`, `addRisk`, `updateRisk`, `linkRisk`, `unlinkRisk`, `listRiskObligations`, ⚠ `publishRiskList`
- Risk assessments: `addRiskAssessment` and its scopes, processes, nodes, threats, scenarios (`add*`, `list*`, `update*`), `linkRiskAssessmentScenarioRisk`, `linkRiskAssessmentScenarioThreat`, `getRiskAssessmentScopeMermaidChart`

## Vendors (third parties)
- `listThirdParties`, `addThirdParty`, `updateThirdParty`, ⚠ `deleteThirdParty`
- Contacts and services: `addThirdPartyContact`, `addThirdPartyService` (+ list/update)
- Sub-processors: `createThirdPartyThirdPartyMapping`, `listChildThirdParties`
- ⚠ `vetThirdParty` (AI vetting, background), `listThirdPartyRiskAssessments`, `addThirdPartyRiskAssessment`, `updateThirdPartyVettingFollowUp`
- ⚠ `publishThirdPartyList`

## Data, assets and privacy
- `listData`, `addDatum`, `updateDatum`, ⚠ `publishDataList`
- `listAssets`, `addAsset`, `updateAsset`, ⚠ `publishAssetList`
- `addProcessingActivity`, `addDataProtectionImpactAssessment`, `addTransferImpactAssessment`, `addRightsRequest`, `addObligation` (+ list/get/update, ⚠ publish lists)
- Cookie consent: `addCookieBanner`, `addCookieCategory`, `upsertCookieBannerTranslation`, ⚠ `publishCookieBannerVersion`, ⚠ `activateCookieBanner`; trackers: `addTrackerPattern`, `addTrackerResource`

## Access reviews
- `createAccessSource`, `listAccessSources`, `createAccessReviewCampaign`, `addAccessReviewCampaignScopeSource`
- ⚠ `startAccessReviewCampaign`, `listAccessEntries`, `flagAccessEntry`, `recordAccessEntryDecision(s)`, `getAccessReviewCampaignStatistics`, ⚠ `closeAccessReviewCampaign`

## Tasks
- `listTasks`, `getTask`, `addTask`, `updateTask`, `assignTask`, `unassignTask`, ⚠ `deleteTask`

## Audits and findings
- `listAudits`, `getAudit`, `addAudit`, `updateAudit`, `getAuditReportUrl`
- `listFindings`, `addFinding`, `updateFinding`, `linkFindingAudit`, `addFindingComment`, ⚠ `publishFindingList`
- `listAuditLogEntries`, `getAuditLogEntry` (platform activity log)

## Trust center (public-facing — confirm every change)
- `getTrustCenter`, ⚠ `updateTrustCenter`, `listTrustCenterFiles`, `listTrustCenterReferences`, ⚠ `addTrustCenterReference`, ⚠ `createCustomDomain`
- `listComplianceExternalURLs`, ⚠ `addComplianceExternalURL`

## Integrations
- `listWebhookSubscriptions`, ⚠ `createWebhookSubscription`, `listWebhookEvents`
