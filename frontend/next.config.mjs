/** @type {import('next').NextConfig} */
const nextConfig = {
    async rewrites() {
      if (!process.env.API_URL) {
        throw new Error('API_URL is not defined in environment variables');
      }
      return [
        {
          source: "/uploads/:path*",
          destination: `${process.env.API_URL}/uploads/:path*`
        }
      ];
    }
  };
  
  export default nextConfig;