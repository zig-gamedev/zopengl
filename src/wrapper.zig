const builtin = @import("builtin");

const std = @import("std");
const log = std.log.scoped(.zopengl);
const assert = std.debug.assert;

const meta = struct {
    pub fn mergeEnums(comptime Enums: anytype) type {
        const tag_type = @typeInfo(Enums[0]).@"enum".tag_type;
        const num_fields = countFields: {
            var count: comptime_int = 0;
            for (Enums) |Subset| {
                for (std.meta.fields(Subset)) |_| count += 1;
            }
            break :countFields count;
        };
        comptime var fields: [num_fields]std.builtin.Type.EnumField = .{undefined} ** num_fields;
        comptime var i = 0;
        for (Enums) |Subset| {
            const subset_info = @typeInfo(Subset).@"enum";
            assert(subset_info.tag_type == tag_type);
            for (subset_info.fields) |field| {
                assert(i < fields.len);
                fields[i] = field;
                i += 1;
            }
        }
        return @Type(.{ .@"enum" = .{
            .tag_type = tag_type,
            .fields = &fields,
            .decls = &.{},
            .is_exhaustive = true,
        } });
    }
};

pub fn Wrap(comptime bindings: anytype) type {
    return struct {
        pub const Framebuffer = enum(Uint) { invalid = 0, _ };
        pub const Renderbuffer = enum(Uint) { invalid = 0, _ };
        pub const Shader = enum(Uint) { invalid = 0, _ };
        pub const Program = enum(Uint) { invalid = 0, _ };
        pub const Texture = enum(Uint) { invalid = 0, _ };
        pub const Query = enum(Uint) { invalid = 0, _ };
        pub const Buffer = enum(Uint) { invalid = 0, _ };
        pub const VertexArrayObject = enum(Uint) { invalid = 0, _ };

        pub const UniformLocation = enum(Int) { invalid = -1, _ };

        pub const VertexAttribLocation = enum(Uint) { _ };

        pub const Sampler = enum(Uint) { invalid = 0, _ };

        pub const TransformFeedback = enum(Uint) { invalid = 0, _ };

        pub const ProgramPipeline = enum(Uint) { invalid = 0, _ };

        pub const Error = enum(Enum) {
            //--------------------------------------------------------------------------------------
            // OpenGL 1.0 (Core Profile)
            //--------------------------------------------------------------------------------------
            no_error = NO_ERROR,
            invalid_enum = INVALID_ENUM,
            invalid_value = INVALID_VALUE,
            invalid_operation = INVALID_OPERATION,
            stack_overflow = STACK_OVERFLOW,
            stack_underflow = STACK_UNDERFLOW,
            out_of_memory = OUT_OF_MEMORY,
            invalid_framebuffer_operation = INVALID_FRAMEBUFFER_OPERATION,
        };

        pub const Capability = enum(Enum) {
            //--------------------------------------------------------------------------------------
            // OpenGL 1.0 (Core Profile)
            //--------------------------------------------------------------------------------------
            blend = BLEND,
            cull_face = CULL_FACE,
            depth_test = DEPTH_TEST,
            dither = DITHER,
            line_smooth = LINE_SMOOTH,
            polygon_smooth = POLYGON_SMOOTH,
            scissor_test = SCISSOR_TEST,
            stencil_test = STENCIL_TEST,
            //--------------------------------------------------------------------------------------
            // OpenGL 1.1 (Core Profile)
            //--------------------------------------------------------------------------------------
            color_logic_op = COLOR_LOGIC_OP,
            polygon_offset_fill = POLYGON_OFFSET_FILL,
            polygon_offset_line = POLYGON_OFFSET_LINE,
            polygon_offset_point = POLYGON_OFFSET_POINT,
            //--------------------------------------------------------------------------------------
            // OpenGL 1.3 (Core Profile)
            //--------------------------------------------------------------------------------------
            multisample = MULTISAMPLE,
            sample_alpha_to_coverage = SAMPLE_ALPHA_TO_COVERAGE,
            sample_alpha_to_one = SAMPLE_ALPHA_TO_ONE,
            sample_coverage = SAMPLE_COVERAGE,
            //--------------------------------------------------------------------------------------
            // OpenGL 2.0 (Core Profile)
            //--------------------------------------------------------------------------------------
            program_point_size = PROGRAM_POINT_SIZE,
            //--------------------------------------------------------------------------------------
            // OpenGL 3.0 (Core Profile)
            //--------------------------------------------------------------------------------------
            framebuffer_srgb = FRAMEBUFFER_SRGB,
            rasterizer_discard = RASTERIZER_DISCARD,
            //--------------------------------------------------------------------------------------
            // OpenGL 3.1 (Core Profile)
            //--------------------------------------------------------------------------------------
            primitive_restart = PRIMITIVE_RESTART,
            //--------------------------------------------------------------------------------------
            // OpenGL 3.2 (Core Profile)
            //--------------------------------------------------------------------------------------
            depth_clamp = DEPTH_CLAMP,
            sample_mask = SAMPLE_MASK,
            texture_cube_map_seamless = TEXTURE_CUBE_MAP_SEAMLESS,
            //--------------------------------------------------------------------------------------
            // OpenGL 4.0 (Core Profile)
            //--------------------------------------------------------------------------------------
            sample_shading = SAMPLE_SHADING,
            //--------------------------------------------------------------------------------------
            // OpenGL 4.3 (Core Profile)
            //--------------------------------------------------------------------------------------
            debug_output = DEBUG_OUTPUT,
        };

        pub const StringParamName = enum(Enum) {
            //--------------------------------------------------------------------------------------
            // OpenGL 1.0 (Core Profile)
            //--------------------------------------------------------------------------------------
            vendor = VENDOR,
            renderer = RENDERER,
            version = VERSION,
            extensions = EXTENSIONS,
            //--------------------------------------------------------------------------------------
            // OpenGL 2.0 (Core Profile)
            //--------------------------------------------------------------------------------------
            shading_language_version = SHADING_LANGUAGE_VERSION,
        };

        pub const ParamName = meta.mergeEnums(.{
            enum(Enum) {
                //--------------------------------------------------------------------------------------
                // OpenGL 1.0 (Core Profile)
                //--------------------------------------------------------------------------------------
                cull_face = CULL_FACE,
                polygon_smooth = POLYGON_SMOOTH,
                line_smooth = LINE_SMOOTH,
                dither = DITHER,
                blend = BLEND,
                color_writemask = COLOR_WRITEMASK,
                depth_test = DEPTH_TEST,
                depth_writemask = DEPTH_WRITEMASK,
                stencil_test = STENCIL_TEST,
                doublebuffer = DOUBLEBUFFER,
                stereo = STEREO,
                scissor_test = SCISSOR_TEST,
                polygon_mode = POLYGON_MODE,
                polygon_smooth_hint = POLYGON_SMOOTH_HINT,
                line_smooth_hint = LINE_SMOOTH_HINT,
                logic_op_mode = LOGIC_OP_MODE,
                color_clear_value = COLOR_CLEAR_VALUE,
                depth_clear_value = DEPTH_CLEAR_VALUE,
                depth_func = DEPTH_FUNC,
                depth_range = DEPTH_RANGE,
                stencil_clear_value = STENCIL_CLEAR_VALUE,
                stencil_fail = STENCIL_FAIL,
                stencil_func = STENCIL_FUNC,
                stencil_pass_depth_fail = STENCIL_PASS_DEPTH_FAIL,
                stencil_pass_depth_pass = STENCIL_PASS_DEPTH_PASS,
                stencil_ref = STENCIL_REF,
                stencil_value_mask = STENCIL_VALUE_MASK,
                stencil_writemask = STENCIL_WRITEMASK,
                viewport = VIEWPORT,
                subpixel_bits = SUBPIXEL_BITS,
                draw_buffer = DRAW_BUFFER,
                read_buffer = READ_BUFFER,
                scissor_box = SCISSOR_BOX,
                pack_alignment = PACK_ALIGNMENT,
                pack_lsb_first = PACK_LSB_FIRST,
                pack_row_length = PACK_ROW_LENGTH,
                pack_skip_pixels = PACK_SKIP_PIXELS,
                pack_skip_rows = PACK_SKIP_ROWS,
                pack_swap_bytes = PACK_SWAP_BYTES,
                unpack_alignment = UNPACK_ALIGNMENT,
                unpack_lsb_first = UNPACK_LSB_FIRST,
                unpack_row_length = UNPACK_ROW_LENGTH,
                unpack_skip_pixels = UNPACK_SKIP_PIXELS,
                unpack_skip_rows = UNPACK_SKIP_ROWS,
                unpack_swap_bytes = UNPACK_SWAP_BYTES,
                max_texture_size = MAX_TEXTURE_SIZE,
                max_viewport_dims = MAX_VIEWPORT_DIMS,
                point_size = POINT_SIZE,
                point_size_granularity = POINT_SIZE_GRANULARITY,
                point_size_range = POINT_SIZE_RANGE,
                line_width = LINE_WIDTH,
                //--------------------------------------------------------------------------------------
                // OpenGL 1.1 (Core Profile)
                //--------------------------------------------------------------------------------------
                polygon_offset_fill = POLYGON_OFFSET_FILL,
                polygon_offset_line = POLYGON_OFFSET_LINE,
                polygon_offset_point = POLYGON_OFFSET_POINT,
                color_logic_op = COLOR_LOGIC_OP,
                texture_binding_1d = TEXTURE_BINDING_1D,
                texture_binding_2d = TEXTURE_BINDING_2D,
                polygon_offset_factor = POLYGON_OFFSET_FACTOR,
                polygon_offset_units = POLYGON_OFFSET_UNITS,
                //--------------------------------------------------------------------------------------
                // OpenGL 1.2 (Core Profile)
                //--------------------------------------------------------------------------------------
                pack_image_height = PACK_IMAGE_HEIGHT,
                pack_skip_images = PACK_SKIP_IMAGES,
                unpack_image_height = UNPACK_IMAGE_HEIGHT,
                unpack_skip_images = UNPACK_SKIP_IMAGES,
                texture_binding_3d = TEXTURE_BINDING_3D,
                max_3d_texture_size = MAX_3D_TEXTURE_SIZE,
                max_elements_indices = MAX_ELEMENTS_INDICES,
                max_elements_vertices = MAX_ELEMENTS_VERTICES,
                aliased_line_width_range = ALIASED_LINE_WIDTH_RANGE,
                smooth_line_width_granularity = SMOOTH_LINE_WIDTH_GRANULARITY,
                smooth_line_width_range = SMOOTH_LINE_WIDTH_RANGE,
                //--------------------------------------------------------------------------------------
                // OpenGL 1.3 (Core Profile)
                //--------------------------------------------------------------------------------------
                sample_coverage_invert = SAMPLE_COVERAGE_INVERT,
                active_texture = ACTIVE_TEXTURE,
                texture_binding_cube_map = TEXTURE_BINDING_CUBE_MAP,
                texture_compression_hint = TEXTURE_COMPRESSION_HINT,
                compressed_texture_formats = COMPRESSED_TEXTURE_FORMATS,
                samples = SAMPLES,
                sample_buffers = SAMPLE_BUFFERS,
                num_compressed_texture_formats = NUM_COMPRESSED_TEXTURE_FORMATS,
                max_cube_map_texture_size = MAX_CUBE_MAP_TEXTURE_SIZE,
                sample_coverage_value = SAMPLE_COVERAGE_VALUE,
                //--------------------------------------------------------------------------------------
                // OpenGL 1.4 (Core Profile)
                //--------------------------------------------------------------------------------------
                blend_src_rgb = BLEND_SRC_RGB,
                blend_src_alpha = BLEND_SRC_ALPHA,
                blend_dst_rgb = BLEND_DST_RGB,
                blend_dst_alpha = BLEND_DST_ALPHA,
                blend_color = BLEND_COLOR,
                point_fade_threshold_size = POINT_FADE_THRESHOLD_SIZE,
                max_texture_lod_bias = MAX_TEXTURE_LOD_BIAS,
                //--------------------------------------------------------------------------------------
                // OpenGL 1.5 (Core Profile)
                //--------------------------------------------------------------------------------------
                array_buffer_binding = ARRAY_BUFFER_BINDING,
                element_array_buffer_binding = ELEMENT_ARRAY_BUFFER_BINDING,
                //--------------------------------------------------------------------------------------
                // OpenGL 2.0 (Core Profile)
                //--------------------------------------------------------------------------------------
                current_program = CURRENT_PROGRAM,
                blend_equation_rgb = BLEND_EQUATION_RGB,
                blend_equation_alpha = BLEND_EQUATION_ALPHA,
                stencil_back_fail = STENCIL_BACK_FAIL,
                stencil_back_func = STENCIL_BACK_FUNC,
                stencil_back_pass_depth_fail = STENCIL_BACK_PASS_DEPTH_FAIL,
                stencil_back_pass_depth_pass = STENCIL_BACK_PASS_DEPTH_PASS,
                stencil_back_ref = STENCIL_BACK_REF,
                stencil_back_value_mask = STENCIL_BACK_VALUE_MASK,
                stencil_back_writemask = STENCIL_BACK_WRITEMASK,
                draw_buffer0 = DRAW_BUFFER0,
                draw_buffer1 = DRAW_BUFFER1,
                draw_buffer2 = DRAW_BUFFER2,
                draw_buffer3 = DRAW_BUFFER3,
                draw_buffer4 = DRAW_BUFFER4,
                draw_buffer5 = DRAW_BUFFER5,
                draw_buffer6 = DRAW_BUFFER6,
                draw_buffer7 = DRAW_BUFFER7,
                draw_buffer8 = DRAW_BUFFER8,
                draw_buffer9 = DRAW_BUFFER9,
                draw_buffer10 = DRAW_BUFFER10,
                draw_buffer11 = DRAW_BUFFER11,
                draw_buffer12 = DRAW_BUFFER12,
                draw_buffer13 = DRAW_BUFFER13,
                draw_buffer14 = DRAW_BUFFER14,
                draw_buffer15 = DRAW_BUFFER15,
                draw_framebuffer_binding = DRAW_FRAMEBUFFER_BINDING,
                fragment_shader_derivative_hint = FRAGMENT_SHADER_DERIVATIVE_HINT,
                max_combined_texture_image_units = MAX_COMBINED_TEXTURE_IMAGE_UNITS,
                max_draw_buffers = MAX_DRAW_BUFFERS,
                max_fragment_uniform_components = MAX_FRAGMENT_UNIFORM_COMPONENTS,
                max_texture_image_units = MAX_TEXTURE_IMAGE_UNITS,
                //max_varying_floats = MAX_VARYING_FLOATS, // NOTE: MAX_VARYING_FLOATS is equal to MAX_VARYING_COMPONENTS
                max_vertex_attribs = MAX_VERTEX_ATTRIBS,
                max_vertex_texture_image_units = MAX_VERTEX_TEXTURE_IMAGE_UNITS,
                max_vertex_uniform_components = MAX_VERTEX_UNIFORM_COMPONENTS,
                //--------------------------------------------------------------------------------------
                // OpenGL 2.1 (Core Profile)
                //--------------------------------------------------------------------------------------
                pixel_pack_buffer_binding = PIXEL_PACK_BUFFER_BINDING,
                pixel_unpack_buffer_binding = PIXEL_UNPACK_BUFFER_BINDING,
                //--------------------------------------------------------------------------------------
                // OpenGL 3.0 (Core Profile)
                //--------------------------------------------------------------------------------------
                context_flags = CONTEXT_FLAGS,
                major_version = MAJOR_VERSION,
                minor_version = MINOR_VERSION,
                num_extensions = NUM_EXTENSIONS,
                texture_binding_1d_array = TEXTURE_BINDING_1D_ARRAY,
                texture_binding_2d_array = TEXTURE_BINDING_2D_ARRAY,
                transform_feedback_buffer_binding = TRANSFORM_FEEDBACK_BUFFER_BINDING,
                transform_feedback_buffer_size = TRANSFORM_FEEDBACK_BUFFER_SIZE,
                transform_feedback_buffer_start = TRANSFORM_FEEDBACK_BUFFER_START,
                vertex_array_binding = VERTEX_ARRAY_BINDING,
                read_framebuffer_binding = READ_FRAMEBUFFER_BINDING,
                renderbuffer_binding = RENDERBUFFER_BINDING,
                min_program_texel_offset = MIN_PROGRAM_TEXEL_OFFSET,
                max_array_texture_layers = MAX_ARRAY_TEXTURE_LAYERS,
                max_clip_distances = MAX_CLIP_DISTANCES,
                max_program_texel_offset = MAX_PROGRAM_TEXEL_OFFSET,
                max_renderbuffer_size = MAX_RENDERBUFFER_SIZE,
                max_varying_components = MAX_VARYING_COMPONENTS,
                //--------------------------------------------------------------------------------------
                // OpenGL 3.1 (Core Profile)
                //--------------------------------------------------------------------------------------
                primitive_restart_index = PRIMITIVE_RESTART_INDEX,
                texture_binding_buffer = TEXTURE_BINDING_BUFFER,
                texture_binding_rectangle = TEXTURE_BINDING_RECTANGLE,
                uniform_buffer_binding = UNIFORM_BUFFER_BINDING,
                uniform_buffer_offset_alignment = UNIFORM_BUFFER_OFFSET_ALIGNMENT,
                uniform_buffer_size = UNIFORM_BUFFER_SIZE,
                uniform_buffer_start = UNIFORM_BUFFER_START,
                max_combined_vertex_uniform_components = MAX_COMBINED_VERTEX_UNIFORM_COMPONENTS,
                max_combined_fragment_uniform_components = MAX_COMBINED_FRAGMENT_UNIFORM_COMPONENTS,
                max_combined_geometry_uniform_components = MAX_COMBINED_GEOMETRY_UNIFORM_COMPONENTS,
                max_combined_uniform_blocks = MAX_COMBINED_UNIFORM_BLOCKS,
                max_fragment_uniform_blocks = MAX_FRAGMENT_UNIFORM_BLOCKS,
                max_geometry_uniform_blocks = MAX_GEOMETRY_UNIFORM_BLOCKS,
                max_rectangle_texture_size = MAX_RECTANGLE_TEXTURE_SIZE,
                max_texture_buffer_size = MAX_TEXTURE_BUFFER_SIZE,
                max_uniform_block_size = MAX_UNIFORM_BLOCK_SIZE,
                max_uniform_buffer_bindings = MAX_UNIFORM_BUFFER_BINDINGS,
                max_vertex_uniform_blocks = MAX_VERTEX_UNIFORM_BLOCKS,
                //--------------------------------------------------------------------------------------
                // OpenGL 3.2 (Core Profile)
                //--------------------------------------------------------------------------------------
                program_point_size = PROGRAM_POINT_SIZE,
                provoking_vertex = PROVOKING_VERTEX,
                texture_binding_2d_multisample = TEXTURE_BINDING_2D_MULTISAMPLE,
                texture_binding_2d_multisample_array = TEXTURE_BINDING_2D_MULTISAMPLE_ARRAY,
                max_color_texture_samples = MAX_COLOR_TEXTURE_SAMPLES,
                max_depth_texture_samples = MAX_DEPTH_TEXTURE_SAMPLES,
                max_fragment_input_components = MAX_FRAGMENT_INPUT_COMPONENTS,
                max_geometry_input_components = MAX_GEOMETRY_INPUT_COMPONENTS,
                max_geometry_output_components = MAX_GEOMETRY_OUTPUT_COMPONENTS,
                max_geometry_texture_image_units = MAX_GEOMETRY_TEXTURE_IMAGE_UNITS,
                max_geometry_uniform_components = MAX_GEOMETRY_UNIFORM_COMPONENTS,
                max_integer_samples = MAX_INTEGER_SAMPLES,
                max_sample_mask_words = MAX_SAMPLE_MASK_WORDS,
                max_server_wait_timeout = MAX_SERVER_WAIT_TIMEOUT,
                max_vertex_output_components = MAX_VERTEX_OUTPUT_COMPONENTS,
                //--------------------------------------------------------------------------------------
                // OpenGL 3.3 (Core Profile)
                //--------------------------------------------------------------------------------------
                max_dual_source_draw_buffers = MAX_DUAL_SOURCE_DRAW_BUFFERS,
                sampler_binding = SAMPLER_BINDING,
                timestamp = TIMESTAMP,
                //--------------------------------------------------------------------------------------
                // OpenGL 4.1 (Core Profile)
                //--------------------------------------------------------------------------------------
                shader_compiler = SHADER_COMPILER,
                shader_binary_formats = SHADER_BINARY_FORMATS,
                num_shader_binary_formats = NUM_SHADER_BINARY_FORMATS,
                max_vertex_uniform_vectors = MAX_VERTEX_UNIFORM_VECTORS,
                max_varying_vectors = MAX_VARYING_VECTORS,
                max_fragment_uniform_vectors = MAX_FRAGMENT_UNIFORM_VECTORS,
                implementation_color_read_type = IMPLEMENTATION_COLOR_READ_TYPE,
                implementation_color_read_format = IMPLEMENTATION_COLOR_READ_FORMAT,
                num_program_binary_formats = NUM_PROGRAM_BINARY_FORMATS,
                program_binary_formats = PROGRAM_BINARY_FORMATS,
                program_pipeline_binding = PROGRAM_PIPELINE_BINDING,
                max_viewports = MAX_VIEWPORTS,
                viewport_subpixel_bits = VIEWPORT_SUBPIXEL_BITS,
                viewport_bounds_range = VIEWPORT_BOUNDS_RANGE,
                layer_provoking_vertex = LAYER_PROVOKING_VERTEX,
                viewport_index_provoking_vertex = VIEWPORT_INDEX_PROVOKING_VERTEX,
            },
            CompressedTexturePixelStorage,
        });

        pub const Func = enum(Enum) {
            never = NEVER,
            less = LESS,
            equal = EQUAL,
            lequal = LEQUAL,
            greater = GREATER,
            notequal = NOTEQUAL,
            gequal = GEQUAL,
            always = ALWAYS,
        };

        pub const StencilAction = enum(Enum) {
            //--------------------------------------------------------------------------------------
            // OpenGL 1.0 (Core Profile)
            //--------------------------------------------------------------------------------------
            keep = KEEP,
            zero = ZERO,
            replace = REPLACE,
            incr = INCR,
            decr = DECR,
            //--------------------------------------------------------------------------------------
            // OpenGL 1.4 (Core Profile)
            //--------------------------------------------------------------------------------------
            incr_wrap = INCR_WRAP,
            decr_wrap = DECR_WRAP,
        };

        pub const BlendFactor = enum(Enum) {
            //--------------------------------------------------------------------------------------
            // OpenGL 1.0 (Core Profile)
            //--------------------------------------------------------------------------------------
            zero = ZERO,
            one = ONE,
            src_color = SRC_COLOR,
            one_minus_src_color = ONE_MINUS_SRC_COLOR,
            dst_color = DST_COLOR,
            one_minus_dst_color = ONE_MINUS_DST_COLOR,
            src_alpha = SRC_ALPHA,
            one_minus_src_alpha = ONE_MINUS_SRC_ALPHA,
            dst_alpha = DST_ALPHA,
            one_minus_dst_alpha = ONE_MINUS_DST_ALPHA,
            /// can only be used for 'sfactor'/'src' color and alpha parameters, before OpenGL 3.3
            src_alpha_saturate = SRC_ALPHA_SATURATE,
            //--------------------------------------------------------------------------------------
            // OpenGL 1.2 (Core Profile)
            //--------------------------------------------------------------------------------------
            constant_color = CONSTANT_COLOR,
            one_minus_constant_color = ONE_MINUS_CONSTANT_COLOR,
            constant_alpha = CONSTANT_ALPHA,
            one_minus_constant_alpha = ONE_MINUS_CONSTANT_ALPHA,
            //--------------------------------------------------------------------------------------
            // OpenGL 3.3 (Core Profile)
            //--------------------------------------------------------------------------------------
            src1_color = SRC1_COLOR,
            one_minus_src1_color = ONE_MINUS_SRC1_COLOR,
            src1_alpha = SRC1_ALPHA,
            one_minus_src1_alpha = ONE_MINUS_SRC1_ALPHA,
        };

        pub const ColorBuffer = enum(Enum) {
            //--------------------------------------------------------------------------------------
            // OpenGL 1.0 (Core Profile)
            //--------------------------------------------------------------------------------------
            none = NONE,
            front_left = FRONT_LEFT,
            front_right = FRONT_RIGHT,
            back_left = BACK_LEFT,
            back_right = BACK_RIGHT,
            front = FRONT,
            back = BACK,
            left = LEFT,
            right = RIGHT,
            front_and_back = FRONT_AND_BACK,
            //--------------------------------------------------------------------------------------
            // OpenGL 3.0 (Core Profile)
            //--------------------------------------------------------------------------------------
            color_attachment0 = COLOR_ATTACHMENT0,
            color_attachment1 = COLOR_ATTACHMENT1,
            color_attachment2 = COLOR_ATTACHMENT2,
            color_attachment3 = COLOR_ATTACHMENT3,
            color_attachment4 = COLOR_ATTACHMENT4,
            color_attachment5 = COLOR_ATTACHMENT5,
            color_attachment6 = COLOR_ATTACHMENT6,
            color_attachment7 = COLOR_ATTACHMENT7,
            color_attachment8 = COLOR_ATTACHMENT8,
            color_attachment9 = COLOR_ATTACHMENT9,
            color_attachment10 = COLOR_ATTACHMENT10,
            color_attachment11 = COLOR_ATTACHMENT11,
            color_attachment12 = COLOR_ATTACHMENT12,
            color_attachment13 = COLOR_ATTACHMENT13,
            color_attachment14 = COLOR_ATTACHMENT14,
            color_attachment15 = COLOR_ATTACHMENT15,
            color_attachment16 = COLOR_ATTACHMENT16,
            color_attachment17 = COLOR_ATTACHMENT17,
            color_attachment18 = COLOR_ATTACHMENT18,
            color_attachment19 = COLOR_ATTACHMENT19,
            color_attachment20 = COLOR_ATTACHMENT20,
            color_attachment21 = COLOR_ATTACHMENT21,
            color_attachment22 = COLOR_ATTACHMENT22,
            color_attachment23 = COLOR_ATTACHMENT23,
            color_attachment24 = COLOR_ATTACHMENT24,
            color_attachment25 = COLOR_ATTACHMENT25,
            color_attachment26 = COLOR_ATTACHMENT26,
            color_attachment27 = COLOR_ATTACHMENT27,
            color_attachment28 = COLOR_ATTACHMENT28,
            color_attachment29 = COLOR_ATTACHMENT29,
            color_attachment30 = COLOR_ATTACHMENT30,
            color_attachment31 = COLOR_ATTACHMENT31,
        };

        pub const ColorBufferSingle = enum(Enum) {
            //--------------------------------------------------------------------------------------
            // OpenGL 1.0 (Core Profile)
            //--------------------------------------------------------------------------------------
            none = NONE,
            front_left = FRONT_LEFT,
            front_right = FRONT_RIGHT,
            back_left = BACK_LEFT,
            back_right = BACK_RIGHT,
            //--------------------------------------------------------------------------------------
            // OpenGL 3.0 (Core Profile)
            //--------------------------------------------------------------------------------------
            color_attachment0 = COLOR_ATTACHMENT0,
            color_attachment1 = COLOR_ATTACHMENT1,
            color_attachment2 = COLOR_ATTACHMENT2,
            color_attachment3 = COLOR_ATTACHMENT3,
            color_attachment4 = COLOR_ATTACHMENT4,
            color_attachment5 = COLOR_ATTACHMENT5,
            color_attachment6 = COLOR_ATTACHMENT6,
            color_attachment7 = COLOR_ATTACHMENT7,
            color_attachment8 = COLOR_ATTACHMENT8,
            color_attachment9 = COLOR_ATTACHMENT9,
            color_attachment10 = COLOR_ATTACHMENT10,
            color_attachment11 = COLOR_ATTACHMENT11,
            color_attachment12 = COLOR_ATTACHMENT12,
            color_attachment13 = COLOR_ATTACHMENT13,
            color_attachment14 = COLOR_ATTACHMENT14,
            color_attachment15 = COLOR_ATTACHMENT15,
            color_attachment16 = COLOR_ATTACHMENT16,
            color_attachment17 = COLOR_ATTACHMENT17,
            color_attachment18 = COLOR_ATTACHMENT18,
            color_attachment19 = COLOR_ATTACHMENT19,
            color_attachment20 = COLOR_ATTACHMENT20,
            color_attachment21 = COLOR_ATTACHMENT21,
            color_attachment22 = COLOR_ATTACHMENT22,
            color_attachment23 = COLOR_ATTACHMENT23,
            color_attachment24 = COLOR_ATTACHMENT24,
            color_attachment25 = COLOR_ATTACHMENT25,
            color_attachment26 = COLOR_ATTACHMENT26,
            color_attachment27 = COLOR_ATTACHMENT27,
            color_attachment28 = COLOR_ATTACHMENT28,
            color_attachment29 = COLOR_ATTACHMENT29,
            color_attachment30 = COLOR_ATTACHMENT30,
            color_attachment31 = COLOR_ATTACHMENT31,
        };

        pub const ColorMask = packed struct(Bitfield) {
            //--------------------------------------------------------------------------------------
            // OpenGL 1.0 (Core Profile)
            //--------------------------------------------------------------------------------------
            // DEPTH_BUFFER_BIT   = 0x00000100 // 9th bit
            // STENCIL_BUFFER_BIT = 0x00000400 // 11th bit
            // COLOR_BUFFER_BIT   = 0x00004000 // 15th bit

            /// DO NOT WRITE
            pad1: u8 = 0,
            depth: bool = false,
            /// DO NOT WRITE
            pad2: u1 = 0,
            stencil: bool = false,
            /// DO NOT WRITE
            pad3: u3 = 0,
            color: bool = false,
            /// DO NOT WRITE
            pad4: u17 = 0,

            comptime {
                assert(@as(Bitfield, @bitCast(ColorMask{ .depth = true })) == DEPTH_BUFFER_BIT);
                assert(@as(Bitfield, @bitCast(ColorMask{ .stencil = true })) == STENCIL_BUFFER_BIT);
                assert(@as(Bitfield, @bitCast(ColorMask{ .color = true })) == COLOR_BUFFER_BIT);
            }
        };

        const DrawIndicesType = enum(Enum) {
            //--------------------------------------------------------------------------------------
            // OpenGL 1.1 (Core Profile)
            //--------------------------------------------------------------------------------------
            unsigned_byte = UNSIGNED_BYTE,
            unsigned_short = UNSIGNED_SHORT,
            unsigned_int = UNSIGNED_INT,
        };

        pub const FramebufferTarget = enum(Enum) {
            //--------------------------------------------------------------------------------------
            // OpenGL 3.0 (Core Profile)
            //--------------------------------------------------------------------------------------
            framebuffer = FRAMEBUFFER,
            draw_framebuffer = DRAW_FRAMEBUFFER,
            read_framebuffer = READ_FRAMEBUFFER,
        };

        pub const FramebufferAttachment = enum(Enum) {
            //--------------------------------------------------------------------------------------
            // OpenGL 3.0 (Core Profile)
            //--------------------------------------------------------------------------------------
            color_attachment0 = COLOR_ATTACHMENT0,
            color_attachment1 = COLOR_ATTACHMENT1,
            color_attachment2 = COLOR_ATTACHMENT2,
            color_attachment3 = COLOR_ATTACHMENT3,
            color_attachment4 = COLOR_ATTACHMENT4,
            color_attachment5 = COLOR_ATTACHMENT5,
            color_attachment6 = COLOR_ATTACHMENT6,
            color_attachment7 = COLOR_ATTACHMENT7,
            color_attachment8 = COLOR_ATTACHMENT8,
            color_attachment9 = COLOR_ATTACHMENT9,
            color_attachment10 = COLOR_ATTACHMENT10,
            color_attachment11 = COLOR_ATTACHMENT11,
            color_attachment12 = COLOR_ATTACHMENT12,
            color_attachment13 = COLOR_ATTACHMENT13,
            color_attachment14 = COLOR_ATTACHMENT14,
            color_attachment15 = COLOR_ATTACHMENT15,
            color_attachment16 = COLOR_ATTACHMENT16,
            color_attachment17 = COLOR_ATTACHMENT17,
            color_attachment18 = COLOR_ATTACHMENT18,
            color_attachment19 = COLOR_ATTACHMENT19,
            color_attachment20 = COLOR_ATTACHMENT20,
            color_attachment21 = COLOR_ATTACHMENT21,
            color_attachment22 = COLOR_ATTACHMENT22,
            color_attachment23 = COLOR_ATTACHMENT23,
            color_attachment24 = COLOR_ATTACHMENT24,
            color_attachment25 = COLOR_ATTACHMENT25,
            color_attachment26 = COLOR_ATTACHMENT26,
            color_attachment27 = COLOR_ATTACHMENT27,
            color_attachment28 = COLOR_ATTACHMENT28,
            color_attachment29 = COLOR_ATTACHMENT29,
            color_attachment30 = COLOR_ATTACHMENT30,
            color_attachment31 = COLOR_ATTACHMENT31,
            depth_attachment = DEPTH_ATTACHMENT,
            stencil_attachment = STENCIL_ATTACHMENT,
            depth_stencil_attachment = DEPTH_STENCIL_ATTACHMENT,
        };

        pub const FramebufferAttachmentDefault = enum(Enum) {
            //--------------------------------------------------------------------------------------
            // OpenGL 1.0 (Core Profile)
            //--------------------------------------------------------------------------------------
            front_left = FRONT_LEFT,
            front_right = FRONT_RIGHT,
            back_left = BACK_LEFT,
            back_right = BACK_RIGHT,
            depth = DEPTH,
            stencil = STENCIL,
            //--------------------------------------------------------------------------------------
            // OpenGL 3.0 (Core Profile)
            //--------------------------------------------------------------------------------------
            color_attachment0 = COLOR_ATTACHMENT0,
            color_attachment1 = COLOR_ATTACHMENT1,
            color_attachment2 = COLOR_ATTACHMENT2,
            color_attachment3 = COLOR_ATTACHMENT3,
            color_attachment4 = COLOR_ATTACHMENT4,
            color_attachment5 = COLOR_ATTACHMENT5,
            color_attachment6 = COLOR_ATTACHMENT6,
            color_attachment7 = COLOR_ATTACHMENT7,
            color_attachment8 = COLOR_ATTACHMENT8,
            color_attachment9 = COLOR_ATTACHMENT9,
            color_attachment10 = COLOR_ATTACHMENT10,
            color_attachment11 = COLOR_ATTACHMENT11,
            color_attachment12 = COLOR_ATTACHMENT12,
            color_attachment13 = COLOR_ATTACHMENT13,
            color_attachment14 = COLOR_ATTACHMENT14,
            color_attachment15 = COLOR_ATTACHMENT15,
            color_attachment16 = COLOR_ATTACHMENT16,
            color_attachment17 = COLOR_ATTACHMENT17,
            color_attachment18 = COLOR_ATTACHMENT18,
            color_attachment19 = COLOR_ATTACHMENT19,
            color_attachment20 = COLOR_ATTACHMENT20,
            color_attachment21 = COLOR_ATTACHMENT21,
            color_attachment22 = COLOR_ATTACHMENT22,
            color_attachment23 = COLOR_ATTACHMENT23,
            color_attachment24 = COLOR_ATTACHMENT24,
            color_attachment25 = COLOR_ATTACHMENT25,
            color_attachment26 = COLOR_ATTACHMENT26,
            color_attachment27 = COLOR_ATTACHMENT27,
            color_attachment28 = COLOR_ATTACHMENT28,
            color_attachment29 = COLOR_ATTACHMENT29,
            color_attachment30 = COLOR_ATTACHMENT30,
            color_attachment31 = COLOR_ATTACHMENT31,
            depth_attachment = DEPTH_ATTACHMENT,
            stencil_attachment = STENCIL_ATTACHMENT,
            depth_stencil_attachment = DEPTH_STENCIL_ATTACHMENT,
        };

        pub const FramebufferAttachmentParameter = enum(Enum) {
            //--------------------------------------------------------------------------------------
            // OpenGL 3.0 (Core Profile)
            //--------------------------------------------------------------------------------------
            color_encoding = FRAMEBUFFER_ATTACHMENT_COLOR_ENCODING,
            component_type = FRAMEBUFFER_ATTACHMENT_COMPONENT_TYPE,
            red_size = FRAMEBUFFER_ATTACHMENT_RED_SIZE,
            green_size = FRAMEBUFFER_ATTACHMENT_GREEN_SIZE,
            blue_size = FRAMEBUFFER_ATTACHMENT_BLUE_SIZE,
            alpha_size = FRAMEBUFFER_ATTACHMENT_ALPHA_SIZE,
            depth_size = FRAMEBUFFER_ATTACHMENT_DEPTH_SIZE,
            stencil_size = FRAMEBUFFER_ATTACHMENT_STENCIL_SIZE,
            object_type = FRAMEBUFFER_ATTACHMENT_OBJECT_TYPE,
            object_name = FRAMEBUFFER_ATTACHMENT_OBJECT_NAME,
            texture_level = FRAMEBUFFER_ATTACHMENT_TEXTURE_LEVEL,
            texture_cube_map_face = FRAMEBUFFER_ATTACHMENT_TEXTURE_CUBE_MAP_FACE,
            texture_layer = FRAMEBUFFER_ATTACHMENT_TEXTURE_LAYER,
            //--------------------------------------------------------------------------------------
            // OpenGL 3.2 (Core Profile)
            //--------------------------------------------------------------------------------------
            layered = FRAMEBUFFER_ATTACHMENT_LAYERED,
        };

        pub const RenderbufferTarget = enum(Enum) {
            //--------------------------------------------------------------------------------------
            // OpenGL 3.0 (Core Profile)
            //--------------------------------------------------------------------------------------
            renderbuffer = RENDERBUFFER,
        };

        pub const FramebufferStatus = enum(Enum) {
            //--------------------------------------------------------------------------------------
            // OpenGL 3.0 (Core Profile)
            //--------------------------------------------------------------------------------------
            complete = FRAMEBUFFER_COMPLETE,
            incomplete_attachment = FRAMEBUFFER_INCOMPLETE_ATTACHMENT,
            incomplete_missing_attachment = FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT,
            incomplete_draw_buffer = FRAMEBUFFER_INCOMPLETE_DRAW_BUFFER,
            incomplete_read_buffer = FRAMEBUFFER_INCOMPLETE_READ_BUFFER,
            unsupported = FRAMEBUFFER_UNSUPPORTED,
            incomplete_multisample = FRAMEBUFFER_INCOMPLETE_MULTISAMPLE,
            //--------------------------------------------------------------------------------------
            // OpenGL 3.2 (Core Profile)
            //--------------------------------------------------------------------------------------
            incomplete_layer_targets = FRAMEBUFFER_INCOMPLETE_LAYER_TARGETS,
            //--------------------------------------------------------------------------------------
            // OpenGL ES 2
            //--------------------------------------------------------------------------------------
            incomplete_dimensions = FRAMEBUFFER_INCOMPLETE_DIMENSIONS,
        };

        pub const BlendEquation = enum(Enum) {
            //--------------------------------------------------------------------------------------
            // OpenGL 1.4 (Core Profile)
            //--------------------------------------------------------------------------------------
            func_add = FUNC_ADD,
            func_subtract = FUNC_SUBTRACT,
            func_reverse_subtract = FUNC_REVERSE_SUBTRACT,
            min = MIN,
            max = MAX,
        };

        pub const ShaderType = enum(Enum) {
            //--------------------------------------------------------------------------------------
            // OpenGL 2.0 (Core Profile)
            //--------------------------------------------------------------------------------------
            vertex = VERTEX_SHADER,
            fragment = FRAGMENT_SHADER,
            //--------------------------------------------------------------------------------------
            // OpenGL 3.2 (Core Profile)
            //--------------------------------------------------------------------------------------
            geometry = GEOMETRY_SHADER,
            //--------------------------------------------------------------------------------------
            // OpenGL 4.0 (Core Profile)
            //--------------------------------------------------------------------------------------
            tess_control = TESS_CONTROL_SHADER,
            tess_evaluation = TESS_EVALUATION_SHADER,
            //--------------------------------------------------------------------------------------
            // OpenGL 4.3 (Core Profile)
            //--------------------------------------------------------------------------------------
            compute = COMPUTE_SHADER,
        };

        pub const ShaderTypeBasic = enum(Enum) {
            //--------------------------------------------------------------------------------------
            // OpenGL 2.0 (Core Profile)
            //--------------------------------------------------------------------------------------
            vertex = VERTEX_SHADER,
            fragment = FRAGMENT_SHADER,
        };

        pub const ProgramParameter = enum(Enum) {
            //----------------------------------------------------------------------------------
            // OpenGL 2.0 (Core Profile)
            //----------------------------------------------------------------------------------
            delete_status = DELETE_STATUS,
            link_status = LINK_STATUS,
            validate_status = VALIDATE_STATUS,
            info_log_length = INFO_LOG_LENGTH,
            attached_shaders = ATTACHED_SHADERS,
            active_attributes = ACTIVE_ATTRIBUTES,
            active_attribute_max_length = ACTIVE_ATTRIBUTE_MAX_LENGTH,
            active_uniforms = ACTIVE_UNIFORMS,
            active_uniform_blocks = ACTIVE_UNIFORM_BLOCKS,
            active_uniform_block_max_name_length = ACTIVE_UNIFORM_BLOCK_MAX_NAME_LENGTH,
            active_uniform_max_length = ACTIVE_UNIFORM_MAX_LENGTH,
            //----------------------------------------------------------------------------------
            // OpenGL 3.0 (Core Profile)
            //----------------------------------------------------------------------------------
            transform_feedback_buffer_mode = TRANSFORM_FEEDBACK_BUFFER_MODE,
            transform_feedback_varyings = TRANSFORM_FEEDBACK_VARYINGS,
            transform_feedback_varying_max_length = TRANSFORM_FEEDBACK_VARYING_MAX_LENGTH,
            //----------------------------------------------------------------------------------
            // OpenGL 3.2 (Core Profile)
            //----------------------------------------------------------------------------------
            geometry_vertices_out = GEOMETRY_VERTICES_OUT,
            geometry_input_type = GEOMETRY_INPUT_TYPE,
            geometry_output_type = GEOMETRY_OUTPUT_TYPE,
            //----------------------------------------------------------------------------------
            // OpenGL 4.1 (Core Profile)
            //----------------------------------------------------------------------------------
            program_binary_length = PROGRAM_BINARY_LENGTH,
            program_separable = PROGRAM_SEPARABLE,
            program_binary_retrievable_hint = PROGRAM_BINARY_RETRIEVABLE_HINT,
        };

        pub const ShaderParameter = enum(Enum) {
            //--------------------------------------------------------------------------------------
            // OpenGL 2.0 (Core Profile)
            //--------------------------------------------------------------------------------------
            shader_type = SHADER_TYPE,
            delete_status = DELETE_STATUS,
            compile_status = COMPILE_STATUS,
            info_log_length = INFO_LOG_LENGTH,
            shader_source_length = SHADER_SOURCE_LENGTH,
        };

        pub const AttribType = enum(Enum) {
            //--------------------------------------------------------------------------------------
            // OpenGL 2.0 (Core Profile)
            //--------------------------------------------------------------------------------------
            float = FLOAT,
            float_vec2 = FLOAT_VEC2,
            float_vec3 = FLOAT_VEC3,
            float_vec4 = FLOAT_VEC4,
            float_mat2 = FLOAT_MAT2,
            float_mat3 = FLOAT_MAT3,
            float_mat4 = FLOAT_MAT4,
            //--------------------------------------------------------------------------------------
            // OpenGL 2.1 (Core Profile)
            //--------------------------------------------------------------------------------------
            float_mat2x3 = FLOAT_MAT2x3,
            float_mat2x4 = FLOAT_MAT2x4,
            float_mat3x2 = FLOAT_MAT3x2,
            float_mat3x4 = FLOAT_MAT3x4,
            float_mat4x2 = FLOAT_MAT4x2,
            float_mat4x3 = FLOAT_MAT4x3,
            //--------------------------------------------------------------------------------------
            // OpenGL 3.0 (Core Profile)
            //--------------------------------------------------------------------------------------
            int = INT,
            int_vec2 = INT_VEC2,
            int_vec3 = INT_VEC3,
            int_vec4 = INT_VEC4,
            unsigned_int = UNSIGNED_INT,
            unsigned_int_vec2 = UNSIGNED_INT_VEC2,
            unsigned_int_vec3 = UNSIGNED_INT_VEC3,
            unsigned_int_vec4 = UNSIGNED_INT_VEC4,
            //--------------------------------------------------------------------------------------
            // OpenGL 4.1 (Core Profile)
            //--------------------------------------------------------------------------------------
            double = DOUBLE,
            double_vec2 = DOUBLE_VEC2,
            double_vec3 = DOUBLE_VEC3,
            double_vec4 = DOUBLE_VEC4,
            double_mat2 = DOUBLE_MAT2,
            double_mat3 = DOUBLE_MAT3,
            double_mat4 = DOUBLE_MAT4,
            double_mat2x3 = DOUBLE_MAT2x3,
            double_mat2x4 = DOUBLE_MAT2x4,
            double_mat3x2 = DOUBLE_MAT3x2,
            double_mat3x4 = DOUBLE_MAT3x4,
            double_mat4x2 = DOUBLE_MAT4x2,
            double_mat4x3 = DOUBLE_MAT4x3,
        };

        pub const UniformType = enum(Enum) {
            //--------------------------------------------------------------------------------------
            // OpenGL 2.0 (Core Profile)
            //--------------------------------------------------------------------------------------
            float = FLOAT,
            float_vec2 = FLOAT_VEC2,
            float_vec3 = FLOAT_VEC3,
            float_vec4 = FLOAT_VEC4,
            int = INT,
            int_vec2 = INT_VEC2,
            int_vec3 = INT_VEC3,
            int_vec4 = INT_VEC4,
            bool = BOOL,
            bool_vec2 = BOOL_VEC2,
            bool_vec3 = BOOL_VEC3,
            bool_vec4 = BOOL_VEC4,
            float_mat2 = FLOAT_MAT2,
            float_mat3 = FLOAT_MAT3,
            float_mat4 = FLOAT_MAT4,
            sampler_1d = SAMPLER_1D,
            sampler_2d = SAMPLER_2D,
            sampler_3d = SAMPLER_3D,
            sampler_cube = SAMPLER_CUBE,
            sampler_1d_shadow = SAMPLER_1D_SHADOW,
            sampler_2d_shadow = SAMPLER_2D_SHADOW,
            //--------------------------------------------------------------------------------------
            // OpenGL 2.1 (Core Profile)
            //--------------------------------------------------------------------------------------
            float_mat2x3 = FLOAT_MAT2x3,
            float_mat2x4 = FLOAT_MAT2x4,
            float_mat3x2 = FLOAT_MAT3x2,
            float_mat3x4 = FLOAT_MAT3x4,
            float_mat4x2 = FLOAT_MAT4x2,
            float_mat4x3 = FLOAT_MAT4x3,
            //--------------------------------------------------------------------------------------
            // OpenGL 3.0 (Core Profile)
            //--------------------------------------------------------------------------------------
            sampler_1d_array = SAMPLER_1D_ARRAY,
            sampler_2d_array = SAMPLER_2D_ARRAY,
            sampler_1d_array_shadow = SAMPLER_1D_ARRAY_SHADOW,
            sampler_2d_array_shadow = SAMPLER_2D_ARRAY_SHADOW,
            sampler_cube_shadow = SAMPLER_CUBE_SHADOW,
            int_sampler_1d = INT_SAMPLER_1D,
            int_sampler_2d = INT_SAMPLER_2D,
            int_sampler_3d = INT_SAMPLER_3D,
            int_sampler_cube = INT_SAMPLER_CUBE,
            int_sampler_1d_array = INT_SAMPLER_1D_ARRAY,
            int_sampler_2d_array = INT_SAMPLER_2D_ARRAY,
            unsigned_int = UNSIGNED_INT,
            unsigned_int_vec2 = UNSIGNED_INT_VEC2,
            unsigned_int_vec3 = UNSIGNED_INT_VEC3,
            unsigned_int_vec4 = UNSIGNED_INT_VEC4,
            unsigned_int_sampler_1d = UNSIGNED_INT_SAMPLER_1D,
            unsigned_int_sampler_2d = UNSIGNED_INT_SAMPLER_2D,
            unsigned_int_sampler_3d = UNSIGNED_INT_SAMPLER_3D,
            unsigned_int_sampler_1d_array = UNSIGNED_INT_SAMPLER_1D_ARRAY,
            unsigned_int_sampler_2d_array = UNSIGNED_INT_SAMPLER_2D_ARRAY,
            unsigned_int_sampler_cube = UNSIGNED_INT_SAMPLER_CUBE,
            //--------------------------------------------------------------------------------------
            // OpenGL 3.1 (Core Profile)
            //--------------------------------------------------------------------------------------
            sampler_2d_rect = SAMPLER_2D_RECT,
            sampler_2d_rect_shadow = SAMPLER_2D_RECT_SHADOW,
            //--------------------------------------------------------------------------------------
            // OpenGL 3.2 (Core Profile)
            //--------------------------------------------------------------------------------------
            sampler_2d_multisample = SAMPLER_2D_MULTISAMPLE,
            sampler_2d_multisample_array = SAMPLER_2D_MULTISAMPLE_ARRAY,
            sampler_buffer = SAMPLER_BUFFER,
            int_sampler_2d_multisample = INT_SAMPLER_2D_MULTISAMPLE,
            int_sampler_2d_multisample_array = INT_SAMPLER_2D_MULTISAMPLE_ARRAY,
            int_sampler_buffer = INT_SAMPLER_BUFFER,
            int_sampler_2d_rect = INT_SAMPLER_2D_RECT,
            unsigned_int_sampler_2d_multisample = UNSIGNED_INT_SAMPLER_2D_MULTISAMPLE,
            unsigned_int_sampler_2d_multisample_array = UNSIGNED_INT_SAMPLER_2D_MULTISAMPLE_ARRAY,
            unsigned_int_sampler_buffer = UNSIGNED_INT_SAMPLER_BUFFER,
            unsigned_int_sampler_2d_rect = UNSIGNED_INT_SAMPLER_2D_RECT,
            //--------------------------------------------------------------------------------------
            // OpenGL 4.0 (Core Profile)
            //--------------------------------------------------------------------------------------
            double = DOUBLE,
            double_vec2 = DOUBLE_VEC2,
            double_vec3 = DOUBLE_VEC3,
            double_vec4 = DOUBLE_VEC4,
            double_mat2 = DOUBLE_MAT2,
            double_mat3 = DOUBLE_MAT3,
            double_mat4 = DOUBLE_MAT4,
            double_mat2x3 = DOUBLE_MAT2x3,
            double_mat2x4 = DOUBLE_MAT2x4,
            double_mat3x2 = DOUBLE_MAT3x2,
            double_mat3x4 = DOUBLE_MAT3x4,
            double_mat4x2 = DOUBLE_MAT4x2,
            double_mat4x3 = DOUBLE_MAT4x3,
            sampler_cube_map_array = SAMPLER_CUBE_MAP_ARRAY,
            sampler_cube_map_array_shadow = SAMPLER_CUBE_MAP_ARRAY_SHADOW,
            int_sampler_cube_map_array = INT_SAMPLER_CUBE_MAP_ARRAY,
            unsigned_int_sampler_cube_map_array = UNSIGNED_INT_SAMPLER_CUBE_MAP_ARRAY,
            //--------------------------------------------------------------------------------------
            // OpenGL 4.2 (Core Profile)
            //--------------------------------------------------------------------------------------
            image_1d = IMAGE_1D,
            image_2d = IMAGE_2D,
            image_3d = IMAGE_3D,
            image_2d_rect = IMAGE_2D_RECT,
            image_cube = IMAGE_CUBE,
            image_buffer = IMAGE_BUFFER,
            image_1d_array = IMAGE_1D_ARRAY,
            image_2d_array = IMAGE_2D_ARRAY,
            image_cube_map_array = IMAGE_CUBE_MAP_ARRAY,
            image_2d_multisample = IMAGE_2D_MULTISAMPLE,
            image_2d_multisample_array = IMAGE_2D_MULTISAMPLE_ARRAY,
            int_image_1d = INT_IMAGE_1D,
            int_image_2d = INT_IMAGE_2D,
            int_image_3d = INT_IMAGE_3D,
            int_image_2d_rect = INT_IMAGE_2D_RECT,
            int_image_cube = INT_IMAGE_CUBE,
            int_image_buffer = INT_IMAGE_BUFFER,
            int_image_1d_array = INT_IMAGE_1D_ARRAY,
            int_image_2d_array = INT_IMAGE_2D_ARRAY,
            int_image_cube_map_array = INT_IMAGE_CUBE_MAP_ARRAY,
            int_image_2d_multisample = INT_IMAGE_2D_MULTISAMPLE,
            int_image_2d_multisample_array = INT_IMAGE_2D_MULTISAMPLE_ARRAY,
            unsigned_int_image_1d = UNSIGNED_INT_IMAGE_1D,
            unsigned_int_image_2d = UNSIGNED_INT_IMAGE_2D,
            unsigned_int_image_3d = UNSIGNED_INT_IMAGE_3D,
            unsigned_int_image_2d_rect = UNSIGNED_INT_IMAGE_2D_RECT,
            unsigned_int_image_cube = UNSIGNED_INT_IMAGE_CUBE,
            unsigned_int_image_buffer = UNSIGNED_INT_IMAGE_BUFFER,
            unsigned_int_image_1d_array = UNSIGNED_INT_IMAGE_1D_ARRAY,
            unsigned_int_image_2d_array = UNSIGNED_INT_IMAGE_2D_ARRAY,
            unsigned_int_image_cube_map_array = UNSIGNED_INT_IMAGE_CUBE_MAP_ARRAY,
            unsigned_int_image_2d_multisample = UNSIGNED_INT_IMAGE_2D_MULTISAMPLE,
            unsigned_int_image_2d_multisample_array = UNSIGNED_INT_IMAGE_2D_MULTISAMPLE_ARRAY,
            unsigned_int_atomic_counter = UNSIGNED_INT_ATOMIC_COUNTER,
        };

        pub const VertexAttribParameter = enum(Enum) {
            //--------------------------------------------------------------------------------------
            // OpenGL 2.0 (Core Profile)
            //--------------------------------------------------------------------------------------
            vertex_attrib_array_enabled = VERTEX_ATTRIB_ARRAY_ENABLED,
            vertex_attrib_array_size = VERTEX_ATTRIB_ARRAY_SIZE,
            vertex_attrib_array_stride = VERTEX_ATTRIB_ARRAY_STRIDE,
            vertex_attrib_array_type = VERTEX_ATTRIB_ARRAY_TYPE,
            vertex_attrib_array_normalized = VERTEX_ATTRIB_ARRAY_NORMALIZED,
            current_vertex_attrib = CURRENT_VERTEX_ATTRIB,
            //--------------------------------------------------------------------------------------
            // OpenGL 2.1 (Core Profile)
            //--------------------------------------------------------------------------------------
            vertex_attrib_array_buffer_binding = VERTEX_ATTRIB_ARRAY_BUFFER_BINDING,
            //--------------------------------------------------------------------------------------
            // OpenGL 3.0 (Core Profile)
            //--------------------------------------------------------------------------------------
            vertex_attrib_array_integer = VERTEX_ATTRIB_ARRAY_INTEGER,
            //--------------------------------------------------------------------------------------
            // OpenGL 3.3 (Core Profile)
            //--------------------------------------------------------------------------------------
            vertex_attrib_array_divisor = VERTEX_ATTRIB_ARRAY_DIVISOR,
            //--------------------------------------------------------------------------------------
            // OpenGL 4.3 (Core Profile)
            //--------------------------------------------------------------------------------------
            vertex_attrib_array_long = VERTEX_ATTRIB_ARRAY_LONG,
            //--------------------------------------------------------------------------------------
            // OpenGL 4.4 (Core Profile)
            //--------------------------------------------------------------------------------------
            vertex_attrib_binding = VERTEX_ATTRIB_BINDING,
            vertex_attrib_relative_offset = VERTEX_ATTRIB_RELATIVE_OFFSET,
        };

        pub const VertexAttribPointerParameter = enum(Enum) {
            //--------------------------------------------------------------------------------------
            // OpenGL 2.0 (Core Profile)
            //--------------------------------------------------------------------------------------
            vertex_attrib_array_pointer = VERTEX_ATTRIB_ARRAY_POINTER,
        };

        pub const VertexAttribType = enum(Enum) {
            //--------------------------------------------------------------------------------------
            // OpenGL 1.0 (Core Profile)
            //--------------------------------------------------------------------------------------
            byte = BYTE,
            short = SHORT,
            int = INT,
            float = FLOAT,
            double = DOUBLE,
            unsigned_byte = UNSIGNED_BYTE,
            unsigned_short = UNSIGNED_SHORT,
            unsigned_int = UNSIGNED_INT,
            //--------------------------------------------------------------------------------------
            // OpenGL 1.2 (Core Profile)
            //--------------------------------------------------------------------------------------
            unsigned_int_2_10_10_10_rev = UNSIGNED_INT_2_10_10_10_REV,
            //--------------------------------------------------------------------------------------
            // OpenGL 3.0 (Core Profile)
            //--------------------------------------------------------------------------------------
            half_float = HALF_FLOAT,
            unsigned_int_10_f_11_f_11_f_rev = UNSIGNED_INT_10F_11F_11F_REV,
            //--------------------------------------------------------------------------------------
            // OpenGL 3.3 (Core Profile)
            //--------------------------------------------------------------------------------------
            int_2_10_10_10_rev = INT_2_10_10_10_REV,
            //--------------------------------------------------------------------------------------
            // OpenGL 4.1 (Core Profile)
            //--------------------------------------------------------------------------------------
            fixed = FIXED,
        };

        pub const TextureTarget = enum(Enum) {
            //--------------------------------------------------------------------------------------
            // OpenGL 1.0 (Core Profile)
            //--------------------------------------------------------------------------------------
            texture_1d = TEXTURE_1D,
            texture_2d = TEXTURE_2D,
            //--------------------------------------------------------------------------------------
            // OpenGL 1.2 (Core Profile)
            //--------------------------------------------------------------------------------------
            texture_3d = TEXTURE_3D,
            //--------------------------------------------------------------------------------------
            // OpenGL 1.3 (Core Profile)
            //--------------------------------------------------------------------------------------
            texture_cube_map = TEXTURE_CUBE_MAP,
            //--------------------------------------------------------------------------------------
            // OpenGL 3.0 (Core Profile)
            //--------------------------------------------------------------------------------------
            texture_1d_array = TEXTURE_1D_ARRAY,
            texture_2d_array = TEXTURE_2D_ARRAY,
            //--------------------------------------------------------------------------------------
            // OpenGL 3.1 (Core Profile)
            //--------------------------------------------------------------------------------------
            texture_buffer = TEXTURE_BUFFER,
            texture_rectangle = TEXTURE_RECTANGLE,
            //--------------------------------------------------------------------------------------
            // OpenGL 3.2 (Core Profile)
            //--------------------------------------------------------------------------------------
            texture_2d_multisample = TEXTURE_2D_MULTISAMPLE,
            texture_2d_multisample_array = TEXTURE_2D_MULTISAMPLE_ARRAY,
            //--------------------------------------------------------------------------------------
            // OpenGL 4.0 (Core Profile)
            //--------------------------------------------------------------------------------------
            texture_cube_map_array = TEXTURE_CUBE_MAP_ARRAY,
        };

        pub const TexUnit = enum(Enum) {
            texture_0 = TEXTURE0,
            texture_1 = TEXTURE1,
            texture_2 = TEXTURE2,
            texture_3 = TEXTURE3,
            texture_4 = TEXTURE4,
            texture_5 = TEXTURE5,
            texture_6 = TEXTURE6,
            texture_7 = TEXTURE7,
            texture_8 = TEXTURE8,
            texture_9 = TEXTURE9,
            texture_10 = TEXTURE10,
            texture_11 = TEXTURE11,
            texture_12 = TEXTURE12,
            texture_13 = TEXTURE13,
            texture_14 = TEXTURE14,
            texture_15 = TEXTURE15,
            texture_16 = TEXTURE16,
            texture_17 = TEXTURE17,
            texture_18 = TEXTURE18,
            texture_19 = TEXTURE19,
            texture_20 = TEXTURE20,
            texture_21 = TEXTURE21,
            texture_22 = TEXTURE22,
            texture_23 = TEXTURE23,
            texture_24 = TEXTURE24,
            texture_25 = TEXTURE25,
            texture_26 = TEXTURE26,
            texture_27 = TEXTURE27,
            texture_28 = TEXTURE28,
            texture_29 = TEXTURE29,
            texture_30 = TEXTURE30,
            texture_31 = TEXTURE31,
        };

        pub const TexImageTarget = enum(Enum) {
            //--------------------------------------------------------------------------------------
            // OpenGL 1.0 (Core Profile)
            //--------------------------------------------------------------------------------------
            texture_1d = TEXTURE_1D,
            texture_2d = TEXTURE_2D,
            //--------------------------------------------------------------------------------------
            // OpenGL 1.2 (Core Profile)
            //--------------------------------------------------------------------------------------
            texture_3d = TEXTURE_3D,
            //--------------------------------------------------------------------------------------
            // OpenGL 1.3 (Core Profile)
            //--------------------------------------------------------------------------------------
            texture_cube_map_positive_x = TEXTURE_CUBE_MAP_POSITIVE_X,
            texture_cube_map_positive_y = TEXTURE_CUBE_MAP_POSITIVE_Y,
            texture_cube_map_positive_z = TEXTURE_CUBE_MAP_POSITIVE_Z,
            texture_cube_map_negative_x = TEXTURE_CUBE_MAP_NEGATIVE_X,
            texture_cube_map_negative_y = TEXTURE_CUBE_MAP_NEGATIVE_Y,
            texture_cube_map_negative_z = TEXTURE_CUBE_MAP_NEGATIVE_Z,
            //--------------------------------------------------------------------------------------
            // OpenGL 3.0 (Core Profile)
            //--------------------------------------------------------------------------------------
            texture_1d_array = TEXTURE_1D_ARRAY,
            texture_2d_array = TEXTURE_2D_ARRAY,
            //--------------------------------------------------------------------------------------
            // OpenGL 3.1 (Core Profile)
            //--------------------------------------------------------------------------------------
            texture_rectangle = TEXTURE_RECTANGLE,
            //--------------------------------------------------------------------------------------
            // OpenGL 4.0 (Core Profile)
            //--------------------------------------------------------------------------------------
            texture_cube_map_array = TEXTURE_CUBE_MAP_ARRAY,
        };

        pub const TexImage1DTarget = enum(Enum) {
            //--------------------------------------------------------------------------------------
            // OpenGL 1.0 (Core Profile)
            //--------------------------------------------------------------------------------------
            texture_1d = TEXTURE_1D,
            //--------------------------------------------------------------------------------------
            // OpenGL 1.1 (Core Profile)
            //--------------------------------------------------------------------------------------
            proxy_texture_1d = PROXY_TEXTURE_1D,
        };

        pub const TexImage2DTarget = enum(Enum) {
            //--------------------------------------------------------------------------------------
            // OpenGL 1.0 (Core Profile)
            //--------------------------------------------------------------------------------------
            texture_2d = TEXTURE_2D,
            //--------------------------------------------------------------------------------------
            // OpenGL 1.1 (Core Profile)
            //--------------------------------------------------------------------------------------
            proxy_texture_2d = PROXY_TEXTURE_2D,
            //--------------------------------------------------------------------------------------
            // OpenGL 1.3 (Core Profile)
            //--------------------------------------------------------------------------------------
            texture_cube_map_positive_x = TEXTURE_CUBE_MAP_POSITIVE_X,
            texture_cube_map_negative_x = TEXTURE_CUBE_MAP_NEGATIVE_X,
            texture_cube_map_positive_y = TEXTURE_CUBE_MAP_POSITIVE_Y,
            texture_cube_map_negative_y = TEXTURE_CUBE_MAP_NEGATIVE_Y,
            texture_cube_map_positive_z = TEXTURE_CUBE_MAP_POSITIVE_Z,
            texture_cube_map_negative_z = TEXTURE_CUBE_MAP_NEGATIVE_Z,
            proxy_texture_cube_map = PROXY_TEXTURE_CUBE_MAP,
            //--------------------------------------------------------------------------------------
            // OpenGL 3.0 (Core Profile)
            //--------------------------------------------------------------------------------------
            texture_1d_array = TEXTURE_1D_ARRAY,
            proxy_texture_1d_array = PROXY_TEXTURE_1D_ARRAY,
            //--------------------------------------------------------------------------------------
            // OpenGL 3.1 (Core Profile)
            //--------------------------------------------------------------------------------------
            texture_rectangle = TEXTURE_RECTANGLE,
            proxy_texture_rectangle = PROXY_TEXTURE_RECTANGLE,
        };

        pub const TexImage3DTarget = enum(Enum) {
            //--------------------------------------------------------------------------------------
            // OpenGL 1.2 (Core Profile)
            //--------------------------------------------------------------------------------------
            texture_3d = TEXTURE_3D,
            proxy_texture_3d = PROXY_TEXTURE_3D,
            //--------------------------------------------------------------------------------------
            // OpenGL 3.0 (Core Profile)
            //--------------------------------------------------------------------------------------
            texture_2d_array = TEXTURE_2D_ARRAY,
            proxy_texture_2d_array = PROXY_TEXTURE_2D_ARRAY,
            //--------------------------------------------------------------------------------------
            // OpenGL 4.0 (Core Profile)
            //--------------------------------------------------------------------------------------
            texture_cube_map_array = TEXTURE_CUBE_MAP_ARRAY,
            proxy_texture_cube_map_array = PROXY_TEXTURE_CUBE_MAP_ARRAY,
        };

        pub const TexLevelTarget = enum(Enum) {
            //--------------------------------------------------------------------------------------
            // OpenGL 1.0 (Core Profile)
            //--------------------------------------------------------------------------------------
            texture_1d = TEXTURE_1D,
            texture_2d = TEXTURE_2D,
            //--------------------------------------------------------------------------------------
            // OpenGL 1.1 (Core Profile)
            //--------------------------------------------------------------------------------------
            proxy_texture_1d = PROXY_TEXTURE_1D,
            proxy_texture_2d = PROXY_TEXTURE_2D,
            //--------------------------------------------------------------------------------------
            // OpenGL 1.2 (Core Profile)
            //--------------------------------------------------------------------------------------
            texture_3d = TEXTURE_3D,
            proxy_texture_3d = PROXY_TEXTURE_3D,
            //--------------------------------------------------------------------------------------
            // OpenGL 1.3 (Core Profile)
            //--------------------------------------------------------------------------------------
            texture_cube_map_positive_x = TEXTURE_CUBE_MAP_POSITIVE_X,
            texture_cube_map_positive_y = TEXTURE_CUBE_MAP_POSITIVE_Y,
            texture_cube_map_positive_z = TEXTURE_CUBE_MAP_POSITIVE_Z,
            texture_cube_map_negative_x = TEXTURE_CUBE_MAP_NEGATIVE_X,
            texture_cube_map_negative_y = TEXTURE_CUBE_MAP_NEGATIVE_Y,
            texture_cube_map_negative_z = TEXTURE_CUBE_MAP_NEGATIVE_Z,
            proxy_texture_cube_map = PROXY_TEXTURE_CUBE_MAP,
            //--------------------------------------------------------------------------------------
            // OpenGL 3.0 (Core Profile)
            //--------------------------------------------------------------------------------------
            texture_1d_array = TEXTURE_1D_ARRAY,
            texture_2d_array = TEXTURE_2D_ARRAY,
            proxy_texture_1d_array = PROXY_TEXTURE_1D_ARRAY,
            proxy_texture_2d_array = PROXY_TEXTURE_2D_ARRAY,
            //--------------------------------------------------------------------------------------
            // OpenGL 3.1 (Core Profile)
            //--------------------------------------------------------------------------------------
            texture_buffer = TEXTURE_BUFFER,
            texture_rectangle = TEXTURE_RECTANGLE,
            proxy_texture_rectangle = PROXY_TEXTURE_RECTANGLE,
            //--------------------------------------------------------------------------------------
            // OpenGL 3.2 (Core Profile)
            //--------------------------------------------------------------------------------------
            texture_2d_multisample = TEXTURE_2D_MULTISAMPLE,
            texture_2d_mulitsample_array = TEXTURE_2D_MULTISAMPLE_ARRAY,
            proxy_texture_2d_multisample = PROXY_TEXTURE_2D_MULTISAMPLE,
            proxy_texture_2d_mulitsample_array = PROXY_TEXTURE_2D_MULTISAMPLE_ARRAY,
            //--------------------------------------------------------------------------------------
            // OpenGL 4.0 (Core Profile)
            //--------------------------------------------------------------------------------------
            texture_cube_map_array = TEXTURE_CUBE_MAP_ARRAY,
        };

        pub const InternalFormat = enum(Enum) {
            //--------------------------------------------------------------------------------------
            // OpenGL 1.0 (Core Profile)
            //--------------------------------------------------------------------------------------
            red = RED,
            rg = RG,
            rgb = RGB,
            rgba = RGBA,
            depth_component = DEPTH_COMPONENT,
            stencil_index = STENCIL_INDEX,
            //--------------------------------------------------------------------------------------
            // OpenGL 1.1 (Core Profile)
            //--------------------------------------------------------------------------------------
            r3_g3_b2 = R3_G3_B2,
            rgb4 = RGB4,
            rgb5 = RGB5,
            rgb8 = RGB8,
            rgb10 = RGB10,
            rgb12 = RGB12,
            rgb16 = RGB16,
            rgba2 = RGBA2,
            rgba4 = RGBA4,
            rgb5_a1 = RGB5_A1,
            rgba8 = RGBA8,
            rgb10_a2 = RGB10_A2,
            rgba12 = RGBA12,
            rgba16 = RGBA16,
            //--------------------------------------------------------------------------------------
            // OpenGL 1.2 (Core Profile)
            //--------------------------------------------------------------------------------------
            bgr = BGR,
            bgra = BGRA,
            //--------------------------------------------------------------------------------------
            // OpenGL 1.4 (Core Profile)
            //--------------------------------------------------------------------------------------
            depth_component16 = DEPTH_COMPONENT16,
            depth_component24 = DEPTH_COMPONENT24,
            depth_component32 = DEPTH_COMPONENT32,
            //--------------------------------------------------------------------------------------
            // OpenGL 2.1 (Core Profile)
            //--------------------------------------------------------------------------------------
            srgb8 = SRGB8,
            srgb8_alpha8 = SRGB8_ALPHA8,
            //--------------------------------------------------------------------------------------
            // OpenGL 3.0 (Core Profile)
            //--------------------------------------------------------------------------------------
            red_integer = RED_INTEGER,
            rg_integer = RG_INTEGER,
            rgb_integer = RGB_INTEGER,
            bgr_integer = BGR_INTEGER,
            rgba_integer = RGBA_INTEGER,
            bgra_integer = BGRA_INTEGER,
            r8 = R8,
            r16 = R16,
            rg8 = RG8,
            rg16 = RG16,
            r16f = R16F,
            rg16f = RG16F,
            rgb16f = RGB16F,
            rgba16f = RGBA16F,
            r32f = R32F,
            rg32f = RG32F,
            rgb32f = RGB32F,
            rgba32f = RGBA32F,
            r11f_g11f_b10f = R11F_G11F_B10F,
            rgb9_e5 = RGB9_E5,
            r8i = R8I,
            r8ui = R8UI,
            r16i = R16I,
            r16ui = R16UI,
            r32i = R32I,
            r32ui = R32UI,
            rg8i = RG8I,
            rg8ui = RG8UI,
            rg16i = RG16I,
            rg16ui = RG16UI,
            rg32i = RG32I,
            rg32ui = RG32UI,
            rgb8i = RGB8I,
            rgb8ui = RGB8UI,
            rgb16i = RGB16I,
            rgb16ui = RGB16UI,
            rgb32i = RGB32I,
            rgb32ui = RGB32UI,
            rgba8i = RGBA8I,
            rgba8ui = RGBA8UI,
            rgba16i = RGBA16I,
            rgba16ui = RGBA16UI,
            rgba32i = RGBA32I,
            rgba32ui = RGBA32UI,
            depth_component32f = DEPTH_COMPONENT32F,
            depth24_stencil8 = DEPTH24_STENCIL8,
            depth32f_stencil8 = DEPTH32F_STENCIL8,
            //--------------------------------------------------------------------------------------
            // OpenGL 3.1 (Core Profile)
            //--------------------------------------------------------------------------------------
            r8_snorm = R8_SNORM,
            r16_snorm = R16_SNORM,
            rg8_snorm = RG8_SNORM,
            rg16_snorm = RG16_SNORM,
            rgb8_snorm = RGB8_SNORM,
            rgb16_snorm = RGB16_SNORM,
            rgba8_snorm = RGBA8_SNORM,
            rgba16_snorm = RGBA16_SNORM,
            //--------------------------------------------------------------------------------------
            // OpenGL 3.3 (Core Profile)
            //--------------------------------------------------------------------------------------
            rgb10_a2ui = RGB10_A2UI,
            //--------------------------------------------------------------------------------------
            // OpenGL 4.1 (Core Profile)
            //--------------------------------------------------------------------------------------
            rgb565 = RGB565,
            //--------------------------------------------------------------------------------------
            // OpenGL 4.2 (Core Profile)
            //--------------------------------------------------------------------------------------
            compressed_rgba_bptc_unorm = COMPRESSED_RGBA_BPTC_UNORM,
            compressed_srgb_alpha_bptc_unorm = COMPRESSED_SRGB_ALPHA_BPTC_UNORM,
            compressed_rgb_bptc_signed_float = COMPRESSED_RGB_BPTC_SIGNED_FLOAT,
            compressed_rgb_bptc_unsigned_float = COMPRESSED_RGB_BPTC_UNSIGNED_FLOAT,
        };

        pub const PixelFormat = enum(Enum) {
            //--------------------------------------------------------------------------------------
            // OpenGL 1.0 (Core Profile)
            //--------------------------------------------------------------------------------------
            red = RED,
            green = GREEN,
            blue = BLUE,
            rg = RG,
            rgb = RGB,
            rgba = RGBA,
            depth_component = DEPTH_COMPONENT,
            stencil_index = STENCIL_INDEX,
            //--------------------------------------------------------------------------------------
            // OpenGL 1.2 (Core Profile)
            //--------------------------------------------------------------------------------------
            bgr = BGR,
            bgra = BGRA,
            //--------------------------------------------------------------------------------------
            // OpenGL 3.0 (Core Profile)
            //--------------------------------------------------------------------------------------
            depth_stencil = DEPTH_STENCIL,
            red_integer = RED_INTEGER,
            green_integer = GREEN_INTEGER,
            blue_integer = BLUE_INTEGER,
            rg_integer = RG_INTEGER,
            rgb_integer = RGB_INTEGER,
            bgr_integer = BGR_INTEGER,
            rgba_integer = RGBA_INTEGER,
            bgra_integer = BGRA_INTEGER,
        };

        pub const CompressedPixelFormat = enum(Enum) {
            //--------------------------------------------------------------------------------------
            // OpenGL 4.2 (Core Profile)
            //--------------------------------------------------------------------------------------
            compressed_rgba_bptc_unorm = COMPRESSED_RGBA_BPTC_UNORM,
            compressed_srgb_alpha_bptc_unorm = COMPRESSED_SRGB_ALPHA_BPTC_UNORM,
            compressed_rgb_bptc_signed_float = COMPRESSED_RGB_BPTC_SIGNED_FLOAT,
            compressed_rgb_bptc_unsigned_float = COMPRESSED_RGB_BPTC_UNSIGNED_FLOAT,
        };

        pub const PixelType = enum(Enum) {
            //--------------------------------------------------------------------------------------
            // OpenGL 1.0 (Core Profile)
            //--------------------------------------------------------------------------------------
            unsigned_byte = UNSIGNED_BYTE,
            byte = BYTE,
            unsigned_short = UNSIGNED_SHORT,
            short = SHORT,
            unsigned_int = UNSIGNED_INT,
            int = INT,
            float = FLOAT,
            //--------------------------------------------------------------------------------------
            // OpenGL 1.2 (Core Profile)
            //--------------------------------------------------------------------------------------
            unsigned_byte_3_3_2 = UNSIGNED_BYTE_3_3_2,
            unsigned_byte_2_3_3_rev = UNSIGNED_BYTE_2_3_3_REV,
            unsigned_short_5_6_5 = UNSIGNED_SHORT_5_6_5,
            unsigned_short_5_6_5_rev = UNSIGNED_SHORT_5_6_5_REV,
            unsigned_short_4_4_4_4 = UNSIGNED_SHORT_4_4_4_4,
            unsigned_short_4_4_4_4_rev = UNSIGNED_SHORT_4_4_4_4_REV,
            unsigned_short_5_5_5_1 = UNSIGNED_SHORT_5_5_5_1,
            unsigned_short_1_5_5_5_rev = UNSIGNED_SHORT_1_5_5_5_REV,
            unsigned_int_8_8_8_8 = UNSIGNED_INT_8_8_8_8,
            unsigned_int_8_8_8_8_rev = UNSIGNED_INT_8_8_8_8_REV,
            unsigned_int_10_10_10_2 = UNSIGNED_INT_10_10_10_2,
            unsigned_int_2_10_10_10_rev = UNSIGNED_INT_2_10_10_10_REV,
            //--------------------------------------------------------------------------------------
            // OpenGL 3.0 (Core Profile)
            //--------------------------------------------------------------------------------------
            half_float = HALF_FLOAT,
            unsigned_int_24_8 = UNSIGNED_INT_24_8,
            unsigned_int_10f_11f_11f_rev = UNSIGNED_INT_10F_11F_11F_REV,
            unsigned_int_5_9_9_9_rev = UNSIGNED_INT_5_9_9_9_REV,
            float_32_unsigned_int_24_8_rev = FLOAT_32_UNSIGNED_INT_24_8_REV,
        };

        pub const TexParameter = enum(Enum) {
            //--------------------------------------------------------------------------------------
            // OpenGL 1.0 (Core Profile)
            //--------------------------------------------------------------------------------------
            min_filter = TEXTURE_MIN_FILTER,
            mag_filter = TEXTURE_MAG_FILTER,
            wrap_s = TEXTURE_WRAP_S,
            wrap_t = TEXTURE_WRAP_T,
            //--------------------------------------------------------------------------------------
            // OpenGL 1.2 (Core Profile)
            //--------------------------------------------------------------------------------------
            base_level = TEXTURE_BASE_LEVEL,
            min_lod = TEXTURE_MIN_LOD,
            max_lod = TEXTURE_MAX_LOD,
            max_level = TEXTURE_MAX_LEVEL,
            wrap_r = TEXTURE_WRAP_R,
            //--------------------------------------------------------------------------------------
            // OpenGL 1.4 (Core Profile)
            //--------------------------------------------------------------------------------------
            compare_func = TEXTURE_COMPARE_FUNC,
            compare_mode = TEXTURE_COMPARE_MODE,
            lod_bias = TEXTURE_LOD_BIAS,
            //--------------------------------------------------------------------------------------
            // OpenGL 3.3 (Core Profile)
            //--------------------------------------------------------------------------------------
            swizzle_r = TEXTURE_SWIZZLE_R,
            swizzle_g = TEXTURE_SWIZZLE_G,
            swizzle_b = TEXTURE_SWIZZLE_B,
            swizzle_a = TEXTURE_SWIZZLE_A,
        };

        pub const GetTexParameter = enum(Enum) {
            //--------------------------------------------------------------------------------------
            // OpenGL 1.0 (Core Profile)
            //--------------------------------------------------------------------------------------
            min_filter = TEXTURE_MIN_FILTER,
            mag_filter = TEXTURE_MAG_FILTER,
            wrap_s = TEXTURE_WRAP_S,
            wrap_t = TEXTURE_WRAP_T,
            border_color = TEXTURE_BORDER_COLOR,
            //--------------------------------------------------------------------------------------
            // OpenGL 1.2 (Core Profile)
            //--------------------------------------------------------------------------------------
            base_level = TEXTURE_BASE_LEVEL,
            min_lod = TEXTURE_MIN_LOD,
            max_lod = TEXTURE_MAX_LOD,
            max_level = TEXTURE_MAX_LEVEL,
            wrap_r = TEXTURE_WRAP_R,
            //--------------------------------------------------------------------------------------
            // OpenGL 1.4 (Core Profile)
            //--------------------------------------------------------------------------------------
            compare_func = TEXTURE_COMPARE_FUNC,
            compare_mode = TEXTURE_COMPARE_MODE,
            lod_bias = TEXTURE_LOD_BIAS,
            //--------------------------------------------------------------------------------------
            // OpenGL 3.3 (Core Profile)
            //--------------------------------------------------------------------------------------
            swizzle_r = TEXTURE_SWIZZLE_R,
            swizzle_g = TEXTURE_SWIZZLE_G,
            swizzle_b = TEXTURE_SWIZZLE_B,
            swizzle_a = TEXTURE_SWIZZLE_A,
            swizzle_rgba = TEXTURE_SWIZZLE_RGBA,
            //--------------------------------------------------------------------------------------
            // OpenGL 4.2 (Core Profile)
            //--------------------------------------------------------------------------------------
            texture_immutable_format = TEXTURE_IMMUTABLE_FORMAT,
        };

        pub const GetTexLevelParameter = enum(Enum) {
            //--------------------------------------------------------------------------------------
            // OpenGL 1.0 (Core Profile)
            //--------------------------------------------------------------------------------------
            width = TEXTURE_WIDTH,
            height = TEXTURE_HEIGHT,
            //--------------------------------------------------------------------------------------
            // OpenGL 1.1 (Core Profile)
            //--------------------------------------------------------------------------------------
            internal_format = TEXTURE_INTERNAL_FORMAT,
            red_size = TEXTURE_RED_SIZE,
            green_size = TEXTURE_GREEN_SIZE,
            blue_size = TEXTURE_BLUE_SIZE,
            alpha_size = TEXTURE_ALPHA_SIZE,
            //--------------------------------------------------------------------------------------
            // OpenGL 1.2 (Core Profile)
            //--------------------------------------------------------------------------------------
            depth = TEXTURE_DEPTH,
            //--------------------------------------------------------------------------------------
            // OpenGL 1.3 (Core Profile)
            //--------------------------------------------------------------------------------------
            compressed = TEXTURE_COMPRESSED,
            compressed_image_size = TEXTURE_COMPRESSED_IMAGE_SIZE,
            //--------------------------------------------------------------------------------------
            // OpenGL 1.4 (Core Profile)
            //--------------------------------------------------------------------------------------
            depth_size = TEXTURE_DEPTH_SIZE,
            //--------------------------------------------------------------------------------------
            // TODO
            // buffer_offset = TEXTURE_BUFFER_OFFSET,
        };

        pub const MipmapTarget = enum(Enum) {
            //--------------------------------------------------------------------------------------
            // OpenGL 3.0 (Core Profile)
            //--------------------------------------------------------------------------------------
            texture_1d = TEXTURE_1D,
            texture_2d = TEXTURE_2D,
            texture_3d = TEXTURE_3D,
            texture_1d_array = TEXTURE_1D_ARRAY,
            texture_2d_array = TEXTURE_2D_ARRAY,
            texture_cube_map = TEXTURE_CUBE_MAP,
            //--------------------------------------------------------------------------------------
            // OpenGL 4.0 (Core Profile)
            //--------------------------------------------------------------------------------------
            texture_cube_map_array = TEXTURE_CUBE_MAP_ARRAY,
        };

        pub const PixelStoreParameter = meta.mergeEnums(.{
            enum(Enum) {
                //--------------------------------------------------------------------------------------
                // OpenGL 1.0 (Core Profile)
                //--------------------------------------------------------------------------------------
                pack_swap_bytes = PACK_SWAP_BYTES,
                pack_lsb_first = PACK_LSB_FIRST,
                pack_row_length = PACK_ROW_LENGTH,
                pack_skip_pixels = PACK_SKIP_PIXELS,
                pack_skip_rows = PACK_SKIP_ROWS,
                pack_alignment = PACK_ALIGNMENT,
                unpack_swap_bytes = UNPACK_SWAP_BYTES,
                unpack_lsb_first = UNPACK_LSB_FIRST,
                unpack_row_length = UNPACK_ROW_LENGTH,
                unpack_skip_pixels = UNPACK_SKIP_PIXELS,
                unpack_skip_rows = UNPACK_SKIP_ROWS,
                unpack_alignment = UNPACK_ALIGNMENT,
                //--------------------------------------------------------------------------------------
                // OpenGL 1.2 (Core Profile)
                //--------------------------------------------------------------------------------------
                pack_image_height = PACK_IMAGE_HEIGHT,
                pack_skip_images = PACK_SKIP_IMAGES,
                unpack_image_height = UNPACK_IMAGE_HEIGHT,
                unpack_skip_images = UNPACK_SKIP_IMAGES,
            },
            CompressedTexturePixelStorage,
        });

        const CompressedTexturePixelStorage = enum(Enum) {
            //--------------------------------------------------------------------------------------
            // OpenGL 4.2 (Core Profile)
            //--------------------------------------------------------------------------------------
            unpack_compressed_block_width = UNPACK_COMPRESSED_BLOCK_WIDTH,
            unpack_compressed_block_height = UNPACK_COMPRESSED_BLOCK_HEIGHT,
            unpack_compressed_block_depth = UNPACK_COMPRESSED_BLOCK_DEPTH,
            unpack_compressed_block_size = UNPACK_COMPRESSED_BLOCK_SIZE,
            pack_compressed_block_width = PACK_COMPRESSED_BLOCK_WIDTH,
            pack_compressed_block_height = PACK_COMPRESSED_BLOCK_HEIGHT,
            pack_compressed_block_depth = PACK_COMPRESSED_BLOCK_DEPTH,
            pack_compressed_block_size = PACK_COMPRESSED_BLOCK_SIZE,
        };

        pub const QueryTarget = enum(Enum) {
            //--------------------------------------------------------------------------------------
            // OpenGL 1.5 (Core Profile)
            //--------------------------------------------------------------------------------------
            samples_passed = SAMPLES_PASSED,
            //--------------------------------------------------------------------------------------
            // OpenGL 3.0 (Core Profile)
            //--------------------------------------------------------------------------------------
            primitives_generated = PRIMITIVES_GENERATED,
            transform_feedback_primitives_written = TRANSFORM_FEEDBACK_PRIMITIVES_WRITTEN,
            //--------------------------------------------------------------------------------------
            // OpenGL 3.3 (Core Profile)
            //--------------------------------------------------------------------------------------
            any_samples_passed = ANY_SAMPLES_PASSED,
            time_elapsed = TIME_ELAPSED,
            //--------------------------------------------------------------------------------------
            // OpenGL 4.3 (Core Profile)
            //--------------------------------------------------------------------------------------
            any_samples_passed_conservative = ANY_SAMPLES_PASSED_CONSERVATIVE,
        };

        pub const QueryTargetWithTimestamp = enum(Enum) {
            //--------------------------------------------------------------------------------------
            // OpenGL 1.5 (Core Profile)
            //--------------------------------------------------------------------------------------
            samples_passed = SAMPLES_PASSED,
            //--------------------------------------------------------------------------------------
            // OpenGL 3.0 (Core Profile)
            //--------------------------------------------------------------------------------------
            primitives_generated = PRIMITIVES_GENERATED,
            transform_feedback_primitives_written = TRANSFORM_FEEDBACK_PRIMITIVES_WRITTEN,
            //--------------------------------------------------------------------------------------
            // OpenGL 3.3 (Core Profile)
            //--------------------------------------------------------------------------------------
            any_samples_passed = ANY_SAMPLES_PASSED,
            time_elapsed = TIME_ELAPSED,
            timestamp = TIMESTAMP,
            //--------------------------------------------------------------------------------------
            // OpenGL 4.3 (Core Profile)
            //--------------------------------------------------------------------------------------
            any_samples_passed_conservative = ANY_SAMPLES_PASSED_CONSERVATIVE,
        };

        pub const QueryParameter = enum(Enum) {
            //--------------------------------------------------------------------------------------
            // OpenGL 1.5 (Core Profile)
            //--------------------------------------------------------------------------------------
            current_query = CURRENT_QUERY,
            query_counter_bits = QUERY_COUNTER_BITS,
        };

        pub const QueryObjectParameter = enum(Enum) {
            //--------------------------------------------------------------------------------------
            // OpenGL 1.5 (Core Profile)
            //--------------------------------------------------------------------------------------
            query_result = QUERY_RESULT,
            query_result_available = QUERY_RESULT_AVAILABLE,
            //--------------------------------------------------------------------------------------
            // OpenGL 4.4 (Core Profile)
            //--------------------------------------------------------------------------------------
            query_result_no_wait = QUERY_RESULT_NO_WAIT,
            //--------------------------------------------------------------------------------------
            // OpenGL 4.5 (Core Profile)
            //--------------------------------------------------------------------------------------
            query_target = QUERY_TARGET,
        };

        pub const BufferTarget = enum(Enum) {
            //--------------------------------------------------------------------------------------
            // OpenGL 1.5 (Core Profile)
            //--------------------------------------------------------------------------------------
            array_buffer = ARRAY_BUFFER,
            element_array_buffer = ELEMENT_ARRAY_BUFFER,
            //--------------------------------------------------------------------------------------
            // OpenGL 2.1 (Core Profile)
            //--------------------------------------------------------------------------------------
            pixel_pack_buffer = PIXEL_PACK_BUFFER,
            pixel_unpack_buffer = PIXEL_UNPACK_BUFFER,
            //--------------------------------------------------------------------------------------
            // OpenGL 3.0 (Core Profile)
            //--------------------------------------------------------------------------------------
            transform_feedback_buffer = TRANSFORM_FEEDBACK_BUFFER,
            //--------------------------------------------------------------------------------------
            // OpenGL 3.1 (Core Profile)
            //--------------------------------------------------------------------------------------
            copy_read_buffer = COPY_READ_BUFFER,
            copy_write_buffer = COPY_WRITE_BUFFER,
            texture_buffer = TEXTURE_BUFFER,
            uniform_buffer = UNIFORM_BUFFER,
            //--------------------------------------------------------------------------------------
            // OpenGL 4.0 (Core Profile)
            //--------------------------------------------------------------------------------------
            draw_indirect_buffer = DRAW_INDIRECT_BUFFER,
            //--------------------------------------------------------------------------------------
            // OpenGL 4.2 (Core Profile)
            //--------------------------------------------------------------------------------------
            atomic_counter_buffer = ATOMIC_COUNTER_BUFFER,
            //--------------------------------------------------------------------------------------
            // OpenGL 4.3 (Core Profile)
            //--------------------------------------------------------------------------------------
            dispatch_indirect_buffer = DISPATCH_INDIRECT_BUFFER,
            shader_storage_buffer = SHADER_STORAGE_BUFFER,
            //--------------------------------------------------------------------------------------
            // OpenGL 4.4 (Core Profile)
            //--------------------------------------------------------------------------------------
            query_buffer = QUERY_BUFFER,
            //--------------------------------------------------------------------------------------
            // OpenGL 4.6 (Core Profile)
            //--------------------------------------------------------------------------------------
            parameter_buffer = PARAMETER_BUFFER,
        };

        pub const Access = enum(Enum) {
            //--------------------------------------------------------------------------------------
            // OpenGL 1.5 (Core Profile)
            //--------------------------------------------------------------------------------------
            read_only = READ_ONLY,
            write_only = WRITE_ONLY,
            read_write = READ_WRITE,
        };

        pub const BufferParameter = enum(Enum) {
            //--------------------------------------------------------------------------------------
            // OpenGL 1.5 (Core Profile)
            //--------------------------------------------------------------------------------------
            buffer_size = BUFFER_SIZE,
            buffer_usage = BUFFER_USAGE,
            buffer_access = BUFFER_ACCESS,
            buffer_mapped = BUFFER_MAPPED,
            //--------------------------------------------------------------------------------------
            // OpenGL 3.0 (Core Profile)
            //--------------------------------------------------------------------------------------
            buffer_access_flags = BUFFER_ACCESS_FLAGS,
            buffer_map_offset = BUFFER_MAP_OFFSET,
            buffer_map_length = BUFFER_MAP_LENGTH,
            //--------------------------------------------------------------------------------------
            // OpenGL 4.4 (Core Profile)
            //--------------------------------------------------------------------------------------
            buffer_immutable_storage = BUFFER_IMMUTABLE_STORAGE,
            buffer_storage_flags = BUFFER_STORAGE_FLAGS,
        };

        pub const BufferPointerParameter = enum(Enum) {
            //--------------------------------------------------------------------------------------
            // OpenGL 1.5 (Core Profile)
            //--------------------------------------------------------------------------------------
            buffer_map_pointer = BUFFER_MAP_POINTER,
        };

        pub const IndexedBufferTarget = enum(Enum) {
            //--------------------------------------------------------------------------------------
            // OpenGL 3.0 (Core Profile)
            //--------------------------------------------------------------------------------------
            transform_feedback_buffer = TRANSFORM_FEEDBACK_BUFFER,
            //--------------------------------------------------------------------------------------
            // OpenGL 3.1 (Core Profile)
            //--------------------------------------------------------------------------------------
            uniform_buffer = UNIFORM_BUFFER,
            //--------------------------------------------------------------------------------------
            // OpenGL 4.2 (Core Profile)
            //--------------------------------------------------------------------------------------
            atomic_counter_buffer = ATOMIC_COUNTER_BUFFER,
            //--------------------------------------------------------------------------------------
            // OpenGL 4.3 (Core Profile)
            //--------------------------------------------------------------------------------------
            shader_storage_buffer = SHADER_STORAGE_BUFFER,
        };

        pub const BufferUsage = enum(Enum) {
            //--------------------------------------------------------------------------------------
            // OpenGL 1.5 (Core Profile)
            //--------------------------------------------------------------------------------------
            stream_draw = STREAM_DRAW,
            stream_read = STREAM_READ,
            stream_copy = STREAM_COPY,
            static_draw = STATIC_DRAW,
            static_read = STATIC_READ,
            static_copy = STATIC_COPY,
            dynamic_draw = DYNAMIC_DRAW,
            dynamic_read = DYNAMIC_READ,
            dynamic_copy = DYNAMIC_COPY,
        };

        pub const PrimitiveType = enum(Enum) {
            //--------------------------------------------------------------------------------------
            // OpenGL 1.0 (Core Profile)
            //--------------------------------------------------------------------------------------
            points = POINTS,
            line_strip = LINE_STRIP,
            line_loop = LINE_LOOP,
            lines = LINES,
            triangle_strip = TRIANGLE_STRIP,
            triangle_fan = TRIANGLE_FAN,
            triangles = TRIANGLES,
            //--------------------------------------------------------------------------------------
            // OpenGL 3.2 (Core Profile)
            //--------------------------------------------------------------------------------------
            line_strip_adjacency = LINE_STRIP_ADJACENCY,
            lines_adjacency = LINES_ADJACENCY,
            triangle_strip_adjacency = TRIANGLE_STRIP_ADJACENCY,
            triangles_adjacency = TRIANGLES_ADJACENCY,
            //--------------------------------------------------------------------------------------
            // OpenGL 4.0 (Core Profile)
            //--------------------------------------------------------------------------------------
            patches = PATCHES,
        };

        pub const PrimitiveTypeBasic = enum(Enum) {
            //--------------------------------------------------------------------------------------
            // OpenGL 1.0 (Core Profile)
            //--------------------------------------------------------------------------------------
            points = POINTS,
            lines = LINES,
            triangles = TRIANGLES,
        };

        pub const Face = enum(Enum) {
            //--------------------------------------------------------------------------------------
            // OpenGL 1.0 (Core Profile)
            //--------------------------------------------------------------------------------------
            front = FRONT,
            back = BACK,
            front_and_back = FRONT_AND_BACK,
        };

        pub const IndexedBoolParameter = enum(Enum) {
            //--------------------------------------------------------------------------------------
            // OpenGL 3.0 (Core Profile)
            //--------------------------------------------------------------------------------------
            color_writemask = COLOR_WRITEMASK,
            //--------------------------------------------------------------------------------------
            // OpenGL 4.2 (Core Profile)
            //--------------------------------------------------------------------------------------
            image_binding_layered = IMAGE_BINDING_LAYERED,
        };

        pub const IndexedInt32Parameter = enum(Enum) {
            //--------------------------------------------------------------------------------------
            // OpenGL 3.0 (Core Profile)
            //--------------------------------------------------------------------------------------
            blend_src_rgb = BLEND_SRC_RGB,
            blend_src_alpha = BLEND_SRC_ALPHA,
            blend_dst_rgb = BLEND_DST_RGB,
            blend_dst_alpha = BLEND_DST_ALPHA,
            scissor_box = SCISSOR_BOX,
            blend_equation_rgb = BLEND_EQUATION_RGB,
            blend_equation_alpha = BLEND_EQUATION_ALPHA,
            transform_feedback_buffer_binding = TRANSFORM_FEEDBACK_BUFFER_BINDING,
            //--------------------------------------------------------------------------------------
            // OpenGL 3.1 (Core Profile)
            //--------------------------------------------------------------------------------------
            uniform_buffer_binding = UNIFORM_BUFFER_BINDING,
            //--------------------------------------------------------------------------------------
            // OpenGL 3.2 (Core Profile)
            //--------------------------------------------------------------------------------------
            sample_mask_value = SAMPLE_MASK_VALUE,
            //--------------------------------------------------------------------------------------
            // OpenGL 4.2 (Core Profile)
            //--------------------------------------------------------------------------------------
            atomic_counter_buffer_binding = ATOMIC_COUNTER_BUFFER_BINDING,
            image_binding_name = IMAGE_BINDING_NAME,
            image_binding_level = IMAGE_BINDING_LEVEL,
            image_binding_layer = IMAGE_BINDING_LAYER,
            image_binding_access = IMAGE_BINDING_ACCESS,
            image_binding_format = IMAGE_BINDING_FORMAT,
            //--------------------------------------------------------------------------------------
            // OpenGL 4.3 (Core Profile)
            //--------------------------------------------------------------------------------------
            vertex_binding_stride = VERTEX_BINDING_STRIDE,
            vertex_binding_divisor = VERTEX_BINDING_DIVISOR,
            vertex_binding_buffer = VERTEX_BINDING_BUFFER,
            shader_storage_buffer_binding = SHADER_STORAGE_BUFFER_BINDING,
            max_compute_work_group_count = MAX_COMPUTE_WORK_GROUP_COUNT,
            max_compute_work_group_size = MAX_COMPUTE_WORK_GROUP_SIZE,
        };

        pub const IndexedCapability = enum(Enum) {
            //--------------------------------------------------------------------------------------
            // OpenGL 3.0 (Core Profile)
            //--------------------------------------------------------------------------------------
            blend = BLEND,
            scissor_test = SCISSOR_TEST,
        };

        pub const TransformFeedbackBufferMode = enum(Enum) {
            //--------------------------------------------------------------------------------------
            // OpenGL 3.0 (Core Profile)
            //--------------------------------------------------------------------------------------
            interleaved_attribs = INTERLEAVED_ATTRIBS,
            separate_attribs = SEPARATE_ATTRIBS,
        };

        pub const ClampColorTarget = enum(Enum) {
            //--------------------------------------------------------------------------------------
            // OpenGL 3.0 (Core Profile)
            //--------------------------------------------------------------------------------------
            clamp_read_color = CLAMP_READ_COLOR,
        };

        pub const ClampColor = enum(Enum) {
            //--------------------------------------------------------------------------------------
            // OpenGL 3.0 (Core Profile)
            //--------------------------------------------------------------------------------------
            true = TRUE,
            false = FALSE,
            fixed_only = FIXED_ONLY,
        };

        pub const ConditionalRenderMode = enum(Enum) {
            //--------------------------------------------------------------------------------------
            // OpenGL 3.0 (Core Profile)
            //--------------------------------------------------------------------------------------
            query_wait = QUERY_WAIT,
            query_no_wait = QUERY_NO_WAIT,
            query_by_region_wait = QUERY_BY_REGION_WAIT,
            query_by_region_no_wait = QUERY_BY_REGION_NO_WAIT,
            //--------------------------------------------------------------------------------------
            // OpenGL 4.5 (Core Profile)
            //--------------------------------------------------------------------------------------
            query_wait_inverted = QUERY_WAIT_INVERTED,
            query_no_wait_inverted = QUERY_NO_WAIT_INVERTED,
            query_by_region_wait_inverted = QUERY_BY_REGION_WAIT_INVERTED,
            query_by_region_no_wait_inverted = QUERY_BY_REGION_NO_WAIT_INVERTED,
        };

        pub const VertexAttribIntegerType = enum(Enum) {
            //--------------------------------------------------------------------------------------
            // OpenGL 3.0 (Core Profile)
            //--------------------------------------------------------------------------------------
            byte = BYTE,
            short = SHORT,
            int = INT,
            unsigned_byte = UNSIGNED_BYTE,
            unsigned_short = UNSIGNED_SHORT,
            unsigned_int = UNSIGNED_INT,
        };

        pub const ClearBuffer = enum(Enum) {
            //--------------------------------------------------------------------------------------
            // OpenGL 3.0 (Core Profile)
            //--------------------------------------------------------------------------------------
            color = COLOR,
            depth = DEPTH,
            stencil = STENCIL,
        };

        pub const ClearBufferDepthStencil = enum(Enum) {
            //--------------------------------------------------------------------------------------
            // OpenGL 3.0 (Core Profile)
            //--------------------------------------------------------------------------------------
            depth_stencil = DEPTH_STENCIL,
        };

        pub const RenderbufferParameter = enum(Enum) {
            //--------------------------------------------------------------------------------------
            // OpenGL 3.0 (Core Profile)
            //--------------------------------------------------------------------------------------
            renderbuffer_width = RENDERBUFFER_WIDTH,
            renderbuffer_height = RENDERBUFFER_HEIGHT,
            renderbuffer_internal_format = RENDERBUFFER_INTERNAL_FORMAT,
            renderbuffer_red_size = RENDERBUFFER_RED_SIZE,
            renderbuffer_green_size = RENDERBUFFER_GREEN_SIZE,
            renderbuffer_blue_size = RENDERBUFFER_BLUE_SIZE,
            renderbuffer_alpha_size = RENDERBUFFER_ALPHA_SIZE,
            renderbuffer_depth_size = RENDERBUFFER_DEPTH_SIZE,
            renderbuffer_stencil_size = RENDERBUFFER_STENCIL_SIZE,
            renderbuffer_samples = RENDERBUFFER_SAMPLES,
        };

        pub const Filter = enum(Enum) {
            //--------------------------------------------------------------------------------------
            // OpenGL 3.0 (Core Profile)
            //--------------------------------------------------------------------------------------
            nearest = NEAREST,
            linear = LINEAR,
        };

        pub const MappedBufferAccess = packed struct(Bitfield) {
            //--------------------------------------------------------------------------------------
            // OpenGL 3.0 (Core Profile)
            //--------------------------------------------------------------------------------------
            // MAP_READ_BIT              = 0x00000001 // 1st bit
            // MAP_WRITE_BIT             = 0x00000002 // 2nd bit
            // MAP_INVALIDATE_RANGE_BIT  = 0x00000004 // 3rd bit
            // MAP_INVALIDATE_BUFFER_BIT = 0x00000008 // 4th bit
            // MAP_FLUSH_EXPLICIT_BIT    = 0x00000010 // 5th bit
            // MAP_UNSYNCHRONIZED_BIT    = 0x00000020 // 6th bit
            //--------------------------------------------------------------------------------------
            // OpenGL 4.4 (Core Profile)
            //--------------------------------------------------------------------------------------
            // MAP_PERSISTENT_BIT        = 0x00000040 // 7th bit
            // MAP_COHERENT_BIT          = 0x00000080 // 8th bit

            map_read: bool = false,
            map_write: bool = false,
            map_invalidate_range: bool = false,
            map_invalidate_buffer: bool = false,
            map_flush_explicit: bool = false,
            map_unsynchronized: bool = false,
            map_persistent: bool = false,
            map_coherent: bool = false,

            /// DO NOT WRITE
            pad: u24 = 0,

            // confirmation that memory layout is correct
            comptime {
                assert(@as(Bitfield, @bitCast(MappedBufferAccess{ .map_read = true })) == MAP_READ_BIT);
                assert(@as(Bitfield, @bitCast(MappedBufferAccess{ .map_write = true })) == MAP_WRITE_BIT);
                assert(@as(Bitfield, @bitCast(MappedBufferAccess{ .map_invalidate_range = true })) == MAP_INVALIDATE_RANGE_BIT);
                assert(@as(Bitfield, @bitCast(MappedBufferAccess{ .map_invalidate_buffer = true })) == MAP_INVALIDATE_BUFFER_BIT);
                assert(@as(Bitfield, @bitCast(MappedBufferAccess{ .map_flush_explicit = true })) == MAP_FLUSH_EXPLICIT_BIT);
                assert(@as(Bitfield, @bitCast(MappedBufferAccess{ .map_unsynchronized = true })) == MAP_UNSYNCHRONIZED_BIT);
                assert(@as(Bitfield, @bitCast(MappedBufferAccess{ .map_persistent = true })) == MAP_PERSISTENT_BIT);
                assert(@as(Bitfield, @bitCast(MappedBufferAccess{ .map_coherent = true })) == MAP_COHERENT_BIT);
            }
        };

        pub const TexBufferTarget = enum(Enum) {
            //--------------------------------------------------------------------------------------
            // OpenGL 3.1 (Core Profile)
            //--------------------------------------------------------------------------------------
            texture_buffer = TEXTURE_BUFFER,
        };

        pub const TextureInternalFormat = enum(Enum) {
            //--------------------------------------------------------------------------------------
            // OpenGL 3.1 (Core Profile)
            //--------------------------------------------------------------------------------------
            r8 = R8,
            r16 = R16,
            r16f = R16F,
            r32f = R32F,
            r8i = R8I,
            r16i = R16I,
            r32i = R32I,
            r8ui = R8UI,
            r16ui = R16UI,
            r32ui = R32UI,
            rg8 = RG8,
            rg16 = RG16,
            rg16f = RG16F,
            rg32f = RG32F,
            rg8i = RG8I,
            rg16i = RG16I,
            rg32i = RG32I,
            rg8ui = RG8UI,
            rg16ui = RG16UI,
            rg32ui = RG32UI,
            rgb32f = RGB32F,
            rgb32i = RGB32I,
            rgb32ui = RGB32UI,
            rgba8 = RGBA8,
            rgba16 = RGBA16,
            rgba16f = RGBA16F,
            rgba32f = RGBA32F,
            rgba8i = RGBA8I,
            rgba16i = RGBA16I,
            rgba32i = RGBA32I,
            rgba8ui = RGBA8UI,
            rgba16ui = RGBA16UI,
            rgba32ui = RGBA32UI,
        };

        const UniformParameter = enum(Enum) {
            //--------------------------------------------------------------------------------------
            // OpenGL 3.1 (Core Profile)
            //--------------------------------------------------------------------------------------
            uniform_type = UNIFORM_TYPE,
            uniform_size = UNIFORM_SIZE,
            uniform_name_length = UNIFORM_NAME_LENGTH,
            uniform_block_index = UNIFORM_BLOCK_INDEX,
            uniform_offset = UNIFORM_OFFSET,
            uniform_array_stride = UNIFORM_ARRAY_STRIDE,
            uniform_matrix_stride = UNIFORM_MATRIX_STRIDE,
            uniform_is_row_major = UNIFORM_IS_ROW_MAJOR,
            //--------------------------------------------------------------------------------------
            // OpenGL 4.2 (Core Profile)
            //--------------------------------------------------------------------------------------
            uniform_atomic_counter_buffer_index = UNIFORM_ATOMIC_COUNTER_BUFFER_INDEX,
        };

        const UniformBlockParameter = enum(Enum) {
            //--------------------------------------------------------------------------------------
            // OpenGL 3.1 (Core Profile)
            //--------------------------------------------------------------------------------------
            uniform_block_binding = UNIFORM_BLOCK_BINDING,
            uniform_block_data_size = UNIFORM_BLOCK_DATA_SIZE,
            uniform_block_name_length = UNIFORM_BLOCK_NAME_LENGTH,
            uniform_block_active_uniforms = UNIFORM_BLOCK_ACTIVE_UNIFORMS,
            uniform_block_active_uniform_indices = UNIFORM_BLOCK_ACTIVE_UNIFORM_INDICES,
            uniform_block_referenced_by_vertex_shader = UNIFORM_BLOCK_REFERENCED_BY_VERTEX_SHADER,
            uniform_block_referenced_by_fragment_shader = UNIFORM_BLOCK_REFERENCED_BY_FRAGMENT_SHADER,
            //--------------------------------------------------------------------------------------
            // OpenGL 3.2 (Core Profile)
            //--------------------------------------------------------------------------------------
            uniform_block_referenced_by_geometry_shader = UNIFORM_BLOCK_REFERENCED_BY_GEOMETRY_SHADER,
            //--------------------------------------------------------------------------------------
            // OpenGL 4.0 (Core Profile)
            //--------------------------------------------------------------------------------------
            uniform_block_referenced_by_tess_control_shader = UNIFORM_BLOCK_REFERENCED_BY_TESS_CONTROL_SHADER,
            uniform_block_referenced_by_tess_evaluation_shader = UNIFORM_BLOCK_REFERENCED_BY_TESS_EVALUATION_SHADER,
            //--------------------------------------------------------------------------------------
            // OpenGL 4.3 (Core Profile)
            //--------------------------------------------------------------------------------------
            uniform_block_referenced_by_compute_shader = UNIFORM_BLOCK_REFERENCED_BY_COMPUTE_SHADER,
        };

        pub const VertexProvokeMode = enum(Enum) {
            //--------------------------------------------------------------------------------------
            // OpenGL 3.2 (Core Profile)
            //--------------------------------------------------------------------------------------
            first_vertex_convention = FIRST_VERTEX_CONVENTION,
            last_vertex_convention = LAST_VERTEX_CONVENTION,
        };

        pub const SyncCondition = enum(Enum) {
            //--------------------------------------------------------------------------------------
            // OpenGL 3.2 (Core Profile)
            //--------------------------------------------------------------------------------------
            sync_gpu_commands_complete = SYNC_GPU_COMMANDS_COMPLETE,
        };

        pub const WaitSyncFlags = packed struct(Bitfield) {
            //--------------------------------------------------------------------------------------
            // OpenGL 3.2 (Core Profile)
            //--------------------------------------------------------------------------------------
            // SYNC_FLUSH_COMMANDS_BIT = 0x00000001 // 1st bit

            sync_flush_commands: bool = false,

            /// DO NOT WRITE
            pad: u31 = 0,

            // confirmation that memory layout is correct
            comptime {
                assert(@as(Bitfield, @bitCast(WaitSyncFlags{ .sync_flush_commands = true })) == SYNC_FLUSH_COMMANDS_BIT);
            }
        };

        pub const WaitSyncResult = enum(Enum) {
            //--------------------------------------------------------------------------------------
            // OpenGL 3.2 (Core Profile)
            //--------------------------------------------------------------------------------------
            already_signaled = ALREADY_SIGNALED,
            timeout_expired = TIMEOUT_EXPIRED,
            condition_satisfied = CONDITION_SATISFIED,
            // this value is reported as an WaitSyncError instead
            // wait_failed = WAIT_FAILED,
        };

        pub const WaitSyncError = error{
            //--------------------------------------------------------------------------------------
            // OpenGL 3.2 (Core Profile)
            //--------------------------------------------------------------------------------------
            Failed,
        };

        pub const WaitTimeout = enum(Uint64) {
            //--------------------------------------------------------------------------------------
            // OpenGL 3.2 (Core Profile)
            //--------------------------------------------------------------------------------------
            timeout_ignored = TIMEOUT_IGNORED,
        };

        pub const Int64Parameter = enum(Enum) {
            //--------------------------------------------------------------------------------------
            // OpenGL 3.2 (Core Profile)
            //--------------------------------------------------------------------------------------
            max_server_wait_timeout = MAX_SERVER_WAIT_TIMEOUT,
            //--------------------------------------------------------------------------------------
            // OpenGL 4.3 (Core Profile)
            //--------------------------------------------------------------------------------------
            max_element_index = MAX_ELEMENT_INDEX,
            max_shader_storage_block_size = MAX_SHADER_STORAGE_BLOCK_SIZE,
        };

        pub const SyncParameter = enum(Enum) {
            object_type = OBJECT_TYPE,
            sync_status = SYNC_STATUS,
            sync_condition = SYNC_CONDITION,
            sync_flags = SYNC_FLAGS,
        };

        pub const IndexedInt64Parameter = enum(Enum) {
            //--------------------------------------------------------------------------------------
            // OpenGL 3.2 (Core Profile)
            //--------------------------------------------------------------------------------------
            uniform_buffer_start = UNIFORM_BUFFER_START,
            uniform_buffer_size = UNIFORM_BUFFER_SIZE,
            transform_feedback_buffer_start = TRANSFORM_FEEDBACK_BUFFER_START,
            transform_feedback_buffer_size = TRANSFORM_FEEDBACK_BUFFER_SIZE,
            //--------------------------------------------------------------------------------------
            // OpenGL 4.2 (Core Profile)
            //--------------------------------------------------------------------------------------
            atomic_counter_buffer_start = ATOMIC_COUNTER_BUFFER_START,
            atomic_counter_buffer_size = ATOMIC_COUNTER_BUFFER_SIZE,
            //--------------------------------------------------------------------------------------
            // OpenGL 4.3 (Core Profile)
            //--------------------------------------------------------------------------------------
            vertex_binding_offset = VERTEX_BINDING_OFFSET,
            shader_storage_buffer_start = SHADER_STORAGE_BUFFER_START,
            shader_storage_buffer_size = SHADER_STORAGE_BUFFER_SIZE,
        };

        pub const TexImage2DMultisampleTarget = enum(Enum) {
            //--------------------------------------------------------------------------------------
            // OpenGL 3.2 (Core Profile)
            //--------------------------------------------------------------------------------------
            texture_2d_multisample = TEXTURE_2D_MULTISAMPLE,
            proxy_texture_2d_multisample = PROXY_TEXTURE_2D_MULTISAMPLE,
        };

        pub const TexImage3DMultisampleTarget = enum(Enum) {
            //--------------------------------------------------------------------------------------
            // OpenGL 3.2 (Core Profile)
            //--------------------------------------------------------------------------------------
            texture_2d_multisample_array = TEXTURE_2D_MULTISAMPLE_ARRAY,
            proxy_texture_2d_multisample_array = PROXY_TEXTURE_2D_MULTISAMPLE_ARRAY,
        };

        pub const MultisampleParameter = enum(Enum) {
            //--------------------------------------------------------------------------------------
            // OpenGL 3.2 (Core Profile)
            //--------------------------------------------------------------------------------------
            sample_position = SAMPLE_POSITION,
        };

        pub const SamplerParameter = enum(Enum) {
            //--------------------------------------------------------------------------------------
            // OpenGL 3.3 (Core Profile)
            //--------------------------------------------------------------------------------------
            texture_wrap_s = TEXTURE_WRAP_S,
            texture_wrap_t = TEXTURE_WRAP_T,
            texture_wrap_r = TEXTURE_WRAP_R,
            texture_min_filter = TEXTURE_MIN_FILTER,
            texture_mag_filter = TEXTURE_MAG_FILTER,
            texture_border_color = TEXTURE_BORDER_COLOR,
            texture_min_lod = TEXTURE_MIN_LOD,
            texture_max_lod = TEXTURE_MAX_LOD,
            texture_lod_bias = TEXTURE_LOD_BIAS,
            texture_compare_mode = TEXTURE_COMPARE_MODE,
            texture_compare_func = TEXTURE_COMPARE_FUNC,
            //--------------------------------------------------------------------------------------
            // OpenGL 4.6 (Core Profile)
            //--------------------------------------------------------------------------------------
            texture_max_anisotropy = TEXTURE_MAX_ANISOTROPY,
        };

        pub const QueryCounterTarget = enum(Enum) {
            //--------------------------------------------------------------------------------------
            // OpenGL 3.3 (Core Profile)
            //--------------------------------------------------------------------------------------
            timestamp = TIMESTAMP,
        };

        pub const VertexAttribPackedType = enum(Enum) {
            //--------------------------------------------------------------------------------------
            // OpenGL 3.3 (Core Profile)
            //--------------------------------------------------------------------------------------
            int_2_10_10_10_rev = INT_2_10_10_10_REV,
            unsigned_int_2_10_10_10_rev = UNSIGNED_INT_2_10_10_10_REV,
            //--------------------------------------------------------------------------------------
            // OpenGL 4.4 (Core Profile)
            //--------------------------------------------------------------------------------------
            unsigned_int_10f_11f_11f_rev = UNSIGNED_INT_10F_11F_11F_REV,
        };

        pub const DrawArraysIndirectCommand = extern struct {
            //--------------------------------------------------------------------------------------
            // OpenGL 4.0 (Core Profile)
            //--------------------------------------------------------------------------------------
            count: u32,
            instance_count: u32,
            first: u32,
            //--------------------------------------------------------------------------------------
            // OpenGL 4.2 (Core Profile)
            //--------------------------------------------------------------------------------------
            /// must be zero if used before OpenGL 4.2
            base_instance: u32 = 0,
        };

        pub const DrawElementsIndirectCommand = extern struct {
            //--------------------------------------------------------------------------------------
            // OpenGL 4.0 (Core Profile)
            //--------------------------------------------------------------------------------------
            count: u32,
            instance_count: u32,
            first_index: u32,
            base_vertex: i32,
            //--------------------------------------------------------------------------------------
            // OpenGL 4.2 (Core Profile)
            //--------------------------------------------------------------------------------------
            /// must be zero if used before OpenGL 4.2
            base_instance: u32 = 0,
        };

        pub const SubroutineUniformParameter = enum(Enum) {
            //--------------------------------------------------------------------------------------
            // OpenGL 4.0 (Core Profile)
            //--------------------------------------------------------------------------------------
            num_compatible_subroutines = NUM_COMPATIBLE_SUBROUTINES,
            compatible_subroutines = COMPATIBLE_SUBROUTINES,
            uniform_size = UNIFORM_SIZE,
            uniform_name_length = UNIFORM_NAME_LENGTH,
        };

        pub const ProgramStageParameter = enum(Enum) {
            //--------------------------------------------------------------------------------------
            // OpenGL 4.0 (Core Profile)
            //--------------------------------------------------------------------------------------
            active_subroutine_uniform_locations = ACTIVE_SUBROUTINE_UNIFORM_LOCATIONS,
            active_subroutine_uniforms = ACTIVE_SUBROUTINE_UNIFORMS,
            active_subroutines = ACTIVE_SUBROUTINES,
            active_subroutine_uniform_max_length = ACTIVE_SUBROUTINE_UNIFORM_MAX_LENGTH,
            active_subroutine_max_length = ACTIVE_SUBROUTINE_MAX_LENGTH,
        };

        pub const PatchIntegerParameter = enum(Enum) {
            //--------------------------------------------------------------------------------------
            // OpenGL 4.0 (Core Profile)
            //--------------------------------------------------------------------------------------
            patch_vertices = PATCH_VERTICES,
        };

        pub const PatchFloatParameter = enum(Enum) {
            //--------------------------------------------------------------------------------------
            // OpenGL 4.0 (Core Profile)
            //--------------------------------------------------------------------------------------
            patch_default_outer_level = PATCH_DEFAULT_OUTER_LEVEL,
            patch_default_inner_level = PATCH_DEFAULT_INNER_LEVEL,
        };

        pub const TransformFeedbackTarget = enum(Enum) {
            //--------------------------------------------------------------------------------------
            // OpenGL 4.0 (Core Profile)
            //--------------------------------------------------------------------------------------
            transform_feedback = TRANSFORM_FEEDBACK,
        };

        pub const ShaderPrecisionFormat = enum(Enum) {
            //--------------------------------------------------------------------------------------
            // OpenGL 4.1 (Core Profile)
            //--------------------------------------------------------------------------------------
            low_float = LOW_FLOAT,
            medium_float = MEDIUM_FLOAT,
            high_float = HIGH_FLOAT,
            low_int = LOW_INT,
            medium_int = MEDIUM_INT,
            high_int = HIGH_INT,
        };

        pub const ShaderBinaryFormat = enum(Enum) {
            //--------------------------------------------------------------------------------------
            // OpenGL 4.1 (Core Profile)
            //--------------------------------------------------------------------------------------
            // some shader binary formats are vendor specific (non-exaustive enum)
            //--------------------------------------------------------------------------------------
            // OpenGL 4.6 (Core Profile)
            //--------------------------------------------------------------------------------------
            shader_binary_format_spir_v = SHADER_BINARY_FORMAT_SPIR_V,
            _,
        };

        pub const ProgramBinaryFormat = enum(Enum) {
            //--------------------------------------------------------------------------------------
            // OpenGL 4.1 (Core Profile)
            //--------------------------------------------------------------------------------------
            // program binary formats are vendor specific (non-exaustive enum)
            _,
        };

        pub const ProgramParameterModifiable = enum(Enum) {
            //--------------------------------------------------------------------------------------
            // OpenGL 4.1 (Core Profile)
            //--------------------------------------------------------------------------------------
            program_separable = PROGRAM_SEPARABLE,
        };

        pub const UsedProgramStages = packed struct(Bitfield) {
            //--------------------------------------------------------------------------------------
            // OpenGL 4.1 (Core Profile)
            //--------------------------------------------------------------------------------------
            // VERTEX_SHADER_BIT          = 0x00000001 // 1st bit
            // FRAGMENT_SHADER_BIT        = 0x00000002 // 2nd bit
            // GEOMETRY_SHADER_BIT        = 0x00000004 // 3rd bit
            // TESS_CONTROL_SHADER_BIT    = 0x00000008 // 4th bit
            // TESS_EVALUATION_SHADER_BIT = 0x00000010 // 5th bit
            // ALL_SHADER_BITS            = 0xFFFFFFFF // implemented using all() function
            //--------------------------------------------------------------------------------------
            // OpenGL 4.3 (Core Profile)
            //--------------------------------------------------------------------------------------
            // COMPUTE_SHADER_BIT         = 0x00000020 // 6th bit

            vertex_shader: bool = false,
            fragment_shader: bool = false,
            geometry_shader: bool = false,
            tess_control_shader: bool = false,
            tess_evaluation_shader: bool = false,
            compute_shader: bool = false,

            /// DO NOT WRITE
            pad: u26 = 0,

            pub fn all() UsedProgramStages {
                return @bitCast(
                    @as(Bitfield, ALL_SHADER_BITS),
                );
            }

            // confirmation that memory layout is correct
            comptime {
                assert(@as(Bitfield, @bitCast(UsedProgramStages{ .vertex_shader = true })) == VERTEX_SHADER_BIT);
                assert(@as(Bitfield, @bitCast(UsedProgramStages{ .fragment_shader = true })) == FRAGMENT_SHADER_BIT);
                assert(@as(Bitfield, @bitCast(UsedProgramStages{ .geometry_shader = true })) == GEOMETRY_SHADER_BIT);
                assert(@as(Bitfield, @bitCast(UsedProgramStages{ .tess_control_shader = true })) == TESS_CONTROL_SHADER_BIT);
                assert(@as(Bitfield, @bitCast(UsedProgramStages{ .tess_evaluation_shader = true })) == TESS_EVALUATION_SHADER_BIT);
                assert(@as(Bitfield, @bitCast(UsedProgramStages{ .compute_shader = true })) == COMPUTE_SHADER_BIT);
                assert(@as(Bitfield, @bitCast(UsedProgramStages.all())) == ALL_SHADER_BITS);
            }
        };

        pub const ProgramPipelineParameter = enum(Enum) {
            //--------------------------------------------------------------------------------------
            // OpenGL 4.1 (Core Profile)
            //--------------------------------------------------------------------------------------
            active_program = ACTIVE_PROGRAM,
            vertex_shader = VERTEX_SHADER,
            fragment_shader = FRAGMENT_SHADER,
            geometry_shader = GEOMETRY_SHADER,
            tess_control_shader = TESS_CONTROL_SHADER,
            tess_evaluation_shader = TESS_EVALUATION_SHADER,
            info_log_length = INFO_LOG_LENGTH,
            //--------------------------------------------------------------------------------------
            // OpenGL 4.2 (Core Profile)
            //--------------------------------------------------------------------------------------
            validate_status = VALIDATE_STATUS,
            //--------------------------------------------------------------------------------------
            // OpenGL 4.3 (Core Profile)
            //--------------------------------------------------------------------------------------
            compute_shader = COMPUTE_SHADER,
        };

        pub const VertexAttribDoubleType = enum(Enum) {
            //--------------------------------------------------------------------------------------
            // OpenGL 4.1 (Core Profile)
            //--------------------------------------------------------------------------------------
            double = DOUBLE,
        };

        pub const VertexAttribDoubleParameter = enum(Enum) {
            //--------------------------------------------------------------------------------------
            // OpenGL 4.1 (Core Profile)
            //--------------------------------------------------------------------------------------
            current_vertex_attrib = CURRENT_VERTEX_ATTRIB,
        };

        pub const IndexedFloatParameter = enum(Enum) {
            //--------------------------------------------------------------------------------------
            // OpenGL 4.1 (Core Profile)
            //--------------------------------------------------------------------------------------
            viewport = VIEWPORT,
        };

        pub const IndexedDoubleParameter = enum(Enum) {
            //--------------------------------------------------------------------------------------
            // OpenGL 4.1 (Core Profile)
            //--------------------------------------------------------------------------------------
            depth_range = DEPTH_RANGE,
        };

        pub const InternalFormatTarget = enum(Enum) {
            //--------------------------------------------------------------------------------------
            // OpenGL 4.2 (Core Profile)
            //--------------------------------------------------------------------------------------
            renderbuffer = RENDERBUFFER,
            texture_2d_multisample = TEXTURE_2D_MULTISAMPLE,
            texture_2d_multisample_array = TEXTURE_2D_MULTISAMPLE_ARRAY,
            //--------------------------------------------------------------------------------------
            // OpenGL 4.3 (Core Profile)
            //--------------------------------------------------------------------------------------
            texture_1d = TEXTURE_1D,
            texture_1d_array = TEXTURE_1D_ARRAY,
            texture_2d = TEXTURE_2D,
            texture_2d_array = TEXTURE_2D_ARRAY,
            texture_3d = TEXTURE_3D,
            texture_buffer = TEXTURE_BUFFER,
            texture_cube_map = TEXTURE_CUBE_MAP,
            texture_cube_map_array = TEXTURE_CUBE_MAP_ARRAY,
            texture_rectangle = TEXTURE_RECTANGLE,
        };

        pub const InternalFormatAny = enum(Enum) {
            //--------------------------------------------------------------------------------------
            // OpenGL 4.2 (Core Profile)
            //--------------------------------------------------------------------------------------
            red = RED,
            rg = RG,
            rgb = RGB,
            rgba = RGBA,
            depth_component = DEPTH_COMPONENT,
            stencil_index = STENCIL_INDEX,
            r3_g3_b2 = R3_G3_B2,
            rgb4 = RGB4,
            rgb5 = RGB5,
            rgb8 = RGB8,
            rgb10 = RGB10,
            rgb12 = RGB12,
            rgb16 = RGB16,
            rgba2 = RGBA2,
            rgba4 = RGBA4,
            rgb5_a1 = RGB5_A1,
            rgba8 = RGBA8,
            rgb10_a2 = RGB10_A2,
            rgba12 = RGBA12,
            rgba16 = RGBA16,
            bgr = BGR,
            bgra = BGRA,
            depth_component16 = DEPTH_COMPONENT16,
            depth_component24 = DEPTH_COMPONENT24,
            depth_component32 = DEPTH_COMPONENT32,
            srgb8 = SRGB8,
            srgb8_alpha8 = SRGB8_ALPHA8,
            red_integer = RED_INTEGER,
            rg_integer = RG_INTEGER,
            rgb_integer = RGB_INTEGER,
            bgr_integer = BGR_INTEGER,
            rgba_integer = RGBA_INTEGER,
            bgra_integer = BGRA_INTEGER,
            r8 = R8,
            r16 = R16,
            rg8 = RG8,
            rg16 = RG16,
            r16f = R16F,
            rg16f = RG16F,
            rgb16f = RGB16F,
            rgba16f = RGBA16F,
            r32f = R32F,
            rg32f = RG32F,
            rgb32f = RGB32F,
            rgba32f = RGBA32F,
            r11f_g11f_b10f = R11F_G11F_B10F,
            rgb9_e5 = RGB9_E5,
            r8i = R8I,
            r8ui = R8UI,
            r16i = R16I,
            r16ui = R16UI,
            r32i = R32I,
            r32ui = R32UI,
            rg8i = RG8I,
            rg8ui = RG8UI,
            rg16i = RG16I,
            rg16ui = RG16UI,
            rg32i = RG32I,
            rg32ui = RG32UI,
            rgb8i = RGB8I,
            rgb8ui = RGB8UI,
            rgb16i = RGB16I,
            rgb16ui = RGB16UI,
            rgb32i = RGB32I,
            rgb32ui = RGB32UI,
            rgba8i = RGBA8I,
            rgba8ui = RGBA8UI,
            rgba16i = RGBA16I,
            rgba16ui = RGBA16UI,
            rgba32i = RGBA32I,
            rgba32ui = RGBA32UI,
            depth_component32f = DEPTH_COMPONENT32F,
            depth24_stencil8 = DEPTH24_STENCIL8,
            depth32f_stencil8 = DEPTH32F_STENCIL8,
            r8_snorm = R8_SNORM,
            r16_snorm = R16_SNORM,
            rg8_snorm = RG8_SNORM,
            rg16_snorm = RG16_SNORM,
            rgb8_snorm = RGB8_SNORM,
            rgb16_snorm = RGB16_SNORM,
            rgba8_snorm = RGBA8_SNORM,
            rgba16_snorm = RGBA16_SNORM,
            rgb10_a2ui = RGB10_A2UI,
            rgb565 = RGB565,
            compressed_rgba_bptc_unorm = COMPRESSED_RGBA_BPTC_UNORM,
            compressed_srgb_alpha_bptc_unorm = COMPRESSED_SRGB_ALPHA_BPTC_UNORM,
            compressed_rgb_bptc_signed_float = COMPRESSED_RGB_BPTC_SIGNED_FLOAT,
            compressed_rgb_bptc_unsigned_float = COMPRESSED_RGB_BPTC_UNSIGNED_FLOAT,
            // for getInternalformat*v specification states that any value can
            // be passed as 'internalformat' parameter which vendors might use
            // for their own formats not listed in the OpenGL specification
            _,
        };

        pub const InternalFormatParameter = enum(Enum) {
            //--------------------------------------------------------------------------------------
            // OpenGL 4.2 (Core Profile)
            //--------------------------------------------------------------------------------------
            num_sample_counts = NUM_SAMPLE_COUNTS,
            samples = SAMPLES,
            //--------------------------------------------------------------------------------------
            // OpenGL 4.3 (Core Profile)
            //--------------------------------------------------------------------------------------
            internalformat_preferred = INTERNALFORMAT_PREFERRED,
            internalformat_red_size = INTERNALFORMAT_RED_SIZE,
            internalformat_green_size = INTERNALFORMAT_GREEN_SIZE,
            internalformat_blue_size = INTERNALFORMAT_BLUE_SIZE,
            internalformat_alpha_size = INTERNALFORMAT_ALPHA_SIZE,
            internalformat_depth_size = INTERNALFORMAT_DEPTH_SIZE,
            internalformat_stencil_size = INTERNALFORMAT_STENCIL_SIZE,
            internalformat_shared_size = INTERNALFORMAT_SHARED_SIZE,
            internalformat_red_type = INTERNALFORMAT_RED_TYPE,
            internalformat_green_type = INTERNALFORMAT_GREEN_TYPE,
            internalformat_blue_type = INTERNALFORMAT_BLUE_TYPE,
            internalformat_alpha_type = INTERNALFORMAT_ALPHA_TYPE,
            internalformat_depth_type = INTERNALFORMAT_DEPTH_TYPE,
            internalformat_stencil_type = INTERNALFORMAT_STENCIL_TYPE,
            max_width = MAX_WIDTH,
            max_height = MAX_HEIGHT,
            max_depth = MAX_DEPTH,
            max_layers = MAX_LAYERS,
            max_combined_dimensions = MAX_COMBINED_DIMENSIONS,
            color_components = COLOR_COMPONENTS,
            depth_components = DEPTH_COMPONENTS,
            stencil_components = STENCIL_COMPONENTS,
            color_renderable = COLOR_RENDERABLE,
            depth_renderable = DEPTH_RENDERABLE,
            stencil_renderable = STENCIL_RENDERABLE,
            framebuffer_renderable = FRAMEBUFFER_RENDERABLE,
            framebuffer_renderable_layered = FRAMEBUFFER_RENDERABLE_LAYERED,
            framebuffer_blend = FRAMEBUFFER_BLEND,
            read_pixels = READ_PIXELS,
            read_pixels_format = READ_PIXELS_FORMAT,
            read_pixels_type = READ_PIXELS_TYPE,
            texture_image_format = TEXTURE_IMAGE_FORMAT,
            texture_image_type = TEXTURE_IMAGE_TYPE,
            get_texture_image_format = GET_TEXTURE_IMAGE_FORMAT,
            get_texture_image_type = GET_TEXTURE_IMAGE_TYPE,
            mipmap = MIPMAP,
            manual_generate_mipmap = MANUAL_GENERATE_MIPMAP,
            color_encoding = COLOR_ENCODING,
            srgb_read = SRGB_READ,
            srgb_write = SRGB_WRITE,
            filter = FILTER,
            vertex_texture = VERTEX_TEXTURE,
            tess_control_texture = TESS_CONTROL_TEXTURE,
            tess_evaluation_texture = TESS_EVALUATION_TEXTURE,
            geometry_texture = GEOMETRY_TEXTURE,
            fragment_texture = FRAGMENT_TEXTURE,
            compute_texture = COMPUTE_TEXTURE,
            texture_shadow = TEXTURE_SHADOW,
            texture_gather = TEXTURE_GATHER,
            texture_gather_shadow = TEXTURE_GATHER_SHADOW,
            shader_image_load = SHADER_IMAGE_LOAD,
            shader_image_store = SHADER_IMAGE_STORE,
            shader_image_atomic = SHADER_IMAGE_ATOMIC,
            image_texel_size = IMAGE_TEXEL_SIZE,
            image_compatibility_class = IMAGE_COMPATIBILITY_CLASS,
            image_pixel_format = IMAGE_PIXEL_FORMAT,
            image_pixel_type = IMAGE_PIXEL_TYPE,
            image_format_compatibility_type = IMAGE_FORMAT_COMPATIBILITY_TYPE,
            simultaneous_texture_and_depth_test = SIMULTANEOUS_TEXTURE_AND_DEPTH_TEST,
            simultaneous_texture_and_stencil_test = SIMULTANEOUS_TEXTURE_AND_STENCIL_TEST,
            simultaneous_texture_and_depth_write = SIMULTANEOUS_TEXTURE_AND_DEPTH_WRITE,
            simultaneous_texture_and_stencil_write = SIMULTANEOUS_TEXTURE_AND_STENCIL_WRITE,
            texture_compressed = TEXTURE_COMPRESSED,
            texture_compressed_block_width = TEXTURE_COMPRESSED_BLOCK_WIDTH,
            texture_compressed_block_height = TEXTURE_COMPRESSED_BLOCK_HEIGHT,
            texture_compressed_block_size = TEXTURE_COMPRESSED_BLOCK_SIZE,
            clear_buffer = CLEAR_BUFFER,
            texture_view = TEXTURE_VIEW,
            view_compatibility_class = VIEW_COMPATIBILITY_CLASS,
            //--------------------------------------------------------------------------------------
            // OpenGL 4.4 (Core Profile)
            //--------------------------------------------------------------------------------------
            clear_texture = CLEAR_TEXTURE,
        };

        pub const AtomicCounterBufferParameter = enum(Enum) {
            //--------------------------------------------------------------------------------------
            // OpenGL 4.2 (Core Profile)
            //--------------------------------------------------------------------------------------
            atomic_counter_buffer_binding = ATOMIC_COUNTER_BUFFER_BINDING,
            atomic_counter_buffer_data_size = ATOMIC_COUNTER_BUFFER_DATA_SIZE,
            atomic_counter_buffer_active_atomic_counters = ATOMIC_COUNTER_BUFFER_ACTIVE_ATOMIC_COUNTERS,
            atomic_counter_buffer_active_atomic_counter_indices = ATOMIC_COUNTER_BUFFER_ACTIVE_ATOMIC_COUNTER_INDICES,
            atomic_counter_buffer_referenced_by_vertex_shader = ATOMIC_COUNTER_BUFFER_REFERENCED_BY_VERTEX_SHADER,
            atomic_counter_buffer_referenced_by_tess_control_shader = ATOMIC_COUNTER_BUFFER_REFERENCED_BY_TESS_CONTROL_SHADER,
            atomic_counter_buffer_referenced_by_tess_evaluation_shader = ATOMIC_COUNTER_BUFFER_REFERENCED_BY_TESS_EVALUATION_SHADER,
            atomic_counter_buffer_referenced_by_geometry_shader = ATOMIC_COUNTER_BUFFER_REFERENCED_BY_GEOMETRY_SHADER,
            atomic_counter_buffer_referenced_by_fragment_shader = ATOMIC_COUNTER_BUFFER_REFERENCED_BY_FRAGMENT_SHADER,
            //--------------------------------------------------------------------------------------
            // OpenGL 4.3 (Core Profile)
            //--------------------------------------------------------------------------------------
            atomic_counter_buffer_referenced_by_compute_shader = ATOMIC_COUNTER_BUFFER_REFERENCED_BY_COMPUTE_SHADER,
        };

        pub const ImageUnitFormat = enum(Enum) {
            //--------------------------------------------------------------------------------------
            // OpenGL 4.2 (Core Profile)
            //--------------------------------------------------------------------------------------
            rgba32f = RGBA32F,
            rgba16f = RGBA16F,
            rg32f = RG32F,
            rg16f = RG16F,
            r11f_g11f_b10f = R11F_G11F_B10F,
            r32f = R32F,
            r16f = R16F,
            rgba32ui = RGBA32UI,
            rgba16ui = RGBA16UI,
            rgb10_a2ui = RGB10_A2UI,
            rgba8ui = RGBA8UI,
            rg32ui = RG32UI,
            rg16ui = RG16UI,
            rg8ui = RG8UI,
            r32ui = R32UI,
            r16ui = R16UI,
            r8ui = R8UI,
            rgba32i = RGBA32I,
            rgba16i = RGBA16I,
            rgba8i = RGBA8I,
            rg32i = RG32I,
            rg16i = RG16I,
            rg8i = RG8I,
            r32i = R32I,
            r16i = R16I,
            r8i = R8I,
            rgba16 = RGBA16,
            rgb10_a2 = RGB10_A2,
            rgba8 = RGBA8,
            rg16 = RG16,
            rg8 = RG8,
            r16 = R16,
            r8 = R8,
            rgba16_snorm = RGBA16_SNORM,
            rgba8_snorm = RGBA8_SNORM,
            rg16_snorm = RG16_SNORM,
            rg8_snorm = RG8_SNORM,
            r16_snorm = R16_SNORM,
            r8_snorm = R8_SNORM,
        };

        pub const UsedBarriers = packed struct(Bitfield) {
            //--------------------------------------------------------------------------------------
            // OpenGL 4.2 (Core Profile)
            //--------------------------------------------------------------------------------------
            // VERTEX_ATTRIB_ARRAY_BARRIER_BIT  = 0x00000001 // 1st bit
            // ELEMENT_ARRAY_BARRIER_BIT        = 0x00000002 // 2nd bit
            // UNIFORM_BARRIER_BIT              = 0x00000004 // 3rd bit
            // TEXTURE_FETCH_BARRIER_BIT        = 0x00000008 // 4th bit
            // SHADER_IMAGE_ACCESS_BARRIER_BIT  = 0x00000020 // 6th bit
            // COMMAND_BARRIER_BIT              = 0x00000040 // 7th bit
            // PIXEL_BUFFER_BARRIER_BIT         = 0x00000080 // 8th bit
            // TEXTURE_UPDATE_BARRIER_BIT       = 0x00000100 // 9th bit
            // BUFFER_UPDATE_BARRIER_BIT        = 0x00000200 // 10th bit
            // FRAMEBUFFER_BARRIER_BIT          = 0x00000400 // 11th bit
            // TRANSFORM_FEEDBACK_BARRIER_BIT   = 0x00000800 // 12th bit
            // ATOMIC_COUNTER_BARRIER_BIT       = 0x00001000 // 13th bit
            // ALL_BARRIER_BITS                 = 0xFFFFFFFF // implemented using all() function
            //--------------------------------------------------------------------------------------
            // OpenGL 4.3 (Core Profile)
            //--------------------------------------------------------------------------------------
            // SHADER_STORAGE_BARRIER_BIT       = 0x00002000 // 14th bit
            //--------------------------------------------------------------------------------------
            // OpenGL 4.4 (Core Profile)
            //--------------------------------------------------------------------------------------
            // CLIENT_MAPPED_BUFFER_BARRIER_BIT = 0x00004000 // 15th bit
            // QUERY_BUFFER_BARRIER_BIT         = 0x00008000 // 16th bit

            vertex_attrib_array_barrier: bool = false,
            element_array_barrier: bool = false,
            uniform_barrier: bool = false,
            texture_fetch_barrier: bool = false,

            /// DO NOT WRITE
            pad1: u1 = 0,

            shader_image_access_barrier: bool = false,
            command_barrier: bool = false,
            pixel_buffer_barrier: bool = false,
            texture_update_barrier: bool = false,
            buffer_update_barrier: bool = false,
            framebuffer_barrier: bool = false,
            transform_feedback_barrier: bool = false,
            atomic_counter_barrier: bool = false,
            shader_storage_barrier: bool = false,
            client_mapped_buffer_barrier: bool = false,
            query_buffer_barrier: bool = false,

            /// DO NOT WRITE
            pad2: u16 = 0,

            pub fn all() UsedBarriers {
                return @bitCast(
                    @as(Bitfield, ALL_BARRIER_BITS),
                );
            }

            // confirmation that memory layout is correct
            comptime {
                assert(@as(Bitfield, @bitCast(UsedBarriers{ .vertex_attrib_array_barrier = true })) == VERTEX_ATTRIB_ARRAY_BARRIER_BIT);
                assert(@as(Bitfield, @bitCast(UsedBarriers{ .element_array_barrier = true })) == ELEMENT_ARRAY_BARRIER_BIT);
                assert(@as(Bitfield, @bitCast(UsedBarriers{ .uniform_barrier = true })) == UNIFORM_BARRIER_BIT);
                assert(@as(Bitfield, @bitCast(UsedBarriers{ .texture_fetch_barrier = true })) == TEXTURE_FETCH_BARRIER_BIT);
                assert(@as(Bitfield, @bitCast(UsedBarriers{ .shader_image_access_barrier = true })) == SHADER_IMAGE_ACCESS_BARRIER_BIT);
                assert(@as(Bitfield, @bitCast(UsedBarriers{ .command_barrier = true })) == COMMAND_BARRIER_BIT);
                assert(@as(Bitfield, @bitCast(UsedBarriers{ .pixel_buffer_barrier = true })) == PIXEL_BUFFER_BARRIER_BIT);
                assert(@as(Bitfield, @bitCast(UsedBarriers{ .texture_update_barrier = true })) == TEXTURE_UPDATE_BARRIER_BIT);
                assert(@as(Bitfield, @bitCast(UsedBarriers{ .buffer_update_barrier = true })) == BUFFER_UPDATE_BARRIER_BIT);
                assert(@as(Bitfield, @bitCast(UsedBarriers{ .framebuffer_barrier = true })) == FRAMEBUFFER_BARRIER_BIT);
                assert(@as(Bitfield, @bitCast(UsedBarriers{ .transform_feedback_barrier = true })) == TRANSFORM_FEEDBACK_BARRIER_BIT);
                assert(@as(Bitfield, @bitCast(UsedBarriers{ .atomic_counter_barrier = true })) == ATOMIC_COUNTER_BARRIER_BIT);
                assert(@as(Bitfield, @bitCast(UsedBarriers{ .shader_storage_barrier = true })) == SHADER_STORAGE_BARRIER_BIT);
                assert(@as(Bitfield, @bitCast(UsedBarriers{ .client_mapped_buffer_barrier = true })) == CLIENT_MAPPED_BUFFER_BARRIER_BIT);
                assert(@as(Bitfield, @bitCast(UsedBarriers{ .query_buffer_barrier = true })) == QUERY_BUFFER_BARRIER_BIT);
                assert(@as(Bitfield, @bitCast(UsedBarriers.all())) == ALL_BARRIER_BITS);
            }
        };

        pub const CopyImageTextureTarget = enum(Enum) {
            //--------------------------------------------------------------------------------------
            // OpenGL 4.3 (Core Profile)
            //--------------------------------------------------------------------------------------
            texture_1d = TEXTURE_1D,
            texture_2d = TEXTURE_2D,
            texture_3d = TEXTURE_3D,
            texture_cube_map = TEXTURE_CUBE_MAP,
            texture_1d_array = TEXTURE_1D_ARRAY,
            texture_2d_array = TEXTURE_2D_ARRAY,
            texture_rectangle = TEXTURE_RECTANGLE,
            texture_2d_multisample = TEXTURE_2D_MULTISAMPLE,
            texture_2d_multisample_array = TEXTURE_2D_MULTISAMPLE_ARRAY,
            texture_cube_map_array = TEXTURE_CUBE_MAP_ARRAY,
        };

        pub const FramebufferParameter = enum(Enum) {
            //--------------------------------------------------------------------------------------
            // OpenGL 4.3 (Core Profile)
            //--------------------------------------------------------------------------------------
            framebuffer_default_width = FRAMEBUFFER_DEFAULT_WIDTH,
            framebuffer_default_height = FRAMEBUFFER_DEFAULT_HEIGHT,
            framebuffer_default_layers = FRAMEBUFFER_DEFAULT_LAYERS,
            framebuffer_default_samples = FRAMEBUFFER_DEFAULT_SAMPLES,
            framebuffer_default_fixed_sample_locations = FRAMEBUFFER_DEFAULT_FIXED_SAMPLE_LOCATIONS,
        };

        pub const GetFramebufferParameter = enum(Enum) {
            //--------------------------------------------------------------------------------------
            // OpenGL 4.3 (Core Profile)
            //--------------------------------------------------------------------------------------
            framebuffer_default_width = FRAMEBUFFER_DEFAULT_WIDTH,
            framebuffer_default_height = FRAMEBUFFER_DEFAULT_HEIGHT,
            framebuffer_default_layers = FRAMEBUFFER_DEFAULT_LAYERS,
            framebuffer_default_samples = FRAMEBUFFER_DEFAULT_SAMPLES,
            framebuffer_default_fixed_sample_locations = FRAMEBUFFER_DEFAULT_FIXED_SAMPLE_LOCATIONS,
            //--------------------------------------------------------------------------------------
            // OpenGL 4.5 (Core Profile)
            //--------------------------------------------------------------------------------------
            doublebuffer = DOUBLEBUFFER,
            implementation_color_read_format = IMPLEMENTATION_COLOR_READ_FORMAT,
            implementation_color_read_type = IMPLEMENTATION_COLOR_READ_TYPE,
            samples = SAMPLES,
            sample_buffers = SAMPLE_BUFFERS,
            stereo = STEREO,
        };

        pub const ProgramInterface = enum(Enum) {
            //--------------------------------------------------------------------------------------
            // OpenGL 4.3 (Core Profile)
            //--------------------------------------------------------------------------------------
            uniform = UNIFORM,
            uniform_block = UNIFORM_BLOCK,
            atomic_counter_buffer = ATOMIC_COUNTER_BUFFER,
            program_input = PROGRAM_INPUT,
            program_output = PROGRAM_OUTPUT,
            vertex_subroutine = VERTEX_SUBROUTINE,
            tess_control_subroutine = TESS_CONTROL_SUBROUTINE,
            tess_evaluation_subroutine = TESS_EVALUATION_SUBROUTINE,
            geometry_subroutine = GEOMETRY_SUBROUTINE,
            fragment_subroutine = FRAGMENT_SUBROUTINE,
            compute_subroutine = COMPUTE_SUBROUTINE,
            vertex_subroutine_uniform = VERTEX_SUBROUTINE_UNIFORM,
            tess_control_subroutine_uniform = TESS_CONTROL_SUBROUTINE_UNIFORM,
            tess_evaluation_subroutine_uniform = TESS_EVALUATION_SUBROUTINE_UNIFORM,
            geometry_subroutine_uniform = GEOMETRY_SUBROUTINE_UNIFORM,
            fragment_subroutine_uniform = FRAGMENT_SUBROUTINE_UNIFORM,
            compute_subroutine_uniform = COMPUTE_SUBROUTINE_UNIFORM,
            transform_feedback_varying = TRANSFORM_FEEDBACK_VARYING,
            buffer_variable = BUFFER_VARIABLE,
            shader_storage_block = SHADER_STORAGE_BLOCK,
            //--------------------------------------------------------------------------------------
            // OpenGL 4.4 (Core Profile)
            //--------------------------------------------------------------------------------------
            transform_feedback_buffer = TRANSFORM_FEEDBACK_BUFFER,
        };

        pub const ProgramInterfaceParameter = enum(Enum) {
            //--------------------------------------------------------------------------------------
            // OpenGL 4.3 (Core Profile)
            //--------------------------------------------------------------------------------------
            active_resources = ACTIVE_RESOURCES,
            max_name_length = MAX_NAME_LENGTH,
            max_num_active_variables = MAX_NUM_ACTIVE_VARIABLES,
            max_num_compatible_subroutines = MAX_NUM_COMPATIBLE_SUBROUTINES,
        };

        pub const ProgramInterfaceWithName = enum(Enum) {
            //--------------------------------------------------------------------------------------
            // OpenGL 4.3 (Core Profile)
            //--------------------------------------------------------------------------------------
            uniform = UNIFORM,
            uniform_block = UNIFORM_BLOCK,
            program_input = PROGRAM_INPUT,
            program_output = PROGRAM_OUTPUT,
            vertex_subroutine = VERTEX_SUBROUTINE,
            tess_control_subroutine = TESS_CONTROL_SUBROUTINE,
            tess_evaluation_subroutine = TESS_EVALUATION_SUBROUTINE,
            geometry_subroutine = GEOMETRY_SUBROUTINE,
            fragment_subroutine = FRAGMENT_SUBROUTINE,
            compute_subroutine = COMPUTE_SUBROUTINE,
            vertex_subroutine_uniform = VERTEX_SUBROUTINE_UNIFORM,
            tess_control_subroutine_uniform = TESS_CONTROL_SUBROUTINE_UNIFORM,
            tess_evaluation_subroutine_uniform = TESS_EVALUATION_SUBROUTINE_UNIFORM,
            geometry_subroutine_uniform = GEOMETRY_SUBROUTINE_UNIFORM,
            fragment_subroutine_uniform = FRAGMENT_SUBROUTINE_UNIFORM,
            compute_subroutine_uniform = COMPUTE_SUBROUTINE_UNIFORM,
            transform_feedback_varying = TRANSFORM_FEEDBACK_VARYING,
            buffer_variable = BUFFER_VARIABLE,
            shader_storage_block = SHADER_STORAGE_BLOCK,
        };

        pub const ProgramResource = enum(Enum) {
            //--------------------------------------------------------------------------------------
            // OpenGL 4.3 (Core Profile)
            //--------------------------------------------------------------------------------------
            name_length = NAME_LENGTH,
            type = TYPE,
            array_size = ARRAY_SIZE,
            offset = OFFSET,
            block_index = BLOCK_INDEX,
            array_stride = ARRAY_STRIDE,
            matrix_stride = MATRIX_STRIDE,
            is_row_major = IS_ROW_MAJOR,
            atomic_counter_buffer_index = ATOMIC_COUNTER_BUFFER_INDEX,
            buffer_binding = BUFFER_BINDING,
            buffer_data_size = BUFFER_DATA_SIZE,
            num_active_variables = NUM_ACTIVE_VARIABLES,
            active_variables = ACTIVE_VARIABLES,
            referenced_by_vertex_shader = REFERENCED_BY_VERTEX_SHADER,
            referenced_by_tess_control_shader = REFERENCED_BY_TESS_CONTROL_SHADER,
            referenced_by_tess_evaluation_shader = REFERENCED_BY_TESS_EVALUATION_SHADER,
            referenced_by_geometry_shader = REFERENCED_BY_GEOMETRY_SHADER,
            referenced_by_fragment_shader = REFERENCED_BY_FRAGMENT_SHADER,
            referenced_by_compute_shader = REFERENCED_BY_COMPUTE_SHADER,
            num_compatible_subroutines = NUM_COMPATIBLE_SUBROUTINES,
            compatible_subroutines = COMPATIBLE_SUBROUTINES,
            top_level_array_size = TOP_LEVEL_ARRAY_SIZE,
            top_level_array_stride = TOP_LEVEL_ARRAY_STRIDE,
            location = LOCATION,
            location_index = LOCATION_INDEX,
            is_per_patch = IS_PER_PATCH,
            //--------------------------------------------------------------------------------------
            // OpenGL 4.4 (Core Profile)
            //--------------------------------------------------------------------------------------
            location_component = LOCATION_COMPONENT,
            transform_feedback_buffer_index = TRANSFORM_FEEDBACK_BUFFER_INDEX,
            transform_feedback_buffer_stride = TRANSFORM_FEEDBACK_BUFFER_STRIDE,
        };

        pub const ProgramInterfaceWithLocation = enum(Enum) {
            //--------------------------------------------------------------------------------------
            // OpenGL 4.3 (Core Profile)
            //--------------------------------------------------------------------------------------
            uniform = UNIFORM,
            program_input = PROGRAM_INPUT,
            program_output = PROGRAM_OUTPUT,
            vertex_subroutine_uniform = VERTEX_SUBROUTINE_UNIFORM,
            tess_control_subroutine_uniform = TESS_CONTROL_SUBROUTINE_UNIFORM,
            tess_evaluation_subroutine_uniform = TESS_EVALUATION_SUBROUTINE_UNIFORM,
            geometry_subroutine_uniform = GEOMETRY_SUBROUTINE_UNIFORM,
            fragment_subroutine_uniform = FRAGMENT_SUBROUTINE_UNIFORM,
            compute_subroutine_uniform = COMPUTE_SUBROUTINE_UNIFORM,
        };

        pub const ProgramInterfaceWithLocationIndex = enum(Enum) {
            //--------------------------------------------------------------------------------------
            // OpenGL 4.3 (Core Profile)
            //--------------------------------------------------------------------------------------
            program_output = PROGRAM_OUTPUT,
        };

        pub const TextureViewInternalFormat = enum(Enum) {
            //--------------------------------------------------------------------------------------
            // OpenGL 4.3 (Core Profile)
            //--------------------------------------------------------------------------------------
            rgba32f = RGBA32F,
            rgba32ui = RGBA32UI,
            rgba32i = RGBA32I,
            rgb32f = RGB32F,
            rgb32ui = RGB32UI,
            rgb32i = RGB32I,
            rgba16f = RGBA16F,
            rg32f = RG32F,
            rgba16ui = RGBA16UI,
            rg32ui = RG32UI,
            rgba16i = RGBA16I,
            rg32i = RG32I,
            rgba16 = RGBA16,
            rgba16_snorm = RGBA16_SNORM,
            rg16f = RG16F,
            r11f_g11f_b10f = R11F_G11F_B10F,
            r32f = R32F,
            rgb10_a2ui = RGB10_A2UI,
            rgba8ui = RGBA8UI,
            rg16ui = RG16UI,
            r32ui = R32UI,
            rgba8i = RGBA8I,
            rg16i = RG16I,
            r32i = R32I,
            rgb10_a2 = RGB10_A2,
            rgba8 = RGBA8,
            rg16 = RG16,
            rgba8_snorm = RGBA8_SNORM,
            rg16_snorm = RG16_SNORM,
            srgb8_alpha8 = SRGB8_ALPHA8,
            rgb9_e5 = RGB9_E5,
            rgb8 = RGB8,
            rgb8_snorm = RGB8_SNORM,
            srgb8 = SRGB8,
            rgb8ui = RGB8UI,
            r16f = R16F,
            rg8ui = RG8UI,
            r16ui = R16UI,
            rg8i = RG8I,
            r16i = R16I,
            rg8 = RG8,
            r16 = R16,
            rg8_snorm = RG8_SNORM,
            r16_snorm = R16_SNORM,
            r8ui = R8UI,
            r8i = R8I,
            r8 = R8,
            r8_snorm = R8_SNORM,
            compressed_red_rgtc1 = COMPRESSED_RED_RGTC1,
            compressed_signed_red_rgtc1 = COMPRESSED_SIGNED_RED_RGTC1,
            compressed_rg_rgtc2 = COMPRESSED_RG_RGTC2,
            compressed_signed_rg_rgtc2 = COMPRESSED_SIGNED_RG_RGTC2,
            compressed_rgba_bptc_unorm = COMPRESSED_RGBA_BPTC_UNORM,
            compressed_srgb_alpha_bptc_unorm = COMPRESSED_SRGB_ALPHA_BPTC_UNORM,
            compressed_rgb_bptc_signed_float = COMPRESSED_RGB_BPTC_SIGNED_FLOAT,
            compressed_rgb_bptc_unsigned_float = COMPRESSED_RGB_BPTC_UNSIGNED_FLOAT,
        };

        pub const DebugSourceWithDontCare = enum(Enum) {
            //--------------------------------------------------------------------------------------
            // OpenGL 4.3 (Core Profile)
            //--------------------------------------------------------------------------------------
            api = DEBUG_SOURCE_API,
            window_system = DEBUG_SOURCE_WINDOW_SYSTEM,
            shader_compiler = DEBUG_SOURCE_SHADER_COMPILER,
            third_party = DEBUG_SOURCE_THIRD_PARTY,
            application = DEBUG_SOURCE_APPLICATION,
            other = DEBUG_SOURCE_OTHER,
            dont_care = DONT_CARE,
        };

        pub const DebugTypeWithDontCare = enum(Enum) {
            //--------------------------------------------------------------------------------------
            // OpenGL 4.3 (Core Profile)
            //--------------------------------------------------------------------------------------
            @"error" = DEBUG_TYPE_ERROR,
            deprecated_behavior = DEBUG_TYPE_DEPRECATED_BEHAVIOR,
            undefined_behavior = DEBUG_TYPE_UNDEFINED_BEHAVIOR,
            portability = DEBUG_TYPE_PORTABILITY,
            performance = DEBUG_TYPE_PERFORMANCE,
            marker = DEBUG_TYPE_MARKER,
            push_group = DEBUG_TYPE_PUSH_GROUP,
            pop_group = DEBUG_TYPE_POP_GROUP,
            other = DEBUG_TYPE_OTHER,
            debug_severity_high = DEBUG_SEVERITY_HIGH,
            debug_severity_medium = DEBUG_SEVERITY_MEDIUM,
            debug_severity_low = DEBUG_SEVERITY_LOW,
            debug_severity_notification = DEBUG_SEVERITY_NOTIFICATION,
            dont_care = DONT_CARE,
        };

        pub const DebugSeverityWithDontCare = enum(Enum) {
            //--------------------------------------------------------------------------------------
            // OpenGL 4.3 (Core Profile)
            //--------------------------------------------------------------------------------------
            high = DEBUG_SEVERITY_HIGH,
            medium = DEBUG_SEVERITY_MEDIUM,
            low = DEBUG_SEVERITY_LOW,
            notification = DEBUG_SEVERITY_NOTIFICATION,
            dont_care = DONT_CARE,
        };

        pub const DebugSourceCustom = enum(Enum) {
            //--------------------------------------------------------------------------------------
            // OpenGL 4.3 (Core Profile)
            //--------------------------------------------------------------------------------------
            third_party = DEBUG_SOURCE_THIRD_PARTY,
            application = DEBUG_SOURCE_APPLICATION,
        };

        pub const DebugSource = enum(Enum) {
            //--------------------------------------------------------------------------------------
            // OpenGL 4.3 (Core Profile)
            //--------------------------------------------------------------------------------------
            api = DEBUG_SOURCE_API,
            window_system = DEBUG_SOURCE_WINDOW_SYSTEM,
            shader_compiler = DEBUG_SOURCE_SHADER_COMPILER,
            third_party = DEBUG_SOURCE_THIRD_PARTY,
            application = DEBUG_SOURCE_APPLICATION,
            other = DEBUG_SOURCE_OTHER,
        };

        pub const DebugType = enum(Enum) {
            //--------------------------------------------------------------------------------------
            // OpenGL 4.3 (Core Profile)
            //--------------------------------------------------------------------------------------
            @"error" = DEBUG_TYPE_ERROR,
            deprecated_behavior = DEBUG_TYPE_DEPRECATED_BEHAVIOR,
            undefined_behavior = DEBUG_TYPE_UNDEFINED_BEHAVIOR,
            portability = DEBUG_TYPE_PORTABILITY,
            performance = DEBUG_TYPE_PERFORMANCE,
            marker = DEBUG_TYPE_MARKER,
            push_group = DEBUG_TYPE_PUSH_GROUP,
            pop_group = DEBUG_TYPE_POP_GROUP,
            other = DEBUG_TYPE_OTHER,
            debug_severity_high = DEBUG_SEVERITY_HIGH,
            debug_severity_medium = DEBUG_SEVERITY_MEDIUM,
            debug_severity_low = DEBUG_SEVERITY_LOW,
            debug_severity_notification = DEBUG_SEVERITY_NOTIFICATION,
        };

        pub const DebugSeverity = enum(Enum) {
            //--------------------------------------------------------------------------------------
            // OpenGL 4.3 (Core Profile)
            //--------------------------------------------------------------------------------------
            high = DEBUG_SEVERITY_HIGH,
            medium = DEBUG_SEVERITY_MEDIUM,
            low = DEBUG_SEVERITY_LOW,
            notification = DEBUG_SEVERITY_NOTIFICATION,
        };

        pub const DebugObjectNamespace = enum(Enum) {
            //--------------------------------------------------------------------------------------
            // OpenGL 4.3 (Core Profile)
            //--------------------------------------------------------------------------------------
            buffer = BUFFER,
            framebuffer = FRAMEBUFFER,
            program_pipeline = PROGRAM_PIPELINE,
            program = PROGRAM,
            query = QUERY,
            renderbuffer = RENDERBUFFER,
            sampler = SAMPLER,
            shader = SHADER,
            texture = TEXTURE,
            transform_feedback = TRANSFORM_FEEDBACK,
            vertex_array = VERTEX_ARRAY,

            pub fn fromType(comptime T: type) DebugObjectNamespace {
                return switch (T) {
                    inline Buffer => .buffer,
                    inline Framebuffer => .framebuffer,
                    inline ProgramPipeline => .program_pipeline,
                    inline Program => .program,
                    inline Query => .query,
                    inline Renderbuffer => .renderbuffer,
                    inline Sampler => .sampler,
                    inline Shader => .shader,
                    inline Texture => .textue,
                    inline TransformFeedback => .transform_feedback,
                    inline VertexArrayObject => .vertex_array,
                    inline else => {
                        @compileError("parameter 'T' must be Buffer, Framebuffer " ++
                            "ProgramPipeline, Program, Query, Renderbuffer, Sampler " ++
                            "Shader, Texture, TransformFeedback or VertexArrayObject");
                    },
                };
            }
        };

        pub const DebugPointerParameter = enum(Enum) {
            //--------------------------------------------------------------------------------------
            // OpenGL 4.3 (Core Profile)
            //--------------------------------------------------------------------------------------
            debug_callback_function = DEBUG_CALLBACK_FUNCTION,
            debug_callback_user_param = DEBUG_CALLBACK_USER_PARAM,
        };

        pub const BufferStorageFlags = packed struct(Bitfield) {
            //--------------------------------------------------------------------------------------
            // OpenGL 4.4 (Core Profile)
            //--------------------------------------------------------------------------------------
            // MAP_READ_BIT        = 0x00000001 // 1st bit
            // MAP_WRITE_BIT       = 0x00000002 // 2nd bit
            // MAP_PERSISTENT_BIT  = 0x00000040 // 7th bit
            // MAP_COHERENT_BIT    = 0x00000080 // 8th bit
            // DYNAMIC_STORAGE_BIT = 0x00000100 // 9th bit
            // CLIENT_STORAGE_BIT  = 0x00000200 // 10th bit

            map_read: bool = false,
            map_write: bool = false,

            /// DO NOT WRITE
            pad1: u4 = 0,

            map_persistent: bool = false,
            map_coherent: bool = false,
            dynamic_storage: bool = false,
            client_storage: bool = false,

            /// DO NOT WRITE
            pad2: u22 = 0,

            // confirmation that memory layout is correct
            comptime {
                assert(@as(Bitfield, @bitCast(BufferStorageFlags{ .map_read = true })) == MAP_READ_BIT);
                assert(@as(Bitfield, @bitCast(BufferStorageFlags{ .map_write = true })) == MAP_WRITE_BIT);
                assert(@as(Bitfield, @bitCast(BufferStorageFlags{ .map_persistent = true })) == MAP_PERSISTENT_BIT);
                assert(@as(Bitfield, @bitCast(BufferStorageFlags{ .map_coherent = true })) == MAP_COHERENT_BIT);
                assert(@as(Bitfield, @bitCast(BufferStorageFlags{ .dynamic_storage = true })) == DYNAMIC_STORAGE_BIT);
                assert(@as(Bitfield, @bitCast(BufferStorageFlags{ .client_storage = true })) == CLIENT_STORAGE_BIT);
            }
        };

        pub const ClipOrigin = enum(Enum) {
            //--------------------------------------------------------------------------------------
            // OpenGL 4.5 (Core Profile)
            //--------------------------------------------------------------------------------------
            lower_left = LOWER_LEFT,
            upper_left = UPPER_LEFT,
        };

        pub const ClipDepth = enum(Enum) {
            //--------------------------------------------------------------------------------------
            // OpenGL 4.5 (Core Profile)
            //--------------------------------------------------------------------------------------
            negative_one_to_one = NEGATIVE_ONE_TO_ONE,
            zero_to_one = ZERO_TO_ONE,
        };

        pub const TransformFeedbackIntegerParameter = enum(Enum) {
            //--------------------------------------------------------------------------------------
            // OpenGL 4.5 (Core Profile)
            //--------------------------------------------------------------------------------------
            transform_feedback_paused = TRANSFORM_FEEDBACK_PAUSED,
            transform_feedback_active = TRANSFORM_FEEDBACK_ACTIVE,
        };

        pub const IndexedTransformFeedbackIntegerParameter = enum(Enum) {
            //--------------------------------------------------------------------------------------
            // OpenGL 4.5 (Core Profile)
            //--------------------------------------------------------------------------------------
            transform_feedback_buffer_binding = TRANSFORM_FEEDBACK_BUFFER_BINDING,
        };

        pub const IndexedTransformFeedbackInt64Parameter = enum(Enum) {
            //--------------------------------------------------------------------------------------
            // OpenGL 4.5 (Core Profile)
            //--------------------------------------------------------------------------------------
            transform_feedback_buffer_start = TRANSFORM_FEEDBACK_BUFFER_START,
            transform_feedback_buffer_size = TRANSFORM_FEEDBACK_BUFFER_SIZE,
        };

        pub const VertexArrayIntegerParameter = enum(Enum) {
            //--------------------------------------------------------------------------------------
            // OpenGL 4.5 (Core Profile)
            //--------------------------------------------------------------------------------------
            element_array_buffer_binding = ELEMENT_ARRAY_BUFFER_BINDING,
        };

        pub const IndexedVertexArrayIntegerParameter = enum(Enum) {
            //--------------------------------------------------------------------------------------
            // OpenGL 4.5 (Core Profile)
            //--------------------------------------------------------------------------------------
            vertex_attrib_array_enabled = VERTEX_ATTRIB_ARRAY_ENABLED,
            vertex_attrib_array_size = VERTEX_ATTRIB_ARRAY_SIZE,
            vertex_attrib_array_stride = VERTEX_ATTRIB_ARRAY_STRIDE,
            vertex_attrib_array_type = VERTEX_ATTRIB_ARRAY_TYPE,
            vertex_attrib_array_normalized = VERTEX_ATTRIB_ARRAY_NORMALIZED,
            vertex_attrib_array_integer = VERTEX_ATTRIB_ARRAY_INTEGER,
            vertex_attrib_array_long = VERTEX_ATTRIB_ARRAY_LONG,
            vertex_attrib_array_divisor = VERTEX_ATTRIB_ARRAY_DIVISOR,
            vertex_attrib_relative_offset = VERTEX_ATTRIB_RELATIVE_OFFSET,
            //--------------------------------------------------------------------------------------
            // OpenGL 4.6 (Core Profile)
            //--------------------------------------------------------------------------------------
            vertex_attrib_array_buffer_binding = VERTEX_ATTRIB_ARRAY_BUFFER_BINDING,
            vertex_binding_stride = VERTEX_BINDING_STRIDE,
            vertex_binding_divisor = VERTEX_BINDING_DIVISOR,
            vertex_binding_buffer = VERTEX_BINDING_BUFFER,
        };

        pub const IndexedVertexArrayInt64Parameter = enum(Enum) {
            //--------------------------------------------------------------------------------------
            // OpenGL 4.5 (Core Profile)
            //--------------------------------------------------------------------------------------
            vertex_binding_offset = VERTEX_BINDING_OFFSET,
        };

        pub const UsedRegionBarriers = packed struct(Bitfield) {
            //--------------------------------------------------------------------------------------
            // OpenGL 4.5 (Core Profile)
            //--------------------------------------------------------------------------------------
            // UNIFORM_BARRIER_BIT              = 0x00000004 // 3rd bit
            // TEXTURE_FETCH_BARRIER_BIT        = 0x00000008 // 4th bit
            // SHADER_IMAGE_ACCESS_BARRIER_BIT  = 0x00000020 // 6th bit
            // FRAMEBUFFER_BARRIER_BIT          = 0x00000400 // 11th bit
            // ATOMIC_COUNTER_BARRIER_BIT       = 0x00001000 // 13th bit
            // SHADER_STORAGE_BARRIER_BIT       = 0x00002000 // 14th bit
            // ALL_BARRIER_BITS                 = 0xFFFFFFFF // implemented using all() function

            /// DO NOT WRITE
            pad1: u2 = 0,

            uniform_barrier: bool = false,
            texture_fetch_barrier: bool = false,

            /// DO NOT WRITE
            pad2: u1 = 0,

            shader_image_access_barrier: bool = false,

            /// DO NOT WRITE
            pad3: u4 = 0,

            framebuffer_barrier: bool = false,

            /// DO NOT WRITE
            pad4: u1 = 0,

            atomic_counter_barrier: bool = false,
            shader_storage_barrier: bool = false,

            /// DO NOT WRITE
            pad5: u18 = 0,

            pub fn all() UsedRegionBarriers {
                return @bitCast(
                    @as(Bitfield, ALL_BARRIER_BITS),
                );
            }

            // confirmation that memory layout is correct
            comptime {
                assert(@as(Bitfield, @bitCast(UsedRegionBarriers{ .uniform_barrier = true })) == UNIFORM_BARRIER_BIT);
                assert(@as(Bitfield, @bitCast(UsedRegionBarriers{ .texture_fetch_barrier = true })) == TEXTURE_FETCH_BARRIER_BIT);
                assert(@as(Bitfield, @bitCast(UsedRegionBarriers{ .shader_image_access_barrier = true })) == SHADER_IMAGE_ACCESS_BARRIER_BIT);
                assert(@as(Bitfield, @bitCast(UsedRegionBarriers{ .framebuffer_barrier = true })) == FRAMEBUFFER_BARRIER_BIT);
                assert(@as(Bitfield, @bitCast(UsedRegionBarriers{ .atomic_counter_barrier = true })) == ATOMIC_COUNTER_BARRIER_BIT);
                assert(@as(Bitfield, @bitCast(UsedRegionBarriers{ .shader_storage_barrier = true })) == SHADER_STORAGE_BARRIER_BIT);
                assert(@as(Bitfield, @bitCast(UsedRegionBarriers.all())) == ALL_BARRIER_BITS);
            }
        };

        pub const GraphicsResetStatus = enum(Enum) {
            no_error = NO_ERROR,
            guilty_context_reset = GUILTY_CONTEXT_RESET,
            innocent_context_reset = INNOCENT_CONTEXT_RESET,
            unknown_context_reset = UNKNOWN_CONTEXT_RESET,
        };

        //------------------------------------------------------------------------------------------
        //
        // OpenGL 1.0 (Core Profile)
        //
        //------------------------------------------------------------------------------------------
        pub const Enum = bindings.Enum;
        pub const Float = bindings.Float;
        pub const Int = bindings.Int;
        pub const Sizei = bindings.Sizei;
        pub const Bitfield = bindings.Bitfield;
        pub const Double = bindings.Double;
        pub const Uint = bindings.Uint;
        pub const Boolean = bindings.Boolean;
        pub const Ubyte = bindings.Ubyte;

        pub const DEPTH_BUFFER_BIT = bindings.DEPTH_BUFFER_BIT;
        pub const STENCIL_BUFFER_BIT = bindings.STENCIL_BUFFER_BIT;
        pub const COLOR_BUFFER_BIT = bindings.COLOR_BUFFER_BIT;
        pub const FALSE = bindings.FALSE;
        pub const TRUE = bindings.TRUE;
        pub const POINTS = bindings.POINTS;
        pub const LINES = bindings.LINES;
        pub const LINE_LOOP = bindings.LINE_LOOP;
        pub const LINE_STRIP = bindings.LINE_STRIP;
        pub const TRIANGLES = bindings.TRIANGLES;
        pub const TRIANGLE_STRIP = bindings.TRIANGLE_STRIP;
        pub const TRIANGLE_FAN = bindings.TRIANGLE_FAN;
        pub const QUADS = bindings.QUADS;
        pub const NEVER = bindings.NEVER;
        pub const LESS = bindings.LESS;
        pub const EQUAL = bindings.EQUAL;
        pub const LEQUAL = bindings.LEQUAL;
        pub const GREATER = bindings.GREATER;
        pub const NOTEQUAL = bindings.NOTEQUAL;
        pub const GEQUAL = bindings.GEQUAL;
        pub const ALWAYS = bindings.ALWAYS;
        pub const ZERO = bindings.ZERO;
        pub const ONE = bindings.ONE;
        pub const SRC_COLOR = bindings.SRC_COLOR;
        pub const ONE_MINUS_SRC_COLOR = bindings.ONE_MINUS_SRC_COLOR;
        pub const SRC_ALPHA = bindings.SRC_ALPHA;
        pub const ONE_MINUS_SRC_ALPHA = bindings.ONE_MINUS_SRC_ALPHA;
        pub const DST_ALPHA = bindings.DST_ALPHA;
        pub const ONE_MINUS_DST_ALPHA = bindings.ONE_MINUS_DST_ALPHA;
        pub const DST_COLOR = bindings.DST_COLOR;
        pub const ONE_MINUS_DST_COLOR = bindings.ONE_MINUS_DST_COLOR;
        pub const SRC_ALPHA_SATURATE = bindings.SRC_ALPHA_SATURATE;
        pub const NONE = bindings.NONE;
        pub const FRONT_LEFT = bindings.FRONT_LEFT;
        pub const FRONT_RIGHT = bindings.FRONT_RIGHT;
        pub const BACK_LEFT = bindings.BACK_LEFT;
        pub const BACK_RIGHT = bindings.BACK_RIGHT;
        pub const FRONT = bindings.FRONT;
        pub const BACK = bindings.BACK;
        pub const LEFT = bindings.LEFT;
        pub const RIGHT = bindings.RIGHT;
        pub const FRONT_AND_BACK = bindings.FRONT_AND_BACK;
        pub const NO_ERROR = bindings.NO_ERROR;
        pub const INVALID_ENUM = bindings.INVALID_ENUM;
        pub const INVALID_VALUE = bindings.INVALID_VALUE;
        pub const INVALID_OPERATION = bindings.INVALID_OPERATION;
        pub const OUT_OF_MEMORY = bindings.OUT_OF_MEMORY;
        pub const CW = bindings.CW;
        pub const CCW = bindings.CCW;
        pub const POINT_SIZE = bindings.POINT_SIZE;
        pub const POINT_SIZE_RANGE = bindings.POINT_SIZE_RANGE;
        pub const POINT_SIZE_GRANULARITY = bindings.POINT_SIZE_GRANULARITY;
        pub const LINE_SMOOTH = bindings.LINE_SMOOTH;
        pub const LINE_WIDTH = bindings.LINE_WIDTH;
        pub const LINE_WIDTH_RANGE = bindings.LINE_WIDTH_RANGE;
        pub const LINE_WIDTH_GRANULARITY = bindings.LINE_WIDTH_GRANULARITY;
        pub const POLYGON_MODE = bindings.POLYGON_MODE;
        pub const POLYGON_SMOOTH = bindings.POLYGON_SMOOTH;
        pub const CULL_FACE = bindings.CULL_FACE;
        pub const CULL_FACE_MODE = bindings.CULL_FACE_MODE;
        pub const FRONT_FACE = bindings.FRONT_FACE;
        pub const DEPTH_RANGE = bindings.DEPTH_RANGE;
        pub const DEPTH_TEST = bindings.DEPTH_TEST;
        pub const DEPTH_WRITEMASK = bindings.DEPTH_WRITEMASK;
        pub const DEPTH_CLEAR_VALUE = bindings.DEPTH_CLEAR_VALUE;
        pub const DEPTH_FUNC = bindings.DEPTH_FUNC;
        pub const STENCIL_TEST = bindings.STENCIL_TEST;
        pub const STENCIL_CLEAR_VALUE = bindings.STENCIL_CLEAR_VALUE;
        pub const STENCIL_FUNC = bindings.STENCIL_FUNC;
        pub const STENCIL_VALUE_MASK = bindings.STENCIL_VALUE_MASK;
        pub const STENCIL_FAIL = bindings.STENCIL_FAIL;
        pub const STENCIL_PASS_DEPTH_FAIL = bindings.STENCIL_PASS_DEPTH_FAIL;
        pub const STENCIL_PASS_DEPTH_PASS = bindings.STENCIL_PASS_DEPTH_PASS;
        pub const STENCIL_REF = bindings.STENCIL_REF;
        pub const STENCIL_WRITEMASK = bindings.STENCIL_WRITEMASK;
        pub const VIEWPORT = bindings.VIEWPORT;
        pub const DITHER = bindings.DITHER;
        pub const BLEND_DST = bindings.BLEND_DST;
        pub const BLEND_SRC = bindings.BLEND_SRC;
        pub const BLEND = bindings.BLEND;
        pub const LOGIC_OP_MODE = bindings.LOGIC_OP_MODE;
        pub const DRAW_BUFFER = bindings.DRAW_BUFFER;
        pub const READ_BUFFER = bindings.READ_BUFFER;
        pub const SCISSOR_BOX = bindings.SCISSOR_BOX;
        pub const SCISSOR_TEST = bindings.SCISSOR_TEST;
        pub const COLOR_CLEAR_VALUE = bindings.COLOR_CLEAR_VALUE;
        pub const COLOR_WRITEMASK = bindings.COLOR_WRITEMASK;
        pub const DOUBLEBUFFER = bindings.DOUBLEBUFFER;
        pub const STEREO = bindings.STEREO;
        pub const LINE_SMOOTH_HINT = bindings.LINE_SMOOTH_HINT;
        pub const POLYGON_SMOOTH_HINT = bindings.POLYGON_SMOOTH_HINT;
        pub const UNPACK_SWAP_BYTES = bindings.UNPACK_SWAP_BYTES;
        pub const UNPACK_LSB_FIRST = bindings.UNPACK_LSB_FIRST;
        pub const UNPACK_ROW_LENGTH = bindings.UNPACK_ROW_LENGTH;
        pub const UNPACK_SKIP_ROWS = bindings.UNPACK_SKIP_ROWS;
        pub const UNPACK_SKIP_PIXELS = bindings.UNPACK_SKIP_PIXELS;
        pub const UNPACK_ALIGNMENT = bindings.UNPACK_ALIGNMENT;
        pub const PACK_SWAP_BYTES = bindings.PACK_SWAP_BYTES;
        pub const PACK_LSB_FIRST = bindings.PACK_LSB_FIRST;
        pub const PACK_ROW_LENGTH = bindings.PACK_ROW_LENGTH;
        pub const PACK_SKIP_ROWS = bindings.PACK_SKIP_ROWS;
        pub const PACK_SKIP_PIXELS = bindings.PACK_SKIP_PIXELS;
        pub const PACK_ALIGNMENT = bindings.PACK_ALIGNMENT;
        pub const MAX_TEXTURE_SIZE = bindings.MAX_TEXTURE_SIZE;
        pub const MAX_VIEWPORT_DIMS = bindings.MAX_VIEWPORT_DIMS;
        pub const SUBPIXEL_BITS = bindings.SUBPIXEL_BITS;
        pub const TEXTURE_1D = bindings.TEXTURE_1D;
        pub const TEXTURE_2D = bindings.TEXTURE_2D;
        pub const TEXTURE_WIDTH = bindings.TEXTURE_WIDTH;
        pub const TEXTURE_HEIGHT = bindings.TEXTURE_HEIGHT;
        pub const TEXTURE_BORDER_COLOR = bindings.TEXTURE_BORDER_COLOR;
        pub const DONT_CARE = bindings.DONT_CARE;
        pub const FASTEST = bindings.FASTEST;
        pub const NICEST = bindings.NICEST;
        pub const BYTE = bindings.BYTE;
        pub const UNSIGNED_BYTE = bindings.UNSIGNED_BYTE;
        pub const SHORT = bindings.SHORT;
        pub const UNSIGNED_SHORT = bindings.UNSIGNED_SHORT;
        pub const INT = bindings.INT;
        pub const UNSIGNED_INT = bindings.UNSIGNED_INT;
        pub const FLOAT = bindings.FLOAT;
        pub const STACK_OVERFLOW = bindings.STACK_OVERFLOW;
        pub const STACK_UNDERFLOW = bindings.STACK_UNDERFLOW;
        pub const CLEAR = bindings.CLEAR;
        pub const AND = bindings.AND;
        pub const AND_REVERSE = bindings.AND_REVERSE;
        pub const COPY = bindings.COPY;
        pub const AND_INVERTED = bindings.AND_INVERTED;
        pub const NOOP = bindings.NOOP;
        pub const XOR = bindings.XOR;
        pub const OR = bindings.OR;
        pub const NOR = bindings.NOR;
        pub const EQUIV = bindings.EQUIV;
        pub const INVERT = bindings.INVERT;
        pub const OR_REVERSE = bindings.OR_REVERSE;
        pub const COPY_INVERTED = bindings.COPY_INVERTED;
        pub const OR_INVERTED = bindings.OR_INVERTED;
        pub const NAND = bindings.NAND;
        pub const SET = bindings.SET;
        pub const TEXTURE = bindings.TEXTURE;
        pub const COLOR = bindings.COLOR;
        pub const DEPTH = bindings.DEPTH;
        pub const STENCIL = bindings.STENCIL;
        pub const STENCIL_INDEX = bindings.STENCIL_INDEX;
        pub const DEPTH_COMPONENT = bindings.DEPTH_COMPONENT;
        pub const RED = bindings.RED;
        pub const GREEN = bindings.GREEN;
        pub const BLUE = bindings.BLUE;
        pub const ALPHA = bindings.ALPHA;
        pub const RGB = bindings.RGB;
        pub const RGBA = bindings.RGBA;
        pub const POINT = bindings.POINT;
        pub const LINE = bindings.LINE;
        pub const FILL = bindings.FILL;
        pub const KEEP = bindings.KEEP;
        pub const REPLACE = bindings.REPLACE;
        pub const INCR = bindings.INCR;
        pub const DECR = bindings.DECR;
        pub const VENDOR = bindings.VENDOR;
        pub const RENDERER = bindings.RENDERER;
        pub const VERSION = bindings.VERSION;
        pub const EXTENSIONS = bindings.EXTENSIONS;
        pub const NEAREST = bindings.NEAREST;
        pub const LINEAR = bindings.LINEAR;
        pub const NEAREST_MIPMAP_NEAREST = bindings.NEAREST_MIPMAP_NEAREST;
        pub const LINEAR_MIPMAP_NEAREST = bindings.LINEAR_MIPMAP_NEAREST;
        pub const NEAREST_MIPMAP_LINEAR = bindings.NEAREST_MIPMAP_LINEAR;
        pub const LINEAR_MIPMAP_LINEAR = bindings.LINEAR_MIPMAP_LINEAR;
        pub const TEXTURE_MAG_FILTER = bindings.TEXTURE_MAG_FILTER;
        pub const TEXTURE_MIN_FILTER = bindings.TEXTURE_MIN_FILTER;
        pub const TEXTURE_WRAP_S = bindings.TEXTURE_WRAP_S;
        pub const TEXTURE_WRAP_T = bindings.TEXTURE_WRAP_T;
        pub const REPEAT = bindings.REPEAT;

        pub fn cullFace(mode: Face) void {
            bindings.cullFace(@intFromEnum(mode));
        }

        pub fn frontFace(mode: enum(Enum) { cw = CW, ccw = CCW }) void {
            bindings.frontFace(@intFromEnum(mode));
        }

        pub fn hint(
            target: enum(Enum) {
                //------------------------------------------------------------------------------------------
                // OpenGL 1.0 (Core Profile)
                //------------------------------------------------------------------------------------------
                line_smooth = LINE_SMOOTH_HINT,
                polygon_smooth = POLYGON_SMOOTH_HINT,
                //------------------------------------------------------------------------------------------
                // OpenGL 1.3 (Core Profile)
                //------------------------------------------------------------------------------------------
                texture_compression = TEXTURE_COMPRESSION_HINT,
                //------------------------------------------------------------------------------------------
                // OpenGL 2.0 (Core Profile)
                //------------------------------------------------------------------------------------------
                fragment_shader_derivative = FRAGMENT_SHADER_DERIVATIVE_HINT,
            },
            mode: enum(Enum) {
                fastest = FASTEST,
                nicest = NICEST,
                dont_care = DONT_CARE,
            },
        ) void {
            bindings.hint(@intFromEnum(target), @intFromEnum(mode));
        }

        pub fn lineWidth(width: f32) void {
            bindings.lineWidth(width);
        }

        pub fn pointSize(size: f32) void {
            bindings.pointSize(size);
        }

        pub fn polygonMode(face: Face, mode: enum(Enum) {
            point = POINT,
            line = LINE,
            fill = FILL,
        }) void {
            bindings.polygonMode(@intFromEnum(face), @intFromEnum(mode));
        }

        pub fn scissor(x: i32, y: i32, width: i32, height: i32) void {
            bindings.scissor(x, y, width, height);
        }

        pub fn texParameterf(target: TextureTarget, pname: TexParameter, param: f32) void {
            bindings.texParameterf(@intFromEnum(target), @intFromEnum(pname), param);
        }

        pub fn texParameterfv(target: TextureTarget, pname: TexParameter, params: []const f32) void {
            bindings.texParameterfv(@intFromEnum(target), @intFromEnum(pname), params.ptr);
        }

        pub fn texParameteri(target: TextureTarget, pname: TexParameter, param: i32) void {
            bindings.texParameteri(@intFromEnum(target), @intFromEnum(pname), param);
        }

        pub fn texParameteriv(target: TextureTarget, pname: TexParameter, params: []const i32) void {
            bindings.texParameteriv(@intFromEnum(target), @intFromEnum(pname), params.ptr);
        }

        pub fn texImage1D(args: struct {
            target: TexImage1DTarget,
            level: u32,
            internal_format: InternalFormat,
            width: u32,
            /// Deprecated since OpenGL 3.0
            border: bool = false,
            format: PixelFormat,
            pixel_type: PixelType,
            data: ?[*]const u8,
        }) void {
            bindings.texImage1D(
                @intFromEnum(args.target),
                @bitCast(args.level),
                @intFromEnum(args.internal_format),
                @bitCast(args.width),
                @intFromBool(args.border),
                @intFromEnum(args.format),
                @intFromEnum(args.pixel_type),
                args.data,
            );
        }

        pub fn texImage2D(args: struct {
            target: TexImage2DTarget,
            level: u32,
            internal_format: InternalFormat,
            width: u32,
            height: u32,
            /// Deprecated since OpenGL 3.0
            border: bool = false,
            format: PixelFormat,
            pixel_type: PixelType,
            data: ?[*]const u8,
        }) void {
            bindings.texImage2D(
                @intFromEnum(args.target),
                @bitCast(args.level),
                @intFromEnum(args.internal_format),
                @bitCast(args.width),
                @bitCast(args.height),
                @intFromBool(args.border),
                @intFromEnum(args.format),
                @intFromEnum(args.pixel_type),
                args.data,
            );
        }

        pub fn drawBuffer(buf: ColorBuffer) void {
            bindings.drawBuffer(@intFromEnum(buf));
        }

        pub fn clear(mask: ColorMask) void {
            bindings.clear(@bitCast(mask));
        }

        pub fn clearColor(r: f32, g: f32, b: f32, a: f32) void {
            bindings.clearColor(r, g, b, a);
        }

        pub fn clearStencil(s: Int) void {
            bindings.clearStencil(s);
        }

        pub fn clearDepth(depth: Double) void {
            bindings.clearDepth(depth);
        }

        pub fn stencilMask(mask: Uint) void {
            bindings.stencilMask(mask);
        }

        pub fn colorMask(red: bool, green: bool, blue: bool, alpha: bool) void {
            bindings.colorMask(
                @intFromBool(red),
                @intFromBool(green),
                @intFromBool(blue),
                @intFromBool(alpha),
            );
        }

        pub fn depthMask(flag: bool) void {
            bindings.depthMask(@intFromBool(flag));
        }

        pub fn disable(capability: Capability) void {
            bindings.disable(@intFromEnum(capability));
        }

        pub fn enable(capability: Capability) void {
            bindings.enable(@intFromEnum(capability));
        }

        pub fn finish() void {
            bindings.finish();
        }

        pub fn flush() void {
            bindings.flush();
        }

        pub fn blendFunc(sfactor: BlendFactor, dfactor: BlendFactor) void {
            bindings.blendFunc(@intFromEnum(sfactor), @intFromEnum(dfactor));
        }

        pub fn logicOp(opcode: enum(Enum) {
            clear = CLEAR,
            set = SET,
            copy = COPY,
            copy_inverted = COPY_INVERTED,
            noop = NOOP,
            invert = INVERT,
            @"and" = AND,
            nand = NAND,
            @"or" = OR,
            nor = NOR,
            xor = XOR,
            equiv = EQUIV,
            and_reverse = AND_REVERSE,
            or_reverse = OR_REVERSE,
            or_inverted = OR_INVERTED,
        }) void {
            bindings.logicOp(@intFromEnum(opcode));
        }

        pub fn stencilFunc(func: Func, ref: i32, mask: u32) void {
            bindings.stencilFunc(@intFromEnum(func), ref, mask);
        }

        pub fn stencilOp(fail: StencilAction, zfail: StencilAction, zpass: StencilAction) void {
            bindings.stencilOp(@intFromEnum(fail), @intFromEnum(zfail), @intFromEnum(zpass));
        }

        pub fn depthFunc(func: Func) void {
            bindings.depthFunc(@intFromEnum(func));
        }

        pub fn pixelStoref(pname: PixelStoreParameter, param: f32) void {
            bindings.pixelStoref(@intFromEnum(pname), param);
        }

        pub fn pixelStorei(pname: PixelStoreParameter, param: i32) void {
            bindings.pixelStorei(@intFromEnum(pname), param);
        }

        pub fn readBuffer(src: ColorBuffer) void {
            bindings.readBuffer(@intFromEnum(src));
        }

        pub fn readPixels(
            x: i32,
            y: i32,
            width: i32,
            height: i32,
            format: PixelFormat,
            pixel_type: PixelType,
            pixels: ?[*]u8,
        ) void {
            bindings.readPixels(
                x,
                y,
                width,
                height,
                @intFromEnum(format),
                @intFromEnum(pixel_type),
                pixels,
            );
        }

        pub fn getBooleanv(pname: ParamName, ptr: [*]Boolean) void {
            bindings.getBooleanv(@intFromEnum(pname), ptr);
        }

        pub fn getDoublev(pname: ParamName, ptr: [*]Double) void {
            bindings.getDoublev(@intFromEnum(pname), ptr);
        }

        pub fn getError() Error {
            const res = bindings.getError();
            return std.meta.intToEnum(Error, res) catch onInvalid: {
                log.warn("getError returned unexpected value {}", .{res});
                break :onInvalid .no_error;
            };
        }

        pub fn getFloatv(pname: ParamName, ptr: [*]Float) void {
            bindings.getFloatv(@intFromEnum(pname), ptr);
        }

        pub fn getIntegerv(pname: ParamName, ptr: [*]Int) void {
            bindings.getIntegerv(@intFromEnum(pname), ptr);
        }

        pub fn getString(name: StringParamName) [*:0]const u8 {
            return bindings.getString(@intFromEnum(name));
        }

        pub fn getTexImage(
            target: TexImageTarget,
            level: u32,
            format: PixelFormat,
            pixel_type: PixelType,
            pixels: ?[*]u8,
        ) void {
            bindings.getTexImage(
                @intFromEnum(target),
                @bitCast(level),
                @intFromEnum(format),
                @intFromEnum(pixel_type),
                pixels,
            );
        }

        pub fn getTexParameterfv(target: TextureTarget, pname: GetTexParameter, params: []f32) void {
            bindings.getTexParameterfv(@intFromEnum(target), @intFromEnum(pname), params.ptr);
        }

        pub fn getTexParameteriv(target: TextureTarget, pname: GetTexParameter, params: []i32) void {
            bindings.getTexParameteriv(@intFromEnum(target), @intFromEnum(pname), params.ptr);
        }

        pub fn getTexLevelParameterfv(
            target: TexLevelTarget,
            level: u32,
            pname: GetTexLevelParameter,
            params: []f32,
        ) void {
            bindings.getTexLevelParameterfv(
                @intFromEnum(target),
                @bitCast(level),
                @intFromEnum(pname),
                params.ptr,
            );
        }

        pub fn getTexLevelParameteriv(
            target: TexLevelTarget,
            level: u32,
            pname: GetTexLevelParameter,
            params: []i32,
        ) void {
            bindings.getTexLevelParameteriv(
                @intFromEnum(target),
                @bitCast(level),
                @intFromEnum(pname),
                params.ptr,
            );
        }

        pub fn isEnabled(capability: Capability) bool {
            return bindings.isEnabled(@intFromEnum(capability)) == TRUE;
        }

        pub fn depthRange(near: f64, far: f64) void {
            bindings.depthRange(near, far);
        }

        pub fn viewport(x: Int, y: Int, width: u32, height: u32) void {
            bindings.viewport(x, y, @as(Sizei, @bitCast(width)), @as(Sizei, @bitCast(height)));
        }

        //------------------------------------------------------------------------------------------
        //
        // OpenGL 1.1 (Core Profile)
        //
        //------------------------------------------------------------------------------------------
        pub const Clampf = bindings.Clampf;
        pub const Clampd = bindings.Clampd;

        pub const COLOR_LOGIC_OP = bindings.COLOR_LOGIC_OP;
        pub const POLYGON_OFFSET_UNITS = bindings.POLYGON_OFFSET_UNITS;
        pub const POLYGON_OFFSET_POINT = bindings.POLYGON_OFFSET_POINT;
        pub const POLYGON_OFFSET_LINE = bindings.POLYGON_OFFSET_LINE;
        pub const POLYGON_OFFSET_FILL = bindings.POLYGON_OFFSET_FILL;
        pub const POLYGON_OFFSET_FACTOR = bindings.POLYGON_OFFSET_FACTOR;
        pub const TEXTURE_BINDING_1D = bindings.TEXTURE_BINDING_1D;
        pub const TEXTURE_BINDING_2D = bindings.TEXTURE_BINDING_2D;
        pub const TEXTURE_INTERNAL_FORMAT = bindings.TEXTURE_INTERNAL_FORMAT;
        pub const TEXTURE_RED_SIZE = bindings.TEXTURE_RED_SIZE;
        pub const TEXTURE_GREEN_SIZE = bindings.TEXTURE_GREEN_SIZE;
        pub const TEXTURE_BLUE_SIZE = bindings.TEXTURE_BLUE_SIZE;
        pub const TEXTURE_ALPHA_SIZE = bindings.TEXTURE_ALPHA_SIZE;
        pub const DOUBLE = bindings.DOUBLE;
        pub const PROXY_TEXTURE_1D = bindings.PROXY_TEXTURE_1D;
        pub const PROXY_TEXTURE_2D = bindings.PROXY_TEXTURE_2D;
        pub const R3_G3_B2 = bindings.R3_G3_B2;
        pub const RGB4 = bindings.RGB4;
        pub const RGB5 = bindings.RGB5;
        pub const RGB8 = bindings.RGB8;
        pub const RGB10 = bindings.RGB10;
        pub const RGB12 = bindings.RGB12;
        pub const RGB16 = bindings.RGB16;
        pub const RGBA2 = bindings.RGBA2;
        pub const RGBA4 = bindings.RGBA4;
        pub const RGB5_A1 = bindings.RGB5_A1;
        pub const RGBA8 = bindings.RGBA8;
        pub const RGB10_A2 = bindings.RGB10_A2;
        pub const RGBA12 = bindings.RGBA12;
        pub const RGBA16 = bindings.RGBA16;
        pub const VERTEX_ARRAY = bindings.VERTEX_ARRAY;

        pub fn drawArrays(prim_type: PrimitiveType, first: u32, count: u32) void {
            bindings.drawArrays(@intFromEnum(prim_type), @as(Int, @bitCast(first)), @as(Sizei, @bitCast(count)));
        }

        pub fn drawElements(
            mode: PrimitiveType,
            length: u32,
            index_type: DrawIndicesType,
            indices: u32, //offset in buffer
        ) void {
            bindings.drawElements(@intFromEnum(mode), @intCast(length), @intFromEnum(index_type), @ptrFromInt(indices));
        }

        pub fn polygonOffset(factor: f32, units: f32) void {
            bindings.polygonOffset(factor, units);
        }

        pub fn copyTexImage1D(
            target: TexImageTarget,
            level: i32,
            internal_format: InternalFormat,
            x: i32,
            y: i32,
            width: u32,
            border: i32,
        ) void {
            bindings.copyTexImage1D(
                @intFromEnum(target),
                level,
                @intFromEnum(internal_format),
                x,
                y,
                @intCast(width),
                border,
            );
        }

        pub fn copyTexImage2D(
            target: TexImageTarget,
            level: i32,
            internal_format: InternalFormat,
            x: i32,
            y: i32,
            width: u32,
            height: u32,
            border: i32,
        ) void {
            bindings.copyTexImage2D(
                @intFromEnum(target),
                level,
                @intFromEnum(internal_format),
                x,
                y,
                @intCast(width),
                @intCast(height),
                border,
            );
        }

        pub fn copyTexSubImage1D(target: TexImageTarget, level: i32, xoffset: i32, x: i32, y: i32, width: u32) void {
            bindings.copyTexSubImage1D(@intFromEnum(target), level, xoffset, x, y, @intCast(width));
        }

        pub fn copyTexSubImage2D(
            target: TexImageTarget,
            level: i32,
            xoffset: i32,
            yoffset: i32,
            x: i32,
            y: i32,
            width: u32,
            height: u32,
        ) void {
            bindings.copyTexSubImage2D(
                @intFromEnum(target),
                level,
                xoffset,
                yoffset,
                x,
                y,
                @intCast(width),
                @intCast(height),
            );
        }

        pub fn texSubImage1D(
            target: TexImageTarget,
            level: i32,
            xoffset: i32,
            width: u32,
            format: PixelFormat,
            pixel_type: PixelType,
            data: ?[*]const u8,
        ) void {
            bindings.texSubImage1D(
                @intFromEnum(target),
                level,
                xoffset,
                @intCast(width),
                @intFromEnum(format),
                @intFromEnum(pixel_type),
                data,
            );
        }

        pub fn texSubImage2D(
            target: TexImageTarget,
            level: i32,
            xoffset: i32,
            yoffset: i32,
            width: u32,
            height: u32,
            format: PixelFormat,
            pixel_type: PixelType,
            data: ?[*]const u8,
        ) void {
            bindings.texSubImage2D(@intFromEnum(target), level, xoffset, yoffset, @intCast(width), @intCast(height), @intFromEnum(format), @intFromEnum(pixel_type), data);
        }

        pub fn bindTexture(target: TextureTarget, texture: Texture) void {
            bindings.bindTexture(@intFromEnum(target), @intFromEnum(texture));
        }

        pub fn deleteTexture(ptr: *const Texture) void {
            bindings.deleteTextures(1, @as([*c]const Uint, @ptrCast(ptr)));
        }
        pub fn deleteTextures(textures: []const Texture) void {
            bindings.deleteTextures(@intCast(textures.len), @as([*c]const Uint, @ptrCast(textures.ptr)));
        }

        pub fn genTexture(ptr: *Texture) void {
            bindings.genTextures(1, @as([*c]Uint, @ptrCast(ptr)));
        }
        pub fn genTextures(textures: []Texture) void {
            bindings.genTextures(@intCast(textures.len), @as([*c]Uint, @ptrCast(textures.ptr)));
        }

        pub fn isTexture(texture: Texture) bool {
            return bindings.isTexture(@intFromEnum(texture)) == TRUE;
        }

        //------------------------------------------------------------------------------------------
        //
        // OpenGL 1.2 (Core Profile)
        //
        //------------------------------------------------------------------------------------------
        pub const UNSIGNED_BYTE_3_3_2 = bindings.UNSIGNED_BYTE_3_3_2;
        pub const UNSIGNED_SHORT_4_4_4_4 = bindings.UNSIGNED_SHORT_4_4_4_4;
        pub const UNSIGNED_SHORT_5_5_5_1 = bindings.UNSIGNED_SHORT_5_5_5_1;
        pub const UNSIGNED_INT_8_8_8_8 = bindings.UNSIGNED_INT_8_8_8_8;
        pub const UNSIGNED_INT_10_10_10_2 = bindings.UNSIGNED_INT_10_10_10_2;
        pub const TEXTURE_BINDING_3D = bindings.TEXTURE_BINDING_3D;
        pub const PACK_SKIP_IMAGES = bindings.PACK_SKIP_IMAGES;
        pub const PACK_IMAGE_HEIGHT = bindings.PACK_IMAGE_HEIGHT;
        pub const UNPACK_SKIP_IMAGES = bindings.UNPACK_SKIP_IMAGES;
        pub const UNPACK_IMAGE_HEIGHT = bindings.UNPACK_IMAGE_HEIGHT;
        pub const TEXTURE_3D = bindings.TEXTURE_3D;
        pub const PROXY_TEXTURE_3D = bindings.PROXY_TEXTURE_3D;
        pub const TEXTURE_DEPTH = bindings.TEXTURE_DEPTH;
        pub const TEXTURE_WRAP_R = bindings.TEXTURE_WRAP_R;
        pub const MAX_3D_TEXTURE_SIZE = bindings.MAX_3D_TEXTURE_SIZE;
        pub const UNSIGNED_BYTE_2_3_3_REV = bindings.UNSIGNED_BYTE_2_3_3_REV;
        pub const UNSIGNED_SHORT_5_6_5 = bindings.UNSIGNED_SHORT_5_6_5;
        pub const UNSIGNED_SHORT_5_6_5_REV = bindings.UNSIGNED_SHORT_5_6_5_REV;
        pub const UNSIGNED_SHORT_4_4_4_4_REV = bindings.UNSIGNED_SHORT_4_4_4_4_REV;
        pub const UNSIGNED_SHORT_1_5_5_5_REV = bindings.UNSIGNED_SHORT_1_5_5_5_REV;
        pub const UNSIGNED_INT_8_8_8_8_REV = bindings.UNSIGNED_INT_8_8_8_8_REV;
        pub const UNSIGNED_INT_2_10_10_10_REV = bindings.UNSIGNED_INT_2_10_10_10_REV;
        pub const BGR = bindings.BGR;
        pub const BGRA = bindings.BGRA;
        pub const MAX_ELEMENTS_VERTICES = bindings.MAX_ELEMENTS_VERTICES;
        pub const MAX_ELEMENTS_INDICES = bindings.MAX_ELEMENTS_INDICES;
        pub const CLAMP_TO_EDGE = bindings.CLAMP_TO_EDGE;
        pub const TEXTURE_MIN_LOD = bindings.TEXTURE_MIN_LOD;
        pub const TEXTURE_MAX_LOD = bindings.TEXTURE_MAX_LOD;
        pub const TEXTURE_BASE_LEVEL = bindings.TEXTURE_BASE_LEVEL;
        pub const TEXTURE_MAX_LEVEL = bindings.TEXTURE_MAX_LEVEL;
        pub const SMOOTH_POINT_SIZE_RANGE = bindings.SMOOTH_POINT_SIZE_RANGE;
        pub const SMOOTH_POINT_SIZE_GRANULARITY = bindings.SMOOTH_POINT_SIZE_GRANULARITY;
        pub const SMOOTH_LINE_WIDTH_RANGE = bindings.SMOOTH_LINE_WIDTH_RANGE;
        pub const SMOOTH_LINE_WIDTH_GRANULARITY = bindings.SMOOTH_LINE_WIDTH_GRANULARITY;
        pub const ALIASED_LINE_WIDTH_RANGE = bindings.ALIASED_LINE_WIDTH_RANGE;

        pub fn drawRangeElements(prim_type: PrimitiveType, start: u32, end: u32, indices: []const u16) void {
            bindings.drawRangeElements(
                @intFromEnum(prim_type),
                start,
                end,
                @intCast(indices.len),
                UNSIGNED_SHORT,
                indices.ptr,
            );
        }

        pub fn drawRangeElementsU32(prim_type: PrimitiveType, start: u32, end: u32, indices: []const u32) void {
            bindings.drawRangeElements(
                @intFromEnum(prim_type),
                start,
                end,
                @intCast(indices.len),
                UNSIGNED_INT,
                indices.ptr,
            );
        }

        pub fn texImage3D(args: struct {
            target: TexImage3DTarget,
            level: i32 = 0,
            internal_format: InternalFormat,
            width: u32,
            height: u32,
            depth: u32,
            border: i32 = 0,
            format: PixelFormat,
            pixel_type: PixelType,
            data: ?[*]const u8,
        }) void {
            bindings.texImage3D(
                @intFromEnum(args.target),
                args.level,
                @intFromEnum(args.internal_format),
                @intCast(args.width),
                @intCast(args.height),
                @intCast(args.depth),
                args.border,
                @intFromEnum(args.format),
                @intFromEnum(args.pixel_type),
                args.data,
            );
        }

        pub fn texSubImage3D(
            target: TexImageTarget,
            level: i32,
            xoffset: i32,
            yoffset: i32,
            zoffset: i32,
            width: u32,
            height: u32,
            depth: u32,
            format: PixelFormat,
            pixel_type: PixelType,
            data: ?[*]const u8,
        ) void {
            bindings.texSubImage3D(
                @intFromEnum(target),
                level,
                xoffset,
                yoffset,
                zoffset,
                @intCast(width),
                @intCast(height),
                @intCast(depth),
                @intFromEnum(format),
                @intFromEnum(pixel_type),
                data,
            );
        }

        pub fn copyTexSubImage3D(
            target: TexImageTarget,
            level: i32,
            xoffset: i32,
            yoffset: i32,
            zoffset: i32,
            x: i32,
            y: i32,
            width: u32,
            height: u32,
        ) void {
            bindings.copyTexSubImage3D(
                @intFromEnum(target),
                level,
                xoffset,
                yoffset,
                zoffset,
                x,
                y,
                @intCast(width),
                @intCast(height),
            );
        }

        //------------------------------------------------------------------------------------------
        //
        // OpenGL 1.3 (Core Profile)
        //
        //------------------------------------------------------------------------------------------
        pub const TEXTURE0 = bindings.TEXTURE0;
        pub const TEXTURE1 = bindings.TEXTURE1;
        pub const TEXTURE2 = bindings.TEXTURE2;
        pub const TEXTURE3 = bindings.TEXTURE3;
        pub const TEXTURE4 = bindings.TEXTURE4;
        pub const TEXTURE5 = bindings.TEXTURE5;
        pub const TEXTURE6 = bindings.TEXTURE6;
        pub const TEXTURE7 = bindings.TEXTURE7;
        pub const TEXTURE8 = bindings.TEXTURE8;
        pub const TEXTURE9 = bindings.TEXTURE9;
        pub const TEXTURE10 = bindings.TEXTURE10;
        pub const TEXTURE11 = bindings.TEXTURE11;
        pub const TEXTURE12 = bindings.TEXTURE12;
        pub const TEXTURE13 = bindings.TEXTURE13;
        pub const TEXTURE14 = bindings.TEXTURE14;
        pub const TEXTURE15 = bindings.TEXTURE15;
        pub const TEXTURE16 = bindings.TEXTURE16;
        pub const TEXTURE17 = bindings.TEXTURE17;
        pub const TEXTURE18 = bindings.TEXTURE18;
        pub const TEXTURE19 = bindings.TEXTURE19;
        pub const TEXTURE20 = bindings.TEXTURE20;
        pub const TEXTURE21 = bindings.TEXTURE21;
        pub const TEXTURE22 = bindings.TEXTURE22;
        pub const TEXTURE23 = bindings.TEXTURE23;
        pub const TEXTURE24 = bindings.TEXTURE24;
        pub const TEXTURE25 = bindings.TEXTURE25;
        pub const TEXTURE26 = bindings.TEXTURE26;
        pub const TEXTURE27 = bindings.TEXTURE27;
        pub const TEXTURE28 = bindings.TEXTURE28;
        pub const TEXTURE29 = bindings.TEXTURE29;
        pub const TEXTURE30 = bindings.TEXTURE30;
        pub const TEXTURE31 = bindings.TEXTURE31;
        pub const ACTIVE_TEXTURE = bindings.ACTIVE_TEXTURE;
        pub const MULTISAMPLE = bindings.MULTISAMPLE;
        pub const SAMPLE_ALPHA_TO_COVERAGE = bindings.SAMPLE_ALPHA_TO_COVERAGE;
        pub const SAMPLE_ALPHA_TO_ONE = bindings.SAMPLE_ALPHA_TO_ONE;
        pub const SAMPLE_COVERAGE = bindings.SAMPLE_COVERAGE;
        pub const SAMPLE_BUFFERS = bindings.SAMPLE_BUFFERS;
        pub const SAMPLES = bindings.SAMPLES;
        pub const SAMPLE_COVERAGE_VALUE = bindings.SAMPLE_COVERAGE_VALUE;
        pub const SAMPLE_COVERAGE_INVERT = bindings.SAMPLE_COVERAGE_INVERT;
        pub const TEXTURE_CUBE_MAP = bindings.TEXTURE_CUBE_MAP;
        pub const TEXTURE_BINDING_CUBE_MAP = bindings.TEXTURE_BINDING_CUBE_MAP;
        pub const TEXTURE_CUBE_MAP_POSITIVE_X = bindings.TEXTURE_CUBE_MAP_POSITIVE_X;
        pub const TEXTURE_CUBE_MAP_NEGATIVE_X = bindings.TEXTURE_CUBE_MAP_NEGATIVE_X;
        pub const TEXTURE_CUBE_MAP_POSITIVE_Y = bindings.TEXTURE_CUBE_MAP_POSITIVE_Y;
        pub const TEXTURE_CUBE_MAP_NEGATIVE_Y = bindings.TEXTURE_CUBE_MAP_NEGATIVE_Y;
        pub const TEXTURE_CUBE_MAP_POSITIVE_Z = bindings.TEXTURE_CUBE_MAP_POSITIVE_Z;
        pub const TEXTURE_CUBE_MAP_NEGATIVE_Z = bindings.TEXTURE_CUBE_MAP_NEGATIVE_Z;
        pub const PROXY_TEXTURE_CUBE_MAP = bindings.PROXY_TEXTURE_CUBE_MAP;
        pub const MAX_CUBE_MAP_TEXTURE_SIZE = bindings.MAX_CUBE_MAP_TEXTURE_SIZE;
        pub const COMPRESSED_RGB = bindings.COMPRESSED_RGB;
        pub const COMPRESSED_RGBA = bindings.COMPRESSED_RGBA;
        pub const TEXTURE_COMPRESSION_HINT = bindings.TEXTURE_COMPRESSION_HINT;
        pub const TEXTURE_COMPRESSED_IMAGE_SIZE = bindings.TEXTURE_COMPRESSED_IMAGE_SIZE;
        pub const TEXTURE_COMPRESSED = bindings.TEXTURE_COMPRESSED;
        pub const NUM_COMPRESSED_TEXTURE_FORMATS = bindings.NUM_COMPRESSED_TEXTURE_FORMATS;
        pub const COMPRESSED_TEXTURE_FORMATS = bindings.COMPRESSED_TEXTURE_FORMATS;
        pub const CLAMP_TO_BORDER = bindings.CLAMP_TO_BORDER;

        pub fn activeTexture(texture_unit: TexUnit) void {
            bindings.activeTexture(@intFromEnum(texture_unit));
        }

        pub fn sampleCoverage(value: f32, invert: bool) void {
            bindings.sampleCoverage(value, if (invert) TRUE else FALSE);
        }

        pub fn compressedTexImage3D(
            target: TexImageTarget,
            level: i32,
            internal_format: CompressedPixelFormat,
            width: u32,
            height: u32,
            depth: u32,
            border: i32,
            data: []const u8,
        ) void {
            bindings.compressedTexImage3D(
                @intFromEnum(target),
                level,
                @intFromEnum(internal_format),
                @intCast(width),
                @intCast(height),
                @intCast(depth),
                border,
                @intCast(data.len),
                data.ptr,
            );
        }

        pub fn compressedTexImage2D(
            target: TexImageTarget,
            level: i32,
            internal_format: CompressedPixelFormat,
            width: u32,
            height: u32,
            border: i32,
            data: []const u8,
        ) void {
            bindings.compressedTexImage2D(
                @intFromEnum(target),
                level,
                @intFromEnum(internal_format),
                @intCast(width),
                @intCast(height),
                border,
                @intCast(data.len),
                data.ptr,
            );
        }

        pub fn compressedTexImage1D(
            target: TexImageTarget,
            level: i32,
            internal_format: CompressedPixelFormat,
            width: u32,
            border: i32,
            data: []const u8,
        ) void {
            bindings.compressedTexImage1D(
                @intFromEnum(target),
                level,
                @intFromEnum(internal_format),
                @intCast(width),
                border,
                @intCast(data.len),
                data.ptr,
            );
        }

        pub fn compressedTexSubImage3D(
            target: TexImageTarget,
            level: i32,
            xoffset: i32,
            yoffset: i32,
            zoffset: i32,
            width: u32,
            height: u32,
            depth: u32,
            format: CompressedPixelFormat,
            data: []const u8,
        ) void {
            bindings.compressedTexSubImage3D(
                @intFromEnum(target),
                level,
                xoffset,
                yoffset,
                zoffset,
                @intCast(width),
                @intCast(height),
                @intCast(depth),
                @intFromEnum(format),
                @intCast(data.len),
                data.ptr,
            );
        }

        pub fn compressedTexSubImage2D(
            target: TexImageTarget,
            level: i32,
            xoffset: i32,
            yoffset: i32,
            width: u32,
            height: u32,
            format: CompressedPixelFormat,
            data: []const u8,
        ) void {
            bindings.compressedTexSubImage2D(
                @intFromEnum(target),
                level,
                xoffset,
                yoffset,
                @intCast(width),
                @intCast(height),
                @intFromEnum(format),
                @intCast(data.len),
                data.ptr,
            );
        }

        pub fn compressedTexSubImage1D(
            target: TexImageTarget,
            level: i32,
            xoffset: i32,
            width: u32,
            format: CompressedPixelFormat,
            data: []const u8,
        ) void {
            bindings.compressedTexSubImage1D(
                @intFromEnum(target),
                level,
                xoffset,
                @intCast(width),
                @intFromEnum(format),
                @intCast(data.len),
                data.ptr,
            );
        }

        pub fn getCompressedTexImage(target: TexLevelTarget, level: i32, data: [*]u8) void {
            bindings.getCompressedTexImage(@intFromEnum(target), level, data);
        }

        //------------------------------------------------------------------------------------------
        //
        // OpenGL 1.4 (Core Profile)
        //
        //------------------------------------------------------------------------------------------
        pub const BLEND_DST_RGB = bindings.BLEND_DST_RGB;
        pub const BLEND_SRC_RGB = bindings.BLEND_SRC_RGB;
        pub const BLEND_DST_ALPHA = bindings.BLEND_DST_ALPHA;
        pub const BLEND_SRC_ALPHA = bindings.BLEND_SRC_ALPHA;
        pub const POINT_FADE_THRESHOLD_SIZE = bindings.POINT_FADE_THRESHOLD_SIZE;
        pub const DEPTH_COMPONENT16 = bindings.DEPTH_COMPONENT16;
        pub const DEPTH_COMPONENT24 = bindings.DEPTH_COMPONENT24;
        pub const DEPTH_COMPONENT32 = bindings.DEPTH_COMPONENT32;
        pub const MIRRORED_REPEAT = bindings.MIRRORED_REPEAT;
        pub const MAX_TEXTURE_LOD_BIAS = bindings.MAX_TEXTURE_LOD_BIAS;
        pub const TEXTURE_LOD_BIAS = bindings.TEXTURE_LOD_BIAS;
        pub const INCR_WRAP = bindings.INCR_WRAP;
        pub const DECR_WRAP = bindings.DECR_WRAP;
        pub const TEXTURE_DEPTH_SIZE = bindings.TEXTURE_DEPTH_SIZE;
        pub const TEXTURE_COMPARE_MODE = bindings.TEXTURE_COMPARE_MODE;
        pub const TEXTURE_COMPARE_FUNC = bindings.TEXTURE_COMPARE_FUNC;
        pub const BLEND_COLOR = bindings.BLEND_COLOR;
        pub const BLEND_EQUATION = bindings.BLEND_EQUATION;
        pub const CONSTANT_COLOR = bindings.CONSTANT_COLOR;
        pub const ONE_MINUS_CONSTANT_COLOR = bindings.ONE_MINUS_CONSTANT_COLOR;
        pub const CONSTANT_ALPHA = bindings.CONSTANT_ALPHA;
        pub const ONE_MINUS_CONSTANT_ALPHA = bindings.ONE_MINUS_CONSTANT_ALPHA;
        pub const FUNC_ADD = bindings.FUNC_ADD;
        pub const FUNC_REVERSE_SUBTRACT = bindings.FUNC_REVERSE_SUBTRACT;
        pub const FUNC_SUBTRACT = bindings.FUNC_SUBTRACT;
        pub const MIN = bindings.MIN;
        pub const MAX = bindings.MAX;

        pub fn blendFuncSeparate(src_rgb: BlendFactor, dst_rgb: BlendFactor, src_alpha: BlendFactor, dst_alpha: BlendFactor) void {
            bindings.blendFuncSeparate(@intFromEnum(src_rgb), @intFromEnum(dst_rgb), @intFromEnum(src_alpha), @intFromEnum(dst_alpha));
        }

        pub fn multiDrawArrays(prim_type: PrimitiveType, first: []const i32, count: []const u32) void {
            assert(first.len == count.len);
            bindings.multiDrawArrays(@intFromEnum(prim_type), first.ptr, @ptrCast(count.ptr), @intCast(first.len));
        }

        pub fn multiDrawElements(prim_type: PrimitiveType, count: []const u32, index_type: DrawIndicesType, indices: []const ?*const anyopaque) void {
            assert(count.len == indices.len);
            bindings.multiDrawElements(@intFromEnum(prim_type), @ptrCast(count.ptr), @intFromEnum(index_type), indices.ptr, @intCast(count.len));
        }

        pub fn pointParameterf(pname: enum(Enum) { point_fade_threshold_size = POINT_FADE_THRESHOLD_SIZE }, param: f32) void {
            bindings.pointParameterf(@intFromEnum(pname), param);
        }

        pub fn pointParameterfv(pname: enum(Enum) { point_fade_threshold_size = POINT_FADE_THRESHOLD_SIZE }, params: []const f32) void {
            bindings.pointParameterfv(@intFromEnum(pname), params.ptr);
        }

        pub fn pointParameteri(pname: enum(Enum) { point_fade_threshold_size = POINT_FADE_THRESHOLD_SIZE }, param: i32) void {
            bindings.pointParameteri(@intFromEnum(pname), param);
        }

        pub fn pointParameteriv(pname: enum(Enum) { point_fade_threshold_size = POINT_FADE_THRESHOLD_SIZE }, params: []const i32) void {
            bindings.pointParameteriv(@intFromEnum(pname), params.ptr);
        }

        pub fn blendColor(red: f32, green: f32, blue: f32, alpha: f32) void {
            bindings.blendColor(red, green, blue, alpha);
        }

        pub fn blendEquation(mode: BlendEquation) void {
            bindings.blendEquation(@intFromEnum(mode));
        }

        //------------------------------------------------------------------------------------------
        //
        // OpenGL 1.5 (Core Profile)
        //
        //------------------------------------------------------------------------------------------
        pub const Sizeiptr = bindings.Sizeiptr;
        pub const Intptr = bindings.Intptr;

        pub const BUFFER_SIZE = bindings.BUFFER_SIZE;
        pub const BUFFER_USAGE = bindings.BUFFER_USAGE;
        pub const QUERY_COUNTER_BITS = bindings.QUERY_COUNTER_BITS;
        pub const CURRENT_QUERY = bindings.CURRENT_QUERY;
        pub const QUERY_RESULT = bindings.QUERY_RESULT;
        pub const QUERY_RESULT_AVAILABLE = bindings.QUERY_RESULT_AVAILABLE;
        pub const ARRAY_BUFFER = bindings.ARRAY_BUFFER;
        pub const ELEMENT_ARRAY_BUFFER = bindings.ELEMENT_ARRAY_BUFFER;
        pub const ARRAY_BUFFER_BINDING = bindings.ARRAY_BUFFER_BINDING;
        pub const ELEMENT_ARRAY_BUFFER_BINDING = bindings.ELEMENT_ARRAY_BUFFER_BINDING;
        pub const VERTEX_ATTRIB_ARRAY_BUFFER_BINDING = bindings.VERTEX_ATTRIB_ARRAY_BUFFER_BINDING;
        pub const READ_ONLY = bindings.READ_ONLY;
        pub const WRITE_ONLY = bindings.WRITE_ONLY;
        pub const READ_WRITE = bindings.READ_WRITE;
        pub const BUFFER_ACCESS = bindings.BUFFER_ACCESS;
        pub const BUFFER_MAPPED = bindings.BUFFER_MAPPED;
        pub const BUFFER_MAP_POINTER = bindings.BUFFER_MAP_POINTER;
        pub const STREAM_DRAW = bindings.STREAM_DRAW;
        pub const STREAM_READ = bindings.STREAM_READ;
        pub const STREAM_COPY = bindings.STREAM_COPY;
        pub const STATIC_DRAW = bindings.STATIC_DRAW;
        pub const STATIC_READ = bindings.STATIC_READ;
        pub const STATIC_COPY = bindings.STATIC_COPY;
        pub const DYNAMIC_DRAW = bindings.DYNAMIC_DRAW;
        pub const DYNAMIC_READ = bindings.DYNAMIC_READ;
        pub const DYNAMIC_COPY = bindings.DYNAMIC_COPY;
        pub const SAMPLES_PASSED = bindings.SAMPLES_PASSED;
        pub const SRC1_ALPHA = bindings.SRC1_ALPHA;

        // pub var genQueries: *const fn (n: Sizei, ids: [*c]Uint) callconv(.c) void = undefined;
        pub fn genQuery(ptr: *Query) void {
            bindings.genQueries(1, @as([*c]Uint, @ptrCast(ptr)));
        }
        pub fn genQueries(queries: []Query) void {
            bindings.genQueries(@intCast(queries.len), @as([*c]Uint, @ptrCast(queries.ptr)));
        }

        // pub var deleteQueries: *const fn (n: Sizei, ids: [*c]const Uint) callconv(.c) void = undefined;
        pub fn deleteQuery(ptr: *const Query) void {
            bindings.deleteQueries(1, @as([*c]const Uint, @ptrCast(ptr)));
        }
        pub fn deleteQueries(queries: []const Query) void {
            bindings.deleteQueries(@intCast(queries.len), @as([*c]const Uint, @ptrCast(queries.ptr)));
        }

        // pub var isQuery: *const fn (id: Uint) callconv(.c) Boolean = undefined;
        pub fn isQuery(query: Query) bool {
            return bindings.isQuery(@intFromEnum(query)) == TRUE;
        }

        // pub var beginQuery: *const fn (target: Enum, id: Uint) callconv(.c) void = undefined;
        pub fn beginQuery(target: QueryTarget, query: Query) void {
            bindings.beginQuery(@intFromEnum(target), @intFromEnum(query));
        }

        // pub var endQuery: *const fn (target: Enum) callconv(.c) void = undefined;
        pub fn endQuery(target: QueryTarget) void {
            bindings.endQuery(@intFromEnum(target));
        }

        // pub var getQueryiv: *const fn (target: Enum, pname: Enum, params: [*c]Int) callconv(.c) void = undefined;
        pub fn getQueryiv(
            target: QueryTargetWithTimestamp,
            pname: QueryParameter,
            params: []i32,
        ) void {
            bindings.getQueryiv(
                @intFromEnum(target),
                @intFromEnum(pname),
                @as([*c]Int, @ptrCast(params.ptr)),
            );
        }

        // pub var getQueryObjectiv: *const fn (id: Uint, pname: Enum, params: [*c]Int) callconv(.c) void = undefined;
        pub fn getQueryObjectiv(query: Query, pname: QueryObjectParameter, params: []i32) void {
            bindings.getQueryObjectiv(@intFromEnum(query), @intFromEnum(pname), @as([*c]Int, @ptrCast(params.ptr)));
        }

        // pub var getQueryObjectuiv: *const fn (id: Uint, pname: Enum, params: [*c]Uint) callconv(.c) void = undefined;
        pub fn getQueryObjectuiv(query: Query, pname: QueryObjectParameter, params: []u32) void {
            bindings.getQueryObjectuiv(@intFromEnum(query), @intFromEnum(pname), @as([*c]Uint, @ptrCast(params.ptr)));
        }

        // pub var bindBuffer: *const fn (target: Enum, buffer: Uint) callconv(.c) void = undefined;
        pub fn bindBuffer(target: BufferTarget, buffer: Buffer) void {
            bindings.bindBuffer(@intFromEnum(target), @intFromEnum(buffer));
        }

        // pub var deleteBuffers: *const fn (n: Sizei, buffers: [*c]const Uint) callconv(.c) void = undefined;
        pub fn deleteBuffer(ptr: *const Buffer) void {
            bindings.deleteBuffers(1, @as([*c]const Uint, @ptrCast(ptr)));
        }
        pub fn deleteBuffers(buffers: []const Buffer) void {
            bindings.deleteBuffers(@intCast(buffers.len), @as([*c]const Uint, @ptrCast(buffers.ptr)));
        }

        // pub var genBuffers: *const fn (n: Sizei, buffers: [*c]Uint) callconv(.c) void = undefined;
        pub fn genBuffer(ptr: *Buffer) void {
            bindings.genBuffers(1, @as([*c]Uint, @ptrCast(ptr)));
        }
        pub fn genBuffers(buffers: []Buffer) void {
            bindings.genBuffers(@intCast(buffers.len), @as([*c]Uint, @ptrCast(buffers.ptr)));
        }

        // pub var isBuffer: *const fn (buffer: Uint) callconv(.c) Boolean = undefined;
        pub fn isBuffer(buffer: Buffer) bool {
            return bindings.isBuffer(@intFromEnum(buffer)) == TRUE;
        }

        // pub var bufferData: *const fn (
        //     target: Enum,
        //     size: Sizeiptr,
        //     data: ?*const anyopaque,
        //     usage: Enum,
        // ) callconv(.c) void = undefined;
        pub fn bufferData(
            target: BufferTarget,
            size: usize,
            bytes: ?[*]const u8,
            usage: BufferUsage,
        ) void {
            bindings.bufferData(
                @intFromEnum(target),
                @as(Sizeiptr, @bitCast(size)),
                bytes,
                @intFromEnum(usage),
            );
        }

        // pub var bufferSubData: *const fn (
        //     target: Enum,
        //     offset: Intptr,
        //     size: Sizeiptr,
        //     data: ?*const anyopaque,
        // ) callconv(.c) void = undefined;
        pub fn bufferSubData(target: BufferTarget, offset: usize, bytes: []const u8) void {
            bindings.bufferSubData(
                @intFromEnum(target),
                @as(Intptr, @bitCast(offset)),
                @as(Sizeiptr, @bitCast(bytes.len)),
                bytes.ptr,
            );
        }

        // pub var getBufferSubData: *const fn (
        //     target: Enum,
        //     offset: Intptr,
        //     size: Sizeiptr,
        //     data: ?*anyopaque,
        // ) callconv(.c) void = undefined;
        pub fn getBufferSubData(
            target: BufferTarget,
            offset: usize,
            data: []u8,
        ) void {
            bindings.getBufferSubData(
                @intFromEnum(target),
                @as(Intptr, @bitCast(offset)),
                @as(Sizeiptr, @bitCast(data.len)),
                data.ptr,
            );
        }

        // pub var mapBuffer: *const fn (target: Enum, access: Enum) callconv(.c) ?*anyopaque = undefined;
        pub fn mapBuffer(target: BufferTarget, access: Access) ?[*]u8 {
            return @ptrCast(bindings.mapBuffer(@intFromEnum(target), @intFromEnum(access)));
        }

        // pub var unmapBuffer: *const fn (target: Enum) callconv(.c) Boolean = undefined;
        pub fn unmapBuffer(target: BufferTarget) bool {
            return bindings.unmapBuffer(@intFromEnum(target)) == TRUE;
        }

        // pub var getBufferParameteriv: *const fn (target: Enum, pname: Enum, params: [*c]Int) callconv(.c) void = undefined;
        pub fn getBufferParameteriv(target: BufferTarget, pname: BufferParameter, params: []i32) void {
            bindings.getBufferParameteriv(
                @intFromEnum(target),
                @intFromEnum(pname),
                @as([*c]Int, @ptrCast(params.ptr)),
            );
        }

        // pub var getBufferPointerv: *const fn (
        //     target: Enum,
        //     pname: Enum,
        //     params: [*c]?*anyopaque,
        // ) callconv(.c) void = undefined;
        pub fn getBufferPointerv(target: BufferTarget, pname: BufferPointerParameter, params: *?[*]u8) void {
            bindings.getBufferPointerv(
                @intFromEnum(target),
                @intFromEnum(pname),
                @as([*c]?*anyopaque, @ptrCast(params)),
            );
        }

        //------------------------------------------------------------------------------------------
        //
        // OpenGL 2.0 (Core Profile)
        //
        //------------------------------------------------------------------------------------------
        pub const Char = bindings.Char;
        pub const Short = bindings.Short;
        pub const Byte = bindings.Byte;
        pub const Ushort = bindings.Ushort;

        pub const BLEND_EQUATION_RGB = bindings.BLEND_EQUATION_RGB;
        pub const VERTEX_ATTRIB_ARRAY_ENABLED = bindings.VERTEX_ATTRIB_ARRAY_ENABLED;
        pub const VERTEX_ATTRIB_ARRAY_SIZE = bindings.VERTEX_ATTRIB_ARRAY_SIZE;
        pub const VERTEX_ATTRIB_ARRAY_STRIDE = bindings.VERTEX_ATTRIB_ARRAY_STRIDE;
        pub const VERTEX_ATTRIB_ARRAY_TYPE = bindings.VERTEX_ATTRIB_ARRAY_TYPE;
        pub const CURRENT_VERTEX_ATTRIB = bindings.CURRENT_VERTEX_ATTRIB;
        pub const VERTEX_PROGRAM_POINT_SIZE = bindings.VERTEX_PROGRAM_POINT_SIZE;
        pub const VERTEX_ATTRIB_ARRAY_POINTER = bindings.VERTEX_ATTRIB_ARRAY_POINTER;
        pub const STENCIL_BACK_FUNC = bindings.STENCIL_BACK_FUNC;
        pub const STENCIL_BACK_FAIL = bindings.STENCIL_BACK_FAIL;
        pub const STENCIL_BACK_PASS_DEPTH_FAIL = bindings.STENCIL_BACK_PASS_DEPTH_FAIL;
        pub const STENCIL_BACK_PASS_DEPTH_PASS = bindings.STENCIL_BACK_PASS_DEPTH_PASS;
        pub const MAX_DRAW_BUFFERS = bindings.MAX_DRAW_BUFFERS;
        pub const DRAW_BUFFER0 = bindings.DRAW_BUFFER0;
        pub const DRAW_BUFFER1 = bindings.DRAW_BUFFER1;
        pub const DRAW_BUFFER2 = bindings.DRAW_BUFFER2;
        pub const DRAW_BUFFER3 = bindings.DRAW_BUFFER3;
        pub const DRAW_BUFFER4 = bindings.DRAW_BUFFER4;
        pub const DRAW_BUFFER5 = bindings.DRAW_BUFFER5;
        pub const DRAW_BUFFER6 = bindings.DRAW_BUFFER6;
        pub const DRAW_BUFFER7 = bindings.DRAW_BUFFER7;
        pub const DRAW_BUFFER8 = bindings.DRAW_BUFFER8;
        pub const DRAW_BUFFER9 = bindings.DRAW_BUFFER9;
        pub const DRAW_BUFFER10 = bindings.DRAW_BUFFER10;
        pub const DRAW_BUFFER11 = bindings.DRAW_BUFFER11;
        pub const DRAW_BUFFER12 = bindings.DRAW_BUFFER12;
        pub const DRAW_BUFFER13 = bindings.DRAW_BUFFER13;
        pub const DRAW_BUFFER14 = bindings.DRAW_BUFFER14;
        pub const DRAW_BUFFER15 = bindings.DRAW_BUFFER15;
        pub const BLEND_EQUATION_ALPHA = bindings.BLEND_EQUATION_ALPHA;
        pub const MAX_VERTEX_ATTRIBS = bindings.MAX_VERTEX_ATTRIBS;
        pub const VERTEX_ATTRIB_ARRAY_NORMALIZED = bindings.VERTEX_ATTRIB_ARRAY_NORMALIZED;
        pub const MAX_TEXTURE_IMAGE_UNITS = bindings.MAX_TEXTURE_IMAGE_UNITS;
        pub const FRAGMENT_SHADER = bindings.FRAGMENT_SHADER;
        pub const VERTEX_SHADER = bindings.VERTEX_SHADER;
        pub const MAX_FRAGMENT_UNIFORM_COMPONENTS = bindings.MAX_FRAGMENT_UNIFORM_COMPONENTS;
        pub const MAX_VERTEX_UNIFORM_COMPONENTS = bindings.MAX_VERTEX_UNIFORM_COMPONENTS;
        pub const MAX_VARYING_FLOATS = bindings.MAX_VARYING_FLOATS;
        pub const MAX_VERTEX_TEXTURE_IMAGE_UNITS = bindings.MAX_VERTEX_TEXTURE_IMAGE_UNITS;
        pub const MAX_COMBINED_TEXTURE_IMAGE_UNITS = bindings.MAX_COMBINED_TEXTURE_IMAGE_UNITS;
        pub const SHADER_TYPE = bindings.SHADER_TYPE;
        pub const FLOAT_VEC2 = bindings.FLOAT_VEC2;
        pub const FLOAT_VEC3 = bindings.FLOAT_VEC3;
        pub const FLOAT_VEC4 = bindings.FLOAT_VEC4;
        pub const INT_VEC2 = bindings.INT_VEC2;
        pub const INT_VEC3 = bindings.INT_VEC3;
        pub const INT_VEC4 = bindings.INT_VEC4;
        pub const BOOL = bindings.BOOL;
        pub const BOOL_VEC2 = bindings.BOOL_VEC2;
        pub const BOOL_VEC3 = bindings.BOOL_VEC3;
        pub const BOOL_VEC4 = bindings.BOOL_VEC4;
        pub const FLOAT_MAT2 = bindings.FLOAT_MAT2;
        pub const FLOAT_MAT3 = bindings.FLOAT_MAT3;
        pub const FLOAT_MAT4 = bindings.FLOAT_MAT4;
        pub const SAMPLER_1D = bindings.SAMPLER_1D;
        pub const SAMPLER_2D = bindings.SAMPLER_2D;
        pub const SAMPLER_3D = bindings.SAMPLER_3D;
        pub const SAMPLER_CUBE = bindings.SAMPLER_CUBE;
        pub const SAMPLER_1D_SHADOW = bindings.SAMPLER_1D_SHADOW;
        pub const SAMPLER_2D_SHADOW = bindings.SAMPLER_2D_SHADOW;
        pub const DELETE_STATUS = bindings.DELETE_STATUS;
        pub const COMPILE_STATUS = bindings.COMPILE_STATUS;
        pub const LINK_STATUS = bindings.LINK_STATUS;
        pub const VALIDATE_STATUS = bindings.VALIDATE_STATUS;
        pub const INFO_LOG_LENGTH = bindings.INFO_LOG_LENGTH;
        pub const ATTACHED_SHADERS = bindings.ATTACHED_SHADERS;
        pub const ACTIVE_UNIFORMS = bindings.ACTIVE_UNIFORMS;
        pub const ACTIVE_UNIFORM_MAX_LENGTH = bindings.ACTIVE_UNIFORM_MAX_LENGTH;
        pub const SHADER_SOURCE_LENGTH = bindings.SHADER_SOURCE_LENGTH;
        pub const ACTIVE_ATTRIBUTES = bindings.ACTIVE_ATTRIBUTES;
        pub const ACTIVE_ATTRIBUTE_MAX_LENGTH = bindings.ACTIVE_ATTRIBUTE_MAX_LENGTH;
        pub const FRAGMENT_SHADER_DERIVATIVE_HINT = bindings.FRAGMENT_SHADER_DERIVATIVE_HINT;
        pub const SHADING_LANGUAGE_VERSION = bindings.SHADING_LANGUAGE_VERSION;
        pub const CURRENT_PROGRAM = bindings.CURRENT_PROGRAM;
        pub const POINT_SPRITE_COORD_ORIGIN = bindings.POINT_SPRITE_COORD_ORIGIN;
        pub const LOWER_LEFT = bindings.LOWER_LEFT;
        pub const UPPER_LEFT = bindings.UPPER_LEFT;
        pub const STENCIL_BACK_REF = bindings.STENCIL_BACK_REF;
        pub const STENCIL_BACK_VALUE_MASK = bindings.STENCIL_BACK_VALUE_MASK;
        pub const STENCIL_BACK_WRITEMASK = bindings.STENCIL_BACK_WRITEMASK;

        // pub var blendEquationSeparate: *const fn (modeRGB: Enum, modeAlpha: Enum) callconv(.c) void = undefined;
        pub fn blendEquationSeparate(modeRGB: BlendEquation, modeAlpha: BlendEquation) void {
            bindings.blendEquationSeparate(@intFromEnum(modeRGB), @intFromEnum(modeAlpha));
        }

        // pub var drawBuffers: *const fn (n: Sizei, bufs: [*c]const Enum) callconv(.c) void = undefined;
        pub fn drawBuffers(bufs: []const ColorBufferSingle) void {
            bindings.drawBuffers(
                @as(Sizei, @intCast(bufs.len)),
                @ptrCast(bufs.ptr),
            );
        }

        // pub var stencilOpSeparate: *const fn (
        //     face: Enum,
        //     sfail: Enum,
        //     dpfail: Enum,
        //     dppass: Enum,
        // ) callconv(.c) void = undefined;
        pub fn stencilOpSeparate(
            face: Face,
            sfail: StencilAction,
            dpfail: StencilAction,
            dppass: StencilAction,
        ) void {
            bindings.stencilOpSeparate(
                @intFromEnum(face),
                @intFromEnum(sfail),
                @intFromEnum(dpfail),
                @intFromEnum(dppass),
            );
        }

        // pub var stencilFuncSeparate: *const fn (face: Enum, func: Enum, ref: Int, mask: Uint) callconv(.c) void = undefined;
        pub fn stencilFuncSeparate(
            face: Face,
            func: Func,
            ref: i32,
            mask: u32,
        ) void {
            bindings.stencilFuncSeparate(
                @intFromEnum(face),
                @intFromEnum(func),
                @as(Int, @bitCast(ref)),
                @as(Uint, @bitCast(mask)),
            );
        }

        // pub var stencilMaskSeparate: *const fn (face: Enum, mask: Uint) callconv(.c) void = undefined;
        pub fn stencilMaskSeparate(face: Face, mask: u32) void {
            bindings.stencilMaskSeparate(
                @intFromEnum(face),
                @as(Uint, @bitCast(mask)),
            );
        }

        // pub var attachShader: *const fn (program: Uint, shader: Uint) callconv(.c) void = undefined;
        pub fn attachShader(program: Program, shader: Shader) void {
            assert(program != Program.invalid);
            assert(shader != Shader.invalid);
            bindings.attachShader(@intFromEnum(program), @intFromEnum(shader));
        }

        // pub var bindAttribLocation: *const fn (
        //     program: Uint,
        //     index: Uint,
        //     name: [*c]const Char,
        // ) callconv(.c) void = undefined;
        pub fn bindAttribLocation(
            program: Program,
            location: VertexAttribLocation,
            name: [:0]const u8,
        ) void {
            assert(program != .invalid);
            // prefix 'gl_' is reserved and cannot be used
            assert(!std.mem.startsWith(u8, name, "gl_"));
            bindings.bindAttribLocation(
                @intFromEnum(program),
                @intFromEnum(location),
                @ptrCast(name.ptr),
            );
        }

        // pub var compileShader: *const fn (shader: Uint) callconv(.c) void = undefined;
        pub fn compileShader(shader: Shader) void {
            assert(shader != Shader.invalid);
            bindings.compileShader(@intFromEnum(shader));
        }

        // pub var createProgram: *const fn () callconv(.c) Uint = undefined;
        pub fn createProgram() !Program {
            const maybe_program = bindings.createProgram();
            if (maybe_program == @intFromEnum(Program.invalid)) {
                return error.glCreateProgramFailed;
            }
            return @enumFromInt(maybe_program);
        }

        // pub var createShader: *const fn (type: Enum) callconv(.c) Uint = undefined;
        pub fn createShader(shader_type: ShaderType) !Shader {
            const maybe_shader = bindings.createShader(@intFromEnum(shader_type));
            if (maybe_shader == @intFromEnum(Shader.invalid)) {
                return error.glCreateShaderFailed;
            }
            return @enumFromInt(maybe_shader);
        }

        // pub var deleteProgram: *const fn (program: Uint) callconv(.c) void = undefined;
        pub fn deleteProgram(program: Program) void {
            assert(program != Program.invalid);
            bindings.deleteProgram(@intFromEnum(program));
        }

        // pub var deleteShader: *const fn (shader: Uint) callconv(.c) void = undefined;
        pub fn deleteShader(shader: Shader) void {
            assert(shader != Shader.invalid);
            bindings.deleteShader(@intFromEnum(shader));
        }

        // pub var detachShader: *const fn (program: Uint, shader: Uint) callconv(.c) void = undefined;
        pub fn detachShader(program: Program, shader: Shader) void {
            assert(program != .invalid);
            assert(shader != .invalid);
            bindings.detachShader(@intFromEnum(program), @intFromEnum(shader));
        }

        // pub var disableVertexAttribArray: *const fn (index: Uint) callconv(.c) void = undefined;
        pub fn disableVertexAttribArray(location: VertexAttribLocation) void {
            bindings.disableVertexAttribArray(@intFromEnum(location));
        }

        // pub var enableVertexAttribArray: *const fn (index: Uint) callconv(.c) void = undefined;
        pub fn enableVertexAttribArray(location: VertexAttribLocation) void {
            bindings.enableVertexAttribArray(@intFromEnum(location));
        }

        // pub var getActiveAttrib: *const fn (
        //     program: Uint,
        //     index: Uint,
        //     bufSize: Sizei,
        //     length: [*c]Sizei,
        //     size: [*c]Int,
        //     type: [*c]Enum,
        //     name: [*c]Char,
        // ) callconv(.c) void = undefined;
        pub fn getActiveAttrib(
            program: Program,
            index: u32,
            size: *i32,
            attrib_type: *AttribType,
            name_buf: [:0]u8,
        ) [:0]const u8 {
            assert(program != .invalid);
            var length: i32 = undefined;
            bindings.getActiveAttrib(
                @intFromEnum(program),
                @as(Uint, @bitCast(index)),
                // includes null terminator
                @as(Sizei, @intCast(name_buf.len + 1)),
                // excludes null terminator
                @as([*c]Sizei, @ptrCast(&length)),
                @as([*c]Int, @ptrCast(size)),
                @as([*c]Enum, @ptrCast(attrib_type)),
                @ptrCast(name_buf.ptr),
            );
            return name_buf[0..@intCast(length) :0];
        }

        // pub var getActiveUniform: *const fn (
        //     program: Uint,
        //     index: Uint,
        //     bufSize: Sizei,
        //     length: [*c]Sizei,
        //     size: [*c]Int,
        //     type: [*c]Enum,
        //     name: [*c]Char,
        // ) callconv(.c) Int = undefined;
        pub fn getActiveUniform(
            program: Program,
            index: u32,
            size: *i32,
            attrib_type: *UniformType,
            name_buf: [:0]u8,
        ) [:0]const u8 {
            assert(program != .invalid);
            var length: i32 = undefined;
            bindings.getActiveUniform(
                @intFromEnum(program),
                @as(Uint, @bitCast(index)),
                // includes null terminator
                @as(Sizei, @intCast(name_buf.len + 1)),
                // excludes null terminator
                @as([*c]Sizei, @ptrCast(&length)),
                @as([*c]Int, @ptrCast(size)),
                @as([*c]Enum, @ptrCast(attrib_type)),
                @ptrCast(name_buf.ptr),
            );
            return name_buf[0..@intCast(length) :0];
        }

        // pub var getAttachedShaders: *const fn (
        //     program: Uint,
        //     maxCount: Sizei,
        //     count: [*c]Sizei,
        //     shaders: [*c]Uint,
        // ) callconv(.c) void = undefined;
        pub fn getAttachedShaders(program: Program, shaders: []Shader) []const Shader {
            assert(program != .invalid);
            var count: i32 = undefined;
            bindings.getAttachedShaders(
                @intFromEnum(program),
                @as(Sizei, @intCast(shaders.len)),
                @as([*c]Sizei, @ptrCast(&count)),
                @ptrCast(shaders.ptr),
            );
            return shaders[0..@intCast(count)];
        }

        // pub var getAttribLocation: *const fn (program: Uint, name: [*c]const Char) callconv(.c) Int = undefined;
        pub fn getAttribLocation(program: Program, name: [:0]const u8) ?VertexAttribLocation {
            assert(program != Program.invalid);
            const location = bindings.getAttribLocation(@intFromEnum(program), @ptrCast(name.ptr));
            return if (location < 0) null else @enumFromInt(location);
        }

        // pub var getProgramiv: *const fn (program: Uint, pname: Enum, params: [*c]Int) callconv(.c) void = undefined;
        pub fn getProgramiv(program: Program, parameter: ProgramParameter) Int {
            assert(program != Program.invalid);
            var value: Int = undefined;
            bindings.getProgramiv(@intFromEnum(program), @intFromEnum(parameter), &value);
            return value;
        }

        // pub var getProgramInfoLog: *const fn (
        //     program: Uint,
        //     bufSize: Sizei,
        //     length: [*c]Sizei,
        //     infoLog: [*c]Char,
        // ) callconv(.c) void = undefined;
        pub fn getProgramInfoLog(program: Program, buffer: []u8) ?[]const u8 {
            assert(program != Program.invalid);
            assert(buffer.len > 0);
            assert(buffer.len <= std.math.maxInt(u32));
            var log_len: Sizei = 0;
            bindings.getProgramInfoLog(
                @intFromEnum(program),
                @as(Sizei, @intCast(buffer.len)),
                &log_len,
                @ptrCast(buffer.ptr),
            );
            return if (log_len > 0) buffer[0..@as(usize, @intCast(log_len))] else null;
        }

        // pub var getShaderiv: *const fn (shader: Uint, pname: Enum, params: [*c]Int) callconv(.c) void = undefined;
        pub fn getShaderiv(shader: Shader, parameter: ShaderParameter) Int {
            assert(shader != Shader.invalid);
            var value: Int = undefined;
            bindings.getShaderiv(@intFromEnum(shader), @intFromEnum(parameter), &value);
            return value;
        }

        // pub var getShaderInfoLog: *const fn (
        //     shader: Uint,
        //     bufSize: Sizei,
        //     length: [*c]Sizei,
        //     infoLog: [*c]Char,
        // ) callconv(.c) void = undefined;
        pub fn getShaderInfoLog(shader: Shader, buffer: []u8) ?[]const u8 {
            assert(shader != Shader.invalid);
            assert(buffer.len > 0);
            assert(buffer.len <= std.math.maxInt(u32));
            var log_len: Sizei = 0;
            bindings.getShaderInfoLog(
                @intFromEnum(shader),
                @as(Sizei, @intCast(buffer.len)),
                &log_len,
                @ptrCast(buffer.ptr),
            );
            return if (log_len > 0) buffer[0..@as(usize, @intCast(log_len))] else null;
        }

        // pub var getShaderSource: *const fn (
        //     shader: Uint,
        //     bufSize: Sizei,
        //     length: [*c]Sizei,
        //     source: [*c]Char,
        // ) callconv(.c) void = undefined;
        pub fn getShaderSource(shader: Shader, source: [:0]u8) [:0]const u8 {
            assert(shader != Shader.invalid);
            var length: i32 = undefined;
            bindings.getShaderSource(
                @intFromEnum(shader),
                // includes null terminator
                @as(Sizei, @intCast(source.len + 1)),
                // excludes null terminator
                @as([*c]Sizei, @ptrCast(&length)),
                @ptrCast(source.ptr),
            );
            return source[0..@intCast(length) :0];
        }

        // pub var getUniformLocation: *const fn (program: Uint, name: [*c]const Char) callconv(.c) Int = undefined;
        pub fn getUniformLocation(program: Program, name: [:0]const u8) ?UniformLocation {
            assert(program != Program.invalid);
            assert(name.len > 0);
            const location = bindings.getUniformLocation(@intFromEnum(program), @ptrCast(name.ptr));
            return if (location < 0) null else @enumFromInt(location);
        }

        // pub var getUniformfv: *const fn (program: Uint, location: Int, params: [*c]Float) callconv(.c) void = undefined;
        pub fn getUniformfv(program: Program, location: UniformLocation, params: []f32) void {
            assert(program != .invalid);
            assert(location != .invalid);
            bindings.getUniformfv(
                @intFromEnum(program),
                @intFromEnum(location),
                @ptrCast(params.ptr),
            );
        }

        // pub var getUniformiv: *const fn (program: Uint, location: Int, params: [*c]Int) callconv(.c) void = undefined;
        pub fn getUniformiv(program: Program, location: UniformLocation, params: []i32) void {
            assert(program != .invalid);
            assert(location != .invalid);
            bindings.getUniformiv(
                @intFromEnum(program),
                @intFromEnum(location),
                @ptrCast(params.ptr),
            );
        }

        // pub var getVertexAttribdv: *const fn (index: Uint, pname: Enum, params: [*c]Double) callconv(.c) void = undefined;
        pub fn getVertexAttribdv(
            location: VertexAttribLocation,
            pname: VertexAttribParameter,
            params: []f64,
        ) void {
            bindings.getVertexAttribdv(
                @intFromEnum(location),
                @intFromEnum(pname),
                @ptrCast(params.ptr),
            );
        }

        // pub var getVertexAttribfv: *const fn (index: Uint, pname: Enum, params: [*c]Float) callconv(.c) void = undefined;
        pub fn getVertexAttribfv(
            location: VertexAttribLocation,
            pname: VertexAttribParameter,
            params: []f32,
        ) void {
            bindings.getVertexAttribfv(
                @intFromEnum(location),
                @intFromEnum(pname),
                @ptrCast(params.ptr),
            );
        }

        // pub var getVertexAttribiv: *const fn (index: Uint, pname: Enum, params: [*c]Int) callconv(.c) void = undefined;
        pub fn getVertexAttribiv(
            location: VertexAttribLocation,
            pname: VertexAttribParameter,
            params: []i32,
        ) void {
            bindings.getVertexAttribiv(
                @intFromEnum(location),
                @intFromEnum(pname),
                @ptrCast(params.ptr),
            );
        }

        // pub var getVertexAttribPointerv: *const fn (
        //     index: Uint,
        //     pname: Enum,
        //     pointer: [*c]?*anyopaque,
        // ) callconv(.c) void = undefined;
        pub fn getVertexAttribPointerv(
            location: VertexAttribLocation,
            pname: VertexAttribPointerParameter,
            pointer: **allowzero anyopaque,
        ) void {
            bindings.getVertexAttribPointerv(
                @intFromEnum(location),
                @intFromEnum(pname),
                @ptrCast(pointer),
            );
        }

        // pub var isProgram: *const fn (program: Uint) callconv(.c) Boolean = undefined;
        pub fn isProgram(program: Program) bool {
            return bindings.isProgram(@intFromEnum(program)) == TRUE;
        }

        // pub var isShader: *const fn (shader: Uint) callconv(.c) Boolean = undefined;
        pub fn isShader(shader: Shader) bool {
            return bindings.isShader(@intFromEnum(shader)) == TRUE;
        }

        // pub var linkProgram: *const fn (program: Uint) callconv(.c) void = undefined;
        pub fn linkProgram(program: Program) void {
            assert(program != Program.invalid);
            bindings.linkProgram(@intFromEnum(program));
        }

        // pub var shaderSource: *const fn (
        //     shader: Uint,
        //     count: Sizei,
        //     string: [*c]const [*c]const Char,
        //     length: [*c]const Int,
        // ) callconv(.c) void = undefined;
        pub fn shaderSource(
            shader: Shader,
            src_ptrs: []const [*:0]const u8,
            maybe_src_lengths: ?[]const u32,
        ) void {
            assert(shader != Shader.invalid);
            assert(src_ptrs.len > 0);
            assert(src_ptrs.len <= std.math.maxInt(u32));
            if (maybe_src_lengths) |src_lengths| {
                assert(src_ptrs.len == src_lengths.len);
            }
            bindings.shaderSource(
                @intFromEnum(shader),
                @as(Sizei, @bitCast(@as(u32, @intCast(src_ptrs.len)))),
                @as([*c]const [*c]const Char, @ptrCast(src_ptrs)),
                if (maybe_src_lengths) |src_lengths| @as([*c]const Int, @ptrCast(src_lengths.ptr)) else null,
            );
        }

        // pub var useProgram: *const fn (program: Uint) callconv(.c) void = undefined;
        pub fn useProgram(program: Program) void {
            bindings.useProgram(@intFromEnum(program));
        }

        // pub var uniform1f: *const fn (location: Int, v0: Float) callconv(.c) void = undefined;
        pub fn uniform1f(location: UniformLocation, v0: f32) void {
            assert(location != UniformLocation.invalid);
            bindings.uniform1f(@intFromEnum(location), v0);
        }

        // pub var uniform2f: *const fn (location: Int, v0: Float, v1: Float) callconv(.c) void = undefined;
        pub fn uniform2f(location: UniformLocation, v0: f32, v1: f32) void {
            assert(location != UniformLocation.invalid);
            bindings.uniform2f(@intFromEnum(location), v0, v1);
        }

        // pub var uniform3f: *const fn (location: Int, v0: Float, v1: Float, v2: Float) callconv(.c) void = undefined;
        pub fn uniform3f(location: UniformLocation, v0: f32, v1: f32, v2: f32) void {
            assert(location != UniformLocation.invalid);
            bindings.uniform3f(@intFromEnum(location), v0, v1, v2);
        }

        // pub var uniform4f: *const fn (
        //     location: Int,
        //     v0: Float,
        //     v1: Float,
        //     v2: Float,
        //     v3: Float,
        // ) callconv(.c) void = undefined;
        pub fn uniform4f(location: UniformLocation, v0: f32, v1: f32, v2: f32, v3: f32) void {
            assert(location != UniformLocation.invalid);
            bindings.uniform4f(@intFromEnum(location), v0, v1, v2, v3);
        }

        // pub var uniform1i: *const fn (location: Int, v0: Int) callconv(.c) void = undefined;
        pub fn uniform1i(location: UniformLocation, v0: Int) void {
            assert(location != UniformLocation.invalid);
            bindings.uniform1i(@intFromEnum(location), v0);
        }

        // pub var uniform2i: *const fn (location: Int, v0: Int, v1: Int) callconv(.c) void = undefined;
        pub fn uniform2i(location: UniformLocation, v0: i32, v1: i32) void {
            assert(location != UniformLocation.invalid);
            bindings.uniform2i(@intFromEnum(location), v0, v1);
        }

        // pub var uniform3i: *const fn (location: Int, v0: Int, v1: Int, v2: Int) callconv(.c) void = undefined;
        pub fn uniform3i(location: UniformLocation, v0: i32, v1: i32, v2: i32) void {
            assert(location != UniformLocation.invalid);
            bindings.uniform3i(@intFromEnum(location), v0, v1, v2);
        }

        // pub var uniform4i: *const fn (
        //     location: Int,
        //     v0: Int,
        //     v1: Int,
        //     v2: Int,
        //     v3: Int,
        // ) callconv(.c) void = undefined;
        pub fn uniform4i(location: UniformLocation, v0: i32, v1: i32, v2: i32, v3: i32) void {
            assert(location != UniformLocation.invalid);
            bindings.uniform4i(@intFromEnum(location), v0, v1, v2, v3);
        }

        // pub var uniform1fv: *const fn (
        //     location: Int,
        //     count: Sizei,
        //     value: [*c]const Float,
        // ) callconv(.c) void = undefined;
        pub fn uniform1fv(location: UniformLocation, count: u32, value: []const f32) void {
            assert(location != .invalid);
            assert(value.len == count);
            bindings.uniform1fv(
                @intFromEnum(location),
                @as(Sizei, @bitCast(count)),
                @ptrCast(value.ptr),
            );
        }

        // pub var uniform2fv: *const fn (
        //     location: Int,
        //     count: Sizei,
        //     value: [*c]const Float,
        // ) callconv(.c) void = undefined;
        pub fn uniform2fv(location: UniformLocation, count: u32, value: []const f32) void {
            const vec_size = 2;
            assert(location != .invalid);
            assert(value.len % vec_size == 0);
            assert(value.len / vec_size == count);
            bindings.uniform2fv(
                @intFromEnum(location),
                @as(Sizei, @bitCast(count)),
                @ptrCast(value.ptr),
            );
        }

        // pub var uniform3fv: *const fn (
        //     location: Int,
        //     count: Sizei,
        //     value: [*c]const Float,
        // ) callconv(.c) void = undefined;
        pub fn uniform3fv(location: UniformLocation, count: u32, value: []const f32) void {
            const vec_size = 3;
            assert(location != .invalid);
            assert(value.len % vec_size == 0);
            assert(value.len / vec_size == count);
            bindings.uniform3fv(
                @intFromEnum(location),
                @as(Sizei, @bitCast(count)),
                @ptrCast(value.ptr),
            );
        }

        // pub var uniform4fv: *const fn (
        //     location: Int,
        //     count: Sizei,
        //     value: [*c]const Float,
        // ) callconv(.c) void = undefined;
        pub fn uniform4fv(location: UniformLocation, count: u32, value: []const f32) void {
            const vec_size = 4;
            assert(location != .invalid);
            assert(value.len % vec_size == 0);
            assert(value.len / vec_size == count);
            bindings.uniform4fv(
                @intFromEnum(location),
                @as(Sizei, @bitCast(count)),
                @ptrCast(value.ptr),
            );
        }

        // pub var uniform1iv: *const fn (location: Int, count: Sizei, value: [*c]const Int) callconv(.c) void = undefined;
        pub fn uniform1iv(location: UniformLocation, count: u32, value: []const i32) void {
            assert(location != .invalid);
            assert(value.len == count);
            bindings.uniform1iv(
                @intFromEnum(location),
                @as(Sizei, @bitCast(count)),
                @ptrCast(value.ptr),
            );
        }

        // pub var uniform2iv: *const fn (location: Int, count: Sizei, value: [*c]const Int) callconv(.c) void = undefined;
        pub fn uniform2iv(location: UniformLocation, count: u32, value: []const i32) void {
            const vec_size = 2;
            assert(location != .invalid);
            assert(value.len % vec_size == 0);
            assert(value.len / vec_size == count);
            bindings.uniform2iv(
                @intFromEnum(location),
                @as(Sizei, @bitCast(count)),
                @ptrCast(value.ptr),
            );
        }

        // pub var uniform3iv: *const fn (location: Int, count: Sizei, value: [*c]const Int) callconv(.c) void = undefined;
        pub fn uniform3iv(location: UniformLocation, count: u32, value: []const i32) void {
            const vec_size = 3;
            assert(location != .invalid);
            assert(value.len % vec_size == 0);
            assert(value.len / vec_size == count);
            bindings.uniform3iv(
                @intFromEnum(location),
                @as(Sizei, @bitCast(count)),
                @ptrCast(value.ptr),
            );
        }

        // pub var uniform4iv: *const fn (location: Int, count: Sizei, value: [*c]const Int) callconv(.c) void = undefined;
        pub fn uniform4iv(location: UniformLocation, count: u32, value: []const i32) void {
            const vec_size = 4;
            assert(location != .invalid);
            assert(value.len % vec_size == 0);
            assert(value.len / vec_size == count);
            bindings.uniform4iv(
                @intFromEnum(location),
                @as(Sizei, @bitCast(count)),
                @ptrCast(value.ptr),
            );
        }

        // pub var uniformMatrix2fv: *const fn (
        //     location: Int,
        //     count: Sizei,
        //     transpose: Boolean,
        //     value: [*c]const Float,
        // ) callconv(.c) void = undefined;
        pub fn uniformMatrix2fv(
            location: UniformLocation,
            count: u32,
            transpose: bool,
            value: []const f32,
        ) void {
            const mat_size = 2 * 2;
            assert(location != .invalid);
            assert(value.len % mat_size == 0);
            assert(value.len / mat_size == count);
            bindings.uniformMatrix2fv(
                @intFromEnum(location),
                @as(Sizei, @bitCast(count)),
                @intFromBool(transpose),
                @ptrCast(value.ptr),
            );
        }

        // pub var uniformMatrix3fv: *const fn (
        //     location: Int,
        //     count: Sizei,
        //     transpose: Boolean,
        //     value: [*c]const Float,
        // ) callconv(.c) void = undefined;
        pub fn uniformMatrix3fv(
            location: UniformLocation,
            count: u32,
            transpose: bool,
            value: []const f32,
        ) void {
            const mat_size = 3 * 3;
            assert(location != .invalid);
            assert(value.len % mat_size == 0);
            assert(value.len / mat_size == count);
            bindings.uniformMatrix3fv(
                @intFromEnum(location),
                @as(Sizei, @bitCast(count)),
                @intFromBool(transpose),
                @ptrCast(value.ptr),
            );
        }

        // pub var uniformMatrix4fv: *const fn (
        //     location: Int,
        //     count: Sizei,
        //     transpose: Boolean,
        //     value: [*c]const Float,
        // ) callconv(.c) void = undefined;
        pub fn uniformMatrix4fv(
            location: UniformLocation,
            count: u32,
            transpose: bool,
            value: []const f32,
        ) void {
            const mat_size = 4 * 4;
            assert(location != .invalid);
            assert(value.len % mat_size == 0);
            assert(value.len / mat_size == count);
            bindings.uniformMatrix4fv(
                @intFromEnum(location),
                @as(Sizei, @bitCast(count)),
                @intFromBool(transpose),
                @ptrCast(value.ptr),
            );
        }

        // pub var validateProgram: *const fn (program: Uint) callconv(.c) void = undefined;
        pub fn validateProgram(program: Program) void {
            assert(program != .invalid);
            bindings.validateProgram(@intFromEnum(program));
        }

        // pub var vertexAttrib1d: *const fn (index: Uint, x: Double) callconv(.c) void = undefined;
        pub fn vertexAttrib1d(location: VertexAttribLocation, x: f64) void {
            bindings.vertexAttrib1d(@intFromEnum(location), x);
        }

        // pub var vertexAttrib1dv: *const fn (index: Uint, v: [*c]const Double) callconv(.c) void = undefined;
        pub fn vertexAttrib1dv(location: VertexAttribLocation, v: []const f64) void {
            bindings.vertexAttrib1dv(@intFromEnum(location), @ptrCast(v.ptr));
        }

        // pub var vertexAttrib1f: *const fn (index: Uint, x: Float) callconv(.c) void = undefined;
        pub fn vertexAttrib1f(location: VertexAttribLocation, x: f32) void {
            bindings.vertexAttrib1f(@intFromEnum(location), x);
        }

        // pub var vertexAttrib1fv: *const fn (index: Uint, v: [*c]const Float) callconv(.c) void = undefined;
        pub fn vertexAttrib1fv(location: VertexAttribLocation, v: []const f32) void {
            bindings.vertexAttrib1fv(@intFromEnum(location), @ptrCast(v.ptr));
        }

        // pub var vertexAttrib1s: *const fn (index: Uint, x: Short) callconv(.c) void = undefined;
        pub fn vertexAttrib1s(location: VertexAttribLocation, x: i16) void {
            bindings.vertexAttrib1s(@intFromEnum(location), x);
        }

        // pub var vertexAttrib1sv: *const fn (index: Uint, v: [*c]const Short) callconv(.c) void = undefined;
        pub fn vertexAttrib1sv(location: VertexAttribLocation, v: []const i16) void {
            bindings.vertexAttrib1sv(@intFromEnum(location), @ptrCast(v.ptr));
        }

        // pub var vertexAttrib2d: *const fn (index: Uint, x: Double, y: Double) callconv(.c) void = undefined;
        pub fn vertexAttrib2d(location: VertexAttribLocation, x: f64, y: f64) void {
            bindings.vertexAttrib2d(@intFromEnum(location), x, y);
        }

        // pub var vertexAttrib2dv: *const fn (index: Uint, v: [*c]const Double) callconv(.c) void = undefined;
        pub fn vertexAttrib2dv(location: VertexAttribLocation, v: []const f64) void {
            bindings.vertexAttrib2dv(@intFromEnum(location), @ptrCast(v.ptr));
        }

        // pub var vertexAttrib2f: *const fn (index: Uint, x: Float, y: Float) callconv(.c) void = undefined;
        pub fn vertexAttrib2f(location: VertexAttribLocation, x: f32, y: f32) void {
            bindings.vertexAttrib2f(@intFromEnum(location), x, y);
        }

        // pub var vertexAttrib2fv: *const fn (index: Uint, v: [*c]const Float) callconv(.c) void = undefined;
        pub fn vertexAttrib2fv(location: VertexAttribLocation, v: []const f32) void {
            bindings.vertexAttrib2fv(@intFromEnum(location), @ptrCast(v.ptr));
        }

        // pub var vertexAttrib2s: *const fn (index: Uint, x: Short, y: Short) callconv(.c) void = undefined;
        pub fn vertexAttrib2s(location: VertexAttribLocation, x: i16, y: i16) void {
            bindings.vertexAttrib2s(@intFromEnum(location), x, y);
        }

        // pub var vertexAttrib2sv: *const fn (index: Uint, v: [*c]const Short) callconv(.c) void = undefined;
        pub fn vertexAttrib2sv(location: VertexAttribLocation, v: []const i16) void {
            bindings.vertexAttrib2sv(@intFromEnum(location), @ptrCast(v.ptr));
        }

        // pub var vertexAttrib3d: *const fn (index: Uint, x: Double, y: Double, z: Double) callconv(.c) void = undefined;
        pub fn vertexAttrib3d(location: VertexAttribLocation, x: f64, y: f64, z: f64) void {
            bindings.vertexAttrib3d(@intFromEnum(location), x, y, z);
        }

        // pub var vertexAttrib3dv: *const fn (index: Uint, v: [*c]const Double) callconv(.c) void = undefined;
        pub fn vertexAttrib3dv(location: VertexAttribLocation, v: []const f64) void {
            bindings.vertexAttrib3dv(@intFromEnum(location), @ptrCast(v.ptr));
        }

        // pub var vertexAttrib3f: *const fn (index: Uint, x: Float, y: Float, z: Float) callconv(.c) void = undefined;
        pub fn vertexAttrib3f(location: VertexAttribLocation, x: f32, y: f32, z: f32) void {
            bindings.vertexAttrib3f(@intFromEnum(location), x, y, z);
        }

        // pub var vertexAttrib3fv: *const fn (index: Uint, v: [*c]const Float) callconv(.c) void = undefined;
        pub fn vertexAttrib3fv(location: VertexAttribLocation, v: []const f32) void {
            bindings.vertexAttrib3fv(@intFromEnum(location), @ptrCast(v.ptr));
        }

        // pub var vertexAttrib3s: *const fn (index: Uint, x: Short, y: Short, z: Short) callconv(.c) void = undefined;
        pub fn vertexAttrib3s(location: VertexAttribLocation, x: i16, y: i16, z: i16) void {
            bindings.vertexAttrib3s(@intFromEnum(location), x, y, z);
        }

        // pub var vertexAttrib3sv: *const fn (index: Uint, v: [*c]const Short) callconv(.c) void = undefined;
        pub fn vertexAttrib3sv(location: VertexAttribLocation, v: []const i16) void {
            bindings.vertexAttrib3sv(@intFromEnum(location), @ptrCast(v.ptr));
        }

        // pub var vertexAttrib4Nbv: *const fn (index: Uint, v: [*c]const Byte) callconv(.c) void = undefined;
        pub fn vertexAttrib4Nbv(location: VertexAttribLocation, v: []const i8) void {
            bindings.vertexAttrib4Nbv(@intFromEnum(location), @ptrCast(v.ptr));
        }

        // pub var vertexAttrib4Niv: *const fn (index: Uint, v: [*c]const Int) callconv(.c) void = undefined;
        pub fn vertexAttrib4Niv(location: VertexAttribLocation, v: []const i32) void {
            bindings.vertexAttrib4Niv(@intFromEnum(location), @ptrCast(v.ptr));
        }

        // pub var vertexAttrib4Nsv: *const fn (index: Uint, v: [*c]const Short) callconv(.c) void = undefined;
        pub fn vertexAttrib4Nsv(location: VertexAttribLocation, v: []const i16) void {
            bindings.vertexAttrib4Nsv(@intFromEnum(location), @ptrCast(v.ptr));
        }

        // pub var vertexAttrib4Nub: *const fn (
        //     index: Uint,
        //     x: Ubyte,
        //     y: Ubyte,
        //     z: Ubyte,
        //     w: Ubyte,
        // ) callconv(.c) void = undefined;
        pub fn vertexAttrib4Nub(
            location: VertexAttribLocation,
            x: u8,
            y: u8,
            z: u8,
            w: u8,
        ) void {
            bindings.vertexAttrib4Nub(
                @intFromEnum(location),
                x,
                y,
                z,
                w,
            );
        }

        // pub var vertexAttrib4Nubv: *const fn (index: Uint, v: [*c]const Ubyte) callconv(.c) void = undefined;
        pub fn vertexAttrib4Nubv(location: VertexAttribLocation, v: []const u8) void {
            bindings.vertexAttrib4Nubv(@intFromEnum(location), @ptrCast(v.ptr));
        }

        // pub var vertexAttrib4Nuiv: *const fn (index: Uint, v: [*c]const Uint) callconv(.c) void = undefined;
        pub fn vertexAttrib4Nuiv(location: VertexAttribLocation, v: []const u32) void {
            bindings.vertexAttrib4Nuiv(@intFromEnum(location), @ptrCast(v.ptr));
        }

        // pub var vertexAttrib4Nusv: *const fn (index: Uint, v: [*c]const Ushort) callconv(.c) void = undefined;
        pub fn vertexAttrib4Nusv(location: VertexAttribLocation, v: []const u16) void {
            bindings.vertexAttrib4Nusv(@intFromEnum(location), @ptrCast(v.ptr));
        }

        // pub var vertexAttrib4bv: *const fn (index: Uint, v: [*c]const Byte) callconv(.c) void = undefined;
        pub fn vertexAttrib4bv(location: VertexAttribLocation, v: []const i8) void {
            bindings.vertexAttrib4bv(@intFromEnum(location), @ptrCast(v.ptr));
        }

        // pub var vertexAttrib4d: *const fn (
        //     index: Uint,
        //     x: Double,
        //     y: Double,
        //     z: Double,
        //     w: Double,
        // ) callconv(.c) void = undefined;
        pub fn vertexAttrib4d(
            location: VertexAttribLocation,
            x: f64,
            y: f64,
            z: f64,
            w: f64,
        ) void {
            bindings.vertexAttrib4d(
                @intFromEnum(location),
                x,
                y,
                z,
                w,
            );
        }

        // pub var vertexAttrib4dv: *const fn (index: Uint, v: [*c]const Double) callconv(.c) void = undefined;
        pub fn vertexAttrib4dv(location: VertexAttribLocation, v: []const f64) void {
            bindings.vertexAttrib4dv(@intFromEnum(location), @ptrCast(v.ptr));
        }

        // pub var vertexAttrib4f: *const fn (
        //     index: Uint,
        //     x: Float,
        //     y: Float,
        //     z: Float,
        //     w: Float,
        // ) callconv(.c) void = undefined;
        pub fn vertexAttrib4f(
            location: VertexAttribLocation,
            x: f32,
            y: f32,
            z: f32,
            w: f32,
        ) void {
            bindings.vertexAttrib4f(
                @intFromEnum(location),
                x,
                y,
                z,
                w,
            );
        }

        // pub var vertexAttrib4fv: *const fn (index: Uint, v: [*c]const Float) callconv(.c) void = undefined;
        pub fn vertexAttrib4fv(location: VertexAttribLocation, v: []const f32) void {
            bindings.vertexAttrib4fv(@intFromEnum(location), @ptrCast(v.ptr));
        }

        // pub var vertexAttrib4iv: *const fn (index: Uint, v: [*c]const Int) callconv(.c) void = undefined;
        pub fn vertexAttrib4iv(location: VertexAttribLocation, v: []const i32) void {
            bindings.vertexAttrib4iv(@intFromEnum(location), @ptrCast(v.ptr));
        }

        // pub var vertexAttrib4s: *const fn (
        //     index: Uint,
        //     x: Short,
        //     y: Short,
        //     z: Short,
        //     w: Short,
        // ) callconv(.c) void = undefined;
        pub fn vertexAttrib4s(
            location: VertexAttribLocation,
            x: i16,
            y: i16,
            z: i16,
            w: i16,
        ) void {
            bindings.vertexAttrib4s(
                @intFromEnum(location),
                x,
                y,
                z,
                w,
            );
        }

        // pub var vertexAttrib4sv: *const fn (index: Uint, v: [*c]const Short) callconv(.c) void = undefined;
        pub fn vertexAttrib4sv(location: VertexAttribLocation, v: []const i16) void {
            bindings.vertexAttrib4sv(@intFromEnum(location), @ptrCast(v.ptr));
        }

        // pub var vertexAttrib4ubv: *const fn (index: Uint, v: [*c]const Ubyte) callconv(.c) void = undefined;
        pub fn vertexAttrib4ubv(location: VertexAttribLocation, v: []const u8) void {
            bindings.vertexAttrib4ubv(@intFromEnum(location), @ptrCast(v.ptr));
        }

        // pub var vertexAttrib4uiv: *const fn (index: Uint, v: [*c]const Uint) callconv(.c) void = undefined;
        pub fn vertexAttrib4uiv(location: VertexAttribLocation, v: []const u32) void {
            bindings.vertexAttrib4uiv(@intFromEnum(location), @ptrCast(v.ptr));
        }

        // pub var vertexAttrib4usv: *const fn (index: Uint, v: [*c]const Ushort) callconv(.c) void = undefined;
        pub fn vertexAttrib4usv(location: VertexAttribLocation, v: []const u16) void {
            bindings.vertexAttrib4usv(@intFromEnum(location), @ptrCast(v.ptr));
        }

        // pub var vertexAttribPointer: *const fn (
        //     index: Uint,
        //     size: Int,
        //     type: Enum,
        //     normalized: Boolean,
        //     stride: Sizei,
        //     pointer: ?*const anyopaque,
        // ) callconv(.c) void = undefined;
        pub fn vertexAttribPointer(
            location: VertexAttribLocation,
            size: u32,
            attrib_type: VertexAttribType,
            normalised: bool,
            stride: u32,
            offset: usize,
        ) void {
            bindings.vertexAttribPointer(
                @intFromEnum(location),
                @as(Int, @bitCast(size)),
                @intFromEnum(attrib_type),
                @intFromBool(normalised),
                @as(Sizei, @bitCast(stride)),
                @as(*allowzero const anyopaque, @ptrFromInt(offset)),
            );
        }

        //------------------------------------------------------------------------------------------
        //
        // OpenGL 2.1 (Core Profile)
        //
        //------------------------------------------------------------------------------------------
        pub const PIXEL_PACK_BUFFER = bindings.PIXEL_PACK_BUFFER;
        pub const PIXEL_UNPACK_BUFFER = bindings.PIXEL_UNPACK_BUFFER;
        pub const PIXEL_PACK_BUFFER_BINDING = bindings.PIXEL_PACK_BUFFER_BINDING;
        pub const PIXEL_UNPACK_BUFFER_BINDING = bindings.PIXEL_UNPACK_BUFFER_BINDING;
        pub const FLOAT_MAT2x3 = bindings.FLOAT_MAT2x3;
        pub const FLOAT_MAT2x4 = bindings.FLOAT_MAT2x4;
        pub const FLOAT_MAT3x2 = bindings.FLOAT_MAT3x2;
        pub const FLOAT_MAT3x4 = bindings.FLOAT_MAT3x4;
        pub const FLOAT_MAT4x2 = bindings.FLOAT_MAT4x2;
        pub const FLOAT_MAT4x3 = bindings.FLOAT_MAT4x3;
        pub const SRGB = bindings.SRGB;
        pub const SRGB8 = bindings.SRGB8;
        pub const SRGB_ALPHA = bindings.SRGB_ALPHA;
        pub const SRGB8_ALPHA8 = bindings.SRGB8_ALPHA8;
        pub const COMPRESSED_SRGB = bindings.COMPRESSED_SRGB;
        pub const COMPRESSED_SRGB_ALPHA = bindings.COMPRESSED_SRGB_ALPHA;

        // pub var uniformMatrix2x3fv: *const fn (
        //     location: Int,
        //     count: Sizei,
        //     transpose: Boolean,
        //     value: [*c]const Float,
        // ) callconv(.c) void = undefined;
        pub fn uniformMatrix2x3fv(
            location: UniformLocation,
            count: u32,
            transpose: bool,
            value: []const f32,
        ) void {
            const mat_size = 2 * 3;
            assert(location != .invalid);
            assert(value.len % mat_size == 0);
            assert(value.len / mat_size == count);
            bindings.uniformMatrix2x3fv(
                @intFromEnum(location),
                @as(Sizei, @bitCast(count)),
                @intFromBool(transpose),
                @ptrCast(value.ptr),
            );
        }

        // pub var uniformMatrix3x2fv: *const fn (
        //     location: Int,
        //     count: Sizei,
        //     transpose: Boolean,
        //     value: [*c]const Float,
        // ) callconv(.c) void = undefined;
        pub fn uniformMatrix3x2fv(
            location: UniformLocation,
            count: u32,
            transpose: bool,
            value: []const f32,
        ) void {
            const mat_size = 3 * 2;
            assert(location != .invalid);
            assert(value.len % mat_size == 0);
            assert(value.len / mat_size == count);
            bindings.uniformMatrix3x2fv(
                @intFromEnum(location),
                @as(Sizei, @bitCast(count)),
                @intFromBool(transpose),
                @ptrCast(value.ptr),
            );
        }

        // pub var uniformMatrix2x4fv: *const fn (
        //     location: Int,
        //     count: Sizei,
        //     transpose: Boolean,
        //     value: [*c]const Float,
        // ) callconv(.c) void = undefined;
        pub fn uniformMatrix2x4fv(
            location: UniformLocation,
            count: u32,
            transpose: bool,
            value: []const f32,
        ) void {
            const mat_size = 2 * 4;
            assert(location != .invalid);
            assert(value.len % mat_size == 0);
            assert(value.len / mat_size == count);
            bindings.uniformMatrix2x4fv(
                @intFromEnum(location),
                @as(Sizei, @bitCast(count)),
                @intFromBool(transpose),
                @ptrCast(value.ptr),
            );
        }

        // pub var uniformMatrix4x2fv: *const fn (
        //     location: Int,
        //     count: Sizei,
        //     transpose: Boolean,
        //     value: [*c]const Float,
        // ) callconv(.c) void = undefined;
        pub fn uniformMatrix4x2fv(
            location: UniformLocation,
            count: u32,
            transpose: bool,
            value: []const f32,
        ) void {
            const mat_size = 4 * 2;
            assert(location != .invalid);
            assert(value.len % mat_size == 0);
            assert(value.len / mat_size == count);
            bindings.uniformMatrix4x2fv(
                @intFromEnum(location),
                @as(Sizei, @bitCast(count)),
                @intFromBool(transpose),
                @ptrCast(value.ptr),
            );
        }

        // pub var uniformMatrix3x4fv: *const fn (
        //     location: Int,
        //     count: Sizei,
        //     transpose: Boolean,
        //     value: [*c]const Float,
        // ) callconv(.c) void = undefined;
        pub fn uniformMatrix3x4fv(
            location: UniformLocation,
            count: u32,
            transpose: bool,
            value: []const f32,
        ) void {
            const mat_size = 3 * 4;
            assert(location != .invalid);
            assert(value.len % mat_size == 0);
            assert(value.len / mat_size == count);
            bindings.uniformMatrix3x4fv(
                @intFromEnum(location),
                @as(Sizei, @bitCast(count)),
                @intFromBool(transpose),
                @ptrCast(value.ptr),
            );
        }

        // pub var uniformMatrix4x3fv: *const fn (
        //     location: Int,
        //     count: Sizei,
        //     transpose: Boolean,
        //     value: [*c]const Float,
        // ) callconv(.c) void = undefined;
        pub fn uniformMatrix4x3fv(
            location: UniformLocation,
            count: u32,
            transpose: bool,
            value: []const f32,
        ) void {
            const mat_size = 4 * 3;
            assert(location != .invalid);
            assert(value.len % mat_size == 0);
            assert(value.len / mat_size == count);
            bindings.uniformMatrix4x3fv(
                @intFromEnum(location),
                @as(Sizei, @bitCast(count)),
                @intFromBool(transpose),
                @ptrCast(value.ptr),
            );
        }

        //------------------------------------------------------------------------------------------
        //
        // OpenGL 3.0 (Core Profile)
        //
        //------------------------------------------------------------------------------------------
        pub const Half = bindings.Half;

        pub const COMPARE_REF_TO_TEXTURE = bindings.COMPARE_REF_TO_TEXTURE;
        pub const CLIP_DISTANCE0 = bindings.CLIP_DISTANCE0;
        pub const CLIP_DISTANCE1 = bindings.CLIP_DISTANCE1;
        pub const CLIP_DISTANCE2 = bindings.CLIP_DISTANCE2;
        pub const CLIP_DISTANCE3 = bindings.CLIP_DISTANCE3;
        pub const CLIP_DISTANCE4 = bindings.CLIP_DISTANCE4;
        pub const CLIP_DISTANCE5 = bindings.CLIP_DISTANCE5;
        pub const CLIP_DISTANCE6 = bindings.CLIP_DISTANCE6;
        pub const CLIP_DISTANCE7 = bindings.CLIP_DISTANCE7;
        pub const MAX_CLIP_DISTANCES = bindings.MAX_CLIP_DISTANCES;
        pub const MAJOR_VERSION = bindings.MAJOR_VERSION;
        pub const MINOR_VERSION = bindings.MINOR_VERSION;
        pub const NUM_EXTENSIONS = bindings.NUM_EXTENSIONS;
        pub const CONTEXT_FLAGS = bindings.CONTEXT_FLAGS;
        pub const COMPRESSED_RED = bindings.COMPRESSED_RED;
        pub const COMPRESSED_RG = bindings.COMPRESSED_RG;
        pub const CONTEXT_FLAG_FORWARD_COMPATIBLE_BIT = bindings.CONTEXT_FLAG_FORWARD_COMPATIBLE_BIT;
        pub const RGBA32F = bindings.RGBA32F;
        pub const RGB32F = bindings.RGB32F;
        pub const RGBA16F = bindings.RGBA16F;
        pub const RGB16F = bindings.RGB16F;
        pub const VERTEX_ATTRIB_ARRAY_INTEGER = bindings.VERTEX_ATTRIB_ARRAY_INTEGER;
        pub const MAX_ARRAY_TEXTURE_LAYERS = bindings.MAX_ARRAY_TEXTURE_LAYERS;
        pub const MIN_PROGRAM_TEXEL_OFFSET = bindings.MIN_PROGRAM_TEXEL_OFFSET;
        pub const MAX_PROGRAM_TEXEL_OFFSET = bindings.MAX_PROGRAM_TEXEL_OFFSET;
        pub const CLAMP_READ_COLOR = bindings.CLAMP_READ_COLOR;
        pub const FIXED_ONLY = bindings.FIXED_ONLY;
        pub const MAX_VARYING_COMPONENTS = bindings.MAX_VARYING_COMPONENTS;
        pub const TEXTURE_1D_ARRAY = bindings.TEXTURE_1D_ARRAY;
        pub const PROXY_TEXTURE_1D_ARRAY = bindings.PROXY_TEXTURE_1D_ARRAY;
        pub const TEXTURE_2D_ARRAY = bindings.TEXTURE_2D_ARRAY;
        pub const PROXY_TEXTURE_2D_ARRAY = bindings.PROXY_TEXTURE_2D_ARRAY;
        pub const TEXTURE_BINDING_1D_ARRAY = bindings.TEXTURE_BINDING_1D_ARRAY;
        pub const TEXTURE_BINDING_2D_ARRAY = bindings.TEXTURE_BINDING_2D_ARRAY;
        pub const R11F_G11F_B10F = bindings.R11F_G11F_B10F;
        pub const UNSIGNED_INT_10F_11F_11F_REV = bindings.UNSIGNED_INT_10F_11F_11F_REV;
        pub const RGB9_E5 = bindings.RGB9_E5;
        pub const UNSIGNED_INT_5_9_9_9_REV = bindings.UNSIGNED_INT_5_9_9_9_REV;
        pub const TEXTURE_SHARED_SIZE = bindings.TEXTURE_SHARED_SIZE;
        pub const TRANSFORM_FEEDBACK_VARYING_MAX_LENGTH = bindings.TRANSFORM_FEEDBACK_VARYING_MAX_LENGTH;
        pub const TRANSFORM_FEEDBACK_BUFFER_MODE = bindings.TRANSFORM_FEEDBACK_BUFFER_MODE;
        pub const MAX_TRANSFORM_FEEDBACK_SEPARATE_COMPONENTS = bindings.MAX_TRANSFORM_FEEDBACK_SEPARATE_COMPONENTS;
        pub const TRANSFORM_FEEDBACK_VARYINGS = bindings.TRANSFORM_FEEDBACK_VARYINGS;
        pub const TRANSFORM_FEEDBACK_BUFFER_START = bindings.TRANSFORM_FEEDBACK_BUFFER_START;
        pub const TRANSFORM_FEEDBACK_BUFFER_SIZE = bindings.TRANSFORM_FEEDBACK_BUFFER_SIZE;
        pub const PRIMITIVES_GENERATED = bindings.PRIMITIVES_GENERATED;
        pub const TRANSFORM_FEEDBACK_PRIMITIVES_WRITTEN = bindings.TRANSFORM_FEEDBACK_PRIMITIVES_WRITTEN;
        pub const RASTERIZER_DISCARD = bindings.RASTERIZER_DISCARD;
        pub const MAX_TRANSFORM_FEEDBACK_INTERLEAVED_COMPONENTS = bindings.MAX_TRANSFORM_FEEDBACK_INTERLEAVED_COMPONENTS;
        pub const MAX_TRANSFORM_FEEDBACK_SEPARATE_ATTRIBS = bindings.MAX_TRANSFORM_FEEDBACK_SEPARATE_ATTRIBS;
        pub const INTERLEAVED_ATTRIBS = bindings.INTERLEAVED_ATTRIBS;
        pub const SEPARATE_ATTRIBS = bindings.SEPARATE_ATTRIBS;
        pub const TRANSFORM_FEEDBACK_BUFFER = bindings.TRANSFORM_FEEDBACK_BUFFER;
        pub const TRANSFORM_FEEDBACK_BUFFER_BINDING = bindings.TRANSFORM_FEEDBACK_BUFFER_BINDING;
        pub const RGBA32UI = bindings.RGBA32UI;
        pub const RGB32UI = bindings.RGB32UI;
        pub const RGBA16UI = bindings.RGBA16UI;
        pub const RGB16UI = bindings.RGB16UI;
        pub const RGBA8UI = bindings.RGBA8UI;
        pub const RGB8UI = bindings.RGB8UI;
        pub const RGBA32I = bindings.RGBA32I;
        pub const RGB32I = bindings.RGB32I;
        pub const RGBA16I = bindings.RGBA16I;
        pub const RGB16I = bindings.RGB16I;
        pub const RGBA8I = bindings.RGBA8I;
        pub const RGB8I = bindings.RGB8I;
        pub const RED_INTEGER = bindings.RED_INTEGER;
        pub const GREEN_INTEGER = bindings.GREEN_INTEGER;
        pub const BLUE_INTEGER = bindings.BLUE_INTEGER;
        pub const RGB_INTEGER = bindings.RGB_INTEGER;
        pub const RGBA_INTEGER = bindings.RGBA_INTEGER;
        pub const BGR_INTEGER = bindings.BGR_INTEGER;
        pub const BGRA_INTEGER = bindings.BGRA_INTEGER;
        pub const SAMPLER_1D_ARRAY = bindings.SAMPLER_1D_ARRAY;
        pub const SAMPLER_2D_ARRAY = bindings.SAMPLER_2D_ARRAY;
        pub const SAMPLER_1D_ARRAY_SHADOW = bindings.SAMPLER_1D_ARRAY_SHADOW;
        pub const SAMPLER_2D_ARRAY_SHADOW = bindings.SAMPLER_2D_ARRAY_SHADOW;
        pub const SAMPLER_CUBE_SHADOW = bindings.SAMPLER_CUBE_SHADOW;
        pub const UNSIGNED_INT_VEC2 = bindings.UNSIGNED_INT_VEC2;
        pub const UNSIGNED_INT_VEC3 = bindings.UNSIGNED_INT_VEC3;
        pub const UNSIGNED_INT_VEC4 = bindings.UNSIGNED_INT_VEC4;
        pub const INT_SAMPLER_1D = bindings.INT_SAMPLER_1D;
        pub const INT_SAMPLER_2D = bindings.INT_SAMPLER_2D;
        pub const INT_SAMPLER_3D = bindings.INT_SAMPLER_3D;
        pub const INT_SAMPLER_CUBE = bindings.INT_SAMPLER_CUBE;
        pub const INT_SAMPLER_1D_ARRAY = bindings.INT_SAMPLER_1D_ARRAY;
        pub const INT_SAMPLER_2D_ARRAY = bindings.INT_SAMPLER_2D_ARRAY;
        pub const UNSIGNED_INT_SAMPLER_1D = bindings.UNSIGNED_INT_SAMPLER_1D;
        pub const UNSIGNED_INT_SAMPLER_2D = bindings.UNSIGNED_INT_SAMPLER_2D;
        pub const UNSIGNED_INT_SAMPLER_3D = bindings.UNSIGNED_INT_SAMPLER_3D;
        pub const UNSIGNED_INT_SAMPLER_CUBE = bindings.UNSIGNED_INT_SAMPLER_CUBE;
        pub const UNSIGNED_INT_SAMPLER_1D_ARRAY = bindings.UNSIGNED_INT_SAMPLER_1D_ARRAY;
        pub const UNSIGNED_INT_SAMPLER_2D_ARRAY = bindings.UNSIGNED_INT_SAMPLER_2D_ARRAY;
        pub const QUERY_WAIT = bindings.QUERY_WAIT;
        pub const QUERY_NO_WAIT = bindings.QUERY_NO_WAIT;
        pub const QUERY_BY_REGION_WAIT = bindings.QUERY_BY_REGION_WAIT;
        pub const QUERY_BY_REGION_NO_WAIT = bindings.QUERY_BY_REGION_NO_WAIT;
        pub const BUFFER_ACCESS_FLAGS = bindings.BUFFER_ACCESS_FLAGS;
        pub const BUFFER_MAP_LENGTH = bindings.BUFFER_MAP_LENGTH;
        pub const BUFFER_MAP_OFFSET = bindings.BUFFER_MAP_OFFSET;
        pub const DEPTH_COMPONENT32F = bindings.DEPTH_COMPONENT32F;
        pub const DEPTH32F_STENCIL8 = bindings.DEPTH32F_STENCIL8;
        pub const FLOAT_32_UNSIGNED_INT_24_8_REV = bindings.FLOAT_32_UNSIGNED_INT_24_8_REV;
        pub const INVALID_FRAMEBUFFER_OPERATION = bindings.INVALID_FRAMEBUFFER_OPERATION;
        pub const FRAMEBUFFER_ATTACHMENT_COLOR_ENCODING = bindings.FRAMEBUFFER_ATTACHMENT_COLOR_ENCODING;
        pub const FRAMEBUFFER_ATTACHMENT_COMPONENT_TYPE = bindings.FRAMEBUFFER_ATTACHMENT_COMPONENT_TYPE;
        pub const FRAMEBUFFER_ATTACHMENT_RED_SIZE = bindings.FRAMEBUFFER_ATTACHMENT_RED_SIZE;
        pub const FRAMEBUFFER_ATTACHMENT_GREEN_SIZE = bindings.FRAMEBUFFER_ATTACHMENT_GREEN_SIZE;
        pub const FRAMEBUFFER_ATTACHMENT_BLUE_SIZE = bindings.FRAMEBUFFER_ATTACHMENT_BLUE_SIZE;
        pub const FRAMEBUFFER_ATTACHMENT_ALPHA_SIZE = bindings.FRAMEBUFFER_ATTACHMENT_ALPHA_SIZE;
        pub const FRAMEBUFFER_ATTACHMENT_DEPTH_SIZE = bindings.FRAMEBUFFER_ATTACHMENT_DEPTH_SIZE;
        pub const FRAMEBUFFER_ATTACHMENT_STENCIL_SIZE = bindings.FRAMEBUFFER_ATTACHMENT_STENCIL_SIZE;
        pub const FRAMEBUFFER_DEFAULT = bindings.FRAMEBUFFER_DEFAULT;
        pub const FRAMEBUFFER_UNDEFINED = bindings.FRAMEBUFFER_UNDEFINED;
        pub const DEPTH_STENCIL_ATTACHMENT = bindings.DEPTH_STENCIL_ATTACHMENT;
        pub const MAX_RENDERBUFFER_SIZE = bindings.MAX_RENDERBUFFER_SIZE;
        pub const DEPTH_STENCIL = bindings.DEPTH_STENCIL;
        pub const UNSIGNED_INT_24_8 = bindings.UNSIGNED_INT_24_8;
        pub const DEPTH24_STENCIL8 = bindings.DEPTH24_STENCIL8;
        pub const TEXTURE_STENCIL_SIZE = bindings.TEXTURE_STENCIL_SIZE;
        pub const TEXTURE_RED_TYPE = bindings.TEXTURE_RED_TYPE;
        pub const TEXTURE_GREEN_TYPE = bindings.TEXTURE_GREEN_TYPE;
        pub const TEXTURE_BLUE_TYPE = bindings.TEXTURE_BLUE_TYPE;
        pub const TEXTURE_ALPHA_TYPE = bindings.TEXTURE_ALPHA_TYPE;
        pub const TEXTURE_DEPTH_TYPE = bindings.TEXTURE_DEPTH_TYPE;
        pub const UNSIGNED_NORMALIZED = bindings.UNSIGNED_NORMALIZED;
        pub const FRAMEBUFFER_BINDING = bindings.FRAMEBUFFER_BINDING;
        pub const DRAW_FRAMEBUFFER_BINDING = bindings.DRAW_FRAMEBUFFER_BINDING;
        pub const RENDERBUFFER_BINDING = bindings.RENDERBUFFER_BINDING;
        pub const READ_FRAMEBUFFER = bindings.READ_FRAMEBUFFER;
        pub const DRAW_FRAMEBUFFER = bindings.DRAW_FRAMEBUFFER;
        pub const READ_FRAMEBUFFER_BINDING = bindings.READ_FRAMEBUFFER_BINDING;
        pub const RENDERBUFFER_SAMPLES = bindings.RENDERBUFFER_SAMPLES;
        pub const FRAMEBUFFER_ATTACHMENT_OBJECT_TYPE = bindings.FRAMEBUFFER_ATTACHMENT_OBJECT_TYPE;
        pub const FRAMEBUFFER_ATTACHMENT_OBJECT_NAME = bindings.FRAMEBUFFER_ATTACHMENT_OBJECT_NAME;
        pub const FRAMEBUFFER_ATTACHMENT_TEXTURE_LEVEL = bindings.FRAMEBUFFER_ATTACHMENT_TEXTURE_LEVEL;
        pub const FRAMEBUFFER_ATTACHMENT_TEXTURE_CUBE_MAP_FACE = bindings.FRAMEBUFFER_ATTACHMENT_TEXTURE_CUBE_MAP_FACE;
        pub const FRAMEBUFFER_ATTACHMENT_TEXTURE_LAYER = bindings.FRAMEBUFFER_ATTACHMENT_TEXTURE_LAYER;
        pub const FRAMEBUFFER_COMPLETE = bindings.FRAMEBUFFER_COMPLETE;
        pub const FRAMEBUFFER_INCOMPLETE_ATTACHMENT = bindings.FRAMEBUFFER_INCOMPLETE_ATTACHMENT;
        pub const FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT = bindings.FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT;
        pub const FRAMEBUFFER_INCOMPLETE_DRAW_BUFFER = bindings.FRAMEBUFFER_INCOMPLETE_DRAW_BUFFER;
        pub const FRAMEBUFFER_INCOMPLETE_READ_BUFFER = bindings.FRAMEBUFFER_INCOMPLETE_READ_BUFFER;
        pub const FRAMEBUFFER_UNSUPPORTED = bindings.FRAMEBUFFER_UNSUPPORTED;
        pub const MAX_COLOR_ATTACHMENTS = bindings.MAX_COLOR_ATTACHMENTS;
        pub const COLOR_ATTACHMENT0 = bindings.COLOR_ATTACHMENT0;
        pub const COLOR_ATTACHMENT1 = bindings.COLOR_ATTACHMENT1;
        pub const COLOR_ATTACHMENT2 = bindings.COLOR_ATTACHMENT2;
        pub const COLOR_ATTACHMENT3 = bindings.COLOR_ATTACHMENT3;
        pub const COLOR_ATTACHMENT4 = bindings.COLOR_ATTACHMENT4;
        pub const COLOR_ATTACHMENT5 = bindings.COLOR_ATTACHMENT5;
        pub const COLOR_ATTACHMENT6 = bindings.COLOR_ATTACHMENT6;
        pub const COLOR_ATTACHMENT7 = bindings.COLOR_ATTACHMENT7;
        pub const COLOR_ATTACHMENT8 = bindings.COLOR_ATTACHMENT8;
        pub const COLOR_ATTACHMENT9 = bindings.COLOR_ATTACHMENT9;
        pub const COLOR_ATTACHMENT10 = bindings.COLOR_ATTACHMENT10;
        pub const COLOR_ATTACHMENT11 = bindings.COLOR_ATTACHMENT11;
        pub const COLOR_ATTACHMENT12 = bindings.COLOR_ATTACHMENT12;
        pub const COLOR_ATTACHMENT13 = bindings.COLOR_ATTACHMENT13;
        pub const COLOR_ATTACHMENT14 = bindings.COLOR_ATTACHMENT14;
        pub const COLOR_ATTACHMENT15 = bindings.COLOR_ATTACHMENT15;
        pub const COLOR_ATTACHMENT16 = bindings.COLOR_ATTACHMENT16;
        pub const COLOR_ATTACHMENT17 = bindings.COLOR_ATTACHMENT17;
        pub const COLOR_ATTACHMENT18 = bindings.COLOR_ATTACHMENT18;
        pub const COLOR_ATTACHMENT19 = bindings.COLOR_ATTACHMENT19;
        pub const COLOR_ATTACHMENT20 = bindings.COLOR_ATTACHMENT20;
        pub const COLOR_ATTACHMENT21 = bindings.COLOR_ATTACHMENT21;
        pub const COLOR_ATTACHMENT22 = bindings.COLOR_ATTACHMENT22;
        pub const COLOR_ATTACHMENT23 = bindings.COLOR_ATTACHMENT23;
        pub const COLOR_ATTACHMENT24 = bindings.COLOR_ATTACHMENT24;
        pub const COLOR_ATTACHMENT25 = bindings.COLOR_ATTACHMENT25;
        pub const COLOR_ATTACHMENT26 = bindings.COLOR_ATTACHMENT26;
        pub const COLOR_ATTACHMENT27 = bindings.COLOR_ATTACHMENT27;
        pub const COLOR_ATTACHMENT28 = bindings.COLOR_ATTACHMENT28;
        pub const COLOR_ATTACHMENT29 = bindings.COLOR_ATTACHMENT29;
        pub const COLOR_ATTACHMENT30 = bindings.COLOR_ATTACHMENT30;
        pub const COLOR_ATTACHMENT31 = bindings.COLOR_ATTACHMENT31;
        pub const DEPTH_ATTACHMENT = bindings.DEPTH_ATTACHMENT;
        pub const STENCIL_ATTACHMENT = bindings.STENCIL_ATTACHMENT;
        pub const FRAMEBUFFER = bindings.FRAMEBUFFER;
        pub const RENDERBUFFER = bindings.RENDERBUFFER;
        pub const RENDERBUFFER_WIDTH = bindings.RENDERBUFFER_WIDTH;
        pub const RENDERBUFFER_HEIGHT = bindings.RENDERBUFFER_HEIGHT;
        pub const RENDERBUFFER_INTERNAL_FORMAT = bindings.RENDERBUFFER_INTERNAL_FORMAT;
        pub const STENCIL_INDEX1 = bindings.STENCIL_INDEX1;
        pub const STENCIL_INDEX4 = bindings.STENCIL_INDEX4;
        pub const STENCIL_INDEX8 = bindings.STENCIL_INDEX8;
        pub const STENCIL_INDEX16 = bindings.STENCIL_INDEX16;
        pub const RENDERBUFFER_RED_SIZE = bindings.RENDERBUFFER_RED_SIZE;
        pub const RENDERBUFFER_GREEN_SIZE = bindings.RENDERBUFFER_GREEN_SIZE;
        pub const RENDERBUFFER_BLUE_SIZE = bindings.RENDERBUFFER_BLUE_SIZE;
        pub const RENDERBUFFER_ALPHA_SIZE = bindings.RENDERBUFFER_ALPHA_SIZE;
        pub const RENDERBUFFER_DEPTH_SIZE = bindings.RENDERBUFFER_DEPTH_SIZE;
        pub const RENDERBUFFER_STENCIL_SIZE = bindings.RENDERBUFFER_STENCIL_SIZE;
        pub const FRAMEBUFFER_INCOMPLETE_MULTISAMPLE = bindings.FRAMEBUFFER_INCOMPLETE_MULTISAMPLE;
        pub const MAX_SAMPLES = bindings.MAX_SAMPLES;
        pub const FRAMEBUFFER_SRGB = bindings.FRAMEBUFFER_SRGB;
        pub const HALF_FLOAT = bindings.HALF_FLOAT;
        pub const MAP_READ_BIT = bindings.MAP_READ_BIT;
        pub const MAP_WRITE_BIT = bindings.MAP_WRITE_BIT;
        pub const MAP_INVALIDATE_RANGE_BIT = bindings.MAP_INVALIDATE_RANGE_BIT;
        pub const MAP_INVALIDATE_BUFFER_BIT = bindings.MAP_INVALIDATE_BUFFER_BIT;
        pub const MAP_FLUSH_EXPLICIT_BIT = bindings.MAP_FLUSH_EXPLICIT_BIT;
        pub const MAP_UNSYNCHRONIZED_BIT = bindings.MAP_UNSYNCHRONIZED_BIT;
        pub const COMPRESSED_RED_RGTC1 = bindings.COMPRESSED_RED_RGTC1;
        pub const COMPRESSED_SIGNED_RED_RGTC1 = bindings.COMPRESSED_SIGNED_RED_RGTC1;
        pub const COMPRESSED_RG_RGTC2 = bindings.COMPRESSED_RG_RGTC2;
        pub const COMPRESSED_SIGNED_RG_RGTC2 = bindings.COMPRESSED_SIGNED_RG_RGTC2;
        pub const RG = bindings.RG;
        pub const RG_INTEGER = bindings.RG_INTEGER;
        pub const R8 = bindings.R8;
        pub const R16 = bindings.R16;
        pub const RG8 = bindings.RG8;
        pub const RG16 = bindings.RG16;
        pub const R16F = bindings.R16F;
        pub const R32F = bindings.R32F;
        pub const RG16F = bindings.RG16F;
        pub const RG32F = bindings.RG32F;
        pub const R8I = bindings.R8I;
        pub const R8UI = bindings.R8UI;
        pub const R16I = bindings.R16I;
        pub const R16UI = bindings.R16UI;
        pub const R32I = bindings.R32I;
        pub const R32UI = bindings.R32UI;
        pub const RG8I = bindings.RG8I;
        pub const RG8UI = bindings.RG8UI;
        pub const RG16I = bindings.RG16I;
        pub const RG16UI = bindings.RG16UI;
        pub const RG32I = bindings.RG32I;
        pub const RG32UI = bindings.RG32UI;
        pub const VERTEX_ARRAY_BINDING = bindings.VERTEX_ARRAY_BINDING;

        // pub var colorMaski: *const fn (
        //     index: Uint,
        //     r: Boolean,
        //     g: Boolean,
        //     b: Boolean,
        //     a: Boolean,
        // ) callconv(.c) void = undefined;
        pub fn colorMaski(
            index: u32,
            r: bool,
            g: bool,
            b: bool,
            a: bool,
        ) void {
            bindings.colorMaski(
                @bitCast(index),
                @intFromBool(r),
                @intFromBool(g),
                @intFromBool(b),
                @intFromBool(a),
            );
        }

        // pub var getBooleani_v: *const fn (target: Enum, index: Uint, data: [*c]Boolean) callconv(.c) void = undefined;
        pub fn getBooleani_v(
            target: IndexedBoolParameter,
            index: u32,
            data: []bool,
        ) void {
            bindings.getBooleani_v(
                @intFromEnum(target),
                @bitCast(index),
                @ptrCast(data.ptr),
            );
        }

        // pub var getIntegeri_v: *const fn (target: Enum, index: Uint, data: [*c]Int) callconv(.c) void = undefined;
        pub fn getIntegeri_v(
            target: IndexedInt32Parameter,
            index: u32,
            data: []i32,
        ) void {
            bindings.getIntegeri_v(
                @intFromEnum(target),
                @bitCast(index),
                @ptrCast(data.ptr),
            );
        }

        // pub var enablei: *const fn (target: Enum, index: Uint) callconv(.c) void = undefined;
        pub fn enablei(target: IndexedCapability, index: u32) void {
            bindings.enablei(
                @intFromEnum(target),
                @bitCast(index),
            );
        }

        // pub var disablei: *const fn (target: Enum, index: Uint) callconv(.c) void = undefined;
        pub fn disablei(target: IndexedCapability, index: u32) void {
            bindings.disablei(
                @intFromEnum(target),
                @bitCast(index),
            );
        }

        // pub var isEnabledi: *const fn (target: Enum, index: Uint) callconv(.c) Boolean = undefined;
        pub fn isEnabledi(target: IndexedCapability, index: u32) bool {
            return bindings.isEnabledi(
                @intFromEnum(target),
                @bitCast(index),
            ) == TRUE;
        }

        // pub var beginTransformFeedback: *const fn (primitiveMode: Enum) callconv(.c) void = undefined;
        pub fn beginTransformFeedback(primitiveMode: PrimitiveTypeBasic) void {
            bindings.beginTransformFeedback(@intFromEnum(primitiveMode));
        }

        // pub var endTransformFeedback: *const fn () callconv(.c) void = undefined;
        pub fn endTransformFeedback() void {
            bindings.endTransformFeedback();
        }

        // pub var bindBufferRange: *const fn (
        //     target: Enum,
        //     index: Uint,
        //     buffer: Uint,
        //     offset: Intptr,
        //     size: Sizeiptr,
        // ) callconv(.c) void = undefined;
        pub fn bindBufferRange(
            target: IndexedBufferTarget,
            index: Uint,
            buffer: Buffer,
            offset: Intptr,
            size: Sizeiptr,
        ) void {
            bindings.bindBufferRange(@intFromEnum(target), index, @intFromEnum(buffer), offset, size);
        }

        // pub var bindBufferBase: *const fn (target: Enum, index: Uint, buffer: Uint) callconv(.c) void = undefined;
        pub fn bindBufferBase(target: IndexedBufferTarget, index: Uint, buffer: Buffer) void {
            bindings.bindBufferBase(@intFromEnum(target), index, @intFromEnum(buffer));
        }

        // pub var transformFeedbackVaryings: *const fn (
        //     program: Uint,
        //     count: Sizei,
        //     varyings: [*c]const [*c]const Char,
        //     bufferMode: Enum,
        // ) callconv(.c) void = undefined;
        pub fn transformFeedbackVaryings(
            program: Program,
            varyings: []const [:0]const u8,
            bufferMode: TransformFeedbackBufferMode,
        ) void {
            assert(program != .invalid);
            bindings.transformFeedbackVaryings(
                @intFromEnum(program),
                @intCast(varyings.len),
                @ptrCast(varyings.ptr),
                @intFromEnum(bufferMode),
            );
        }

        // pub var getTransformFeedbackVarying: *const fn (
        //     program: Uint,
        //     index: Uint,
        //     bufSize: Sizei,
        //     length: [*c]Sizei,
        //     size: [*c]Sizei,
        //     type: [*c]Enum,
        //     name: [*c]Char,
        // ) callconv(.c) void = undefined;
        pub fn getTransformFeedbackVarying(
            program: Program,
            index: u32,
            size: *i32,
            varying_type: *AttribType,
            name_buf: [:0]u8,
        ) [:0]const u8 {
            assert(program != .invalid);
            var length: i32 = undefined;
            bindings.getTransformFeedbackVarying(
                @intFromEnum(program),
                @bitCast(index),
                // includes null terminator
                @intCast(name_buf.len + 1),
                // excludes null terminator
                @ptrCast(&length),
                @ptrCast(size),
                @ptrCast(varying_type),
                @ptrCast(name_buf.ptr),
            );
            return name_buf[0..@intCast(length) :0];
        }

        // pub var clampColor: *const fn (target: Enum, clamp: Enum) callconv(.c) void = undefined;
        pub fn clampColor(target: ClampColorTarget, clamp: ClampColor) void {
            bindings.clampColor(@intFromEnum(target), @intFromEnum(clamp));
        }

        // pub var beginConditionalRender: *const fn (id: Uint, mode: Enum) callconv(.c) void = undefined;
        pub fn beginConditionalRender(
            id: Query,
            mode: ConditionalRenderMode,
        ) void {
            bindings.beginConditionalRender(
                @intFromEnum(id),
                @intFromEnum(mode),
            );
        }

        // pub var endConditionalRender: *const fn () callconv(.c) void = undefined;
        pub fn endConditionalRender() void {
            bindings.endConditionalRender();
        }

        // pub var vertexAttribIPointer: *const fn (
        //     index: Uint,
        //     size: Int,
        //     type: Enum,
        //     stride: Sizei,
        //     pointer: ?*const anyopaque,
        // ) callconv(.c) void = undefined;
        pub fn vertexAttribIPointer(
            location: VertexAttribLocation,
            size: u32,
            attrib_type: VertexAttribIntegerType,
            stride: u32,
            offset: usize,
        ) void {
            bindings.vertexAttribIPointer(
                @intFromEnum(location),
                @bitCast(size),
                @intFromEnum(attrib_type),
                @bitCast(stride),
                @ptrFromInt(offset),
            );
        }

        // pub var getVertexAttribIiv: *const fn (index: Uint, pname: Enum, params: [*c]Int) callconv(.c) void = undefined;
        pub fn getVertexAttribIiv(
            location: VertexAttribLocation,
            pname: VertexAttribParameter,
            params: []i32,
        ) void {
            bindings.getVertexAttribIiv(
                @intFromEnum(location),
                @intFromEnum(pname),
                @ptrCast(params.ptr),
            );
        }

        // pub var getVertexAttribIuiv: *const fn (index: Uint, pname: Enum, params: [*c]Uint) callconv(.c) void = undefined;
        pub fn getVertexAttribIuiv(
            location: VertexAttribLocation,
            pname: VertexAttribParameter,
            params: []u32,
        ) void {
            bindings.getVertexAttribIuiv(
                @intFromEnum(location),
                @intFromEnum(pname),
                @ptrCast(params.ptr),
            );
        }

        // pub var vertexAttribI1i: *const fn (index: Uint, x: Int) callconv(.c) void = undefined;
        pub fn vertexAttribI1i(location: VertexAttribLocation, x: i32) void {
            bindings.vertexAttribI1i(
                @intFromEnum(location),
                @bitCast(x),
            );
        }

        // pub var vertexAttribI2i: *const fn (index: Uint, x: Int, y: Int) callconv(.c) void = undefined;
        pub fn vertexAttribI2i(location: VertexAttribLocation, x: i32, y: i32) void {
            bindings.vertexAttribI2i(
                @intFromEnum(location),
                @bitCast(x),
                @bitCast(y),
            );
        }

        // pub var vertexAttribI3i: *const fn (index: Uint, x: Int, y: Int, z: Int) callconv(.c) void = undefined;
        pub fn vertexAttribI3i(
            location: VertexAttribLocation,
            x: i32,
            y: i32,
            z: i32,
        ) void {
            bindings.vertexAttribI3i(
                @intFromEnum(location),
                @bitCast(x),
                @bitCast(y),
                @bitCast(z),
            );
        }

        // pub var vertexAttribI4i: *const fn (index: Uint, x: Int, y: Int, z: Int, w: Int) callconv(.c) void = undefined;
        pub fn vertexAttribI4i(
            location: VertexAttribLocation,
            x: i32,
            y: i32,
            z: i32,
            w: i32,
        ) void {
            bindings.vertexAttribI4i(
                @intFromEnum(location),
                @bitCast(x),
                @bitCast(y),
                @bitCast(z),
                @bitCast(w),
            );
        }

        // pub var vertexAttribI1ui: *const fn (index: Uint, x: Uint) callconv(.c) void = undefined;
        pub fn vertexAttribI1ui(location: VertexAttribLocation, x: u32) void {
            bindings.vertexAttribI1ui(
                @intFromEnum(location),
                @bitCast(x),
            );
        }

        // pub var vertexAttribI2ui: *const fn (index: Uint, x: Uint, y: Uint) callconv(.c) void = undefined;
        pub fn vertexAttribI2ui(location: VertexAttribLocation, x: u32, y: u32) void {
            bindings.vertexAttribI2ui(
                @intFromEnum(location),
                @bitCast(x),
                @bitCast(y),
            );
        }

        // pub var vertexAttribI3ui: *const fn (index: Uint, x: Uint, y: Uint, z: Uint) callconv(.c) void = undefined;
        pub fn vertexAttribI3ui(
            location: VertexAttribLocation,
            x: u32,
            y: u32,
            z: u32,
        ) void {
            bindings.vertexAttribI3ui(
                @intFromEnum(location),
                @bitCast(x),
                @bitCast(y),
                @bitCast(z),
            );
        }

        // pub var vertexAttribI4ui: *const fn (index: Uint, x: Uint, y: Uint, z: Uint, w: Uint) callconv(.c) void = undefined;
        pub fn vertexAttribI4ui(
            location: VertexAttribLocation,
            x: u32,
            y: u32,
            z: u32,
            w: u32,
        ) void {
            bindings.vertexAttribI4ui(
                @intFromEnum(location),
                @bitCast(x),
                @bitCast(y),
                @bitCast(z),
                @bitCast(w),
            );
        }

        // pub var vertexAttribI1iv: *const fn (index: Uint, v: [*c]const Int) callconv(.c) void = undefined;
        pub fn vertexAttribI1iv(location: VertexAttribLocation, v: []const i32) void {
            bindings.vertexAttribI1iv(@intFromEnum(location), @ptrCast(v.ptr));
        }

        // pub var vertexAttribI2iv: *const fn (index: Uint, v: [*c]const Int) callconv(.c) void = undefined;
        pub fn vertexAttribI2iv(location: VertexAttribLocation, v: []const i32) void {
            bindings.vertexAttribI2iv(@intFromEnum(location), @ptrCast(v.ptr));
        }

        // pub var vertexAttribI3iv: *const fn (index: Uint, v: [*c]const Int) callconv(.c) void = undefined;
        pub fn vertexAttribI3iv(location: VertexAttribLocation, v: []const i32) void {
            bindings.vertexAttribI3iv(@intFromEnum(location), @ptrCast(v.ptr));
        }

        // pub var vertexAttribI4iv: *const fn (index: Uint, v: [*c]const Int) callconv(.c) void = undefined;
        pub fn vertexAttribI4iv(location: VertexAttribLocation, v: []const i32) void {
            bindings.vertexAttribI4iv(@intFromEnum(location), @ptrCast(v.ptr));
        }

        // pub var vertexAttribI1uiv: *const fn (index: Uint, v: [*c]const Uint) callconv(.c) void = undefined;
        pub fn vertexAttribI1uiv(location: VertexAttribLocation, v: []const u32) void {
            bindings.vertexAttribI1uiv(@intFromEnum(location), @ptrCast(v.ptr));
        }

        // pub var vertexAttribI2uiv: *const fn (index: Uint, v: [*c]const Uint) callconv(.c) void = undefined;
        pub fn vertexAttribI2uiv(location: VertexAttribLocation, v: []const u32) void {
            bindings.vertexAttribI2uiv(@intFromEnum(location), @ptrCast(v.ptr));
        }

        // pub var vertexAttribI3uiv: *const fn (index: Uint, v: [*c]const Uint) callconv(.c) void = undefined;
        pub fn vertexAttribI3uiv(location: VertexAttribLocation, v: []const u32) void {
            bindings.vertexAttribI3uiv(@intFromEnum(location), @ptrCast(v.ptr));
        }

        // pub var vertexAttribI4uiv: *const fn (index: Uint, v: [*c]const Uint) callconv(.c) void = undefined;
        pub fn vertexAttribI4uiv(location: VertexAttribLocation, v: []const u32) void {
            bindings.vertexAttribI4uiv(@intFromEnum(location), @ptrCast(v.ptr));
        }

        // pub var vertexAttribI4bv: *const fn (index: Uint, v: [*c]const Byte) callconv(.c) void = undefined;
        pub fn vertexAttribI4bv(location: VertexAttribLocation, v: []const i8) void {
            bindings.vertexAttribI4bv(@intFromEnum(location), @ptrCast(v.ptr));
        }

        // pub var vertexAttribI4sv: *const fn (index: Uint, v: [*c]const Short) callconv(.c) void = undefined;
        pub fn vertexAttribI4sv(location: VertexAttribLocation, v: []const i16) void {
            bindings.vertexAttribI4sv(@intFromEnum(location), @ptrCast(v.ptr));
        }

        // pub var vertexAttribI4ubv: *const fn (index: Uint, v: [*c]const Ubyte) callconv(.c) void = undefined;
        pub fn vertexAttribI4ubv(location: VertexAttribLocation, v: []const u8) void {
            bindings.vertexAttribI4ubv(@intFromEnum(location), @ptrCast(v.ptr));
        }

        // pub var vertexAttribI4usv: *const fn (index: Uint, v: [*c]const Ushort) callconv(.c) void = undefined;
        pub fn vertexAttribI4usv(location: VertexAttribLocation, v: []const u16) void {
            bindings.vertexAttribI4usv(@intFromEnum(location), @ptrCast(v.ptr));
        }

        // pub var getUniformuiv: *const fn (program: Uint, location: Int, params: [*c]Uint) callconv(.c) void = undefined;
        pub fn getUniformuiv(program: Program, location: UniformLocation, params: []u32) void {
            assert(program != .invalid);
            assert(location != .invalid);
            bindings.getUniformuiv(
                @intFromEnum(program),
                @intFromEnum(location),
                @ptrCast(params.ptr),
            );
        }

        // pub var bindFragDataLocation: *const fn (
        //     program: Uint,
        //     color: Uint,
        //     name: [*c]const Char,
        // ) callconv(.c) void = undefined;
        pub fn bindFragDataLocation(program: Program, color: u32, name: [:0]const u8) void {
            assert(program != .invalid);
            // prefix 'gl_' is reserved and cannot be used
            assert(!std.mem.startsWith(u8, name, "gl_"));
            bindings.bindFragDataLocation(
                @intFromEnum(program),
                @bitCast(color),
                @ptrCast(name.ptr),
            );
        }

        // pub var getFragDataLocation: *const fn (program: Uint, name: [*c]const Char) callconv(.c) Int = undefined;
        pub fn getFragDataLocation(program: Program, name: [:0]const u8) i32 {
            assert(program != .invalid);
            return bindings.getFragDataLocation(
                @intFromEnum(program),
                @ptrCast(name.ptr),
            );
        }

        // pub var uniform1ui: *const fn (location: Int, v0: Uint) callconv(.c) void = undefined;
        pub fn uniform1ui(location: UniformLocation, v0: u32) void {
            assert(location != .invalid);
            bindings.uniform1ui(
                @intFromEnum(location),
                @bitCast(v0),
            );
        }

        // pub var uniform2ui: *const fn (location: Int, v0: Uint, v1: Uint) callconv(.c) void = undefined;
        pub fn uniform2ui(location: UniformLocation, v0: u32, v1: u32) void {
            assert(location != .invalid);
            bindings.uniform2ui(
                @intFromEnum(location),
                @bitCast(v0),
                @bitCast(v1),
            );
        }

        // pub var uniform3ui: *const fn (location: Int, v0: Uint, v1: Uint, v2: Uint) callconv(.c) void = undefined;
        pub fn uniform3ui(
            location: UniformLocation,
            v0: u32,
            v1: u32,
            v2: u32,
        ) void {
            assert(location != .invalid);
            bindings.uniform3ui(
                @intFromEnum(location),
                @bitCast(v0),
                @bitCast(v1),
                @bitCast(v2),
            );
        }

        // pub var uniform4ui: *const fn (location: Int, v0: Uint, v1: Uint, v2: Uint, v3: Uint) callconv(.c) void = undefined;
        pub fn uniform4ui(
            location: UniformLocation,
            v0: u32,
            v1: u32,
            v2: u32,
            v3: u32,
        ) void {
            assert(location != .invalid);
            bindings.uniform4ui(
                @intFromEnum(location),
                @bitCast(v0),
                @bitCast(v1),
                @bitCast(v2),
                @bitCast(v3),
            );
        }

        // pub var uniform1uiv: *const fn (location: Int, count: Sizei, value: [*c]const Uint) callconv(.c) void = undefined;
        pub fn uniform1uiv(location: UniformLocation, count: u32, value: []const u32) void {
            assert(location != .invalid);
            assert(value.len == count);
            bindings.uniform1uiv(
                @intFromEnum(location),
                @bitCast(count),
                @ptrCast(value.ptr),
            );
        }

        // pub var uniform2uiv: *const fn (location: Int, count: Sizei, value: [*c]const Uint) callconv(.c) void = undefined;
        pub fn uniform2uiv(location: UniformLocation, count: u32, value: []const u32) void {
            const vec_size = 2;
            assert(location != .invalid);
            assert(value.len % vec_size == 0);
            assert(value.len / vec_size == count);
            bindings.uniform2uiv(
                @intFromEnum(location),
                @bitCast(count),
                @ptrCast(value.ptr),
            );
        }

        // pub var uniform3uiv: *const fn (location: Int, count: Sizei, value: [*c]const Uint) callconv(.c) void = undefined;
        pub fn uniform3uiv(location: UniformLocation, count: u32, value: []const u32) void {
            const vec_size = 3;
            assert(location != .invalid);
            assert(value.len % vec_size == 0);
            assert(value.len / vec_size == count);
            bindings.uniform3uiv(
                @intFromEnum(location),
                @bitCast(count),
                @ptrCast(value.ptr),
            );
        }

        // pub var uniform4uiv: *const fn (location: Int, count: Sizei, value: [*c]const Uint) callconv(.c) void = undefined;
        pub fn uniform4uiv(location: UniformLocation, count: u32, value: []const u32) void {
            const vec_size = 4;
            assert(location != .invalid);
            assert(value.len % vec_size == 0);
            assert(value.len / vec_size == count);
            bindings.uniform4uiv(
                @intFromEnum(location),
                @bitCast(count),
                @ptrCast(value.ptr),
            );
        }

        // pub var texParameterIiv: *const fn (target: Enum, pname: Enum, params: [*c]const Int) callconv(.c) void = undefined;
        pub fn texParameterIiv(
            target: TextureTarget,
            pname: TexParameter,
            params: []const i32,
        ) void {
            bindings.texParameterIiv(
                @intFromEnum(target),
                @intFromEnum(pname),
                @ptrCast(params.ptr),
            );
        }

        // pub var texParameterIuiv: *const fn (
        //     target: Enum,
        //     pname: Enum,
        //     params: [*c]const Uint,
        // ) callconv(.c) void = undefined;
        pub fn texParameterIuiv(
            target: TextureTarget,
            pname: TexParameter,
            params: []const u32,
        ) void {
            bindings.texParameterIuiv(
                @intFromEnum(target),
                @intFromEnum(pname),
                @ptrCast(params.ptr),
            );
        }

        // pub var getTexParameterIiv: *const fn (target: Enum, pname: Enum, params: [*c]Int) callconv(.c) void = undefined;
        pub fn getTexParameterIiv(
            target: TextureTarget,
            pname: GetTexParameter,
            params: []i32,
        ) void {
            bindings.getTexParameterIiv(
                @intFromEnum(target),
                @intFromEnum(pname),
                @ptrCast(params.ptr),
            );
        }

        // pub var getTexParameterIuiv: *const fn (target: Enum, pname: Enum, params: [*c]Uint) callconv(.c) void = undefined;
        pub fn getTexParameterIuiv(
            target: TextureTarget,
            pname: GetTexParameter,
            params: []u32,
        ) void {
            bindings.getTexParameterIuiv(
                @intFromEnum(target),
                @intFromEnum(pname),
                @ptrCast(params.ptr),
            );
        }

        // pub var clearBufferiv: *const fn (buffer: Enum, drawbuffer: Int, value: [*c]const Int) callconv(.c) void = undefined;
        pub fn clearBufferiv(
            buffer: ClearBuffer,
            drawbuffer: i32,
            value: []const i32,
        ) void {
            bindings.clearBufferiv(
                @intFromEnum(buffer),
                @bitCast(drawbuffer),
                @ptrCast(value.ptr),
            );
        }

        // pub var clearBufferuiv: *const fn (
        //     buffer: Enum,
        //     drawbuffer: Int,
        //     value: [*c]const Uint,
        // ) callconv(.c) void = undefined;
        pub fn clearBufferuiv(
            buffer: ClearBuffer,
            drawbuffer: i32,
            value: []const u32,
        ) void {
            bindings.clearBufferuiv(
                @intFromEnum(buffer),
                @bitCast(drawbuffer),
                @ptrCast(value.ptr),
            );
        }

        // pub var clearBufferfv: *const fn (
        //     buffer: Enum,
        //     drawbuffer: Int,
        //     value: [*c]const Float,
        // ) callconv(.c) void = undefined;
        pub fn clearBufferfv(
            buffer: ClearBuffer,
            drawbuffer: i32,
            value: []const f32,
        ) void {
            bindings.clearBufferfv(
                @intFromEnum(buffer),
                @bitCast(drawbuffer),
                @ptrCast(value.ptr),
            );
        }

        // pub var clearBufferfi: *const fn (
        //     buffer: Enum,
        //     drawbuffer: Int,
        //     depth: Float,
        //     stencil: Int,
        // ) callconv(.c) void = undefined;
        pub fn clearBufferfi(
            buffer: ClearBufferDepthStencil,
            drawbuffer: i32,
            depth: f32,
            stencil: i32,
        ) void {
            bindings.clearBufferfi(
                @intFromEnum(buffer),
                @bitCast(drawbuffer),
                depth,
                stencil,
            );
        }

        // pub var getStringi: *const fn (name: Enum, index: Uint) callconv(.c) [*c]const Ubyte = undefined;
        pub fn getStringi(name: StringParamName, index: Uint) [*:0]const u8 {
            return bindings.getStringi(@intFromEnum(name), index);
        }

        // pub var isRenderbuffer: *const fn (renderbuffer: Uint) callconv(.c) Boolean = undefined;
        pub fn isRenderbuffer(renderbuffer: Renderbuffer) bool {
            return bindings.isRenderbuffer(@intFromEnum(renderbuffer)) == TRUE;
        }

        // pub var bindRenderbuffer: *const fn (target: Enum, renderbuffer: Uint) callconv(.c) void = undefined;
        pub fn bindRenderbuffer(target: RenderbufferTarget, renderbuffer: Renderbuffer) void {
            bindings.bindRenderbuffer(@intFromEnum(target), @intFromEnum(renderbuffer));
        }

        // pub var deleteRenderbuffers: *const fn (n: Sizei, renderbuffers: [*c]const Uint) callconv(.c) void = undefined;
        pub fn deleteRenderbuffer(ptr: *const Renderbuffer) void {
            bindings.deleteRenderbuffers(1, @as([*c]const Uint, @ptrCast(ptr)));
        }
        pub fn deleteRenderbuffers(renderbuffers: []const Renderbuffer) void {
            bindings.deleteRenderbuffers(@intCast(renderbuffers.len), @as([*c]const Uint, @ptrCast(renderbuffers.ptr)));
        }

        // pub var genRenderbuffers: *const fn (n: Sizei, renderbuffers: [*c]Uint) callconv(.c) void = undefined;
        pub fn genRenderbuffer(ptr: *Renderbuffer) void {
            bindings.genRenderbuffers(1, @as([*c]Uint, @ptrCast(ptr)));
        }
        pub fn genRenderbuffers(renderbuffers: []Renderbuffer) void {
            bindings.genRenderbuffers(@intCast(renderbuffers.len), @as([*c]Uint, @ptrCast(renderbuffers.ptr)));
        }

        // pub var renderbufferStorage: *const fn (
        //     target: Enum,
        //     internalformat: Enum,
        //     width: Sizei,
        //     height: Sizei,
        // ) callconv(.c) void = undefined;
        pub fn renderbufferStorage(
            target: RenderbufferTarget,
            internal_format: InternalFormat,
            width: u32,
            height: u32,
        ) void {
            bindings.renderbufferStorage(
                @intFromEnum(target),
                @intFromEnum(internal_format),
                @as(Sizei, @bitCast(width)),
                @as(Sizei, @bitCast(height)),
            );
        }

        // pub var getRenderbufferParameteriv: *const fn (
        //     target: Enum,
        //     pname: Enum,
        //     params: [*c]Int,
        // ) callconv(.c) void = undefined;
        pub fn getRenderbufferParameteriv(
            target: RenderbufferTarget,
            pname: RenderbufferParameter,
            params: []i32,
        ) void {
            bindings.getRenderbufferParameteriv(
                @intFromEnum(target),
                @intFromEnum(pname),
                @ptrCast(params.ptr),
            );
        }

        // pub var isFramebuffer: *const fn (framebuffer: Uint) callconv(.c) Boolean = undefined;
        pub fn isFramebuffer(framebuffer: Framebuffer) bool {
            return bindings.isFramebuffer(@intFromEnum(framebuffer)) == TRUE;
        }

        // pub var bindFramebuffer: *const fn (target: Enum, framebuffer: Uint) callconv(.c) void = undefined;
        pub fn bindFramebuffer(target: FramebufferTarget, framebuffer: Framebuffer) void {
            bindings.bindFramebuffer(@intFromEnum(target), @intFromEnum(framebuffer));
        }

        // pub var deleteFramebuffers: *const fn (n: Sizei, framebuffers: [*c]const Uint) callconv(.c) void = undefined;
        pub fn deleteFramebuffer(ptr: *const Framebuffer) void {
            bindings.deleteFramebuffers(1, @as([*c]const Uint, @ptrCast(ptr)));
        }
        pub fn deleteFramebuffers(framebuffers: []const Framebuffer) void {
            bindings.deleteFramebuffers(@intCast(framebuffers.len), @as([*c]const Uint, @ptrCast(framebuffers.ptr)));
        }

        // pub var genFramebuffers: *const fn (n: Sizei, framebuffers: [*c]Uint) callconv(.c) void = undefined;
        pub fn genFramebuffer(ptr: *Framebuffer) void {
            bindings.genFramebuffers(1, @as([*c]Uint, @ptrCast(ptr)));
        }
        pub fn genFramebuffers(framebuffers: []Framebuffer) void {
            bindings.genFramebuffers(@intCast(framebuffers.len), @as([*c]Uint, @ptrCast(framebuffers.ptr)));
        }

        // pub var checkFramebufferStatus: *const fn (target: Enum) callconv(.c) Enum = undefined;
        pub fn checkFramebufferStatus(target: FramebufferTarget) FramebufferStatus {
            const res = bindings.checkFramebufferStatus(@intFromEnum(target));
            return std.meta.intToEnum(FramebufferStatus, res) catch onInvalid: {
                log.warn("checkFramebufferStatus returned unexpected value {}", .{res});
                break :onInvalid .complete;
            };
        }

        // pub var framebufferTexture1D: *const fn (
        //     target: Enum,
        //     attachment: Enum,
        //     textarget: Enum,
        //     texture: Uint,
        //     level: Int,
        // ) callconv(.c) void = undefined;
        pub fn framebufferTexture1D(
            target: FramebufferTarget,
            attachment: FramebufferAttachment,
            textarget: TextureTarget,
            texture: Texture,
            level: i32,
        ) void {
            bindings.framebufferTexture1D(
                @intFromEnum(target),
                @intFromEnum(attachment),
                @intFromEnum(textarget),
                @intFromEnum(texture),
                @bitCast(level),
            );
        }

        // pub var framebufferTexture2D: *const fn (
        //     target: Enum,
        //     attachment: Enum,
        //     textarget: Enum,
        //     texture: Uint,
        //     level: Int,
        // ) callconv(.c) void = undefined;
        pub fn framebufferTexture2D(
            target: FramebufferTarget,
            attachment: FramebufferAttachment,
            textarget: TextureTarget,
            texture: Texture,
            level: Int,
        ) void {
            bindings.framebufferTexture2D(
                @intFromEnum(target),
                @intFromEnum(attachment),
                @intFromEnum(textarget),
                @intFromEnum(texture),
                level,
            );
        }

        // pub var framebufferTexture3D: *const fn (
        //     target: Enum,
        //     attachment: Enum,
        //     textarget: Enum,
        //     texture: Uint,
        //     level: Int,
        //     zoffset: Int,
        // ) callconv(.c) void = undefined;
        pub fn framebufferTexture3D(
            target: FramebufferTarget,
            attachment: FramebufferAttachment,
            textarget: TextureTarget,
            texture: Texture,
            level: i32,
            zoffset: i32,
        ) void {
            bindings.framebufferTexture3D(
                @intFromEnum(target),
                @intFromEnum(attachment),
                @intFromEnum(textarget),
                @intFromEnum(texture),
                @bitCast(level),
                @bitCast(zoffset),
            );
        }

        // pub var framebufferRenderbuffer: *const fn (
        //     target: Enum,
        //     attachment: Enum,
        //     renderbuffertarget: Enum,
        //     renderbuffer: Uint,
        // ) callconv(.c) void = undefined;
        pub fn framebufferRenderbuffer(
            target: FramebufferTarget,
            attachment: FramebufferAttachment,
            renderbuffertarget: RenderbufferTarget,
            renderbuffer: Renderbuffer,
        ) void {
            bindings.framebufferRenderbuffer(
                @intFromEnum(target),
                @intFromEnum(attachment),
                @intFromEnum(renderbuffertarget),
                @intFromEnum(renderbuffer),
            );
        }

        // pub var getFramebufferAttachmentParameteriv: *const fn (
        //     target: Enum,
        //     attachment: Enum,
        //     pname: Enum,
        //     params: [*c]Int,
        // ) callconv(.c) void = undefined;
        pub fn getFramebufferAttachmentParameteriv(
            target: FramebufferTarget,
            attachment: FramebufferAttachmentDefault,
            pname: FramebufferAttachmentParameter,
        ) Int {
            var result: Int = undefined;
            bindings.getFramebufferAttachmentParameteriv(
                @intFromEnum(target),
                @intFromEnum(attachment),
                @intFromEnum(pname),
                &result,
            );
            return result;
        }

        // pub var generateMipmap: *const fn (target: Enum) callconv(.c) void = undefined;
        pub fn generateMipmap(target: MipmapTarget) void {
            bindings.generateMipmap(@intFromEnum(target));
        }

        // pub var blitFramebuffer: *const fn (
        //     srcX0: Int,
        //     srcY0: Int,
        //     srcX1: Int,
        //     srcY1: Int,
        //     dstX0: Int,
        //     dstY0: Int,
        //     dstX1: Int,
        //     dstY1: Int,
        //     mask: Bitfield,
        //     filter: Enum,
        // ) callconv(.c) void = undefined;
        pub fn blitFramebuffer(
            srcX0: i32,
            srcY0: i32,
            srcX1: i32,
            srcY1: i32,
            dstX0: i32,
            dstY0: i32,
            dstX1: i32,
            dstY1: i32,
            mask: ColorMask,
            filter: Filter,
        ) void {
            bindings.blitFramebuffer(
                @bitCast(srcX0),
                @bitCast(srcY0),
                @bitCast(srcX1),
                @bitCast(srcY1),
                @bitCast(dstX0),
                @bitCast(dstY0),
                @bitCast(dstX1),
                @bitCast(dstY1),
                @bitCast(mask),
                @intFromEnum(filter),
            );
        }

        // pub var renderbufferStorageMultisample: *const fn (
        //     target: Enum,
        //     samples: Sizei,
        //     internalformat: Enum,
        //     width: Sizei,
        //     height: Sizei,
        // ) callconv(.c) void = undefined;
        pub fn renderbufferStorageMultisample(
            target: RenderbufferTarget,
            samples: u32,
            internalformat: InternalFormat,
            width: u32,
            height: u32,
        ) void {
            bindings.renderbufferStorageMultisample(
                @intFromEnum(target),
                @bitCast(samples),
                @intFromEnum(internalformat),
                @bitCast(width),
                @bitCast(height),
            );
        }

        // pub var framebufferTextureLayer: *const fn (
        //     target: Enum,
        //     attachment: Enum,
        //     texture: Uint,
        //     level: Int,
        //     layer: Int,
        // ) callconv(.c) void = undefined;
        pub fn framebufferTextureLayer(
            target: FramebufferTarget,
            attachment: FramebufferAttachment,
            texture: Texture,
            level: i32,
            layer: i32,
        ) void {
            bindings.framebufferTextureLayer(
                @intFromEnum(target),
                @intFromEnum(attachment),
                @intFromEnum(texture),
                @bitCast(level),
                @bitCast(layer),
            );
        }

        // pub var mapBufferRange: *const fn (
        //     target: Enum,
        //     offset: Intptr,
        //     length: Sizeiptr,
        //     access: Bitfield,
        // ) callconv(.c) ?*anyopaque = undefined;
        pub fn mapBufferRange(
            target: BufferTarget,
            offset: usize,
            length: usize,
            access: MappedBufferAccess,
        ) ?[*]u8 {
            assert(length == 0);
            assert(!(!access.map_read and !access.map_write));
            assert(!(access.map_read and (access.map_invalidate_range or access.map_invalidate_buffer or access.map_unsynchronized)));
            assert(!(access.map_flush_explicit and !access.map_write));
            return @ptrCast(bindings.mapBufferRange(
                @intFromEnum(target),
                @bitCast(offset),
                @bitCast(length),
                @bitCast(access),
            ));
        }

        // pub var flushMappedBufferRange: *const fn (
        //     target: Enum,
        //     offset: Intptr,
        //     length: Sizeiptr,
        // ) callconv(.c) void = undefined;
        pub fn flushMappedBufferRange(
            target: BufferTarget,
            offset: usize,
            length: usize,
        ) void {
            bindings.flushMappedBufferRange(
                @intFromEnum(target),
                @bitCast(offset),
                @bitCast(length),
            );
        }

        // pub var bindVertexArray: *const fn (array: Uint) callconv(.c) void = undefined;
        pub fn bindVertexArray(array: VertexArrayObject) void {
            bindings.bindVertexArray(@intFromEnum(array));
        }

        // pub var deleteVertexArrays: *const fn (n: Sizei, arrays: [*c]const Uint) callconv(.c) void = undefined;
        pub fn deleteVertexArray(ptr: *const VertexArrayObject) void {
            bindings.deleteVertexArrays(1, @ptrCast(ptr));
        }
        pub fn deleteVertexArrays(arrays: []const VertexArrayObject) void {
            bindings.deleteVertexArrays(@intCast(arrays.len), @ptrCast(arrays.ptr));
        }

        // pub var genVertexArrays: *const fn (n: Sizei, arrays: [*c]Uint) callconv(.c) void = undefined;
        pub fn genVertexArray(ptr: *VertexArrayObject) void {
            bindings.genVertexArrays(1, @as([*c]Uint, @ptrCast(ptr)));
        }
        pub fn genVertexArrays(arrays: []VertexArrayObject) void {
            bindings.genVertexArrays(@intCast(arrays.len), @ptrCast(arrays.ptr));
        }

        // pub var isVertexArray: *const fn (array: Uint) callconv(.c) Boolean = undefined;
        pub fn isVertexArray(array: VertexArrayObject) bool {
            return bindings.isVertexArray(@intFromEnum(array)) == TRUE;
        }

        //------------------------------------------------------------------------------------------
        //
        // OpenGL 3.1 (Core Profile)
        //
        //------------------------------------------------------------------------------------------
        pub const SAMPLER_2D_RECT = bindings.SAMPLER_2D_RECT;
        pub const SAMPLER_2D_RECT_SHADOW = bindings.SAMPLER_2D_RECT_SHADOW;
        pub const SAMPLER_BUFFER = bindings.SAMPLER_BUFFER;
        pub const INT_SAMPLER_2D_RECT = bindings.INT_SAMPLER_2D_RECT;
        pub const INT_SAMPLER_BUFFER = bindings.INT_SAMPLER_BUFFER;
        pub const UNSIGNED_INT_SAMPLER_2D_RECT = bindings.UNSIGNED_INT_SAMPLER_2D_RECT;
        pub const UNSIGNED_INT_SAMPLER_BUFFER = bindings.UNSIGNED_INT_SAMPLER_BUFFER;
        pub const TEXTURE_BUFFER = bindings.TEXTURE_BUFFER;
        pub const MAX_TEXTURE_BUFFER_SIZE = bindings.MAX_TEXTURE_BUFFER_SIZE;
        pub const TEXTURE_BINDING_BUFFER = bindings.TEXTURE_BINDING_BUFFER;
        pub const TEXTURE_BUFFER_DATA_STORE_BINDING = bindings.TEXTURE_BUFFER_DATA_STORE_BINDING;
        pub const TEXTURE_RECTANGLE = bindings.TEXTURE_RECTANGLE;
        pub const TEXTURE_BINDING_RECTANGLE = bindings.TEXTURE_BINDING_RECTANGLE;
        pub const PROXY_TEXTURE_RECTANGLE = bindings.PROXY_TEXTURE_RECTANGLE;
        pub const MAX_RECTANGLE_TEXTURE_SIZE = bindings.MAX_RECTANGLE_TEXTURE_SIZE;
        pub const R8_SNORM = bindings.R8_SNORM;
        pub const RG8_SNORM = bindings.RG8_SNORM;
        pub const RGB8_SNORM = bindings.RGB8_SNORM;
        pub const RGBA8_SNORM = bindings.RGBA8_SNORM;
        pub const R16_SNORM = bindings.R16_SNORM;
        pub const RG16_SNORM = bindings.RG16_SNORM;
        pub const RGB16_SNORM = bindings.RGB16_SNORM;
        pub const RGBA16_SNORM = bindings.RGBA16_SNORM;
        pub const SIGNED_NORMALIZED = bindings.SIGNED_NORMALIZED;
        pub const PRIMITIVE_RESTART = bindings.PRIMITIVE_RESTART;
        pub const PRIMITIVE_RESTART_INDEX = bindings.PRIMITIVE_RESTART_INDEX;
        pub const COPY_READ_BUFFER = bindings.COPY_READ_BUFFER;
        pub const COPY_WRITE_BUFFER = bindings.COPY_WRITE_BUFFER;
        pub const UNIFORM_BUFFER = bindings.UNIFORM_BUFFER;
        pub const UNIFORM_BUFFER_BINDING = bindings.UNIFORM_BUFFER_BINDING;
        pub const UNIFORM_BUFFER_START = bindings.UNIFORM_BUFFER_START;
        pub const UNIFORM_BUFFER_SIZE = bindings.UNIFORM_BUFFER_SIZE;
        pub const MAX_VERTEX_UNIFORM_BLOCKS = bindings.MAX_VERTEX_UNIFORM_BLOCKS;
        pub const MAX_GEOMETRY_UNIFORM_BLOCKS = bindings.MAX_GEOMETRY_UNIFORM_BLOCKS;
        pub const MAX_FRAGMENT_UNIFORM_BLOCKS = bindings.MAX_FRAGMENT_UNIFORM_BLOCKS;
        pub const MAX_COMBINED_UNIFORM_BLOCKS = bindings.MAX_COMBINED_UNIFORM_BLOCKS;
        pub const MAX_UNIFORM_BUFFER_BINDINGS = bindings.MAX_UNIFORM_BUFFER_BINDINGS;
        pub const MAX_UNIFORM_BLOCK_SIZE = bindings.MAX_UNIFORM_BLOCK_SIZE;
        pub const MAX_COMBINED_VERTEX_UNIFORM_COMPONENTS = bindings.MAX_COMBINED_VERTEX_UNIFORM_COMPONENTS;
        pub const MAX_COMBINED_GEOMETRY_UNIFORM_COMPONENTS = bindings.MAX_COMBINED_GEOMETRY_UNIFORM_COMPONENTS;
        pub const MAX_COMBINED_FRAGMENT_UNIFORM_COMPONENTS = bindings.MAX_COMBINED_FRAGMENT_UNIFORM_COMPONENTS;
        pub const UNIFORM_BUFFER_OFFSET_ALIGNMENT = bindings.UNIFORM_BUFFER_OFFSET_ALIGNMENT;
        pub const ACTIVE_UNIFORM_BLOCK_MAX_NAME_LENGTH = bindings.ACTIVE_UNIFORM_BLOCK_MAX_NAME_LENGTH;
        pub const ACTIVE_UNIFORM_BLOCKS = bindings.ACTIVE_UNIFORM_BLOCKS;
        pub const UNIFORM_TYPE = bindings.UNIFORM_TYPE;
        pub const UNIFORM_SIZE = bindings.UNIFORM_SIZE;
        pub const UNIFORM_NAME_LENGTH = bindings.UNIFORM_NAME_LENGTH;
        pub const UNIFORM_BLOCK_INDEX = bindings.UNIFORM_BLOCK_INDEX;
        pub const UNIFORM_OFFSET = bindings.UNIFORM_OFFSET;
        pub const UNIFORM_ARRAY_STRIDE = bindings.UNIFORM_ARRAY_STRIDE;
        pub const UNIFORM_MATRIX_STRIDE = bindings.UNIFORM_MATRIX_STRIDE;
        pub const UNIFORM_IS_ROW_MAJOR = bindings.UNIFORM_IS_ROW_MAJOR;
        pub const UNIFORM_BLOCK_BINDING = bindings.UNIFORM_BLOCK_BINDING;
        pub const UNIFORM_BLOCK_DATA_SIZE = bindings.UNIFORM_BLOCK_DATA_SIZE;
        pub const UNIFORM_BLOCK_NAME_LENGTH = bindings.UNIFORM_BLOCK_NAME_LENGTH;
        pub const UNIFORM_BLOCK_ACTIVE_UNIFORMS = bindings.UNIFORM_BLOCK_ACTIVE_UNIFORMS;
        pub const UNIFORM_BLOCK_ACTIVE_UNIFORM_INDICES = bindings.UNIFORM_BLOCK_ACTIVE_UNIFORM_INDICES;
        pub const UNIFORM_BLOCK_REFERENCED_BY_VERTEX_SHADER = bindings.UNIFORM_BLOCK_REFERENCED_BY_VERTEX_SHADER;
        pub const UNIFORM_BLOCK_REFERENCED_BY_GEOMETRY_SHADER = bindings.UNIFORM_BLOCK_REFERENCED_BY_GEOMETRY_SHADER;
        pub const UNIFORM_BLOCK_REFERENCED_BY_FRAGMENT_SHADER = bindings.UNIFORM_BLOCK_REFERENCED_BY_FRAGMENT_SHADER;
        pub const INVALID_INDEX = bindings.INVALID_INDEX;

        // pub var drawArraysInstanced: *const fn (
        //     mode: Enum,
        //     first: Int,
        //     count: Sizei,
        //     instancecount: Sizei,
        // ) callconv(.c) void = undefined;
        pub fn drawArraysInstanced(
            mode: PrimitiveType,
            first: i32,
            count: i32,
            instancecount: i32,
        ) void {
            bindings.drawArraysInstanced(
                @intFromEnum(mode),
                @bitCast(first),
                @bitCast(count),
                @bitCast(instancecount),
            );
        }

        // pub var drawElementsInstanced: *const fn (
        //     mode: Enum,
        //     count: Sizei,
        //     type: Enum,
        //     indices: ?*const anyopaque,
        //     instancecount: Sizei,
        // ) callconv(.c) void = undefined;
        pub fn drawElementsInstanced(
            mode: PrimitiveType,
            count: i32,
            index_type: DrawIndicesType,
            offset: usize, // offset into bound element array buffer
            instancecount: i32,
        ) void {
            bindings.drawElementsInstanced(
                @intFromEnum(mode),
                @bitCast(count),
                @intFromEnum(index_type),
                @ptrFromInt(offset),
                @bitCast(instancecount),
            );
        }

        // pub var texBuffer: *const fn (target: Enum, internalformat: Enum, buffer: Uint) callconv(.c) void = undefined;
        pub fn texBuffer(
            target: TexBufferTarget,
            internalformat: TextureInternalFormat,
            buffer: Buffer,
        ) void {
            bindings.texBuffer(
                @intFromEnum(target),
                @intFromEnum(internalformat),
                @intFromEnum(buffer),
            );
        }

        // pub var primitiveRestartIndex: *const fn (index: Uint) callconv(.c) void = undefined;
        pub fn primitiveRestartIndex(index: u32) void {
            bindings.primitiveRestartIndex(@bitCast(index));
        }

        // pub var copyBufferSubData: *const fn (
        //     readTarget: Enum,
        //     writeTarget: Enum,
        //     readOffset: Intptr,
        //     writeOffset: Intptr,
        //     size: Sizeiptr,
        // ) callconv(.c) void = undefined;
        pub fn copyBufferSubData(
            readTarget: BufferTarget,
            writeTarget: BufferTarget,
            readOffset: usize,
            writeOffset: usize,
            size: usize,
        ) void {
            bindings.copyBufferSubData(
                @intFromEnum(readTarget),
                @intFromEnum(writeTarget),
                @bitCast(readOffset),
                @bitCast(writeOffset),
                @bitCast(size),
            );
        }

        // pub var getUniformIndices: *const fn (
        //     program: Uint,
        //     uniformCount: Sizei,
        //     uniformNames: [*c]const [*c]const Char,
        //     uniformIndices: [*c]Uint,
        // ) callconv(.c) void = undefined;
        pub fn getUniformIndices(
            program: Program,
            uniformNames: []const [*:0]const u8,
            uniformIndices: []u32,
        ) void {
            assert(program != .invalid);
            assert(uniformNames.len == uniformIndices.len);
            bindings.getUniformIndices(
                @intFromEnum(program),
                @intCast(uniformNames.len),
                @ptrCast(uniformNames.ptr),
                @ptrCast(uniformIndices.ptr),
            );
        }

        // pub var getActiveUniformsiv: *const fn (
        //     program: Uint,
        //     uniformCount: Sizei,
        //     uniformIndices: [*c]const Uint,
        //     pname: Enum,
        //     params: [*c]Int,
        // ) callconv(.c) void = undefined;
        pub fn getActiveUniformsiv(
            program: Program,
            uniform_indices: []const u32,
            pname: UniformParameter,
            params: []i32,
        ) void {
            assert(program != .invalid);
            assert(uniform_indices.len == params.len);
            bindings.getActiveUniformsiv(
                @intFromEnum(program),
                @intCast(uniform_indices.len),
                @ptrCast(uniform_indices.ptr),
                @intFromEnum(pname),
                @ptrCast(params.ptr),
            );
        }

        // pub var getActiveUniformName: *const fn (
        //     program: Uint,
        //     uniformIndex: Uint,
        //     bufSize: Sizei,
        //     length: [*c]Sizei,
        //     uniformName: [*c]Char,
        // ) callconv(.c) void = undefined;
        pub fn getActiveUniformName(
            program: Program,
            uniform_index: u32,
            uniform_name_buf: [:0]u8,
        ) [:0]const u8 {
            assert(program != .invalid);
            var length: i32 = undefined;
            bindings.getActiveUniformName(
                @intFromEnum(program),
                @bitCast(uniform_index),
                // includes null terminator
                @intCast(uniform_name_buf.len + 1),
                // excludes null terminator
                @ptrCast(&length),
                @ptrCast(uniform_name_buf.ptr),
            );
            return uniform_name_buf[0..@intCast(length) :0];
        }

        // pub var getUniformBlockIndex: *const fn (
        //     program: Uint,
        //     uniformBlockName: [*c]const Char,
        // ) callconv(.c) Uint = undefined;
        pub fn getUniformBlockIndex(
            program: Program,
            uniformBlockName: [:0]const u8,
        ) u32 {
            assert(program != .invalid);
            return @bitCast(bindings.getUniformBlockIndex(
                @intFromEnum(program),
                @ptrCast(uniformBlockName.ptr),
            ));
        }

        // pub var getActiveUniformBlockiv: *const fn (
        //     program: Uint,
        //     uniformBlockIndex: Uint,
        //     pname: Enum,
        //     params: [*c]Int,
        // ) callconv(.c) void = undefined;
        pub fn getActiveUniformBlockiv(
            program: Program,
            uniformBlockIndex: u32,
            pname: UniformBlockParameter,
            params: []i32,
        ) void {
            assert(program != .invalid);
            bindings.getActiveUniformBlockiv(
                @intFromEnum(program),
                @bitCast(uniformBlockIndex),
                @intFromEnum(pname),
                @ptrCast(params.ptr),
            );
        }

        // pub var getActiveUniformBlockName: *const fn (
        //     program: Uint,
        //     uniformBlockIndex: Uint,
        //     bufSize: Sizei,
        //     length: [*c]Sizei,
        //     uniformBlockName: [*c]Char,
        // ) callconv(.c) void = undefined;
        pub fn getActiveUniformBlockName(
            program: Program,
            uniform_block_index: u32,
            uniform_block_name_buf: [:0]u8,
        ) [:0]const u8 {
            assert(program != .invalid);
            var length: i32 = undefined;
            bindings.getActiveUniformBlockName(
                @intFromEnum(program),
                @bitCast(uniform_block_index),
                // includes null terminator
                @intCast(uniform_block_name_buf.len + 1),
                // excludes null terminator
                @ptrCast(&length),
                @ptrCast(uniform_block_name_buf.ptr),
            );
            return uniform_block_name_buf[0..@intCast(length) :0];
        }

        // pub var uniformBlockBinding: *const fn (
        //     program: Uint,
        //     uniformBlockIndex: Uint,
        //     uniformBlockBinding: Uint,
        // ) callconv(.c) void = undefined;
        pub fn uniformBlockBinding(
            program: Program,
            // parameter names adjusted to avoid shadowing
            uniform_block_index: u32,
            uniform_block_binding: u32,
        ) void {
            assert(program != .invalid);
            bindings.uniformBlockBinding(
                @intFromEnum(program),
                @bitCast(uniform_block_index),
                @bitCast(uniform_block_binding),
            );
        }

        //------------------------------------------------------------------------------------------
        //
        // OpenGL 3.2 (Core Profile)
        //
        //------------------------------------------------------------------------------------------
        pub const Sync = bindings.Sync;
        pub const Uint64 = bindings.Uint64;
        pub const Int64 = bindings.Int64;

        pub const CONTEXT_CORE_PROFILE_BIT = bindings.CONTEXT_CORE_PROFILE_BIT;
        pub const CONTEXT_COMPATIBILITY_PROFILE_BIT = bindings.CONTEXT_COMPATIBILITY_PROFILE_BIT;
        pub const LINES_ADJACENCY = bindings.LINES_ADJACENCY;
        pub const LINE_STRIP_ADJACENCY = bindings.LINE_STRIP_ADJACENCY;
        pub const TRIANGLES_ADJACENCY = bindings.TRIANGLES_ADJACENCY;
        pub const TRIANGLE_STRIP_ADJACENCY = bindings.TRIANGLE_STRIP_ADJACENCY;
        pub const PROGRAM_POINT_SIZE = bindings.PROGRAM_POINT_SIZE;
        pub const MAX_GEOMETRY_TEXTURE_IMAGE_UNITS = bindings.MAX_GEOMETRY_TEXTURE_IMAGE_UNITS;
        pub const FRAMEBUFFER_ATTACHMENT_LAYERED = bindings.FRAMEBUFFER_ATTACHMENT_LAYERED;
        pub const FRAMEBUFFER_INCOMPLETE_LAYER_TARGETS = bindings.FRAMEBUFFER_INCOMPLETE_LAYER_TARGETS;
        pub const GEOMETRY_SHADER = bindings.GEOMETRY_SHADER;
        pub const GEOMETRY_VERTICES_OUT = bindings.GEOMETRY_VERTICES_OUT;
        pub const GEOMETRY_INPUT_TYPE = bindings.GEOMETRY_INPUT_TYPE;
        pub const GEOMETRY_OUTPUT_TYPE = bindings.GEOMETRY_OUTPUT_TYPE;
        pub const MAX_GEOMETRY_UNIFORM_COMPONENTS = bindings.MAX_GEOMETRY_UNIFORM_COMPONENTS;
        pub const MAX_GEOMETRY_OUTPUT_VERTICES = bindings.MAX_GEOMETRY_OUTPUT_VERTICES;
        pub const MAX_GEOMETRY_TOTAL_OUTPUT_COMPONENTS = bindings.MAX_GEOMETRY_TOTAL_OUTPUT_COMPONENTS;
        pub const MAX_VERTEX_OUTPUT_COMPONENTS = bindings.MAX_VERTEX_OUTPUT_COMPONENTS;
        pub const MAX_GEOMETRY_INPUT_COMPONENTS = bindings.MAX_GEOMETRY_INPUT_COMPONENTS;
        pub const MAX_GEOMETRY_OUTPUT_COMPONENTS = bindings.MAX_GEOMETRY_OUTPUT_COMPONENTS;
        pub const MAX_FRAGMENT_INPUT_COMPONENTS = bindings.MAX_FRAGMENT_INPUT_COMPONENTS;
        pub const CONTEXT_PROFILE_MASK = bindings.CONTEXT_PROFILE_MASK;
        pub const DEPTH_CLAMP = bindings.DEPTH_CLAMP;
        pub const QUADS_FOLLOW_PROVOKING_VERTEX_CONVENTION = bindings.QUADS_FOLLOW_PROVOKING_VERTEX_CONVENTION;
        pub const FIRST_VERTEX_CONVENTION = bindings.FIRST_VERTEX_CONVENTION;
        pub const LAST_VERTEX_CONVENTION = bindings.LAST_VERTEX_CONVENTION;
        pub const PROVOKING_VERTEX = bindings.PROVOKING_VERTEX;
        pub const TEXTURE_CUBE_MAP_SEAMLESS = bindings.TEXTURE_CUBE_MAP_SEAMLESS;
        pub const MAX_SERVER_WAIT_TIMEOUT = bindings.MAX_SERVER_WAIT_TIMEOUT;
        pub const OBJECT_TYPE = bindings.OBJECT_TYPE;
        pub const SYNC_CONDITION = bindings.SYNC_CONDITION;
        pub const SYNC_STATUS = bindings.SYNC_STATUS;
        pub const SYNC_FLAGS = bindings.SYNC_FLAGS;
        pub const SYNC_FENCE = bindings.SYNC_FENCE;
        pub const SYNC_GPU_COMMANDS_COMPLETE = bindings.SYNC_GPU_COMMANDS_COMPLETE;
        pub const UNSIGNALED = bindings.UNSIGNALED;
        pub const SIGNALED = bindings.SIGNALED;
        pub const ALREADY_SIGNALED = bindings.ALREADY_SIGNALED;
        pub const TIMEOUT_EXPIRED = bindings.TIMEOUT_EXPIRED;
        pub const CONDITION_SATISFIED = bindings.CONDITION_SATISFIED;
        pub const WAIT_FAILED = bindings.WAIT_FAILED;
        pub const TIMEOUT_IGNORED = bindings.TIMEOUT_IGNORED;
        pub const SYNC_FLUSH_COMMANDS_BIT = bindings.SYNC_FLUSH_COMMANDS_BIT;
        pub const SAMPLE_POSITION = bindings.SAMPLE_POSITION;
        pub const SAMPLE_MASK = bindings.SAMPLE_MASK;
        pub const SAMPLE_MASK_VALUE = bindings.SAMPLE_MASK_VALUE;
        pub const MAX_SAMPLE_MASK_WORDS = bindings.MAX_SAMPLE_MASK_WORDS;
        pub const TEXTURE_2D_MULTISAMPLE = bindings.TEXTURE_2D_MULTISAMPLE;
        pub const PROXY_TEXTURE_2D_MULTISAMPLE = bindings.PROXY_TEXTURE_2D_MULTISAMPLE;
        pub const TEXTURE_2D_MULTISAMPLE_ARRAY = bindings.TEXTURE_2D_MULTISAMPLE_ARRAY;
        pub const PROXY_TEXTURE_2D_MULTISAMPLE_ARRAY = bindings.PROXY_TEXTURE_2D_MULTISAMPLE_ARRAY;
        pub const TEXTURE_BINDING_2D_MULTISAMPLE = bindings.TEXTURE_BINDING_2D_MULTISAMPLE;
        pub const TEXTURE_BINDING_2D_MULTISAMPLE_ARRAY = bindings.TEXTURE_BINDING_2D_MULTISAMPLE_ARRAY;
        pub const TEXTURE_SAMPLES = bindings.TEXTURE_SAMPLES;
        pub const TEXTURE_FIXED_SAMPLE_LOCATIONS = bindings.TEXTURE_FIXED_SAMPLE_LOCATIONS;
        pub const SAMPLER_2D_MULTISAMPLE = bindings.SAMPLER_2D_MULTISAMPLE;
        pub const INT_SAMPLER_2D_MULTISAMPLE = bindings.INT_SAMPLER_2D_MULTISAMPLE;
        pub const UNSIGNED_INT_SAMPLER_2D_MULTISAMPLE = bindings.UNSIGNED_INT_SAMPLER_2D_MULTISAMPLE;
        pub const SAMPLER_2D_MULTISAMPLE_ARRAY = bindings.SAMPLER_2D_MULTISAMPLE_ARRAY;
        pub const INT_SAMPLER_2D_MULTISAMPLE_ARRAY = bindings.INT_SAMPLER_2D_MULTISAMPLE_ARRAY;
        pub const UNSIGNED_INT_SAMPLER_2D_MULTISAMPLE_ARRAY = bindings.UNSIGNED_INT_SAMPLER_2D_MULTISAMPLE_ARRAY;
        pub const MAX_COLOR_TEXTURE_SAMPLES = bindings.MAX_COLOR_TEXTURE_SAMPLES;
        pub const MAX_DEPTH_TEXTURE_SAMPLES = bindings.MAX_DEPTH_TEXTURE_SAMPLES;
        pub const MAX_INTEGER_SAMPLES = bindings.MAX_INTEGER_SAMPLES;

        // pub var drawElementsBaseVertex: *const fn (
        //     mode: Enum,
        //     count: Sizei,
        //     type: Enum,
        //     indices: ?*const anyopaque,
        //     basevertex: Int,
        // ) callconv(.c) void = undefined;
        pub fn drawElementsBaseVertex(
            mode: PrimitiveType,
            count: i32,
            index_type: DrawIndicesType,
            offset: usize, // offset into bound element array buffer
            basevertex: i32,
        ) void {
            bindings.drawElementsBaseVertex(
                @intFromEnum(mode),
                @bitCast(count),
                @intFromEnum(index_type),
                @ptrFromInt(offset),
                @bitCast(basevertex),
            );
        }

        // pub var drawRangeElementsBaseVertex: *const fn (
        //     mode: Enum,
        //     start: Uint,
        //     end: Uint,
        //     count: Sizei,
        //     type: Enum,
        //     indices: ?*const anyopaque,
        //     basevertex: Int,
        // ) callconv(.c) void = undefined;
        pub fn drawRangeElementsBaseVertex(
            mode: PrimitiveType,
            start: u32,
            end: u32,
            count: i32,
            index_type: DrawIndicesType,
            offset: usize, // offset into bound element array buffer
            basevertex: i32,
        ) void {
            bindings.drawRangeElementsBaseVertex(
                @intFromEnum(mode),
                @bitCast(start),
                @bitCast(end),
                @bitCast(count),
                @intFromEnum(index_type),
                @ptrFromInt(offset),
                @bitCast(basevertex),
            );
        }

        // pub var drawElementsInstancedBaseVertex: *const fn (
        //     mode: Enum,
        //     count: Sizei,
        //     type: Enum,
        //     indices: ?*const anyopaque,
        //     instancecount: Sizei,
        //     basevertex: Int,
        // ) callconv(.c) void = undefined;
        pub fn drawElementsInstancedBaseVertex(
            mode: PrimitiveType,
            count: i32,
            index_type: DrawIndicesType,
            offset: usize, // offset into bound element array buffer
            instancecount: i32,
            basevertex: i32,
        ) void {
            bindings.drawElementsInstancedBaseVertex(
                @intFromEnum(mode),
                @bitCast(count),
                @intFromEnum(index_type),
                @ptrFromInt(offset),
                @bitCast(instancecount),
                @bitCast(basevertex),
            );
        }

        // pub var multiDrawElementsBaseVertex: *const fn (
        //     mode: Enum,
        //     count: [*c]const Sizei,
        //     type: Enum,
        //     indices: [*c]const ?*const anyopaque,
        //     drawcount: Sizei,
        //     basevertex: [*c]const Int,
        // ) callconv(.c) void = undefined;
        pub fn multiDrawElementsBaseVertex(
            mode: PrimitiveType,
            counts: []const i32,
            index_type: DrawIndicesType,
            offsets: []const usize, // offsets into bound element array buffer
            drawcount: i32,
            basevertex: []const i32,
        ) void {
            assert(counts.len == drawcount);
            assert(offsets.len == drawcount);
            bindings.multiDrawElementsBaseVertex(
                @intFromEnum(mode),
                @ptrCast(counts.ptr),
                @intFromEnum(index_type),
                @ptrCast(offsets.ptr),
                @bitCast(drawcount),
                @ptrCast(basevertex.ptr),
            );
        }

        // pub var provokingVertex: *const fn (mode: Enum) callconv(.c) void = undefined;
        pub fn provokingVertex(mode: VertexProvokeMode) void {
            bindings.provokingVertex(@intFromEnum(mode));
        }

        // pub var fenceSync: *const fn (condition: Enum, flags: Bitfield) callconv(.c) Sync = undefined;
        pub fn fenceSync(
            condition: SyncCondition,
            // only valid flags value is zero
        ) Sync {
            return bindings.fenceSync(@intFromEnum(condition), 0);
        }

        // pub var isSync: *const fn (sync: Sync) callconv(.c) Boolean = undefined;
        pub fn isSync(sync: Sync) bool {
            return bindings.isSync(sync) == TRUE;
        }

        // pub var deleteSync: *const fn (sync: Sync) callconv(.c) void = undefined;
        pub fn deleteSync(sync: Sync) void {
            bindings.deleteSync(sync);
        }

        // pub var clientWaitSync: *const fn (sync: Sync, flags: Bitfield, timeout: Uint64) callconv(.c) Enum = undefined;
        pub fn clientWaitSync(
            sync: Sync,
            flags: WaitSyncFlags,
            timeout_nanos: u64,
        ) WaitSyncError!WaitSyncResult {
            const wait_result = bindings.clientWaitSync(
                sync,
                @bitCast(flags),
                timeout_nanos,
            );
            if (wait_result == WAIT_FAILED)
                return WaitSyncError.Failed;
            return @enumFromInt(wait_result);
        }

        // pub var waitSync: *const fn (sync: Sync, flags: Bitfield, timeout: Uint64) callconv(.c) void = undefined;
        pub fn waitSync(
            sync: Sync,
            timeout: WaitTimeout,
        ) void {
            bindings.waitSync(
                sync,
                0, // only valid flags value is zero
                @intFromEnum(timeout),
            );
        }

        // pub var getInteger64v: *const fn (pname: Enum, data: [*c]Int64) callconv(.c) void = undefined;
        pub fn getInteger64v(pname: ParamName, ptr: [*]Int64) void {
            bindings.getInteger64v(@intFromEnum(pname), ptr);
        }

        // pub var getSynciv: *const fn (
        //     sync: Sync,
        //     pname: Enum,
        //     count: Sizei,
        //     length: [*c]Sizei,
        //     values: [*c]Int,
        // ) callconv(.c) void = undefined;
        pub fn getSynciv(
            sync: Sync,
            pname: SyncParameter,
            value_buf: []i32,
        ) []const i32 {
            var length: i32 = undefined;
            bindings.getSynciv(
                sync,
                @intFromEnum(pname),
                @intCast(value_buf.len),
                @ptrCast(&length),
                @ptrCast(value_buf.ptr),
            );
            return value_buf[0..@intCast(length)];
        }

        // pub var getInteger64i_v: *const fn (target: Enum, index: Uint, data: [*c]Int64) callconv(.c) void = undefined;
        pub fn getInteger64i_v(target: IndexedInt64Parameter, index: u32, data: []i64) void {
            bindings.getInteger64i_v(
                @intFromEnum(target),
                @bitCast(index),
                @ptrCast(data.ptr),
            );
        }

        // pub var getBufferParameteri64v: *const fn (
        //     target: Enum,
        //     pname: Enum,
        //     params: [*c]Int64,
        // ) callconv(.c) void = undefined;
        pub fn getBufferParameteri64v(
            target: BufferTarget,
            pname: BufferParameter,
            params: []i64,
        ) void {
            bindings.getBufferParameteri64v(
                @intFromEnum(target),
                @intFromEnum(pname),
                @ptrCast(params.ptr),
            );
        }

        // pub var framebufferTexture: *const fn (
        //     target: Enum,
        //     attachment: Enum,
        //     texture: Uint,
        //     level: Int,
        // ) callconv(.c) void = undefined;
        pub fn framebufferTexture(
            target: FramebufferTarget,
            attachment: FramebufferAttachment,
            texture: Texture,
            level: i32,
        ) void {
            bindings.framebufferTexture(
                @intFromEnum(target),
                @intFromEnum(attachment),
                @intFromEnum(texture),
                @bitCast(level),
            );
        }

        // pub var texImage2DMultisample: *const fn (
        //     target: Enum,
        //     samples: Sizei,
        //     internalformat: Enum,
        //     width: Sizei,
        //     height: Sizei,
        //     fixedsamplelocations: Boolean,
        // ) callconv(.c) void = undefined;
        pub fn texImage2DMultisample(
            target: TexImage2DMultisampleTarget,
            samples: i32,
            internalformat: InternalFormat,
            width: i32,
            height: i32,
            fixedsamplelocations: bool,
        ) void {
            bindings.texImage2DMultisample(
                @intFromEnum(target),
                @bitCast(samples),
                @intFromEnum(internalformat),
                @bitCast(width),
                @bitCast(height),
                @intFromBool(fixedsamplelocations),
            );
        }

        // pub var texImage3DMultisample: *const fn (
        //     target: Enum,
        //     samples: Sizei,
        //     internalformat: Enum,
        //     width: Sizei,
        //     height: Sizei,
        //     depth: Sizei,
        //     fixedsamplelocations: Boolean,
        // ) callconv(.c) void = undefined;
        pub fn texImage3DMultisample(
            target: TexImage3DMultisampleTarget,
            samples: i32,
            internalformat: InternalFormat,
            width: i32,
            height: i32,
            depth: i32,
            fixedsamplelocations: bool,
        ) void {
            bindings.texImage3DMultisample(
                @intFromEnum(target),
                @bitCast(samples),
                @intFromEnum(internalformat),
                @bitCast(width),
                @bitCast(height),
                @bitCast(depth),
                @intFromBool(fixedsamplelocations),
            );
        }

        // pub var getMultisamplefv: *const fn (pname: Enum, index: Uint, val: [*c]Float) callconv(.c) void = undefined;
        pub fn getMultisamplefv(
            pname: MultisampleParameter,
            index: u32,
            val: []f32,
        ) void {
            bindings.getMultisamplefv(
                @intFromEnum(pname),
                @bitCast(index),
                @ptrCast(val.ptr),
            );
        }

        // pub var sampleMaski: *const fn (maskNumber: Uint, mask: Bitfield) callconv(.c) void = undefined;
        // mask bits are interpreted, but there are no
        // concrete enum values bits correspond to
        pub fn sampleMaski(maskNumber: u32, mask: u32) void {
            bindings.sampleMaski(
                @bitCast(maskNumber),
                @bitCast(mask),
            );
        }

        //------------------------------------------------------------------------------------------
        //
        // OpenGL 3.3 (Core Profile)
        //
        //------------------------------------------------------------------------------------------
        pub const VERTEX_ATTRIB_ARRAY_DIVISOR = bindings.VERTEX_ATTRIB_ARRAY_DIVISOR;
        pub const SRC1_COLOR = bindings.SRC1_COLOR;
        pub const ONE_MINUS_SRC1_COLOR = bindings.ONE_MINUS_SRC1_COLOR;
        pub const ONE_MINUS_SRC1_ALPHA = bindings.ONE_MINUS_SRC1_ALPHA;
        pub const MAX_DUAL_SOURCE_DRAW_BUFFERS = bindings.MAX_DUAL_SOURCE_DRAW_BUFFERS;
        pub const ANY_SAMPLES_PASSED = bindings.ANY_SAMPLES_PASSED;
        pub const SAMPLER_BINDING = bindings.SAMPLER_BINDING;
        pub const RGB10_A2UI = bindings.RGB10_A2UI;
        pub const TEXTURE_SWIZZLE_R = bindings.TEXTURE_SWIZZLE_R;
        pub const TEXTURE_SWIZZLE_G = bindings.TEXTURE_SWIZZLE_G;
        pub const TEXTURE_SWIZZLE_B = bindings.TEXTURE_SWIZZLE_B;
        pub const TEXTURE_SWIZZLE_A = bindings.TEXTURE_SWIZZLE_A;
        pub const TEXTURE_SWIZZLE_RGBA = bindings.TEXTURE_SWIZZLE_RGBA;
        pub const TIME_ELAPSED = bindings.TIME_ELAPSED;
        pub const TIMESTAMP = bindings.TIMESTAMP;
        pub const INT_2_10_10_10_REV = bindings.INT_2_10_10_10_REV;

        // pub var bindFragDataLocationIndexed: *const fn (
        //     program: Uint,
        //     colorNumber: Uint,
        //     index: Uint,
        //     name: [*c]const Char,
        // ) callconv(.c) void = undefined;
        pub fn bindFragDataLocationIndexed(
            program: Program,
            colorNumber: u32,
            index: u32,
            name: [:0]const u8,
        ) void {
            assert(program != .invalid);
            // prefix 'gl_' is reserved and cannot be used
            assert(!std.mem.startsWith(u8, name, "gl_"));
            bindings.bindFragDataLocationIndexed(
                @intFromEnum(program),
                @bitCast(colorNumber),
                @bitCast(index),
                @ptrCast(name.ptr),
            );
        }

        // pub var getFragDataIndex: *const fn (program: Uint, name: [*c]const Char) callconv(.c) Int = undefined;
        pub fn getFragDataIndex(
            program: Program,
            name: [:0]const u8,
        ) i32 {
            assert(program != .invalid);
            return @bitCast(bindings.getFragDataIndex(
                @intFromEnum(program),
                @ptrCast(name.ptr),
            ));
        }

        // pub var genSamplers: *const fn (count: Sizei, samplers: [*c]Uint) callconv(.c) void = undefined;
        pub fn genSampler(ptr: *Sampler) void {
            bindings.genSamplers(1, @ptrCast(ptr));
        }
        pub fn genSamplers(samplers: []Sampler) void {
            bindings.genSamplers(@intCast(samplers.len), @ptrCast(samplers.ptr));
        }

        // pub var deleteSamplers: *const fn (count: Sizei, samplers: [*c]const Uint) callconv(.c) void = undefined;
        pub fn deleteSampler(ptr: *const Sampler) void {
            bindings.deleteSamplers(1, @ptrCast(ptr));
        }
        pub fn deleteSamplers(samplers: []const Sampler) void {
            bindings.deleteSamplers(@intCast(samplers.len), @ptrCast(samplers.ptr));
        }

        // pub var isSampler: *const fn (sampler: Uint) callconv(.c) Boolean = undefined;
        pub fn isSampler(sampler: Sampler) bool {
            return bindings.isSampler(@intFromEnum(sampler)) == TRUE;
        }

        // pub var bindSampler: *const fn (unit: Uint, sampler: Uint) callconv(.c) void = undefined;
        pub fn bindSampler(unit: u32, sampler: Sampler) void {
            bindings.bindSampler(
                @bitCast(unit),
                @intFromEnum(sampler),
            );
        }

        // pub var samplerParameteri: *const fn (sampler: Uint, pname: Enum, param: Int) callconv(.c) void = undefined;
        pub fn samplerParameteri(
            sampler: Sampler,
            pname: SamplerParameter,
            param: i32,
        ) void {
            bindings.samplerParameteri(
                @intFromEnum(sampler),
                @intFromEnum(pname),
                @bitCast(param),
            );
        }

        // pub var samplerParameteriv: *const fn (
        //     sampler: Uint,
        //     pname: Enum,
        //     param: [*c]const Int,
        // ) callconv(.c) void = undefined;
        pub fn samplerParameteriv(
            sampler: Sampler,
            pname: SamplerParameter,
            param: []const i32,
        ) void {
            bindings.samplerParameteriv(
                @intFromEnum(sampler),
                @intFromEnum(pname),
                @ptrCast(param.ptr),
            );
        }

        // pub var samplerParameterf: *const fn (sampler: Uint, pname: Enum, param: Float) callconv(.c) void = undefined;
        pub fn samplerParameterf(
            sampler: Sampler,
            pname: SamplerParameter,
            param: f32,
        ) void {
            bindings.samplerParameterf(
                @intFromEnum(sampler),
                @intFromEnum(pname),
                param,
            );
        }

        // pub var samplerParameterfv: *const fn (
        //     sampler: Uint,
        //     pname: Enum,
        //     param: [*c]const Float,
        // ) callconv(.c) void = undefined;
        pub fn samplerParameterfv(
            sampler: Sampler,
            pname: SamplerParameter,
            param: []const f32,
        ) void {
            bindings.samplerParameterfv(
                @intFromEnum(sampler),
                @intFromEnum(pname),
                @ptrCast(param.ptr),
            );
        }

        // pub var samplerParameterIiv: *const fn (
        //     sampler: Uint,
        //     pname: Enum,
        //     param: [*c]const Int,
        // ) callconv(.c) void = undefined;
        pub fn samplerParameterIiv(
            sampler: Sampler,
            pname: SamplerParameter,
            param: []const i32,
        ) void {
            bindings.samplerParameterIiv(
                @intFromEnum(sampler),
                @intFromEnum(pname),
                @ptrCast(param.ptr),
            );
        }

        // pub var samplerParameterIuiv: *const fn (
        //     sampler: Uint,
        //     pname: Enum,
        //     param: [*c]const Uint,
        // ) callconv(.c) void = undefined;
        pub fn samplerParameterIuiv(
            sampler: Sampler,
            pname: SamplerParameter,
            param: []const u32,
        ) void {
            bindings.samplerParameterIuiv(
                @intFromEnum(sampler),
                @intFromEnum(pname),
                @ptrCast(param.ptr),
            );
        }

        // pub var getSamplerParameteriv: *const fn (
        //     sampler: Uint,
        //     pname: Enum,
        //     params: [*c]Int,
        // ) callconv(.c) void = undefined;
        pub fn getSamplerParameteriv(
            sampler: Sampler,
            pname: SamplerParameter,
            params: []i32,
        ) void {
            bindings.getSamplerParameteriv(
                @intFromEnum(sampler),
                @intFromEnum(pname),
                @ptrCast(params.ptr),
            );
        }

        // pub var getSamplerParameterIiv: *const fn (
        //     sampler: Uint,
        //     pname: Enum,
        //     params: [*c]Int,
        // ) callconv(.c) void = undefined;
        pub fn getSamplerParameterIiv(
            sampler: Sampler,
            pname: SamplerParameter,
            params: []i32,
        ) void {
            bindings.getSamplerParameterIiv(
                @intFromEnum(sampler),
                @intFromEnum(pname),
                @ptrCast(params.ptr),
            );
        }

        // pub var getSamplerParameterfv: *const fn (
        //     sampler: Uint,
        //     pname: Enum,
        //     params: [*c]Float,
        // ) callconv(.c) void = undefined;
        pub fn getSamplerParameterfv(
            sampler: Sampler,
            pname: SamplerParameter,
            params: []f32,
        ) void {
            bindings.getSamplerParameterfv(
                @intFromEnum(sampler),
                @intFromEnum(pname),
                @ptrCast(params.ptr),
            );
        }

        // pub var getSamplerParameterIuiv: *const fn (
        //     sampler: Uint,
        //     pname: Enum,
        //     params: [*c]Uint,
        // ) callconv(.c) void = undefined;
        pub fn getSamplerParameterIuiv(
            sampler: Sampler,
            pname: SamplerParameter,
            params: []u32,
        ) void {
            bindings.getSamplerParameterIuiv(
                @intFromEnum(sampler),
                @intFromEnum(pname),
                @ptrCast(params.ptr),
            );
        }

        // pub var queryCounter: *const fn (id: Uint, target: Enum) callconv(.c) void = undefined;
        pub fn queryCounter(query: Query, target: QueryCounterTarget) void {
            bindings.queryCounter(
                @intFromEnum(query),
                @intFromEnum(target),
            );
        }

        // pub var getQueryObjecti64v: *const fn (id: Uint, pname: Enum, params: [*c]Int64) callconv(.c) void = undefined;
        pub fn getQueryObjecti64v(
            query: Query,
            pname: QueryObjectParameter,
            params: []i64,
        ) void {
            bindings.getQueryObjecti64v(
                @intFromEnum(query),
                @intFromEnum(pname),
                @ptrCast(params.ptr),
            );
        }

        // pub var getQueryObjectui64v: *const fn (id: Uint, pname: Enum, params: [*c]Uint64) callconv(.c) void = undefined;
        pub fn getQueryObjectui64v(
            query: Query,
            pname: QueryObjectParameter,
            params: []u64,
        ) void {
            bindings.getQueryObjectui64v(
                @intFromEnum(query),
                @intFromEnum(pname),
                @ptrCast(params.ptr),
            );
        }

        // pub var vertexAttribDivisor: *const fn (index: Uint, divisor: Uint) callconv(.c) void = undefined;
        pub fn vertexAttribDivisor(
            location: VertexAttribLocation,
            divisor: u32,
        ) void {
            bindings.vertexAttribDivisor(
                @intFromEnum(location),
                @bitCast(divisor),
            );
        }

        // pub var vertexAttribP1ui: *const fn (index: Uint, type: Enum, normalized: Boolean, value: Uint) callconv(.c) void = undefined;
        pub fn vertexAttribP1ui(
            location: VertexAttribLocation,
            packed_type: VertexAttribPackedType,
            normalized: bool,
            value: u32,
        ) void {
            bindings.vertexAttribP1ui(
                @intFromEnum(location),
                @intFromEnum(packed_type),
                @intFromBool(normalized),
                @bitCast(value),
            );
        }

        // pub var vertexAttribP1uiv: *const fn (index: Uint, type: Enum, normalized: Boolean, value: [*c]const Uint) callconv(.c) void = undefined;
        pub fn vertexAttribP1uiv(
            location: VertexAttribLocation,
            packed_type: VertexAttribPackedType,
            normalized: bool,
            value: []const u32,
        ) void {
            bindings.vertexAttribP1uiv(
                @intFromEnum(location),
                @intFromEnum(packed_type),
                @intFromBool(normalized),
                @ptrCast(value.ptr),
            );
        }

        // pub var vertexAttribP2ui: *const fn (index: Uint, type: Enum, normalized: Boolean, value: Uint) callconv(.c) void = undefined;
        pub fn vertexAttribP2ui(
            location: VertexAttribLocation,
            packed_type: VertexAttribPackedType,
            normalized: bool,
            value: u32,
        ) void {
            bindings.vertexAttribP2ui(
                @intFromEnum(location),
                @intFromEnum(packed_type),
                @intFromBool(normalized),
                @bitCast(value),
            );
        }

        // pub var vertexAttribP2uiv: *const fn (index: Uint, type: Enum, normalized: Boolean, value: [*c]const Uint) callconv(.c) void = undefined;
        pub fn vertexAttribP2uiv(
            location: VertexAttribLocation,
            packed_type: VertexAttribPackedType,
            normalized: bool,
            value: []const u32,
        ) void {
            bindings.vertexAttribP2uiv(
                @intFromEnum(location),
                @intFromEnum(packed_type),
                @intFromBool(normalized),
                @ptrCast(value.ptr),
            );
        }

        // pub var vertexAttribP3ui: *const fn (index: Uint, type: Enum, normalized: Boolean, value: Uint) callconv(.c) void = undefined;
        pub fn vertexAttribP3ui(
            location: VertexAttribLocation,
            packed_type: VertexAttribPackedType,
            normalized: bool,
            value: u32,
        ) void {
            bindings.vertexAttribP3ui(
                @intFromEnum(location),
                @intFromEnum(packed_type),
                @intFromBool(normalized),
                @bitCast(value),
            );
        }

        // pub var vertexAttribP3uiv: *const fn (index: Uint, type: Enum, normalized: Boolean, value: [*c]const Uint) callconv(.c) void = undefined;
        pub fn vertexAttribP3uiv(
            location: VertexAttribLocation,
            packed_type: VertexAttribPackedType,
            normalized: bool,
            value: []const u32,
        ) void {
            bindings.vertexAttribP3uiv(
                @intFromEnum(location),
                @intFromEnum(packed_type),
                @intFromBool(normalized),
                @ptrCast(value.ptr),
            );
        }

        // pub var vertexAttribP4ui: *const fn (index: Uint, type: Enum, normalized: Boolean, value: Uint) callconv(.c) void = undefined;
        pub fn vertexAttribP4ui(
            location: VertexAttribLocation,
            packed_type: VertexAttribPackedType,
            normalized: bool,
            value: u32,
        ) void {
            bindings.vertexAttribP4ui(
                @intFromEnum(location),
                @intFromEnum(packed_type),
                @intFromBool(normalized),
                @bitCast(value),
            );
        }

        // pub var vertexAttribP4uiv: *const fn (index: Uint, type: Enum, normalized: Boolean, value: [*c]const Uint) callconv(.c) void = undefined;
        pub fn vertexAttribP4uiv(
            location: VertexAttribLocation,
            packed_type: VertexAttribPackedType,
            normalized: bool,
            value: []const u32,
        ) void {
            bindings.vertexAttribP4uiv(
                @intFromEnum(location),
                @intFromEnum(packed_type),
                @intFromBool(normalized),
                @ptrCast(value.ptr),
            );
        }

        // TODO: where do these belong? these are part of OpenGL 3.3 (Compatibility Profile)
        // pub var vertexP2ui: *const fn (type: Enum, value: Uint) callconv(.c) void = undefined;
        // pub var vertexP2uiv: *const fn (type: Enum, value: *const Uint) callconv(.c) void = undefined;
        // pub var vertexP3ui: *const fn (type: Enum, value: Uint) callconv(.c) void = undefined;
        // pub var vertexP3uiv: *const fn (type: Enum, value: *const Uint) callconv(.c) void = undefined;
        // pub var vertexP4ui: *const fn (type: Enum, value: Uint) callconv(.c) void = undefined;
        // pub var vertexP4uiv: *const fn (type: Enum, value: *const Uint) callconv(.c) void = undefined;
        // pub var texCoordP1ui: *const fn (type: Enum, coords: Uint) callconv(.c) void = undefined;
        // pub var texCoordP1uiv: *const fn (type: Enum, coords: *const Uint) callconv(.c) void = undefined;
        // pub var texCoordP2ui: *const fn (type: Enum, coords: Uint) callconv(.c) void = undefined;
        // pub var texCoordP2uiv: *const fn (type: Enum, coords: *const Uint) callconv(.c) void = undefined;
        // pub var texCoordP3ui: *const fn (type: Enum, coords: Uint) callconv(.c) void = undefined;
        // pub var texCoordP3uiv: *const fn (type: Enum, coords: *const Uint) callconv(.c) void = undefined;
        // pub var texCoordP4ui: *const fn (type: Enum, coords: Uint) callconv(.c) void = undefined;
        // pub var texCoordP4uiv: *const fn (type: Enum, coords: *const Uint) callconv(.c) void = undefined;
        // pub var multiTexCoordP1ui: *const fn (texture: Enum, type: Enum, coords: Uint) callconv(.c) void = undefined;
        // pub var multiTexCoordP1uiv: *const fn (texture: Enum, type: Enum, coords: *const Uint) callconv(.c) void = undefined;
        // pub var multiTexCoordP2ui: *const fn (texture: Enum, type: Enum, coords: Uint) callconv(.c) void = undefined;
        // pub var multiTexCoordP2uiv: *const fn (texture: Enum, type: Enum, coords: *const Uint) callconv(.c) void = undefined;
        // pub var multiTexCoordP3ui: *const fn (texture: Enum, type: Enum, coords: Uint) callconv(.c) void = undefined;
        // pub var multiTexCoordP3uiv: *const fn (texture: Enum, type: Enum, coords: *const Uint) callconv(.c) void = undefined;
        // pub var multiTexCoordP4ui: *const fn (texture: Enum, type: Enum, coords: Uint) callconv(.c) void = undefined;
        // pub var multiTexCoordP4uiv: *const fn (texture: Enum, type: Enum, coords: *const Uint) callconv(.c) void = undefined;
        // pub var normalP3ui: *const fn (type: Enum, coords: Uint) callconv(.c) void = undefined;
        // pub var normalP3uiv: *const fn (type: Enum, coords: *const Uint) callconv(.c) void = undefined;
        // pub var colorP3ui: *const fn (type: Enum, color: Uint) callconv(.c) void = undefined;
        // pub var colorP3uiv: *const fn (type: Enum, color: *const Uint) callconv(.c) void = undefined;
        // pub var colorP4ui: *const fn (type: Enum, color: Uint) callconv(.c) void = undefined;
        // pub var colorP4uiv: *const fn (type: Enum, color: *const Uint) callconv(.c) void = undefined;
        // pub var secondaryColorP3ui: *const fn (type: Enum, color: Uint) callconv(.c) void = undefined;
        // pub var secondaryColorP3uiv: *const fn (type: Enum, color: *const Uint) callconv(.c) void = undefined;

        //--------------------------------------------------------------------------------------------------
        //
        // OpenGL 4.0 (Core Profile)
        //
        //--------------------------------------------------------------------------------------------------
        pub const SAMPLE_SHADING = bindings.SAMPLE_SHADING;
        pub const MIN_SAMPLE_SHADING_VALUE = bindings.MIN_SAMPLE_SHADING_VALUE;
        pub const MIN_PROGRAM_TEXTURE_GATHER_OFFSET = bindings.MIN_PROGRAM_TEXTURE_GATHER_OFFSET;
        pub const MAX_PROGRAM_TEXTURE_GATHER_OFFSET = bindings.MAX_PROGRAM_TEXTURE_GATHER_OFFSET;
        pub const TEXTURE_CUBE_MAP_ARRAY = bindings.TEXTURE_CUBE_MAP_ARRAY;
        pub const TEXTURE_BINDING_CUBE_MAP_ARRAY = bindings.TEXTURE_BINDING_CUBE_MAP_ARRAY;
        pub const PROXY_TEXTURE_CUBE_MAP_ARRAY = bindings.PROXY_TEXTURE_CUBE_MAP_ARRAY;
        pub const SAMPLER_CUBE_MAP_ARRAY = bindings.SAMPLER_CUBE_MAP_ARRAY;
        pub const SAMPLER_CUBE_MAP_ARRAY_SHADOW = bindings.SAMPLER_CUBE_MAP_ARRAY_SHADOW;
        pub const INT_SAMPLER_CUBE_MAP_ARRAY = bindings.INT_SAMPLER_CUBE_MAP_ARRAY;
        pub const UNSIGNED_INT_SAMPLER_CUBE_MAP_ARRAY = bindings.UNSIGNED_INT_SAMPLER_CUBE_MAP_ARRAY;
        pub const DRAW_INDIRECT_BUFFER = bindings.DRAW_INDIRECT_BUFFER;
        pub const DRAW_INDIRECT_BUFFER_BINDING = bindings.DRAW_INDIRECT_BUFFER_BINDING;
        pub const GEOMETRY_SHADER_INVOCATIONS = bindings.GEOMETRY_SHADER_INVOCATIONS;
        pub const MAX_GEOMETRY_SHADER_INVOCATIONS = bindings.MAX_GEOMETRY_SHADER_INVOCATIONS;
        pub const MIN_FRAGMENT_INTERPOLATION_OFFSET = bindings.MIN_FRAGMENT_INTERPOLATION_OFFSET;
        pub const MAX_FRAGMENT_INTERPOLATION_OFFSET = bindings.MAX_FRAGMENT_INTERPOLATION_OFFSET;
        pub const FRAGMENT_INTERPOLATION_OFFSET_BITS = bindings.FRAGMENT_INTERPOLATION_OFFSET_BITS;
        pub const MAX_VERTEX_STREAMS = bindings.MAX_VERTEX_STREAMS;
        pub const DOUBLE_VEC2 = bindings.DOUBLE_VEC2;
        pub const DOUBLE_VEC3 = bindings.DOUBLE_VEC3;
        pub const DOUBLE_VEC4 = bindings.DOUBLE_VEC4;
        pub const DOUBLE_MAT2 = bindings.DOUBLE_MAT2;
        pub const DOUBLE_MAT3 = bindings.DOUBLE_MAT3;
        pub const DOUBLE_MAT4 = bindings.DOUBLE_MAT4;
        pub const DOUBLE_MAT2x3 = bindings.DOUBLE_MAT2x3;
        pub const DOUBLE_MAT2x4 = bindings.DOUBLE_MAT2x4;
        pub const DOUBLE_MAT3x2 = bindings.DOUBLE_MAT3x2;
        pub const DOUBLE_MAT3x4 = bindings.DOUBLE_MAT3x4;
        pub const DOUBLE_MAT4x2 = bindings.DOUBLE_MAT4x2;
        pub const DOUBLE_MAT4x3 = bindings.DOUBLE_MAT4x3;
        pub const ACTIVE_SUBROUTINES = bindings.ACTIVE_SUBROUTINES;
        pub const ACTIVE_SUBROUTINE_UNIFORMS = bindings.ACTIVE_SUBROUTINE_UNIFORMS;
        pub const ACTIVE_SUBROUTINE_UNIFORM_LOCATIONS = bindings.ACTIVE_SUBROUTINE_UNIFORM_LOCATIONS;
        pub const ACTIVE_SUBROUTINE_MAX_LENGTH = bindings.ACTIVE_SUBROUTINE_MAX_LENGTH;
        pub const ACTIVE_SUBROUTINE_UNIFORM_MAX_LENGTH = bindings.ACTIVE_SUBROUTINE_UNIFORM_MAX_LENGTH;
        pub const MAX_SUBROUTINES = bindings.MAX_SUBROUTINES;
        pub const MAX_SUBROUTINE_UNIFORM_LOCATIONS = bindings.MAX_SUBROUTINE_UNIFORM_LOCATIONS;
        pub const NUM_COMPATIBLE_SUBROUTINES = bindings.NUM_COMPATIBLE_SUBROUTINES;
        pub const COMPATIBLE_SUBROUTINES = bindings.COMPATIBLE_SUBROUTINES;
        pub const PATCHES = bindings.PATCHES;
        pub const PATCH_VERTICES = bindings.PATCH_VERTICES;
        pub const PATCH_DEFAULT_INNER_LEVEL = bindings.PATCH_DEFAULT_INNER_LEVEL;
        pub const PATCH_DEFAULT_OUTER_LEVEL = bindings.PATCH_DEFAULT_OUTER_LEVEL;
        pub const TESS_CONTROL_OUTPUT_VERTICES = bindings.TESS_CONTROL_OUTPUT_VERTICES;
        pub const TESS_GEN_MODE = bindings.TESS_GEN_MODE;
        pub const TESS_GEN_SPACING = bindings.TESS_GEN_SPACING;
        pub const TESS_GEN_VERTEX_ORDER = bindings.TESS_GEN_VERTEX_ORDER;
        pub const TESS_GEN_POINT_MODE = bindings.TESS_GEN_POINT_MODE;
        pub const ISOLINES = bindings.ISOLINES;
        pub const FRACTIONAL_ODD = bindings.FRACTIONAL_ODD;
        pub const FRACTIONAL_EVEN = bindings.FRACTIONAL_EVEN;
        pub const MAX_PATCH_VERTICES = bindings.MAX_PATCH_VERTICES;
        pub const MAX_TESS_GEN_LEVEL = bindings.MAX_TESS_GEN_LEVEL;
        pub const MAX_TESS_CONTROL_UNIFORM_COMPONENTS = bindings.MAX_TESS_CONTROL_UNIFORM_COMPONENTS;
        pub const MAX_TESS_EVALUATION_UNIFORM_COMPONENTS = bindings.MAX_TESS_EVALUATION_UNIFORM_COMPONENTS;
        pub const MAX_TESS_CONTROL_TEXTURE_IMAGE_UNITS = bindings.MAX_TESS_CONTROL_TEXTURE_IMAGE_UNITS;
        pub const MAX_TESS_EVALUATION_TEXTURE_IMAGE_UNITS = bindings.MAX_TESS_EVALUATION_TEXTURE_IMAGE_UNITS;
        pub const MAX_TESS_CONTROL_OUTPUT_COMPONENTS = bindings.MAX_TESS_CONTROL_OUTPUT_COMPONENTS;
        pub const MAX_TESS_PATCH_COMPONENTS = bindings.MAX_TESS_PATCH_COMPONENTS;
        pub const MAX_TESS_CONTROL_TOTAL_OUTPUT_COMPONENTS = bindings.MAX_TESS_CONTROL_TOTAL_OUTPUT_COMPONENTS;
        pub const MAX_TESS_EVALUATION_OUTPUT_COMPONENTS = bindings.MAX_TESS_EVALUATION_OUTPUT_COMPONENTS;
        pub const MAX_TESS_CONTROL_UNIFORM_BLOCKS = bindings.MAX_TESS_CONTROL_UNIFORM_BLOCKS;
        pub const MAX_TESS_EVALUATION_UNIFORM_BLOCKS = bindings.MAX_TESS_EVALUATION_UNIFORM_BLOCKS;
        pub const MAX_TESS_CONTROL_INPUT_COMPONENTS = bindings.MAX_TESS_CONTROL_INPUT_COMPONENTS;
        pub const MAX_TESS_EVALUATION_INPUT_COMPONENTS = bindings.MAX_TESS_EVALUATION_INPUT_COMPONENTS;
        pub const MAX_COMBINED_TESS_CONTROL_UNIFORM_COMPONENTS = bindings.MAX_COMBINED_TESS_CONTROL_UNIFORM_COMPONENTS;
        pub const MAX_COMBINED_TESS_EVALUATION_UNIFORM_COMPONENTS = bindings.MAX_COMBINED_TESS_EVALUATION_UNIFORM_COMPONENTS;
        pub const UNIFORM_BLOCK_REFERENCED_BY_TESS_CONTROL_SHADER = bindings.UNIFORM_BLOCK_REFERENCED_BY_TESS_CONTROL_SHADER;
        pub const UNIFORM_BLOCK_REFERENCED_BY_TESS_EVALUATION_SHADER = bindings.UNIFORM_BLOCK_REFERENCED_BY_TESS_EVALUATION_SHADER;
        pub const TESS_EVALUATION_SHADER = bindings.TESS_EVALUATION_SHADER;
        pub const TESS_CONTROL_SHADER = bindings.TESS_CONTROL_SHADER;
        pub const TRANSFORM_FEEDBACK = bindings.TRANSFORM_FEEDBACK;
        pub const TRANSFORM_FEEDBACK_BUFFER_PAUSED = bindings.TRANSFORM_FEEDBACK_BUFFER_PAUSED;
        pub const TRANSFORM_FEEDBACK_BUFFER_ACTIVE = bindings.TRANSFORM_FEEDBACK_BUFFER_ACTIVE;
        pub const TRANSFORM_FEEDBACK_BINDING = bindings.TRANSFORM_FEEDBACK_BINDING;
        pub const MAX_TRANSFORM_FEEDBACK_BUFFERS = bindings.MAX_TRANSFORM_FEEDBACK_BUFFERS;

        // pub var minSampleShading: *const fn (value: Float) callconv(.c) void = undefined;
        pub fn minSampleShading(value: f32) void {
            bindings.minSampleShading(value);
        }

        // pub var blendEquationi: *const fn (buf: Uint, mode: Enum) callconv(.c) void = undefined;
        pub fn blendEquationi(buf: u32, mode: BlendEquation) void {
            bindings.blendEquationi(@bitCast(buf), @intFromEnum(mode));
        }

        // pub var blendEquationSeparatei: *const fn (buf: Uint, modeRGB: Enum, modeAlpha: Enum) callconv(.c) void = undefined;
        pub fn blendEquationSeparatei(
            buf: u32,
            modeRGB: BlendEquation,
            modeAlpha: BlendEquation,
        ) void {
            bindings.blendEquationSeparatei(
                @bitCast(buf),
                @intFromEnum(modeRGB),
                @intFromEnum(modeAlpha),
            );
        }

        // pub var blendFunci: *const fn (buf: Uint, src: Enum, dst: Enum) callconv(.c) void = undefined;
        pub fn blendFunci(
            buf: u32,
            src: BlendFactor,
            dst: BlendFactor,
        ) void {
            bindings.blendFunci(
                @bitCast(buf),
                @intFromEnum(src),
                @intFromEnum(dst),
            );
        }

        // pub var blendFuncSeparatei: *const fn (buf: Uint, srcRGB: Enum, dstRGB: Enum, srcAlpha: Enum, dstAlpha: Enum) callconv(.c) void = undefined;
        pub fn blendFuncSeparatei(
            buf: u32,
            srcRGB: BlendFactor,
            dstRGB: BlendFactor,
            srcAlpha: BlendFactor,
            dstAlpha: BlendFactor,
        ) void {
            bindings.blendFuncSeparatei(
                @bitCast(buf),
                @intFromEnum(srcRGB),
                @intFromEnum(dstRGB),
                @intFromEnum(srcAlpha),
                @intFromEnum(dstAlpha),
            );
        }

        // pub var drawArraysIndirect: *const fn (mode: Enum, indirect: [*c]const DrawArraysIndirectCommand) callconv(.c) void = undefined;
        pub fn drawArraysIndirect(
            mode: PrimitiveType,
            indirect: *const DrawArraysIndirectCommand,
        ) void {
            bindings.drawArraysIndirect(
                @intFromEnum(mode),
                @ptrCast(indirect),
            );
        }

        // pub var drawElementsIndirect: *const fn (mode: Enum, type: Enum, indirect: [*c]const DrawElementsIndirectCommand) callconv(.c) void = undefined;
        pub fn drawElementsIndirect(
            mode: PrimitiveType,
            index_type: DrawIndicesType,
            indirect: *const DrawElementsIndirectCommand,
        ) void {
            bindings.drawElementsIndirect(
                @intFromEnum(mode),
                @intFromEnum(index_type),
                @ptrCast(indirect),
            );
        }

        // pub var uniform1d: *const fn (location: Int, x: Double) callconv(.c) void = undefined;
        pub fn uniform1d(location: UniformLocation, x: f64) void {
            assert(location != .invalid);
            bindings.uniform1d(@intFromEnum(location), x);
        }

        // pub var uniform2d: *const fn (location: Int, x: Double, y: Double) callconv(.c) void = undefined;
        pub fn uniform2d(location: UniformLocation, x: f64, y: f64) void {
            assert(location != .invalid);
            bindings.uniform2d(@intFromEnum(location), x, y);
        }

        // pub var uniform3d: *const fn (location: Int, x: Double, y: Double, z: Double) callconv(.c) void = undefined;
        pub fn uniform3d(location: UniformLocation, x: f64, y: f64, z: f64) void {
            assert(location != .invalid);
            bindings.uniform3d(@intFromEnum(location), x, y, z);
        }

        // pub var uniform4d: *const fn (location: Int, x: Double, y: Double, z: Double, w: Double) callconv(.c) void = undefined;
        pub fn uniform4d(location: UniformLocation, x: f64, y: f64, z: f64, w: f64) void {
            assert(location != .invalid);
            bindings.uniform4d(@intFromEnum(location), x, y, z, w);
        }

        // pub var uniform1dv: *const fn (location: Int, count: Sizei, value: [*c]const Double) callconv(.c) void = undefined;
        pub fn uniform1dv(location: UniformLocation, count: u32, value: []const f64) void {
            assert(location != .invalid);
            assert(value.len == count);
            bindings.uniform1dv(
                @intFromEnum(location),
                @bitCast(count),
                @ptrCast(value.ptr),
            );
        }

        // pub var uniform2dv: *const fn (location: Int, count: Sizei, value: [*c]const Double) callconv(.c) void = undefined;
        pub fn uniform2dv(location: UniformLocation, count: u32, value: []const f64) void {
            const vec_size = 2;
            assert(location != .invalid);
            assert(value.len % vec_size == 0);
            assert(value.len / vec_size == count);
            bindings.uniform2dv(
                @intFromEnum(location),
                @bitCast(count),
                @ptrCast(value.ptr),
            );
        }

        // pub var uniform3dv: *const fn (location: Int, count: Sizei, value: [*c]const Double) callconv(.c) void = undefined;
        pub fn uniform3dv(location: UniformLocation, count: u32, value: []const f64) void {
            const vec_size = 3;
            assert(location != .invalid);
            assert(value.len % vec_size == 0);
            assert(value.len / vec_size == count);
            bindings.uniform3dv(
                @intFromEnum(location),
                @bitCast(count),
                @ptrCast(value.ptr),
            );
        }

        // pub var uniform4dv: *const fn (location: Int, count: Sizei, value: [*c]const Double) callconv(.c) void = undefined;
        pub fn uniform4dv(location: UniformLocation, count: u32, value: []const f64) void {
            const vec_size = 4;
            assert(location != .invalid);
            assert(value.len % vec_size == 0);
            assert(value.len / vec_size == count);
            bindings.uniform4dv(
                @intFromEnum(location),
                @bitCast(count),
                @ptrCast(value.ptr),
            );
        }

        // pub var uniformMatrix2dv: *const fn (location: Int, count: Sizei, transpose: Boolean, value: [*c]const Double) callconv(.c) void = undefined;
        pub fn uniformMatrix2dv(
            location: UniformLocation,
            count: u32,
            transpose: bool,
            value: []const f64,
        ) void {
            const mat_size = 2 * 2;
            assert(location != .invalid);
            assert(value.len % mat_size == 0);
            assert(value.len / mat_size == count);
            bindings.uniformMatrix2dv(
                @intFromEnum(location),
                @bitCast(count),
                @intFromBool(transpose),
                @ptrCast(value.ptr),
            );
        }

        // pub var uniformMatrix3dv: *const fn (location: Int, count: Sizei, transpose: Boolean, value: [*c]const Double) callconv(.c) void = undefined;
        pub fn uniformMatrix3dv(
            location: UniformLocation,
            count: u32,
            transpose: bool,
            value: []const f64,
        ) void {
            const mat_size = 3 * 3;
            assert(location != .invalid);
            assert(value.len % mat_size == 0);
            assert(value.len / mat_size == count);
            bindings.uniformMatrix3dv(
                @intFromEnum(location),
                @bitCast(count),
                @intFromBool(transpose),
                @ptrCast(value.ptr),
            );
        }

        // pub var uniformMatrix4dv: *const fn (location: Int, count: Sizei, transpose: Boolean, value: [*c]const Double) callconv(.c) void = undefined;
        pub fn uniformMatrix4dv(
            location: UniformLocation,
            count: u32,
            transpose: bool,
            value: []const f64,
        ) void {
            const mat_size = 4 * 4;
            assert(location != .invalid);
            assert(value.len % mat_size == 0);
            assert(value.len / mat_size == count);
            bindings.uniformMatrix4dv(
                @intFromEnum(location),
                @bitCast(count),
                @intFromBool(transpose),
                @ptrCast(value.ptr),
            );
        }

        // pub var uniformMatrix2x3dv: *const fn (location: Int, count: Sizei, transpose: Boolean, value: [*c]const Double) callconv(.c) void = undefined;
        pub fn uniformMatrix2x3dv(
            location: UniformLocation,
            count: u32,
            transpose: bool,
            value: []const f64,
        ) void {
            const mat_size = 2 * 3;
            assert(location != .invalid);
            assert(value.len % mat_size == 0);
            assert(value.len / mat_size == count);
            bindings.uniformMatrix2x3dv(
                @intFromEnum(location),
                @bitCast(count),
                @intFromBool(transpose),
                @ptrCast(value.ptr),
            );
        }

        // pub var uniformMatrix2x4dv: *const fn (location: Int, count: Sizei, transpose: Boolean, value: [*c]const Double) callconv(.c) void = undefined;
        pub fn uniformMatrix2x4dv(
            location: UniformLocation,
            count: u32,
            transpose: bool,
            value: []const f64,
        ) void {
            const mat_size = 2 * 4;
            assert(location != .invalid);
            assert(value.len % mat_size == 0);
            assert(value.len / mat_size == count);
            bindings.uniformMatrix2x4dv(
                @intFromEnum(location),
                @bitCast(count),
                @intFromBool(transpose),
                @ptrCast(value.ptr),
            );
        }

        // pub var uniformMatrix3x2dv: *const fn (location: Int, count: Sizei, transpose: Boolean, value: [*c]const Double) callconv(.c) void = undefined;
        pub fn uniformMatrix3x2dv(
            location: UniformLocation,
            count: u32,
            transpose: bool,
            value: []const f64,
        ) void {
            const mat_size = 3 * 2;
            assert(location != .invalid);
            assert(value.len % mat_size == 0);
            assert(value.len / mat_size == count);
            bindings.uniformMatrix3x2dv(
                @intFromEnum(location),
                @bitCast(count),
                @intFromBool(transpose),
                @ptrCast(value.ptr),
            );
        }

        // pub var uniformMatrix3x4dv: *const fn (location: Int, count: Sizei, transpose: Boolean, value: [*c]const Double) callconv(.c) void = undefined;
        pub fn uniformMatrix3x4dv(
            location: UniformLocation,
            count: u32,
            transpose: bool,
            value: []const f64,
        ) void {
            const mat_size = 3 * 4;
            assert(location != .invalid);
            assert(value.len % mat_size == 0);
            assert(value.len / mat_size == count);
            bindings.uniformMatrix3x4dv(
                @intFromEnum(location),
                @bitCast(count),
                @intFromBool(transpose),
                @ptrCast(value.ptr),
            );
        }

        // pub var uniformMatrix4x2dv: *const fn (location: Int, count: Sizei, transpose: Boolean, value: [*c]const Double) callconv(.c) void = undefined;
        pub fn uniformMatrix4x2dv(
            location: UniformLocation,
            count: u32,
            transpose: bool,
            value: []const f64,
        ) void {
            const mat_size = 4 * 2;
            assert(location != .invalid);
            assert(value.len % mat_size == 0);
            assert(value.len / mat_size == count);
            bindings.uniformMatrix4x2dv(
                @intFromEnum(location),
                @bitCast(count),
                @intFromBool(transpose),
                @ptrCast(value.ptr),
            );
        }

        // pub var uniformMatrix4x3dv: *const fn (location: Int, count: Sizei, transpose: Boolean, value: [*c]const Double) callconv(.c) void = undefined;
        pub fn uniformMatrix4x3dv(
            location: UniformLocation,
            count: u32,
            transpose: bool,
            value: []const f64,
        ) void {
            const mat_size = 4 * 3;
            assert(location != .invalid);
            assert(value.len % mat_size == 0);
            assert(value.len / mat_size == count);
            bindings.uniformMatrix4x3dv(
                @intFromEnum(location),
                @bitCast(count),
                @intFromBool(transpose),
                @ptrCast(value.ptr),
            );
        }

        // pub var getUniformdv: *const fn (program: Uint, location: Int, params: [*c]Double) callconv(.c) void = undefined;
        pub fn getUniformdv(
            program: Program,
            location: UniformLocation,
            params: []f64,
        ) void {
            assert(program != .invalid);
            assert(location != .invalid);
            bindings.getUniformdv(
                @intFromEnum(program),
                @intFromEnum(location),
                @ptrCast(params.ptr),
            );
        }

        // pub var getSubroutineUniformLocation: *const fn (program: Uint, shadertype: Enum, name: [*c]const Char) callconv(.c) Int = undefined;
        pub fn getSubroutineUniformLocation(
            program: Program,
            shadertype: ShaderType,
            name: [:0]const u8,
        ) UniformLocation {
            assert(program != .invalid);
            return @enumFromInt(bindings.getSubroutineUniformLocation(
                @intFromEnum(program),
                @intFromEnum(shadertype),
                @ptrCast(name.ptr),
            ));
        }

        // pub var getSubroutineIndex: *const fn (program: Uint, shadertype: Enum, name: [*c]const Char) callconv(.c) Uint = undefined;
        pub fn getSubroutineIndex(
            program: Program,
            shadertype: ShaderType,
            name: [:0]const u8,
        ) u32 {
            assert(program != .invalid);
            return @bitCast(bindings.getSubroutineIndex(
                @intFromEnum(program),
                @intFromEnum(shadertype),
                @ptrCast(name.ptr),
            ));
        }

        // pub var getActiveSubroutineUniformiv: *const fn (program: Uint, shadertype: Enum, index: Uint, pname: Enum, values: [*c]Int) callconv(.c) void = undefined;
        pub fn getActiveSubroutineUniformiv(
            program: Program,
            shadertype: ShaderType,
            index: u32,
            pname: SubroutineUniformParameter,
            values: []i32,
        ) void {
            assert(program != .invalid);
            bindings.getActiveSubroutineUniformiv(
                @intFromEnum(program),
                @intFromEnum(shadertype),
                @bitCast(index),
                @intFromEnum(pname),
                @ptrCast(values.ptr),
            );
        }

        // pub var getActiveSubroutineUniformName: *const fn (program: Uint, shadertype: Enum, index: Uint, bufsize: Sizei, length: [*c]Sizei, name: [*c]Char) callconv(.c) void = undefined;
        pub fn getActiveSubroutineUniformName(
            program: Program,
            shadertype: ShaderType,
            index: u32,
            subroutine_uniform_name_buf: [:0]u8,
        ) [:0]const u8 {
            assert(program != .invalid);
            var length: i32 = undefined;
            bindings.getActiveSubroutineUniformName(
                @intFromEnum(program),
                @intFromEnum(shadertype),
                @bitCast(index),
                // includes null terminator
                @intCast(subroutine_uniform_name_buf.len + 1),
                // excludes null terminator
                @ptrCast(&length),
                @ptrCast(subroutine_uniform_name_buf.ptr),
            );
            return subroutine_uniform_name_buf[0..@intCast(length) :0];
        }

        // pub var getActiveSubroutineName: *const fn (program: Uint, shadertype: Enum, index: Uint, bufsize: Sizei, length: [*c]Sizei, name: [*c]Char) callconv(.c) void = undefined;
        pub fn getActiveSubroutineName(
            program: Program,
            shadertype: ShaderType,
            index: u32,
            subroutine_name_buf: [:0]u8,
        ) [:0]const u8 {
            assert(program != .invalid);
            var length: i32 = undefined;
            bindings.getActiveSubroutineName(
                @intFromEnum(program),
                @intFromEnum(shadertype),
                @bitCast(index),
                // includes null terminator
                @intCast(subroutine_name_buf.len + 1),
                // excludes null terminator
                @ptrCast(&length),
                @ptrCast(subroutine_name_buf.ptr),
            );
            return subroutine_name_buf[0..@intCast(length) :0];
        }

        // pub var uniformSubroutinesuiv: *const fn (shadertype: Enum, count: Sizei, indices: [*c]const Uint) callconv(.c) void = undefined;
        pub fn uniformSubroutinesuiv(
            shadertype: ShaderType,
            count: i32,
            indices: []const u32,
        ) void {
            bindings.uniformSubroutinesuiv(
                @intFromEnum(shadertype),
                @bitCast(count),
                @ptrCast(indices.ptr),
            );
        }

        // pub var getUniformSubroutineuiv: *const fn (shadertype: Enum, location: Int, params: [*c]Uint) callconv(.c) void = undefined;
        pub fn getUniformSubroutineuiv(
            shadertype: ShaderType,
            location: UniformLocation,
            params: []u32,
        ) void {
            bindings.getUniformSubroutineuiv(
                @intFromEnum(shadertype),
                @intFromEnum(location),
                @ptrCast(params.ptr),
            );
        }

        // pub var getProgramStageiv: *const fn (program: Uint, shadertype: Enum, pname: Enum, values: [*c]Int) callconv(.c) void = undefined;
        pub fn getProgramStageiv(
            program: Program,
            shadertype: ShaderType,
            pname: ProgramStageParameter,
            values: []i32,
        ) void {
            assert(program != .invalid);
            bindings.getProgramStageiv(
                @intFromEnum(program),
                @intFromEnum(shadertype),
                @intFromEnum(pname),
                @ptrCast(values.ptr),
            );
        }

        // pub var patchParameteri: *const fn (pname: Enum, value: Int) callconv(.c) void = undefined;
        pub fn patchParameteri(pname: PatchIntegerParameter, value: i32) void {
            bindings.patchParameteri(@intFromEnum(pname), @bitCast(value));
        }

        // pub var patchParameterfv: *const fn (pname: Enum, values: [*c]const Float) callconv(.c) void = undefined;
        pub fn patchParameterfv(pname: PatchFloatParameter, values: []const f32) void {
            bindings.patchParameterfv(@intFromEnum(pname), @ptrCast(values.ptr));
        }

        // pub var bindTransformFeedback: *const fn (target: Enum, id: Uint) callconv(.c) void = undefined;
        pub fn bindTransformFeedback(
            target: TransformFeedbackTarget,
            transform_feedback: TransformFeedback,
        ) void {
            bindings.bindTransformFeedback(
                @intFromEnum(target),
                @intFromEnum(transform_feedback),
            );
        }

        // pub var deleteTransformFeedbacks: *const fn (n: Sizei, ids: [*c]const Uint) callconv(.c) void = undefined;
        pub fn deleteTransformFeedback(ptr: *const TransformFeedback) void {
            bindings.deleteTransformFeedbacks(1, @ptrCast(ptr));
        }
        pub fn deleteTransformFeedbacks(transform_feedbacks: []const TransformFeedback) void {
            bindings.deleteTransformFeedbacks(
                @intCast(transform_feedbacks.len),
                @ptrCast(transform_feedbacks.ptr),
            );
        }

        // pub var genTransformFeedbacks: *const fn (n: Sizei, ids: [*c]Uint) callconv(.c) void = undefined;
        pub fn genTransformFeedback(ptr: *TransformFeedback) void {
            bindings.genTransformFeedbacks(1, @ptrCast(ptr));
        }
        pub fn genTransformFeedbacks(transform_feedbacks: []TransformFeedback) void {
            bindings.genTransformFeedbacks(
                @intCast(transform_feedbacks.len),
                @ptrCast(transform_feedbacks.ptr),
            );
        }

        // pub var isTransformFeedback: *const fn (id: Uint) callconv(.c) Boolean = undefined;
        pub fn isTransformFeedback(transform_feedback: TransformFeedback) bool {
            return bindings.isTransformFeedback(@intFromEnum(transform_feedback)) == TRUE;
        }

        // pub var pauseTransformFeedback: *const fn () callconv(.c) void = undefined;
        pub fn pauseTransformFeedback() void {
            bindings.pauseTransformFeedback();
        }

        // pub var resumeTransformFeedback: *const fn () callconv(.c) void = undefined;
        pub fn resumeTransformFeedback() void {
            bindings.resumeTransformFeedback();
        }

        // pub var drawTransformFeedback: *const fn (mode: Enum, id: Uint) callconv(.c) void = undefined;
        pub fn drawTransformFeedback(
            mode: PrimitiveType,
            transform_feedback: TransformFeedback,
        ) void {
            bindings.drawTransformFeedback(
                @intFromEnum(mode),
                @intFromEnum(transform_feedback),
            );
        }

        // pub var drawTransformFeedbackStream: *const fn (mode: Enum, id: Uint, stream: Uint) callconv(.c) void = undefined;
        pub fn drawTransformFeedbackStream(
            mode: PrimitiveType,
            transform_feedback: TransformFeedback,
            stream: u32,
        ) void {
            bindings.drawTransformFeedbackStream(
                @intFromEnum(mode),
                @intFromEnum(transform_feedback),
                @bitCast(stream),
            );
        }

        // pub var beginQueryIndexed: *const fn (target: Enum, index: Uint, id: Uint) callconv(.c) void = undefined;
        pub fn beginQueryIndexed(
            target: QueryTarget,
            index: u32,
            query: Query,
        ) void {
            bindings.beginQueryIndexed(
                @intFromEnum(target),
                @bitCast(index),
                @intFromEnum(query),
            );
        }

        // pub var endQueryIndexed: *const fn (target: Enum, index: Uint) callconv(.c) void = undefined;
        pub fn endQueryIndexed(
            target: QueryTarget,
            index: u32,
        ) void {
            bindings.endQueryIndexed(
                @intFromEnum(target),
                @bitCast(index),
            );
        }

        // pub var getQueryIndexediv: *const fn (target: Enum, index: Uint, pname: Enum, params: [*c]Int) callconv(.c) void = undefined;
        pub fn getQueryIndexediv(
            target: QueryTargetWithTimestamp,
            index: u32,
            pname: QueryParameter,
            params: []i32,
        ) void {
            bindings.getQueryIndexediv(
                @intFromEnum(target),
                @bitCast(index),
                @intFromEnum(pname),
                @ptrCast(params.ptr),
            );
        }

        //--------------------------------------------------------------------------------------------------
        //
        // OpenGL 4.1 (Core Profile)
        //
        //--------------------------------------------------------------------------------------------------
        pub const FIXED = bindings.FIXED;
        pub const IMPLEMENTATION_COLOR_READ_TYPE = bindings.IMPLEMENTATION_COLOR_READ_TYPE;
        pub const IMPLEMENTATION_COLOR_READ_FORMAT = bindings.IMPLEMENTATION_COLOR_READ_FORMAT;
        pub const LOW_FLOAT = bindings.LOW_FLOAT;
        pub const MEDIUM_FLOAT = bindings.MEDIUM_FLOAT;
        pub const HIGH_FLOAT = bindings.HIGH_FLOAT;
        pub const LOW_INT = bindings.LOW_INT;
        pub const MEDIUM_INT = bindings.MEDIUM_INT;
        pub const HIGH_INT = bindings.HIGH_INT;
        pub const SHADER_COMPILER = bindings.SHADER_COMPILER;
        pub const SHADER_BINARY_FORMATS = bindings.SHADER_BINARY_FORMATS;
        pub const NUM_SHADER_BINARY_FORMATS = bindings.NUM_SHADER_BINARY_FORMATS;
        pub const MAX_VERTEX_UNIFORM_VECTORS = bindings.MAX_VERTEX_UNIFORM_VECTORS;
        pub const MAX_VARYING_VECTORS = bindings.MAX_VARYING_VECTORS;
        pub const MAX_FRAGMENT_UNIFORM_VECTORS = bindings.MAX_FRAGMENT_UNIFORM_VECTORS;
        pub const RGB565 = bindings.RGB565;
        pub const PROGRAM_BINARY_RETRIEVABLE_HINT = bindings.PROGRAM_BINARY_RETRIEVABLE_HINT;
        pub const PROGRAM_BINARY_LENGTH = bindings.PROGRAM_BINARY_LENGTH;
        pub const NUM_PROGRAM_BINARY_FORMATS = bindings.NUM_PROGRAM_BINARY_FORMATS;
        pub const PROGRAM_BINARY_FORMATS = bindings.PROGRAM_BINARY_FORMATS;
        pub const VERTEX_SHADER_BIT = bindings.VERTEX_SHADER_BIT;
        pub const FRAGMENT_SHADER_BIT = bindings.FRAGMENT_SHADER_BIT;
        pub const GEOMETRY_SHADER_BIT = bindings.GEOMETRY_SHADER_BIT;
        pub const TESS_CONTROL_SHADER_BIT = bindings.TESS_CONTROL_SHADER_BIT;
        pub const TESS_EVALUATION_SHADER_BIT = bindings.TESS_EVALUATION_SHADER_BIT;
        pub const ALL_SHADER_BITS = bindings.ALL_SHADER_BITS;
        pub const PROGRAM_SEPARABLE = bindings.PROGRAM_SEPARABLE;
        pub const ACTIVE_PROGRAM = bindings.ACTIVE_PROGRAM;
        pub const PROGRAM_PIPELINE_BINDING = bindings.PROGRAM_PIPELINE_BINDING;
        pub const MAX_VIEWPORTS = bindings.MAX_VIEWPORTS;
        pub const VIEWPORT_SUBPIXEL_BITS = bindings.VIEWPORT_SUBPIXEL_BITS;
        pub const VIEWPORT_BOUNDS_RANGE = bindings.VIEWPORT_BOUNDS_RANGE;
        pub const LAYER_PROVOKING_VERTEX = bindings.LAYER_PROVOKING_VERTEX;
        pub const VIEWPORT_INDEX_PROVOKING_VERTEX = bindings.VIEWPORT_INDEX_PROVOKING_VERTEX;
        pub const UNDEFINED_VERTEX = bindings.UNDEFINED_VERTEX;

        // pub var releaseShaderCompiler: *const fn () callconv(.c) void = undefined;
        pub fn releaseShaderCompiler() void {
            bindings.releaseShaderCompiler();
        }

        // pub var shaderBinary: *const fn (
        //     count: Sizei,
        //     shaders: [*c]const Uint,
        //     binaryFormat: Enum,
        //     binary: ?*const anyopaque,
        //     length: Sizei,
        // ) callconv(.c) void = undefined;
        pub fn shaderBinary(
            shaders: []const Shader,
            binaryFormat: ShaderBinaryFormat,
            binary_buf: []const u8,
        ) void {
            bindings.shaderBinary(
                @intCast(shaders.len),
                @ptrCast(shaders.ptr),
                @intFromEnum(binaryFormat),
                @ptrCast(binary_buf.ptr),
                @intCast(binary_buf.len),
            );
        }

        // pub var getShaderPrecisionFormat: *const fn (
        //     shadertype: Enum,
        //     precisiontype: Enum,
        //     range: [*c]Int,
        //     precision: [*c]Int,
        // ) callconv(.c) void = undefined;
        pub fn getShaderPrecisionFormat(
            shadertype: ShaderTypeBasic,
            precisiontype: ShaderPrecisionFormat,
            range: []i32,
            precision: []i32,
        ) void {
            bindings.getShaderPrecisionFormat(
                @intFromEnum(shadertype),
                @intFromEnum(precisiontype),
                @ptrCast(range.ptr),
                @ptrCast(precision.ptr),
            );
        }

        // depthRangef first defined by OpenGL ES 1.0

        // clearDepthf first defined by OpenGL ES 1.0

        // pub var getProgramBinary: *const fn (
        //     program: Uint,
        //     bufSize: Sizei,
        //     length: [*c]Sizei,
        //     binaryFormat: [*c]Enum,
        //     binary: ?*anyopaque,
        // ) callconv(.c) void = undefined;
        pub fn getProgramBinary(
            program: Program,
            binaryFormat: *ProgramBinaryFormat,
            binary_buf: []u8,
        ) []const u8 {
            assert(program != .invalid);
            var length: i32 = undefined;
            bindings.getProgramBinary(
                @intFromEnum(program),
                @intCast(binary_buf.len),
                @ptrCast(&length),
                @ptrCast(binaryFormat),
                @ptrCast(binary_buf.ptr),
            );
            return binary_buf[0..@intCast(length)];
        }

        // pub var programBinary: *const fn (
        //     program: Uint,
        //     binaryFormat: Enum,
        //     binary: ?*const anyopaque,
        //     length: Sizei,
        // ) callconv(.c) void = undefined;
        pub fn programBinary(
            program: Program,
            binaryFormat: ProgramBinaryFormat,
            binary_buf: []const u8,
        ) void {
            assert(program != .invalid);
            bindings.programBinary(
                @intFromEnum(program),
                @intFromEnum(binaryFormat),
                @ptrCast(binary_buf.ptr),
                @intCast(binary_buf.len),
            );
        }

        // pub var programParameteri: *const fn (
        //     program: Uint,
        //     pname: Enum,
        //     value: Int,
        // ) callconv(.c) void = undefined;
        pub fn programParameteri(
            program: Program,
            pname: ProgramParameterModifiable,
            value: i32,
        ) void {
            assert(program != .invalid);
            bindings.programParameteri(
                @intFromEnum(program),
                @intFromEnum(pname),
                @bitCast(value),
            );
        }

        // pub var useProgramStages: *const fn (
        //     pipeline: Uint,
        //     stages: Bitfield,
        //     program: Uint,
        // ) callconv(.c) void = undefined;
        pub fn useProgramStages(
            pipeline: ProgramPipeline,
            stages: UsedProgramStages,
            program: Program,
        ) void {
            assert(program != .invalid);
            bindings.useProgramStages(
                @intFromEnum(pipeline),
                @bitCast(stages),
                @intFromEnum(program),
            );
        }

        // pub var activeShaderProgram: *const fn (
        //     pipeline: Uint,
        //     program: Uint,
        // ) callconv(.c) void = undefined;
        pub fn activeShaderProgram(
            pipeline: ProgramPipeline,
            program: Program,
        ) void {
            assert(program != .invalid);
            bindings.activeShaderProgram(
                @intFromEnum(pipeline),
                @intFromEnum(program),
            );
        }

        // pub var createShaderProgramv: *const fn (
        //     type: Enum,
        //     count: Sizei,
        //     strings: [*c]const [*c]const Char,
        // ) callconv(.c) Uint = undefined;
        pub fn createShaderProgramv(
            shader_type: ShaderType,
            src_ptrs: []const [*:0]const u8,
        ) Program {
            return @enumFromInt(bindings.createShaderProgramv(
                @intFromEnum(shader_type),
                @intCast(src_ptrs.len),
                @ptrCast(src_ptrs.ptr),
            ));
        }

        // pub var bindProgramPipeline: *const fn (pipeline: Uint) callconv(.c) void = undefined;
        pub fn bindProgramPipeline(pipeline: ProgramPipeline) void {
            bindings.bindProgramPipeline(@intFromEnum(pipeline));
        }

        // pub var deleteProgramPipelines: *const fn (
        //     n: Sizei,
        //     pipelines: [*c]const Uint,
        // ) callconv(.c) void = undefined;
        pub fn deleteProgramPipeline(ptr: *const ProgramPipeline) void {
            bindings.deleteProgramPipelines(1, @ptrCast(ptr));
        }
        pub fn deleteProgramPipelines(pipelines: []const ProgramPipeline) void {
            bindings.deleteProgramPipelines(
                @intCast(pipelines.len),
                @ptrCast(pipelines.ptr),
            );
        }

        // pub var genProgramPipelines: *const fn (n: Sizei, pipelines: [*c]Uint) callconv(.c) void = undefined;
        pub fn genProgramPipeline(ptr: *ProgramPipeline) void {
            bindings.genProgramPipelines(1, @ptrCast(ptr));
        }
        pub fn genProgramPipelines(pipelines: []ProgramPipeline) void {
            bindings.genProgramPipelines(
                @intCast(pipelines.len),
                @ptrCast(pipelines.ptr),
            );
        }

        // pub var isProgramPipeline: *const fn (pipeline: Uint) callconv(.c) Boolean = undefined
        pub fn isProgramPipeline(pipeline: ProgramPipeline) bool {
            return bindings.isProgramPipeline(@intFromEnum(pipeline)) == TRUE;
        }

        // pub var getProgramPipelineiv: *const fn (
        //     pipeline: Uint,
        //     pname: Enum,
        //     params: [*c]Int,
        // ) callconv(.c) void = undefined;
        pub fn getProgramPipelineiv(
            pipeline: ProgramPipeline,
            pname: ProgramPipelineParameter,
            params: []i32,
        ) void {
            bindings.getProgramPipelineiv(
                @intFromEnum(pipeline),
                @intFromEnum(pname),
                @ptrCast(params),
            );
        }

        // pub var programUniform1i: *const fn (
        //     program: Uint,
        //     location: Int,
        //     v0: Int,
        // ) callconv(.c) void = undefined;
        pub fn programUniform1i(
            program: Program,
            location: UniformLocation,
            v0: i32,
        ) void {
            assert(program != .invalid);
            assert(location != .invalid);
            bindings.programUniform1i(
                @intFromEnum(program),
                @intFromEnum(location),
                @bitCast(v0),
            );
        }

        // pub var programUniform2i: *const fn (
        //     program: Uint,
        //     location: Int,
        //     v0: Int,
        //     v1: Int,
        // ) callconv(.c) void = undefined;
        pub fn programUniform2i(
            program: Program,
            location: UniformLocation,
            v0: i32,
            v1: i32,
        ) void {
            assert(program != .invalid);
            assert(location != .invalid);
            bindings.programUniform2i(
                @intFromEnum(program),
                @intFromEnum(location),
                @bitCast(v0),
                @bitCast(v1),
            );
        }

        // pub var programUniform3i: *const fn (
        //     program: Uint,
        //     location: Int,
        //     v0: Int,
        //     v1: Int,
        //     v2: Int,
        // ) callconv(.c) void = undefined;
        pub fn programUniform3i(
            program: Program,
            location: UniformLocation,
            v0: i32,
            v1: i32,
            v2: i32,
        ) void {
            assert(program != .invalid);
            assert(location != .invalid);
            bindings.programUniform3i(
                @intFromEnum(program),
                @intFromEnum(location),
                @bitCast(v0),
                @bitCast(v1),
                @bitCast(v2),
            );
        }

        // pub var programUniform4i: *const fn (
        //     program: Uint,
        //     location: Int,
        //     v0: Int,
        //     v1: Int,
        //     v2: Int,
        //     v3: Int,
        // ) callconv(.c) void = undefined;
        pub fn programUniform4i(
            program: Program,
            location: UniformLocation,
            v0: i32,
            v1: i32,
            v2: i32,
            v3: i32,
        ) void {
            assert(program != .invalid);
            assert(location != .invalid);
            bindings.programUniform4i(
                @intFromEnum(program),
                @intFromEnum(location),
                @bitCast(v0),
                @bitCast(v1),
                @bitCast(v2),
                @bitCast(v3),
            );
        }

        // pub var programUniform1ui: *const fn (
        //     program: Uint,
        //     location: Int,
        //     v0: Uint,
        // ) callconv(.c) void = undefined;
        pub fn programUniform1ui(
            program: Program,
            location: UniformLocation,
            v0: u32,
        ) void {
            assert(program != .invalid);
            assert(location != .invalid);
            bindings.programUniform1ui(
                @intFromEnum(program),
                @intFromEnum(location),
                @bitCast(v0),
            );
        }

        // pub var programUniform2ui: *const fn (
        //     program: Uint,
        //     location: Int,
        //     v0: Uint,
        //     v1: Uint,
        // ) callconv(.c) void = undefined;
        pub fn programUniform2ui(
            program: Program,
            location: UniformLocation,
            v0: u32,
            v1: u32,
        ) void {
            assert(program != .invalid);
            assert(location != .invalid);
            bindings.programUniform2ui(
                @intFromEnum(program),
                @intFromEnum(location),
                @bitCast(v0),
                @bitCast(v1),
            );
        }

        // pub var programUniform3ui: *const fn (
        //     program: Uint,
        //     location: Int,
        //     v0: Uint,
        //     v1: Uint,
        //     v2: Uint,
        // ) callconv(.c) void = undefined;
        pub fn programUniform3ui(
            program: Program,
            location: UniformLocation,
            v0: u32,
            v1: u32,
            v2: u32,
        ) void {
            assert(program != .invalid);
            assert(location != .invalid);
            bindings.programUniform3ui(
                @intFromEnum(program),
                @intFromEnum(location),
                @bitCast(v0),
                @bitCast(v1),
                @bitCast(v2),
            );
        }

        // pub var programUniform4ui: *const fn (
        //     program: Uint,
        //     location: Int,
        //     v0: Uint,
        //     v1: Uint,
        //     v2: Uint,
        //     v3: Uint,
        // ) callconv(.c) void = undefined;
        pub fn programUniform4ui(
            program: Program,
            location: UniformLocation,
            v0: u32,
            v1: u32,
            v2: u32,
            v3: u32,
        ) void {
            assert(program != .invalid);
            assert(location != .invalid);
            bindings.programUniform4ui(
                @intFromEnum(program),
                @intFromEnum(location),
                @bitCast(v0),
                @bitCast(v1),
                @bitCast(v2),
                @bitCast(v3),
            );
        }

        // pub var programUniform1f: *const fn (
        //     program: Uint,
        //     location: Int,
        //     v0: Float,
        // ) callconv(.c) void = undefined;
        pub fn programUniform1f(
            program: Program,
            location: UniformLocation,
            v0: f32,
        ) void {
            assert(program != .invalid);
            assert(location != .invalid);
            bindings.programUniform1f(
                @intFromEnum(program),
                @intFromEnum(location),
                v0,
            );
        }

        // pub var programUniform2f: *const fn (
        //     program: Uint,
        //     location: Int,
        //     v0: Float,
        //     v1: Float,
        // ) callconv(.c) void = undefined;
        pub fn programUniform2f(
            program: Program,
            location: UniformLocation,
            v0: f32,
            v1: f32,
        ) void {
            assert(program != .invalid);
            assert(location != .invalid);
            bindings.programUniform2f(
                @intFromEnum(program),
                @intFromEnum(location),
                v0,
                v1,
            );
        }

        // pub var programUniform3f: *const fn (
        //     program: Uint,
        //     location: Int,
        //     v0: Float,
        //     v1: Float,
        //     v2: Float,
        // ) callconv(.c) void = undefined;
        pub fn programUniform3f(
            program: Program,
            location: UniformLocation,
            v0: f32,
            v1: f32,
            v2: f32,
        ) void {
            assert(program != .invalid);
            assert(location != .invalid);
            bindings.programUniform3f(
                @intFromEnum(program),
                @intFromEnum(location),
                v0,
                v1,
                v2,
            );
        }

        // pub var programUniform4f: *const fn (
        //     program: Uint,
        //     location: Int,
        //     v0: Float,
        //     v1: Float,
        //     v2: Float,
        //     v3: Float,
        // ) callconv(.c) void = undefined;
        pub fn programUniform4f(
            program: Program,
            location: UniformLocation,
            v0: f32,
            v1: f32,
            v2: f32,
            v3: f32,
        ) void {
            assert(program != .invalid);
            assert(location != .invalid);
            bindings.programUniform4f(
                @intFromEnum(program),
                @intFromEnum(location),
                v0,
                v1,
                v2,
                v3,
            );
        }

        // pub var programUniform1d: *const fn (
        //     program: Uint,
        //     location: Int,
        //     v0: Double,
        // ) callconv(.c) void = undefined;
        pub fn programUniform1d(
            program: Program,
            location: UniformLocation,
            v0: f64,
        ) void {
            assert(program != .invalid);
            assert(location != .invalid);
            bindings.programUniform1d(
                @intFromEnum(program),
                @intFromEnum(location),
                v0,
            );
        }

        // pub var programUniform2d: *const fn (
        //     program: Uint,
        //     location: Int,
        //     v0: Double,
        //     v1: Double,
        // ) callconv(.c) void = undefined;
        pub fn programUniform2d(
            program: Program,
            location: UniformLocation,
            v0: f64,
            v1: f64,
        ) void {
            assert(program != .invalid);
            assert(location != .invalid);
            bindings.programUniform2d(
                @intFromEnum(program),
                @intFromEnum(location),
                v0,
                v1,
            );
        }

        // pub var programUniform3d: *const fn (
        //     program: Uint,
        //     location: Int,
        //     v0: Double,
        //     v1: Double,
        //     v2: Double,
        // ) callconv(.c) void = undefined;
        pub fn programUniform3d(
            program: Program,
            location: UniformLocation,
            v0: f64,
            v1: f64,
            v2: f64,
        ) void {
            assert(program != .invalid);
            assert(location != .invalid);
            bindings.programUniform3d(
                @intFromEnum(program),
                @intFromEnum(location),
                v0,
                v1,
                v2,
            );
        }

        // pub var programUniform4d: *const fn (
        //     program: Uint,
        //     location: Int,
        //     v0: Double,
        //     v1: Double,
        //     v2: Double,
        //     v3: Double,
        // ) callconv(.c) void = undefined;
        pub fn programUniform4d(
            program: Program,
            location: UniformLocation,
            v0: f64,
            v1: f64,
            v2: f64,
            v3: f64,
        ) void {
            assert(program != .invalid);
            assert(location != .invalid);
            bindings.programUniform4d(
                @intFromEnum(program),
                @intFromEnum(location),
                v0,
                v1,
                v2,
                v3,
            );
        }

        // pub var programUniform1iv: *const fn (
        //     program: Uint,
        //     location: Int,
        //     count: Sizei,
        //     value: [*c]const Int,
        // ) callconv(.c) void = undefined;
        pub fn programUniform1iv(
            program: Program,
            location: UniformLocation,
            count: u32,
            value: []const i32,
        ) void {
            assert(program != .invalid);
            assert(location != .invalid);
            assert(value.len == count);
            bindings.programUniform1iv(
                @intFromEnum(program),
                @intFromEnum(location),
                @bitCast(count),
                @ptrCast(value.ptr),
            );
        }

        // pub var programUniform2iv: *const fn (
        //     program: Uint,
        //     location: Int,
        //     count: Sizei,
        //     value: [*c]const Int,
        // ) callconv(.c) void = undefined;
        pub fn programUniform2iv(
            program: Program,
            location: UniformLocation,
            count: u32,
            value: []const i32,
        ) void {
            const vec_size = 2;
            assert(program != .invalid);
            assert(location != .invalid);
            assert(value.len % vec_size == 0);
            assert(value.len / vec_size == count);
            bindings.programUniform2iv(
                @intFromEnum(program),
                @intFromEnum(location),
                @bitCast(count),
                @ptrCast(value.ptr),
            );
        }

        // pub var programUniform3iv: *const fn (
        //     program: Uint,
        //     location: Int,
        //     count: Sizei,
        //     value: [*c]const Int,
        // ) callconv(.c) void = undefined;
        pub fn programUniform3iv(
            program: Program,
            location: UniformLocation,
            count: u32,
            value: []const i32,
        ) void {
            const vec_size = 3;
            assert(program != .invalid);
            assert(location != .invalid);
            assert(value.len % vec_size == 0);
            assert(value.len / vec_size == count);
            bindings.programUniform3iv(
                @intFromEnum(program),
                @intFromEnum(location),
                @bitCast(count),
                @ptrCast(value.ptr),
            );
        }

        // pub var programUniform4iv: *const fn (
        //     program: Uint,
        //     location: Int,
        //     count: Sizei,
        //     value: [*c]const Int,
        // ) callconv(.c) void = undefined;
        pub fn programUniform4iv(
            program: Program,
            location: UniformLocation,
            count: u32,
            value: []const i32,
        ) void {
            const vec_size = 4;
            assert(program != .invalid);
            assert(location != .invalid);
            assert(value.len % vec_size == 0);
            assert(value.len / vec_size == count);
            bindings.programUniform4iv(
                @intFromEnum(program),
                @intFromEnum(location),
                @bitCast(count),
                @ptrCast(value.ptr),
            );
        }

        // pub var programUniform1uiv: *const fn (
        //     program: Uint,
        //     location: Int,
        //     count: Sizei,
        //     value: [*c]const Uint,
        // ) callconv(.c) void = undefined;
        pub fn programUniform1uiv(
            program: Program,
            location: UniformLocation,
            count: u32,
            value: []const u32,
        ) void {
            assert(program != .invalid);
            assert(location != .invalid);
            assert(value.len == count);
            bindings.programUniform1uiv(
                @intFromEnum(program),
                @intFromEnum(location),
                @bitCast(count),
                @ptrCast(value.ptr),
            );
        }

        // pub var programUniform2uiv: *const fn (
        //     program: Uint,
        //     location: Int,
        //     count: Sizei,
        //     value: [*c]const Uint,
        // ) callconv(.c) void = undefined;
        pub fn programUniform2uiv(
            program: Program,
            location: UniformLocation,
            count: u32,
            value: []const u32,
        ) void {
            const vec_size = 2;
            assert(program != .invalid);
            assert(location != .invalid);
            assert(value.len % vec_size == 0);
            assert(value.len / vec_size == count);
            bindings.programUniform2uiv(
                @intFromEnum(program),
                @intFromEnum(location),
                @bitCast(count),
                @ptrCast(value.ptr),
            );
        }

        // pub var programUniform3uiv: *const fn (
        //     program: Uint,
        //     location: Int,
        //     count: Sizei,
        //     value: [*c]const Uint,
        // ) callconv(.c) void = undefined;
        pub fn programUniform3uiv(
            program: Program,
            location: UniformLocation,
            count: u32,
            value: []const u32,
        ) void {
            const vec_size = 3;
            assert(program != .invalid);
            assert(location != .invalid);
            assert(value.len % vec_size == 0);
            assert(value.len / vec_size == count);
            bindings.programUniform3uiv(
                @intFromEnum(program),
                @intFromEnum(location),
                @bitCast(count),
                @ptrCast(value.ptr),
            );
        }

        // pub var programUniform4uiv: *const fn (
        //     program: Uint,
        //     location: Int,
        //     count: Sizei,
        //     value: [*c]const Uint,
        // ) callconv(.c) void = undefined;
        pub fn programUniform4uiv(
            program: Program,
            location: UniformLocation,
            count: u32,
            value: []const u32,
        ) void {
            const vec_size = 4;
            assert(program != .invalid);
            assert(location != .invalid);
            assert(value.len % vec_size == 0);
            assert(value.len / vec_size == count);
            bindings.programUniform4uiv(
                @intFromEnum(program),
                @intFromEnum(location),
                @bitCast(count),
                @ptrCast(value.ptr),
            );
        }

        // pub var programUniform1fv: *const fn (
        //     program: Uint,
        //     location: Int,
        //     count: Sizei,
        //     value: [*c]const Float,
        // ) callconv(.c) void = undefined;
        pub fn programUniform1fv(
            program: Program,
            location: UniformLocation,
            count: u32,
            value: []const f32,
        ) void {
            assert(program != .invalid);
            assert(location != .invalid);
            assert(value.len == count);
            bindings.programUniform1fv(
                @intFromEnum(program),
                @intFromEnum(location),
                @bitCast(count),
                @ptrCast(value.ptr),
            );
        }

        // pub var programUniform2fv: *const fn (
        //     program: Uint,
        //     location: Int,
        //     count: Sizei,
        //     value: [*c]const Float,
        // ) callconv(.c) void = undefined;
        pub fn programUniform2fv(
            program: Program,
            location: UniformLocation,
            count: u32,
            value: []const f32,
        ) void {
            const vec_size = 2;
            assert(program != .invalid);
            assert(location != .invalid);
            assert(value.len % vec_size == 0);
            assert(value.len / vec_size == count);
            bindings.programUniform2fv(
                @intFromEnum(program),
                @intFromEnum(location),
                @bitCast(count),
                @ptrCast(value.ptr),
            );
        }

        // pub var programUniform3fv: *const fn (
        //     program: Uint,
        //     location: Int,
        //     count: Sizei,
        //     value: [*c]const Float,
        // ) callconv(.c) void = undefined;
        pub fn programUniform3fv(
            program: Program,
            location: UniformLocation,
            count: u32,
            value: []const f32,
        ) void {
            const vec_size = 3;
            assert(program != .invalid);
            assert(location != .invalid);
            assert(value.len % vec_size == 0);
            assert(value.len / vec_size == count);
            bindings.programUniform3fv(
                @intFromEnum(program),
                @intFromEnum(location),
                @bitCast(count),
                @ptrCast(value.ptr),
            );
        }

        // pub var programUniform4fv: *const fn (
        //     program: Uint,
        //     location: Int,
        //     count: Sizei,
        //     value: [*c]const Float,
        // ) callconv(.c) void = undefined;
        pub fn programUniform4fv(
            program: Program,
            location: UniformLocation,
            count: u32,
            value: []const f32,
        ) void {
            const vec_size = 4;
            assert(program != .invalid);
            assert(location != .invalid);
            assert(value.len % vec_size == 0);
            assert(value.len / vec_size == count);
            bindings.programUniform4fv(
                @intFromEnum(program),
                @intFromEnum(location),
                @bitCast(count),
                @ptrCast(value.ptr),
            );
        }

        // pub var programUniform1dv: *const fn (
        //     program: Uint,
        //     location: Int,
        //     count: Sizei,
        //     value: [*c]const Double,
        // ) callconv(.c) void = undefined;
        pub fn programUniform1dv(
            program: Program,
            location: UniformLocation,
            count: u32,
            value: []const f64,
        ) void {
            assert(program != .invalid);
            assert(location != .invalid);
            assert(value.len == count);
            bindings.programUniform1dv(
                @intFromEnum(program),
                @intFromEnum(location),
                @bitCast(count),
                @ptrCast(value.ptr),
            );
        }

        // pub var programUniform2dv: *const fn (
        //     program: Uint,
        //     location: Int,
        //     count: Sizei,
        //     value: [*c]const Double,
        // ) callconv(.c) void = undefined;
        pub fn programUniform2dv(
            program: Program,
            location: UniformLocation,
            count: u32,
            value: []const f64,
        ) void {
            const vec_size = 2;
            assert(program != .invalid);
            assert(location != .invalid);
            assert(value.len % vec_size == 0);
            assert(value.len / vec_size == count);
            bindings.programUniform2dv(
                @intFromEnum(program),
                @intFromEnum(location),
                @bitCast(count),
                @ptrCast(value.ptr),
            );
        }

        // pub var programUniform3dv: *const fn (
        //     program: Uint,
        //     location: Int,
        //     count: Sizei,
        //     value: [*c]const Double,
        // ) callconv(.c) void = undefined;
        pub fn programUniform3dv(
            program: Program,
            location: UniformLocation,
            count: u32,
            value: []const f64,
        ) void {
            const vec_size = 3;
            assert(program != .invalid);
            assert(location != .invalid);
            assert(value.len % vec_size == 0);
            assert(value.len / vec_size == count);
            bindings.programUniform3dv(
                @intFromEnum(program),
                @intFromEnum(location),
                @bitCast(count),
                @ptrCast(value.ptr),
            );
        }

        // pub var programUniform4dv: *const fn (
        //     program: Uint,
        //     location: Int,
        //     count: Sizei,
        //     value: [*c]const Double,
        // ) callconv(.c) void = undefined;
        pub fn programUniform4dv(
            program: Program,
            location: UniformLocation,
            count: u32,
            value: []const f64,
        ) void {
            const vec_size = 4;
            assert(program != .invalid);
            assert(location != .invalid);
            assert(value.len % vec_size == 0);
            assert(value.len / vec_size == count);
            bindings.programUniform4dv(
                @intFromEnum(program),
                @intFromEnum(location),
                @bitCast(count),
                @ptrCast(value.ptr),
            );
        }

        // pub var programUniformMatrix2fv: *const fn (
        //     program: Uint,
        //     location: Int,
        //     count: Sizei,
        //     transpose: Boolean,
        //     value: [*c]const Float,
        // ) callconv(.c) void = undefined;
        pub fn programUniformMatrix2fv(
            program: Program,
            location: UniformLocation,
            count: u32,
            transpose: bool,
            value: []const f32,
        ) void {
            const mat_size = 2 * 2;
            assert(program != .invalid);
            assert(location != .invalid);
            assert(value.len % mat_size == 0);
            assert(value.len / mat_size == count);
            bindings.programUniformMatrix2fv(
                @intFromEnum(program),
                @intFromEnum(location),
                @bitCast(count),
                @intFromBool(transpose),
                @ptrCast(value.ptr),
            );
        }

        // pub var programUniformMatrix3fv: *const fn (
        //     program: Uint,
        //     location: Int,
        //     count: Sizei,
        //     transpose: Boolean,
        //     value: [*c]const Float,
        // ) callconv(.c) void = undefined;
        pub fn programUniformMatrix3fv(
            program: Program,
            location: UniformLocation,
            count: u32,
            transpose: bool,
            value: []const f32,
        ) void {
            const mat_size = 3 * 3;
            assert(program != .invalid);
            assert(location != .invalid);
            assert(value.len % mat_size == 0);
            assert(value.len / mat_size == count);
            bindings.programUniformMatrix3fv(
                @intFromEnum(program),
                @intFromEnum(location),
                @bitCast(count),
                @intFromBool(transpose),
                @ptrCast(value.ptr),
            );
        }

        // pub var programUniformMatrix4fv: *const fn (
        //     program: Uint,
        //     location: Int,
        //     count: Sizei,
        //     transpose: Boolean,
        //     value: [*c]const Float,
        // ) callconv(.c) void = undefined;
        pub fn programUniformMatrix4fv(
            program: Program,
            location: UniformLocation,
            count: u32,
            transpose: bool,
            value: []const f32,
        ) void {
            const mat_size = 4 * 4;
            assert(program != .invalid);
            assert(location != .invalid);
            assert(value.len % mat_size == 0);
            assert(value.len / mat_size == count);
            bindings.programUniformMatrix4fv(
                @intFromEnum(program),
                @intFromEnum(location),
                @bitCast(count),
                @intFromBool(transpose),
                @ptrCast(value.ptr),
            );
        }

        // pub var programUniformMatrix2dv: *const fn (
        //     program: Uint,
        //     location: Int,
        //     count: Sizei,
        //     transpose: Boolean,
        //     value: [*c]const Double,
        // ) callconv(.c) void = undefined;
        pub fn programUniformMatrix2dv(
            program: Program,
            location: UniformLocation,
            count: u32,
            transpose: bool,
            value: []const f64,
        ) void {
            const mat_size = 2 * 2;
            assert(program != .invalid);
            assert(location != .invalid);
            assert(value.len % mat_size == 0);
            assert(value.len / mat_size == count);
            bindings.programUniformMatrix2dv(
                @intFromEnum(program),
                @intFromEnum(location),
                @bitCast(count),
                @intFromBool(transpose),
                @ptrCast(value.ptr),
            );
        }

        // pub var programUniformMatrix3dv: *const fn (
        //     program: Uint,
        //     location: Int,
        //     count: Sizei,
        //     transpose: Boolean,
        //     value: [*c]const Double,
        // ) callconv(.c) void = undefined;
        pub fn programUniformMatrix3dv(
            program: Program,
            location: UniformLocation,
            count: u32,
            transpose: bool,
            value: []const f64,
        ) void {
            const mat_size = 3 * 3;
            assert(program != .invalid);
            assert(location != .invalid);
            assert(value.len % mat_size == 0);
            assert(value.len / mat_size == count);
            bindings.programUniformMatrix3dv(
                @intFromEnum(program),
                @intFromEnum(location),
                @bitCast(count),
                @intFromBool(transpose),
                @ptrCast(value.ptr),
            );
        }

        // pub var programUniformMatrix4dv: *const fn (
        //     program: Uint,
        //     location: Int,
        //     count: Sizei,
        //     transpose: Boolean,
        //     value: [*c]const Double,
        // ) callconv(.c) void = undefined;
        pub fn programUniformMatrix4dv(
            program: Program,
            location: UniformLocation,
            count: u32,
            transpose: bool,
            value: []const f64,
        ) void {
            const mat_size = 4 * 4;
            assert(program != .invalid);
            assert(location != .invalid);
            assert(value.len % mat_size == 0);
            assert(value.len / mat_size == count);
            bindings.programUniformMatrix4dv(
                @intFromEnum(program),
                @intFromEnum(location),
                @bitCast(count),
                @intFromBool(transpose),
                @ptrCast(value.ptr),
            );
        }

        // pub var programUniformMatrix2x3fv: *const fn (
        //     program: Uint,
        //     location: Int,
        //     count: Sizei,
        //     transpose: Boolean,
        //     value: [*c]const Float,
        // ) callconv(.c) void = undefined;
        pub fn programUniformMatrix2x3fv(
            program: Program,
            location: UniformLocation,
            count: u32,
            transpose: bool,
            value: []const f32,
        ) void {
            const mat_size = 2 * 3;
            assert(program != .invalid);
            assert(location != .invalid);
            assert(value.len % mat_size == 0);
            assert(value.len / mat_size == count);
            bindings.programUniformMatrix2x3fv(
                @intFromEnum(program),
                @intFromEnum(location),
                @bitCast(count),
                @intFromBool(transpose),
                @ptrCast(value.ptr),
            );
        }

        // pub var programUniformMatrix3x2fv: *const fn (
        //     program: Uint,
        //     location: Int,
        //     count: Sizei,
        //     transpose: Boolean,
        //     value: [*c]const Float,
        // ) callconv(.c) void = undefined;
        pub fn programUniformMatrix3x2fv(
            program: Program,
            location: UniformLocation,
            count: u32,
            transpose: bool,
            value: []const f32,
        ) void {
            const mat_size = 3 * 2;
            assert(program != .invalid);
            assert(location != .invalid);
            assert(value.len % mat_size == 0);
            assert(value.len / mat_size == count);
            bindings.programUniformMatrix3x2fv(
                @intFromEnum(program),
                @intFromEnum(location),
                @bitCast(count),
                @intFromBool(transpose),
                @ptrCast(value.ptr),
            );
        }

        // pub var programUniformMatrix2x4fv: *const fn (
        //     program: Uint,
        //     location: Int,
        //     count: Sizei,
        //     transpose: Boolean,
        //     value: [*c]const Float,
        // ) callconv(.c) void = undefined;
        pub fn programUniformMatrix2x4fv(
            program: Program,
            location: UniformLocation,
            count: u32,
            transpose: bool,
            value: []const f32,
        ) void {
            const mat_size = 2 * 4;
            assert(program != .invalid);
            assert(location != .invalid);
            assert(value.len % mat_size == 0);
            assert(value.len / mat_size == count);
            bindings.programUniformMatrix2x4fv(
                @intFromEnum(program),
                @intFromEnum(location),
                @bitCast(count),
                @intFromBool(transpose),
                @ptrCast(value.ptr),
            );
        }

        // pub var programUniformMatrix4x2fv: *const fn (
        //     program: Uint,
        //     location: Int,
        //     count: Sizei,
        //     transpose: Boolean,
        //     value: [*c]const Float,
        // ) callconv(.c) void = undefined;
        pub fn programUniformMatrix4x2fv(
            program: Program,
            location: UniformLocation,
            count: u32,
            transpose: bool,
            value: []const f32,
        ) void {
            const mat_size = 4 * 2;
            assert(program != .invalid);
            assert(location != .invalid);
            assert(value.len % mat_size == 0);
            assert(value.len / mat_size == count);
            bindings.programUniformMatrix4x2fv(
                @intFromEnum(program),
                @intFromEnum(location),
                @bitCast(count),
                @intFromBool(transpose),
                @ptrCast(value.ptr),
            );
        }

        // pub var programUniformMatrix3x4fv: *const fn (
        //     program: Uint,
        //     location: Int,
        //     count: Sizei,
        //     transpose: Boolean,
        //     value: [*c]const Float,
        // ) callconv(.c) void = undefined;
        pub fn programUniformMatrix3x4fv(
            program: Program,
            location: UniformLocation,
            count: u32,
            transpose: bool,
            value: []const f32,
        ) void {
            const mat_size = 3 * 4;
            assert(program != .invalid);
            assert(location != .invalid);
            assert(value.len % mat_size == 0);
            assert(value.len / mat_size == count);
            bindings.programUniformMatrix3x4fv(
                @intFromEnum(program),
                @intFromEnum(location),
                @bitCast(count),
                @intFromBool(transpose),
                @ptrCast(value.ptr),
            );
        }

        // pub var programUniformMatrix4x3fv: *const fn (
        //     program: Uint,
        //     location: Int,
        //     count: Sizei,
        //     transpose: Boolean,
        //     value: [*c]const Float,
        // ) callconv(.c) void = undefined;
        pub fn programUniformMatrix4x3fv(
            program: Program,
            location: UniformLocation,
            count: u32,
            transpose: bool,
            value: []const f32,
        ) void {
            const mat_size = 4 * 3;
            assert(program != .invalid);
            assert(location != .invalid);
            assert(value.len % mat_size == 0);
            assert(value.len / mat_size == count);
            bindings.programUniformMatrix4x3fv(
                @intFromEnum(program),
                @intFromEnum(location),
                @bitCast(count),
                @intFromBool(transpose),
                @ptrCast(value.ptr),
            );
        }

        // pub var programUniformMatrix2x3dv: *const fn (
        //     program: Uint,
        //     location: Int,
        //     count: Sizei,
        //     transpose: Boolean,
        //     value: [*c]const Double,
        // ) callconv(.c) void = undefined;
        pub fn programUniformMatrix2x3dv(
            program: Program,
            location: UniformLocation,
            count: u32,
            transpose: bool,
            value: []const f64,
        ) void {
            const mat_size = 2 * 3;
            assert(program != .invalid);
            assert(location != .invalid);
            assert(value.len % mat_size == 0);
            assert(value.len / mat_size == count);
            bindings.programUniformMatrix2x3dv(
                @intFromEnum(program),
                @intFromEnum(location),
                @bitCast(count),
                @intFromBool(transpose),
                @ptrCast(value.ptr),
            );
        }

        // pub var programUniformMatrix3x2dv: *const fn (
        //     program: Uint,
        //     location: Int,
        //     count: Sizei,
        //     transpose: Boolean,
        //     value: [*c]const Double,
        // ) callconv(.c) void = undefined;
        pub fn programUniformMatrix3x2dv(
            program: Program,
            location: UniformLocation,
            count: u32,
            transpose: bool,
            value: []const f64,
        ) void {
            const mat_size = 3 * 2;
            assert(program != .invalid);
            assert(location != .invalid);
            assert(value.len % mat_size == 0);
            assert(value.len / mat_size == count);
            bindings.programUniformMatrix3x2dv(
                @intFromEnum(program),
                @intFromEnum(location),
                @bitCast(count),
                @intFromBool(transpose),
                @ptrCast(value.ptr),
            );
        }

        // pub var programUniformMatrix2x4dv: *const fn (
        //     program: Uint,
        //     location: Int,
        //     count: Sizei,
        //     transpose: Boolean,
        //     value: [*c]const Double,
        // ) callconv(.c) void = undefined;
        pub fn programUniformMatrix2x4dv(
            program: Program,
            location: UniformLocation,
            count: u32,
            transpose: bool,
            value: []const f64,
        ) void {
            const mat_size = 2 * 4;
            assert(program != .invalid);
            assert(location != .invalid);
            assert(value.len % mat_size == 0);
            assert(value.len / mat_size == count);
            bindings.programUniformMatrix2x4dv(
                @intFromEnum(program),
                @intFromEnum(location),
                @bitCast(count),
                @intFromBool(transpose),
                @ptrCast(value.ptr),
            );
        }

        // pub var programUniformMatrix4x2dv: *const fn (
        //     program: Uint,
        //     location: Int,
        //     count: Sizei,
        //     transpose: Boolean,
        //     value: [*c]const Double,
        // ) callconv(.c) void = undefined;
        pub fn programUniformMatrix4x2dv(
            program: Program,
            location: UniformLocation,
            count: u32,
            transpose: bool,
            value: []const f64,
        ) void {
            const mat_size = 4 * 2;
            assert(program != .invalid);
            assert(location != .invalid);
            assert(value.len % mat_size == 0);
            assert(value.len / mat_size == count);
            bindings.programUniformMatrix4x2dv(
                @intFromEnum(program),
                @intFromEnum(location),
                @bitCast(count),
                @intFromBool(transpose),
                @ptrCast(value.ptr),
            );
        }

        // pub var programUniformMatrix3x4dv: *const fn (
        //     program: Uint,
        //     location: Int,
        //     count: Sizei,
        //     transpose: Boolean,
        //     value: [*c]const Double,
        // ) callconv(.c) void = undefined;
        pub fn programUniformMatrix3x4dv(
            program: Program,
            location: UniformLocation,
            count: u32,
            transpose: bool,
            value: []const f64,
        ) void {
            const mat_size = 3 * 4;
            assert(program != .invalid);
            assert(location != .invalid);
            assert(value.len % mat_size == 0);
            assert(value.len / mat_size == count);
            bindings.programUniformMatrix3x4dv(
                @intFromEnum(program),
                @intFromEnum(location),
                @bitCast(count),
                @intFromBool(transpose),
                @ptrCast(value.ptr),
            );
        }

        // pub var programUniformMatrix4x3dv: *const fn (
        //     program: Uint,
        //     location: Int,
        //     count: Sizei,
        //     transpose: Boolean,
        //     value: [*c]const Double,
        // ) callconv(.c) void = undefined;
        pub fn programUniformMatrix4x3dv(
            program: Program,
            location: UniformLocation,
            count: u32,
            transpose: bool,
            value: []const f64,
        ) void {
            const mat_size = 4 * 3;
            assert(program != .invalid);
            assert(location != .invalid);
            assert(value.len % mat_size == 0);
            assert(value.len / mat_size == count);
            bindings.programUniformMatrix4x3dv(
                @intFromEnum(program),
                @intFromEnum(location),
                @bitCast(count),
                @intFromBool(transpose),
                @ptrCast(value.ptr),
            );
        }

        // pub var validateProgramPipeline: *const fn (pipeline: Uint) callconv(.c) void = undefined;
        pub fn validateProgramPipeline(pipeline: ProgramPipeline) void {
            bindings.validateProgramPipeline(@intFromEnum(pipeline));
        }

        // pub var getProgramPipelineInfoLog: *const fn (
        //     pipeline: Uint,
        //     bufSize: Sizei,
        //     length: [*c]Sizei,
        //     infoLog: [*c]Char,
        // ) callconv(.c) void = undefined;
        pub fn getProgramPipelineInfoLog(
            pipeline: ProgramPipeline,
            info_log_buf: [:0]u8,
        ) [:0]const u8 {
            var length: i32 = undefined;
            bindings.getProgramPipelineInfoLog(
                @intFromEnum(pipeline),
                // includes null terminator
                @intCast(info_log_buf.len + 1),
                // excludes null terminator
                @ptrCast(&length),
                @ptrCast(info_log_buf.ptr),
            );
            return info_log_buf[0..@intCast(length) :0];
        }

        // pub var vertexAttribL1d: *const fn (index: Uint, x: Double) callconv(.c) void = undefined;
        pub fn vertexAttribL1d(location: VertexAttribLocation, x: f64) void {
            bindings.vertexAttribL1d(@intFromEnum(location), x);
        }

        // pub var vertexAttribL2d: *const fn (index: Uint, x: Double, y: Double) callconv(.c) void = undefined;
        pub fn vertexAttribL2d(location: VertexAttribLocation, x: f64, y: f64) void {
            bindings.vertexAttribL2d(@intFromEnum(location), x, y);
        }

        // pub var vertexAttribL3d: *const fn (
        //     index: Uint,
        //     x: Double,
        //     y: Double,
        //     z: Double,
        // ) callconv(.c) void = undefined;
        pub fn vertexAttribL3d(
            location: VertexAttribLocation,
            x: f64,
            y: f64,
            z: f64,
        ) void {
            bindings.vertexAttribL3d(
                @intFromEnum(location),
                x,
                y,
                z,
            );
        }

        // pub var vertexAttribL4d: *const fn (
        //     index: Uint,
        //     x: Double,
        //     y: Double,
        //     z: Double,
        //     w: Double,
        // ) callconv(.c) void = undefined;
        pub fn vertexAttribL4d(
            location: VertexAttribLocation,
            x: f64,
            y: f64,
            z: f64,
            w: f64,
        ) void {
            bindings.vertexAttribL4d(
                @intFromEnum(location),
                x,
                y,
                z,
                w,
            );
        }

        // pub var vertexAttribL1dv: *const fn (index: Uint, v: [*c]const Double) callconv(.c) void = undefined;
        pub fn vertexAttribL1dv(location: VertexAttribLocation, v: []const f64) void {
            bindings.vertexAttribL1dv(@intFromEnum(location), @ptrCast(v.ptr));
        }

        // pub var vertexAttribL2dv: *const fn (index: Uint, v: [*c]const Double) callconv(.c) void = undefined;
        pub fn vertexAttribL2dv(location: VertexAttribLocation, v: []const f64) void {
            bindings.vertexAttribL2dv(@intFromEnum(location), @ptrCast(v.ptr));
        }

        // pub var vertexAttribL3dv: *const fn (index: Uint, v: [*c]const Double) callconv(.c) void = undefined;
        pub fn vertexAttribL3dv(location: VertexAttribLocation, v: []const f64) void {
            bindings.vertexAttribL3dv(@intFromEnum(location), @ptrCast(v.ptr));
        }

        // pub var vertexAttribL4dv: *const fn (index: Uint, v: [*c]const Double) callconv(.c) void = undefined;
        pub fn vertexAttribL4dv(location: VertexAttribLocation, v: []const f64) void {
            bindings.vertexAttribL4dv(@intFromEnum(location), @ptrCast(v.ptr));
        }

        // pub var vertexAttribLPointer: *const fn (
        //     index: Uint,
        //     size: Int,
        //     type: Enum,
        //     stride: Sizei,
        //     pointer: ?*const anyopaque,
        // ) callconv(.c) void = undefined;
        pub fn vertexAttribLPointer(
            location: VertexAttribLocation,
            size: u32,
            attrib_type: VertexAttribDoubleType,
            stride: u32,
            offset: usize,
        ) void {
            bindings.vertexAttribLPointer(
                @intFromEnum(location),
                @bitCast(size),
                @intFromEnum(attrib_type),
                @bitCast(stride),
                @ptrFromInt(offset),
            );
        }

        // pub var getVertexAttribLdv: *const fn (
        //     index: Uint,
        //     pname: Enum,
        //     params: [*c]Double,
        // ) callconv(.c) void = undefined;
        pub fn getVertexAttribLdv(
            location: VertexAttribLocation,
            pname: VertexAttribDoubleParameter,
            params: []f64,
        ) void {
            bindings.getVertexAttribLdv(
                @intFromEnum(location),
                @intFromEnum(pname),
                @ptrCast(params.ptr),
            );
        }

        // pub var viewportArrayv: *const fn (
        //     first: Uint,
        //     count: Sizei,
        //     v: [*c]const Float,
        // ) callconv(.c) void = undefined;
        pub fn viewportArrayv(
            first: u32,
            count: i32,
            v: []const f32,
        ) void {
            bindings.viewportArrayv(
                @bitCast(first),
                @bitCast(count),
                @ptrCast(v.ptr),
            );
        }

        // pub var viewportIndexedf: *const fn (
        //     index: Uint,
        //     x: Float,
        //     y: Float,
        //     w: Float,
        //     h: Float,
        // ) callconv(.c) void = undefined;
        pub fn viewportIndexedf(
            index: u32,
            x: f32,
            y: f32,
            w: f32,
            h: f32,
        ) void {
            bindings.viewportIndexedf(
                @bitCast(index),
                x,
                y,
                w,
                h,
            );
        }

        // pub var viewportIndexedfv: *const fn (index: Uint, v: [*c]const Float) callconv(.c) void = undefined;
        pub fn viewportIndexedfv(index: u32, v: []const f32) void {
            bindings.viewportIndexedfv(@bitCast(index), @ptrCast(v.ptr));
        }

        // pub var scissorArrayv: *const fn (
        //     first: Uint,
        //     count: Sizei,
        //     v: [*c]const Int,
        // ) callconv(.c) void = undefined;
        pub fn scissorArrayv(
            first: u32,
            count: i32,
            v: []const i32,
        ) void {
            bindings.scissorArrayv(
                @bitCast(first),
                @bitCast(count),
                @ptrCast(v.ptr),
            );
        }

        // pub var scissorIndexed: *const fn (
        //     index: Uint,
        //     left: Int,
        //     bottom: Int,
        //     width: Sizei,
        //     height: Sizei,
        // ) callconv(.c) void = undefined;
        pub fn scissorIndexed(
            index: u32,
            left: i32,
            bottom: i32,
            width: i32,
            height: i32,
        ) void {
            bindings.scissorIndexed(
                @bitCast(index),
                @bitCast(left),
                @bitCast(bottom),
                @bitCast(width),
                @bitCast(height),
            );
        }

        // pub var scissorIndexedv: *const fn (index: Uint, v: [*c]const Int) callconv(.c) void = undefined;
        pub fn scissorIndexedv(index: u32, v: []const i32) void {
            bindings.scissorIndexedv(@bitCast(index), @ptrCast(v.ptr));
        }

        // pub var depthRangeArrayv: *const fn (
        //     first: Uint,
        //     count: Sizei,
        //     v: [*c]const Double,
        // ) callconv(.c) void = undefined;
        pub fn depthRangeArrayv(
            first: u32,
            count: i32,
            v: []const f64,
        ) void {
            bindings.depthRangeArrayv(
                @bitCast(first),
                @bitCast(count),
                @ptrCast(v.ptr),
            );
        }

        // pub var depthRangeIndexed: *const fn (
        //     index: Uint,
        //     n: Double,
        //     f: Double,
        // ) callconv(.c) void = undefined;
        pub fn depthRangeIndexed(index: u32, n: f64, f: f64) void {
            bindings.depthRangeIndexed(@bitCast(index), n, f);
        }

        // pub var getFloati_v: *const fn (
        //     target: Enum,
        //     index: Uint,
        //     data: [*c]Float,
        // ) callconv(.c) void = undefined;
        pub fn getFloati_v(
            target: IndexedFloatParameter,
            index: u32,
            data: []f32,
        ) void {
            bindings.getFloati_v(
                @intFromEnum(target),
                @bitCast(index),
                @ptrCast(data.ptr),
            );
        }

        // pub var getDoublei_v: *const fn (
        //     target: Enum,
        //     index: Uint,
        //     data: [*c]Double,
        // ) callconv(.c) void = undefined;
        pub fn getDoublei_v(
            target: IndexedDoubleParameter,
            index: u32,
            data: []f64,
        ) void {
            bindings.getDoublei_v(
                @intFromEnum(target),
                @bitCast(index),
                @ptrCast(data.ptr),
            );
        }

        //--------------------------------------------------------------------------------------------------
        //
        // OpenGL 4.2 (Core Profile)
        //
        //--------------------------------------------------------------------------------------------------
        pub const COPY_READ_BUFFER_BINDING = bindings.COPY_READ_BUFFER_BINDING;
        pub const COPY_WRITE_BUFFER_BINDING = bindings.COPY_WRITE_BUFFER_BINDING;
        pub const TRANSFORM_FEEDBACK_ACTIVE = bindings.TRANSFORM_FEEDBACK_ACTIVE;
        pub const TRANSFORM_FEEDBACK_PAUSED = bindings.TRANSFORM_FEEDBACK_PAUSED;
        pub const UNPACK_COMPRESSED_BLOCK_WIDTH = bindings.UNPACK_COMPRESSED_BLOCK_WIDTH;
        pub const UNPACK_COMPRESSED_BLOCK_HEIGHT = bindings.UNPACK_COMPRESSED_BLOCK_HEIGHT;
        pub const UNPACK_COMPRESSED_BLOCK_DEPTH = bindings.UNPACK_COMPRESSED_BLOCK_DEPTH;
        pub const UNPACK_COMPRESSED_BLOCK_SIZE = bindings.UNPACK_COMPRESSED_BLOCK_SIZE;
        pub const PACK_COMPRESSED_BLOCK_WIDTH = bindings.PACK_COMPRESSED_BLOCK_WIDTH;
        pub const PACK_COMPRESSED_BLOCK_HEIGHT = bindings.PACK_COMPRESSED_BLOCK_HEIGHT;
        pub const PACK_COMPRESSED_BLOCK_DEPTH = bindings.PACK_COMPRESSED_BLOCK_DEPTH;
        pub const PACK_COMPRESSED_BLOCK_SIZE = bindings.PACK_COMPRESSED_BLOCK_SIZE;
        pub const NUM_SAMPLE_COUNTS = bindings.NUM_SAMPLE_COUNTS;
        pub const MIN_MAP_BUFFER_ALIGNMENT = bindings.MIN_MAP_BUFFER_ALIGNMENT;
        pub const ATOMIC_COUNTER_BUFFER = bindings.ATOMIC_COUNTER_BUFFER;
        pub const ATOMIC_COUNTER_BUFFER_BINDING = bindings.ATOMIC_COUNTER_BUFFER_BINDING;
        pub const ATOMIC_COUNTER_BUFFER_START = bindings.ATOMIC_COUNTER_BUFFER_START;
        pub const ATOMIC_COUNTER_BUFFER_SIZE = bindings.ATOMIC_COUNTER_BUFFER_SIZE;
        pub const ATOMIC_COUNTER_BUFFER_DATA_SIZE = bindings.ATOMIC_COUNTER_BUFFER_DATA_SIZE;
        pub const ATOMIC_COUNTER_BUFFER_ACTIVE_ATOMIC_COUNTERS = bindings.ATOMIC_COUNTER_BUFFER_ACTIVE_ATOMIC_COUNTERS;
        pub const ATOMIC_COUNTER_BUFFER_ACTIVE_ATOMIC_COUNTER_INDICES = bindings.ATOMIC_COUNTER_BUFFER_ACTIVE_ATOMIC_COUNTER_INDICES;
        pub const ATOMIC_COUNTER_BUFFER_REFERENCED_BY_VERTEX_SHADER = bindings.ATOMIC_COUNTER_BUFFER_REFERENCED_BY_VERTEX_SHADER;
        pub const ATOMIC_COUNTER_BUFFER_REFERENCED_BY_TESS_CONTROL_SHADER = bindings.ATOMIC_COUNTER_BUFFER_REFERENCED_BY_TESS_CONTROL_SHADER;
        pub const ATOMIC_COUNTER_BUFFER_REFERENCED_BY_TESS_EVALUATION_SHADER = bindings.ATOMIC_COUNTER_BUFFER_REFERENCED_BY_TESS_EVALUATION_SHADER;
        pub const ATOMIC_COUNTER_BUFFER_REFERENCED_BY_GEOMETRY_SHADER = bindings.ATOMIC_COUNTER_BUFFER_REFERENCED_BY_GEOMETRY_SHADER;
        pub const ATOMIC_COUNTER_BUFFER_REFERENCED_BY_FRAGMENT_SHADER = bindings.ATOMIC_COUNTER_BUFFER_REFERENCED_BY_FRAGMENT_SHADER;
        pub const MAX_VERTEX_ATOMIC_COUNTER_BUFFERS = bindings.MAX_VERTEX_ATOMIC_COUNTER_BUFFERS;
        pub const MAX_TESS_CONTROL_ATOMIC_COUNTER_BUFFERS = bindings.MAX_TESS_CONTROL_ATOMIC_COUNTER_BUFFERS;
        pub const MAX_TESS_EVALUATION_ATOMIC_COUNTER_BUFFERS = bindings.MAX_TESS_EVALUATION_ATOMIC_COUNTER_BUFFERS;
        pub const MAX_GEOMETRY_ATOMIC_COUNTER_BUFFERS = bindings.MAX_GEOMETRY_ATOMIC_COUNTER_BUFFERS;
        pub const MAX_FRAGMENT_ATOMIC_COUNTER_BUFFERS = bindings.MAX_FRAGMENT_ATOMIC_COUNTER_BUFFERS;
        pub const MAX_COMBINED_ATOMIC_COUNTER_BUFFERS = bindings.MAX_COMBINED_ATOMIC_COUNTER_BUFFERS;
        pub const MAX_VERTEX_ATOMIC_COUNTERS = bindings.MAX_VERTEX_ATOMIC_COUNTERS;
        pub const MAX_TESS_CONTROL_ATOMIC_COUNTERS = bindings.MAX_TESS_CONTROL_ATOMIC_COUNTERS;
        pub const MAX_TESS_EVALUATION_ATOMIC_COUNTERS = bindings.MAX_TESS_EVALUATION_ATOMIC_COUNTERS;
        pub const MAX_GEOMETRY_ATOMIC_COUNTERS = bindings.MAX_GEOMETRY_ATOMIC_COUNTERS;
        pub const MAX_FRAGMENT_ATOMIC_COUNTERS = bindings.MAX_FRAGMENT_ATOMIC_COUNTERS;
        pub const MAX_COMBINED_ATOMIC_COUNTERS = bindings.MAX_COMBINED_ATOMIC_COUNTERS;
        pub const MAX_ATOMIC_COUNTER_BUFFER_SIZE = bindings.MAX_ATOMIC_COUNTER_BUFFER_SIZE;
        pub const MAX_ATOMIC_COUNTER_BUFFER_BINDINGS = bindings.MAX_ATOMIC_COUNTER_BUFFER_BINDINGS;
        pub const ACTIVE_ATOMIC_COUNTER_BUFFERS = bindings.ACTIVE_ATOMIC_COUNTER_BUFFERS;
        pub const UNIFORM_ATOMIC_COUNTER_BUFFER_INDEX = bindings.UNIFORM_ATOMIC_COUNTER_BUFFER_INDEX;
        pub const UNSIGNED_INT_ATOMIC_COUNTER = bindings.UNSIGNED_INT_ATOMIC_COUNTER;
        pub const VERTEX_ATTRIB_ARRAY_BARRIER_BIT = bindings.VERTEX_ATTRIB_ARRAY_BARRIER_BIT;
        pub const ELEMENT_ARRAY_BARRIER_BIT = bindings.ELEMENT_ARRAY_BARRIER_BIT;
        pub const UNIFORM_BARRIER_BIT = bindings.UNIFORM_BARRIER_BIT;
        pub const TEXTURE_FETCH_BARRIER_BIT = bindings.TEXTURE_FETCH_BARRIER_BIT;
        pub const SHADER_IMAGE_ACCESS_BARRIER_BIT = bindings.SHADER_IMAGE_ACCESS_BARRIER_BIT;
        pub const COMMAND_BARRIER_BIT = bindings.COMMAND_BARRIER_BIT;
        pub const PIXEL_BUFFER_BARRIER_BIT = bindings.PIXEL_BUFFER_BARRIER_BIT;
        pub const TEXTURE_UPDATE_BARRIER_BIT = bindings.TEXTURE_UPDATE_BARRIER_BIT;
        pub const BUFFER_UPDATE_BARRIER_BIT = bindings.BUFFER_UPDATE_BARRIER_BIT;
        pub const FRAMEBUFFER_BARRIER_BIT = bindings.FRAMEBUFFER_BARRIER_BIT;
        pub const TRANSFORM_FEEDBACK_BARRIER_BIT = bindings.TRANSFORM_FEEDBACK_BARRIER_BIT;
        pub const ATOMIC_COUNTER_BARRIER_BIT = bindings.ATOMIC_COUNTER_BARRIER_BIT;
        pub const ALL_BARRIER_BITS = bindings.ALL_BARRIER_BITS;
        pub const MAX_IMAGE_UNITS = bindings.MAX_IMAGE_UNITS;
        pub const MAX_COMBINED_IMAGE_UNITS_AND_FRAGMENT_OUTPUTS = bindings.MAX_COMBINED_IMAGE_UNITS_AND_FRAGMENT_OUTPUTS;
        pub const IMAGE_BINDING_NAME = bindings.IMAGE_BINDING_NAME;
        pub const IMAGE_BINDING_LEVEL = bindings.IMAGE_BINDING_LEVEL;
        pub const IMAGE_BINDING_LAYERED = bindings.IMAGE_BINDING_LAYERED;
        pub const IMAGE_BINDING_LAYER = bindings.IMAGE_BINDING_LAYER;
        pub const IMAGE_BINDING_ACCESS = bindings.IMAGE_BINDING_ACCESS;
        pub const IMAGE_1D = bindings.IMAGE_1D;
        pub const IMAGE_2D = bindings.IMAGE_2D;
        pub const IMAGE_3D = bindings.IMAGE_3D;
        pub const IMAGE_2D_RECT = bindings.IMAGE_2D_RECT;
        pub const IMAGE_CUBE = bindings.IMAGE_CUBE;
        pub const IMAGE_BUFFER = bindings.IMAGE_BUFFER;
        pub const IMAGE_1D_ARRAY = bindings.IMAGE_1D_ARRAY;
        pub const IMAGE_2D_ARRAY = bindings.IMAGE_2D_ARRAY;
        pub const IMAGE_CUBE_MAP_ARRAY = bindings.IMAGE_CUBE_MAP_ARRAY;
        pub const IMAGE_2D_MULTISAMPLE = bindings.IMAGE_2D_MULTISAMPLE;
        pub const IMAGE_2D_MULTISAMPLE_ARRAY = bindings.IMAGE_2D_MULTISAMPLE_ARRAY;
        pub const INT_IMAGE_1D = bindings.INT_IMAGE_1D;
        pub const INT_IMAGE_2D = bindings.INT_IMAGE_2D;
        pub const INT_IMAGE_3D = bindings.INT_IMAGE_3D;
        pub const INT_IMAGE_2D_RECT = bindings.INT_IMAGE_2D_RECT;
        pub const INT_IMAGE_CUBE = bindings.INT_IMAGE_CUBE;
        pub const INT_IMAGE_BUFFER = bindings.INT_IMAGE_BUFFER;
        pub const INT_IMAGE_1D_ARRAY = bindings.INT_IMAGE_1D_ARRAY;
        pub const INT_IMAGE_2D_ARRAY = bindings.INT_IMAGE_2D_ARRAY;
        pub const INT_IMAGE_CUBE_MAP_ARRAY = bindings.INT_IMAGE_CUBE_MAP_ARRAY;
        pub const INT_IMAGE_2D_MULTISAMPLE = bindings.INT_IMAGE_2D_MULTISAMPLE;
        pub const INT_IMAGE_2D_MULTISAMPLE_ARRAY = bindings.INT_IMAGE_2D_MULTISAMPLE_ARRAY;
        pub const UNSIGNED_INT_IMAGE_1D = bindings.UNSIGNED_INT_IMAGE_1D;
        pub const UNSIGNED_INT_IMAGE_2D = bindings.UNSIGNED_INT_IMAGE_2D;
        pub const UNSIGNED_INT_IMAGE_3D = bindings.UNSIGNED_INT_IMAGE_3D;
        pub const UNSIGNED_INT_IMAGE_2D_RECT = bindings.UNSIGNED_INT_IMAGE_2D_RECT;
        pub const UNSIGNED_INT_IMAGE_CUBE = bindings.UNSIGNED_INT_IMAGE_CUBE;
        pub const UNSIGNED_INT_IMAGE_BUFFER = bindings.UNSIGNED_INT_IMAGE_BUFFER;
        pub const UNSIGNED_INT_IMAGE_1D_ARRAY = bindings.UNSIGNED_INT_IMAGE_1D_ARRAY;
        pub const UNSIGNED_INT_IMAGE_2D_ARRAY = bindings.UNSIGNED_INT_IMAGE_2D_ARRAY;
        pub const UNSIGNED_INT_IMAGE_CUBE_MAP_ARRAY = bindings.UNSIGNED_INT_IMAGE_CUBE_MAP_ARRAY;
        pub const UNSIGNED_INT_IMAGE_2D_MULTISAMPLE = bindings.UNSIGNED_INT_IMAGE_2D_MULTISAMPLE;
        pub const UNSIGNED_INT_IMAGE_2D_MULTISAMPLE_ARRAY = bindings.UNSIGNED_INT_IMAGE_2D_MULTISAMPLE_ARRAY;
        pub const MAX_IMAGE_SAMPLES = bindings.MAX_IMAGE_SAMPLES;
        pub const IMAGE_BINDING_FORMAT = bindings.IMAGE_BINDING_FORMAT;
        pub const IMAGE_FORMAT_COMPATIBILITY_TYPE = bindings.IMAGE_FORMAT_COMPATIBILITY_TYPE;
        pub const IMAGE_FORMAT_COMPATIBILITY_BY_SIZE = bindings.IMAGE_FORMAT_COMPATIBILITY_BY_SIZE;
        pub const IMAGE_FORMAT_COMPATIBILITY_BY_CLASS = bindings.IMAGE_FORMAT_COMPATIBILITY_BY_CLASS;
        pub const MAX_VERTEX_IMAGE_UNIFORMS = bindings.MAX_VERTEX_IMAGE_UNIFORMS;
        pub const MAX_TESS_CONTROL_IMAGE_UNIFORMS = bindings.MAX_TESS_CONTROL_IMAGE_UNIFORMS;
        pub const MAX_TESS_EVALUATION_IMAGE_UNIFORMS = bindings.MAX_TESS_EVALUATION_IMAGE_UNIFORMS;
        pub const MAX_GEOMETRY_IMAGE_UNIFORMS = bindings.MAX_GEOMETRY_IMAGE_UNIFORMS;
        pub const MAX_FRAGMENT_IMAGE_UNIFORMS = bindings.MAX_FRAGMENT_IMAGE_UNIFORMS;
        pub const MAX_COMBINED_IMAGE_UNIFORMS = bindings.MAX_COMBINED_IMAGE_UNIFORMS;
        pub const COMPRESSED_RGBA_BPTC_UNORM = bindings.COMPRESSED_RGBA_BPTC_UNORM;
        pub const COMPRESSED_SRGB_ALPHA_BPTC_UNORM = bindings.COMPRESSED_SRGB_ALPHA_BPTC_UNORM;
        pub const COMPRESSED_RGB_BPTC_SIGNED_FLOAT = bindings.COMPRESSED_RGB_BPTC_SIGNED_FLOAT;
        pub const COMPRESSED_RGB_BPTC_UNSIGNED_FLOAT = bindings.COMPRESSED_RGB_BPTC_UNSIGNED_FLOAT;
        pub const TEXTURE_IMMUTABLE_FORMAT = bindings.TEXTURE_IMMUTABLE_FORMAT;

        // pub var drawArraysInstancedBaseInstance: *const fn (
        //     mode: Enum,
        //     first: Int,
        //     count: Sizei,
        //     instancecount: Sizei,
        //     baseinstance: Uint,
        // ) callconv(.c) void = undefined;
        pub fn drawArraysInstancedBaseInstance(
            mode: PrimitiveType,
            first: i32,
            count: i32,
            instancecount: i32,
            baseinstance: u32,
        ) void {
            bindings.drawArraysInstancedBaseInstance(
                @intFromEnum(mode),
                @bitCast(first),
                @bitCast(count),
                @bitCast(instancecount),
                @bitCast(baseinstance),
            );
        }

        // pub var drawElementsInstancedBaseInstance: *const fn (
        //     mode: Enum,
        //     count: Sizei,
        //     type: Enum,
        //     indices: ?*const anyopaque,
        //     instancecount: Sizei,
        //     baseinstance: Uint,
        // ) callconv(.c) void = undefined;
        pub fn drawElementsInstancedBaseInstance(
            mode: PrimitiveType,
            count: i32,
            index_type: DrawIndicesType,
            offset: usize, // offset into bound element array buffer
            instancecount: i32,
            baseinstance: u32,
        ) void {
            bindings.drawElementsInstancedBaseInstance(
                @intFromEnum(mode),
                @bitCast(count),
                @intFromEnum(index_type),
                @ptrFromInt(offset),
                @bitCast(instancecount),
                @bitCast(baseinstance),
            );
        }

        // pub var drawElementsInstancedBaseVertexBaseInstance: *const fn (
        //     mode: Enum,
        //     count: Sizei,
        //     type: Enum,
        //     indices: ?*const anyopaque,
        //     instancecount: Sizei,
        //     basevertex: Int,
        //     baseinstance: Uint,
        // ) callconv(.c) void = undefined;
        pub fn drawElementsInstancedBaseVertexBaseInstance(
            mode: PrimitiveType,
            count: i32,
            index_type: DrawIndicesType,
            offset: usize, // offset into bound element array buffer
            instancecount: i32,
            basevertex: i32,
            baseinstance: u32,
        ) void {
            bindings.drawElementsInstancedBaseVertexBaseInstance(
                @intFromEnum(mode),
                @bitCast(count),
                @intFromEnum(index_type),
                @ptrFromInt(offset),
                @bitCast(instancecount),
                @bitCast(basevertex),
                @bitCast(baseinstance),
            );
        }

        // pub var getInternalformativ: *const fn (
        //     target: Enum,
        //     internalformat: Enum,
        //     pname: Enum,
        //     count: Sizei,
        //     params: [*c]Int,
        // ) callconv(.c) void = undefined;
        pub fn getInternalformativ(
            target: InternalFormatTarget,
            internalformat: InternalFormatAny,
            pname: InternalFormatParameter,
            params: []i32,
        ) void {
            bindings.getInternalformativ(
                @intFromEnum(target),
                @intFromEnum(internalformat),
                @intFromEnum(pname),
                @intCast(params.len),
                @ptrCast(params.ptr),
            );
        }

        // pub var getActiveAtomicCounterBufferiv: *const fn (
        //     program: Uint,
        //     bufferIndex: Uint,
        //     pname: Enum,
        //     params: [*c]Int,
        // ) callconv(.c) void = undefined;
        pub fn getActiveAtomicCounterBufferiv(
            program: Program,
            bufferIndex: u32,
            pname: AtomicCounterBufferParameter,
            params: []i32,
        ) void {
            assert(program != .invalid);
            bindings.getActiveAtomicCounterBufferiv(
                @intFromEnum(program),
                @bitCast(bufferIndex),
                @intFromEnum(pname),
                @ptrCast(params.ptr),
            );
        }

        // pub var bindImageTexture: *const fn (
        //     unit: Uint,
        //     texture: Uint,
        //     level: Int,
        //     layered: Boolean,
        //     layer: Int,
        //     access: Enum,
        //     format: Enum,
        // ) callconv(.c) void = undefined;
        pub fn bindImageTexture(
            unit: u32,
            texture: Texture,
            level: i32,
            layered: bool,
            layer: i32,
            access: Access,
            format: ImageUnitFormat,
        ) void {
            bindings.bindImageTexture(
                @bitCast(unit),
                @intFromEnum(texture),
                @bitCast(level),
                @intFromBool(layered),
                @bitCast(layer),
                @intFromEnum(access),
                @intFromEnum(format),
            );
        }

        // pub var memoryBarrier: *const fn (
        //     barriers: Bitfield,
        // ) callconv(.c) void = undefined;
        pub fn memoryBarrier(barriers: UsedBarriers) void {
            bindings.memoryBarrier(@bitCast(barriers));
        }

        // pub var texStorage1D: *const fn (
        //     target: Enum,
        //     levels: Sizei,
        //     internalformat: Enum,
        //     width: Sizei,
        // ) callconv(.c) void = undefined;
        pub fn texStorage1D(
            target: TexImage1DTarget,
            levels: i32,
            internalformat: InternalFormat,
            width: i32,
        ) void {
            bindings.texStorage1D(
                @intFromEnum(target),
                @bitCast(levels),
                @intFromEnum(internalformat),
                @bitCast(width),
            );
        }

        // pub var texStorage2D: *const fn (
        //     target: Enum,
        //     levels: Sizei,
        //     internalformat: Enum,
        //     width: Sizei,
        //     height: Sizei,
        // ) callconv(.c) void = undefined;
        pub fn texStorage2D(
            target: TexImage2DTarget,
            levels: i32,
            internalformat: InternalFormat,
            width: i32,
            height: i32,
        ) void {
            bindings.texStorage2D(
                @intFromEnum(target),
                @bitCast(levels),
                @intFromEnum(internalformat),
                @bitCast(width),
                @bitCast(height),
            );
        }

        // pub var texStorage3D: *const fn (
        //     target: Enum,
        //     levels: Sizei,
        //     internalformat: Enum,
        //     width: Sizei,
        //     height: Sizei,
        //     depth: Sizei,
        // ) callconv(.c) void = undefined;
        pub fn texStorage3D(
            target: TexImage3DTarget,
            levels: i32,
            internalformat: InternalFormat,
            width: i32,
            height: i32,
            depth: i32,
        ) void {
            bindings.texStorage3D(
                @intFromEnum(target),
                @bitCast(levels),
                @intFromEnum(internalformat),
                @bitCast(width),
                @bitCast(height),
                @bitCast(depth),
            );
        }

        // pub var drawTransformFeedbackInstanced: *const fn (
        //     mode: Enum,
        //     id: Uint,
        //     instancecount: Sizei,
        // ) callconv(.c) void = undefined;
        pub fn drawTransformFeedbackInstanced(
            mode: PrimitiveType,
            transform_feedback: TransformFeedback,
            instancecount: i32,
        ) void {
            bindings.drawTransformFeedbackInstanced(
                @intFromEnum(mode),
                @intFromEnum(transform_feedback),
                @bitCast(instancecount),
            );
        }

        // pub var drawTransformFeedbackStreamInstanced: *const fn (
        //     mode: Enum,
        //     id: Uint,
        //     stream: Uint,
        //     instancecount: Sizei,
        // ) callconv(.c) void = undefined;
        pub fn drawTransformFeedbackStreamInstanced(
            mode: PrimitiveType,
            transform_feedback: TransformFeedback,
            stream: u32,
            instancecount: i32,
        ) void {
            bindings.drawTransformFeedbackStreamInstanced(
                @intFromEnum(mode),
                @intFromEnum(transform_feedback),
                @bitCast(stream),
                @bitCast(instancecount),
            );
        }

        //--------------------------------------------------------------------------------------------------
        //
        // OpenGL 4.3 (Core Profile)
        //
        //--------------------------------------------------------------------------------------------------
        pub const DEBUGPROC = fn (
            source: DebugSource,
            type: DebugType,
            id: u32,
            severity: DebugSeverity,
            length: i32,
            message: [*:0]const u8,
            userParam: ?*const anyopaque,
        ) callconv(.c) void;

        pub const NUM_SHADING_LANGUAGE_VERSIONS = bindings.NUM_SHADING_LANGUAGE_VERSIONS;
        pub const VERTEX_ATTRIB_ARRAY_LONG = bindings.VERTEX_ATTRIB_ARRAY_LONG;
        pub const COMPRESSED_RGB8_ETC2 = bindings.COMPRESSED_RGB8_ETC2;
        pub const COMPRESSED_SRGB8_ETC2 = bindings.COMPRESSED_SRGB8_ETC2;
        pub const COMPRESSED_RGB8_PUNCHTHROUGH_ALPHA1_ETC2 = bindings.COMPRESSED_RGB8_PUNCHTHROUGH_ALPHA1_ETC2;
        pub const COMPRESSED_SRGB8_PUNCHTHROUGH_ALPHA1_ETC2 = bindings.COMPRESSED_SRGB8_PUNCHTHROUGH_ALPHA1_ETC2;
        pub const COMPRESSED_RGBA8_ETC2_EAC = bindings.COMPRESSED_RGBA8_ETC2_EAC;
        pub const COMPRESSED_SRGB8_ALPHA8_ETC2_EAC = bindings.COMPRESSED_SRGB8_ALPHA8_ETC2_EAC;
        pub const COMPRESSED_R11_EAC = bindings.COMPRESSED_R11_EAC;
        pub const COMPRESSED_SIGNED_R11_EAC = bindings.COMPRESSED_SIGNED_R11_EAC;
        pub const COMPRESSED_RG11_EAC = bindings.COMPRESSED_RG11_EAC;
        pub const COMPRESSED_SIGNED_RG11_EAC = bindings.COMPRESSED_SIGNED_RG11_EAC;
        pub const PRIMITIVE_RESTART_FIXED_INDEX = bindings.PRIMITIVE_RESTART_FIXED_INDEX;
        pub const ANY_SAMPLES_PASSED_CONSERVATIVE = bindings.ANY_SAMPLES_PASSED_CONSERVATIVE;
        pub const MAX_ELEMENT_INDEX = bindings.MAX_ELEMENT_INDEX;
        pub const COMPUTE_SHADER = bindings.COMPUTE_SHADER;
        pub const MAX_COMPUTE_UNIFORM_BLOCKS = bindings.MAX_COMPUTE_UNIFORM_BLOCKS;
        pub const MAX_COMPUTE_TEXTURE_IMAGE_UNITS = bindings.MAX_COMPUTE_TEXTURE_IMAGE_UNITS;
        pub const MAX_COMPUTE_IMAGE_UNIFORMS = bindings.MAX_COMPUTE_IMAGE_UNIFORMS;
        pub const MAX_COMPUTE_SHARED_MEMORY_SIZE = bindings.MAX_COMPUTE_SHARED_MEMORY_SIZE;
        pub const MAX_COMPUTE_UNIFORM_COMPONENTS = bindings.MAX_COMPUTE_UNIFORM_COMPONENTS;
        pub const MAX_COMPUTE_ATOMIC_COUNTER_BUFFERS = bindings.MAX_COMPUTE_ATOMIC_COUNTER_BUFFERS;
        pub const MAX_COMPUTE_ATOMIC_COUNTERS = bindings.MAX_COMPUTE_ATOMIC_COUNTERS;
        pub const MAX_COMBINED_COMPUTE_UNIFORM_COMPONENTS = bindings.MAX_COMBINED_COMPUTE_UNIFORM_COMPONENTS;
        pub const MAX_COMPUTE_WORK_GROUP_INVOCATIONS = bindings.MAX_COMPUTE_WORK_GROUP_INVOCATIONS;
        pub const MAX_COMPUTE_WORK_GROUP_COUNT = bindings.MAX_COMPUTE_WORK_GROUP_COUNT;
        pub const MAX_COMPUTE_WORK_GROUP_SIZE = bindings.MAX_COMPUTE_WORK_GROUP_SIZE;
        pub const COMPUTE_WORK_GROUP_SIZE = bindings.COMPUTE_WORK_GROUP_SIZE;
        pub const UNIFORM_BLOCK_REFERENCED_BY_COMPUTE_SHADER = bindings.UNIFORM_BLOCK_REFERENCED_BY_COMPUTE_SHADER;
        pub const ATOMIC_COUNTER_BUFFER_REFERENCED_BY_COMPUTE_SHADER = bindings.ATOMIC_COUNTER_BUFFER_REFERENCED_BY_COMPUTE_SHADER;
        pub const DISPATCH_INDIRECT_BUFFER = bindings.DISPATCH_INDIRECT_BUFFER;
        pub const DISPATCH_INDIRECT_BUFFER_BINDING = bindings.DISPATCH_INDIRECT_BUFFER_BINDING;
        pub const COMPUTE_SHADER_BIT = bindings.COMPUTE_SHADER_BIT;
        pub const DEBUG_OUTPUT_SYNCHRONOUS = bindings.DEBUG_OUTPUT_SYNCHRONOUS;
        pub const DEBUG_NEXT_LOGGED_MESSAGE_LENGTH = bindings.DEBUG_NEXT_LOGGED_MESSAGE_LENGTH;
        pub const DEBUG_CALLBACK_FUNCTION = bindings.DEBUG_CALLBACK_FUNCTION;
        pub const DEBUG_CALLBACK_USER_PARAM = bindings.DEBUG_CALLBACK_USER_PARAM;
        pub const DEBUG_SOURCE_API = bindings.DEBUG_SOURCE_API;
        pub const DEBUG_SOURCE_WINDOW_SYSTEM = bindings.DEBUG_SOURCE_WINDOW_SYSTEM;
        pub const DEBUG_SOURCE_SHADER_COMPILER = bindings.DEBUG_SOURCE_SHADER_COMPILER;
        pub const DEBUG_SOURCE_THIRD_PARTY = bindings.DEBUG_SOURCE_THIRD_PARTY;
        pub const DEBUG_SOURCE_APPLICATION = bindings.DEBUG_SOURCE_APPLICATION;
        pub const DEBUG_SOURCE_OTHER = bindings.DEBUG_SOURCE_OTHER;
        pub const DEBUG_TYPE_ERROR = bindings.DEBUG_TYPE_ERROR;
        pub const DEBUG_TYPE_DEPRECATED_BEHAVIOR = bindings.DEBUG_TYPE_DEPRECATED_BEHAVIOR;
        pub const DEBUG_TYPE_UNDEFINED_BEHAVIOR = bindings.DEBUG_TYPE_UNDEFINED_BEHAVIOR;
        pub const DEBUG_TYPE_PORTABILITY = bindings.DEBUG_TYPE_PORTABILITY;
        pub const DEBUG_TYPE_PERFORMANCE = bindings.DEBUG_TYPE_PERFORMANCE;
        pub const DEBUG_TYPE_OTHER = bindings.DEBUG_TYPE_OTHER;
        pub const MAX_DEBUG_MESSAGE_LENGTH = bindings.MAX_DEBUG_MESSAGE_LENGTH;
        pub const MAX_DEBUG_LOGGED_MESSAGES = bindings.MAX_DEBUG_LOGGED_MESSAGES;
        pub const DEBUG_LOGGED_MESSAGES = bindings.DEBUG_LOGGED_MESSAGES;
        pub const DEBUG_SEVERITY_HIGH = bindings.DEBUG_SEVERITY_HIGH;
        pub const DEBUG_SEVERITY_MEDIUM = bindings.DEBUG_SEVERITY_MEDIUM;
        pub const DEBUG_SEVERITY_LOW = bindings.DEBUG_SEVERITY_LOW;
        pub const DEBUG_TYPE_MARKER = bindings.DEBUG_TYPE_MARKER;
        pub const DEBUG_TYPE_PUSH_GROUP = bindings.DEBUG_TYPE_PUSH_GROUP;
        pub const DEBUG_TYPE_POP_GROUP = bindings.DEBUG_TYPE_POP_GROUP;
        pub const DEBUG_SEVERITY_NOTIFICATION = bindings.DEBUG_SEVERITY_NOTIFICATION;
        pub const MAX_DEBUG_GROUP_STACK_DEPTH = bindings.MAX_DEBUG_GROUP_STACK_DEPTH;
        pub const DEBUG_GROUP_STACK_DEPTH = bindings.DEBUG_GROUP_STACK_DEPTH;
        pub const BUFFER = bindings.BUFFER;
        pub const SHADER = bindings.SHADER;
        pub const PROGRAM = bindings.PROGRAM;
        pub const QUERY = bindings.QUERY;
        pub const PROGRAM_PIPELINE = bindings.PROGRAM_PIPELINE;
        pub const SAMPLER = bindings.SAMPLER;
        pub const MAX_LABEL_LENGTH = bindings.MAX_LABEL_LENGTH;
        pub const DEBUG_OUTPUT = bindings.DEBUG_OUTPUT;
        pub const CONTEXT_FLAG_DEBUG_BIT = bindings.CONTEXT_FLAG_DEBUG_BIT;
        pub const MAX_UNIFORM_LOCATIONS = bindings.MAX_UNIFORM_LOCATIONS;
        pub const FRAMEBUFFER_DEFAULT_WIDTH = bindings.FRAMEBUFFER_DEFAULT_WIDTH;
        pub const FRAMEBUFFER_DEFAULT_HEIGHT = bindings.FRAMEBUFFER_DEFAULT_HEIGHT;
        pub const FRAMEBUFFER_DEFAULT_LAYERS = bindings.FRAMEBUFFER_DEFAULT_LAYERS;
        pub const FRAMEBUFFER_DEFAULT_SAMPLES = bindings.FRAMEBUFFER_DEFAULT_SAMPLES;
        pub const FRAMEBUFFER_DEFAULT_FIXED_SAMPLE_LOCATIONS = bindings.FRAMEBUFFER_DEFAULT_FIXED_SAMPLE_LOCATIONS;
        pub const MAX_FRAMEBUFFER_WIDTH = bindings.MAX_FRAMEBUFFER_WIDTH;
        pub const MAX_FRAMEBUFFER_HEIGHT = bindings.MAX_FRAMEBUFFER_HEIGHT;
        pub const MAX_FRAMEBUFFER_LAYERS = bindings.MAX_FRAMEBUFFER_LAYERS;
        pub const MAX_FRAMEBUFFER_SAMPLES = bindings.MAX_FRAMEBUFFER_SAMPLES;
        pub const INTERNALFORMAT_SUPPORTED = bindings.INTERNALFORMAT_SUPPORTED;
        pub const INTERNALFORMAT_PREFERRED = bindings.INTERNALFORMAT_PREFERRED;
        pub const INTERNALFORMAT_RED_SIZE = bindings.INTERNALFORMAT_RED_SIZE;
        pub const INTERNALFORMAT_GREEN_SIZE = bindings.INTERNALFORMAT_GREEN_SIZE;
        pub const INTERNALFORMAT_BLUE_SIZE = bindings.INTERNALFORMAT_BLUE_SIZE;
        pub const INTERNALFORMAT_ALPHA_SIZE = bindings.INTERNALFORMAT_ALPHA_SIZE;
        pub const INTERNALFORMAT_DEPTH_SIZE = bindings.INTERNALFORMAT_DEPTH_SIZE;
        pub const INTERNALFORMAT_STENCIL_SIZE = bindings.INTERNALFORMAT_STENCIL_SIZE;
        pub const INTERNALFORMAT_SHARED_SIZE = bindings.INTERNALFORMAT_SHARED_SIZE;
        pub const INTERNALFORMAT_RED_TYPE = bindings.INTERNALFORMAT_RED_TYPE;
        pub const INTERNALFORMAT_GREEN_TYPE = bindings.INTERNALFORMAT_GREEN_TYPE;
        pub const INTERNALFORMAT_BLUE_TYPE = bindings.INTERNALFORMAT_BLUE_TYPE;
        pub const INTERNALFORMAT_ALPHA_TYPE = bindings.INTERNALFORMAT_ALPHA_TYPE;
        pub const INTERNALFORMAT_DEPTH_TYPE = bindings.INTERNALFORMAT_DEPTH_TYPE;
        pub const INTERNALFORMAT_STENCIL_TYPE = bindings.INTERNALFORMAT_STENCIL_TYPE;
        pub const MAX_WIDTH = bindings.MAX_WIDTH;
        pub const MAX_HEIGHT = bindings.MAX_HEIGHT;
        pub const MAX_DEPTH = bindings.MAX_DEPTH;
        pub const MAX_LAYERS = bindings.MAX_LAYERS;
        pub const MAX_COMBINED_DIMENSIONS = bindings.MAX_COMBINED_DIMENSIONS;
        pub const COLOR_COMPONENTS = bindings.COLOR_COMPONENTS;
        pub const DEPTH_COMPONENTS = bindings.DEPTH_COMPONENTS;
        pub const STENCIL_COMPONENTS = bindings.STENCIL_COMPONENTS;
        pub const COLOR_RENDERABLE = bindings.COLOR_RENDERABLE;
        pub const DEPTH_RENDERABLE = bindings.DEPTH_RENDERABLE;
        pub const STENCIL_RENDERABLE = bindings.STENCIL_RENDERABLE;
        pub const FRAMEBUFFER_RENDERABLE = bindings.FRAMEBUFFER_RENDERABLE;
        pub const FRAMEBUFFER_RENDERABLE_LAYERED = bindings.FRAMEBUFFER_RENDERABLE_LAYERED;
        pub const FRAMEBUFFER_BLEND = bindings.FRAMEBUFFER_BLEND;
        pub const READ_PIXELS = bindings.READ_PIXELS;
        pub const READ_PIXELS_FORMAT = bindings.READ_PIXELS_FORMAT;
        pub const READ_PIXELS_TYPE = bindings.READ_PIXELS_TYPE;
        pub const TEXTURE_IMAGE_FORMAT = bindings.TEXTURE_IMAGE_FORMAT;
        pub const TEXTURE_IMAGE_TYPE = bindings.TEXTURE_IMAGE_TYPE;
        pub const GET_TEXTURE_IMAGE_FORMAT = bindings.GET_TEXTURE_IMAGE_FORMAT;
        pub const GET_TEXTURE_IMAGE_TYPE = bindings.GET_TEXTURE_IMAGE_TYPE;
        pub const MIPMAP = bindings.MIPMAP;
        pub const MANUAL_GENERATE_MIPMAP = bindings.MANUAL_GENERATE_MIPMAP;
        pub const AUTO_GENERATE_MIPMAP = bindings.AUTO_GENERATE_MIPMAP;
        pub const COLOR_ENCODING = bindings.COLOR_ENCODING;
        pub const SRGB_READ = bindings.SRGB_READ;
        pub const SRGB_WRITE = bindings.SRGB_WRITE;
        pub const FILTER = bindings.FILTER;
        pub const VERTEX_TEXTURE = bindings.VERTEX_TEXTURE;
        pub const TESS_CONTROL_TEXTURE = bindings.TESS_CONTROL_TEXTURE;
        pub const TESS_EVALUATION_TEXTURE = bindings.TESS_EVALUATION_TEXTURE;
        pub const GEOMETRY_TEXTURE = bindings.GEOMETRY_TEXTURE;
        pub const FRAGMENT_TEXTURE = bindings.FRAGMENT_TEXTURE;
        pub const COMPUTE_TEXTURE = bindings.COMPUTE_TEXTURE;
        pub const TEXTURE_SHADOW = bindings.TEXTURE_SHADOW;
        pub const TEXTURE_GATHER = bindings.TEXTURE_GATHER;
        pub const TEXTURE_GATHER_SHADOW = bindings.TEXTURE_GATHER_SHADOW;
        pub const SHADER_IMAGE_LOAD = bindings.SHADER_IMAGE_LOAD;
        pub const SHADER_IMAGE_STORE = bindings.SHADER_IMAGE_STORE;
        pub const SHADER_IMAGE_ATOMIC = bindings.SHADER_IMAGE_ATOMIC;
        pub const IMAGE_TEXEL_SIZE = bindings.IMAGE_TEXEL_SIZE;
        pub const IMAGE_COMPATIBILITY_CLASS = bindings.IMAGE_COMPATIBILITY_CLASS;
        pub const IMAGE_PIXEL_FORMAT = bindings.IMAGE_PIXEL_FORMAT;
        pub const IMAGE_PIXEL_TYPE = bindings.IMAGE_PIXEL_TYPE;
        pub const SIMULTANEOUS_TEXTURE_AND_DEPTH_TEST = bindings.SIMULTANEOUS_TEXTURE_AND_DEPTH_TEST;
        pub const SIMULTANEOUS_TEXTURE_AND_STENCIL_TEST = bindings.SIMULTANEOUS_TEXTURE_AND_STENCIL_TEST;
        pub const SIMULTANEOUS_TEXTURE_AND_DEPTH_WRITE = bindings.SIMULTANEOUS_TEXTURE_AND_DEPTH_WRITE;
        pub const SIMULTANEOUS_TEXTURE_AND_STENCIL_WRITE = bindings.SIMULTANEOUS_TEXTURE_AND_STENCIL_WRITE;
        pub const TEXTURE_COMPRESSED_BLOCK_WIDTH = bindings.TEXTURE_COMPRESSED_BLOCK_WIDTH;
        pub const TEXTURE_COMPRESSED_BLOCK_HEIGHT = bindings.TEXTURE_COMPRESSED_BLOCK_HEIGHT;
        pub const TEXTURE_COMPRESSED_BLOCK_SIZE = bindings.TEXTURE_COMPRESSED_BLOCK_SIZE;
        pub const CLEAR_BUFFER = bindings.CLEAR_BUFFER;
        pub const TEXTURE_VIEW = bindings.TEXTURE_VIEW;
        pub const VIEW_COMPATIBILITY_CLASS = bindings.VIEW_COMPATIBILITY_CLASS;
        pub const FULL_SUPPORT = bindings.FULL_SUPPORT;
        pub const CAVEAT_SUPPORT = bindings.CAVEAT_SUPPORT;
        pub const IMAGE_CLASS_4_X_32 = bindings.IMAGE_CLASS_4_X_32;
        pub const IMAGE_CLASS_2_X_32 = bindings.IMAGE_CLASS_2_X_32;
        pub const IMAGE_CLASS_1_X_32 = bindings.IMAGE_CLASS_1_X_32;
        pub const IMAGE_CLASS_4_X_16 = bindings.IMAGE_CLASS_4_X_16;
        pub const IMAGE_CLASS_2_X_16 = bindings.IMAGE_CLASS_2_X_16;
        pub const IMAGE_CLASS_1_X_16 = bindings.IMAGE_CLASS_1_X_16;
        pub const IMAGE_CLASS_4_X_8 = bindings.IMAGE_CLASS_4_X_8;
        pub const IMAGE_CLASS_2_X_8 = bindings.IMAGE_CLASS_2_X_8;
        pub const IMAGE_CLASS_1_X_8 = bindings.IMAGE_CLASS_1_X_8;
        pub const IMAGE_CLASS_11_11_10 = bindings.IMAGE_CLASS_11_11_10;
        pub const IMAGE_CLASS_10_10_10_2 = bindings.IMAGE_CLASS_10_10_10_2;
        pub const VIEW_CLASS_128_BITS = bindings.VIEW_CLASS_128_BITS;
        pub const VIEW_CLASS_96_BITS = bindings.VIEW_CLASS_96_BITS;
        pub const VIEW_CLASS_64_BITS = bindings.VIEW_CLASS_64_BITS;
        pub const VIEW_CLASS_48_BITS = bindings.VIEW_CLASS_48_BITS;
        pub const VIEW_CLASS_32_BITS = bindings.VIEW_CLASS_32_BITS;
        pub const VIEW_CLASS_24_BITS = bindings.VIEW_CLASS_24_BITS;
        pub const VIEW_CLASS_16_BITS = bindings.VIEW_CLASS_16_BITS;
        pub const VIEW_CLASS_8_BITS = bindings.VIEW_CLASS_8_BITS;
        pub const VIEW_CLASS_S3TC_DXT1_RGB = bindings.VIEW_CLASS_S3TC_DXT1_RGB;
        pub const VIEW_CLASS_S3TC_DXT1_RGBA = bindings.VIEW_CLASS_S3TC_DXT1_RGBA;
        pub const VIEW_CLASS_S3TC_DXT3_RGBA = bindings.VIEW_CLASS_S3TC_DXT3_RGBA;
        pub const VIEW_CLASS_S3TC_DXT5_RGBA = bindings.VIEW_CLASS_S3TC_DXT5_RGBA;
        pub const VIEW_CLASS_RGTC1_RED = bindings.VIEW_CLASS_RGTC1_RED;
        pub const VIEW_CLASS_RGTC2_RG = bindings.VIEW_CLASS_RGTC2_RG;
        pub const VIEW_CLASS_BPTC_UNORM = bindings.VIEW_CLASS_BPTC_UNORM;
        pub const VIEW_CLASS_BPTC_FLOAT = bindings.VIEW_CLASS_BPTC_FLOAT;
        pub const UNIFORM = bindings.UNIFORM;
        pub const UNIFORM_BLOCK = bindings.UNIFORM_BLOCK;
        pub const PROGRAM_INPUT = bindings.PROGRAM_INPUT;
        pub const PROGRAM_OUTPUT = bindings.PROGRAM_OUTPUT;
        pub const BUFFER_VARIABLE = bindings.BUFFER_VARIABLE;
        pub const SHADER_STORAGE_BLOCK = bindings.SHADER_STORAGE_BLOCK;
        pub const VERTEX_SUBROUTINE = bindings.VERTEX_SUBROUTINE;
        pub const TESS_CONTROL_SUBROUTINE = bindings.TESS_CONTROL_SUBROUTINE;
        pub const TESS_EVALUATION_SUBROUTINE = bindings.TESS_EVALUATION_SUBROUTINE;
        pub const GEOMETRY_SUBROUTINE = bindings.GEOMETRY_SUBROUTINE;
        pub const FRAGMENT_SUBROUTINE = bindings.FRAGMENT_SUBROUTINE;
        pub const COMPUTE_SUBROUTINE = bindings.COMPUTE_SUBROUTINE;
        pub const VERTEX_SUBROUTINE_UNIFORM = bindings.VERTEX_SUBROUTINE_UNIFORM;
        pub const TESS_CONTROL_SUBROUTINE_UNIFORM = bindings.TESS_CONTROL_SUBROUTINE_UNIFORM;
        pub const TESS_EVALUATION_SUBROUTINE_UNIFORM = bindings.TESS_EVALUATION_SUBROUTINE_UNIFORM;
        pub const GEOMETRY_SUBROUTINE_UNIFORM = bindings.GEOMETRY_SUBROUTINE_UNIFORM;
        pub const FRAGMENT_SUBROUTINE_UNIFORM = bindings.FRAGMENT_SUBROUTINE_UNIFORM;
        pub const COMPUTE_SUBROUTINE_UNIFORM = bindings.COMPUTE_SUBROUTINE_UNIFORM;
        pub const TRANSFORM_FEEDBACK_VARYING = bindings.TRANSFORM_FEEDBACK_VARYING;
        pub const ACTIVE_RESOURCES = bindings.ACTIVE_RESOURCES;
        pub const MAX_NAME_LENGTH = bindings.MAX_NAME_LENGTH;
        pub const MAX_NUM_ACTIVE_VARIABLES = bindings.MAX_NUM_ACTIVE_VARIABLES;
        pub const MAX_NUM_COMPATIBLE_SUBROUTINES = bindings.MAX_NUM_COMPATIBLE_SUBROUTINES;
        pub const NAME_LENGTH = bindings.NAME_LENGTH;
        pub const TYPE = bindings.TYPE;
        pub const ARRAY_SIZE = bindings.ARRAY_SIZE;
        pub const OFFSET = bindings.OFFSET;
        pub const BLOCK_INDEX = bindings.BLOCK_INDEX;
        pub const ARRAY_STRIDE = bindings.ARRAY_STRIDE;
        pub const MATRIX_STRIDE = bindings.MATRIX_STRIDE;
        pub const IS_ROW_MAJOR = bindings.IS_ROW_MAJOR;
        pub const ATOMIC_COUNTER_BUFFER_INDEX = bindings.ATOMIC_COUNTER_BUFFER_INDEX;
        pub const BUFFER_BINDING = bindings.BUFFER_BINDING;
        pub const BUFFER_DATA_SIZE = bindings.BUFFER_DATA_SIZE;
        pub const NUM_ACTIVE_VARIABLES = bindings.NUM_ACTIVE_VARIABLES;
        pub const ACTIVE_VARIABLES = bindings.ACTIVE_VARIABLES;
        pub const REFERENCED_BY_VERTEX_SHADER = bindings.REFERENCED_BY_VERTEX_SHADER;
        pub const REFERENCED_BY_TESS_CONTROL_SHADER = bindings.REFERENCED_BY_TESS_CONTROL_SHADER;
        pub const REFERENCED_BY_TESS_EVALUATION_SHADER = bindings.REFERENCED_BY_TESS_EVALUATION_SHADER;
        pub const REFERENCED_BY_GEOMETRY_SHADER = bindings.REFERENCED_BY_GEOMETRY_SHADER;
        pub const REFERENCED_BY_FRAGMENT_SHADER = bindings.REFERENCED_BY_FRAGMENT_SHADER;
        pub const REFERENCED_BY_COMPUTE_SHADER = bindings.REFERENCED_BY_COMPUTE_SHADER;
        pub const TOP_LEVEL_ARRAY_SIZE = bindings.TOP_LEVEL_ARRAY_SIZE;
        pub const TOP_LEVEL_ARRAY_STRIDE = bindings.TOP_LEVEL_ARRAY_STRIDE;
        pub const LOCATION = bindings.LOCATION;
        pub const LOCATION_INDEX = bindings.LOCATION_INDEX;
        pub const IS_PER_PATCH = bindings.IS_PER_PATCH;
        pub const SHADER_STORAGE_BUFFER = bindings.SHADER_STORAGE_BUFFER;
        pub const SHADER_STORAGE_BUFFER_BINDING = bindings.SHADER_STORAGE_BUFFER_BINDING;
        pub const SHADER_STORAGE_BUFFER_START = bindings.SHADER_STORAGE_BUFFER_START;
        pub const SHADER_STORAGE_BUFFER_SIZE = bindings.SHADER_STORAGE_BUFFER_SIZE;
        pub const MAX_VERTEX_SHADER_STORAGE_BLOCKS = bindings.MAX_VERTEX_SHADER_STORAGE_BLOCKS;
        pub const MAX_GEOMETRY_SHADER_STORAGE_BLOCKS = bindings.MAX_GEOMETRY_SHADER_STORAGE_BLOCKS;
        pub const MAX_TESS_CONTROL_SHADER_STORAGE_BLOCKS = bindings.MAX_TESS_CONTROL_SHADER_STORAGE_BLOCKS;
        pub const MAX_TESS_EVALUATION_SHADER_STORAGE_BLOCKS = bindings.MAX_TESS_EVALUATION_SHADER_STORAGE_BLOCKS;
        pub const MAX_FRAGMENT_SHADER_STORAGE_BLOCKS = bindings.MAX_FRAGMENT_SHADER_STORAGE_BLOCKS;
        pub const MAX_COMPUTE_SHADER_STORAGE_BLOCKS = bindings.MAX_COMPUTE_SHADER_STORAGE_BLOCKS;
        pub const MAX_COMBINED_SHADER_STORAGE_BLOCKS = bindings.MAX_COMBINED_SHADER_STORAGE_BLOCKS;
        pub const MAX_SHADER_STORAGE_BUFFER_BINDINGS = bindings.MAX_SHADER_STORAGE_BUFFER_BINDINGS;
        pub const MAX_SHADER_STORAGE_BLOCK_SIZE = bindings.MAX_SHADER_STORAGE_BLOCK_SIZE;
        pub const SHADER_STORAGE_BUFFER_OFFSET_ALIGNMENT = bindings.SHADER_STORAGE_BUFFER_OFFSET_ALIGNMENT;
        pub const SHADER_STORAGE_BARRIER_BIT = bindings.SHADER_STORAGE_BARRIER_BIT;
        pub const MAX_COMBINED_SHADER_OUTPUT_RESOURCES = bindings.MAX_COMBINED_SHADER_OUTPUT_RESOURCES;
        pub const DEPTH_STENCIL_TEXTURE_MODE = bindings.DEPTH_STENCIL_TEXTURE_MODE;
        pub const TEXTURE_BUFFER_OFFSET = bindings.TEXTURE_BUFFER_OFFSET;
        pub const TEXTURE_BUFFER_SIZE = bindings.TEXTURE_BUFFER_SIZE;
        pub const TEXTURE_BUFFER_OFFSET_ALIGNMENT = bindings.TEXTURE_BUFFER_OFFSET_ALIGNMENT;
        pub const TEXTURE_VIEW_MIN_LEVEL = bindings.TEXTURE_VIEW_MIN_LEVEL;
        pub const TEXTURE_VIEW_NUM_LEVELS = bindings.TEXTURE_VIEW_NUM_LEVELS;
        pub const TEXTURE_VIEW_MIN_LAYER = bindings.TEXTURE_VIEW_MIN_LAYER;
        pub const TEXTURE_VIEW_NUM_LAYERS = bindings.TEXTURE_VIEW_NUM_LAYERS;
        pub const TEXTURE_IMMUTABLE_LEVELS = bindings.TEXTURE_IMMUTABLE_LEVELS;
        pub const VERTEX_ATTRIB_BINDING = bindings.VERTEX_ATTRIB_BINDING;
        pub const VERTEX_ATTRIB_RELATIVE_OFFSET = bindings.VERTEX_ATTRIB_RELATIVE_OFFSET;
        pub const VERTEX_BINDING_DIVISOR = bindings.VERTEX_BINDING_DIVISOR;
        pub const VERTEX_BINDING_OFFSET = bindings.VERTEX_BINDING_OFFSET;
        pub const VERTEX_BINDING_STRIDE = bindings.VERTEX_BINDING_STRIDE;
        pub const MAX_VERTEX_ATTRIB_RELATIVE_OFFSET = bindings.MAX_VERTEX_ATTRIB_RELATIVE_OFFSET;
        pub const MAX_VERTEX_ATTRIB_BINDINGS = bindings.MAX_VERTEX_ATTRIB_BINDINGS;
        pub const VERTEX_BINDING_BUFFER = bindings.VERTEX_BINDING_BUFFER;

        // pub var clearBufferData: *const fn (
        //     target: Enum,
        //     internalformat: Enum,
        //     format: Enum,
        //     type: Enum,
        //     data: ?*const anyopaque,
        // ) callconv(.c) void = undefined;
        pub fn clearBufferData(
            target: BufferTarget,
            internalformat: TextureInternalFormat,
            format: PixelFormat,
            pixel_type: PixelType,
            data: ?[]const u8, // passing null will fill the buffer with zeros
        ) void {
            bindings.clearBufferData(
                @intFromEnum(target),
                @intFromEnum(internalformat),
                @intFromEnum(format),
                @intFromEnum(pixel_type),
                if (data) |d| @ptrCast(d.ptr) else null,
            );
        }

        // pub var clearBufferSubData: *const fn (
        //     target: Enum,
        //     internalformat: Enum,
        //     offset: Intptr,
        //     size: Sizeiptr,
        //     format: Enum,
        //     type: Enum,
        //     data: ?*const anyopaque,
        // ) callconv(.c) void = undefined;
        pub fn clearBufferSubData(
            target: BufferTarget,
            internalformat: TextureInternalFormat,
            offset: usize,
            size: usize,
            format: PixelFormat,
            pixel_type: PixelType,
            data: ?[]const u8, // passing null will fill the buffer region with zeros
        ) void {
            bindings.clearBufferSubData(
                @intFromEnum(target),
                @intFromEnum(internalformat),
                @bitCast(offset),
                @bitCast(size),
                @intFromEnum(format),
                @intFromEnum(pixel_type),
                if (data) |d| d.ptr else null,
            );
        }

        // pub var dispatchCompute: *const fn (
        //     num_groups_x: Uint,
        //     num_groups_y: Uint,
        //     num_groups_z: Uint,
        // ) callconv(.c) void = undefined;
        pub fn dispatchCompute(
            num_groups_x: u32,
            num_groups_y: u32,
            num_groups_z: u32,
        ) void {
            bindings.dispatchCompute(
                @bitCast(num_groups_x),
                @bitCast(num_groups_y),
                @bitCast(num_groups_z),
            );
        }

        // pub var dispatchComputeIndirect: *const fn (
        //     indirect: Intptr,
        // ) callconv(.c) void = undefined;
        pub fn dispatchComputeIndirect(indirect: usize) void {
            bindings.dispatchComputeIndirect(@bitCast(indirect));
        }

        // pub var copyImageSubData: *const fn (
        //     srcName: Uint,
        //     srcTarget: Enum,
        //     srcLevel: Int,
        //     srcX: Int,
        //     srcY: Int,
        //     srcZ: Int,
        //     dstName: Uint,
        //     dstTarget: Enum,
        //     dstLevel: Int,
        //     dstX: Int,
        //     dstY: Int,
        //     dstZ: Int,
        //     srcWidth: Sizei,
        //     srcHeight: Sizei,
        //     srcDepth: Sizei,
        // ) callconv(.c) void = undefined;
        // function 'copyImageSubData' is split into four variants,
        // because '*Name' parameters can either name a texture or
        // a rednderbuffer, and this way we handle all combinations,
        // also TEXTURE_BUFFER is not allowed as a texture target,
        // that's why TextureTarget is not used
        pub fn copyImageSubDataTexture(
            srcName: Texture,
            srcTarget: CopyImageTextureTarget,
            srcLevel: i32,
            srcX: i32,
            srcY: i32,
            srcZ: i32,
            dstName: Texture,
            dstTarget: CopyImageTextureTarget,
            dstLevel: i32,
            dstX: i32,
            dstY: i32,
            dstZ: i32,
            srcWidth: i32,
            srcHeight: i32,
            srcDepth: i32,
        ) void {
            bindings.copyImageSubData(
                @intFromEnum(srcName),
                @intFromEnum(srcTarget),
                @bitCast(srcLevel),
                @bitCast(srcX),
                @bitCast(srcY),
                @bitCast(srcZ),
                @intFromEnum(dstName),
                @intFromEnum(dstTarget),
                @bitCast(dstLevel),
                @bitCast(dstX),
                @bitCast(dstY),
                @bitCast(dstZ),
                @bitCast(srcWidth),
                @bitCast(srcHeight),
                @bitCast(srcDepth),
            );
        }
        pub fn copyImageSubDataRenderbuffer(
            srcName: Renderbuffer,
            srcTarget: RenderbufferTarget,
            srcLevel: i32,
            srcX: i32,
            srcY: i32,
            srcZ: i32,
            dstName: Renderbuffer,
            dstTarget: RenderbufferTarget,
            dstLevel: i32,
            dstX: i32,
            dstY: i32,
            dstZ: i32,
            srcWidth: i32,
            srcHeight: i32,
            srcDepth: i32,
        ) void {
            bindings.copyImageSubData(
                @intFromEnum(srcName),
                @intFromEnum(srcTarget),
                @bitCast(srcLevel),
                @bitCast(srcX),
                @bitCast(srcY),
                @bitCast(srcZ),
                @intFromEnum(dstName),
                @intFromEnum(dstTarget),
                @bitCast(dstLevel),
                @bitCast(dstX),
                @bitCast(dstY),
                @bitCast(dstZ),
                @bitCast(srcWidth),
                @bitCast(srcHeight),
                @bitCast(srcDepth),
            );
        }
        pub fn copyImageSubDataTextureToRenderbuffer(
            srcName: Texture,
            srcTarget: CopyImageTextureTarget,
            srcLevel: i32,
            srcX: i32,
            srcY: i32,
            srcZ: i32,
            dstName: Renderbuffer,
            dstTarget: CopyImageTextureTarget,
            dstLevel: i32,
            dstX: i32,
            dstY: i32,
            dstZ: i32,
            srcWidth: i32,
            srcHeight: i32,
            srcDepth: i32,
        ) void {
            bindings.copyImageSubData(
                @intFromEnum(srcName),
                @intFromEnum(srcTarget),
                @bitCast(srcLevel),
                @bitCast(srcX),
                @bitCast(srcY),
                @bitCast(srcZ),
                @intFromEnum(dstName),
                @intFromEnum(dstTarget),
                @bitCast(dstLevel),
                @bitCast(dstX),
                @bitCast(dstY),
                @bitCast(dstZ),
                @bitCast(srcWidth),
                @bitCast(srcHeight),
                @bitCast(srcDepth),
            );
        }
        pub fn copyImageSubDataRenderbufferToTexture(
            srcName: Renderbuffer,
            srcTarget: RenderbufferTarget,
            srcLevel: i32,
            srcX: i32,
            srcY: i32,
            srcZ: i32,
            dstName: Texture,
            dstTarget: CopyImageTextureTarget,
            dstLevel: i32,
            dstX: i32,
            dstY: i32,
            dstZ: i32,
            srcWidth: i32,
            srcHeight: i32,
            srcDepth: i32,
        ) void {
            bindings.copyImageSubData(
                @intFromEnum(srcName),
                @intFromEnum(srcTarget),
                @bitCast(srcLevel),
                @bitCast(srcX),
                @bitCast(srcY),
                @bitCast(srcZ),
                @intFromEnum(dstName),
                @intFromEnum(dstTarget),
                @bitCast(dstLevel),
                @bitCast(dstX),
                @bitCast(dstY),
                @bitCast(dstZ),
                @bitCast(srcWidth),
                @bitCast(srcHeight),
                @bitCast(srcDepth),
            );
        }

        // pub var framebufferParameteri: *const fn (
        //     target: Enum,
        //     pname: Enum,
        //     param: Int,
        // ) callconv(.c) void = undefined;
        pub fn framebufferParameteri(
            target: FramebufferTarget,
            pname: FramebufferParameter,
            param: i32,
        ) void {
            bindings.framebufferParameteri(
                @intFromEnum(target),
                @intFromEnum(pname),
                @bitCast(param),
            );
        }

        // pub var getFramebufferParameteriv: *const fn (
        //     target: Enum,
        //     pname: Enum,
        //     params: [*c]Int,
        // ) callconv(.c) void = undefined;
        pub fn getFramebufferParameteriv(
            target: FramebufferTarget,
            pname: GetFramebufferParameter,
            params: []i32,
        ) void {
            bindings.getFramebufferParameteriv(
                @intFromEnum(target),
                @intFromEnum(pname),
                @ptrCast(params.ptr),
            );
        }

        // pub var getInternalformati64v: *const fn (
        //     target: Enum,
        //     internalformat: Enum,
        //     pname: Enum,
        //     count: Sizei,
        //     params: [*c]Int64,
        // ) callconv(.c) void = undefined;
        pub fn getInternalformati64v(
            target: InternalFormatTarget,
            internalformat: InternalFormatAny,
            pname: InternalFormatParameter,
            params: []i64,
        ) void {
            bindings.getInternalformati64v(
                @intFromEnum(target),
                @intFromEnum(internalformat),
                @intFromEnum(pname),
                @intCast(params.len),
                @ptrCast(params.ptr),
            );
        }

        // pub var invalidateTexSubImage: *const fn (
        //     texture: Uint,
        //     level: Int,
        //     xoffset: Int,
        //     yoffset: Int,
        //     zoffset: Int,
        //     width: Sizei,
        //     height: Sizei,
        //     depth: Sizei,
        // ) callconv(.c) void = undefined;
        pub fn invalidateTexSubImage(
            texture: Texture,
            level: i32,
            xoffset: i32,
            yoffset: i32,
            zoffset: i32,
            width: i32,
            height: i32,
            depth: i32,
        ) void {
            bindings.invalidateTexSubImage(
                @intFromEnum(texture),
                @bitCast(level),
                @bitCast(xoffset),
                @bitCast(yoffset),
                @bitCast(zoffset),
                @bitCast(width),
                @bitCast(height),
                @bitCast(depth),
            );
        }

        // pub var invalidateTexImage: *const fn (
        //     texture: Uint,
        //     level: Int,
        // ) callconv(.c) void = undefined;
        pub fn invalidateTexImage(
            texture: Texture,
            level: i32,
        ) void {
            bindings.invalidateTexImage(
                @intFromEnum(texture),
                @bitCast(level),
            );
        }

        // pub var invalidateBufferSubData: *const fn (
        //     buffer: Uint,
        //     offset: Intptr,
        //     length: Sizeiptr,
        // ) callconv(.c) void = undefined;
        pub fn invalidateBufferSubData(
            buffer: Buffer,
            offset: usize,
            length: usize,
        ) void {
            bindings.invalidateBufferSubData(
                @intFromEnum(buffer),
                @bitCast(offset),
                @bitCast(length),
            );
        }

        // pub var invalidateBufferData: *const fn (
        //     buffer: Uint,
        // ) callconv(.c) void = undefined;
        pub fn invalidateBufferData(buffer: Buffer) void {
            bindings.invalidateBufferData(@intFromEnum(buffer));
        }

        // pub var invalidateFramebuffer: *const fn (
        //     target: Enum,
        //     numAttachments: Sizei,
        //     attachments: [*c]const Enum,
        // ) callconv(.c) void = undefined;
        pub fn invalidateFramebuffer(
            target: FramebufferTarget,
            attachments: []FramebufferAttachmentDefault,
        ) void {
            bindings.invalidateFramebuffer(
                @intFromEnum(target),
                @intCast(attachments.len),
                @ptrCast(attachments.ptr),
            );
        }

        // pub var invalidateSubFramebuffer: *const fn (
        //     target: Enum,
        //     numAttachments: Sizei,
        //     attachments: [*c]const Enum,
        //     x: Int,
        //     y: Int,
        //     width: Sizei,
        //     height: Sizei,
        // ) callconv(.c) void = undefined;
        pub fn invalidateSubFramebuffer(
            target: FramebufferTarget,
            attachments: []FramebufferAttachmentDefault,
            x: i32,
            y: i32,
            width: i32,
            height: i32,
        ) void {
            bindings.invalidateSubFramebuffer(
                @intFromEnum(target),
                @intCast(attachments.len),
                @ptrCast(attachments.ptr),
                @bitCast(x),
                @bitCast(y),
                @bitCast(width),
                @bitCast(height),
            );
        }

        // pub var multiDrawArraysIndirect: *const fn (
        //     mode: Enum,
        //     indirect: ?*const anyopaque,
        //     drawcount: Sizei,
        //     stride: Sizei,
        // ) callconv(.c) void = undefined;
        pub fn multiDrawArraysIndirect(
            mode: PrimitiveType,
            offset: usize, // offset of first DrawArraysIndirectCommand in bound DRAW_INDIRECT buffer
            drawcount: i32,
            stride: i32,
        ) void {
            bindings.multiDrawArraysIndirect(
                @intFromEnum(mode),
                @ptrFromInt(offset),
                @bitCast(drawcount),
                @bitCast(stride),
            );
        }

        // pub var multiDrawElementsIndirect: *const fn (
        //     mode: Enum,
        //     type: Enum,
        //     indirect: ?*const anyopaque,
        //     drawcount: Sizei,
        //     stride: Sizei,
        // ) callconv(.c) void = undefined;
        pub fn multiDrawElementsIndirect(
            mode: PrimitiveType,
            index_type: DrawIndicesType,
            offset: usize, // offset of first DrawElementsIndirectCommand in bound DRAW_INDIRECT buffer
            drawcount: i32,
            stride: i32,
        ) void {
            bindings.multiDrawElementsIndirect(
                @intFromEnum(mode),
                @intFromEnum(index_type),
                @ptrFromInt(offset),
                @bitCast(drawcount),
                @bitCast(stride),
            );
        }

        // pub var getProgramInterfaceiv: *const fn (
        //     program: Uint,
        //     programInterface: Enum,
        //     pname: Enum,
        //     params: [*c]Int,
        // ) callconv(.c) void = undefined;
        pub fn getProgramInterfaceiv(
            program: Program,
            programInterface: ProgramInterface,
            pname: ProgramInterfaceParameter,
            params: []i32,
        ) void {
            assert(program != .invalid);
            bindings.getProgramInterfaceiv(
                @intFromEnum(program),
                @intFromEnum(programInterface),
                @intFromEnum(pname),
                @ptrCast(params.ptr),
            );
        }

        // pub var getProgramResourceIndex: *const fn (
        //     program: Uint,
        //     programInterface: Enum,
        //     name: [*c]const Char,
        // ) callconv(.c) Uint = undefined;
        pub fn getProgramResourceIndex(
            program: Program,
            programInterface: ProgramInterfaceWithName,
            name: [:0]const u8,
        ) u32 {
            assert(program != .invalid);
            return @bitCast(bindings.getProgramResourceIndex(
                @intFromEnum(program),
                @intFromEnum(programInterface),
                @ptrCast(name.ptr),
            ));
        }

        // pub var getProgramResourceName: *const fn (
        //     program: Uint,
        //     programInterface: Enum,
        //     index: Uint,
        //     bufSize: Sizei,
        //     length: [*c]Sizei,
        //     name: [*c]Char,
        // ) callconv(.c) void = undefined;
        pub fn getProgramResourceName(
            program: Program,
            programInterface: ProgramInterfaceWithName,
            index: u32,
            name_buf: [:0]u8,
        ) [:0]const u8 {
            assert(program != .invalid);
            var length: i32 = undefined;
            bindings.getProgramResourceName(
                @intFromEnum(program),
                @intFromEnum(programInterface),
                @bitCast(index),
                // includes null terminator
                @intCast(name_buf.len + 1),
                // excludes null terminator
                @ptrCast(&length),
                @ptrCast(name_buf.ptr),
            );
            return name_buf[0..@intCast(length) :0];
        }

        // pub var getProgramResourceiv: *const fn (
        //     program: Uint,
        //     programInterface: Enum,
        //     index: Uint,
        //     propCount: Sizei,
        //     props: [*c]const Enum,
        //     count: Sizei,
        //     length: [*c]Sizei,
        //     params: [*c]Int,
        // ) callconv(.c) void = undefined;
        pub fn getProgramResourceiv(
            program: Program,
            programInterface: ProgramInterface,
            index: u32,
            props: []const ProgramResource,
            params_buf: []i32,
        ) []const i32 {
            assert(program != .invalid);
            var length: i32 = undefined;
            bindings.getProgramResourceiv(
                @intFromEnum(program),
                @intFromEnum(programInterface),
                @bitCast(index),
                @intCast(props.len),
                @ptrCast(props.ptr),
                @intCast(params_buf.len),
                @ptrCast(&length),
                @ptrCast(params_buf.ptr),
            );
            return params_buf[0..@intCast(length)];
        }

        // pub var getProgramResourceLocation: *const fn (
        //     program: Uint,
        //     programInterface: Enum,
        //     name: [*c]const Char,
        // ) callconv(.c) Int = undefined;
        pub fn getProgramResourceLocation(
            program: Program,
            programInterface: ProgramInterfaceWithLocation,
            name: [:0]const u8,
        ) i32 {
            assert(program != .invalid);
            return @bitCast(bindings.getProgramResourceLocation(
                @intFromEnum(program),
                @intFromEnum(programInterface),
                @ptrCast(name.ptr),
            ));
        }

        // pub var getProgramResourceLocationIndex: *const fn (
        //     program: Uint,
        //     programInterface: Enum,
        //     name: [*c]const Char,
        // ) callconv(.c) Int = undefined;
        pub fn getProgramResourceLocationIndex(
            program: Program,
            programInterface: ProgramInterfaceWithLocationIndex,
            name: [:0]const u8,
        ) i32 {
            assert(program != .invalid);
            return @bitCast(bindings.getProgramResourceLocationIndex(
                @intFromEnum(program),
                @intFromEnum(programInterface),
                @ptrCast(name.ptr),
            ));
        }

        // pub var shaderStorageBlockBinding: *const fn (
        //     program: Uint,
        //     storageBlockIndex: Uint,
        //     storageBlockBinding: Uint,
        // ) callconv(.c) void = undefined;
        pub fn shaderStorageBlockBinding(
            program: Program,
            storageBlockIndex: u32,
            storageBlockBinding: u32,
        ) void {
            assert(program != .invalid);
            bindings.shaderStorageBlockBinding(
                @intFromEnum(program),
                @bitCast(storageBlockIndex),
                @bitCast(storageBlockBinding),
            );
        }

        // pub var texBufferRange: *const fn (
        //     target: Enum,
        //     internalformat: Enum,
        //     buffer: Uint,
        //     offset: Intptr,
        //     size: Sizeiptr,
        // ) callconv(.c) void = undefined;
        pub fn texBufferRange(
            target: TexBufferTarget,
            internalformat: TextureInternalFormat,
            buffer: Buffer,
            offset: usize,
            size: usize,
        ) void {
            bindings.texBufferRange(
                @intFromEnum(target),
                @intFromEnum(internalformat),
                @intFromEnum(buffer),
                @bitCast(offset),
                @bitCast(size),
            );
        }

        // pub var texStorage2DMultisample: *const fn (
        //     target: Enum,
        //     samples: Sizei,
        //     internalformat: Enum,
        //     width: Sizei,
        //     height: Sizei,
        //     fixedsamplelocations: Boolean,
        // ) callconv(.c) void = undefined;
        pub fn texStorage2DMultisample(
            target: TexImage2DMultisampleTarget,
            samples: i32,
            internalformat: InternalFormat,
            width: i32,
            height: i32,
            fixedsamplelocations: bool,
        ) void {
            bindings.texStorage2DMultisample(
                @intFromEnum(target),
                @bitCast(samples),
                @intFromEnum(internalformat),
                @bitCast(width),
                @bitCast(height),
                @intFromBool(fixedsamplelocations),
            );
        }

        // pub var texStorage3DMultisample: *const fn (
        //     target: Enum,
        //     samples: Sizei,
        //     internalformat: Enum,
        //     width: Sizei,
        //     height: Sizei,
        //     depth: Sizei,
        //     fixedsamplelocations: Boolean,
        // ) callconv(.c) void = undefined;
        pub fn texStorage3DMultisample(
            target: TexImage3DMultisampleTarget,
            samples: i32,
            internalformat: InternalFormat,
            width: i32,
            height: i32,
            depth: i32,
            fixedsamplelocations: bool,
        ) void {
            bindings.texStorage3DMultisample(
                @intFromEnum(target),
                @bitCast(samples),
                @intFromEnum(internalformat),
                @bitCast(width),
                @bitCast(height),
                @bitCast(depth),
                @intFromBool(fixedsamplelocations),
            );
        }

        // pub var textureView: *const fn (
        //     texture: Uint,
        //     target: Enum,
        //     origtexture: Uint,
        //     internalformat: Enum,
        //     minlevel: Uint,
        //     numlevels: Uint,
        //     minlayer: Uint,
        //     numlayers: Uint,
        // ) callconv(.c) void = undefined;
        pub fn textureView(
            texture: Texture,
            target: CopyImageTextureTarget,
            origtexture: Texture,
            internalformat: TextureViewInternalFormat,
            minlevel: u32,
            numlevels: u32,
            minlayer: u32,
            numlayers: u32,
        ) void {
            assert(texture != .invalid);
            bindings.textureView(
                @intFromEnum(texture),
                @intFromEnum(target),
                @intFromEnum(origtexture),
                @intFromEnum(internalformat),
                @bitCast(minlevel),
                @bitCast(numlevels),
                @bitCast(minlayer),
                @bitCast(numlayers),
            );
        }

        // pub var bindVertexBuffer: *const fn (
        //     bindingindex: Uint,
        //     buffer: Uint,
        //     offset: Intptr,
        //     stride: Sizei,
        // ) callconv(.c) void = undefined;
        pub fn bindVertexBuffer(
            bindingindex: u32,
            buffer: Buffer,
            offset: usize,
            stride: i32,
        ) void {
            bindings.bindVertexBuffer(
                @bitCast(bindingindex),
                @intFromEnum(buffer),
                @bitCast(offset),
                @bitCast(stride),
            );
        }

        // pub var vertexAttribFormat: *const fn (
        //     attribindex: Uint,
        //     size: Int,
        //     type: Enum,
        //     normalized: Boolean,
        //     relativeoffset: Uint,
        // ) callconv(.c) void = undefined;
        pub fn vertexAttribFormat(
            attribindex: VertexAttribLocation,
            size: i32,
            attrib_type: VertexAttribType,
            normalized: bool,
            relativeoffset: u32,
        ) void {
            bindings.vertexAttribFormat(
                @intFromEnum(attribindex),
                @bitCast(size),
                @intFromEnum(attrib_type),
                @intFromBool(normalized),
                @bitCast(relativeoffset),
            );
        }

        // pub var vertexAttribIFormat: *const fn (
        //     attribindex: Uint,
        //     size: Int,
        //     type: Enum,
        //     relativeoffset: Uint,
        // ) callconv(.c) void = undefined;
        pub fn vertexAttribIFormat(
            attribindex: VertexAttribLocation,
            size: i32,
            attrib_type: VertexAttribIntegerType,
            relativeoffset: u32,
        ) void {
            bindings.vertexAttribIFormat(
                @intFromEnum(attribindex),
                @bitCast(size),
                @intFromEnum(attrib_type),
                @bitCast(relativeoffset),
            );
        }

        // pub var vertexAttribLFormat: *const fn (
        //     attribindex: Uint,
        //     size: Int,
        //     type: Enum,
        //     relativeoffset: Uint,
        // ) callconv(.c) void = undefined;
        pub fn vertexAttribLFormat(
            attribindex: VertexAttribLocation,
            size: i32,
            attrib_type: VertexAttribDoubleType,
            relativeoffset: u32,
        ) void {
            bindings.vertexAttribLFormat(
                @intFromEnum(attribindex),
                @bitCast(size),
                @intFromEnum(attrib_type),
                @bitCast(relativeoffset),
            );
        }

        // pub var vertexAttribBinding: *const fn (
        //     attribindex: Uint,
        //     bindingindex: Uint,
        // ) callconv(.c) void = undefined;
        pub fn vertexAttribBinding(
            attribindex: VertexAttribLocation,
            bindingindex: u32,
        ) void {
            bindings.vertexAttribBinding(
                @intFromEnum(attribindex),
                @bitCast(bindingindex),
            );
        }

        // pub var vertexBindingDivisor: *const fn (
        //     bindingindex: Uint,
        //     divisor: Uint,
        // ) callconv(.c) void = undefined;
        pub fn vertexBindingDivisor(
            bindingindex: u32,
            divisor: u32,
        ) void {
            bindings.vertexBindingDivisor(
                @bitCast(bindingindex),
                @bitCast(divisor),
            );
        }

        // pub var debugMessageControl: *const fn (
        //     source: Enum,
        //     type: Enum,
        //     severity: Enum,
        //     count: Sizei,
        //     ids: [*c]const Uint,
        //     enabled: Boolean,
        // ) callconv(.c) void = undefined;
        pub fn debugMessageControl(
            source: DebugSourceWithDontCare,
            debug_type: DebugTypeWithDontCare,
            severity: DebugSeverityWithDontCare,
            ids: []const u32,
            enabled: bool,
        ) void {
            if (ids.len > 0) {
                // when ids are provided, source and type must not be DONT_CARE
                assert(source != .dont_care);
                assert(debug_type != .dont_care);
                // and severity must be DONT_CARE
                assert(severity == .dont_care);
            }
            bindings.debugMessageControl(
                @intFromEnum(source),
                @intFromEnum(debug_type),
                @intFromEnum(severity),
                @intCast(ids.len),
                @ptrCast(ids.ptr),
                @intFromBool(enabled),
            );
        }

        // pub var debugMessageInsert: *const fn (
        //     source: Enum,
        //     type: Enum,
        //     id: Uint,
        //     severity: Enum,
        //     length: Sizei,
        //     message: [*c]const Char,
        // ) callconv(.c) void = undefined;
        pub fn debugMessageInsert(
            source: DebugSourceCustom,
            debug_type: DebugType,
            id: u32,
            severity: DebugSeverity,
            messsage: []const u8,
        ) void {
            bindings.debugMessageInsert(
                @intFromEnum(source),
                @intFromEnum(debug_type),
                @bitCast(id),
                @intFromEnum(severity),
                @intCast(messsage.len),
                @ptrCast(messsage.ptr),
            );
        }

        pub fn debugMessageCallback(
            callback: ?*const DEBUGPROC, // passing null will unset message callback
            userParam: ?*const anyopaque,
        ) void {
            bindings.debugMessageCallback(
                @ptrCast(callback),
                userParam,
            );
        }

        // pub var getDebugMessageLog: *const fn (
        //     count: Uint,
        //     bufSize: Sizei,
        //     sources: [*c]Enum,
        //     types: [*c]Enum,
        //     ids: [*c]Uint,
        //     severities: [*c]Enum,
        //     lengths: [*c]Sizei,
        //     messageLog: [*c]Char,
        // ) callconv(.c) Uint = undefined;
        /// passing null to optional parameters will omit that segment
        /// of messages' information, while still populating all non-null
        /// parameters,
        /// when parameters 'sources', 'types', 'ids', 'severities' and 'lengths',
        /// are non-null, they must have space for at least 'count' messages
        pub fn getDebugMessageLog(
            count: u32,
            sources: ?[*]DebugSource,
            types: ?[*]DebugType,
            ids: ?[*]u32,
            severities: ?[*]DebugSeverity,
            lengths: ?[*]i32,
            message_log_buf: ?[:0]u8,
        ) usize {
            return @intCast(bindings.getDebugMessageLog(
                @bitCast(count),
                if (message_log_buf) |buf| @intCast(buf.len) else 0,
                @ptrCast(sources),
                @ptrCast(types),
                @ptrCast(ids),
                @ptrCast(severities),
                @ptrCast(lengths),
                if (message_log_buf) |buf| @ptrCast(buf.ptr) else null,
            ));
        }
        /// discards 'count' messages from the log
        pub fn getDebugMessageLogDiscard(count: usize) usize {
            return @intCast(bindings.getDebugMessageLog(
                @intCast(count),
                0,
                null,
                null,
                null,
                null,
                null,
                null,
            ));
        }

        // pub var pushDebugGroup: *const fn (
        //     source: Enum,
        //     id: Uint,
        //     length: Sizei,
        //     message: [*c]const Char,
        // ) callconv(.c) void = undefined;
        pub fn pushDebugGroup(
            source: DebugSourceCustom,
            id: u32,
            message: [:0]const u8,
        ) void {
            bindings.pushDebugGroup(
                @intFromEnum(source),
                @bitCast(id),
                @intCast(message.len),
                @ptrCast(message.ptr),
            );
        }

        // pub var popDebugGroup: *const fn () callconv(.c) void = undefined;
        pub fn popDebugGroup() void {
            bindings.popDebugGroup();
        }

        // pub var objectLabel: *const fn (
        //     identifier: Enum,
        //     name: Uint,
        //     length: Sizei,
        //     label: [*c]const Char,
        // ) callconv(.c) void = undefined;
        /// parameter 'NameType' must be Buffer, Framebuffer,
        /// ProgramPipeline, Program, Query, Renderbuffer, Sampler,
        /// Shader, Texture, TransformFeedback or VertexArrayObject
        pub fn objectLabel(
            comptime NameType: type,
            name: NameType,
            label: ?[:0]const u8, // null removes the label from object
        ) void {
            const namespace: DebugObjectNamespace = .fromType(NameType);
            bindings.objectLabel(
                @intFromEnum(namespace),
                @intFromEnum(name),
                if (label) |l| @intCast(l.len) else 0,
                if (label) |l| @ptrCast(l.ptr) else null,
            );
        }

        // pub var getObjectLabel: *const fn (
        //     identifier: Enum,
        //     name: Uint,
        //     bufSize: Sizei,
        //     length: [*c]Sizei,
        //     label: [*c]Char,
        // ) callconv(.c) void = undefined;
        /// parameter 'NameType' must be Buffer, Framebuffer,
        /// ProgramPipeline, Program, Query, Renderbuffer, Sampler,
        /// Shader, Texture, TransformFeedback or VertexArrayObject
        pub fn getObjectLabel(
            comptime NameType: type,
            name: NameType,
            label_buf: [:0]u8,
        ) [:0]const u8 {
            const namespace: DebugObjectNamespace = .fromType(NameType);
            var length: i32 = undefined;
            bindings.getObjectLabel(
                @intFromEnum(namespace),
                @intFromEnum(name),
                // includes null terminator
                @intCast(label_buf.len + 1),
                // excludes null terminator
                @ptrCast(&length),
                @ptrCast(label_buf.ptr),
            );
            return label_buf[0..@intCast(length) :0];
        }

        // pub var objectPtrLabel: *const fn (
        //     ptr: ?*const anyopaque,
        //     length: Sizei,
        //     label: [*c]const Char,
        // ) callconv(.c) void = undefined;
        pub fn objectPtrLabel(
            sync: Sync,
            label_buf: [:0]const u8,
        ) void {
            bindings.objectPtrLabel(
                @ptrCast(sync),
                @intCast(label_buf.len),
                @ptrCast(label_buf.ptr),
            );
        }

        // pub var getObjectPtrLabel: *const fn (
        //     ptr: ?*const anyopaque,
        //     bufSize: Sizei,
        //     length: [*c]Sizei,
        //     label: [*c]Char,
        // ) callconv(.c) void = undefined;
        pub fn getObjectPtrLabel(
            sync: Sync,
            label_buf: [:0]u8,
        ) [:0]const u8 {
            var length: i32 = undefined;
            bindings.getObjectPtrLabel(
                @ptrCast(sync),
                // includes null terminator
                @intCast(label_buf.len + 1),
                // excludes null terminator
                @ptrCast(&length),
                @ptrCast(label_buf.ptr),
            );
            return label_buf[0..@intCast(length) :0];
        }

        // pub var getPointerv: *const fn (
        //     pname: Enum,
        //     params: [*c]?*anyopaque,
        // ) callconv(.c) void = undefined;
        pub fn getPointerv(
            pname: DebugPointerParameter,
            params: *?*anyopaque,
        ) void {
            bindings.getPointerv(
                @intFromEnum(pname),
                @ptrCast(params),
            );
        }

        //--------------------------------------------------------------------------------------------------
        //
        // OpenGL 4.4 (Core Profile)
        //
        //--------------------------------------------------------------------------------------------------
        pub const MAX_VERTEX_ATTRIB_STRIDE = bindings.MAX_VERTEX_ATTRIB_STRIDE;
        pub const PRIMITIVE_RESTART_FOR_PATCHES_SUPPORTED = bindings.PRIMITIVE_RESTART_FOR_PATCHES_SUPPORTED;
        pub const TEXTURE_BUFFER_BINDING = bindings.TEXTURE_BUFFER_BINDING;
        pub const MAP_PERSISTENT_BIT = bindings.MAP_PERSISTENT_BIT;
        pub const MAP_COHERENT_BIT = bindings.MAP_COHERENT_BIT;
        pub const DYNAMIC_STORAGE_BIT = bindings.DYNAMIC_STORAGE_BIT;
        pub const CLIENT_STORAGE_BIT = bindings.CLIENT_STORAGE_BIT;
        pub const CLIENT_MAPPED_BUFFER_BARRIER_BIT = bindings.CLIENT_MAPPED_BUFFER_BARRIER_BIT;
        pub const BUFFER_IMMUTABLE_STORAGE = bindings.BUFFER_IMMUTABLE_STORAGE;
        pub const BUFFER_STORAGE_FLAGS = bindings.BUFFER_STORAGE_FLAGS;
        pub const CLEAR_TEXTURE = bindings.CLEAR_TEXTURE;
        pub const LOCATION_COMPONENT = bindings.LOCATION_COMPONENT;
        pub const TRANSFORM_FEEDBACK_BUFFER_INDEX = bindings.TRANSFORM_FEEDBACK_BUFFER_INDEX;
        pub const TRANSFORM_FEEDBACK_BUFFER_STRIDE = bindings.TRANSFORM_FEEDBACK_BUFFER_STRIDE;
        pub const QUERY_BUFFER = bindings.QUERY_BUFFER;
        pub const QUERY_BUFFER_BARRIER_BIT = bindings.QUERY_BUFFER_BARRIER_BIT;
        pub const QUERY_BUFFER_BINDING = bindings.QUERY_BUFFER_BINDING;
        pub const QUERY_RESULT_NO_WAIT = bindings.QUERY_RESULT_NO_WAIT;
        pub const MIRROR_CLAMP_TO_EDGE = bindings.MIRROR_CLAMP_TO_EDGE;

        pub fn bufferStorage(
            target: BufferTarget,
            size: usize,
            data: ?[]const u8,
            flags: BufferStorageFlags,
        ) void {
            // when MAP_COHERENT_BIT is set, MAP_PERSISTENT_BIT must also be set
            assert(!flags.map_coherent or flags.map_persistent);
            // when MAP_PERSISTENT_BIT is set, at least one of
            // MAP_READ_BIT and/or MAP_WRITE_BIT must also be set
            assert(!flags.map_persistent or (flags.map_read or flags.map_write));
            bindings.bufferStorage(
                @intFromEnum(target),
                @as(Sizeiptr, @bitCast(size)),
                if (data) |d| d.ptr else null,
                @bitCast(flags),
            );
        }

        pub fn clearTexImage(texture: Texture, level: i32, format: PixelFormat, pixel_type: PixelType, data: ?[]const u8) void {
            bindings.clearTexImage(
                @intFromEnum(texture),
                level,
                @intFromEnum(format),
                @intFromEnum(pixel_type),
                if (data) |d| d.ptr else null,
            );
        }

        pub fn clearTexSubImage(
            texture: Texture,
            level: i32,
            xoffset: i32,
            yoffset: i32,
            zoffset: i32,
            width: u32,
            height: u32,
            depth: u32,
            format: PixelFormat,
            pixel_type: PixelType,
            data: ?[]const u8,
        ) void {
            bindings.clearTexSubImage(
                @intFromEnum(texture),
                level,
                xoffset,
                yoffset,
                zoffset,
                @as(Sizei, @bitCast(width)),
                @as(Sizei, @bitCast(height)),
                @as(Sizei, @bitCast(depth)),
                @intFromEnum(format),
                @intFromEnum(pixel_type),
                if (data) |d| d.ptr else null,
            );
        }

        pub fn bindBuffersBase(target: IndexedBufferTarget, first: u32, buffers: []const Buffer) void {
            bindings.bindBuffersBase(
                @intFromEnum(target),
                first,
                @intCast(buffers.len),
                @ptrCast(buffers.ptr),
            );
        }

        pub fn bindBuffersRange(
            target: IndexedBufferTarget,
            first: u32,
            buffers: []const Buffer,
            offsets: []const Intptr,
            sizes: []const Sizeiptr,
        ) void {
            assert(buffers.len == offsets.len);
            assert(buffers.len == sizes.len);
            bindings.bindBuffersRange(
                @intFromEnum(target),
                first,
                @intCast(buffers.len),
                @ptrCast(buffers.ptr),
                offsets.ptr,
                sizes.ptr,
            );
        }

        pub fn bindTextures(first: u32, textures: []const Texture) void {
            bindings.bindTextures(
                first,
                @intCast(textures.len),
                @ptrCast(textures.ptr),
            );
        }

        pub fn bindSamplers(first: u32, samplers: []const Uint) void {
            bindings.bindSamplers(
                first,
                @intCast(samplers.len),
                samplers.ptr,
            );
        }

        pub fn bindImageTextures(first: u32, textures: []const Texture) void {
            bindings.bindImageTextures(
                first,
                @intCast(textures.len),
                @ptrCast(textures.ptr),
            );
        }

        pub fn bindVertexBuffers(
            first: u32,
            buffers: []const Buffer,
            offsets: []const Intptr,
            strides: []const Sizei,
        ) void {
            assert(buffers.len == offsets.len);
            assert(buffers.len == strides.len);
            bindings.bindVertexBuffers(
                first,
                @intCast(buffers.len),
                @ptrCast(buffers.ptr),
                offsets.ptr,
                strides.ptr,
            );
        }

        //--------------------------------------------------------------------------------------------------
        //
        // OpenGL 4.5 (Core Profile)
        //
        //--------------------------------------------------------------------------------------------------
        pub const CONTEXT_LOST = bindings.CONTEXT_LOST;
        pub const NEGATIVE_ONE_TO_ONE = bindings.NEGATIVE_ONE_TO_ONE;
        pub const ZERO_TO_ONE = bindings.ZERO_TO_ONE;
        pub const CLIP_ORIGIN = bindings.CLIP_ORIGIN;
        pub const CLIP_DEPTH_MODE = bindings.CLIP_DEPTH_MODE;
        pub const QUERY_WAIT_INVERTED = bindings.QUERY_WAIT_INVERTED;
        pub const QUERY_NO_WAIT_INVERTED = bindings.QUERY_NO_WAIT_INVERTED;
        pub const QUERY_BY_REGION_WAIT_INVERTED = bindings.QUERY_BY_REGION_WAIT_INVERTED;
        pub const QUERY_BY_REGION_NO_WAIT_INVERTED = bindings.QUERY_BY_REGION_NO_WAIT_INVERTED;
        pub const MAX_CULL_DISTANCES = bindings.MAX_CULL_DISTANCES;
        pub const MAX_COMBINED_CLIP_AND_CULL_DISTANCES = bindings.MAX_COMBINED_CLIP_AND_CULL_DISTANCES;
        pub const TEXTURE_TARGET = bindings.TEXTURE_TARGET;
        pub const QUERY_TARGET = bindings.QUERY_TARGET;
        pub const GUILTY_CONTEXT_RESET = bindings.GUILTY_CONTEXT_RESET;
        pub const INNOCENT_CONTEXT_RESET = bindings.INNOCENT_CONTEXT_RESET;
        pub const UNKNOWN_CONTEXT_RESET = bindings.UNKNOWN_CONTEXT_RESET;
        pub const RESET_NOTIFICATION_STRATEGY = bindings.RESET_NOTIFICATION_STRATEGY;
        pub const LOSE_CONTEXT_ON_RESET = bindings.LOSE_CONTEXT_ON_RESET;
        pub const NO_RESET_NOTIFICATION = bindings.NO_RESET_NOTIFICATION;
        pub const CONTEXT_FLAG_ROBUST_ACCESS_BIT = bindings.CONTEXT_FLAG_ROBUST_ACCESS_BIT;
        pub const CONTEXT_RELEASE_BEHAVIOR = bindings.CONTEXT_RELEASE_BEHAVIOR;
        pub const CONTEXT_RELEASE_BEHAVIOR_FLUSH = bindings.CONTEXT_RELEASE_BEHAVIOR_FLUSH;

        pub fn clipControl(origin: ClipOrigin, depth: ClipDepth) void {
            bindings.clipControl(@intFromEnum(origin), @intFromEnum(depth));
        }

        // pub var createTransformFeedbacks: *const fn (
        //     n: Sizei,
        //     ids: [*c]Uint,
        // ) callconv(.c) void = undefined;
        pub fn createTransformFeedback(ptr: *TransformFeedback) void {
            bindings.createTransformFeedbacks(1, @ptrCast(ptr));
        }
        pub fn createTransformFeedbacks(transform_feedbacks: []TransformFeedback) void {
            bindings.createTransformFeedbacks(
                @intCast(transform_feedbacks.len),
                @ptrCast(transform_feedbacks.ptr),
            );
        }

        // pub var transformFeedbackBufferBase: *const fn (
        //     xfb: Uint,
        //     index: Uint,
        //     buffer: Uint,
        // ) callconv(.c) void = undefined;
        pub fn transformFeedbackBufferBase(
            transform_feedback: TransformFeedback,
            index: u32,
            buffer: Buffer,
        ) void {
            bindings.transformFeedbackBufferBase(
                @intFromEnum(transform_feedback),
                @bitCast(index),
                @intFromEnum(buffer),
            );
        }

        // pub var transformFeedbackBufferRange: *const fn (
        //     xfb: Uint,
        //     index: Uint,
        //     buffer: Uint,
        //     offset: Intptr,
        //     size: Sizeiptr,
        // ) callconv(.c) void = undefined;
        pub fn transformFeedbackBufferRange(
            transform_feedback: TransformFeedback,
            index: u32,
            buffer: Buffer,
            offset: usize,
            size: usize,
        ) void {
            bindings.transformFeedbackBufferRange(
                @intFromEnum(transform_feedback),
                @bitCast(index),
                @intFromEnum(buffer),
                @bitCast(offset),
                @bitCast(size),
            );
        }

        // pub var getTransformFeedbackiv: *const fn (
        //     xfb: Uint,
        //     pname: Enum,
        //     param: [*c]Int,
        // ) callconv(.c) void = undefined;
        pub fn getTransformFeedbackiv(
            transform_feedback: TransformFeedback,
            pname: TransformFeedbackIntegerParameter,
            param: []i32,
        ) void {
            bindings.getTransformFeedbackiv(
                @intFromEnum(transform_feedback),
                @intFromEnum(pname),
                @ptrCast(param.ptr),
            );
        }

        // pub var getTransformFeedbacki_v: *const fn (
        //     xfb: Uint,
        //     pname: Enum,
        //     index: Uint,
        //     param: [*c]Int,
        // ) callconv(.c) void = undefined;
        pub fn getTransformFeedbacki_v(
            transform_feedback: TransformFeedback,
            pname: IndexedTransformFeedbackIntegerParameter,
            index: u32,
            param: []i32,
        ) void {
            bindings.getTransformFeedbacki_v(
                @intFromEnum(transform_feedback),
                @intFromEnum(pname),
                @bitCast(index),
                @ptrCast(param.ptr),
            );
        }

        // pub var getTransformFeedbacki64_v: *const fn (
        //     xfb: Uint,
        //     pname: Enum,
        //     index: Uint,
        //     param: [*c]Int64,
        // ) callconv(.c) void = undefined;
        pub fn getTransformFeedbacki64_v(
            transform_feedback: TransformFeedback,
            pname: IndexedTransformFeedbackInt64Parameter,
            index: u32,
            param: []i64,
        ) void {
            bindings.getTransformFeedbacki64_v(
                @intFromEnum(transform_feedback),
                @intFromEnum(pname),
                @bitCast(index),
                @ptrCast(param.ptr),
            );
        }

        pub fn createBuffer(ptr: *Buffer) void {
            bindings.createBuffers(1, @ptrCast(ptr));
        }
        pub fn createBuffers(buffers: []Buffer) void {
            bindings.createBuffers(@intCast(buffers.len), @ptrCast(buffers.ptr));
        }

        // pub var namedBufferStorage: *const fn (
        //     buffer: Uint,
        //     size: Sizeiptr,
        //     data: ?*const anyopaque,
        //     flags: Bitfield,
        // ) callconv(.c) void = undefined;
        pub fn namedBufferStorage(
            buffer: Buffer,
            size: usize,
            data: ?[]const u8,
            flags: BufferStorageFlags,
        ) void {
            // when MAP_COHERENT_BIT is set, MAP_PERSISTENT_BIT must also be set
            assert(!flags.map_coherent or flags.map_persistent);
            // when MAP_PERSISTENT_BIT is set, at least one of
            // MAP_READ_BIT and/or MAP_WRITE_BIT must also be set
            assert(!flags.map_persistent or (flags.map_read or flags.map_write));
            bindings.namedBufferStorage(
                @intFromEnum(buffer),
                @bitCast(size),
                if (data) |d| @ptrCast(d.ptr) else null,
                @bitCast(flags),
            );
        }

        pub fn namedBufferData(buffer: Buffer, data: []const u8, usage: BufferUsage) void {
            bindings.namedBufferData(@intFromEnum(buffer), @intCast(data.len), data.ptr, @intFromEnum(usage));
        }

        // pub var namedBufferSubData: *const fn (
        //     buffer: Uint,
        //     offset: Intptr,
        //     size: Sizeiptr,
        //     data: ?*const anyopaque,
        // ) callconv(.c) void = undefined;
        pub fn namedBufferSubData(
            buffer: Buffer,
            offset: usize,
            bytes: []const u8,
        ) void {
            bindings.namedBufferSubData(
                @intFromEnum(buffer),
                @bitCast(offset),
                @bitCast(bytes.len),
                @ptrCast(bytes.ptr),
            );
        }

        // pub var copyNamedBufferSubData: *const fn (
        //     readBuffer: Uint,
        //     writeBuffer: Uint,
        //     readOffset: Intptr,
        //     writeOffset: Intptr,
        //     size: Sizeiptr,
        // ) callconv(.c) void = undefined;
        pub fn copyNamedBufferSubData(
            read_buffer: Buffer,
            write_buffer: Buffer,
            readOffset: usize,
            writeOffset: usize,
            size: usize,
        ) void {
            bindings.copyNamedBufferSubData(
                @intFromEnum(read_buffer),
                @intFromEnum(write_buffer),
                @bitCast(readOffset),
                @bitCast(writeOffset),
                @bitCast(size),
            );
        }

        // pub var clearNamedBufferData: *const fn (
        //     buffer: Uint,
        //     internalformat: Enum,
        //     format: Enum,
        //     type: Enum,
        //     data: ?*const anyopaque,
        // ) callconv(.c) void = undefined;
        pub fn clearNamedBufferData(
            buffer: Buffer,
            internalformat: TextureInternalFormat,
            format: PixelFormat,
            pixel_type: PixelType,
            data: ?[]const u8, // passing null will fill the buffer with zeros
        ) void {
            bindings.clearNamedBufferData(
                @intFromEnum(buffer),
                @intFromEnum(internalformat),
                @intFromEnum(format),
                @intFromEnum(pixel_type),
                if (data) |d| @ptrCast(d.ptr) else null,
            );
        }

        // pub var clearNamedBufferSubData: *const fn (
        //     buffer: Uint,
        //     internalformat: Enum,
        //     offset: Intptr,
        //     size: Sizeiptr,
        //     format: Enum,
        //     type: Enum,
        //     data: ?*const anyopaque,
        // ) callconv(.c) void = undefined;
        pub fn clearNamedBufferSubData(
            buffer: Buffer,
            internalformat: TextureInternalFormat,
            offset: usize,
            size: usize,
            format: PixelFormat,
            pixel_type: PixelType,
            data: ?[]const u8, // passing null will clear the buffer region with zeros
        ) void {
            bindings.clearNamedBufferSubData(
                @intFromEnum(buffer),
                @intFromEnum(internalformat),
                @bitCast(offset),
                @bitCast(size),
                @intFromEnum(format),
                @intFromEnum(pixel_type),
                if (data) |d| @ptrCast(d.ptr) else null,
            );
        }

        // pub var mapNamedBuffer: *const fn (
        //     buffer: Uint,
        //     access: Enum,
        // ) callconv(.c) ?*anyopaque = undefined;
        pub fn mapNamedBuffer(buffer: Buffer, access: Access) ?[*]u8 {
            return @ptrCast(bindings.mapNamedBuffer(
                @intFromEnum(buffer),
                @intFromEnum(access),
            ));
        }

        // pub var mapNamedBufferRange: *const fn (
        //     buffer: Uint,
        //     offset: Intptr,
        //     length: Sizeiptr,
        //     access: Bitfield,
        // ) callconv(.c) ?*anyopaque = undefined;
        pub fn mapNamedBufferRange(
            buffer: Buffer,
            offset: usize,
            length: usize,
            access: MappedBufferAccess,
        ) ?[*]u8 {
            return @ptrCast(bindings.mapNamedBufferRange(
                @intFromEnum(buffer),
                @bitCast(offset),
                @bitCast(length),
                @bitCast(access),
            ));
        }

        // pub var unmapNamedBuffer: *const fn (
        //     buffer: Uint,
        // ) callconv(.c) Boolean = undefined;
        pub fn unmapNamedBuffer(buffer: Buffer) bool {
            return bindings.unmapNamedBuffer(@intFromEnum(buffer)) == TRUE;
        }

        // pub var flushMappedNamedBufferRange: *const fn (
        //     buffer: Uint,
        //     offset: Intptr,
        //     length: Sizeiptr,
        // ) callconv(.c) void = undefined;
        pub fn flushMappedNamedBufferRange(
            buffer: Buffer,
            offset: usize,
            length: usize,
        ) void {
            bindings.flushMappedNamedBufferRange(
                @intFromEnum(buffer),
                @bitCast(offset),
                @bitCast(length),
            );
        }

        // pub var getNamedBufferParameteriv: *const fn (
        //     buffer: Uint,
        //     pname: Enum,
        //     params: [*c]Int,
        // ) callconv(.c) void = undefined;
        pub fn getNamedBufferParameteriv(
            buffer: Buffer,
            pname: BufferParameter,
            params: []i32,
        ) void {
            bindings.getNamedBufferParameteriv(
                @intFromEnum(buffer),
                @intFromEnum(pname),
                @ptrCast(params.ptr),
            );
        }

        // pub var getNamedBufferParameteri64v: *const fn (
        //     buffer: Uint,
        //     pname: Enum,
        //     params: [*c]Int64,
        // ) callconv(.c) void = undefined;
        pub fn getNamedBufferParameteri64v(
            buffer: Buffer,
            pname: BufferParameter,
            params: []i64,
        ) void {
            bindings.getNamedBufferParameteri64v(
                @intFromEnum(buffer),
                @intFromEnum(pname),
                @ptrCast(params.ptr),
            );
        }

        // pub var getNamedBufferPointerv: *const fn (
        //     buffer: Uint,
        //     pname: Enum,
        //     params: [*c]?*anyopaque,
        // ) callconv(.c) void = undefined;
        pub fn getNamedBufferPointerv(
            buffer: Buffer,
            pname: BufferPointerParameter,
            params: *?[*]u8,
        ) void {
            bindings.getNamedBufferPointerv(
                @intFromEnum(buffer),
                @intFromEnum(pname),
                @ptrCast(params),
            );
        }

        // pub var getNamedBufferSubData: *const fn (
        //     buffer: Uint,
        //     offset: Intptr,
        //     size: Sizeiptr,
        //     data: ?*anyopaque,
        // ) callconv(.c) void = undefined;
        pub fn getNamedBufferSubData(
            buffer: Buffer,
            offset: usize,
            data: []u8,
        ) void {
            bindings.getNamedBufferSubData(
                @intFromEnum(buffer),
                @bitCast(offset),
                @bitCast(data.len),
                @ptrCast(data.ptr),
            );
        }

        pub fn createFramebuffer(ptr: *Framebuffer) void {
            bindings.createFramebuffers(1, @ptrCast(ptr));
        }
        pub fn createFramebuffers(framebuffers: []Framebuffer) void {
            bindings.createFramebuffers(
                @intCast(framebuffers.len),
                @ptrCast(framebuffers.ptr),
            );
        }

        // pub var namedFramebufferRenderbuffer: *const fn (
        //     framebuffer: Uint,
        //     attachment: Enum,
        //     renderbuffertarget: Enum,
        //     renderbuffer: Uint,
        // ) callconv(.c) void = undefined;
        pub fn namedFramebufferRenderbuffer(
            framebuffer: Framebuffer,
            attachment: FramebufferAttachment,
            renderbuffertarget: RenderbufferTarget,
            renderbuffer: Renderbuffer,
        ) void {
            bindings.namedFramebufferRenderbuffer(
                @intFromEnum(framebuffer),
                @intFromEnum(attachment),
                @intFromEnum(renderbuffertarget),
                @intFromEnum(renderbuffer),
            );
        }

        // pub var namedFramebufferParameteri: *const fn (
        //     framebuffer: Uint,
        //     pname: Enum,
        //     param: Int,
        // ) callconv(.c) void = undefined;
        pub fn namedFramebufferParameteri(
            framebuffer: Framebuffer,
            pname: FramebufferParameter,
            param: i32,
        ) void {
            bindings.namedFramebufferParameteri(
                @intFromEnum(framebuffer),
                @intFromEnum(pname),
                @bitCast(param),
            );
        }

        pub fn namedFramebufferTexture(framebuffer: Framebuffer, attachment: FramebufferAttachment, texture: Texture, level: i32) void {
            bindings.namedFramebufferTexture(@intFromEnum(framebuffer), @intFromEnum(attachment), @intFromEnum(texture), level);
        }

        // pub var namedFramebufferTextureLayer: *const fn (
        //     framebuffer: Uint,
        //     attachment: Enum,
        //     texture: Uint,
        //     level: Int,
        //     layer: Int,
        // ) callconv(.c) void = undefined;
        pub fn namedFramebufferTextureLayer(
            framebuffer: Framebuffer,
            attachment: FramebufferAttachment,
            texture: Texture,
            level: i32,
            layer: i32,
        ) void {
            bindings.namedFramebufferTextureLayer(
                @intFromEnum(framebuffer),
                @intFromEnum(attachment),
                @intFromEnum(texture),
                @bitCast(level),
                @bitCast(layer),
            );
        }

        // pub var namedFramebufferDrawBuffer: *const fn (
        //     framebuffer: Uint,
        //     buf: Enum,
        // ) callconv(.c) void = undefined;
        pub fn namedFramebufferDrawBuffer(
            framebuffer: Framebuffer,
            buf: ColorBuffer,
        ) void {
            bindings.namedFramebufferDrawBuffer(
                @intFromEnum(framebuffer),
                @intFromEnum(buf),
            );
        }

        // pub var namedFramebufferDrawBuffers: *const fn (
        //     framebuffer: Uint,
        //     n: Sizei,
        //     bufs: [*c]const Enum,
        // ) callconv(.c) void = undefined;
        pub fn namedFramebufferDrawBuffers(
            framebuffer: Framebuffer,
            bufs: []const ColorBufferSingle,
        ) void {
            bindings.namedFramebufferDrawBuffers(
                @intFromEnum(framebuffer),
                @intCast(bufs.len),
                @ptrCast(bufs.ptr),
            );
        }

        // pub var namedFramebufferReadBuffer: *const fn (
        //     framebuffer: Uint,
        //     src: Enum,
        // ) callconv(.c) void = undefined;
        pub fn namedFramebufferReadBuffer(
            framebuffer: Framebuffer,
            src: ColorBuffer,
        ) void {
            bindings.namedFramebufferReadBuffer(
                @intFromEnum(framebuffer),
                @intFromEnum(src),
            );
        }

        // pub var invalidateNamedFramebufferData: *const fn (
        //     framebuffer: Uint,
        //     numAttachments: Sizei,
        //     attachments: [*c]const Enum,
        // ) callconv(.c) void = undefined;
        pub fn invalidateNamedFramebufferData(
            framebuffer: Framebuffer,
            attachments: []FramebufferAttachmentDefault,
        ) void {
            bindings.invalidateNamedFramebufferData(
                @intFromEnum(framebuffer),
                @intCast(attachments.len),
                @ptrCast(attachments.ptr),
            );
        }

        // pub var invalidateNamedFramebufferSubData: *const fn (
        //     framebuffer: Uint,
        //     numAttachments: Sizei,
        //     attachments: [*c]const Enum,
        //     x: Int,
        //     y: Int,
        //     width: Sizei,
        //     height: Sizei,
        // ) callconv(.c) void = undefined;
        pub fn invalidateNamedFramebufferSubData(
            framebuffer: Framebuffer,
            attachments: []FramebufferAttachmentDefault,
            x: i32,
            y: i32,
            width: i32,
            height: i32,
        ) void {
            bindings.invalidateNamedFramebufferSubData(
                @intFromEnum(framebuffer),
                @intCast(attachments.len),
                @ptrCast(attachments.ptr),
                @bitCast(x),
                @bitCast(y),
                @bitCast(width),
                @bitCast(height),
            );
        }

        // pub var clearNamedFramebufferiv: *const fn (
        //     framebuffer: Uint,
        //     buffer: Enum,
        //     drawbuffer: Int,
        //     value: [*c]const Int,
        // ) callconv(.c) void = undefined;
        pub fn clearNamedFramebufferiv(
            framebuffer: Framebuffer,
            buffer: ClearBuffer,
            drawbuffer: i32,
            value: []const i32,
        ) void {
            bindings.clearNamedFramebufferiv(
                @intFromEnum(framebuffer),
                @intFromEnum(buffer),
                @bitCast(drawbuffer),
                @ptrCast(value.ptr),
            );
        }

        // pub var clearNamedFramebufferuiv: *const fn (
        //     framebuffer: Uint,
        //     buffer: Enum,
        //     drawbuffer: Int,
        //     value: [*c]const Uint,
        // ) callconv(.c) void = undefined;
        pub fn clearNamedFramebufferuiv(
            framebuffer: Framebuffer,
            buffer: ClearBuffer,
            drawbuffer: i32,
            value: []const u32,
        ) void {
            bindings.clearNamedFramebufferuiv(
                @intFromEnum(framebuffer),
                @intFromEnum(buffer),
                @bitCast(drawbuffer),
                @ptrCast(value.ptr),
            );
        }

        // pub var clearNamedFramebufferfv: *const fn (
        //     framebuffer: Uint,
        //     buffer: Enum,
        //     drawbuffer: Int,
        //     value: [*c]const Float,
        // ) callconv(.c) void = undefined;
        pub fn clearNamedFramebufferfv(
            framebuffer: Framebuffer,
            buffer: ClearBuffer,
            drawbuffer: i32,
            value: []const f32,
        ) void {
            bindings.clearNamedFramebufferfv(
                @intFromEnum(framebuffer),
                @intFromEnum(buffer),
                @bitCast(drawbuffer),
                @ptrCast(value.ptr),
            );
        }

        // pub var clearNamedFramebufferfi: *const fn (
        //     framebuffer: Uint,
        //     buffer: Enum,
        //     drawbuffer: Int,
        //     depth: Float,
        //     stencil: Int,
        // ) callconv(.c) void = undefined;
        pub fn clearNamedFramebufferfi(
            framebuffer: Framebuffer,
            buffer: ClearBufferDepthStencil,
            drawbuffer: i32,
            depth: f32,
            stencil: i32,
        ) void {
            bindings.clearNamedFramebufferfi(
                @intFromEnum(framebuffer),
                @intFromEnum(buffer),
                @bitCast(drawbuffer),
                depth,
                @bitCast(stencil),
            );
        }

        // pub var blitNamedFramebuffer: *const fn (
        //     readFramebuffer: Uint,
        //     drawFramebuffer: Uint,
        //     srcX0: Int,
        //     srcY0: Int,
        //     srcX1: Int,
        //     srcY1: Int,
        //     dstX0: Int,
        //     dstY0: Int,
        //     dstX1: Int,
        //     dstY1: Int,
        //     mask: Bitfield,
        //     filter: Enum,
        // ) callconv(.c) void = undefined;
        pub fn blitNamedFramebuffer(
            readFramebuffer: Framebuffer,
            drawFramebuffer: Framebuffer,
            srcX0: i32,
            srcY0: i32,
            srcX1: i32,
            srcY1: i32,
            dstX0: i32,
            dstY0: i32,
            dstX1: i32,
            dstY1: i32,
            mask: ColorMask,
            filter: Filter,
        ) void {
            bindings.blitNamedFramebuffer(
                @intFromEnum(readFramebuffer),
                @intFromEnum(drawFramebuffer),
                @bitCast(srcX0),
                @bitCast(srcY0),
                @bitCast(srcX1),
                @bitCast(srcY1),
                @bitCast(dstX0),
                @bitCast(dstY0),
                @bitCast(dstX1),
                @bitCast(dstY1),
                @bitCast(mask),
                @intFromEnum(filter),
            );
        }

        // pub var checkNamedFramebufferStatus: *const fn (
        //     framebuffer: Uint,
        //     target: Enum,
        // ) callconv(.c) Enum = undefined;
        pub fn checkNamedFramebufferStatus(
            framebuffer: Framebuffer,
            target: FramebufferTarget,
        ) FramebufferStatus {
            return @enumFromInt(bindings.checkNamedFramebufferStatus(
                @intFromEnum(framebuffer),
                @intFromEnum(target),
            ));
        }

        // pub var getNamedFramebufferParameteriv: *const fn (
        //     framebuffer: Uint,
        //     pname: Enum,
        //     param: [*c]Int,
        // ) callconv(.c) void = undefined;
        pub fn getNamedFramebufferParameteriv(
            framebuffer: Framebuffer,
            pname: GetFramebufferParameter,
            params: []i32,
        ) void {
            bindings.getNamedFramebufferParameteriv(
                @intFromEnum(framebuffer),
                @intFromEnum(pname),
                @ptrCast(params.ptr),
            );
        }

        // pub var getNamedFramebufferAttachmentParameteriv: *const fn (
        //     framebuffer: Uint,
        //     attachment: Enum,
        //     pname: Enum,
        //     params: [*c]Int,
        // ) callconv(.c) void = undefined;
        pub fn getNamedFramebufferAttachmentParameteriv(
            framebuffer: Framebuffer,
            attachment: FramebufferAttachmentDefault,
            pname: FramebufferAttachmentParameter,
            params: []i32,
        ) void {
            bindings.getNamedFramebufferAttachmentParameteriv(
                @intFromEnum(framebuffer),
                @intFromEnum(attachment),
                @intFromEnum(pname),
                @ptrCast(params.ptr),
            );
        }

        // pub var createRenderbuffers: *const fn (
        //     n: Sizei,
        //     renderbuffers: [*c]Uint,
        // ) callconv(.c) void = undefined;
        pub fn createRenderbuffer(ptr: *Renderbuffer) void {
            bindings.createRenderbuffers(1, @ptrCast(ptr));
        }
        pub fn createRenderbuffers(renderbuffers: []Renderbuffer) void {
            bindings.createRenderbuffers(
                @intCast(renderbuffers.len),
                @ptrCast(renderbuffers.ptr),
            );
        }

        // pub var namedRenderbufferStorage: *const fn (
        //     renderbuffer: Uint,
        //     internalformat: Enum,
        //     width: Sizei,
        //     height: Sizei,
        // ) callconv(.c) void = undefined;
        pub fn namedRenderbufferStorage(
            renderbuffer: Renderbuffer,
            internal_format: InternalFormat,
            width: u32,
            height: u32,
        ) void {
            bindings.namedRenderbufferStorage(
                @intFromEnum(renderbuffer),
                @intFromEnum(internal_format),
                @bitCast(width),
                @bitCast(height),
            );
        }

        // pub var namedRenderbufferStorageMultisample: *const fn (
        //     renderbuffer: Uint,
        //     samples: Sizei,
        //     internalformat: Enum,
        //     width: Sizei,
        //     height: Sizei,
        // ) callconv(.c) void = undefined;
        pub fn namedRenderbufferStorageMultisample(
            renderbuffer: Renderbuffer,
            samples: u32,
            internalformat: InternalFormat,
            width: u32,
            height: u32,
        ) void {
            bindings.namedRenderbufferStorageMultisample(
                @intFromEnum(renderbuffer),
                @bitCast(samples),
                @intFromEnum(internalformat),
                @bitCast(width),
                @bitCast(height),
            );
        }

        // pub var getNamedRenderbufferParameteriv: *const fn (
        //     renderbuffer: Uint,
        //     pname: Enum,
        //     params: [*c]Int,
        // ) callconv(.c) void = undefined;
        pub fn getNamedRenderbufferParameteriv(
            renderbuffer: Renderbuffer,
            pname: RenderbufferParameter,
            params: []i32,
        ) void {
            bindings.getNamedRenderbufferParameteriv(
                @intFromEnum(renderbuffer),
                @intFromEnum(pname),
                @ptrCast(params.ptr),
            );
        }

        pub fn createTexture(target: TextureTarget, ptr: *Texture) void {
            bindings.createTextures(@intFromEnum(target), 1, @ptrCast(ptr));
        }
        pub fn createTextures(target: TextureTarget, textures: []Texture) void {
            bindings.createTextures(@intFromEnum(target), @intCast(textures.len), @ptrCast(textures.ptr));
        }

        // pub var textureBuffer: *const fn (
        //     texture: Uint,
        //     internalformat: Enum,
        //     buffer: Uint,
        // ) callconv(.c) void = undefined;
        pub fn textureBuffer(
            texture: Texture,
            internalformat: TextureInternalFormat,
            buffer: Buffer,
        ) void {
            bindings.textureBuffer(
                @intFromEnum(texture),
                @intFromEnum(internalformat),
                @intFromEnum(buffer),
            );
        }

        // pub var textureBufferRange: *const fn (
        //     texture: Uint,
        //     internalformat: Enum,
        //     buffer: Uint,
        //     offset: Intptr,
        //     size: Sizeiptr,
        // ) callconv(.c) void = undefined;
        pub fn textureBufferRange(
            texture: Texture,
            internalformat: TextureInternalFormat,
            buffer: Buffer,
            offset: usize,
            size: usize,
        ) void {
            bindings.textureBufferRange(
                @intFromEnum(texture),
                @intFromEnum(internalformat),
                @intFromEnum(buffer),
                @bitCast(offset),
                @bitCast(size),
            );
        }

        // pub var textureStorage1D: *const fn (
        //     texture: Uint,
        //     levels: Sizei,
        //     internalformat: Enum,
        //     width: Sizei,
        // ) callconv(.c) void = undefined;
        pub fn textureStorage1D(
            texture: Texture,
            levels: i32,
            internalformat: InternalFormat,
            width: i32,
        ) void {
            bindings.textureStorage1D(
                @intFromEnum(texture),
                @bitCast(levels),
                @intFromEnum(internalformat),
                @bitCast(width),
            );
        }

        pub fn textureStorage2D(texture: Texture, levels: u32, internal_format: InternalFormat, width: u32, height: u32) void {
            bindings.textureStorage2D(@intFromEnum(texture), @intCast(levels), @intFromEnum(internal_format), @intCast(width), @intCast(height));
        }

        // pub var textureStorage3D: *const fn (
        //     texture: Uint,
        //     levels: Sizei,
        //     internalformat: Enum,
        //     width: Sizei,
        //     height: Sizei,
        //     depth: Sizei,
        // ) callconv(.c) void = undefined;
        pub fn textureStorage3D(
            texture: Texture,
            levels: i32,
            internalformat: InternalFormat,
            width: i32,
            height: i32,
            depth: i32,
        ) void {
            bindings.textureStorage3D(
                @intFromEnum(texture),
                @bitCast(levels),
                @intFromEnum(internalformat),
                @bitCast(width),
                @bitCast(height),
                @bitCast(depth),
            );
        }

        // pub var textureStorage2DMultisample: *const fn (
        //     texture: Uint,
        //     samples: Sizei,
        //     internalformat: Enum,
        //     width: Sizei,
        //     height: Sizei,
        //     fixedsamplelocations: Boolean,
        // ) callconv(.c) void = undefined;
        pub fn textureStorage2DMultisample(
            texture: Texture,
            samples: i32,
            internalformat: InternalFormat,
            width: i32,
            height: i32,
            fixedsamplelocations: bool,
        ) void {
            bindings.textureStorage2DMultisample(
                @intFromEnum(texture),
                @bitCast(samples),
                @intFromEnum(internalformat),
                @bitCast(width),
                @bitCast(height),
                @intFromBool(fixedsamplelocations),
            );
        }

        // pub var textureStorage3DMultisample: *const fn (
        //     texture: Uint,
        //     samples: Sizei,
        //     internalformat: Enum,
        //     width: Sizei,
        //     height: Sizei,
        //     depth: Sizei,
        //     fixedsamplelocations: Boolean,
        // ) callconv(.c) void = undefined;
        pub fn textureStorage3DMultisample(
            texture: Texture,
            samples: i32,
            internalformat: InternalFormat,
            width: i32,
            height: i32,
            depth: i32,
            fixedsamplelocations: bool,
        ) void {
            bindings.textureStorage3DMultisample(
                @intFromEnum(texture),
                @bitCast(samples),
                @intFromEnum(internalformat),
                @bitCast(width),
                @bitCast(height),
                @bitCast(depth),
                @intFromBool(fixedsamplelocations),
            );
        }

        // pub var textureSubImage1D: *const fn (
        //     texture: Uint,
        //     level: Int,
        //     xoffset: Int,
        //     width: Sizei,
        //     format: Enum,
        //     type: Enum,
        //     pixels: ?*const anyopaque,
        // ) callconv(.c) void = undefined;
        pub fn textureSubImage1D(
            texture: Texture,
            level: i32,
            xoffset: i32,
            width: u32,
            format: PixelFormat,
            pixel_type: PixelType,
            data: ?[*]const u8,
        ) void {
            bindings.textureSubImage1D(
                @intFromEnum(texture),
                @bitCast(level),
                @bitCast(xoffset),
                @bitCast(width),
                @intFromEnum(format),
                @intFromEnum(pixel_type),
                @ptrCast(data),
            );
        }

        // pub var textureSubImage2D: *const fn (
        //     texture: Uint,
        //     level: Int,
        //     xoffset: Int,
        //     yoffset: Int,
        //     width: Sizei,
        //     height: Sizei,
        //     format: Enum,
        //     type: Enum,
        //     pixels: ?*const anyopaque,
        // ) callconv(.c) void = undefined;
        pub fn textureSubImage2D(
            texture: Texture,
            level: i32,
            xoffset: i32,
            yoffset: i32,
            width: u32,
            height: u32,
            format: PixelFormat,
            pixel_type: PixelType,
            data: ?[*]const u8,
        ) void {
            bindings.textureSubImage2D(
                @intFromEnum(texture),
                @bitCast(level),
                @bitCast(xoffset),
                @bitCast(yoffset),
                @bitCast(width),
                @bitCast(height),
                @intFromEnum(format),
                @intFromEnum(pixel_type),
                @ptrCast(data),
            );
        }

        // pub var textureSubImage3D: *const fn (
        //     texture: Uint,
        //     level: Int,
        //     xoffset: Int,
        //     yoffset: Int,
        //     zoffset: Int,
        //     width: Sizei,
        //     height: Sizei,
        //     depth: Sizei,
        //     format: Enum,
        //     type: Enum,
        //     pixels: ?*const anyopaque,
        // ) callconv(.c) void = undefined;
        pub fn textureSubImage3D(
            texture: Texture,
            level: i32,
            xoffset: i32,
            yoffset: i32,
            zoffset: i32,
            width: u32,
            height: u32,
            depth: u32,
            format: PixelFormat,
            pixel_type: PixelType,
            data: ?[*]const u8,
        ) void {
            bindings.textureSubImage3D(
                @intFromEnum(texture),
                @bitCast(level),
                @bitCast(xoffset),
                @bitCast(yoffset),
                @bitCast(zoffset),
                @bitCast(width),
                @bitCast(height),
                @bitCast(depth),
                @intFromEnum(format),
                @intFromEnum(pixel_type),
                @ptrCast(data),
            );
        }

        // pub var compressedTextureSubImage1D: *const fn (
        //     texture: Uint,
        //     level: Int,
        //     xoffset: Int,
        //     width: Sizei,
        //     format: Enum,
        //     imageSize: Sizei,
        //     data: ?*const anyopaque,
        // ) callconv(.c) void = undefined;
        pub fn compressedTextureSubImage1D(
            texture: Texture,
            level: i32,
            xoffset: i32,
            width: u32,
            format: CompressedPixelFormat,
            data: []const u8,
        ) void {
            bindings.compressedTextureSubImage1D(
                @intFromEnum(texture),
                @bitCast(level),
                @bitCast(xoffset),
                @bitCast(width),
                @intFromEnum(format),
                @intCast(data.len),
                @ptrCast(data.ptr),
            );
        }

        // pub var compressedTextureSubImage2D: *const fn (
        //     texture: Uint,
        //     level: Int,
        //     xoffset: Int,
        //     yoffset: Int,
        //     width: Sizei,
        //     height: Sizei,
        //     format: Enum,
        //     imageSize: Sizei,
        //     data: ?*const anyopaque,
        // ) callconv(.c) void = undefined;
        pub fn compressedTextureSubImage2D(
            texture: Texture,
            level: i32,
            xoffset: i32,
            yoffset: i32,
            width: u32,
            height: u32,
            format: CompressedPixelFormat,
            data: []const u8,
        ) void {
            bindings.compressedTextureSubImage2D(
                @intFromEnum(texture),
                @bitCast(level),
                @bitCast(xoffset),
                @bitCast(yoffset),
                @bitCast(width),
                @bitCast(height),
                @intFromEnum(format),
                @intCast(data.len),
                @ptrCast(data.ptr),
            );
        }

        // pub var compressedTextureSubImage3D: *const fn (
        //     texture: Uint,
        //     level: Int,
        //     xoffset: Int,
        //     yoffset: Int,
        //     zoffset: Int,
        //     width: Sizei,
        //     height: Sizei,
        //     depth: Sizei,
        //     format: Enum,
        //     imageSize: Sizei,
        //     data: ?*const anyopaque,
        // ) callconv(.c) void = undefined;
        pub fn compressedTextureSubImage3D(
            texture: Texture,
            level: i32,
            xoffset: i32,
            yoffset: i32,
            zoffset: i32,
            width: u32,
            height: u32,
            depth: u32,
            format: CompressedPixelFormat,
            data: []const u8,
        ) void {
            bindings.compressedTextureSubImage3D(
                @intFromEnum(texture),
                @bitCast(level),
                @bitCast(xoffset),
                @bitCast(yoffset),
                @bitCast(zoffset),
                @bitCast(width),
                @bitCast(height),
                @bitCast(depth),
                @intFromEnum(format),
                @intCast(data.len),
                @ptrCast(data.ptr),
            );
        }

        // pub var copyTextureSubImage1D: *const fn (
        //     texture: Uint,
        //     level: Int,
        //     xoffset: Int,
        //     x: Int,
        //     y: Int,
        //     width: Sizei,
        // ) callconv(.c) void = undefined;
        pub fn copyTextureSubImage1D(
            texture: Texture,
            level: i32,
            xoffset: i32,
            x: i32,
            y: i32,
            width: u32,
        ) void {
            bindings.copyTextureSubImage1D(
                @intFromEnum(texture),
                @bitCast(level),
                @bitCast(xoffset),
                @bitCast(x),
                @bitCast(y),
                @bitCast(width),
            );
        }

        // pub var copyTextureSubImage2D: *const fn (
        //     texture: Uint,
        //     level: Int,
        //     xoffset: Int,
        //     yoffset: Int,
        //     x: Int,
        //     y: Int,
        //     width: Sizei,
        //     height: Sizei,
        // ) callconv(.c) void = undefined;
        pub fn copyTextureSubImage2D(
            texture: Texture,
            level: i32,
            xoffset: i32,
            yoffset: i32,
            x: i32,
            y: i32,
            width: u32,
            height: u32,
        ) void {
            bindings.copyTextureSubImage2D(
                @intFromEnum(texture),
                @bitCast(level),
                @bitCast(xoffset),
                @bitCast(yoffset),
                @bitCast(x),
                @bitCast(y),
                @bitCast(width),
                @bitCast(height),
            );
        }

        // pub var copyTextureSubImage3D: *const fn (
        //     texture: Uint,
        //     level: Int,
        //     xoffset: Int,
        //     yoffset: Int,
        //     zoffset: Int,
        //     x: Int,
        //     y: Int,
        //     width: Sizei,
        //     height: Sizei,
        // ) callconv(.c) void = undefined;
        pub fn copyTextureSubImage3D(
            texture: Texture,
            level: i32,
            xoffset: i32,
            yoffset: i32,
            zoffset: i32,
            x: i32,
            y: i32,
            width: u32,
            height: u32,
        ) void {
            bindings.copyTextureSubImage3D(
                @intFromEnum(texture),
                @bitCast(level),
                @bitCast(xoffset),
                @bitCast(yoffset),
                @bitCast(zoffset),
                @bitCast(x),
                @bitCast(y),
                @bitCast(width),
                @bitCast(height),
            );
        }

        // pub var textureParameterf: *const fn (
        //     texture: Uint,
        //     pname: Enum,
        //     param: Float,
        // ) callconv(.c) void = undefined;
        pub fn textureParameterf(
            texture: Texture,
            pname: TexParameter,
            param: f32,
        ) void {
            bindings.textureParameterf(
                @intFromEnum(texture),
                @intFromEnum(pname),
                param,
            );
        }

        // pub var textureParameterfv: *const fn (
        //     texture: Uint,
        //     pname: Enum,
        //     param: [*c]const Float,
        // ) callconv(.c) void = undefined;
        pub fn textureParameterfv(
            texture: Texture,
            pname: TexParameter,
            params: []const f32,
        ) void {
            bindings.textureParameterfv(
                @intFromEnum(texture),
                @intFromEnum(pname),
                @ptrCast(params.ptr),
            );
        }

        // pub var textureParameteri: *const fn (
        //     texture: Uint,
        //     pname: Enum,
        //     param: Int,
        // ) callconv(.c) void = undefined;
        pub fn textureParameteri(
            texture: Texture,
            pname: TexParameter,
            param: i32,
        ) void {
            bindings.textureParameteri(
                @intFromEnum(texture),
                @intFromEnum(pname),
                @bitCast(param),
            );
        }

        // pub var textureParameterIiv: *const fn (
        //     texture: Uint,
        //     pname: Enum,
        //     params: [*c]const Int,
        // ) callconv(.c) void = undefined;
        pub fn textureParameterIiv(
            texture: Texture,
            pname: TexParameter,
            params: []const i32,
        ) void {
            bindings.textureParameterIiv(
                @intFromEnum(texture),
                @intFromEnum(pname),
                @ptrCast(params.ptr),
            );
        }

        // pub var textureParameterIuiv: *const fn (
        //     texture: Uint,
        //     pname: Enum,
        //     params: [*c]const Uint,
        // ) callconv(.c) void = undefined;
        pub fn textureParameterIuiv(
            texture: Texture,
            pname: TexParameter,
            params: []const u32,
        ) void {
            bindings.textureParameterIuiv(
                @intFromEnum(texture),
                @intFromEnum(pname),
                @ptrCast(params.ptr),
            );
        }

        // pub var textureParameteriv: *const fn (
        //     texture: Uint,
        //     pname: Enum,
        //     param: [*c]const Int,
        // ) callconv(.c) void = undefined;
        pub fn textureParameteriv(
            texture: Texture,
            pname: TexParameter,
            params: []const i32,
        ) void {
            bindings.textureParameteriv(
                @intFromEnum(texture),
                @intFromEnum(pname),
                @ptrCast(params.ptr),
            );
        }

        // pub var generateTextureMipmap: *const fn (
        //     texture: Uint,
        // ) callconv(.c) void = undefined;
        pub fn generateTextureMipmap(texture: Texture) void {
            bindings.generateTextureMipmap(@intFromEnum(texture));
        }

        // pub var bindTextureUnit: *const fn (
        //     unit: Uint,
        //     texture: Uint,
        // ) callconv(.c) void = undefined;
        pub fn bindTextureUnit(unit: u32, texture: Texture) void {
            bindings.bindTextureUnit(@bitCast(unit), @intFromEnum(texture));
        }

        // pub var getTextureImage: *const fn (
        //     texture: Uint,
        //     level: Int,
        //     format: Enum,
        //     type: Enum,
        //     bufSize: Sizei,
        //     pixels: ?*anyopaque,
        // ) callconv(.c) void = undefined;
        pub fn getTextureImage(
            texture: Texture,
            level: u32,
            format: PixelFormat,
            pixel_type: PixelType,
            pixels: []u8,
        ) void {
            bindings.getTextureImage(
                @intFromEnum(texture),
                @bitCast(level),
                @intFromEnum(format),
                @intFromEnum(pixel_type),
                @intCast(pixels.len),
                @ptrCast(pixels.ptr),
            );
        }

        // pub var getCompressedTextureImage: *const fn (
        //     texture: Uint,
        //     level: Int,
        //     bufSize: Sizei,
        //     pixels: ?*anyopaque,
        // ) callconv(.c) void = undefined;
        pub fn getCompressedTextureImage(
            texture: Texture,
            level: i32,
            pixels: []u8,
        ) void {
            bindings.getCompressedTextureImage(
                @intFromEnum(texture),
                @bitCast(level),
                @intCast(pixels.len),
                @ptrCast(pixels.ptr),
            );
        }

        // pub var getTextureLevelParameterfv: *const fn (
        //     texture: Uint,
        //     level: Int,
        //     pname: Enum,
        //     params: [*c]Float,
        // ) callconv(.c) void = undefined;
        pub fn getTextureLevelParameterfv(
            texture: Texture,
            level: u32,
            pname: GetTexLevelParameter,
            params: []f32,
        ) void {
            bindings.getTextureLevelParameterfv(
                @intFromEnum(texture),
                @bitCast(level),
                @intFromEnum(pname),
                @ptrCast(params.ptr),
            );
        }

        // pub var getTextureLevelParameteriv: *const fn (
        //     texture: Uint,
        //     level: Int,
        //     pname: Enum,
        //     params: [*c]Int,
        // ) callconv(.c) void = undefined;
        pub fn getTextureLevelParameteriv(
            texture: Texture,
            level: u32,
            pname: GetTexLevelParameter,
            params: []i32,
        ) void {
            bindings.getTextureLevelParameteriv(
                @intFromEnum(texture),
                @bitCast(level),
                @intFromEnum(pname),
                @ptrCast(params.ptr),
            );
        }

        // pub var getTextureParameterfv: *const fn (
        //     texture: Uint,
        //     pname: Enum,
        //     params: [*c]Float,
        // ) callconv(.c) void = undefined;
        pub fn getTextureParameterfv(
            texture: Texture,
            pname: GetTexParameter,
            params: []f32,
        ) void {
            bindings.getTextureParameterfv(
                @intFromEnum(texture),
                @intFromEnum(pname),
                @ptrCast(params.ptr),
            );
        }

        // pub var getTextureParameterIiv: *const fn (
        //     texture: Uint,
        //     pname: Enum,
        //     params: [*c]Int,
        // ) callconv(.c) void = undefined;
        pub fn getTextureParameterIiv(
            texture: Texture,
            pname: GetTexParameter,
            params: []i32,
        ) void {
            bindings.getTextureParameterIiv(
                @intFromEnum(texture),
                @intFromEnum(pname),
                @ptrCast(params.ptr),
            );
        }

        // pub var getTextureParameterIuiv: *const fn (
        //     texture: Uint,
        //     pname: Enum,
        //     params: [*c]Uint,
        // ) callconv(.c) void = undefined;
        pub fn getTextureParameterIuiv(
            texture: Texture,
            pname: GetTexParameter,
            params: []u32,
        ) void {
            bindings.getTextureParameterIuiv(
                @intFromEnum(texture),
                @intFromEnum(pname),
                @ptrCast(params.ptr),
            );
        }

        // pub var getTextureParameteriv: *const fn (
        //     texture: Uint,
        //     pname: Enum,
        //     params: [*c]Int,
        // ) callconv(.c) void = undefined;
        pub fn getTextureParameteriv(
            texture: Texture,
            pname: GetTexParameter,
            params: []i32,
        ) void {
            bindings.getTextureParameteriv(
                @intFromEnum(texture),
                @intFromEnum(pname),
                @ptrCast(params.ptr),
            );
        }

        // pub var createVertexArrays: *const fn (
        //     n: Sizei,
        //     arrays: [*c]Uint,
        // ) callconv(.c) void = undefined;
        pub fn createVertexArray(ptr: *VertexArrayObject) void {
            bindings.createVertexArrays(1, @ptrCast(ptr));
        }
        pub fn createVertexArrays(arrays: []VertexArrayObject) void {
            bindings.createVertexArrays(
                @intCast(arrays.len),
                @ptrCast(arrays.ptr),
            );
        }

        // pub var disableVertexArrayAttrib: *const fn (
        //     vaobj: Uint,
        //     index: Uint,
        // ) callconv(.c) void = undefined;
        pub fn disableVertexArrayAttrib(
            vaobj: VertexArrayObject,
            location: VertexAttribLocation,
        ) void {
            bindings.disableVertexArrayAttrib(
                @intFromEnum(vaobj),
                @intFromEnum(location),
            );
        }

        // pub var enableVertexArrayAttrib: *const fn (
        //     vaobj: Uint,
        //     index: Uint,
        // ) callconv(.c) void = undefined;
        pub fn enableVertexArrayAttrib(
            vaobj: VertexArrayObject,
            location: VertexAttribLocation,
        ) void {
            bindings.enableVertexArrayAttrib(
                @intFromEnum(vaobj),
                @intFromEnum(location),
            );
        }

        // pub var vertexArrayElementBuffer: *const fn (
        //     vaobj: Uint,
        //     buffer: Uint,
        // ) callconv(.c) void = undefined;
        pub fn vertexArrayElementBuffer(
            vaobj: VertexArrayObject,
            buffer: Buffer,
        ) void {
            bindings.vertexArrayElementBuffer(
                @intFromEnum(vaobj),
                @intFromEnum(buffer),
            );
        }

        // pub var vertexArrayVertexBuffer: *const fn (
        //     vaobj: Uint,
        //     bindingindex: Uint,
        //     buffer: Uint,
        //     offset: Intptr,
        //     stride: Sizei,
        // ) callconv(.c) void = undefined;
        pub fn vertexArrayVertexBuffer(
            vaobj: VertexArrayObject,
            bindingindex: u32,
            buffer: Buffer,
            offset: usize,
            stride: i32,
        ) void {
            bindings.vertexArrayVertexBuffer(
                @intFromEnum(vaobj),
                @bitCast(bindingindex),
                @intFromEnum(buffer),
                @bitCast(offset),
                @bitCast(stride),
            );
        }

        // pub var vertexArrayVertexBuffers: *const fn (
        //     vaobj: Uint,
        //     first: Uint,
        //     count: Sizei,
        //     buffers: [*c]const Uint,
        //     offsets: [*c]const Intptr,
        //     strides: [*c]const Sizei,
        // ) callconv(.c) void = undefined;
        pub fn vertexArrayVertexBuffers(
            vaobj: VertexArrayObject,
            first: u32,
            buffers: []const Buffer,
            offsets: []const usize,
            strides: []const i32,
        ) void {
            assert(buffers.len == offsets.len);
            assert(buffers.len == strides.len);
            bindings.vertexArrayVertexBuffers(
                @intFromEnum(vaobj),
                @bitCast(first),
                @intCast(buffers.len),
                @ptrCast(buffers.ptr),
                @ptrCast(offsets.ptr),
                @ptrCast(strides.ptr),
            );
        }

        // pub var vertexArrayAttribBinding: *const fn (
        //     vaobj: Uint,
        //     attribindex: Uint,
        //     bindingindex: Uint,
        // ) callconv(.c) void = undefined;
        pub fn vertexArrayAttribBinding(
            vaobj: VertexArrayObject,
            location: VertexAttribLocation,
            bindingindex: u32,
        ) void {
            bindings.vertexArrayAttribBinding(
                @intFromEnum(vaobj),
                @intFromEnum(location),
                @bitCast(bindingindex),
            );
        }

        // pub var vertexArrayAttribFormat: *const fn (
        //     vaobj: Uint,
        //     attribindex: Uint,
        //     size: Int,
        //     type: Enum,
        //     normalized: Boolean,
        //     relativeoffset: Uint,
        // ) callconv(.c) void = undefined;
        pub fn vertexArrayAttribFormat(
            vaobj: VertexArrayObject,
            attribindex: VertexAttribLocation,
            size: i32,
            attrib_type: VertexAttribType,
            normalized: bool,
            relativeoffset: u32,
        ) void {
            bindings.vertexArrayAttribFormat(
                @intFromEnum(vaobj),
                @intFromEnum(attribindex),
                @bitCast(size),
                @intFromEnum(attrib_type),
                @intFromBool(normalized),
                @bitCast(relativeoffset),
            );
        }

        // pub var vertexArrayAttribIFormat: *const fn (
        //     vaobj: Uint,
        //     attribindex: Uint,
        //     size: Int,
        //     type: Enum,
        //     relativeoffset: Uint,
        // ) callconv(.c) void = undefined;
        pub fn vertexArrayAttribIFormat(
            vaobj: VertexArrayObject,
            attribindex: VertexAttribLocation,
            size: i32,
            attrib_type: VertexAttribIntegerType,
            relativeoffset: u32,
        ) void {
            bindings.vertexArrayAttribIFormat(
                @intFromEnum(vaobj),
                @intFromEnum(attribindex),
                @bitCast(size),
                @intFromEnum(attrib_type),
                @bitCast(relativeoffset),
            );
        }

        // pub var vertexArrayAttribLFormat: *const fn (
        //     vaobj: Uint,
        //     attribindex: Uint,
        //     size: Int,
        //     type: Enum,
        //     relativeoffset: Uint,
        // ) callconv(.c) void = undefined;
        pub fn vertexArrayAttribLFormat(
            vaobj: VertexArrayObject,
            attribindex: VertexAttribLocation,
            size: i32,
            attrib_type: VertexAttribDoubleType,
            relativeoffset: u32,
        ) void {
            bindings.vertexArrayAttribLFormat(
                @intFromEnum(vaobj),
                @intFromEnum(attribindex),
                @bitCast(size),
                @intFromEnum(attrib_type),
                @bitCast(relativeoffset),
            );
        }

        // pub var vertexArrayBindingDivisor: *const fn (
        //     vaobj: Uint,
        //     bindingindex: Uint,
        //     divisor: Uint,
        // ) callconv(.c) void = undefined;
        pub fn vertexArrayBindingDivisor(
            vaobj: VertexArrayObject,
            bindingindex: u32,
            divisor: u32,
        ) void {
            bindings.vertexArrayBindingDivisor(
                @intFromEnum(vaobj),
                @bitCast(bindingindex),
                @bitCast(divisor),
            );
        }

        // pub var getVertexArrayiv: *const fn (
        //     vaobj: Uint,
        //     pname: Enum,
        //     param: [*c]Int,
        // ) callconv(.c) void = undefined;
        pub fn getVertexArrayiv(
            vaobj: VertexArrayObject,
            pname: VertexArrayIntegerParameter,
            param: []i32,
        ) void {
            bindings.getVertexArrayiv(
                @intFromEnum(vaobj),
                @intFromEnum(pname),
                @ptrCast(param.ptr),
            );
        }

        // pub var getVertexArrayIndexediv: *const fn (
        //     vaobj: Uint,
        //     index: Uint,
        //     pname: Enum,
        //     param: [*c]Int,
        // ) callconv(.c) void = undefined;
        pub fn getVertexArrayIndexediv(
            vaobj: VertexArrayObject,
            index: u32,
            pname: IndexedVertexArrayIntegerParameter,
            param: []i32,
        ) void {
            bindings.getVertexArrayIndexediv(
                @intFromEnum(vaobj),
                @bitCast(index),
                @intFromEnum(pname),
                @ptrCast(param.ptr),
            );
        }

        // pub var getVertexArrayIndexed64iv: *const fn (
        //     vaobj: Uint,
        //     index: Uint,
        //     pname: Enum,
        //     param: [*c]Int64,
        // ) callconv(.c) void = undefined;
        pub fn getVertexArrayIndexed64iv(
            vaobj: VertexArrayObject,
            index: u32,
            pname: IndexedVertexArrayInt64Parameter,
            param: []i64,
        ) void {
            bindings.getVertexArrayIndexed64iv(
                @intFromEnum(vaobj),
                @bitCast(index),
                @intFromEnum(pname),
                @ptrCast(param.ptr),
            );
        }

        // pub var createSamplers: *const fn (
        //     n: Sizei,
        //     samplers: [*c]Uint,
        // ) callconv(.c) void = undefined;
        pub fn createSampler(ptr: *Sampler) void {
            bindings.createSamplers(1, @ptrCast(ptr));
        }
        pub fn createSamplers(samplers: []Sampler) void {
            bindings.createSamplers(
                @intCast(samplers.len),
                @ptrCast(samplers.ptr),
            );
        }

        // pub var createProgramPipelines: *const fn (
        //     n: Sizei,
        //     pipelines: [*c]Uint,
        // ) callconv(.c) void = undefined;
        pub fn createProgramPipeline(ptr: *ProgramPipeline) void {
            bindings.createProgramPipelines(1, @ptrCast(ptr));
        }
        pub fn createProgramPipelines(pipelines: []ProgramPipeline) void {
            bindings.createProgramPipelines(
                @intCast(pipelines.len),
                @ptrCast(pipelines.ptr),
            );
        }

        // pub var createQueries: *const fn (
        //     target: Enum,
        //     n: Sizei,
        //     ids: [*c]Uint,
        // ) callconv(.c) void = undefined;
        pub fn createQuery(
            target: QueryTargetWithTimestamp,
            ptr: *Query,
        ) void {
            bindings.createQueries(
                @intFromEnum(target),
                1,
                @ptrCast(ptr),
            );
        }
        pub fn createQueries(
            target: QueryTargetWithTimestamp,
            queries: []Query,
        ) void {
            bindings.createQueries(
                @intFromEnum(target),
                @intCast(queries.len),
                @ptrCast(queries.ptr),
            );
        }

        // pub var getQueryBufferObjecti64v: *const fn (
        //     id: Uint,
        //     buffer: Uint,
        //     pname: Enum,
        //     offset: Intptr,
        // ) callconv(.c) void = undefined;
        pub fn getQueryBufferObjecti64v(
            query: Query,
            buffer: Buffer,
            pname: QueryObjectParameter,
            offset: usize,
        ) void {
            bindings.getQueryBufferObjecti64v(
                @intFromEnum(query),
                @intFromEnum(buffer),
                @intFromEnum(pname),
                @bitCast(offset),
            );
        }

        // pub var getQueryBufferObjectiv: *const fn (
        //     id: Uint,
        //     buffer: Uint,
        //     pname: Enum,
        //     offset: Intptr,
        // ) callconv(.c) void = undefined;
        pub fn getQueryBufferObjectiv(
            query: Query,
            buffer: Buffer,
            pname: QueryObjectParameter,
            offset: usize,
        ) void {
            bindings.getQueryBufferObjectiv(
                @intFromEnum(query),
                @intFromEnum(buffer),
                @intFromEnum(pname),
                @bitCast(offset),
            );
        }

        // pub var getQueryBufferObjectui64v: *const fn (
        //     id: Uint,
        //     buffer: Uint,
        //     pname: Enum,
        //     offset: Intptr,
        // ) callconv(.c) void = undefined;
        pub fn getQueryBufferObjectui64v(
            query: Query,
            buffer: Buffer,
            pname: QueryObjectParameter,
            offset: usize,
        ) void {
            bindings.getQueryBufferObjectui64v(
                @intFromEnum(query),
                @intFromEnum(buffer),
                @intFromEnum(pname),
                @bitCast(offset),
            );
        }

        // pub var getQueryBufferObjectuiv: *const fn (
        //     id: Uint,
        //     buffer: Uint,
        //     pname: Enum,
        //     offset: Intptr,
        // ) callconv(.c) void = undefined;
        pub fn getQueryBufferObjectuiv(
            query: Query,
            buffer: Buffer,
            pname: QueryObjectParameter,
            offset: usize,
        ) void {
            bindings.getQueryBufferObjectuiv(
                @intFromEnum(query),
                @intFromEnum(buffer),
                @intFromEnum(pname),
                @bitCast(offset),
            );
        }

        // pub var memoryBarrierByRegion: *const fn (
        //     barriers: Bitfield,
        // ) callconv(.c) void = undefined;
        pub fn memoryBarrierByRegion(barriers: UsedRegionBarriers) void {
            bindings.memoryBarrierByRegion(@bitCast(barriers));
        }

        pub fn getTextureSubImage(texture: Texture, level: i32, xoffset: i32, yoffset: i32, zoffset: i32, width: u32, height: u32, depth: u32, format: PixelFormat, pixel_type: PixelType, buf_size: u32, pixels: ?[*]u8) void {
            bindings.getTextureSubImage(@intFromEnum(texture), level, xoffset, yoffset, zoffset, @intCast(width), @intCast(height), @intCast(depth), @intFromEnum(format), @intFromEnum(pixel_type), @intCast(buf_size), pixels);
        }

        // pub var getCompressedTextureSubImage: *const fn (
        //     texture: Uint,
        //     level: Int,
        //     xoffset: Int,
        //     yoffset: Int,
        //     zoffset: Int,
        //     width: Sizei,
        //     height: Sizei,
        //     depth: Sizei,
        //     bufSize: Sizei,
        //     pixels: ?*anyopaque,
        // ) callconv(.c) void = undefined;
        pub fn getCompressedTextureSubImage(
            texture: Texture,
            level: i32,
            xoffset: i32,
            yoffset: i32,
            zoffset: i32,
            width: u32,
            height: u32,
            depth: u32,
            pixels: []u8,
        ) void {
            bindings.getCompressedTextureSubImage(
                @intFromEnum(texture),
                @bitCast(level),
                @bitCast(xoffset),
                @bitCast(yoffset),
                @bitCast(zoffset),
                @bitCast(width),
                @bitCast(height),
                @bitCast(depth),
                @intCast(pixels.len),
                @ptrCast(pixels.ptr),
            );
        }

        pub fn getGraphicsResetStatus() GraphicsResetStatus {
            return @enumFromInt(bindings.getGraphicsResetStatus());
        }

        // pub var getnCompressedTexImage: *const fn (
        //     target: Enum,
        //     lod: Int,
        //     bufSize: Sizei,
        //     pixels: ?*anyopaque,
        // ) callconv(.c) void = undefined;
        pub fn getnCompressedTexImage(
            target: TexLevelTarget,
            lod: i32,
            pixels: []u8,
        ) void {
            bindings.getnCompressedTexImage(
                @intFromEnum(target),
                @bitCast(lod),
                @intCast(pixels.len),
                @ptrCast(pixels.ptr),
            );
        }

        // pub var getnTexImage: *const fn (
        //     target: Enum,
        //     level: Int,
        //     format: Enum,
        //     type: Enum,
        //     bufSize: Sizei,
        //     pixels: ?*anyopaque,
        // ) callconv(.c) void = undefined;
        pub fn getnTexImage(
            target: TexImageTarget,
            level: u32,
            format: PixelFormat,
            pixel_type: PixelType,
            pixels: []u8,
        ) void {
            bindings.getnTexImage(
                @intFromEnum(target),
                @bitCast(level),
                @intFromEnum(format),
                @intFromEnum(pixel_type),
                @intCast(pixels.len),
                @ptrCast(pixels.ptr),
            );
        }

        // pub var getnUniformdv: *const fn (
        //     program: Uint,
        //     location: Int,
        //     bufSize: Sizei,
        //     params: [*c]Double,
        // ) callconv(.c) void = undefined;
        pub fn getnUniformdv(
            program: Program,
            location: UniformLocation,
            params: []f64,
        ) void {
            assert(program != .invalid);
            assert(location != .invalid);
            bindings.getnUniformdv(
                @intFromEnum(program),
                @intFromEnum(location),
                @intCast(params.len),
                @ptrCast(params.ptr),
            );
        }

        // pub var getnUniformfv: *const fn (
        //     program: Uint,
        //     location: Int,
        //     bufSize: Sizei,
        //     params: [*c]Float,
        // ) callconv(.c) void = undefined;
        pub fn getnUniformfv(
            program: Program,
            location: UniformLocation,
            params: []f32,
        ) void {
            assert(program != .invalid);
            assert(location != .invalid);
            bindings.getnUniformfv(
                @intFromEnum(program),
                @intFromEnum(location),
                @intCast(params.len),
                @ptrCast(params.ptr),
            );
        }

        // pub var getnUniformiv: *const fn (
        //     program: Uint,
        //     location: Int,
        //     bufSize: Sizei,
        //     params: [*c]Int,
        // ) callconv(.c) void = undefined;
        pub fn getnUniformiv(
            program: Program,
            location: UniformLocation,
            params: []i32,
        ) void {
            assert(program != .invalid);
            assert(location != .invalid);
            bindings.getnUniformiv(
                @intFromEnum(program),
                @intFromEnum(location),
                @intCast(params.len),
                @ptrCast(params.ptr),
            );
        }

        // pub var getnUniformuiv: *const fn (
        //     program: Uint,
        //     location: Int,
        //     bufSize: Sizei,
        //     params: [*c]Uint,
        // ) callconv(.c) void = undefined;
        pub fn getnUniformuiv(
            program: Program,
            location: UniformLocation,
            params: []u32,
        ) void {
            assert(program != .invalid);
            assert(location != .invalid);
            bindings.getnUniformuiv(
                @intFromEnum(program),
                @intFromEnum(location),
                @intCast(params.len),
                @ptrCast(params.ptr),
            );
        }

        // pub var readnPixels: *const fn (
        //     x: Int,
        //     y: Int,
        //     width: Sizei,
        //     height: Sizei,
        //     format: Enum,
        //     type: Enum,
        //     bufSize: Sizei,
        //     data: ?*anyopaque,
        // ) callconv(.c) void = undefined;
        pub fn readnPixels(
            x: i32,
            y: i32,
            width: i32,
            height: i32,
            format: PixelFormat,
            pixel_type: PixelType,
            data: []u8,
        ) void {
            bindings.readnPixels(
                @bitCast(x),
                @bitCast(y),
                @bitCast(width),
                @bitCast(height),
                @intFromEnum(format),
                @intFromEnum(pixel_type),
                @intCast(data.len),
                @ptrCast(data.ptr),
            );
        }

        // pub var textureBarrier: *const fn () callconv(.c) void = undefined;
        pub fn textureBarrier() void {
            bindings.textureBarrier();
        }

        //--------------------------------------------------------------------------------------------------
        //
        // OpenGL 4.6 (Core Profile)
        //
        //--------------------------------------------------------------------------------------------------
        pub const SHADER_BINARY_FORMAT_SPIR_V = bindings.SHADER_BINARY_FORMAT_SPIR_V;
        pub const SPIR_V_BINARY = bindings.SPIR_V_BINARY;
        pub const PARAMETER_BUFFER = bindings.PARAMETER_BUFFER;
        pub const PARAMETER_BUFFER_BINDING = bindings.PARAMETER_BUFFER_BINDING;
        pub const CONTEXT_FLAG_NO_ERROR_BIT = bindings.CONTEXT_FLAG_NO_ERROR_BIT;
        pub const VERTICES_SUBMITTED = bindings.VERTICES_SUBMITTED;
        pub const PRIMITIVES_SUBMITTED = bindings.PRIMITIVES_SUBMITTED;
        pub const VERTEX_SHADER_INVOCATIONS = bindings.VERTEX_SHADER_INVOCATIONS;
        pub const TESS_CONTROL_SHADER_PATCHES = bindings.TESS_CONTROL_SHADER_PATCHES;
        pub const TESS_EVALUATION_SHADER_INVOCATIONS = bindings.TESS_EVALUATION_SHADER_INVOCATIONS;
        pub const GEOMETRY_SHADER_PRIMITIVES_EMITTED = bindings.GEOMETRY_SHADER_PRIMITIVES_EMITTED;
        pub const FRAGMENT_SHADER_INVOCATIONS = bindings.FRAGMENT_SHADER_INVOCATIONS;
        pub const COMPUTE_SHADER_INVOCATIONS = bindings.COMPUTE_SHADER_INVOCATIONS;
        pub const CLIPPING_INPUT_PRIMITIVES = bindings.CLIPPING_INPUT_PRIMITIVES;
        pub const CLIPPING_OUTPUT_PRIMITIVES = bindings.CLIPPING_OUTPUT_PRIMITIVES;
        pub const POLYGON_OFFSET_CLAMP = bindings.POLYGON_OFFSET_CLAMP;
        pub const SPIR_V_EXTENSIONS = bindings.SPIR_V_EXTENSIONS;
        pub const NUM_SPIR_V_EXTENSIONS = bindings.NUM_SPIR_V_EXTENSIONS;
        pub const TEXTURE_MAX_ANISOTROPY = bindings.TEXTURE_MAX_ANISOTROPY;
        pub const MAX_TEXTURE_MAX_ANISOTROPY = bindings.MAX_TEXTURE_MAX_ANISOTROPY;
        pub const TRANSFORM_FEEDBACK_OVERFLOW = bindings.TRANSFORM_FEEDBACK_OVERFLOW;
        pub const TRANSFORM_FEEDBACK_STREAM_OVERFLOW = bindings.TRANSFORM_FEEDBACK_STREAM_OVERFLOW;

        pub fn multiDrawArraysIndirectCount(
            mode: PrimitiveType,
            indirect: *const anyopaque,
            drawcount: Intptr,
            maxdrawcount: u32,
            stride: u32,
        ) void {
            bindings.multiDrawArraysIndirectCount(
                @intFromEnum(mode),
                indirect,
                drawcount,
                @as(Sizei, @bitCast(maxdrawcount)),
                @as(Sizei, @bitCast(stride)),
            );
        }

        pub fn multiDrawElementsIndirectCount(
            mode: PrimitiveType,
            index_type: DrawIndicesType,
            indirect: *const anyopaque,
            drawcount: Intptr,
            maxdrawcount: u32,
            stride: u32,
        ) void {
            bindings.multiDrawElementsIndirectCount(
                @intFromEnum(mode),
                @intFromEnum(index_type),
                indirect,
                drawcount,
                @as(Sizei, @bitCast(maxdrawcount)),
                @as(Sizei, @bitCast(stride)),
            );
        }

        pub fn polygonOffsetClamp(factor: f32, units: f32, clamp: f32) void {
            bindings.polygonOffsetClamp(factor, units, clamp);
        }

        pub fn specializeShader(
            shader: Shader,
            entry_point: [:0]const u8,
            constant_indices: []const u32,
            constant_values: []const u32,
        ) void {
            assert(constant_indices.len == constant_values.len);
            bindings.specializeShader(
                @intFromEnum(shader),
                @ptrCast(entry_point.ptr),
                @intCast(constant_indices.len),
                constant_indices.ptr,
                constant_values.ptr,
            );
        }

        //------------------------------------------------------------------------------------------
        //
        // OpenGL ES 1.0
        //
        //------------------------------------------------------------------------------------------
        // pub var clearDepthf: *const fn (depth: Float) callconv(.c) void = undefined;
        pub fn clearDepthf(depth: f32) void {
            bindings.clearDepthf(depth);
        }

        // pub var depthRangef: *const fn (n: Clampf, f: Clampf) callconv(.c) void = undefined;
        pub fn depthRangef(n: f32, f: f32) void {
            bindings.depthRangef(n, f);
        }

        //------------------------------------------------------------------------------------------
        //
        // OpenGL ES 2.0
        //
        //------------------------------------------------------------------------------------------
        pub const FRAMEBUFFER_INCOMPLETE_DIMENSIONS = bindings.FRAMEBUFFER_INCOMPLETE_DIMENSIONS;

        //------------------------------------------------------------------------------------------
        //
        // OES_vertex_array_object
        //
        //------------------------------------------------------------------------------------------
        pub const VERTEX_ARRAY_BINDING_OES = bindings.VERTEX_ARRAY_BINDING_OES;
    };
}
