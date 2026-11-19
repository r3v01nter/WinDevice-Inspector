# Documentation Index

This directory contains the maintained product and engineering documentation.

## Start here

- [Project Overview](PROJECT_OVERVIEW.md): what the product is, why it exists, who it serves, and what is in/out of scope.
- [Product Requirements](PRODUCT_REQUIREMENTS.md): confirmed user-facing behavior and acceptance expectations.
- [Technical Architecture](TECHNICAL_ARCHITECTURE.md): layers, data flow, collection boundaries, storage, and testing.
- [Repository Structure](REPOSITORY_STRUCTURE.md): directory responsibilities and naming rules.
- [Roadmap](ROADMAP.md): staged delivery sequence.
- [Project Status](PROJECT_STATUS.md): current verified state and next actions.
- [AI Collaboration](AI_COLLABORATION.md): Gemini implementation workflow and ChatGPT technical review.

## Reference material

- decisions/: accepted architecture decisions (ADRs).
- tasks/: implementation task briefs and acceptance criteria.
- templates/: reusable task and completion receipt templates.

## Document precedence

1. Confirmed product decisions in PRODUCT_REQUIREMENTS.md.
2. Accepted architecture decisions in decisions/.
3. Current technical architecture.
4. The active task brief, which must be updated if it conflicts with a higher-level decision.
5. Roadmap and status summaries.

If a contradiction is found, stop and report it. Do not silently choose a new product behavior.
