export DB_NAME=test_db
export ARTICLE_PATH=../../articles.json
GIN_MODE=release go test -v -coverprofile=cover.out ./...
go tool cover -html=cover.out