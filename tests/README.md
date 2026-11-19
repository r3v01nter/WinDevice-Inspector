# Tests

This directory contains automated test projects, synthetic fixtures, and test utilities.

Tests must not depend on real user scan exports or embed real machine identifiers. The consent boundary is critical: tests must prove that application startup and a cancelled confirmation never invoke a collector.

See the technical architecture and TASK-0001.
