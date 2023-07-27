package networkController

import (
	"log"
	"net/http"
)

func GetFromAddress(addressVar string) {
	resp, err := http.Get(addressVar)
	if err != nil {
		log.Fatalln(err)
	} else {
		log.Println(resp)
	}

}
