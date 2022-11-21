package routes

import (
	"cash/backend/internal/controllers"
	service "cash/backend/internal/services"
	"fmt"
	"net/http"
	"strings"

	"github.com/gin-gonic/gin"
	"github.com/golang-jwt/jwt/v4"
)

func output204(c *gin.Context) {
	c.JSON(200, "Output 204")
}

func AuthRequired() gin.HandlerFunc {
	return func(c *gin.Context) {
		const BEARER_SCHEMA = "Bearer"
		authHeader := c.GetHeader("Authorization")
		if len(authHeader) == 0 {
			c.AbortWithStatus(http.StatusUnauthorized)
		}
		idTokenHeader := strings.Split(authHeader, "Bearer ")
		token, err := service.ValidateToken(idTokenHeader[1])
		if token.Valid {
			claims := token.Claims.(jwt.MapClaims)
			c.Set("user", claims["id"])
			c.Next()
		} else {
			fmt.Println("Token is not valid: ", err)
			c.AbortWithStatus(http.StatusUnauthorized)
		}
	}
}

func Setup(r *gin.Engine) {

	auth := r.Group("/")
	auth.Use(AuthRequired())
	{
		auth.DELETE("/user", controllers.DeleteUser)
		auth.PUT("/user", controllers.PutUser)
		auth.GET("/user/balance", controllers.GetUserBalance)
		auth.GET("/user/cart", controllers.GetUserCart)
		auth.GET("/user/payment", controllers.UserPayment)
		// auth.POST("/cart/articles/add", controllers.AddArticle)
		// auth.POST("/cart/articles/remove", controllers.RemoveArticle)
	}
	r.GET("/user", controllers.GetUser)
	r.POST("/user", controllers.CreateUser)
	r.POST("/auth", controllers.AuthenticateUser)
	// r.GET("/articles", controllers.GetAllArticles)
}
