# Manual Check Rules

Use this file with `agent-style review --audit-only FILE` for the complete muxing-style-review pass. The CLI handles the implemented automatic detectors; this file contains only the remaining rules that require human or model judgment.

Manual-only rule set: RULE-01, RULE-02, RULE-03, RULE-04, RULE-07, RULE-08, RULE-09, RULE-10, RULE-11, RULE-F, RULE-H.

#### RULE-01: Do Not Assume the Reader Shares Your Tacit Knowledge (Resist the Curse of Knowledge)

- **source**: Pinker 2014, Ch. 3 "The Curse of Knowledge" (the entire chapter is devoted to this failure mode).
- **agent-instruction evidence**: Zhang et al. 2026 supports negative phrasing for anti-pattern directives in coding-agent instruction files (does not validate mechanical enforcement). Bohr 2025 supports pairing directives with examples for stronger initial style control over a paired two-turn code-generation workflow (not open-ended prose).
- **severity**: critical. Most common reviewer complaint on AI-generated technical prose is "reads like you forgot the reader doesn't know X yet."
- **scope**: `.md`, `.tex`, `.rst`, `.txt`, and prose sections of source files.
- **enforcement**: Tier-3 agent self-check (judgment rule; not mechanical); Tier-4 Codex review as primary gate.

##### Directive

Do not use technical terms or acronyms that have not been established for the reader's background level. Do not launch into mechanics before naming the purpose. Do not write a multi-paragraph argument without a one-sentence map first. Before writing, name the intended reader for this artifact: adjacent-field graduate student for research papers, junior engineer for API docs, on-call engineer for runbooks, cross-panel reviewer for proposals, release reader for changelogs, or another concrete reader. If that reader would pause to infer what a term means, define it or rewrite around it.

##### BAD → GOOD

- BAD: `We use contrastive learning with InfoNCE and a momentum encoder.`
- GOOD: `Our method trains a representation to separate similar from dissimilar image pairs (contrastive learning), with InfoNCE as the loss and a slowly-updating momentum encoder to stabilize training.`

- BAD: `The API uses JWT with RS256 refresh tokens rotated via the OIDC flow.`
- GOOD: `Authentication uses short-lived signed tokens (JWT with RS256) issued by our OIDC identity provider. Clients refresh these tokens before expiry through the standard OIDC refresh flow.`

- BAD: `We observed activation collapse in the final layer, resolved by adding LayerNorm before the projection head.`
- GOOD: `Final-layer activations collapsed to a near-constant vector during training (activation collapse). Adding a normalization step (LayerNorm) between the backbone and the projection head restored activation diversity.`

- BAD: `We set dropout=0.1, optimizer=AdamW, lr=3e-4, warmup=2000 steps, cosine decay.`
- GOOD: `We regularize with 10% dropout. Optimization uses AdamW (Adam with decoupled weight decay) at learning rate 3e-4, with a 2000-step linear warmup followed by cosine decay to zero.`

- BAD: `SGD converges faster here because of the Hessian conditioning.`
- GOOD: `SGD converges faster than Adam on this task because the loss surface is well-conditioned — the eigenvalues of the second-derivative matrix (Hessian) do not span many orders of magnitude, so a single learning rate suits all directions.`

- BAD (runbook): `If the queue is backed up, bounce the workers and clear the dead-letter.`
- GOOD (runbook): `If RabbitMQ queue depth exceeds 10k messages for more than 5 minutes, (1) drain and restart the Celery worker pool (bounce the workers) so new brokers pick up the rebalanced connections, then (2) drain the dead-letter queue so failed messages do not replay against the now-fresh workers.`

##### Rationale for AI Agent

LLMs absorb their training corpus at a near-expert register and reproduce that register by default. When an AI assistant writes about a technical subject, it does not know whether the current reader is a peer of the training distribution or a junior engineer, cross-team reviewer, external auditor, or grant panelist. The failure mode is almost invisible to the writer (whose knowledge is the baseline) and glaringly visible to the wrong-audience reader. Pinker 2014 Ch. 3 describes the phenomenon in depth; the practical fix compresses to: imagine a specific reader one level below your own expertise, and write for that reader. The concrete test before any technical paragraph is "would this sentence land for someone who has not opened this codebase / read this paper / sat in this meeting?" — if not, rewrite.

### Voice and Directness

#### RULE-02: Do Not Use Passive Voice When the Agent Matters

- **source**: Orwell 1946, "Politics and the English Language," Rule 3: *"Never use the passive where you can use the active."* Strunk & White §II.14 "Use the active voice."
- **agent-instruction evidence**: Zhang et al. 2026 supports negative phrasing for anti-pattern directives in coding-agent instruction files (does not validate mechanical enforcement). Bohr 2025 supports pairing directives with examples for stronger initial style control over a paired two-turn code-generation workflow (not open-ended prose).
- **severity**: high. Recurring AI-tell; passive constructions are the default register in technical prose generated from formal-training distributions.
- **scope**: `.md`, `.tex`, `.rst`, `.txt`, and prose sections of source files.
- **enforcement**: Tier-2 LanguageTool (`PASSIVE_VOICE` family) + Tier-3 agent self-check + Tier-4 Codex review. Not Tier-1 deny because passive-voice regex is high-recall, low-precision (flags many legitimate passives; scientific attribution and true agent-unknown cases remain valid).

##### Directive

Do not write "X was done by Y" when "Y did X" fits. Active voice names the agent, shortens the sentence, and makes the verb carry the action. When the agent is genuinely unknown or irrelevant (scientific attribution, observation of phenomena, general truths), passive is correct; use it deliberately, not by default. Before each passive construction, ask: is the agent known and worth naming? If yes, rewrite active.

##### BAD → GOOD

- BAD: `The experiments were conducted on eight NVIDIA A100 GPUs.`
- GOOD: `We ran the experiments on eight NVIDIA A100 GPUs.`

- BAD: `Errors are logged to /var/log/app.log when the service restarts.`
- GOOD: `The service logs errors to /var/log/app.log on restart.`

- BAD: `A significant improvement in recall was observed after the embedding model was swapped.`
- GOOD: `Swapping the embedding model raised recall@10 by 7 points.`

- BAD (release note): `Memory leaks have been fixed in the worker pool.`
- GOOD (release note): `The worker pool no longer leaks file descriptors on SIGTERM.`

- BAD (postmortem): `The incident was caused by a misconfigured load balancer rule.`
- GOOD (postmortem): ``A misconfigured load balancer rule (typo in the ingress-nginx path-rewrite regex) routed `/auth/*` to the wrong upstream and caused the incident.``

##### Rationale for AI Agent

LLMs trained on formal technical prose (abstracts, RFCs, corporate documentation) overproduce passive constructions by default. The training signal rewards "sounds authoritative" register, and passive constructions are over-represented in that register. The practical cost: passive hides the agent, drops responsibility, and forces the reader to reconstruct who did what. For debugging prose (postmortems, bug reports, root-cause analyses), this is actively harmful because "the error was raised" leaves the caller unnamed; "function `parse_token` raised the error at line 47" localizes the defect immediately. The rule does not ban passive. Scientific attribution ("participants were recruited") and true agent-unknown reports ("the service was restarted during the incident, reason unlogged") keep passive honestly. The rule bans passive-by-default when the agent is known and naming the agent would clarify the sentence.

### Word Choice

#### RULE-03: Do Not Use Abstract or General Language When a Concrete, Specific Term Exists

- **source**: Strunk & White §II.16: *"Use definite, specific, concrete language."* Pinker 2014 Ch. 3 frames abstraction as a primary vector of the curse of knowledge (writer has the specifics; reader does not, and cannot resolve abstract pointers like "factors" or "aspects").
- **agent-instruction evidence**: Zhang et al. 2026 supports negative phrasing for anti-pattern directives in coding-agent instruction files (does not validate mechanical enforcement). Bohr 2025 supports pairing directives with examples for stronger initial style control over a paired two-turn code-generation workflow (not open-ended prose).
- **severity**: high. Recurring clarity failure; generic nouns (`factors`, `aspects`, `considerations`, `issues`, `elements`) are an AI-tell because the model names a category without naming what the category contains.
- **scope**: `.md`, `.tex`, `.rst`, `.txt`, and prose sections of source files.
- **enforcement**: Tier-2 partial (claim-without-number heuristic for "improved", "enhanced", "optimized") + Tier-3 agent self-check + Tier-4 Codex review as primary gate.

##### Directive

Do not use abstract nouns when concrete ones exist. "The system has performance issues" says nothing; "the checkout endpoint p95 latency rose from 120ms to 450ms at 14:00 UTC" names what, when, and how much. Replace category words ("factors", "aspects", "considerations", "issues", "elements") with the specific items they refer to. If you reach for a category word, ask: what exactly? If the answer takes longer than one clause to give, the sentence was hiding the work.

##### BAD → GOOD

- BAD: `The model shows improvements across various metrics.`
- GOOD: `The model improves F1 by 3.2 points (0.812 to 0.844) on FEVER and cuts hallucination rate from 11.3% to 6.8% on TruthfulQA.`

- BAD: `Several architectural considerations influenced our design decisions.`
- GOOD: `We chose a two-tower retrieval architecture over cross-encoding because (1) the query-side embedding is cached across sessions, and (2) the document-side index is updated nightly without re-running inference on the query side.`

- BAD: `Ingestion is affected by data quality factors.`
- GOOD: ``When upstream vendors send records with malformed UTF-8, ingestion drops the record and increments the `malformed_input` counter on the `/metrics` endpoint.``

- BAD (API doc): `Authentication handles multiple scenarios.`
- GOOD (API doc): `Authentication supports three flows: OIDC authorization code (first-party web), client_credentials (service-to-service), and refresh-token rotation (long-lived mobile sessions). Each flow returns a signed JWT with a 15-minute TTL.`

- BAD (runbook): `Scale up the backend if traffic is high.`
- GOOD (runbook): ``If p95 latency on `/search` exceeds 300ms for more than 2 minutes, scale the search worker pool from 8 to 16 replicas via `kubectl scale deployment/search-worker --replicas=16`.``

##### Rationale for AI Agent

LLMs absorb abstract prose from grant abstracts, executive summaries, and position-paper genres where specifics are hidden for competitive or rhetorical reasons. The default output carries that register: "improvements across metrics", "multiple factors", "various considerations". A careful reader processes these phrases, notices nothing has been said, and discounts the rest of the document. The operational test before any factual-claim sentence: can I point at the exact number, file, commit, user action, or mechanism behind each phrase in this sentence? If not, the phrase is filler, and the LLM has hidden the absence of substance behind pleasant-sounding abstraction. Strunk & White §II.16 gives the rule; Pinker 2014 Ch. 3 identifies abstraction as one primary vector of the curse of knowledge (the writer knows the specifics, so "factors" reads as a pointer to them, but the reader has no pointer and cannot resolve it).

#### RULE-04: Do Not Include Needless Words

- **source**: Strunk & White §II.17: *"Omit needless words. Vigorous writing is concise."* Orwell 1946 Rule 3: *"If it is possible to cut a word out, always cut it out."*
- **agent-instruction evidence**: Zhang et al. 2026 supports negative phrasing for anti-pattern directives in coding-agent instruction files; the filler-phrase deny list is our separate mechanical enforcement choice because these specific phrases are directly detectable without a parse. Bohr 2025 supports pairing directives with examples for stronger initial style control over a paired two-turn code-generation workflow (not open-ended prose).
- **severity**: high. Filler phrases are among the most visible AI tells after clichés; wordiness signals a register shift that careful readers detect immediately.
- **scope**: `.md`, `.tex`, `.rst`, `.txt`, and prose sections of source files.
- **enforcement**: Tier-1 `deny` (filler-phrase list in `enforcement/deny-phrases.txt`: "it is important to note that", "in order to", "due to the fact that", "at this point in time", "may potentially", "could possibly", "in the event that", "it may be necessary to") + Tier-2 ProseLint (`terms.denizen_labels`) + Tier-3 agent self-check.

##### Directive

Do not stretch phrases. "In order to" is "to"; "due to the fact that" is "because"; "at this point in time" is "now"; "it is important to note that" is (delete and state the fact); "may potentially" and "could possibly" are redundant hedges (use "may" or "could", not both). Every filler phrase signals to the reader that substance is about to arrive; delete the phrase and let the substance arrive directly.

##### BAD → GOOD

- BAD: `It is important to note that the learning rate was reduced in order to prevent divergence.`
- GOOD: `We reduced the learning rate to prevent divergence.`

- BAD: `Due to the fact that the data pipeline may potentially fail under high load, we have added retry logic.`
- GOOD: `Because the data pipeline can fail under load, we added retry logic.`

- BAD: `At this point in time, the service is able to process approximately 1000 requests per second.`
- GOOD: `The service processes ~1000 requests per second.`

- BAD (PR description): `This PR makes some minor adjustments in order to fix an issue that was causing failures in certain test cases.`
- GOOD (PR description): ``Fixes a null-pointer crash in `test_checkout_flow` when the cart has a single item.``

- BAD (runbook): `In the event that the database connection pool is exhausted, it may be necessary to restart the service in order to recover.`
- GOOD (runbook): `If the connection pool is exhausted, restart the service.`

- BAD (commit message): `Some small changes have been made that may potentially improve the overall performance of the system in certain scenarios.`
- GOOD (commit message): `Cache product lookups in the hot path; reduces p99 from 310ms to 180ms.`

##### Rationale for AI Agent

LLM training rewards formal-sounding, hedge-laden completions because they sit closer to the modal output of the training corpus (press releases, whitepapers, academic abstracts, corporate documentation) than terse technical writing does. The specific filler phrases ("in order to", "due to the fact that", "it is important to note", "may potentially", "could possibly") are consensus cliché of that register. They lengthen sentences without carrying information. Human readers skim past them and infer the writer had little to say; downstream consumers (search indices, RAG pipelines, summarization chains) also suffer from the diluted signal-per-token ratio. The exact-phrase deny list is mechanically enforceable (Tier-1) because these phrases have no legitimate technical function: "in order to" is always replaceable by "to" with no loss of meaning, so denying the phrase outright has near-zero false-positive risk. Strunk & White §II.17 gives the principle; Orwell 1946 Rule 3 gives the cut-if-possible operational test.

#### RULE-07: Use Affirmative Form for Affirmative Claims ("Trivial" Instead of "Not Important")

- **source**: Strunk & White §II.15: *"Put statements in positive form."*
- **agent-instruction evidence**: Zhang et al. 2026 supports negative phrasing for anti-pattern directives in coding-agent instruction files; RULE-07 carries a positive directive because the target is a constructive placement (choose the affirmative word) rather than an anti-pattern to flag. Bohr 2025 supports pairing directives with examples for stronger initial style control over a paired two-turn code-generation workflow.
- **severity**: medium. Readability cost rather than clarity failure; readers parse "not important" correctly, just slower than "trivial".
- **scope**: `.md`, `.tex`, `.rst`, `.txt`, and prose sections of source files.
- **enforcement**: Tier-3 agent self-check + Tier-4 Codex review. No Tier-1 deny (requires judgment about whether the positive form exists and fits). Empty-hedge phrases ("may potentially", "could possibly") live under RULE-04, not here, because they are redundant hedges rather than double negations.

##### Directive

Replace "not important" with "trivial"; "did not remember" with "forgot"; "did not pay attention to" with "ignored"; "is not often" with "rarely"; "is not large" with "small"; "does not succeed" with "fails". Prefer one affirmative word over two negating words. When the sentence genuinely negates something (the proposition is true only in the negative), a single "not" is fine and necessary. The rule targets two-word negations that have a one-word affirmative equivalent. The operational test: can I replace "not X" with a single positive word that names the state directly? If yes, do so.

##### BAD → GOOD

- BAD: `The variance was not large.`
- GOOD: `The variance was small.`

- BAD: `He did not remember to set the flag.`
- GOOD: `He forgot to set the flag.`

- BAD: `This method is not as accurate as the baseline.`
- GOOD: `This method is less accurate than the baseline (81.7% vs 88.3% top-1 on ImageNet-1k).`

- BAD (bug report): `The function does not return a value in some cases.`
- GOOD (bug report): ``The function returns `undefined` when the input array is empty (missing branch in `parse_row` at `utils/parse.py:47`).``

- BAD (release note): `Startup time is not as slow as in the previous release.`
- GOOD (release note): `Startup time drops from 4.2s to 1.8s (57% faster) by deferring the plugin scan to first interactive action.`

- BAD: `The cache is not frequently invalidated.`
- GOOD: `The cache is rarely invalidated, roughly once per deploy.`

##### Rationale for AI Agent

Double-negation phrasing ("not insignificant", "not uncommon", "not unlike") pervades academic and journalistic prose, and LLMs absorb the pattern from training. The cognitive cost is real: the reader holds "not" in working memory, parses the negated adjective, then negates again to recover the intended meaning. For simple affirmative states, this is wasted work. The rule does not ban honest negation; when something is genuinely absent, "no X" or "not X" is correct. The rule bans avoidable compound negation where a positive-form word already names the state. A downstream concern for AI-generated prose: double-negation also defeats tone and sentiment detection in downstream tooling, so in contexts where the text feeds another model (summarization, classification, moderation), positive form is operationally safer.

#### RULE-08: Do Not Linguistically Overstate or Understate Claims Relative to the Evidence

- **source**: Pinker 2014 Ch. 6 (calibrated claims; hedge calibration treated as a skill with verbs matched to evidence strength). Gopen & Swan 1990 (scientific attribution: the source of a claim should be visible in the sentence, and the verb should match the evidence).
- **agent-instruction evidence**: Zhang et al. 2026 supports negative phrasing for anti-pattern directives in coding-agent instruction files (does not validate mechanical enforcement). Bohr 2025 supports pairing directives with examples for stronger initial style control over a paired two-turn code-generation workflow (not open-ended prose).
- **severity**: high. Externally visible AI-tell; overclaim patterns ("revolutionary", "transforms", "dramatic") and reflexive weasel ("it might be worth considering") are both recognized by technical readers as filler register, each eroding trust differently.
- **scope**: `.md`, `.tex`, `.rst`, `.txt`, and prose sections of source files.
- **enforcement**: Tier-3 agent self-check + Tier-4 Codex review as primary gate. Not Tier-1 because calibration requires judgment about what the evidence actually supports.

##### Directive

Do not overclaim (saying "proves X" when the evidence is "suggests X"). Do not underclaim via reflexive weasel (saying "it might be worth considering" when you mean "we should do X"). Calibrate verbs to evidence: experimental results "suggest" or "show"; theoretical derivations "imply" or "prove"; user reports "indicate" (pending verification); benchmarks "measure". Use "best" only when you have compared against the strongest alternative; use "only" only when you have ruled out alternatives. When the evidence is uncertain, say so in one clause; do not weaken the main verb beyond what the evidence supports.

##### BAD → GOOD

- BAD: `Our method revolutionizes language model alignment.`
- GOOD: `Our method reduces harmful-completion rate on HarmBench from 14.1% to 3.2% without degrading MMLU accuracy. (Generalization to other alignment benchmarks is future work.)`

- BAD: `Dramatic improvement in inference speed was observed.`
- GOOD: `Inference latency at batch size 1 drops from 142ms to 118ms (17% faster) on A100. Batch size 32 and larger show no measurable speedup.`

- BAD: `It might be worth considering whether some form of input validation could be beneficial.`
- GOOD: ``Add input validation at `/users`: the endpoint crashes on non-UTF-8 query parameters (observed twice last week).``

- BAD (paper abstract): `Our model proves the superiority of attention-based retrieval over sparse methods.`
- GOOD (paper abstract): `Our attention-based retriever reaches MRR@10 = 0.412 on MS MARCO Dev, compared to 0.395 for BM25 and 0.398 for ColBERT. The improvement is within one standard deviation on out-of-domain queries (BEIR).`

- BAD (issue report): `Everything is broken; nothing works.`
- GOOD (issue report): ``/auth/login returns 500 for all requests after the 2026-04-18 deploy. /auth/logout and /auth/refresh unaffected. Logs show a KeyError on `iat` in token parsing.``

- BAD (grant proposal): `This research will transform our understanding of neural network interpretability.`
- GOOD (grant proposal): `This research tests whether attention-probing generalizes beyond the 12 factual-recall circuits reported in Meng et al. 2022. If yes, the method applies to a class of interpretability questions currently intractable; if no, we localize the method's scope.`

##### Rationale for AI Agent

LLMs trained on mixed-register corpora (research abstracts, press releases, grant introductions, marketing copy) absorb both overclaiming and reflexive hedging from the genre patterns. Each fails predictably: overclaim trips the reader's calibration alarm (technical readers scan abstracts for unwarranted "proves" or "best" and discount the rest of the paper accordingly); reflexive under-hedging inflates trivially-true claims to sound important; over-hedging delays the main point across two clauses of pro-forma caution. The operational test before writing any result sentence: (a) what evidence supports this, and (b) does the verb match? "We observed" is weaker than "we showed" is weaker than "we proved." Pick the verb that matches your evidence exactly. Pinker 2014 Ch. 6 gives the calibration vocabulary; Gopen & Swan 1990 frame scientific attribution as a structural writing concern (the source of a claim should be visible, and the verb should match the evidence).

### Sentence Structure

#### RULE-09: Express Coordinate Ideas in Similar Form (Parallel Structure)

- **source**: Strunk & White §II.19: *"Express coordinate ideas in similar form."*
- **agent-instruction evidence**: Zhang et al. 2026 supports negative phrasing for anti-pattern directives in coding-agent instruction files; RULE-09 carries a positive directive because parallel structure is a constructive placement (match the form across items) rather than an anti-pattern to flag. Bohr 2025 supports pairing directives with examples for stronger initial style control over a paired two-turn code-generation workflow.
- **severity**: medium. Local readability cost; readers reparse mismatched items and lose rhythm, but still recover the meaning.
- **scope**: `.md`, `.tex`, `.rst`, `.txt`, and prose sections of source files.
- **enforcement**: Tier-2 partial (list-item POS check on bullet lists) + Tier-3 agent self-check + Tier-4 Codex review.

##### Directive

Write coordinate ideas in the same grammatical form. In a list of three items, if item 1 is a noun phrase, items 2 and 3 are also noun phrases; if item 1 is a verb-initial clause, items 2 and 3 are also verb-initial clauses. The rule applies to bullet lists, parallel predicates ("we measure X, improve Y, and validate Z"), and compound sentences connected by "and" / "or" / "but". Mismatched forms force the reader to reparse each item against a new expected structure.

##### BAD → GOOD

- BAD: `The pipeline cleans the data, feature extraction, and then trains the model.`
- GOOD: `The pipeline cleans the data, extracts features, and trains the model.`

- BAD: `We benchmark against three baselines: BM25, a sparse lexical retriever; dense retrieval using DPR; ColBERT.`
- GOOD: `We benchmark against three baselines: BM25 (sparse lexical), DPR (single-vector dense), and ColBERT (multi-vector dense).`

- BAD (API doc): `The endpoint accepts JSON input, you get XML back, and pagination is via cursor.`
- GOOD (API doc): `The endpoint accepts JSON input, returns XML output, and paginates by cursor.`

- BAD (runbook checklist item, in a list of verb-initial items): `Memory usage`
- GOOD (runbook checklist item, matching surrounding items): `Check memory (`free -h`)`

- BAD (changelog entry, in a list of verb-initial entries): `Faster startup`
- GOOD (changelog entry, matching surrounding entries): `Reduce startup time from 4.2s to 1.8s.`

##### Rationale for AI Agent

LLMs often produce lists where the first one or two items set a structure, then subsequent items drift because the model samples each next item conditional on the topic rather than on the established structure. The drift is subtle: a reader scans item 1, forms an expected shape for items 2 and 3, then hits a mismatch and backtracks. Simple cases are mechanically checkable (lists where item 1 starts with verb X should have items 2 and 3 starting with verbs of the same tense; lists of noun phrases should remain noun phrases), but the general case requires parse. The practical remedy for AI generation: when generating a list, first decide the structure (all verb phrases? all noun phrases? subject-verb-object?), then generate each item against that structure rather than sampling freely. Strunk & White §II.19 gives the rule and a diagnostic: read the list with "that" connecting items; if any item fails the read, parallelism is broken.

#### RULE-10: Keep Related Words Together

- **source**: Strunk & White §II.20: *"Keep related words together."* Gopen & Swan 1990 treat verb-subject proximity as a structural readability concern in scientific prose specifically (long subject-to-verb gaps are one of the most common causes of unreadable science writing).
- **agent-instruction evidence**: Zhang et al. 2026 supports negative phrasing for anti-pattern directives in coding-agent instruction files; RULE-10 carries a positive directive because the target is a constructive placement (keep X close to Y) rather than an anti-pattern to flag. Bohr 2025 supports pairing directives with examples for stronger initial style control over a paired two-turn code-generation workflow.
- **severity**: medium. Local readability cost; long subject-to-verb gaps cause reader working-memory overflow and backtracking, but the meaning remains recoverable with effort.
- **scope**: `.md`, `.tex`, `.rst`, `.txt`, and prose sections of source files.
- **enforcement**: Tier-2 partial (dep-parse distance between subject and verb) + Tier-3 agent self-check + Tier-4 Codex review.

##### Directive

Keep subject close to verb, verb close to object, and modifier close to modified. When a long parenthetical or relative clause must appear between subject and verb, move the clause to the end of the sentence or split into two sentences. The operational test: count words between subject and verb; if the gap exceeds 8, split. Readers hold the subject in working memory until the verb arrives; every intervening clause costs memory slots and increases misparsing risk.

##### BAD → GOOD

- BAD: `The model, which was pre-trained on a mixed corpus of English Wikipedia, Common Crawl, and a 400-million-token curated scientific dataset assembled by the authors over eight months, achieves 87.2% accuracy.`
- GOOD: `The model achieves 87.2% accuracy. It was pre-trained on a mixed corpus of English Wikipedia, Common Crawl, and a 400-million-token scientific dataset the authors curated over eight months.`

- BAD: `Users of the legacy authentication flow, which is being deprecated in Q3 2026 in favor of the new OIDC-based system described in the migration guide, must update their client libraries before the end-of-life date.`
- GOOD: `Users of the legacy authentication flow must update their client libraries before end-of-life. The legacy flow is being deprecated in Q3 2026; the replacement is OIDC-based (see migration guide).`

- BAD (API doc): `The /users endpoint returns, subject to the rate-limit and access-control constraints described below, a paginated list of user objects.`
- GOOD (API doc): `The /users endpoint returns a paginated list of user objects. Rate limits and access controls apply (see below).`

- BAD (postmortem): `The database replica, which had been failing its health checks intermittently for three days before the outage but was never promoted to primary during that period because of a misconfigured priority setting, was the direct cause of the outage.`
- GOOD (postmortem): `The database replica was the direct cause of the outage. It had been failing health checks intermittently for three days; a misconfigured priority setting prevented promotion to primary during that period.`

- BAD: `We found that the retrieval recall of our system, compared against the previously strongest baseline across all five evaluation datasets and using the same pre-processing pipeline, improved by 7 points at k=10.`
- GOOD: `Retrieval recall@10 improved by 7 points over the previously strongest baseline. The comparison used the same pre-processing pipeline across all five evaluation datasets.`

##### Rationale for AI Agent

LLMs generate text token-by-token conditional on prior context, which encourages completeness (every qualifier added inline) over readability (qualifiers deferred until the main clause lands). The result: sentences where the subject and verb are separated by 20+ words of parenthetical qualification. Readers experience this as working-memory overflow. By the time the verb arrives, the reader has lost the subject and must backtrack. The same logic applies to verb-object and modifier-modified pairs. Gopen & Swan 1990 frame long subject-to-verb gaps as one of the most common causes of unreadable scientific prose; Strunk & White §II.20 give the principle in general form. For AI generation specifically, the practical remedy is to split the sentence: the main claim lands in the first sentence, supporting qualifications follow in a second sentence.

#### RULE-11: Place New or Important Information in the Stress Position at the End of the Sentence

- **source**: Gopen & Swan 1990, "The Science of Scientific Writing" (stress-position framing; empirical treatment of reader expectation for new information at sentence end).
- **agent-instruction evidence**: Zhang et al. 2026 supports negative phrasing for anti-pattern directives in coding-agent instruction files; RULE-11 carries a positive directive because stress-position placement is a constructive structural rule rather than an anti-pattern to flag. Bohr 2025 supports pairing directives with examples for stronger initial style control over a paired two-turn code-generation workflow.
- **severity**: medium. Local readability cost; readers recover the claim from a front-loaded sentence but at the cost of re-reading, and skim-readers pick up the words before the final punctuation as the takeaway, so stress-position misuse dilutes the sentence's impact.
- **scope**: `.md`, `.tex`, `.rst`, `.txt`, and prose sections of source files.
- **enforcement**: Tier-3 agent self-check + Tier-4 Codex review. Not Tier-1 because identifying the "key fact" in a sentence requires judgment.

##### Directive

End sentences with the information you want the reader to remember. The beginning of a sentence (topic position) connects to what came before; the end (stress position) is where new or important information lands with maximum emphasis. If the key fact is in the middle, move it to the end or rebalance. The rule applies especially to result sentences in papers, conclusions in design docs, and root-cause lines in postmortems.

##### BAD → GOOD

- BAD: `A 3.2-point improvement in F1 over the previous best model was demonstrated by the new architecture on the SQuAD 2.0 test set.`
- GOOD: `On the SQuAD 2.0 test set, the new architecture improves F1 by 3.2 points over the previous best model.`

- BAD: `The outage was caused by a cron job that ran at the wrong time.`
- GOOD: ``The outage was caused by a cron job firing every minute instead of every hour (typo in the crontab: `* * * * *` instead of `0 * * * *`).``

- BAD (commit message): `Fix for issue where users occasionally see a blank page in the dashboard when their session has expired and they try to navigate to a protected route.`
- GOOD (commit message): `On expired-session navigation to protected routes, redirect to /login instead of rendering the blank dashboard frame.`

- BAD (release note): `Performance improvements in the search pipeline are included in this release, with p95 query latency improving from 340ms to 95ms and p99 from 870ms to 180ms.`
- GOOD (release note): `p95 search latency drops from 340ms to 95ms; p99 drops from 870ms to 180ms.`

- BAD (paper sentence): `The approach is to first train a contrastive embedder, and then the retrieval performance can be measured across the five benchmarks.`
- GOOD (paper sentence): `We first train a contrastive embedder, then measure retrieval performance across five benchmarks: MS MARCO, FEVER, HotpotQA, NQ, and TriviaQA.`

##### Rationale for AI Agent

Gopen & Swan 1990 show empirically (American Scientist study of sentence clarity) that readers unconsciously expect the stress position for new information. When a sentence front-loads the new information and tails off into background, readers experience the sentence as flat and re-read to recover the claim. LLMs often produce the BAD pattern because token-by-token generation rewards completing the sentence with whatever is most fluent, frequently a prepositional phrase that restates topic material already established rather than introducing new information. The operational rewrite: identify the sentence's key claim, then rebuild the sentence so that the claim lands at the end. For multi-sentence units (paragraphs), the same logic applies at the paragraph level: the opening sentence frames; the final sentence lands the main point; middle sentences support.

#### RULE-F: Use Consistent Terms; Do Not Redefine Abbreviations Mid-Document

- **source**: My observation of LLM output across dozens of writing projects and code releases, 2022–2026. Adjacent to `agent-config` / `anywhere-agents` AGENTS.md Writing Defaults: "Use consistent terms. If an abbreviation is defined once, do not define it again later."
- **agent-instruction evidence**: Zhang et al. 2026 supports negative phrasing for anti-pattern directives in coding-agent instruction files (does not validate mechanical enforcement). Bohr 2025 supports pairing directives with examples for stronger initial style control over a paired two-turn code-generation workflow (not open-ended prose).
- **severity**: medium. Recurring clarity failure in long documents; varied terms force the reader to check whether each new term refers to the same concept or a new one.
- **scope**: `.md`, `.tex`, `.rst`, `.txt`, and prose sections of source files.
- **enforcement**: Tier-2 (first-use abbreviation tracking across document; flag later re-expansions and flag synonym drift when a defined abbreviation is replaced with a paraphrase without reason) + Tier-3 agent self-check + Tier-4 Codex review.

##### Directive

Once you introduce a term or abbreviation, keep using it. Do not alternate "large language model", "LLM", "language model", "LM", "neural language model", "foundation model" as synonyms for the same thing. Do not redefine an abbreviation: if `LLM` was defined as `large language model` in the introduction, do not expand it again in section 3. For the reader, a consistent term signals "this is the same concept I saw earlier"; varied terms signal "I should check whether this is something new."

##### BAD → GOOD

- BAD (paper, term drift): introduces "large language models (LLMs)" in §1, then writes in §3: "Neural language models achieve..."
- GOOD (paper): introduces "large language models (LLMs)" in §1, then writes in §3: "LLMs achieve..."

- BAD (doc, expansion re-emerges): "We use retrieval-augmented generation (RAG). ... / later / Retrieval-augmented-generation architectures..."
- GOOD (doc): "We use retrieval-augmented generation (RAG). ... / later / RAG architectures..."

- BAD (API doc, drift across synonyms): "The `/users` endpoint returns user objects. ... / later / The user endpoint supports filtering. ... / later / Our user resource accepts query parameters ..."
- GOOD (API doc): "The `/users` endpoint returns user objects. ... / later / `/users` supports filtering. ... / later / `/users` accepts query parameters ..."

- BAD (proposal, specific-aim drift): "Aim 1 focuses on retrieval. ... Aim 1 addresses document selection. ... The first aim investigates retrieval-augmented generation."
- GOOD (proposal): "Aim 1 focuses on retrieval. ... Aim 1 addresses document selection. ... Aim 1 investigates retrieval-augmented generation."

- BAD (runbook, system synonyms): "If the service is down, restart the service. If `app-v2` is offline, bounce the worker pool. If the backend stops responding, failover."
- GOOD (runbook): "If `app-v2` is offline, restart via `systemctl restart app-v2.service`. If `app-v2` still fails, failover to the replica."

##### Rationale for AI Agent

LLMs often vary terminology within a document because variety is mildly rewarded in the training distribution (reviewers and editors mark repetitive vocabulary as prose to be varied, and LLMs learn to alternate). But in technical writing, variety across terminology for the same entity masks the entity's identity and forces the reader to check whether each new term refers to the same concept. RULE-01 covers the first-use introduction of terms; RULE-F covers keeping them consistent thereafter. Gopen & Swan 1990 discuss this under "topic continuity", where subjects and entities should reappear as the same linguistic form across sentences. For documents produced in multi-turn generation, the risk is especially high because the model samples each new paragraph without guaranteed visibility into earlier-introduced terms, leading to drift. The fix at generation time: after defining a term, the agent should maintain a running glossary for the document and re-use the defined form consistently.

#### RULE-H: Support Factual Claims with Citation or Concrete Evidence; Do Not Be Handwavy

- **source**: My observation of LLM output across dozens of writing projects and code releases, 2022–2026. Adjacent to `agent-config` / `anywhere-agents` AGENTS.md Writing Defaults: "If citing papers, verify that they exist." This rule is the flagship of the three-rule cluster against handwavy prose (RULE-03 on vague nouns, RULE-08 on uncalibrated verbs, RULE-H on unsupported claims).
- **agent-instruction evidence**: Zhang et al. 2026 supports negative phrasing for anti-pattern directives in coding-agent instruction files (does not validate mechanical enforcement). Bohr 2025 supports pairing directives with examples for stronger initial style control over a paired two-turn code-generation workflow (not open-ended prose).
- **severity**: critical. Uncited claims are a trust failure; fabricated citations are worse (permanent damage to reader trust once the fabrication is discovered). LLMs both default to citation-free hedges ("prior work shows", "recent studies suggest") and actively hallucinate plausible-looking citations that do not exist (Ji et al. 2023 survey of hallucination in NLG; Agrawal et al. 2024 empirical measurement).
- **scope**: `.md`, `.tex`, `.rst`, `.txt`, and prose sections of source files.
- **enforcement**: Tier-3 agent self-check (judgment about what needs attribution) + Tier-4 Codex review as primary gate. Supporting practice for agents: before writing any `Author Year` citation, verify via search (DBLP, arXiv, Google Scholar, or the cited paper's own bibliography) that the reference exists and supports the cited claim; otherwise mark `[UNVERIFIED]` placeholder or rewrite the sentence. Never generate a citation without verification.

##### Directive

When a sentence asserts a factual claim that warrants attribution (empirical result, published method, community consensus, comparative benchmark, historical fact), provide a verifiable citation, or name the specific source (a paper by author and year, a benchmark, a dataset, an observed experiment). Do not write handwavy attributions ("prior work shows", "it is well known that", "recent studies suggest", "many researchers believe") without naming the specific work. When the claim is the author's own observation, state the concrete evidence (number, dataset, experiment, condition). Never invent a citation; if the cited paper cannot be verified, remove the claim, soften it to the author's own observation, or mark `[UNVERIFIED]` and flag for review.

##### BAD → GOOD

- BAD (paper): `Prior work has shown that late-interaction retrieval improves over lexical retrieval.`
- GOOD (paper): `Khattab and Zaharia 2020 (ColBERT) report MS MARCO passage-ranking MRR@10 of 0.360 for ColBERT versus 0.187 for BM25-Anserini, using contextualized late interaction over BERT token embeddings.`

- BAD: `It is widely accepted that longer context improves RAG performance.`
- GOOD: `Liu et al. 2023/2024 (TACL, "Lost in the Middle") show that models answer less accurately when the relevant evidence is in the middle of a long context than near the beginning or end; Dsouza et al. 2024 report the same lost-in-the-middle pattern for GPT-4 and Claude 3 Opus.`

- BAD (paper): `Several studies have demonstrated the effectiveness of this approach.`
- GOOD (paper): `In our reproduced evaluation, the model improves GSM8K exact-match accuracy from 92.1% to 95.2% and MATH exact-match accuracy from 48.0% to 51.4% under the same decoding settings.`

- BAD (grant proposal): `Our pilot results look promising.`
- GOOD (grant proposal): `Our pilot (N=30 cohort, 3-month follow-up) shows AUROC 0.84 for the primary endpoint versus 0.72 for the standard-of-care baseline (p=0.012).`

- BAD (blog post): `Many researchers believe that contrastive learning produces better embeddings.`
- GOOD (blog post): `Chen et al. 2020 (SimCLR) report 76.5% ImageNet top-1 linear-evaluation accuracy for a self-supervised ResNet-50, a 7% relative gain over prior self-supervised methods and comparable to a supervised ResNet-50 baseline in their setup.`

- BAD (commit message): `Fix based on user feedback.`
- GOOD (commit message): `Fix null-pointer crash reported in issue #1847 (reproducible with empty cart).`

##### Rationale for AI Agent

LLMs produce handwavy, citation-free claims as a default register absorbed from formulaic abstract and review prose in the training corpus. Phrases like "prior work shows", "recent studies suggest", "it is well known that", "many researchers believe" appear at high frequency in academic introductions and review articles, where they serve as transition filler between specific claims. LLMs sample them at comparable rates without carrying the specific attributions that human authors have in mind when writing them. Additionally, LLMs hallucinate citations that look plausible (matching author conventions, year ranges, venue patterns) but point to non-existent papers; the hallucination rate is well-documented across domains. Both failures compound: an uncited claim is unverifiable, and a fabricated citation is worse than no citation because it damages reader trust permanently once discovered. The operational test before writing any factual-claim sentence: is there a specific, verifiable source, observation, or number behind this? If yes, state it by author and year, or by dataset and measurement. If no, either find the source before writing, or rewrite the sentence as a claim about the author's own experience (which must still be concrete: numbers, dataset, conditions). For LLMs specifically: never generate a citation without first verifying via DBLP, arXiv, Google Scholar, or the cited paper's own bibliography. If verification is not possible in the current session, mark `[UNVERIFIED]` and flag for review. Related: RULE-03 fights vague nouns; RULE-08 fights uncalibrated verbs; RULE-H fights unsupported claims. All three aim at specific, verifiable, honest prose; a single sloppy sentence often fires all three rules simultaneously.

