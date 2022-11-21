package middleware

import (
	service "cash/backend/internal/services"
	"fmt"
	"net/http"
	"strings"

	"github.com/gin-gonic/gin"
	"github.com/golang-jwt/jwt/v4"
)

func AuthRequired() gin.HandlerFunc {
	return func(c *gin.Context) {
		const BEARER_SCHEMA = "Bearer"
		authHeader := c.GetHeader("Authorization")
		if len(authHeader) == 0 {
			c.AbortWithStatus(http.StatusUnauthorized)
			return
		}
		idTokenHeader := strings.Split(authHeader, "Bearer ")
		if len(idTokenHeader) < 2 {
			c.AbortWithStatus(http.StatusUnauthorized)
			return
		}
		token, err := service.ValidateToken(idTokenHeader[1])
		if token != nil && token.Valid {
			claims := token.Claims.(jwt.MapClaims)
			c.Set("user", claims["id"])
			c.Next()
		} else {
			fmt.Println("Token is not valid: ", err)
			c.AbortWithStatus(http.StatusUnauthorized)
		}
	}
}
