package controllers

import (
	"cash/backend/internal/models"
	service "cash/backend/internal/services"
	"crypto/sha512"
	"encoding/hex"
	"fmt"

	"github.com/gin-gonic/gin"
)

func hashPassword(pass string) string {
	hash := sha512.New()
	hash.Write([]byte(pass))
	return hex.EncodeToString(hash.Sum(nil))
}

func GetUser(c *gin.Context) {
	var user models.User
	svc := service.NewUserService()
	err := c.BindJSON(&user)
	if err != nil {
		fmt.Println("[ERR]: GET:/user: ", err)
		c.JSON(400, "")
		return
	}
	user, err = svc.GetUser(user.ID)
	if err != nil {
		c.JSON(500, "")
		return
	}
	c.JSON(200, user)
}
