package main

import "fmt"
import "io/ioutil"
import "net/http"
import "net/url"


type RoutingRequest struct {
	Source string
}

func (r* RoutingRequest) DetectCommand(text string) {
	var url = fmt.Sprintf("https://api.wit.ai/message?q=%s", url.QueryEscape(text))

	client := &http.Client{
		CheckRedirect: nil,
	}

	req, err := http.NewRequest("GET", url, nil)
	req.Header.Add("Authorization", "Bearer UE47AC55EFCKJM2WQCIDFBT5F3RK5EGW")
	resp, err := client.Do(req)

	contents, err := ioutil.ReadAll(resp.Body)

	if err != nil {
		fmt.Printf("%s", err)
	}

	fmt.Printf("%s\n", string(contents))
}

func (r *RoutingRequest) Run(text string) {
	r.DetectCommand(text)
}

func httpHandler(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Access-Control-Allow-Origin", "*")
  r.ParseForm()

	var request = RoutingRequest { r.RemoteAddr }
	var text string = r.FormValue("text")
	go request.Run(text)
}

func main() {
  http.HandleFunc("/", httpHandler)
  http.ListenAndServe(":8080", nil)
}
