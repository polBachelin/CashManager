package service

import (
	"cash/backend/internal/models"
	"context"

	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/bson/primitive"
)

func NewUserService() *Service {
	return NewService("user_data")
}

func (u Service) GetUserByEmail(email string) (models.User, error) {
	var result models.User

	cursor := u.collection.FindOne(context.TODO(), bson.M{"email": email})
	err := cursor.Decode(&result)
	if err != nil {
		return models.User{ID: primitive.ObjectID{0}, Email: "", Password: ""}, err
	}
	return result, nil
}

func (u Service) GetUser(id primitive.ObjectID) (models.User, error) {
	var result models.User

	cursor := u.collection.FindOne(context.TODO(), bson.M{"_id": id})
	err := cursor.Decode(&result)
	if err != nil {
		return models.User{ID: primitive.ObjectID{0}, Email: "", Password: ""}, err
	}
	return result, nil
}

func (u Service) DeleteUser(id primitive.ObjectID) (interface{}, error) {
	res, err := u.collection.DeleteOne(context.TODO(), bson.M{"_id": id})
	return res.DeletedCount, err
}

func (u Service) CreateUser(obj models.User) (interface{}, error) {
	if obj.ID == primitive.NilObjectID {
		obj.ID = primitive.NewObjectID()
	}
	res, err := u.collection.InsertOne(context.TODO(), obj)
	return res, err
}

func (u Service) UpdateUser(obj models.User) {
	change := bson.M{"$set": bson.M{"balance": obj.Balance}}
	u.collection.UpdateByID(context.TODO(), obj.ID, change)
}

func (u Service) RemoveFromTotal(obj models.User, toRemove float64) {
	obj.Balance = obj.Balance - toRemove
	change := bson.M{"$set": bson.M{"balance": obj.Balance}}
	u.collection.UpdateByID(context.TODO(), obj.ID, change)
}
