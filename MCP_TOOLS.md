# Penpot MCP Tools Documentation

## Overview

The Penpot MCP Server provides a comprehensive set of tools for AI-powered design workflow automation. These tools enable AI assistants (like Claude) to interact with Penpot projects, files, and design components programmatically through the Model Context Protocol.

## 🛠️ Available MCP Tools

### 1. **list_projects**
Lists all Penpot projects accessible to the authenticated user.

**Purpose**: Discover available design projects in your Penpot account

**Parameters**: None

**Returns**: 
```json
{
  "projects": [
    {
      "id": "project-uuid",
      "name": "Project Name",
      "created_at": "2025-01-01T00:00:00Z",
      "modified_at": "2025-01-15T00:00:00Z",
      "team_id": "team-uuid"
    }
  ]
}
```

**Use Cases**:
- Browse available projects
- Find specific projects by name
- Get project metadata for automation workflows

**Example Query**:
```
"Show me all my Penpot projects"
"List projects created this month"
"Find the project named 'Mobile App Design'"
```

---

### 2. **get_project_files**
Retrieves all files within a specific Penpot project.

**Purpose**: Access design files within a project

**Parameters**:
- `project_id` (required): UUID of the project

**Returns**:
```json
{
  "files": [
    {
      "id": "file-uuid",
      "name": "Design File",
      "created_at": "2025-01-01T00:00:00Z",
      "modified_at": "2025-01-15T00:00:00Z",
      "version": 42
    }
  ]
}
```

**Use Cases**:
- List all design files in a project
- Find specific files by name
- Track file versions and modifications

**Example Query**:
```
"Show me all files in project XYZ"
"What files were modified recently?"
"List all design files in my landing page project"
```

---

### 3. **get_file**
Fetches complete file data including all pages, components, and design elements. Caches the file for efficient subsequent access.

**Purpose**: Load and cache complete design file data

**Parameters**:
- `file_id` (required): UUID of the file

**Returns**:
```json
{
  "id": "file-uuid",
  "name": "Design File",
  "version": 42,
  "data": {
    "pages": [...],
    "components": [...],
    "colors": [...],
    "typography": [...]
  }
}
```

**Use Cases**:
- Load complete design file for analysis
- Cache file data for multiple operations
- Extract design system tokens
- Analyze component structure

**Example Query**:
```
"Load the design file for homepage"
"Get all components from file ABC123"
"Show me the design system from this file"
```

---

### 4. **get_object_tree**
Retrieves the hierarchical structure of design objects within a file or specific component.

**Purpose**: Understand the layer hierarchy and component structure

**Parameters**:
- `file_id` (required): UUID of the file
- `page_id` (optional): Specific page to analyze
- `object_id` (optional): Specific object to get tree for

**Returns**:
```json
{
  "tree": {
    "id": "root",
    "name": "Page Name",
    "type": "frame",
    "children": [
      {
        "id": "child-1",
        "name": "Header",
        "type": "group",
        "children": [...]
      }
    ]
  }
}
```

**Use Cases**:
- Analyze component hierarchy
- Understand layer organization
- Identify deeply nested structures
- Generate documentation for design systems

**Example Query**:
```
"Show me the layer structure of this page"
"What components are in the header section?"
"Visualize the hierarchy of this design file"
```

---

### 5. **search_object**
Searches for design objects by name within a file.

**Purpose**: Find specific design elements quickly

**Parameters**:
- `file_id` (required): UUID of the file
- `query` (required): Search term (object name)
- `page_id` (optional): Limit search to specific page

**Returns**:
```json
{
  "results": [
    {
      "id": "object-uuid",
      "name": "Button Primary",
      "type": "rect",
      "page_id": "page-uuid",
      "parent_id": "parent-uuid"
    }
  ]
}
```

**Use Cases**:
- Find specific components by name
- Locate UI elements across pages
- Search for design patterns
- Quick navigation to elements

**Example Query**:
```
"Find all buttons in this design"
"Search for 'navigation' components"
"Where is the logo component?"
```

---

### 6. **export_object**
Exports a specific design object as an image (PNG, JPG, SVG).

**Purpose**: Generate visual assets from design components

**Parameters**:
- `file_id` (required): UUID of the file
- `object_id` (required): UUID of the object to export
- `format` (optional): Export format (png, jpg, svg) - default: png
- `scale` (optional): Export scale (1-4) - default: 2

**Returns**:
```json
{
  "object_id": "object-uuid",
  "format": "png",
  "scale": 2,
  "image_data": "base64-encoded-image-data",
  "url": "https://penpot.app/export/..."
}
```

**Use Cases**:
- Generate component documentation images
- Create design asset library
- Export icons and illustrations
- Produce high-resolution mockups
- Generate screenshots for presentations

**Example Query**:
```
"Export the main button component as PNG"
"Generate an SVG of the logo"
"Create high-res exports of all icons"
```

---

## 🔧 MCP Resources

The server also provides several resources that can be accessed:

### 1. **server://info**
Server status and configuration information

### 2. **penpot://schema**
Complete Penpot API schema documentation

### 3. **penpot://tree-schema**
Penpot object tree structure schema

### 4. **rendered-component://{component_id}**
Rendered component images (cached)

### 5. **penpot://cached-files**
List of currently cached design files

---

## 🚀 Tool Combinations & Workflows

### Workflow 1: Project Analysis
```
1. list_projects → Find target project
2. get_project_files → List all files
3. get_file → Load specific file
4. get_object_tree → Analyze structure
```

### Workflow 2: Component Export
```
1. get_file → Load design file
2. search_object → Find specific component
3. export_object → Generate image
```

### Workflow 3: Design System Documentation
```
1. list_projects → Find design system project
2. get_project_files → Get all component files
3. get_file → Load each file
4. get_object_tree → Extract component hierarchy
5. export_object → Generate component previews
```

### Workflow 4: Design Review
```
1. get_file → Load file for review
2. get_object_tree → Understand structure
3. search_object → Find specific elements
4. export_object → Generate screenshots for feedback
```

---

## 🎯 Practical Use Cases

### For Designers

1. **Component Inventory**
   - Use `list_projects` + `get_project_files` + `search_object` to catalog all components
   
2. **Design System Audit**
   - Use `get_file` + `get_object_tree` to analyze component structure
   - Export components for documentation

3. **Asset Generation**
   - Bulk export icons, logos, and components using `export_object`

### For Developers

1. **Design-to-Code Sync**
   - Use `get_file` to extract design tokens
   - `get_object_tree` for component structure
   
2. **Automated Testing**
   - Export components for visual regression testing
   - Generate reference images

3. **Documentation Generation**
   - Automatically create component libraries
   - Generate design system docs

### For Product Teams

1. **Design Analytics**
   - Track component usage across projects
   - Identify design pattern adoption
   
2. **Collaboration**
   - Generate shareable component previews
   - Create design review materials

3. **Workflow Automation**
   - Automate repetitive export tasks
   - Batch process design files

---

## 🔐 Authentication

All tools require Penpot authentication via environment variables:

```bash
PENPOT_API_URL=https://design.penpot.app/api
PENPOT_USERNAME=your_username
PENPOT_PASSWORD=your_password
```

---

## 📊 Performance Considerations

### Caching
- `get_file` caches file data for subsequent operations
- Reduces API calls and improves performance
- Cache persists for the session

### Rate Limiting
- Respect Penpot API rate limits
- Batch operations when possible
- Use cached data for multiple queries

### Best Practices
1. Load files once, query multiple times
2. Use `search_object` instead of loading entire files
3. Export components at appropriate scale (2x is usually sufficient)
4. Clear cache periodically for updated designs

---

## 🐛 Error Handling

All tools handle common errors:
- Authentication failures
- Network issues
- Invalid file/object IDs
- CloudFlare protection blocks
- Rate limiting

Tools return descriptive error messages to help diagnose issues.

---

## 🔄 Future Tool Enhancements

Planned tools for future releases:

1. **create_project** - Create new Penpot projects
2. **create_file** - Create new design files
3. **update_object** - Modify design elements
4. **create_component** - Add new components
5. **bulk_export** - Export multiple objects at once
6. **get_comments** - Retrieve design comments
7. **add_comment** - Add feedback to designs
8. **get_version_history** - Access file version history
9. **compare_versions** - Compare file versions
10. **extract_design_tokens** - Export colors, typography, spacing

---

## 📚 Additional Resources

- [Penpot API Documentation](https://design.penpot.app/api/docs)
- [Model Context Protocol Specification](https://modelcontextprotocol.io)
- [Docker Deployment Guide](./DOCKER.md)
- [Claude Integration Guide](./CLAUDE_INTEGRATION.md)

---

## 💡 Example Conversations

### Example 1: Component Discovery
```
User: "What buttons do we have in our design system?"
Claude: [uses search_object with query="button"]
Claude: "I found 15 button variants across your design files..."
```

### Example 2: Export Workflow
```
User: "Export all icons from the UI Kit file"
Claude: [uses get_file → search_object → export_object for each icon]
Claude: "I've exported 42 icons in PNG format..."
```

### Example 3: Design Analysis
```
User: "Analyze the component structure of our mobile app design"
Claude: [uses get_file → get_object_tree]
Claude: "The design has 8 main screens with the following structure..."
```

---

## 🤝 Contributing

To add new MCP tools:

1. Implement the tool in `penpot_mcp/server/mcp_server.py`
2. Add appropriate error handling
3. Update this documentation
4. Add tests in `tests/`
5. Submit a pull request

---

**Last Updated**: October 29, 2025
**Version**: 0.1.2
