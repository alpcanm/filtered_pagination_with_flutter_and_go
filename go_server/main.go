package main

import (
	"pagination_api/controller"

	"github.com/labstack/echo/v4"
)

func main() {
	e := echo.New()
	e.POST("/", controller.InsertAProduct)
	e.GET("/", controller.GetProducts)
	e.Logger.Fatal(e.Start("127.0.0.1:3000"))
}
