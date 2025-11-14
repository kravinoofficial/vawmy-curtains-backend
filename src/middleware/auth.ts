import { Request, Response, NextFunction } from 'express';

export const basicAuth = (req: Request, res: Response, next: NextFunction) => {
  const authHeader = req.headers.authorization;

  if (!authHeader || !authHeader.startsWith('Basic ')) {
    res.setHeader('WWW-Authenticate', 'Basic realm="Admin Portal"');
    return res.status(401).json({ error: 'Authentication required' });
  }

  const base64Credentials = authHeader.split(' ')[1];
  const credentials = Buffer.from(base64Credentials, 'base64').toString('utf-8');
  const [username, password] = credentials.split(':');

  const validUsername = process.env.ADMIN_USERNAME || 'admin';
  const validPassword = process.env.ADMIN_PASSWORD || 'changeme';

  if (username === validUsername && password === validPassword) {
    next();
  } else {
    res.setHeader('WWW-Authenticate', 'Basic realm="Admin Portal"');
    return res.status(401).json({ error: 'Invalid credentials' });
  }
};
