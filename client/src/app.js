import React from 'react'
import { render } from 'react-dom'
import axios from 'axios'

const REQUEST_URL = 'http://localhost:3000/users.json'

class App extends React.Component {
  constructor(props) {
    super(props)
    this.state = {
      data: []
    }
  }

  componentDidMount() {
    this.fetchData()
  }

  fetchData() {
    axios.get(REQUEST_URL)
    .then((response) => response.data)
    .then((responseData) => {
      this.setState({
        data: responseData,
      })
    })
  }

  render () {
    return (
      <ul>
        {this.state.data.map((item) => {
          return (
            <li key={ item.id }>{ item.first_name }</li>
          )
        })}
      </ul>
    )
  }
}

render(
  <App />,
  document.getElementById('app')
)
