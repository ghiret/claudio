---
name: review
description: Surface forgotten, stale, or neglected tasks. Use when user says "review", "what have I forgotten", "weekly review", "clean up the board", or when the board seems cluttered.
---

# REVIEW Skill

## Purpose
Surface forgotten, stale, or neglected tasks. Help the user clean up the board and decide what's still relevant. Archive completed items to keep context lean.

## When to Use
- User says "review", "what have I forgotten", "weekly review", "clean up the board"
- It's been a while since the user engaged with certain tasks
- Board is getting cluttered

## Auto-Remind Triggers
**Proactively suggest running /review when:**
1. **More than 5 cards in Done** - Check during `/today` and nudge if true
2. **7+ days since last review** - Check `last_review` in history files

When triggered, say something like:
> "By the way, there are [X] items in Done and it's been a while since a review. Want to run `/review` to archive old stuff and check for anything gone cold?"

## Workflow

### 1. Scan for Stale Items
Check all cards and flag:

**🔴 Overdue**
- Cards with due dates in the past

**🟠 Gone Cold (Waiting On)**
- Cards that have been in Waiting On for 7+ days
- Ask: "Should you chase this? Or is it resolved?"

**🟡 Sitting Too Long (To Do)**
- Cards that have been in To Do for 14+ days without moving
- Ask: "Is this still relevant? What's stopping it?"

**🟣 Stuck in Progress**
- Cards in "In Progress" for a long time
- Ask: "Is this actually in progress, or did it get paused?"

**👻 Ghost Cards**
- Cards with no description and vague titles
- Ask: "What was this about? Should we flesh it out or delete it?"

### 2. Present Findings
Don't dump everything at once. Prioritize:

```
## Board Review

**Overdue (needs immediate attention):**
- [Card] was due [date]

**Gone quiet (might need chasing):**
- [Card] has been waiting for 2 weeks

**Been sitting a while:**
- [Card] has been in To Do for 3 weeks—still relevant?

**Quick wins (could knock out fast):**
- [Card] looks small, want to just do it?
```

### 3. Go Through Each Item
For each flagged item, ask what to do:
- **Keep it** → Leave as is, maybe add a note
- **Chase it** → Remind user to follow up, offer to draft message
- **Do it now** → Move to In Progress
- **It's done** → Move to Done
- **Kill it** → Archive the card
- **Delegate** → Is this actually someone else's task?

### 4. Update Trello
Make changes as the user decides:
- Move cards to appropriate columns
- Archive abandoned tasks
- Add "chased on [date]" comments to waiting items
- Update due dates if needed

### 5. Archive Done Items
At the end of every review, clean up the Done list:

1. **Fetch Done list** and show items
2. **Ask which to archive** - usually everything that's been there since last review
3. **Archive via MCP** - use `archive_card` for each confirmed item
4. **Confirm** - "Archived X items. Done list is clear."

Example:
```
**Done list has 6 items:**
- ✅ Install a shelf (done Jan 11)
- ✅ Call utility provider (done Jan 11)
- ✅ Fix a broken handle (done Jan 11)
- ✅ Send vendor email (done Jan 11)
- ✅ Book an appointment (done Jan 10)
- ✅ Order a replacement item (done Jan 8)

Archive all of these?
```

User confirms → archive all → "Done! Archived 6 items."

## Red Flags to Always Mention
- Anything with a past due date
- Anything labeled "Time-sensitive" that's not moving
- Cards in Waiting On with no indication of what/who you're waiting for
- Cards in Blocked with no description of the blocker

## Example Interaction

**User:** what have I forgotten about?

**Claude:** Let me check...

**Needs attention:**
- 🔴 **The vendor** has been in Waiting On for 12 days. You set an end-of-month deadline—want to chase them this week?
- 🟡 **Research a service** has been in To Do for 3 weeks. Still need to do this?

**Might be done?**
- **Book pickup for old item** says "waiting to get replacement"—did it arrive?

What do you want to do with these?

**User:** vendor I'll chase Monday, research yes I need to do it, replacement isn't here yet

**Claude:** Got it. I've added a note to the vendor card: "Chase Monday 13th Jan".

For the research task—want to break that down so it's easier to start? Or keep it as is?

## Tone
- Not judgmental about how long things have sat
- Practical: "what do you want to do with this?"
- Acknowledge that some things genuinely take time

## Don't
- Don't make the user feel bad about forgotten tasks
- Don't archive anything without explicit permission
- Don't assume—ask before changing status

## Tracking Reviews
After completing a review, record it in that day's history file:

```markdown
## Last Review
- **Date**: 2026-01-12
- **Archived**: 6 items from Done
- **Chased**: The vendor, research task
```

This lets `/today` check if a review is overdue.
