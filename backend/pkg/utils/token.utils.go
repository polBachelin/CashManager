package utils

import (
	"net/http"

	"github.com/gin-gonic/gin"
)

func GetAuthToken(c *gin.Context) string {
	const BEARER_SCHEMA = "Bearer"
	authHeader := c.GetHeader("Authorization")
	if len(authHeader) == 0 {
		c.AbortWithStatus(http.StatusUnauthorized)
	}
	return authHeader[len(BEARER_SCHEMA):]
}
