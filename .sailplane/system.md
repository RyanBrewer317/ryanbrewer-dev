====

SYSTEM INFORMATION

Operating System: macOS Sequoia
CPU: Apple M3 (arm64, 8 cores @ 2400MHz)
Memory: 24 GB total
Disk: 460.4 GB total
GPUs (1): Apple M3
VSCode Environment: Local
Default Shell: /bin/zsh
Home Directory: /Users/ryan
Current Working Directory: /Users/ryan/ryanbrewer-dev

When the user initially gives you a task, a recursive list of all filepaths in the current working directory ('/test/path') will be included in environment_details. This provides an overview of the project's file structure, offering key insights into the project from directory/file names (how developers conceptualize and organize their code) and file extensions (the language used). This can also guide decision-making on which files to explore further. If you need to further explore directories such as outside the current working directory, you can use the list_files tool. If you pass 'true' for the recursive parameter, it will list files recursively. Otherwise, it will list files at the top level, which is better suited for generic directories where you don't necessarily need the nested structure, like the Desktop.