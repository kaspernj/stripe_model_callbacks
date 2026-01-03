## Notes
- Do not commit or push automatically; ask before running `git commit` or `git push`.
- Run `bundle exec rubocop` on any changed or added `.rb` files.
- Attribute rule: when a Stripe attribute is missing, preserve `nil` to indicate "not provided"; avoid defaulting to false for optional fields like `auto_advance`.
