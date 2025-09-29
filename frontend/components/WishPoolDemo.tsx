"use client";

import { useState } from "react";

export const WishPoolDemo = () => {
  const [wishText, setWishText] = useState("");
  const [isConnected, setIsConnected] = useState(false);
  const [isLoading, setIsLoading] = useState(false);

  const handleConnect = async () => {
    setIsLoading(true);
    try {
      // MetaMask connection logic would go here
      setIsConnected(true);
    } catch (error) {
      console.error("Failed to connect:", error);
    } finally {
      setIsLoading(false);
    }
  };

  const handleMakeWish = async () => {
    if (!wishText.trim()) return;

    setIsLoading(true);
    try {
      // Wish making logic would go here
      console.log("Making wish:", wishText);
      setWishText("");
    } catch (error) {
      console.error("Failed to make wish:", error);
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-purple-50 via-pink-50 to-cyan-50 flex items-center justify-center p-4">
      <div className="rounded-2xl bg-gradient-to-br from-white to-gray-50 border border-gray-200 shadow-xl p-6 transition-all duration-200 hover:shadow-2xl hover:scale-[1.02] max-w-md w-full text-center">
        <div className="mb-6">
          <div className="w-16 h-16 bg-gradient-to-r from-purple-600 to-pink-600 rounded-full mx-auto mb-4 flex items-center justify-center">
            <span className="text-2xl">✨</span>
          </div>
          <h1 className="font-bold text-2xl text-gray-800 mb-2">FHE Wish Pool</h1>
          <p className="text-gray-600 leading-relaxed">Make your wishes come true with privacy-preserving blockchain magic</p>
        </div>

        {!isConnected ? (
          <button
            onClick={handleConnect}
            disabled={isLoading}
            className="inline-flex items-center justify-center rounded-xl bg-gradient-to-r from-purple-600 to-pink-600 px-6 py-3 font-semibold text-white shadow-lg transition-all duration-200 hover:from-purple-700 hover:to-pink-700 active:scale-95 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-purple-500 focus-visible:ring-offset-2 disabled:opacity-50 disabled:pointer-events-none disabled:cursor-not-allowed w-full"
          >
            <span className="text-lg">
              {isLoading ? "🔄 Connecting..." : "🌟 Connect MetaMask"}
            </span>
          </button>
        ) : (
          <div className="space-y-4">
            <div>
              <label htmlFor="wish-input" className="block text-sm font-medium text-gray-700 mb-2">
                Your Wish
              </label>
              <textarea
                id="wish-input"
                value={wishText}
                onChange={(e) => setWishText(e.target.value)}
                placeholder="Enter your wish here..."
                className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 focus:border-transparent resize-none"
                rows={3}
              />
            </div>

            <button
              onClick={handleMakeWish}
              disabled={isLoading || !wishText.trim()}
              className="inline-flex items-center justify-center rounded-xl bg-gradient-to-r from-purple-600 to-pink-600 px-6 py-3 font-semibold text-white shadow-lg transition-all duration-200 hover:from-purple-700 hover:to-pink-700 active:scale-95 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-purple-500 focus-visible:ring-offset-2 disabled:opacity-50 disabled:pointer-events-none disabled:cursor-not-allowed w-full"
            >
              <span className="text-lg">
                {isLoading ? "🔄 Making Wish..." : "✨ Make My Wish (0.001 ETH)"}
              </span>
            </button>
          </div>
        )}

        <div className="mt-6 text-xs text-gray-500">
          Powered by <a href="https://www.zama.ai/" target="_blank" rel="noopener noreferrer" className="text-purple-600 hover:underline">Zama FHEVM</a>
        </div>
      </div>
    </div>
  );
};
