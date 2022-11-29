package controllers

import (
	"cash/backend/pkg/utils"
	"net/http"
	"os"

	"github.com/gin-gonic/gin"
)

func GetAllArticles(c *gin.Context) {
	dat, err := os.ReadFile(utils.GetEnvVar("ARTICLE_PATH", "./articles.json"))
	if err != nil {
		c.JSON(400, "Failed to read articles file")
		return
	}
	c.Data(http.StatusOK, "application/json", dat)
}
