package database

import (
	"context"
	"fmt"

	"github.com/redis/go-redis/v9"
	"github.com/shridarpatil/whatomate/internal/config"
)

// NewRedis creates a new Redis client
func NewRedis(cfg *config.RedisConfig) (*redis.Client, error) {
	var client *redis.Client

	// Use URL if provided (from REDIS_URL env var or config)
	if cfg.URL != "" {
		opt, err := redis.ParseURL(cfg.URL)
		if err != nil {
			return nil, fmt.Errorf("failed to parse Redis URL: %w", err)
		}
		client = redis.NewClient(opt)
	} else {
		// Fallback to individual config fields
		client = redis.NewClient(&redis.Options{
			Addr:     fmt.Sprintf("%s:%d", cfg.Host, cfg.Port),
			Password: cfg.Password,
			DB:       cfg.DB,
		})
	}

	// Test connection
	ctx := context.Background()
	if err := client.Ping(ctx).Err(); err != nil {
		return nil, fmt.Errorf("failed to connect to redis: %w", err)
	}

	return client, nil
}
