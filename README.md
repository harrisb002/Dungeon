# 2D Dungeon Game

This project is a one-player 2D dungeon-crawling game built in Godot. Players explore a sketchy dungeon, defeat enemies, and confront powerful bosses.

## Table of Contents
1. [Overview](#overview)
2. [Features](#features)
   - [Player](#player)
   - [Dungeon Map](#dungeon-map)
   - [Enemies & Bosses](#enemies--bosses)
   - [Storyboarding](#storyboarding)
   - [General Game Logic](#general-game-logic)
3. [Progress](#progress)

## Overview
This game offers players a dungeon to explore, where they can encounter various challenges such as traps, enemies, and boss fights. Players must navigate through the dungeon, collect power-ups, and progress the story by defeating bosses.

## Features

### Player
- **Player Movement**: The player can move in all directions, bound within the map’s edges.
  - [✅] Implement player movement
  - [✅] Set player boundaries within the map
  - [✅] Allow the player to fall through trap holes
  
- **Player Stats**: Tracks player's health, stamina, and experience points.
  - [ ] Design and display the player stats UI
  - [ ] Integrate health, stamina, and experience mechanics

- **Player Attack**: Allows the player to engage enemies with a basic attack.
  - [✅] Develop basic attack animations
  - [ ] Add damage mechanics for player attacks

### Dungeon Map
- **Map Design**: The layout and design of the dungeon map.
  - [✅] Create initial dungeon map layout
  - [✅] Implement various rooms and corridors
  - [⚙️] Add interactive objects (e.g., chests, doors, keys)

- **Trap Elements**: Include traps such as holes that cause the player to fall.
  - [✅] Design trap holes and other obstacles
  - [✅] Integrate player interaction with traps
  
### Enemies & Bosses
- **Basic Enemies**: Skeletons and other non-boss enemies, including AI for movement and attacks.
  - [ ] Create skeleton enemy models and animations
  - [ ] Implement basic enemy AI for patrolling and attacking
  - [ ] Integrate damage and defeat mechanics for enemies
  
- **Bosses**: More challenging enemies with complex AI and special abilities.
  - [ ] Design boss models and animations
  - [ ] Implement boss-specific AI and attack patterns
  - [ ] Develop boss health bars and battle triggers
  
### Storyboarding
- **Plot Events**: Display text plots during important moments.
  - [ ] Add plot text at the game start
  - [ ] Trigger plot updates when passing through special doorways
  - [ ] Show boss defeat text and game progression updates
  
### General Game Logic
- **Game Initialization & Menus**: Manage the start of the game and menu interactions.
  - [ ] Develop start menu and load game options
  - [ ] Implement pause menu and game-over screens
  
- **Health & Power-ups**: Items that aid the player on their journey.
  - [ ] Design health and stamina power-ups
  - [ ] Integrate power-ups into the game with item collection mechanics
---
