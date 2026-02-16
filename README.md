# aLtCaPs Keyboard — Documentation

## Overview
**aLtCaPs Keyboard** is a custom iOS keyboard extension that automatically converts typed words into alternating capitalization (e.g., `aLtCaPs`) in real time. The first letter of each word is preserved exactly as typed, while the remaining characters alternate between uppercase and lowercase.

This keyboard is designed to mirror the native Apple keyboard layout while adding a single toggleable AltCaps transformation feature.

---

# Features

## Core Functionality
- Real-time alternating capitalization (aLtCaPs)
- First letter preserved as typed
- Per-word transformation
- Instant ON/OFF toggle
- Lightweight and fast input processing

## Keyboard Experience
- Familiar QWERTY layout
- Native-style spacing and key sizing
- Globe key for keyboard switching
- Space and delete support
- Dark mode compatibility

---

# How It Works

## Typing Flow
1. User taps a key
2. Character is inserted into the text field
3. If AltCaps is enabled:
   - The keyboard detects the current word
   - The word is transformed into alternating caps
   - The original word is replaced in-place

**Example:**
- User types: `hello`
- Output becomes: `hElLo`

---

# AltCaps Logic

## Transformation Rules
| Rule | Behavior |
|------|----------|
| First character | Preserved exactly as typed |
| Second character onward | Alternates uppercase/lowercase |
| Word boundaries | Spaces and newlines reset the pattern |
| Toggle OFF | No transformation applied |

## Example Transformations
| Input | Output |
|-------|--------|
| hello | hElLo |
| world | wOrLd |
| iPhone | iPhOnE |
| A | A (unchanged) |

---

# Technical Architecture

## App Structure
- Main App (container app)
- Keyboard Extension (`KeyboardViewController`)
- Shared settings (optional future enhancement)

### Primary Class
`KeyboardViewController: UIInputViewController`

Responsible for:
- Rendering keyboard UI
- Handling key taps
- Managing AltCaps state
- Transforming text input

---

# Code Behavior Breakdown

## 1. Keyboard Layout
The keyboard uses stacked `UIStackView` rows to replicate the Apple keyboard structure:
- Row 1: Q–P  
- Row 2: A–L  
- Row 3: Z–M  
- Bottom Row: Toggle, Globe, Space, Delete  

---

## 2. Key Input Handling
```swift
@objc private func keyTapped(_ sender: UIButton)

-
## License (Suggested)

Copyright © 2026 aLtCaPs Keyboard
All rights reserved.
