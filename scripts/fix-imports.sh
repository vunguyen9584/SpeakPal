#!/bin/bash

# SpeakPal Mobile - Import Fixer Script V6
# Correctly uses xargs -r for safety when grep finds nothing

cd mobile

echo "🔧 Converting remaining relative imports to package imports..."

# 1. Broad feature-to-feature fixes
grep -rl "import '../../profile/" lib/ | xargs -r sed -i "s|import '../../profile/|import 'package:mobile/features/profile/|g"
grep -rl "import '../../../core/" lib/ | xargs -r sed -i "s|import '../../../core/|import 'package:mobile/core/|g"
grep -rl "import '../../core/" lib/ | xargs -r sed -i "s|import '../../core/|import 'package:mobile/core/|g"

# 2. Fix specific files
if [ -f lib/features/profile/presentation/providers/profile_provider.dart ]; then
    sed -i "s|import '../../profile/data/profile_repository.dart'|import 'package:mobile/features/profile/data/profile_repository.dart'|g" lib/features/profile/presentation/providers/profile_provider.dart
    sed -i "s|import '../../profile/domain/models/user_stats.dart'|import 'package:mobile/features/profile/domain/models/user_stats.dart'|g" lib/features/profile/presentation/providers/profile_provider.dart
fi

# 3. Cleanup redundant "package:mobile/features/features/"
grep -rl "package:mobile/features/features/" lib/ | xargs -r sed -i 's|package:mobile/features/features/|package:mobile/features/|g'

echo "✅ Import fixing V6 complete."
