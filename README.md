# README

see [ERD](https://docs.google.com/document/d/1iZRX1ZaRG05gA-aZ-uj2LWHmHuP3cXys154DSYu8J0g/edit)

# USAGE

1) Enable Uber's [Phabricator Integration for Buildkite](https://engdocs.uberinternal.com/buildkite/internal/phabricator_integration.html)

2) For every Buildkite step, add the following plugin:

```
'uber-workflow/uber-checkout': {}
```

For example:

```
steps:
  - name: 'my step'
    key: my_step
    commands: 
      - "ls -al"
    plugins:
      'uber-workflow/uber-checkout': {}
```

# TODO
- [ ] add caching support to reduce gitolite load
- [ ] somehow set this plugin for all steps (so users don't need to do it explicitly)
