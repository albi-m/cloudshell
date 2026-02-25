#!/bin/bash
# Start CloudShell Agent Dashboard with local server
# This allows the dashboard to read progress.json updates from agents
cd /Users/albinmathew/Project/Termius-Alternative/agents
echo "🚀 Dashboard running at: http://localhost:8742"
echo "   Press Ctrl+C to stop"
echo ""
open http://localhost:8742/dashboard.html
python3 -m http.server 8742