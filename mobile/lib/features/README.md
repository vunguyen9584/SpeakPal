# Features

This directory contains feature modules following a feature-first architecture.

Each feature module is self-contained with its own:
- **UI** - Screens and widgets
- **State** - Riverpod providers
- **Models** - Data models
- **Services** - Feature-specific services

## Current Features

- **auth/** - Authentication (login, register, password reset)
- **home/** - Home screen and dashboard
- **conversation/** - AI conversation interface

## Adding a New Feature

1. Create a new directory under `features/`
2. Organize with subdirectories:
   - `screens/` - UI screens
   - `widgets/` - Feature-specific widgets
   - `providers/` - Riverpod state providers
   - `models/` - Data models
   - `services/` - Feature services
