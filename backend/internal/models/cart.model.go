package models

import "go.mongodb.org/mongo-driver/bson/primitive"

type Cart struct {
	ID       primitive.ObjectID `bson:"_id" json:"id"`
	Total    int64              `bson:"total" json:"total"`
	Articles []Article          `bson:"articles" json:"articles"`
}
