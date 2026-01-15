---
name: add-task
description: Add well-formed, actionable tasks to Trello. Use when user says "add task", "remind me to", "I need to", or "put on the board".
---

# ADD-TASK Skill

## Purpose
Help the user add well-formed, actionable tasks to Trello—not vague blobs that will sit there forever.

## When to Use
- User says "add task", "remind me to", "I need to", "put on the board"
- User mentions something that should be tracked

## Workflow

### 1. Capture the Intent
User says something like "add task: deal with the appliance"

### 2. Clarify if Vague
If the task is unclear, ask ONE question to make it actionable:
- "What specifically needs doing with the appliance?"
- "Is this a call you need to make, or something else?"
- "Do you know who to contact, or is finding that the first step?"

Don't over-question—one clarification max, then create the card.

### 3. Create the Card

**Title:** Should be actionable. Start with a verb when possible.
- ❌ "Appliance"
- ✅ "Call the service provider about appliance repair"
- ✅ "Research local repair companies"

**Description:** Add any context the user mentioned. Keep it brief.

**List:** Default to "To Do" unless:
- User says "I'm working on this now" → In Progress
- User says "I'm waiting to hear back" → Waiting On
- There's an obvious blocker → Blocked

**Labels:** Apply if obvious:
- Phone call mentioned → 📞 Calls
- About the house → 🏠 Household
- Family-related → 👶 Childcare
- Bills/paperwork → 📋 Admin
- Has a deadline → ⏰ Time-sensitive

**Due date:** Only add if user mentions a specific date/deadline.

### 4. Confirm
Tell the user what you created:
"Added 'Call the service provider about a repair' to To Do, tagged as Calls. Anything to add to it?"

## Good vs Bad Cards

### ❌ Bad (vague, will rot)
- "Insurance"
- "Sort out the thing"
- "Scheduling"
- "Payment"

### ✅ Good (clear next action)
- "Call an insurer to update details"
- "Book pickup for an old item"
- "Email a vendor to confirm a start date"
- "Pay an outstanding bill for this month"

### ✅ Also fine (when first step is research)
- "Research options for a new service provider"
- "Find out how to cancel a membership"

## When Tasks Are Too Big
If user says something like "sort out all our policies", gently suggest:
"That sounds like a few separate things—want me to add them individually? Like:
- Review current coverage
- Get a renewal quote
- [etc.]"

Only split if user agrees.

## Example Interaction

**User:** add task: training sessions

**Claude:** Sure—what's the actual thing you need to do about the training sessions? Call them, research options, something else?

**User:** we're on a waiting list and I need to chase them

**Claude:** Got it. I've added "Chase provider about waiting list status" to Waiting On, tagged as Calls.

Want me to add any details like their phone number to the card?

## Don't
- Don't add vague cards without at least trying to clarify
- Don't create multiple cards without asking
- Don't add unnecessary labels or due dates
- Don't over-engineer—simple is fine
