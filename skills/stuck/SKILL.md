---
name: stuck
description: Help get unstuck on tasks by breaking them down, identifying blockers, or prepping for phone calls. Use when user says "I'm stuck on", "help me with", "I don't know how to", "I keep avoiding", or seems hesitant about a task.
---

# STUCK Skill

## Purpose
Help the user get unstuck on a task by breaking it down, identifying the blocker, or prepping them for action (especially phone calls).

## When to Use
- User says "I'm stuck on...", "help me with...", "I don't know how to...", "I keep avoiding..."
- User mentions a task and seems hesitant
- User has had something in To Do or In Progress for a long time

## Workflow

### 1. Identify the Task
If not clear, ask which task they mean. Check Trello for context.

### 2. Diagnose the Block
Common blockers:
- **Don't know the first step** → Break it down
- **Missing information** → Help find it (phone number, reference, etc.)
- **Requires a phone call** → Help prep a script
- **Waiting on someone** → Should it move to Waiting On? Do they need to chase?
- **Too big/vague** → Split into smaller cards
- **Don't want to do it** → Is it actually necessary? Can someone else do it?

Ask: "What's the bit that's stopping you?"

### 3. Help Based on the Block

#### If it's unclear what to do:
- Ask clarifying questions
- Break into steps
- Offer to create subtasks as a checklist on the card

#### If it needs a phone call:
Help them prep:
```
**Who to call:** [Company/Person]
**Number:** [Help find it if needed]
**Reference numbers:** [Account, policy, etc.]

**What you need from the call:**
- [Specific outcome]

**Opening line:**
"Hi, I'm calling about [X]. My [account/reference] number is [Y]."

**If they ask [likely question]:**
[Suggested response]
```

#### If it's too big:
Suggest splitting: "This sounds like 3 separate things—want me to create cards for: 1) X, 2) Y, 3) Z?"

#### If they're waiting:
- Move to Waiting On column
- Add a note about what they're waiting for
- Suggest a follow-up date

### 4. Update Trello
After helping:
- Move card to appropriate column
- Add any useful info to the card description or as a comment
- Create subtasks if the user agreed to break it down

## Example Interaction

**User:** I keep avoiding the research task

**Claude:** I see that one—"Find service providers, rank them by fit, and start calling them." That's actually like 3 tasks in one, which might be why it's been sitting there.

What if we split it up:
1. Find nearby providers and make a shortlist (10 mins)
2. Check reviews and availability for the shortlist (15 mins)
3. Call top 3 to ask about availability (separate task, maybe batch with other calls)

Want me to break that card into these three? The first one you could probably knock out right now.

**User:** yeah do that

**Claude:** Done—I've created three cards:
- "Research providers nearby - make shortlist" → To Do
- "Check reviews/availability for shortlist" → To Do
- "Call top 3 providers about availability" → To Do, labeled 📞 Calls

I've archived the original big one. The research one is pretty quick if you want to knock it out now?

## Tone
- Practical, not patronizing
- Acknowledge that some tasks just suck (especially phone calls)
- Focus on making the next step as small and obvious as possible

## Don't
- Don't lecture about why they should do things
- Don't create lots of new cards without permission
- Don't assume they have info they might not have (ask first)
