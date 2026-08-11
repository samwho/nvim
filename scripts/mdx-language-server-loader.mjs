// @mdx-js/language-server 0.6.3 imports vscode-uri's ESM build as a
// default export, although that package only exposes named exports. Patch the
// one generated import at load time so the Mason server works with Node 22+.
const broken_module = '/vscode-markdown-languageservice/out/util/vscodeUri.js'

export async function load(url, context, next_load) {
  const result = await next_load(url, context)
  if (!url.endsWith(broken_module) || result.source == null) return result

  const source = typeof result.source === 'string'
    ? result.source
    : new TextDecoder().decode(result.source)
  const patched_source = source.replace(
    "import uri from 'vscode-uri';",
    "import * as uri from 'vscode-uri';",
  )
  return { ...result, format: 'module', source: patched_source, shortCircuit: true }
}
