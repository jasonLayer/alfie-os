# Notion Workspace Map — TrustLayer (Personal: jasonreichl@jasonreichl.com)

> Last updated: 2026-03-09
> Workspace: TrustLayer (connected via jasonreichl@jasonreichl.com)
> This workspace is the **TrustLayer company workspace**, not a personal one.

---

## Teamspaces

### Active (Joined)

| Name | ID | Role |
|---|---|---|
| Admin | `2e0fe491-b55f-8148-87d6-0042980e4c1f` | owner |
| Admin (Do Not GO) | `295fe491-b55f-816d-bda3-00422abd246b` | owner |
| Archive | `94e310d3-2887-457a-b602-e59675724568` | owner |
| Archive - Deep Freeze | `115fe491-b55f-8105-a3f4-00426d762e86` | member |
| Input | `2e0fe491-b55f-8197-9f88-00425e674fa9` | owner |
| Jason & AdaM | `292fe491-b55f-8111-9135-004208a41eb2` | owner |
| OS Testing | `249fe491-b55f-81d6-bcc4-0042ab5412ff` | owner |
| Output | `2e0fe491-b55f-8166-83d3-0042616cde20` | owner |
| Partnerships | `c0ad3815-073b-475e-a839-6533dede842c` | member |

### Archived / Trashed

| Name | ID |
|---|---|
| HR | `e1dc3582-d2f4-4260-839d-3ca1123546bf` |
| Product | `ce4e4103-68d5-42c3-871c-657ca2d95ad9` |
| Archive (old) | `107fe491-b55f-81c1-b9fe-00421c8324e6` |
| Enterprise Partners | `597d1520-a598-4fbc-b91a-77e3fe69d7b0` |
| Make Test | `9f2fce65-7d34-44c1-b8fd-7adc4c22c743` |
| TrustLayer Partner | `ea82d0de-dd7c-401e-9895-8cdd40d54452` |

---

## Core Databases (the "TL OS")

The TrustLayer Operating System ("OS 26") is built around a set of interconnected databases that form a GTM + Product operating system. The naming convention is `TL_<Entity>_DB`.

### 1. TL_Accounts_DB — Customer/Partner Accounts

- **URL:** https://www.notion.so/309fe491b55f80d8907dc62f16b1f4e8
- **ID:** `309fe491-b55f-80d8-907d-c62f16b1f4e8`
- **Data Source:** `collection://309fe491-b55f-8020-bad9-000bc2892f6e`
- **Purpose:** Master account list synced from Salesforce. Tracks customers, partners, opportunities.
- **Key Properties:**
  - `Account Name` (title)
  - `Account Owner` (person)
  - `Type` — Direct, Indirect, Partner, Carrier
  - `Lifecycle Stage` — Opportunity, Customer
  - `Account Trending` — Green, Yellow, Red, Black
  - `Account Trending Reason` (text)
  - `ARR` (number) — Annual Recurring Revenue
  - `Active Parties` / `Contracted Parties` (number)
  - `Industry`, `TL Industry`, `SIC Code`
  - `SFDC Account ID` (text) — Salesforce link
  - `Implementation Phase`, `Customer Stage`, `Lifecycle Status`
  - `Service Level`, `Parent Account`, `Reseller Customer`
  - `Website` (url)
  - `Reference Ready` (checkbox)
  - `Churn Notice Date`, `Intent Date`, `Last Document Reviewed Date`, `Warmly: Last seen` (dates)
  - `IM Manager` (person) — Implementation Manager
  - `Attached Plans` (relation -> TL_Plans_DB)
  - `Opps` (relation -> TL_Opps collection `a81a802a-d9bb-4ca4-a951-74658e8d46a8`)
- **Views:** Default table, Customers (filtered), Opps (filtered to Lifecycle Stage = Opportunity)

---

### 2. TL_Plans_DB — Goal-Oriented Plans

- **URL:** https://www.notion.so/2e1fe491b55f80d793f8de9f5b4aeb31
- **ID:** `2e1fe491-b55f-80d7-93f8-de9f5b4aeb31`
- **Data Source:** `collection://2e1fe491-b55f-807e-bdca-000bbc768703`
- **Purpose:** The primary work-tracking system (replacing Tasks and Projects/Programs). Plans are goal-oriented documents with milestones, KPIs, and status tracking.
- **Key Properties:**
  - `Name` (title)
  - `Status` — On Hold, Backlog, On Deck, In progress, Done, Archived, Cancelled
  - `Summary` (text)
  - `Target Date` (date)
  - `Resource assigned to plan` (person)
  - `Attached Account` (relation -> TL_Accounts_DB)
  - `Plan Adjustments` (relation -> TL_DocsAndResource_DB `collection://2c7fe491-b55f-81c5-8742-000b5328e7bf`)
  - `Adjustment Status` (rollup)
- **Template:** "New Plan" (`2e8fe491-b55f-8039-a861-dffc963cfe0a`)
- **Note:** Tasks DB is being retired. Plans DB is the new standard.

---

### 3. TL_Roadmap_DB — Strategic Roadmap

- **URL:** https://www.notion.so/986752bd7e5c4f338aaf8c9992dda714
- **ID:** `986752bd-7e5c-4f33-8aaf-8c9992dda714`
- **Data Source:** `collection://1bbfb675-def8-490c-a1d0-f9d1701308c9`
- **Purpose:** Company-level initiatives that leadership believes will have direct financial impact. Each roadmap item gets at least one linked Plan when it moves to "In Progress."
- **Key Properties:**
  - `Name` (title)
  - `Status` — Idea, On Deck, In Progress, Blocked, Completed, Cancelled
  - `Function` — GTM, P&E, BizOps
  - `Owner` (person)
  - `Why` (text) — Strategic rationale
  - `How` (text) — Approach and estimates
  - `KPI` (text) — Measurable success metrics
  - `N.C.S.` (text) — Next Clear Step
  - `Summary` (text) — AI-generated executive summary
  - `Impact` / `Effort` — Not Known, Low, Medium, High
  - `Grade` — A+, A, B, C, D, F
  - `Target Date` (date)
  - `Priortization Score` (formula)
  - `Work Link` (relation -> Tasks collection `997b25d1-1173-4620-8c01-9c61a8e566fe`)
  - `Projects/Programs/Pitches Link` (relation -> `collection://49eab4a8-3351-4161-848f-e7291f3d7fd2`)
- **Views:** Simple (grouped by Status), Kanban (board by Status), All Roadmap Items (full table)

---

### 4. TL_DocsAndResource_DB — Knowledge Base / Document Library

- **URL:** https://www.notion.so/2c7fe491b55f815db710e8fc3df271a4
- **ID:** `2c7fe491-b55f-815d-b710-e8fc3df271a4`
- **Data Source:** `collection://2c7fe491-b55f-81c5-8742-000b5328e7bf`
- **Purpose:** Structured document library. All company knowledge (playbooks, SOPs, talk tracks, AI instructions, etc.) lives here with typed templates. Also serves as the "raw input" capture point.
- **Key Properties:**
  - `Name` (title)
  - `Type` — AI Background, AI Instruction, Analysis, Explanation, Flowchart SOP, Guide, Manuscript, Reference, Talk Track, Tutorial, Raw, Playbook, Plan, Template, Processed
  - `Status` — Published, Raw, Adjust, Processed
  - `Area` (multi-select) — Quality Assurance, Product, Engineering, Flow Testing Strategy, RevOps, TrustLayer+, Customer Success, Marketing, Sales, People Ops, Leadership
  - `Summary` (text)
  - `File` (file)
  - `URL` (url)
  - `Connected Plans` (relation -> TL_Plans_DB)
  - `Created`, `Last Edited` (auto timestamps)
  - `Created by`, `Edited By` (auto persons)
- **Templates (13 document types):**
  - Flowchart SOP (`2c7fe491-b55f-8149-8cba-d092ac986532`)
  - Tutorial (`2c7fe491-b55f-8101-ac7d-cb449e2b0100`)
  - Guide (`2c7fe491-b55f-819e-ba36-f66462440d6c`)
  - Explanation (`2c7fe491-b55f-81cc-9f65-f9d837ae4d41`)
  - Reference (`2c7fe491-b55f-815a-9016-f2cfd5d28250`)
  - Talk Track (`2c7fe491-b55f-8130-8b5c-cc032c876d97`)
  - AI Background (`2c7fe491-b55f-81fb-a997-d2b1bff797f7`)
  - AI Instructions (`2c7fe491-b55f-81da-b555-f3242347c3db`)
  - Analysis (`2c7fe491-b55f-8199-bd54-f25df47f5c7c`)
  - Manuscript (`2c7fe491-b55f-81de-ac59-e63d3b170a95`)
  - Raw (default) (`2c7fe491-b55f-8188-966d-cc36a46890c9`)
- **Views:** Playbook (gallery filtered to Playbooks), By Edited (table sorted by Created), Type (gallery grouped by Type), My raw documents (table filtered to Raw + non-Published)

---

### 5. TL_Chorus_Calls_DB — Call Recordings (from Chorus/ZoomInfo)

- **URL:** https://www.notion.so/2f1fe491b55f80a2b336fa52656fe19c
- **ID:** `2f1fe491-b55f-80a2-b336-fa52656fe19c`
- **Data Source:** `collection://2f1fe491-b55f-80ec-9e6a-000b250fd847`
- **Purpose:** Ingested call recordings from Chorus (ZoomInfo). Links calls to SFDC accounts. Used by AI agents for account intelligence.
- **Key Properties:**
  - `Call Name` (title)
  - `Date` (date)
  - `Duration (minutes)` (number)
  - `Internal Names` / `External Names` / `External Emails` (text)
  - `SFDC Account Names` / `SFDC Account IDs` / `SFDC Contact IDs` (text)
  - `Chorus URL` (url) / `Chorus Engagement ID` (text)
  - `Gmail Thread ID` (text)
  - `Message Count` (number)
  - `Notion Users` (person)
  - `Platform` (formula)
- **Views:** Default, TW (filtered), Mine (filtered), Internal Name Data Issue

---

### 6. TL+ Client Database — Managed Service Clients

- **URL:** https://www.notion.so/a7c8c11e53cb4f34adf375812092d85a
- **ID:** `a7c8c11e-53cb-4f34-adf3-75812092d85a`
- **Data Source:** `collection://35c1aad5-7c30-4d37-83e8-5aec7710d109`
- **Parent:** "Reference: TrustLayer+ World" page
- **Purpose:** Tracks TrustLayer+ (managed service) client accounts with their implementation and review status.
- **Key Properties:**
  - `Name` (title)
  - `Status` — Implementation, Done/Churned, Live
  - `Review Status` — Live, Auditing, Pause
  - `Request Status` — Live, Automated, Do Not Request
  - `Account Manager` (person)
  - `Person` (person)
  - `Related Account Name` (text)
  - `Update OS Account Page` (text)
  - `URL` (url)

---

### 7. Releases — Product Release Tracking

- **URL:** https://www.notion.so/315fe491b55f81619e9cc8be18abf5cb
- **ID:** `315fe491-b55f-8161-9e9c-c8be18abf5cb`
- **Data Source:** `collection://315fe491-b55f-811a-aaa4-000b9a155ac3`
- **Parent:** Product Engineering Hub > Ignore For Now
- **Purpose:** Tracks product releases with per-segment rollout status. Each release tracks availability across 9 customer segments.
- **Key Properties:**
  - `Name` (title)
  - `Build Status` — Building, In Review / QA, Shipped, On Hold, Scrapped
  - `Owner` (person), `Stakeholders` (person)
  - `Launch Date` (date)
  - `Capability` (relation -> Capabilities collection)
  - `Pitches` (relation), `Feedback` (relation)
  - `Feature Flag(s)` (text)
  - `Adoption Goal` / `Actual Adoption` (text)
  - `Next Decision` (text)
  - `Metrics Dashboard` (url)
  - **9 Segment columns** (each a select with: GTM Prep, Beta, Alpha, Live, Holding Off, Not Planned):
    - `Seg: Internal`, `Seg: TL+`, `Seg: Starter / Self-Service`, `Seg: Direct Pro`, `Seg: Direct Complete`, `Seg: Prospects`, `Seg: Reseller`, `Seg: Full-Service Reseller`, `Seg: API / Integrations`
  - `Segment Summary` (formula)
  - `Accounts` (relation), `Tasks` (relation)
- **Also contains:** Release access requests sub-data-source (`collection://315fe491-b55f-8138-a824-000bc6fcde77`)
- **Views:** Active Rollouts (filtered to in-progress segments), Build Status (board), Full List (table), Live for Customers (filtered to Live), Segment Cards (gallery)
- **Note:** There's an old Releases DB being archived (`29afe491-b55f-80e1-a502-cf1bab54bb63`). Use the new one above.

---

### 8. TL_Accounts_Timeline_DB

- **URL:** https://www.notion.so/2f8fe491b55f80db9014eb22bfc4572e
- **ID:** `2f8fe491-b55f-80db-9014-eb22bfc4572e`
- **Purpose:** Timeline events for accounts (not fetched for schema detail).

---

### 9. TrustLayer Calendar Database

- **URL:** https://www.notion.so/a8ac9b3d393a4d7e87534d3e5b0c4287
- **ID:** `a8ac9b3d-393a-4d7e-8753-4d3e5b0c4287`
- **Purpose:** Company calendar events.

---

### 10. Projects/Programs Database (Legacy)

- **URL:** https://www.notion.so/997c3397404948fc88ea12ede27be883
- **ID:** `997c3397-4049-48fc-88ea-12ede27be883`
- **Purpose:** Legacy project tracker. Being retired in favor of TL_Plans_DB.

---

### 11. Tasks (Legacy Template)

- **URL:** https://www.notion.so/105b1eae8e33409397b13ce64c2f0863
- **ID:** `105b1eae-8e33-4093-97b1-3ce64c2f0863`
- **Data Source:** `collection://7834d2d9-dc63-43ca-b879-34821d7ea905`
- **Parent:** Task and Project Management [TEMPLATE] > Master Databases
- **Purpose:** Legacy task tracker. Being retired — new items should go in TL_Plans_DB.
- **Key Properties:**
  - `Name` (title)
  - `Status` — Not started, In progress, On Hold, Completed, Abandoned
  - `Priority` — Urgent, High, Medium, Low
  - `Owner` (person)
  - `Due Date` (date)
  - `Project` (relation -> Projects collection `946ff686-66bd-4500-bc31-22c31d4754a8`)
  - `Topic` (relation -> Topics collection `a8c8c3e2-87b0-4975-a6c7-f013619649f3`)
  - Computed: `Time Alert`, `Completed`, `Current Week/Month/Quarter`

---

### 12. Document & Resources (Wiki version)

- **URL:** https://www.notion.so/7bae0b5cdf33446a8f770a64fc5270d0
- **ID:** `7bae0b5c-df33-446a-8f77-0a64fc5270d0`
- **Data Source:** `collection://4d90ea76-8e48-4ff8-bb0a-3a9b83ed9201`
- **Purpose:** Wiki version of the Documents & Resources. Read-only properties (wiki mode). Same schema as TL_DocsAndResource_DB but used as the browsable wiki surface.

---

### 13. Plans (alternate view)

- **URL:** https://www.notion.so/894d8d76451244c288dca89dd7c88dce
- **ID:** `894d8d76-4512-44c2-88dc-a89dd7c88dce`
- **Purpose:** Another database named "Plans" — possibly a view or older version.

---

### 14. Team Members

- **URL:** https://www.notion.so/249fe491b55f8072bb73dd131c4f2098
- **ID:** `249fe491-b55f-8072-bb73-dd131c4f2098`
- **Purpose:** Team member directory.

---

### 15. Accounts (older/alternate)

- **URL:** https://www.notion.so/2e41a6b10d814a3c80f49bfdbfc80f51
- **ID:** `2e41a6b1-0d81-4a3c-80f4-9bfdbfc80f51`
- **Purpose:** Older accounts database, possibly the P&E version.

---

### 16. Release Notes / Changelog (Legacy)

- **URL:** https://www.notion.so/6f4c70e1297b430c8a8cb78989f81901
- **ID:** `6f4c70e1-297b-430c-8a8c-b78989f81901`
- **Purpose:** Legacy changelog from 2024.

---

### 17. Database (unnamed)

- **URL:** https://www.notion.so/2d8fe491b55f80da9d16e6856ef4c86c
- **ID:** `2d8fe491-b55f-80da-9d16-e6856ef4c86c`

---

## Referenced Data Source Collections (not top-level DBs)

These are data sources referenced via relations in the core databases:

| Collection ID | Referenced From | Likely Purpose |
|---|---|---|
| `a81a802a-d9bb-4ca4-a951-74658e8d46a8` | TL_Accounts_DB (Opps) | TL_Opps_DB — Opportunities |
| `997b25d1-1173-4620-8c01-9c61a8e566fe` | TL_Roadmap_DB (Work Link), Releases (Tasks) | Work items / Tasks |
| `49eab4a8-3351-4161-848f-e7291f3d7fd2` | TL_Roadmap_DB (Projects Link) | Projects/Programs/Pitches |
| `29afe491-b55f-8032-85bc-000b556c23fb` | Releases (Capability) | Capabilities list |
| `29bfe491-b55f-80dc-8505-000b053eff4f` | Releases (Pitches) | Pitches |
| `29cfe491-b55f-808d-b44d-000bb182da5d` | Releases (Feedback) | Feedback |
| `dd2cea0f-7def-45a5-b563-f88c174931b2` | Releases (Accounts) | Accounts (P&E version) |
| `946ff686-66bd-4500-bc31-22c31d4754a8` | Tasks (Project) | Projects |
| `a8c8c3e2-87b0-4975-a6c7-f013619649f3` | Tasks (Topic) | Topics |

---

## Major Pages (Non-Database)

### OS Architecture & Documentation

| Title | ID | URL |
|---|---|---|
| Explanation: OS Architecture | `2d2fe491-b55f-80d2-b1c3-e161895fae46` | https://www.notion.so/2d2fe491b55f80d2b1c3e161895fae46 |
| TrustLayer OS Documentation | `c3082408-17b3-4ac8-bd3b-0d5beb5abd97` | https://www.notion.so/c308240817b34ac8bd3b0d5beb5abd97 |
| Explanation: How Plans Work at TrustLayer | `c6bb8273-b9c3-43de-a112-d193e4f3b0ac` | https://www.notion.so/c6bb8273b9c343dea112d193e4f3b0ac |
| Explanation: How Roadmaps Work at TrustLayer | `4639f2f9-e72c-481d-8cc0-1b79ec6a2f28` | https://www.notion.so/4639f2f9e72c481d8cc01b79ec6a2f28 |
| Reference: Plan Types in the TrustLayer OS | `9beff35b-ad48-4364-8db4-bb6e97f9dd32` | https://www.notion.so/9beff35bad4843648db4bb6e97f9dd32 |
| OS Architecture Deep Dive + Comparison Pack | `a59dce2e-f981-4db8-8ac5-6ccec6d6f5d5` | https://www.notion.so/a59dce2ef9814db88ac56ccec6d6f5d5 |
| Unified Roadmap | `293fe491-b55f-8062-93df-cba1f01e7257` | https://www.notion.so/293fe491b55f806293dfcba1f01e7257 |
| OS 26- Document Drafting | `2cefe491-b55f-8002-a059-c7a7b19c94dc` | https://www.notion.so/2cefe491b55f8002a059c7a7b19c94dc |
| OS 26- Personal Radar | `58bb482c-2b70-4886-a98b-c86d2167f371` | https://www.notion.so/58bb482c2b704886a98bc86d2167f371 |
| Tutorial: When to Use Each Document Template | `2c7fe491-b55f-8118-aab5-d0cc6d2b8973` | https://www.notion.so/2c7fe491b55f8118aab5d0cc6d2b8973 |
| How the Releases Database Work | `315fe491-b55f-8053-bb39-de9279f97c85` | https://www.notion.so/315fe491b55f8053bb39de9279f97c85 |

### Roadmap & Strategy

| Title | ID | URL |
|---|---|---|
| Roadmap (hub page) | `295fe491-b55f-80a9-a7a6-c7368033c0b9` | https://www.notion.so/295fe491b55f80a9a7a6c7368033c0b9 |
| Plans (hub page) | `2e1fe491-b55f-8083-991f-f401f38e3439` | https://www.notion.so/2e1fe491b55f8083991ff401f38e3439 |
| TrustLayer Pillars | `288fe491-b55f-80e9-957a-dd0746f3071b` | https://www.notion.so/288fe491b55f80e9957add0746f3071b |
| Strat 26 work up | `2affe491-b55f-80d3-898d-f01b21c66675` | https://www.notion.so/2affe491b55f80d3898df01b21c66675 |
| Company Strategy & Comp Plan SF | `194fe491-b55f-80ca-a3db-d87ad5231565` | https://www.notion.so/194fe491b55f80caa3dbd87ad5231565 |
| Explanation: Roles & Functions in Strategy 2026 | `2b7fe491-b55f-80d7-8b5f-c623af2afd4a` | https://www.notion.so/2b7fe491b55f80d78b5fc623af2afd4a |

### Product & Engineering

| Title | ID | URL |
|---|---|---|
| Product Engineering Hub | `29afe491-b55f-8097-8047-eaf81059b7c3` | https://www.notion.so/29afe491b55f80978047eaf81059b7c3 |
| Product-Engineering Coordination | `2f7fe491-b55f-8039-8bf7-ef74f436aa34` | https://www.notion.so/2f7fe491b55f80398bf7ef74f436aa34 |
| P&E Radar (weekly report) | `310fe491-b55f-8052-bcd1-e05903ba6052` | https://www.notion.so/310fe491b55f8052bcd1e05903ba6052 |

### GTM / Sales / Partnerships

| Title | ID | URL |
|---|---|---|
| Teamspace Home | `295fe491-b55f-8192-92ab-ff5fd6299ec7` | https://www.notion.so/295fe491b55f819292abff5fd6299ec7 |
| Documents and Resources (page) | `dd347056-dd58-4c40-a454-309044d3b1fb` | https://www.notion.so/dd347056dd584c40a454309044d3b1fb |
| Partner Account Management | `225fe491-b55f-80a3-8fdf-e6c49d289bc6` | https://www.notion.so/225fe491b55f80a38fdfe6c49d289bc6 |
| Partner Launch Steps | `20ffe491-b55f-802b-aeda-cf2e747712d2` | https://www.notion.so/20ffe491b55f802baedacf2e747712d2 |
| Commission Structure | `2dffe491-b55f-80eb-9514-f192e080e7ad` | https://www.notion.so/2dffe491b55f80eb9514f192e080e7ad |

### AI Agent System ("majorGTM" / "Alfie")

| Title | ID | URL |
|---|---|---|
| majorGTM Agent | `1acf4f19-bb2c-4c8f-926e-adfdab5fe1b1` | https://www.notion.so/1acf4f19bb2c4c8f926eadfdab5fe1b1 |
| majorGTM Workflows | `54385572-461f-48fa-802c-65653f3f3133` | https://www.notion.so/54385572461f48fa802c65653f3f3133 |
| AI Instruction: GTM OS Agent Update | `7db905c8-d7b0-4c40-801a-58488461d4e2` | https://www.notion.so/7db905c8d7b04c40801a58488461d4e2 |
| AI Instruction: P&E Radar Generator | `3c7b920d-fd48-4072-842b-dd111394ac82` | https://www.notion.so/3c7b920dfd484072842bdd111394ac82 |
| AI Instruction: Document Drafting | `d07ac886-e8b4-4a8e-81ce-1e72ac6fdd10` | https://www.notion.so/d07ac886e8b44a8e81ce1e72ac6fdd10 |
| AI Instruction: Account Linking from Opportunity Name | `f3762373-b4ae-4ebb-9359-901ce90f1099` | https://www.notion.so/f3762373b4ae4ebb9359901ce90f1099 |
| AI Instruction: Plan Adjustment | `521fe029-ea0c-40c5-ad36-7c524257afca` | https://www.notion.so/521fe029ea0c40c5ad367c524257afca |
| AI Instruction: Roadmap Closing Notes & Grade | `fcacc527-9774-49e1-bd6f-dfb34d045696` | https://www.notion.so/fcacc527977449e1bd6fdfb34d045696 |
| AI Background: Project Charters | `2c7fe491-b55f-81c5-8efd-d1bb7c881860` | https://www.notion.so/2c7fe491b55f81c58efdd1bb7c881860 |
| Plan: Major GTM OS v1.0 by (Doc Creators) | `97766a76-8063-45f5-b720-5c06737f050c` | https://www.notion.so/97766a76806345f5b7205c06737f050c |
| Plan: Radar Agent & Collision Detection System | `a747ed17-8c83-40ed-8a5d-f3e6c9c41578` | https://www.notion.so/a747ed178c8340ed8a5df3e6c9c41578 |
| Playbook: Drafting Documents Using AI & OS | `8e9550f8-96b6-4f51-af7d-f4820b608179` | https://www.notion.so/8e9550f896b64f51af7df4820b608179 |

### TrustLayer+ (Managed Service)

| Title | ID | URL |
|---|---|---|
| Reference: TrustLayer+ World | `4d9a3957-19f5-49f4-ad34-645bc7955e4b` | https://www.notion.so/4d9a395719f549f4ad34645bc7955e4b |
| TrustLayer+ (hub) | `9b586c27-cd7c-4ed4-8df8-b4d58b37e89d` | https://www.notion.so/9b586c27cd7c4ed48df8b4d58b37e89d |
| Implementation to TL+ Handoff Workflow | `5c2accd5-8e29-4efa-9370-b2df97928f9f` | https://www.notion.so/5c2accd58e294efa9370b2df97928f9f |
| Reference: TL+ Broker Service Tiers | `27ffe491-b55f-81a1-b361-f6332cf2b61b` | https://www.notion.so/27ffe491b55f81a1b361f6332cf2b61b |
| Talk Track: TL+ Overage Expansion | `086165b1-dbaf-41c7-acb5-ac3ca02015ea` | https://www.notion.so/086165b1dbaf41c7acb5ac3ca02015ea |

### Playbooks

| Title | ID | URL |
|---|---|---|
| Playbook: Enhanced Endorsements | `77ca0cb6-97c7-4d9f-9821-22a137a68464` | https://www.notion.so/77ca0cb697c74d9f982122a137a68464 |
| Playbook: OS 26 Account Structure | `628ea6c8-7a4a-4ae7-b1e6-7ab9b7293c25` | https://www.notion.so/628ea6c87a4a4ae7b1e67ab9b7293c25 |
| Partner Referral Program Outbound Playbook | `f540191f-629d-42e7-8a94-5f7c90dc26eb` | https://www.notion.so/f540191f629d42e78a945f7c90dc26eb |

### Account-Specific Pages (examples)

Internal account pages follow the pattern: `<Company Name> - TL internal page`. Examples:
- Homes by Taber (`6b139960-cf32-4c44-b1bc-360f3fb4da8a`)
- Grenadier Homes (`b164956b-61e5-4af0-8b0f-4181a5e2f641`)
- Home Run Inn Inc. (`153fe491-b55f-804c-95fb-e72381b8868c`)
- Edge Homes (`c8675630-784e-49db-8c74-b8f49b416408`)
- Corgan (`c097be50-e492-484e-a4f4-e63a512eb539`)
- NEF (`072bae75-fcb0-4727-9fab-0975885d7c2b`)

### Radar Reports (weekly)

Weekly executive radar reports are generated as standalone pages. Examples:
- Radar (12/9-12/14/25) (`a825eacf-8e4e-48c4-a8e0-bf6677319a6f`)
- Radar (10/14-10/21/25) (`ac4aca6e-43cc-4700-88de-fe3eaa7b5340`)
- CS Radar Week of Dec 2-8, 2025 (`3743adb3-32ed-454d-8026-ecff88529ef1`)
- P&E Radar Week of Feb 23, 2026 (`310fe491-b55f-8052-bcd1-e05903ba6052`)

### Admin

| Title | ID | URL |
|---|---|---|
| Admin - Databases (Do Not Delete) | `6fa75672-144d-44b9-a2b6-1fedaa83e3ab` | https://www.notion.so/6fa75672144d44b9a2b61fedaa83e3ab |
| Databases (page) | `11afe491-b55f-81cf-9b40-d68ec4602df4` | https://www.notion.so/11afe491b55f81cf9b40d68ec4602df4 |
| Campaign Code Database | `437001c5-810b-4936-9399-60e004ea84e3` | https://www.notion.so/437001c5810b4936939960e004ea84e3 |

---

## Workspace Organization Patterns

### The OS Architecture (Inputs -> Targets -> Outputs)

The TrustLayer OS follows a three-layer architecture:
1. **Inputs (Raw):** User inbox, messy notes, raw transcripts, unstructured input -> captured in TL_DocsAndResource_DB with Status=Raw
2. **Targets (Structured):** Roadmap items, Plans, Account pages, structured documents
3. **Outputs (Actionable):** Radars, Playbooks, Talk Tracks, Published docs

### Database Hierarchy

```
TL_Roadmap_DB (strategic initiatives)
  |-> TL_Plans_DB (execution plans, linked to roadmap items)
       |-> TL_Accounts_DB (customer accounts, linked to plans)
            |-> TL_Opps_DB (opportunities per account)
            |-> TL_Chorus_Calls_DB (calls linked to SFDC accounts)
            |-> TL_Accounts_Timeline_DB (events per account)
       |-> TL_DocsAndResource_DB (knowledge base, plan adjustments)
  |-> Releases (product releases, linked to capabilities)
  |-> Tasks (legacy, being retired)
  |-> Projects/Programs (legacy, being retired)
```

### Document Type System (13 types in TL_DocsAndResource_DB)

| Type | Purpose | Example |
|---|---|---|
| AI Background | Context docs for AI agents | "AI Background: Project Charters" |
| AI Instruction | Behavioral rules for AI agents | "AI Instruction: GTM OS Agent Update" |
| Analysis | Deep-dive investigation | |
| Explanation | Teach concepts | "Explanation: How Plans Work" |
| Flowchart SOP | Visual process docs | |
| Guide | Step-by-step how-to | |
| Manuscript | Long-form writing | |
| Reference | Quick-lookup info | "Reference: Plan Types" |
| Talk Track | Sales conversation scripts | "Talk Track: TL+ Overage Expansion" |
| Tutorial | Learning for beginners | "Tutorial: When to Use Each Template" |
| Raw | Unprocessed input | Default for new captures |
| Playbook | Collection of related docs | "Playbook: Enhanced Endorsements" |
| Plan | Goal-oriented execution doc | "Plan: Major GTM OS v1.0" |

### Naming Conventions

- Databases: `TL_<Entity>_DB` (e.g., `TL_Accounts_DB`, `TL_Plans_DB`)
- Documents: `<Type>: <Title>` (e.g., `Explanation: How Plans Work at TrustLayer`)
- Account pages: `<Company Name> - TL internal page`
- Meeting notes: `<Team>: Alignment & Sync @<Date> <Time>`
- Radar reports: `Radar (<date range>)` or `<Team> Radar - Week of <date>`
- Plans: `Plan: <Name>`
- Playbooks: `Playbook: <Name>`
- OS features: `OS 26- <Feature Name>`

### Key Transitions in Progress

1. **Tasks DB -> TL_Plans_DB:** Tasks database is being retired. New work items go in Plans.
2. **Old Releases DB -> New Releases DB:** Old one (`29afe491-b55f-80e1`) being archived by March 10, 2026.
3. **AI Agent System ("majorGTM" / "Alfie"):** AI agents operate within the OS, using AI Instruction docs to know how to behave. Quick capture via DM to Alfie creates Raw docs.

### Connected External Systems

- **Salesforce (SFDC):** Account IDs, Opportunity data, Contact IDs synced to Notion
- **Chorus/ZoomInfo:** Call recordings ingested into TL_Chorus_Calls_DB
- **HubSpot:** Marketing contacts and sequences
- **Google Drive:** Connected as a data source (search returns Google Drive results)
- **Google Calendar:** Connected (search returns calendar events)
- **Warmly:** Website visitor tracking (Last seen date on accounts)

---

## Quick Reference: Most-Used Database IDs

For programmatic access via Notion MCP tools:

```
# Core OS Databases
TL_Accounts_DB:        309fe491-b55f-80d8-907d-c62f16b1f4e8
TL_Plans_DB:           2e1fe491-b55f-80d7-93f8-de9f5b4aeb31
TL_Roadmap_DB:         986752bd-7e5c-4f33-8aaf-8c9992dda714
TL_DocsAndResource_DB: 2c7fe491-b55f-815d-b710-e8fc3df271a4
TL_Chorus_Calls_DB:    2f1fe491-b55f-80a2-b336-fa52656fe19c
TL+_Client_DB:         a7c8c11e-53cb-4f34-adf3-75812092d85a
Releases:              315fe491-b55f-8161-9e9c-c8be18abf5cb
TL_Accounts_Timeline:  2f8fe491-b55f-80db-9014-eb22bfc4572e
Team_Members:          249fe491-b55f-8072-bb73-dd131c4f2098

# Data Source (collection://) IDs for querying
TL_Accounts_DB:        collection://309fe491-b55f-8020-bad9-000bc2892f6e
TL_Plans_DB:           collection://2e1fe491-b55f-807e-bdca-000bbc768703
TL_Roadmap_DB:         collection://1bbfb675-def8-490c-a1d0-f9d1701308c9
TL_DocsAndResource_DB: collection://2c7fe491-b55f-81c5-8742-000b5328e7bf
TL_Chorus_Calls_DB:    collection://2f1fe491-b55f-80ec-9e6a-000b250fd847
TL+_Client_DB:         collection://35c1aad5-7c30-4d37-83e8-5aec7710d109
Releases:              collection://315fe491-b55f-811a-aaa4-000b9a155ac3
Document_Resources_Wiki: collection://4d90ea76-8e48-4ff8-bb0a-3a9b83ed9201

# Legacy (being retired)
Tasks:                 105b1eae-8e33-4093-97b1-3ce64c2f0863
Projects_Programs:     997c3397-4049-48fc-88ea-12ede27be883
Old_Releases:          29afe491-b55f-80e1-a502-cf1bab54bb63
```
