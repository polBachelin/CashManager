package routes

import (
	"github.com/gin-gonic/gin"
)

func output204(c *gin.Context) {
	c.JSON(204, "")
}

func Setup(r *gin.Engine) {
	r.GET("/", output204)
}
