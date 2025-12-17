.PHONY: test lint docker-build

test:
	@if [ -f "package.json" ]; then npm test; elif [ -f "pyproject.toml" ] || [ -f "requirements.txt" ]; then pytest; else echo "No test command found"; exit 0; fi

lint:
	@if command -v eslint >/dev/null 2>&1 && [ -f "package.json" ]; then eslint . || true; elif command -v flake8 >/dev/null 2>&1; then flake8 || true; else echo "No linter detected"; fi

docker-build:
	docker build -t ${IMAGE_NAME:-project:latest} .
