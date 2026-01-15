---
name: today
description: Daily check-in to decide what to focus on. Use when user says "today", "what should I do", "what's on my plate", "morning review", or at the start of a conversation.
---

# TODAY Skill

## Purpose
Help the user decide what to focus on today, surface forgotten items, and update Trello based on the conversation.

## When to Use
- User says "today", "what should I do", "what's on my plate", "morning review", "daily standup"
- Start of a new conversation in this project

## Workflow

### 0. Get Today's Actual Date
**ALWAYS** start by checking the real date from the system:
```bash
date "+%A, %B %d, %Y"
```

Use this date for everything - don't assume or guess. This prevents creating history files for the wrong day.

### 1. Check/Create Today's History File
History files live at the **project root**: `history/YYYY-MM-DD.md`

This creates a readable history you can browse to analyze patterns, procrastination, and progress over time without needing git archaeology.

### 2. Check if Already Updated Today
Read `history/YYYY-MM-DD.md` if it exists to see:
- What was their focus earlier today
- What's in "Done Today" already
- Any carry-over items

### 3. Gather Current State from Trello
Use the Trello MCP to:
- Get all cards from the board
- Note which list each card is in
- Check for due dates

### 4. Update Today's History File
Write/update `history/YYYY-MM-DD.md` with current date and fresh board snapshot using the format shown in "File Format" section below.

If updating an existing file from earlier today, preserve the "Done Today" section and add new items.

### 5. Present Summary in Chat AND Point to File
Give the user a conversational summary with the most important items, then point them to the file:

```
Good morning! Let me check your board...

You've got 4 things in To Do, 1 in progress, and 2 waiting on replies.

**Needs attention:**
- 🔴 **Upcoming appointment** is on the 15th—that's in 4 days. Is it booked or do you need to call?
- **The vendor** has been in Waiting On since Jan 3rd. Still waiting, or should you chase them?

**In Progress:**
- Book pickup for an item—how's that going?

✅ I've updated `history/2026-01-15.md` with the full breakdown.

What feels doable today?
```

### 6. Surface Forgotten Items
Flag anything that might have gone stale:
- Cards in "Waiting On" for more than a week → "Should you chase this up?"
- Cards in "To Do" for more than 2 weeks → "Is this still relevant?"
- Cards with past due dates → "This was due [date], what's the status?"

### 7. Interactive Updates
As the user works through TODAY.md and tells you about progress:
- "Actually that's done" → Move card to Done in Trello, update "✅ Done Today" section in today's history file
- "I'm waiting on X for that" → Move to Waiting On, add comment, update file
- "That's not happening anymore" → Archive the card, remove from file
- "I'll do that today" → Move to In Progress, keep in Focus section

Make these changes in both Trello AND the current day's history file (history/YYYY-MM-DD.md).

### 8. Check Review Triggers
At the end of `/today`, check if a `/review` is needed:

1. **Count Done items** - If more than 5 cards in Done list, suggest review
2. **Check last review date** - Look for "## Last Review" in recent history files. If none found or >7 days ago, suggest review

If either trigger fires, add a gentle nudge:
> "By the way, there are [X] items sitting in Done. Want to run `/review` to archive them and check for anything gone cold?"

Don't be pushy—one mention is enough.

## Tone
- Keep chat conversational and focused on 2-3 most important items
- Don't repeat everything in chat—the file has the full details
- Point user to today's history file (history/YYYY-MM-DD.md) for complete breakdown
- Be gently persistent about forgotten items in both chat and file
- The history/ directory builds a browsable record for pattern analysis

## File Format
Keep each daily file in the project root `history/YYYY-MM-DD.md` structured like this:

```markdown
# Today - [Day, Date]

## 🎯 Focus Today
- [ ] **[Task]** - [helpful context/next action]

## ⏳ Waiting On
| Item | Waiting since | Action if no reply |

## 📞 Calls to Make
- [ ] [Batched call tasks]

## 🔜 Coming Up
- [Date]: [Item]

## ✅ Done Today
<!-- Items moved here as completed -->

---
*Updated: [timestamp]*
```

## Example Interaction

**User:** today

**Claude:** 
Let me commit the current state and check your board...

Good morning! You've got 4 things in To Do, 1 in progress, and 2 waiting on replies.

**Needs attention:**
- 🔴 **Upcoming appointment** is in 4 days (Jan 15)—is it booked or just on the list?
- **The vendor** has been in Waiting On for 2 weeks. Should you chase them?

**In Progress:**
- Book pickup for an item—how's that going?

✅ I've updated history/2026-01-11.md with the full breakdown.

What feels doable today?

**User:** The appointment is booked, I can mark that done.

**Claude:**
Done! Moved "Upcoming appointment" to Done in Trello and updated history/2026-01-11.md.

Should I add a reminder to chase the vendor tomorrow?

## Don't
- Don't dump the entire board contents into chat—that's what the history file is for
- Don't be preachy about productivity
- Don't create new cards without asking
- Don't assume—if something's ambiguous, ask
- Don't overwrite previous days' files—each day gets its own file in history/

## Analysis Benefits
With dated history files, you can:
- Compare multiple days side-by-side to spot patterns
- See which tasks keep appearing (chronic procrastination)
- Track how long items sit in Waiting On
- Identify productive days vs. stuck days
- Search across all history files for specific tasks or topics
