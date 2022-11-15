package models

import "go.mongodb.org/mongo-driver/bson/primitive"

type Article struct {
	ID    primitive.ObjectID `bson:"_id" json:"id"`
	Name  string             `bson:"name" json:"name"`
	Price float64            `bson:"price" json:"price"`
}
