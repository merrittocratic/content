# LinkedIn Series 3/5: Earnest

Status: draft, ready to paste
Source: draft/Earnest_Comes_ToLife.md ("Earnest Goes to the Draft")

---

The newest member of my sports analytics operation runs on a Mac Mini in the corner of my home office, and he has exactly one hard rule: he proposes, he never publishes.

Earnest is the automation agent built on OpenClaw we introduced in post 1. He watches for new Merrittocracy articles, drafts X threads in house voice, and routes every draft through Telegram for an explicit yes before anything goes live. The relationship is editor and writer, not owner and tool.

He also has a soul. That's not me being sentimental; it's a design feature. OpenClaw's onboarding distills your instructions into a personality file literally named SOUL.md, and it's why Earnest responds like a colleague with opinions instead of a cron job with a chat window.

The proof came on NFL draft night. A pick hits the ticker, I type pick("Caleb Downs") in R, and the chain fires: the model re-scores with the actual drafting team, the SHAP waterfall regenerates to judge the pick quality, Earnest drafts the thread and requests approval. Pick-to-approval request in under three minutes, reliably before the next commercial break.

The build had several lessons of its own. How do I store secrets so Earnest can access them, and also not share them with the world?  A clean 1Password CLI secrets design lasted about 24 hours, because background services can't do interactive auth (macOS Keychain on the Mac Mini solved it). X's error code 32 cost two hours of debugging signing code when the real fix was regenerating tokens minted before the app had write permissions. And when the Telegram cron gateway broke, Earnest rerouted notifications through his own heartbeat cycle without being asked.

Earnest handles the automation and assists with content generation, but never publication.  The part I care most about: every article/post starts as an AI draft, gets committed to git, and the diff between that draft and what I actually publish lives in the commit history. Anyone asking "is this just AI?" can go read the receipts.

x.com/Merrittocratic
https://themerrittocracy.substack.com/p/earnest-goes-to-the-draft
https://github.com/merrittocratic