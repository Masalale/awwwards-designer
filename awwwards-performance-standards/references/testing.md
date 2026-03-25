# Testing — Deep Dive

Performance that isn't measured is performance that isn't controlled. This guide covers lab testing (Lighthouse, WebPageTest), field testing (CrUX, RUM), CI enforcement, and regression detection.

---

## Lighthouse Audit Walkthrough

Lighthouse is your first stop for diagnosing performance issues. It runs in Chrome DevTools, CLI, or PageSpeed Insights.

### Running Lighthouse (Chrome DevTools)

1. Open Chrome DevTools (`F12` or `Cmd+Opt+I`)
2. Navigate to the **Lighthouse** panel
3. Select **Navigation** (for page load) or **Timespan** (for interactions)
4. Check **Performance** (and optionally Accessibility, Best Practices, SEO)
5. Choose **Device**: Mobile (default, throttled) or Desktop
6. Click **Analyze page load**

### Reading the Lighthouse Report

```
Performance: 85/100

Core Web Vitals:
  LCP: 2.3s         [orange]  ← Needs Work
  TBT: 180ms        [green]   ← Good
  CLS: 0.05         [green]   ← Good
  FCP: 1.1s         [green]   ← Good

Opportunities:
  ⚠ Serve images in AVIF/WebP      savings: 420KB
  ⚠ Properly size images            savings: 280KB
  ⚠ Defer offscreen images          savings: 150KB
  ⚠ Eliminate render-blocking CSS   savings: 45ms

Diagnostics:
  ⚠ Largest Contentful Paint element: <img class="hero">
  ⚠ Has a `<link rel="preload">` for LCP image
  ⚠ Avoid large layout shifts        CLS elements: 2
```

### Lighthouse CLI (CI / Automation)

```bash
# Install
bun add -g lighthouse

# Run
lighthouse https://yoursite.com \
  --output=html \
  --output-path=./lighthouse-report.html \
  --only-categories=performance \
  --preset=desktop

# JSON output for programmatic use
lighthouse https://yoursite.com \
  --output=json \
  --output-path=./lighthouse-report.json
```

### Lighthouse CI (Automated Checks)

```yaml
# .lighthouserc.yml
ci:
  collect:
    url: [
      'https://yoursite.com/',
      'https://yoursite.com/about',
      'https://yoursite.com/work'
    ]
    numberOfRuns: 3
    settings:
      preset: desktop
      throttlingMethod: simulate
  assert:
    assertions:
      categories:performance:
        minScore: 0.9
      "first-contentful-paint":
        maxNumericValue: 1800
      "largest-contentful-paint":
        maxNumericValue: 2500
      "cumulative-layout-shift":
        maxNumericValue: 0.1
      "total-blocking-time":
        maxNumericValue: 300
```

---

## WebPageTest

WebPageTest is the definitive tool for waterfall analysis, filmstrip views, and custom testing scenarios that Lighthouse can't handle.

### Key Features

- **Waterfall chart** — See every request, timing, size, and order
- **Filmstrip view** — Visual playback of page loading frame by frame
- **Custom throttling** — Simulate 3G, 4G, slow 4G, cable, custom
- **Multiple runs** — Capture consistency, not just one sample
- **Geographic testing** — Test from real locations worldwide
- **Video comparison** — Side-by-side A/B testing

### Reading the Waterfall

```
Timeline:
  0ms     DNS lookup       (bar: teal)
  50ms    TCP connect      (bar: orange)
  100ms   SSL handshake    (bar: purple)
  150ms   TTFB             (bar: green)
  200ms   Content download (bar: blue)
  400ms   DOM interactive  (bar: red marker)
  800ms   Onload          (bar: blue marker)
```

### Key WebPageTest Metrics

| Metric | What It Tells You |
|--------|------------------|
| **TTFB** | Server responsiveness (aim < 400ms) |
| **Start Render** | When something first appears (aim < 1.5s) |
| **FCP** | First contentful paint (aim < 1.8s) |
| **LCP** | Largest contentful paint (aim < 1.8s) |
| **CLS** | Cumulative layout shift |
| **Speed Index** | Overall visual completeness over time |
| **Fully Loaded** | When all resources finished loading |
| **CPU Busy** | Main thread utilization |
| **Main Thread** | Breakdown of JS execution |

### WebPageTest Config

```
URL: https://yoursite.com
Location: us-east-1 (Chrome, throttled)
Connection: Cable (5 Mbps down, 1 Mbps up, 28ms RTT)
Viewport: 1366x768
Repeat View: first view only (or cached)
```

### Filmstrip Analysis

Use the filmstrip to identify:
1. **When does LCP happen?** — Is it on the hero image, text, or background?
2. **Is there a blank screen before first paint?** — Means render-blocking resources
3. **Does content jump during load?** — CLS from late-loading content
4. **Is the loading experience smooth?** — No jarring transitions

---

## PageSpeed Insights

PageSpeed Insights (PSI) combines **field data** (real users, CrUX) with **lab data** (Lighthouse).

### Using PageSpeed Insights

1. Go to [pagespeed.web.dev](https://pagespeed.web.dev)
2. Enter URL
3. Get field + lab analysis side by side

### Field Data (CrUX — 75th Percentile)

```
Field Data (Chrome UX Report):
  LCP: 2.1s  [Good]
  INP: 145ms [Good]
  CLS: 0.03  [Good]
  FCP: 1.1s  [Good]
  TTFB: 380ms [Good]

Top 75% of observations fall below these values
```

### Lab Data (Lighthouse)

```
Lab Data:
  LCP: 1.9s   [Good]
  CLS: 0.02  [Good]
  TBT: 120ms [Good]
  FCP: 0.9s  [Good]

Performance: 95
```

### When Field and Lab Disagree

| Scenario | Cause | Action |
|----------|-------|--------|
| Lab good, Field bad | Real-world network/device variability | Test on real devices, optimize server |
| Lab bad, Field good | Test environment is slower than average user | Ignore lab, field is ground truth |
| Both bad | Real problem | Fix the metrics |
| Both good | You're doing well | Maintain and monitor |

---

## Real Device Testing

Lab testing is simulation. Real device testing is reality.

### Why Browser DevTools Lie

- Desktop DevTools uses desktop-class CPU
- Throttling is software-based (inaccurate)
- Network throttling is crude (doesn't simulate TCP slow start, TLS handshakes)
- No GPU throttling simulation

### Real Device Options

| Option | Cost | Devices | Best For |
|--------|------|---------|----------|
| BrowserStack | Paid | 3000+ | Full automation + manual |
| Sauce Labs | Paid | 1000+ | CI integration |
| LambdaTest | Paid | 3000+ | CI + manual |
| WebPageTest Real Devices | Free (limited) | 40+ | Lab-quality on real hardware |
| Local physical devices | Free | Your devices | Quick checks |

### Testing on Real Devices

```bash
# WebPageTest real device testing
# Use the "Real Devices" option in the advanced settings
# Select: Moto G4, Pixel 5, iPhone 12, Galaxy S20

# Or via API
curl "https://www.webpagetest.org/runtest.php" \
  -d "url=https://yoursite.com" \
  -d "location=Mobile_US:Ericsson" \
  -d "bwDown=4000" \
  -d "bwUp=1500" \
  -d "latency=40" \
  -d "video=1" \
  -d "f=json"
```

### Mobile Performance Checklist

```plaintext
□ Test on a low-end Android (Moto G4 equivalent or slower)
□ Test on iPhone 12 or older iPhone
□ Test on 3G (1.6 Mbps down, 750 Kbps up, 150ms RTT)
□ Test with 6 tabs open (memory pressure)
□ Test with Dark Mode (some devices throttle in dark mode)
□ Test with Smooth Scroll enabled vs disabled
□ Test touch targets are at least 48x48px
□ Test no hover states on mobile (causes tap delay)
```

---

## Field Data vs Lab Data

| Aspect | Field Data | Lab Data |
|--------|-----------|----------|
| Source | Real users (CrUX) | Synthetic (Lighthouse) |
| Variability | Reflects real conditions | Single snapshot |
| 75th percentile | Top 75% of user experiences | One simulated scenario |
| Device | User's actual devices | Browser DevTools |
| Network | User's actual connection | Throttled simulation |
| Frequency | Updated monthly | Every test |
| **Ground truth?** | **Yes** | No (proxy) |

**Rule:** If you're optimizing for real users, field data is the source of truth. Lab data is useful for debugging and regression detection.

### CrUX API (BigQuery)

```sql
-- Get CrUX data via BigQuery (for detailed analysis)
SELECT
  date,
  form_factor,
  metrics.largest_contentful_paint.p75 AS lcp_p75,
  metrics.cumulative_layout_shift.p75 AS cls_p75,
  metrics.interaction_to_next_paint.p75 AS inp_p75
FROM
  `chrome-ux-report.materialized.device_histogram`
WHERE
  yyyymm = 202501
  AND origin = 'https://yoursite.com'
ORDER BY date
```

---

## Performance Budget Enforcement in CI

### Lighthouse CI Setup

```bash
bun add -d @lhci/cli
```

```yaml
# .lighthouserc.yml
ci:
  collect:
    staticDistDir: ./dist
    url: [
      'http://localhost/'
    ]
    settings:
      preset: desktop
      throttling:
        rttMs: 40
        throughputKbps: 10240
        cpuSlowdownMultiplier: 1
  assert:
    preset: lighthouse:recommended
    assertions:
      # Core Web Vitals
      categories:performance:
        minScore: 0.9
      first-contentful-paint:
        maxNumericValue: 1800
      largest-contentful-paint:
        maxNumericValue: 2500
      cumulative-layout-shift:
        maxNumericValue: 0.1
      total-blocking-time:
        maxNumericValue: 300
      speed-index:
        maxNumericValue: 3400

      # Budgets
      uses-optimized-images:
        mode: warn
      unused-javascript:
        maxNumericValue: 0
      render-blocking-resources:
        maxNumericValue: 0
```

### GitHub Actions Integration

```yaml
# .github/workflows/lighthouse.yml
name: Lighthouse CI

on: [push, pull_request]

jobs:
  lighthouse:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Setup Bun
        uses: oven-sh/setup-bun@v2
        with:
          bun-version: latest

      - name: Install dependencies
        run: bun install --frozen-lockfile

      - name: Build
        run: bun run build

      - name: Run Lighthouse CI
        run: |
          bun add -g @lhci/cli
          lhci autorun
        env:
          LHCI_GITHUB_APP_TOKEN: ${{ secrets.LHCI_GITHUB_APP_TOKEN }}
```

### Bundle Size Budget (Bundlesize)

```json
// .bundlesizerc
{
  "*.js": {
    "maxSize": "120kB"
  },
  "critical.js": {
    "maxSize": "20kB"
  }
}
```

```bash
# package.json
{
  "scripts": {
    "bundlesize": "bundlesize",
    "build": "vite build && bundlesize"
  }
}
```

---

## Core Web Vitals Measurement Tools Comparison

| Tool | Core Web Vitals | Field | Lab | Real Devices | API | CI |
|------|----------------|-------|-----|--------------|-----|-----|
| **Lighthouse** | All (except INP) | No | Yes | No | CLI | Yes |
| **PageSpeed Insights** | All | Yes | Yes | No | REST API | Via CI |
| **WebPageTest** | All | No | Yes | Yes | REST API | Via CI |
| **Chrome DevTools** | All | No | Yes | No | No | No |
| **web-vitals.js** | All | Yes | No | N/A | No | No |
| **CrUX Dashboard** | All | Yes | No | N/A | BigQuery | No |
| **GTmetrix** | Most | No | Yes | No | REST API | Via CI |
| **Calibre** | All | Yes | Yes | Yes | Yes | Yes |
| **SpeedCurve** | All | Yes | Yes | No | Yes | Yes |

### web-vitals.js (Real User Monitoring)

```html
<script type="module">
  import { onCLS, onINP, onLCP, onFCP, onTTFB } from 'https://unpkg.com/web-vitals@4?module';

  function sendToAnalytics({ name, value, id, rating }) {
    // Send to your analytics endpoint
    navigator.sendBeacon('/analytics', JSON.stringify({
      metric: name,
      value: Math.round(name === 'CLS' ? value * 1000 : value),
      rating, // 'good' | 'needs-improvement' | 'poor'
      id
    }));
  }

  onLCP(sendToAnalytics, { reportAllChanges: false });
  onINP(sendToAnalytics, { reportAllChanges: false });
  onCLS(sendToAnalytics, { reportAllChanges: false });
  onFCP(sendToAnalytics, { reportAllChanges: false });
  onTTFB(sendToAnalytics, { reportAllChanges: false });
</script>
```

---

## Performance Regression Detection

### Automated Regression Detection

```yaml
# .github/workflows/perf-regression.yml
name: Performance Regression Check

on:
  pull_request:
    paths:
      - 'src/**'
      - 'package.json'
      - 'vite.config.js'

jobs:
  lighthouse:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Setup Bun
        uses: oven-sh/setup-bun@v2
        with:
          bun-version: latest

      - name: Install
        run: bun install --frozen-lockfile

      - name: Build
        run: bun run build

      - name: Run Lighthouse
        run: bunx lighthouse https://staging.yoursite.com \
          --output=json \
          --output-path=lighthouse-result.json

      - name: Parse and check scores
        run: |
          node -e "
            const results = require('./lighthouse-result.json');
            const perf = results.categories.performance.score * 100;
            const lcp = results.audits['largest-contentful-paint'].numericValue;
            const cls = results.audits['cumulative-layout-shift'].numericValue;

            if (perf < 85) {
              console.error('Performance score ' + perf + ' < 85 — REGRESSION');
              process.exit(1);
            }
            if (lcp > 2500) {
              console.error('LCP ' + lcp + 'ms > 2500ms — REGRESSION');
              process.exit(1);
            }
            if (cls > 0.1) {
              console.error('CLS ' + cls + ' > 0.1 — REGRESSION');
              process.exit(1);
            }
            console.log('All checks passed');
          "
```

### Tracking Performance Over Time

```
Performance Score History (Lighthouse Desktop):
  Jan 1:  ████████████████████ 92 ✓
  Jan 8:  ████████████████████ 94 ✓
  Jan 15: ███████████████████  89 ✗ ← Regression detected!
  Jan 22: ████████████████████ 93 ✓ ← Fixed

Action: PR #142 added a heavy analytics library → 3 point drop
Fix: Lazy load the analytics SDK → Score recovered
```

### Regression Detection Strategies

1. **Lighthouse CI on every PR** — Block merges below threshold
2. **Bundle size tracking** — Alert on >10% increase
3. **CrUX monitoring** — Alert when field metrics worsen
4. **Synthetic monitoring** — Periodic tests from multiple locations
5. **RUM alerting** — Real-time alerts when p75 exceeds thresholds

---

## Testing Checklist

```plaintext
□ Lighthouse Performance 90+ on mobile and desktop
□ Core Web Vitals green in PageSpeed Insights field data
□ WebPageTest waterfall: no render-blocking on critical path
□ WebPageTest filmstrip: no blank screens, no CLS jumps
□ Real device testing on low-end Android
□ Real device testing on older iPhone (iPhone 11 or older)
□ Bundle size within tier budget (run bundlesize)
□ No new render-blocking resources in PR
□ Performance budget enforced in CI (.lighthouserc.yml)
□ web-vitals.js RUM running in production
□ Performance regression detected and alerted
□ CrUX data reviewed monthly
□ TTFB < 800ms (server-side check)
□ Accessibility audit alongside performance audit
```
