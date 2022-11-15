package models

import (
	"go.mongodb.org/mongo-driver/bson/primitive"
)

type User struct {
	ID       primitive.ObjectID `bson:"_id" json:"id,omitempty"`
	Email    string             `bson:"email" json:"email"`
	Name     string             `bson:"name" json:"name"`
	Password string             `bson:"password" json:"password"`
	Balance  int64              `bson:"balance" json:"balance"`
	Cart     primitive.ObjectID `bson:"cart" json:"cart"`
}
