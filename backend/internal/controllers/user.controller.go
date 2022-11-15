package controllers

import (
	"cash/backend/internal/models"
	service "cash/backend/internal/services"
	"crypto/sha512"
	"encoding/hex"
	"fmt"
	"regexp"

	"github.com/gin-gonic/gin"
	"go.mongodb.org/mongo-driver/bson/primitive"
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

func PutUser(c *gin.Context) {
	var user models.User
	svc := service.NewUserService()
	err := c.BindJSON(&user)
	if err != nil {
		fmt.Println("[ERR]: PUT:/user: ", err)
		c.JSON(400, "")
		return
	}
	user.Password = hashPassword(user.Password)
	res, err := svc.CreateUser(user)
	if err != nil {
		c.JSON(500, "")
		return
	}
	c.JSON(200, res)
}

func DeleteUser(c *gin.Context) {
	var user models.User
	svc := service.NewUserService()
	err := c.BindJSON(&user)
	if err != nil {
		fmt.Println("[ERR]: DELETE:/user: ", err)
		c.JSON(400, "")
	}
	res, err := svc.DeleteUser(user.ID)
	if err != nil {
		c.JSON(500, "")
		return
	}
	c.JSON(200, res)
}

func isValidateNewUser(user models.User, svc *service.Service) (bool, string) {
	lenPass := len([]rune(user.Password))
	if lenPass < 10 || lenPass > 64 {
		return false, "Error password length 10 -> 64"
	}
	match, err := regexp.MatchString("^[a-zA-Z0-9]+.?[a-zA-Z0-9]+@[a-zA-Z0-9]+\\.[a-zA-Z0-9]+$", user.Email)
	if err != nil {
		return false, "Error regex " + err.Error()
	}
	if !match {
		return false, "Error email must be an email -> " + user.Email
	}
	var _, getByNameErr = svc.GetUserByEmail((user.Email))
	if getByNameErr == nil {
		return false, "Error email already exists -> " + user.Email
	}
	return true, "Ok"
}

func CreateUser(c *gin.Context) {
	var user models.User
	errorBind := c.BindJSON(&user)

	if errorBind != nil {
		fmt.Println("[ERR]: POST:/user: ", errorBind)
		c.JSON(400, "")
		return
	}
	svc := service.NewUserService()
	cartService := service.NewCartService()
	ok, err := isValidateNewUser(user, svc)
	if ok {
		user.Password = hashPassword(user.Password)
		cartRes, err := cartService.CreateCart(models.Cart{ID: primitive.NilObjectID, Total: 0, Articles: []models.Article{}})
		oid, _ := cartRes.InsertedID.(primitive.ObjectID)
		user.Cart = oid
		res, err := svc.CreateUser(user)
		if err != nil {
			c.JSON(500, "")
			return
		}
		c.JSON(200, res)
	} else {
		c.JSON(400, "Invalid username or password: "+err)
	}
}

func AuthenticateUser(c *gin.Context) {
	var user models.User
	var dbUser models.User
	errorBind := c.BindJSON(&user)

	if errorBind != nil {
		fmt.Println("[ERR]: POST:/user: ", errorBind)
		c.JSON(400, "")
		return
	}
	svc := service.NewUserService()
	dbUser, err := svc.GetUserByEmail(user.Email)
	if err != nil {
		fmt.Println("[ERR]: GET:/user/login: ", err)
		c.JSON(500, "Could not get user")
		return

	}
	if dbUser.Password != hashPassword(user.Password) {
		fmt.Println("[ERR]: POST:/auth: ", err)
		c.JSON(401, "")
		return
	}
	tokenString := service.GenerateToken(dbUser.ID)
	if tokenString == "" {
		c.JSON(400, "")
		return
	}
	c.JSON(200, tokenString)
}
