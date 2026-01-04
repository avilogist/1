export default {
  async fetch(request, env) {
    const url = new URL(request.url);
    const userAgent = request.headers.get('User-Agent') || '';
    
    // Only intercept requests to the root path
    if (url.pathname !== '/') {
      // Let all other requests (images, CSS, JS, etc.) pass through normally
      return env.ASSETS.fetch(request);
    }
    
    // Check if the request is from Roblox (HttpGet)
    const isRobloxRequest = userAgent.toLowerCase().includes('roblox') || 
                            userAgent.toLowerCase().includes('synapse') ||
                            userAgent === '';
    
    const acceptHeader = request.headers.get('Accept') || '';
    const isScriptRequest = !acceptHeader.includes('text/html');
    
    if (isRobloxRequest || isScriptRequest) {
      // Return the Lua script content
      try {
        const scriptResponse = await fetch('https://raw.githubusercontent.com/avilogist/1/refs/heads/main/projects/comet.lua');
        const scriptContent = await scriptResponse.text();
        
        return new Response(scriptContent, {
          status: 200,
          headers: {
            'Content-Type': 'text/plain',
            'Access-Control-Allow-Origin': '*',
            'Cache-Control': 'no-cache'
          }
        });
      } catch (error) {
        return new Response('warn("your executor is not supported by comets url loadstring, join the discord and report this issue with the name of your executor")', {
          status: 500,
          headers: { 'Content-Type': 'text/plain' }
        });
      }
    }
    
    // For normal browser requests, serve the HTML site
    return env.ASSETS.fetch(request);
  }
};

// claude cooked perfectly 👨‍🍳
