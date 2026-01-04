export default {
  async fetch(request, env) {
    const url = new URL(request.url);
    const userAgent = request.headers.get('User-Agent') || '';
    const isRobloxRequest = userAgent.toLowerCase().includes('roblox') || 
                            userAgent.toLowerCase().includes('synapse') ||
                            userAgent === '';
    const acceptHeader = request.headers.get('Accept') || '';
    const isScriptRequest = !acceptHeader.includes('text/html');
    if (isRobloxRequest || isScriptRequest) {
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
        return new Response('-- Error loading script', {
          status: 500,
          headers: { 'Content-Type': 'text/plain' }
        });
      }
    }
    return env.ASSETS.fetch(request);
  }
};
// did claude cook??
