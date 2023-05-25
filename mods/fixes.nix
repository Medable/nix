final: prev: with prev; {
  nodejs_16 = prev.nodejs_16.overrideAttrs (_: { meta.platforms = prev.lib.platforms.all; meta.knownVulnerabilities = [ ]; });
}
