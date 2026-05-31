/**
 * @license
 * SPDX-License-Identifier: Apache-2.0
 */

import React, { useState, useEffect } from 'react';
import { Globe, Terminal, Copy, Check, Code, Cpu, Send, Lock, Eye } from 'lucide-react';
import { Vehicle, VehicleStatus } from '../types';

interface ExternalApiProps {
  vehicles: Vehicle[];
}

export default function ExternalApi({ vehicles }: ExternalApiProps) {
  const [copiedUrl, setCopiedUrl] = useState<string | null>(null);
  const [activePlaygroundIndex, setActivePlaygroundIndex] = useState<number | null>(0);
  const [testResponse, setTestResponse] = useState<string>('');
  const [loading, setLoading] = useState(false);

  const apiEndpoints = [
    {
      method: 'GET',
      path: '/api/v1/vehicles',
      desc: 'Выгрузка списка всех транспортных средств парка, включая текущий статус, ФИО водителя и ГЛОНАСС-координаты.',
      headers: {
        'Authorization': 'Bearer fl_live_7a3d90f2b3c431...',
        'Content-Type': 'application/json'
      },
      mockResponse: () => JSON.stringify(
        vehicles.map(v => ({
          id: v.id,
          plateNumber: v.plateNumber,
          model: v.model,
          driver: v.driver,
          status: v.status,
          telemetics: {
            fuelLevel: v.fuelLevel,
            speed: v.speed,
            engineTemp: v.engineTemp,
            coordinates: { lat: v.lat, lng: v.lng }
          },
          oneCSync: v.oneCSyncStatus
        })), 
        null, 2
      )
    },
    {
      method: 'POST',
      path: '/api/v1/vehicles/V1/status',
      desc: 'Оперативное изменение статуса конкретного ТС внешней системой (например, терминалом КПП склада или СТО 1С).',
      headers: {
        'Authorization': 'Bearer fl_live_7a3d90f2b3c431...',
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        status: 'IN_ROUTE',
        reason: 'Выезд одобрен автоматически СКУД КПП складского комплекса Медведково',
        changedBy: 'Автомат Ворота КПП-3'
      }, null, 2),
      mockResponse: () => JSON.stringify({
        success: true,
        message: "Status successfully updated via External REST integration",
        updatedAt: new Date().toISOString(),
        payload: {
          vehicleId: "V1",
          newStatus: "IN_ROUTE",
          notifiedTelemetryTracker: true,
          synchronizedWithOneC: "pending_background_queue"
        }
      }, null, 2)
    },
    {
      method: 'GET',
      path: '/api/v1/telematics/anomalies',
      desc: 'Сводный реестр критических технологических инцидентов флота (перегрев ДВС, падение бака, потеря ГЛОНАСС).',
      headers: {
        'Authorization': 'Bearer fl_live_7a3d90f2b3c431...',
        'Content-Type': 'application/json'
      },
      mockResponse: () => JSON.stringify(
        vehicles
          .filter(v => v.status === VehicleStatus.BREAKDOWN || v.fuelLevel < 15 || v.engineTemp > 98)
          .map(v => ({
            id: v.id,
            plateNumber: v.plateNumber,
            driver: v.driver,
            anomalies: [
              ...(v.status === VehicleStatus.BREAKDOWN ? [`АВАРИЯ: ${v.reason}`] : []),
              ...(v.fuelLevel < 15 ? [`КРИТИЧЕСКИ МАЛО ТОПЛИВА: ${v.fuelLevel}%`] : []),
              ...(v.engineTemp > 98 ? [`КРИТИЧЕСКИЙ НАГРЕВ ТЕРМОСТАТА ДВС: ${v.engineTemp}°C`] : [])
            ]
          })), 
        null, 2
      )
    }
  ];

  const handleCopy = (text: string, id: string) => {
    navigator.clipboard.writeText(text);
    setCopiedUrl(id);
    setTimeout(() => setCopiedUrl(null), 2000);
  };

  const handleRunTest = (index: number) => {
    setLoading(true);
    setTimeout(() => {
      setTestResponse(apiEndpoints[index].mockResponse());
      setLoading(false);
    }, 600);
  };

  // Run the initial endpoint test
  useEffect(() => {
    if (activePlaygroundIndex !== null) {
      setTestResponse(apiEndpoints[activePlaygroundIndex].mockResponse());
    }
  }, [activePlaygroundIndex]);

  return (
    <div className="space-y-6" id="api_explorer_view">
      
      {/* Informational Welcome Message */}
      <div className="bg-slate-900 text-white p-5 rounded-2xl border border-slate-800 shadow-md">
        <div className="flex items-center space-x-3 mb-3">
          <Globe className="text-emerald-400 stroke-[2.2]" size={20} />
          <h2 className="text-base font-bold tracking-tight">Внешний REST-API шлюз интеграции флота</h2>
        </div>
        <p className="text-xs text-slate-400 leading-relaxed max-w-4xl">
          Спроектированный API позволяет бесшовно связать ЦУП Автопарка с вашими корпоративными ERP-системами, 
          внешними СТО, диспетчерскими агрегаторами грузоперевозок (ATI) или терминалами заездов СКУД. 
          Шлюз работает по протоколу <strong className="text-slate-200 font-mono">HTTPS JSON REST</strong> с токеном авторизации Bearer-Token.
        </p>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-12 gap-6">
        
        {/* API documentation endpoints lists (Left Col) */}
        <div className="lg:col-span-6 space-y-4" id="api_docs_panel">
          <h3 className="font-bold text-sm text-slate-800">Доступные эндпоинты интеграции</h3>

          {apiEndpoints.map((endpoint, idx) => (
            <div
              key={idx}
              onClick={() => setActivePlaygroundIndex(idx)}
              className={`p-4 bg-white border rounded-xl transition cursor-pointer text-xs space-y-2.5 ${
                activePlaygroundIndex === idx 
                  ? 'border-indigo-500 ring-2 ring-indigo-500/10 shadow-sm' 
                  : 'border-slate-200 hover:border-slate-300'
              }`}
            >
              <div className="flex items-center justify-between">
                <div className="flex items-center space-x-2">
                  <span className={`px-2 py-0.5 rounded font-mono font-bold text-[10px] ${
                    endpoint.method === 'GET' ? 'bg-emerald-100 text-emerald-800' : 'bg-indigo-100 text-indigo-800'
                  }`}>
                    {endpoint.method}
                  </span>
                  <span className="font-mono text-slate-800 font-bold bg-slate-50 px-1.5 py-0.5 rounded border border-slate-100">{endpoint.path}</span>
                </div>
                
                <span className="text-[10px] text-indigo-600 font-semibold flex items-center gap-1">
                  <Eye size={12} />
                  Тестировать в песочнице
                </span>
              </div>

              <p className="text-slate-600 leading-relaxed">{endpoint.desc}</p>
              
              <div className="flex items-center space-x-2 text-[10px] text-slate-400 font-mono">
                <span className="flex items-center gap-1"><Lock size={10} /> Bearer Auth</span>
                <span>•</span>
                <span>Response: JSON</span>
              </div>
            </div>
          ))}
        </div>

        {/* Sandbox Playground interactive emulator (Right Col) */}
        <div className="lg:col-span-6 space-y-4" id="api_playground_panel">
          <h3 className="font-bold text-sm text-slate-805">Песочница и интерактивный симулятор</h3>

          {activePlaygroundIndex !== null && (
            <div className="bg-slate-900 border border-slate-800 text-slate-200 rounded-xl overflow-hidden shadow-xl flex flex-col justify-between">
              
              {/* Header block */}
              <div className="px-4 py-3 bg-slate-950 border-b border-slate-850 flex items-center justify-between">
                <div className="flex items-center space-x-2">
                  <Terminal size={14} className="text-emerald-400" />
                  <span className="font-mono text-xs font-bold uppercase text-slate-400">REST Client Simulator</span>
                </div>
                <div className="flex items-center space-x-2">
                  <span className="text-[10px] bg-slate-800 text-indigo-400 font-mono py-0.5 px-2 rounded">ONLINE</span>
                </div>
              </div>

              <div className="p-4 space-y-4 text-xs font-mono">
                {/* Method path visualizer bar */}
                <div className="flex items-center space-x-2 bg-slate-950 p-2 rounded-lg border border-slate-800">
                  <span className={`px-2 py-0.5 rounded font-bold text-[10px] ${
                    apiEndpoints[activePlaygroundIndex].method === 'GET' ? 'bg-emerald-500 text-slate-950' : 'bg-indigo-500 text-white'
                  }`}>
                    {apiEndpoints[activePlaygroundIndex].method}
                  </span>
                  <span className="text-slate-100 flex-1 truncate select-all">
                    https://api.yourdomain.com{apiEndpoints[activePlaygroundIndex].path}
                  </span>
                  <button
                    onClick={() => handleCopy(`https://api.yourdomain.com${apiEndpoints[activePlaygroundIndex].path}`, 'url_' + activePlaygroundIndex)}
                    className="p-1 text-slate-400 hover:text-white rounded"
                    title="Копировать URL"
                  >
                    {copiedUrl === 'url_' + activePlaygroundIndex ? <Check size={13} className="text-emerald-400" /> : <Copy size={13} />}
                  </button>
                </div>

                {/* HTTP Headers */}
                <div>
                  <span className="text-[10px] text-slate-400 block font-bold mb-1 uppercase tracking-tight">Заголовки запроса (HTTP Headers):</span>
                  <pre className="bg-slate-950/50 p-2.5 rounded-lg border border-slate-850 text-[10px] text-slate-300">
                    {Object.entries(apiEndpoints[activePlaygroundIndex].headers).map(([key, value]) => (
                      <div key={key}>
                        <span className="text-emerald-400">{key}</span>: {value}
                      </div>
                    ))}
                  </pre>
                </div>

                {/* Body details if exists (for POST queries) */}
                {apiEndpoints[activePlaygroundIndex].body && (
                  <div>
                    <span className="text-[10px] text-slate-400 block font-bold mb-1 uppercase tracking-tight">Тело запроса (JSON Payload):</span>
                    <pre className="bg-slate-950/50 p-2 text-[10px] text-amber-300 overflow-x-auto rounded border border-slate-850">
                      {apiEndpoints[activePlaygroundIndex].body}
                    </pre>
                  </div>
                )}

                {/* Send button trigger */}
                <div className="flex justify-between items-center pt-2">
                  <span className="text-[11px] text-slate-400 font-sans">Автокод авторизован, подключение стабильное.</span>
                  
                  <button
                    onClick={() => handleRunTest(activePlaygroundIndex)}
                    disabled={loading}
                    className="py-1.5 px-4 bg-emerald-520 text-slate-950 hover:bg-emerald-400 rounded-lg text-xs font-bold flex items-center space-x-1.5 cursor-pointer disabled:opacity-50 transition active:scale-95 shadow-md"
                  >
                    <Send size={12} />
                    <span>{loading ? 'Запрос отправлен...' : 'Выполнить запрос'}</span>
                  </button>
                </div>

                {/* Response Code Block */}
                <div className="space-y-1 pt-2 border-t border-slate-850">
                  <div className="flex justify-between text-[10px] text-slate-500 font-bold uppercase tracking-wide">
                    <span>Тело ответа сервера (JSON Response):</span>
                    <span className="text-emerald-400">STATUS: 200 OK</span>
                  </div>
                  <pre className="bg-slate-950 p-3 rounded-lg border border-slate-850 text-[10px] text-emerald-400 overflow-x-auto max-h-60 overflow-y-auto leading-relaxed select-all">
                    {loading ? '// Запрос ушел в шлюз. Ожидание ответа микросервиса...' : testResponse}
                  </pre>
                </div>

              </div>

            </div>
          )}

        </div>

      </div>

    </div>
  );
}
