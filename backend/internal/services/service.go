package service

import (
	"cash/backend/internal/database"

	"go.mongodb.org/mongo-driver/mongo"
)

type Service struct {
	database   *mongo.Database
	collection *mongo.Collection
}

func NewService(collectionName string) *Service {
	s := &Service{}
	s.database = database.GetDatabaseConnection()
	s.collection = s.database.Collection(collectionName)
	return s
}
