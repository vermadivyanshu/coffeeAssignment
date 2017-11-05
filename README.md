# JSON FORMATTER

## Synopsis

A json formatter to transforms the json as follows:
* it will change any occurance of:
```
{
    books: [
        {
            book: {
                name: 'Love in the time of Cholera'
            }
        },
        {
            book: {
                name: 'Tell me your dreams'
            }
        }
    ]
}
```
into:
 ```
 {
     books: [
         {
             name: 'Love in the time of Cholera'
         },
         {
             name: 'Tell me your dreams'
         }
     ]
 }

 ```

 ## Installation
 1. Clone the repository
 2. Run `npm install`
 3. Run `npm run dev_build`
 4. How to supply input
    - supplying a json object:
    ```
    input: {"books":[{"book": {"name": "Tell me your dreams"}}]}
    ```
    - supplying an array of objects:
    ```
    input: [{"hello":"World"},{"pens":[{"pen": {"ink":"blue"}}]}]
    ```

 ## Tests
 1. Run `npm run test`