#!/usr/bin/env bash
set -e

echo "🔍 Registering all Jupyter kernels from /posts..."

# Check if posts directory exists
if [ ! -d "posts" ]; then
    echo "⚠️  No 'posts' directory found. Skipping kernel registration."
    exit 0
fi

# Find all directories with .venv in the posts subdirectory
find posts -type d -name ".venv" | while read venv_path; do
    dir=$(dirname "$venv_path")
    echo "📦 Processing: $dir"
    
    cd "$dir"
    KERNEL_NAME=$(basename "$PWD")
    PYTHON=".venv/bin/python"
    
    if [ -f "$PYTHON" ]; then
        "$PYTHON" -m ipykernel install --user \
            --name "$KERNEL_NAME" \
            --display-name "Python (.venv: $KERNEL_NAME)" 2>/dev/null || true
        echo "✅ Registered: $KERNEL_NAME"
    fi
    
    cd - > /dev/null
done

echo "✅ All kernels from /posts registered!"