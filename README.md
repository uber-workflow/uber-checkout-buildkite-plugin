# Background

The default buildkite checkout plugin puts excessive load on gitolite -- using this plugin mitigates that issue and improves performance by utilizing a cache of your git repo. In addition, there are various flavors of checkout depending on how the buildkite build was initiated (diff, master, submit queue, manual trigger) — this plugin allows us to consolidate that logic in a single place so you don't need re-implement it yourself.

For more details, see the [ERD](https://docs.google.com/document/d/1iZRX1ZaRG05gA-aZ-uj2LWHmHuP3cXys154DSYu8J0g/edit#)

# Instructions

The following is required to use this plugin:
1) Set up our Buildkite Phabricator integration using [these instructions](https://engdocs.uberinternal.com/buildkite/internal/phabricator_integration.html). Make sure you set up the staging repo as described in the instructions.

2) In your buildkite pipeline yaml config, set this plugin to override the default checkout hook and use this plugin's logic instead. Make sure you set `repo` and `staging_repo` using the values from step 1) above. Here's an example of what the plugin looks like for the [web-code repo](https://code.uberinternal.com/diffusion/WEBCODR/):
```
steps:
  - name: 'my pipeline step'
    key: 'my pipeline key'
    commands: 'echo hello'
    plugins:
      - ssh://gitolite@code.uber.internal/infra/uber-checkout-buildkite-plugin:
          repo: 'gitolite@code.uber.internal:web-code'
          staging_repo: 'gitolite@code.uber.internal:web-code'
```

# Development

### test

`go test ./...`

### build

`go build main.go`

### run

`go build main.go && ./main`

### update binary

The buildkite checkout hook in the `hooks` folder uses the checked-in binary in the `bin` folder for performance reasons. Run the following command to update the binaries:

`./update_binaries.sh`