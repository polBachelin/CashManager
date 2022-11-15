package routes

import (
	"cash/backend/internal/controllers"
	service "cash/backend/internal/services"
	"fmt"
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/golang-jwt/jwt"
)

func output204(c *gin.Context) {
	c.JSON(204, "")
}

func AuthRequired() gin.HandlerFunc {
	return func(c *gin.Context) {
		const BEARER_SCHEMA = "Bearer"
		authHeader := c.GetHeader("Authorization")
		tokenString := authHeader[len(BEARER_SCHEMA):]
		token, err := service.ValidateToken(tokenString)
		if token.Valid {
			claims := token.Claims.(jwt.MapClaims)
			fmt.Println(claims)
			c.Next()
		} else {
			fmt.Println(err)
			c.AbortWithStatus(http.StatusUnauthorized)
		}
	}
}

func Setup(r *gin.Engine) {
	r.GET("/", output204)

	auth := r.Group("/")
	auth.Use(AuthRequired())
	{
		r.POST("/user", controllers.CreateUser)
	}
	r.GET("/user", controllers.GetUser)
	r.POST("/auth", controllers.AuthenticateUser)

}
