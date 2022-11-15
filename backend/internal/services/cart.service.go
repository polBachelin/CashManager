package service

import (
	"cash/backend/internal/models"
	"context"

	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/bson/primitive"
	"go.mongodb.org/mongo-driver/mongo"
)

func NewCartService() *Service {
	return NewService("carts", "carts_data")
}

func (c Service) CreateCart(obj models.Cart) (*mongo.InsertOneResult, error) {
	if obj.ID == primitive.NilObjectID {
		obj.ID = primitive.NewObjectID()
	}
	res, err := c.collection.InsertOne(context.TODO(), obj)
	return res, err
}

func (u Service) DeleteCart(id primitive.ObjectID) (interface{}, error) {
	res, err := u.collection.DeleteOne(context.TODO(), bson.M{"_id": id})
	return res.DeletedCount, err
}

func (u Service) GetCart(id primitive.ObjectID) (models.Cart, error) {
	var result models.Cart

	cursor := u.collection.FindOne(context.TODO(), bson.M{"_id": id})
	err := cursor.Decode(&result)
	if err != nil {
		return models.Cart{ID: primitive.ObjectID{0}, Total: 0}, err
	}
	return result, nil
}
