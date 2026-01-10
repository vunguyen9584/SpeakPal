#!/bin/bash

# SpeakPal Mobile - Development Environment Setup Script
# Run this once after cloning the repo or when dependencies change.

set -e

echo "🚀 Setting up SpeakPal Mobile development environment..."

# Check prerequisites
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter is not installed. Please install Flutter first."
    exit 1
fi

# Move to mobile directory
cd "$(dirname "$0")/../mobile"

echo "📦 Fetching dependencies..."
flutter pub get

echo "⚙️ Generating code (build_runner)..."
flutter pub run build_runner build --delete-conflicting-outputs

echo "🔍 Running initial analysis..."
flutter analyze

echo "🧪 Running tests..."
flutter test

echo "✅ Setup complete! You are ready to develop."
