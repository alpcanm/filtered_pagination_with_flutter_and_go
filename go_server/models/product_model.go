package models

type Product struct {
	Title string `json:"title,omitempty"`
	Date  int64  `json:"date,omitempty"`
	Tag   string `json:"tag,omitempty"`
}
