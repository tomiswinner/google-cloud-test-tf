import { useState } from 'react'

type Method = 'GET' | 'POST' | 'PUT' | 'PATCH' | 'DELETE'

interface RequestBody {
  name?: string
  value?: string
  id?: number
}

function App() {
  const [backend, setBackend] = useState('http://localhost:8080')
  const [output, setOutput] = useState('結果がここに表示されます')
  const [useJson, setUseJson] = useState(true)

  // Form states
  const [getId, setGetId] = useState(1)
  const [postName, setPostName] = useState('newItem')
  const [postValue, setPostValue] = useState('test')
  const [putId, setPutId] = useState(1)
  const [putName, setPutName] = useState('updated')
  const [putValue, setPutValue] = useState('newValue')
  const [patchId, setPatchId] = useState(1)
  const [patchValue, setPatchValue] = useState('patched')
  const [deleteId, setDeleteId] = useState(1)

  const doRequest = async (method: Method, path: string, body?: RequestBody) => {
    if (!backend.trim()) {
      alert('Set backend URL first')
      return
    }

    setOutput(`${method} ${path} ...\n`)

    const options: RequestInit = {
      method,
      credentials: 'omit',
    }

    if (body) {
      if (useJson) {
        options.headers = { 'Content-Type': 'application/json' }
        options.body = JSON.stringify(body)
      } else {
        options.headers = { 'Content-Type': 'application/x-www-form-urlencoded' }
        options.body = new URLSearchParams(body as Record<string, string>).toString()
      }
    }

    try {
      const res = await fetch(backend + path, options)
      const text = await res.text()
      setOutput(`${method} ${path}\nStatus: ${res.status}\n\n${text}`)
    } catch (err) {
      setOutput(`${method} ${path}\nError: ${err}`)
    }
  }

  return (
    <>
      <h1>CORS Test Front</h1>

      <div className="section">
        <h3>Backend URL</h3>
        <input
          type="text"
          value={backend}
          onChange={(e) => setBackend(e.target.value)}
          style={{ width: '70%' }}
        />
      </div>

      <div className="section">
        <h3>Content-Type 設定</h3>
        <label className="checkbox-label">
          <input
            type="checkbox"
            checked={useJson}
            onChange={(e) => setUseJson(e.target.checked)}
          />
          application/json (プリフライト発生)
        </label>
        <p>
          {useJson
            ? '→ POST/PUT/PATCH は Content-Type: application/json でプリフライトが発生します'
            : '→ POST/PUT/PATCH は Content-Type: application/x-www-form-urlencoded で Simple Request になります'}
        </p>
      </div>

      <div className="section">
        <h3>Response</h3>
        <pre>{output}</pre>
      </div>

      <div className="section">
        <h3><span className="method get">GET</span> /api/ping</h3>
        <p>Simple request (プリフライトなし)</p>
        <button onClick={() => doRequest('GET', '/api/ping')}>Ping</button>
      </div>

      <div className="section">
        <h3><span className="method get">GET</span> /api/items</h3>
        <p>Simple request - 全アイテム取得</p>
        <button onClick={() => doRequest('GET', '/api/items')}>Get All Items</button>
      </div>

      <div className="section">
        <h3><span className="method get">GET</span> /api/items/:id</h3>
        <p>Simple request - 1件取得</p>
        <div className="input-group">
          <input
            type="number"
            value={getId}
            onChange={(e) => setGetId(Number(e.target.value))}
          />
          <button onClick={() => doRequest('GET', `/api/items/${getId}`)}>
            Get Item
          </button>
        </div>
      </div>

      <div className="section">
        <h3><span className="method post">POST</span> /api/items</h3>
        <p>{useJson ? 'Preflight required (Content-Type: application/json)' : 'Simple request (Content-Type: application/x-www-form-urlencoded)'}</p>
        <div className="input-group">
          <input
            type="text"
            placeholder="name"
            value={postName}
            onChange={(e) => setPostName(e.target.value)}
          />
          <input
            type="text"
            placeholder="value"
            value={postValue}
            onChange={(e) => setPostValue(e.target.value)}
          />
          <button onClick={() => doRequest('POST', '/api/items', { name: postName, value: postValue })}>
            Create Item
          </button>
        </div>
      </div>

      <div className="section">
        <h3><span className="method put">PUT</span> /api/items/:id</h3>
        <p>Preflight required (PUT メソッド)</p>
        <div className="input-group">
          <input
            type="number"
            value={putId}
            onChange={(e) => setPutId(Number(e.target.value))}
          />
          <input
            type="text"
            placeholder="name"
            value={putName}
            onChange={(e) => setPutName(e.target.value)}
          />
          <input
            type="text"
            placeholder="value"
            value={putValue}
            onChange={(e) => setPutValue(e.target.value)}
          />
          <button onClick={() => doRequest('PUT', `/api/items/${putId}`, { name: putName, value: putValue })}>
            Update Item
          </button>
        </div>
      </div>

      <div className="section">
        <h3><span className="method patch">PATCH</span> /api/items/:id</h3>
        <p>Preflight required (PATCH メソッド)</p>
        <div className="input-group">
          <input
            type="number"
            value={patchId}
            onChange={(e) => setPatchId(Number(e.target.value))}
          />
          <input
            type="text"
            placeholder="value"
            value={patchValue}
            onChange={(e) => setPatchValue(e.target.value)}
          />
          <button onClick={() => doRequest('PATCH', `/api/items/${patchId}`, { value: patchValue })}>
            Patch Item
          </button>
        </div>
      </div>

      <div className="section">
        <h3><span className="method delete">DELETE</span> /api/items/:id</h3>
        <p>Preflight required (DELETE メソッド)</p>
        <div className="input-group">
          <input
            type="number"
            value={deleteId}
            onChange={(e) => setDeleteId(Number(e.target.value))}
          />
          <button onClick={() => doRequest('DELETE', `/api/items/${deleteId}`)}>
            Delete Item
          </button>
        </div>
      </div>
    </>
  )
}

export default App

