Request to add pkg-config integration for building and linking the library and demos, to improve portability and ease of use for dependent projects and local development.

Goals:
- Provide a .pc file for libdivide.a
- Update Makefiles to allow building via pkg-config (optionally fallback to manual linking)
- Document usage in README
