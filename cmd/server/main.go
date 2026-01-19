package main

import (
	"fmt"
	"log"
	"os"

	"github.com/whatomate/whatomate/internal/config"
	"github.com/whatomate/whatomate/internal/database"
)

func main() {
	// Load configuration
	var cfg *config.Config
	var err error

	// Auto-detect Railway deployment
	if os.Getenv("RAILWAY_ENVIRONMENT") != "" || os.Getenv("DATABASE_URL") != "" {
		cfg, err = config.LoadEnvConfig()
	} else {
		cfg, err = config.Load("config.toml")
	}

	if err != nil {
		log.Fatal("Failed to load config:", err)
	}

	// Connect to database
	db, err := database.NewPostgres(&cfg.Database, cfg.App.Debug)
	if err != nil {
		log.Fatal("Failed to connect to database:", err)
	}

	// Connect to Redis
	rdb, err := database.NewRedis(&cfg.Redis)
	if err != nil {
		log.Fatal("Failed to connect to Redis:", err)
	}

	// Determine port
	port := os.Getenv("PORT")
	if port == "" {
		port = fmt.Sprintf("%d", cfg.Server.Port)
	}

	fmt.Printf("Server would start on port %s\n", port)
	fmt.Println("Database connected:", db != nil)
	fmt.Println("Redis connected:", rdb != nil)

	// TODO: Implement full server logic
}
