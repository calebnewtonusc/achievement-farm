# GitHub Achievement Farm

Automated scripts to earn every farmable GitHub profile achievement. Clone, run, walk away.

Built by [@calebnewtonusc](https://github.com/calebnewtonusc).

---

## Achievements You'll Earn

| Achievement | Tiers | What Triggers It |
|---|---|---|
| **Quickdraw** | Default | Close an issue or PR within 5 min of opening it |
| **YOLO** | Default | Merge a PR without a code review |
| **Pull Shark** | Default → Bronze → Silver → **Gold** | 2 / 16 / 128 / 1,024 merged PRs |
| **Pair Extraordinaire** | Default → Bronze → Silver → **Gold** | 1 / 10 / 24 / 48 co-authored merged PRs |
| **Galaxy Brain** | Default → Bronze → Silver → **Gold** | 2 / 8 / 16 / 32 accepted discussion answers |

All scripts target the **Gold tier** — you'll pick up every tier below it automatically along the way.

---

## Prerequisites

- [GitHub CLI](https://cli.github.com/) installed and authenticated
- Git installed and configured

```bash
# Install gh (macOS)
brew install gh

# Authenticate
gh auth login

# Configure git if you haven't
git config --global user.name "Your Name"
git config --global user.email "you@example.com"
```

---

## Setup

### 1. Create a fresh public repo to farm in

```bash
gh repo create YOUR_USERNAME/achievement-farm --public --clone
cd achievement-farm
echo "# Achievement Farm" > README.md
git add README.md && git commit -m "init" && git push origin main
```

### 2. Clone this repo's scripts

```bash
git clone https://github.com/calebnewtonusc/achievement-farm.git ach-scripts
```

---

## Running the Scripts

Run each script from inside your achievement-farm repo directory.

### Quickdraw + YOLO — takes ~30 seconds

```bash
bash /path/to/ach-scripts/scripts/quickdraw_yolo.sh YOUR_USERNAME achievement-farm
```

What it does:
- Opens an issue and immediately closes it (Quickdraw)
- Creates a branch, opens a PR, and merges it without requesting review (YOLO)

---

### Pull Shark Gold — takes ~1 hour

```bash
bash /path/to/ach-scripts/scripts/pull_shark.sh YOUR_USERNAME achievement-farm
```

What it does:
- Creates 1,024 branches, one at a time
- Opens a PR for each and merges it
- Unlocks Default (2), Bronze (16), Silver (128), and Gold (1,024) automatically

> Run this in a terminal you can leave open. It takes about an hour at ~15 PRs/min.

---

### Pair Extraordinaire Gold — takes ~10 min

```bash
bash /path/to/ach-scripts/scripts/pair_extraordinaire.sh YOUR_USERNAME achievement-farm
```

What it does:
- Creates 50 branches with commits that include a `Co-authored-by:` trailer
- Opens and merges each PR
- GitHub counts co-authored commits in merged PRs toward this achievement

---

### Galaxy Brain Gold — takes ~5 min

```bash
bash /path/to/ach-scripts/scripts/galaxy_brain.sh YOUR_USERNAME achievement-farm
```

What it does:
- Enables Discussions on your repo
- Creates 32 Q&A discussions, posts an answer to each, and marks it as accepted
- Rate-limited by GitHub so it sleeps between requests automatically

> Note: GitHub hasn't officially confirmed whether self-answered discussions count. If Galaxy Brain doesn't appear after 24 hours, ask a friend to answer a few of your discussions and mark theirs as accepted — that's the guaranteed path.

---

## How Long Does It Take?

| Script | Runtime |
|---|---|
| quickdraw_yolo.sh | ~30 seconds |
| pull_shark.sh | ~60 minutes |
| pair_extraordinaire.sh | ~10 minutes |
| galaxy_brain.sh | ~5 minutes |

**Total: ~75 minutes** (mostly just waiting on Pull Shark)

---

## When Do Achievements Appear?

GitHub processes achievements asynchronously — they don't appear the instant you hit the threshold. Typical wait times:

- Simple badges (Quickdraw, YOLO): **minutes to 1 hour**
- Tiered badges (Pull Shark, Pair Extraordinaire, Galaxy Brain): **a few hours, up to 24 hours**
- Gold tiers especially may wait for GitHub's nightly batch job

Check your profile at `github.com/YOUR_USERNAME` the next morning — everything should be there.

---

## What's NOT Farmable

Some achievements genuinely require real human interaction:

| Achievement | Why You Can't Script It |
|---|---|
| **Starstruck** | Needs 16 real people to star one of your repos. Share your best project on socials. |
| **Public Sponsor** | Requires actually paying to sponsor someone on GitHub Sponsors ($1/mo minimum). |
| **Heart On Your Sleeve** | GitHub has never documented the trigger. Reacting with ❤️ is the community's best guess but unconfirmed. |
| **Open Sourcerer** | Also undocumented. Likely requires PRs merged into repos you genuinely don't own. |
| **Arctic Code Vault** | Retired. No longer earnable. |
| **Mars 2020 Contributor** | Retired. No longer earnable. |

---

## Troubleshooting

**Script fails with "Bad credentials"**
```bash
gh auth login
# then re-run the script
```

**PRs failing to merge with "CONFLICTING"**

This happens when branches stack on each other. Kill the script, run:
```bash
git checkout main && git fetch origin && git reset --hard origin/main
```
Then re-run from where it left off by changing the `seq 1 $TARGET` start number.

**Galaxy Brain rate limit errors**

The script already sleeps between requests. If it still gets rate limited, increase the `sleep 3` and `sleep 2` values in the script.

**Achievements not showing after 24 hours**

Double-check the action actually happened:
```bash
# Count merged PRs
gh pr list --repo YOUR_USERNAME/achievement-farm --state merged --limit 1100 --json number | jq 'length'

# Count accepted discussions
gh api graphql -f query='{ repository(owner: "YOUR_USERNAME", name: "achievement-farm") { discussions(first: 100) { nodes { answerChosenAt } } } }' \
  --jq '[.data.repository.discussions.nodes[] | select(.answerChosenAt != null)] | length'
```

---

## License

MIT — do whatever you want with it.
