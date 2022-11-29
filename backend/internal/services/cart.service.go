package service

import (
	"cash/backend/internal/models"
	"context"

	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/bson/primitive"
	"go.mongodb.org/mongo-driver/mongo"
)

func NewCartService() *Service {
	return NewService("carts_data")
}

func (c Service) CreateCart(obj models.Cart) (*mongo.InsertOneResult, error) {
	if obj.ID == primitive.NilObjectID {
		obj.ID = primitive.NewObjectID()
	}
	res, err := c.collection.InsertOne(context.TODO(), obj)
	return res, err
}

func (c Service) DeleteCart(id primitive.ObjectID) (interface{}, error) {
	res, err := c.collection.DeleteOne(context.TODO(), bson.M{"_id": id})
	return res.DeletedCount, err
}

func (c Service) GetCart(id primitive.ObjectID) (models.Cart, error) {
	var result models.Cart

	cursor := c.collection.FindOne(context.TODO(), bson.M{"_id": id})
	err := cursor.Decode(&result)
	if err != nil {
		return models.Cart{ID: primitive.ObjectID{0}, Total: 0}, err
	}
	return result, nil
}

func (c Service) ClearCart(obj models.Cart) {
	obj.Articles = []models.Article{}
	obj.Total = 0
	c.collection.InsertOne(context.TODO(), obj)
}
