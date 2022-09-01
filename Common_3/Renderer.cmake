# Renderers
set(RENDERER_SOURCE_FILES
    ../The-Forge/Common_3/Renderer/ResourceLoader.cpp
    ../The-Forge/Common_3/Renderer/Renderer.cpp
    ../The-Forge/Common_3/Renderer/CommonShaderReflection.cpp
)

set(RENDERER_INCLUDE_FILES
    ../The-Forge/Common_3/Renderer/IRay.h
    ../The-Forge/Common_3/Renderer/IRenderer.h
    ../The-Forge/Common_3/Renderer/IResourceLoader.h
    ../The-Forge/Common_3/Renderer/IShaderReflection.h
)

set(AGS_INCLUDE_FILES
    ../The-Forge/Common_3/ThirdParty/OpenSource/ags/AgsHelper.h
)

set(NVAPI_INCLUDE_FILES
    ../The-Forge/Common_3/ThirdParty/OpenSource/nvapi/NvApiHelper.h
)

set(METAL_FILES
    ../The-Forge/Common_3/Renderer/Metal/MetalAvailabilityMacros.h
    ../The-Forge/Common_3/Renderer/Metal/MetalCapBuilder.h
    ../The-Forge/Common_3/Renderer/Metal/MetalConfig.h
    ../The-Forge/Common_3/Renderer/Metal/MetalMemoryAllocator.h
    ../The-Forge/Common_3/Renderer/Metal/MetalMemoryAllocatorImpl.h
    ../The-Forge/Common_3/Renderer/Metal/MetalRaytracing.mm
    ../The-Forge/Common_3/Renderer/Metal/MetalRenderer.mm
    ../The-Forge/Common_3/Renderer/Metal/MetalShaderReflection.mm
)

set(RENDER_QUEST_FILES
    ../The-Forge/Common_3/Renderer/Quest/VrApiHooks.cpp
    ../The-Forge/Common_3/Renderer/Quest/VrApiHooks.h
)

set(DX11_FILES
    ../The-Forge/Common_3/Renderer/Direct3D11/Direct3D11.cpp
    ../The-Forge/Common_3/Renderer/Direct3D11/Direct3D11CapBuilder.h
    ../The-Forge/Common_3/Renderer/Direct3D11/Direct3D11Config.h
    ../The-Forge/Common_3/Renderer/Direct3D11/Direct3D11Raytracing.cpp
    ../The-Forge/Common_3/Renderer/Direct3D11/Direct3D11ShaderReflection.cpp
)

set(DX12_FILES
    ../The-Forge/Common_3/Renderer/Direct3D12/Direct3D12.cpp
    ../The-Forge/Common_3/Renderer/Direct3D12/Direct3D12CapBuilder.h
    ../The-Forge/Common_3/Renderer/Direct3D12/Direct3D12Hooks.cpp
    ../The-Forge/Common_3/Renderer/Direct3D12/Direct3D12Hooks.h
    ../The-Forge/Common_3/ThirdParty/OpenSource/D3D12MemoryAllocator/Direct3D12MemoryAllocator.h
    ../The-Forge/Common_3/Renderer/Direct3D12/Direct3D12Raytracing.cpp
    ../The-Forge/Common_3/Renderer/Direct3D12/Direct3D12ShaderReflection.cpp
)

set(VULKAN_FILES
    ../The-Forge/Common_3/Renderer/Vulkan/Vulkan.cpp
    ../The-Forge/Common_3/Renderer/Vulkan/VulkanCapsBuilder.h
    ../The-Forge/Common_3/Renderer/Vulkan/VulkanConfig.h
    ../The-Forge/Common_3/ThirdParty/OpenSource/VulkanMemoryAllocator/VulkanMemoryAllocator.h
    ../The-Forge/Common_3/Renderer/Vulkan/VulkanRaytracing.cpp
    ../The-Forge/Common_3/Renderer/Vulkan/VulkanShaderReflection.cpp
)

if(${METAL} MATCHES ON)
    find_library(APPLE_METAL Metal)
    find_library(APPLE_METALKIT MetalKit)
    find_library(APPLE_METALPS MetalPerformanceShaders)

    set(RENDER_LIBRARIES ${RENDER_LIBRARIES}
        ${APPLE_METAL}
        ${APPLE_METALKIT}
        ${APPLE_METALPS}
    )

    set(RENDERER_FILES ${RENDERER_FILES} ${METAL_FILES})
endif()

if(${VULKAN} MATCHES ON)
    find_package(Vulkan REQUIRED)
    if (Vulkan_FOUND MATCHES TRUE)
        message("Vulkan SDK found.")
        set(RENDER_LIBRARIES ${RENDER_LIBRARIES} Vulkan::Vulkan)
    else()
        message("Vulkan SDK not found.  Please make sure it is installed and added to your path.")
    endif()
    set(RENDERER_FILES ${RENDERER_FILES} ${VULKAN_FILES})
    set(RENDER_LIBRARIES ${RENDER_LIBRARIES} SpirvTools)
endif()

if(${DX11} MATCHES ON)
    set(RENDER_LIBRARIES ${RENDER_LIBRARIES}
        DirectXShaderCompiler
        "d3d11.lib"
    )
    set(RENDERER_FILES ${RENDERER_FILES} ${DX11_FILES} ${AGS_INCLUDE_FILES})
endif()

if(${DX12} MATCHES ON)
    set(RENDER_LIBRARIES ${RENDER_LIBRARIES}
        "d3d12.lib"
    )

    set(RENDERER_FILES ${RENDERER_FILES} ${DX12_FILES} ${AGS_INCLUDE_FILES})
endif()

if(${APPLE_PLATFORM} MATCHES ON)
    find_library(APPLE_APPKIT AppKit)
    find_library(APPLE_QUARTZCORE QuartzCore)
    find_library(APPLE_IOKIT IOKit)

    set(RENDER_LIBRARIES
        ${RENDER_LIBRARIES}
        ${APPLE_QUARTZCORE}
        ${APPLE_APPKIT}
        ${APPLE_IOKIT}
    )
    
    add_compile_options("-x objective-c++")
endif()

if(${WINDOWS} MATCHES ON)
    set(RENDER_LIBRARIES ${RENDER_LIBRARIES}
        WinPixEventRuntime
        AGS
        Nvapi
    )

    set(RENDER_LIBRARIES ${RENDER_LIBRARIES}
        "Xinput9_1_0.lib"
        "ws2_32.lib"
    )

    set(RENDERER_FILES ${RENDERER_FILES} ${NVAPI_INCLUDE_FILES})

    set(RENDER_DEFINES ${RENDER_DEFINES}
        "_WINDOWS"
    )
endif()
