package service

import (
	"cash/backend/internal/database"

	"go.mongodb.org/mongo-driver/mongo"
)

type Service struct {
	client     *mongo.Client
	collection *mongo.Collection
}

func NewService(dbName string, collectionName string) *Service {
	s := &Service{}
	s.client = database.GetDatabaseConnection()
	s.collection = s.client.Database(dbName).Collection(collectionName)
	return s
}
