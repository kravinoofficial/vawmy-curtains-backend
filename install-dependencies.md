# Installing Backend Dependencies

Run this command in the backend folder:

```bash
npm install
```

This will install all dependencies including:
- express
- @supabase/supabase-js
- cors
- dotenv
- multer
- sharp (for image compression)

## Note on Sharp

Sharp is a high-performance image processing library. It may require additional build tools on some systems:

### Windows
- Install Visual Studio Build Tools or use `npm install --global windows-build-tools`

### Linux
- Usually works out of the box

### macOS
- Usually works out of the box

If you encounter issues installing sharp, see: https://sharp.pixelplumbing.com/install
