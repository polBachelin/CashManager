package controllers

import (
	"cash/backend/internal/models"
	service "cash/backend/internal/services"
	"crypto/sha512"
	"encoding/hex"
	"fmt"
	"net/http"
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
	userID := getUserPrimitiveFromContext(c)
	svc := service.NewUserService()
	user, err := svc.GetUser(userID)
	if err != nil {
		c.AbortWithStatusJSON(http.StatusBadRequest, "No user found")
		return
	}
	c.JSON(http.StatusOK, user)
}

func PutUser(c *gin.Context) {
	var user models.User

	svc := service.NewUserService()
	err := c.BindJSON(&user)
	if err != nil {
		fmt.Println("[ERR]: PUT:/user: ", err)
		c.JSON(http.StatusBadRequest, "Could not bind user")
		return
	}
	user.Password = hashPassword(user.Password)
	res, err := svc.CreateUser(user)
	if err == nil {
		c.JSON(http.StatusOK, res)
	}
}

func DeleteUser(c *gin.Context) {
	userID := getUserPrimitiveFromContext(c)
	svc := service.NewUserService()
	user, err := svc.GetUser(userID)
	if err != nil {
		c.AbortWithStatusJSON(http.StatusBadRequest, "No user found")
		return
	}
	res, err := svc.DeleteUser(user.ID)
	c.JSON(http.StatusOK, res)
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
	var _, getByNameErr = svc.GetUserByEmail(user.Email)
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
		c.JSON(http.StatusBadRequest, "Error binding user")
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
		if err == nil {
			c.JSON(http.StatusOK, res)
			return
		}
		c.JSON(http.StatusInternalServerError, "Failed to create user")
	} else {
		c.JSON(http.StatusBadRequest, "Invalid username or password: "+err)
	}
}

func AuthenticateUser(c *gin.Context) {
	var user models.User
	var dbUser models.User
	errorBind := c.BindJSON(&user)

	if errorBind != nil {
		fmt.Println("[ERR]: POST:/user: ", errorBind)
		c.JSON(http.StatusBadRequest, "")
		return
	}
	svc := service.NewUserService()
	dbUser, err := svc.GetUserByEmail(user.Email)
	if err != nil {
		fmt.Println("[ERR]: AuthenticateUser[122]: ", err)
		c.JSON(http.StatusInternalServerError, "Could not get user")
		return

	}
	if dbUser.Password != hashPassword(user.Password) {
		fmt.Println("[ERR]: POST:/auth: ", err)
		c.JSON(http.StatusBadRequest, "Wrong password")
		return
	}
	tokenString := service.GenerateToken(dbUser.ID)
	if tokenString == "" {
		c.JSON(http.StatusBadRequest, "Could not generate token")
		return
	}
	c.JSON(http.StatusOK, gin.H{"token": tokenString})
}

func getUserPrimitiveFromContext(c *gin.Context) primitive.ObjectID {
	userIDString, _ := c.Get("user")
	userID, err := primitive.ObjectIDFromHex(fmt.Sprintf("%v", userIDString))
	if err != nil {
		c.AbortWithStatusJSON(http.StatusBadRequest, "Error while parsing user ID")
	}
	return userID
}

func GetUserBalance(c *gin.Context) {
	userID := getUserPrimitiveFromContext(c)
	svc := service.NewUserService()
	user, err := svc.GetUser(userID)
	if err != nil {
		c.AbortWithStatusJSON(http.StatusBadRequest, "No user found")
	}
	c.JSON(http.StatusOK, gin.H{"balance": user.Balance})
}

func GetUserCart(c *gin.Context) {
	userID := getUserPrimitiveFromContext(c)
	svc := service.NewUserService()
	user, err := svc.GetUser(userID)
	if err != nil {
		c.AbortWithStatusJSON(http.StatusBadRequest, "No user found")
	}
	cartService := service.NewCartService()
	cart, _ := cartService.GetCart(user.Cart)
	c.JSON(http.StatusOK, gin.H{"cart": cart})
}

func UserPayment(c *gin.Context) {
	userID := getUserPrimitiveFromContext(c)
	svc := service.NewUserService()
	user, err := svc.GetUser(userID)
	if err != nil {
		c.JSON(http.StatusBadRequest, "No user found")
		return
	}
	cartService := service.NewCartService()
	cart, err := cartService.GetCart(user.Cart)
	if err != nil {
		c.JSON(http.StatusBadRequest, "No cart found for user")
		return
	}
	if user.Balance < cart.Total {
		c.JSON(http.StatusInternalServerError, "Not enough in user balance")
		return
	}
	user.Balance = user.Balance - cart.Total
	cartService.ClearCart(cart)
	svc.UpdateUser(user)
	c.JSON(http.StatusOK, "Payment successful")
}
