// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: ClientMessage.proto

// This CPP symbol can be defined to use imports that match up to the framework
// imports needed when using CocoaPods.
#if !defined(GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS)
 #define GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS 0
#endif

#if GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS
 #import <Protobuf/GPBProtocolBuffers_RuntimeSupport.h>
#else
 #import "GPBProtocolBuffers_RuntimeSupport.h"
#endif

#import <stdatomic.h>

#import "ClientMessage.pbobjc.h"
// @@protoc_insertion_point(imports)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

#pragma mark - ClientMessageRoot

@implementation ClientMessageRoot

// No extensions in the file and no imports, so no need to generate
// +extensionRegistry.

@end

#pragma mark - ClientMessageRoot_FileDescriptor

static GPBFileDescriptor *ClientMessageRoot_FileDescriptor(void) {
  // This is called by +initialize so there is no need to worry
  // about thread safety of the singleton.
  static GPBFileDescriptor *descriptor = NULL;
  if (!descriptor) {
    GPB_DEBUG_CHECK_RUNTIME_VERSIONS();
    descriptor = [[GPBFileDescriptor alloc] initWithPackage:@""
                                                     syntax:GPBFileSyntaxProto3];
  }
  return descriptor;
}

#pragma mark - ClientMessage

@implementation ClientMessage

@dynamic sndTimestamp;
@dynamic vdiKey;
@dynamic logMessageArray, logMessageArray_Count;
@dynamic resourceMessageArray, resourceMessageArray_Count;

typedef struct ClientMessage__storage_ {
  uint32_t _has_storage_[1];
  NSString *vdiKey;
  NSMutableArray *logMessageArray;
  NSMutableArray *resourceMessageArray;
  int64_t sndTimestamp;
} ClientMessage__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "sndTimestamp",
        .dataTypeSpecific.className = NULL,
        .number = ClientMessage_FieldNumber_SndTimestamp,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(ClientMessage__storage_, sndTimestamp),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeInt64,
      },
      {
        .name = "vdiKey",
        .dataTypeSpecific.className = NULL,
        .number = ClientMessage_FieldNumber_VdiKey,
        .hasIndex = 1,
        .offset = (uint32_t)offsetof(ClientMessage__storage_, vdiKey),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeString,
      },
      {
        .name = "logMessageArray",
        .dataTypeSpecific.className = GPBStringifySymbol(LogMessage),
        .number = ClientMessage_FieldNumber_LogMessageArray,
        .hasIndex = GPBNoHasBit,
        .offset = (uint32_t)offsetof(ClientMessage__storage_, logMessageArray),
        .flags = (GPBFieldFlags)(GPBFieldRepeated | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeMessage,
      },
      {
        .name = "resourceMessageArray",
        .dataTypeSpecific.className = GPBStringifySymbol(ResourceMessage),
        .number = ClientMessage_FieldNumber_ResourceMessageArray,
        .hasIndex = GPBNoHasBit,
        .offset = (uint32_t)offsetof(ClientMessage__storage_, resourceMessageArray),
        .flags = (GPBFieldFlags)(GPBFieldRepeated | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeMessage,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[ClientMessage class]
                                     rootClass:[ClientMessageRoot class]
                                          file:ClientMessageRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(ClientMessage__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
#if !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    static const char *extraTextFormatInfo =
        "\004\001\014\000\002\006\000\003\000logMessage\000\004\000resourceMessage\000";
    [localDescriptor setupExtraTextInfo:extraTextFormatInfo];
#endif  // !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    #if defined(DEBUG) && DEBUG
      NSAssert(descriptor == nil, @"Startup recursed!");
    #endif  // DEBUG
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

#pragma mark - LogMessage

@implementation LogMessage

@dynamic crtTimestamp;
@dynamic event;
@dynamic eventType;
@dynamic level;
@dynamic hostOs;
@dynamic clientVersion;
@dynamic uuid;
@dynamic etc;

typedef struct LogMessage__storage_ {
  uint32_t _has_storage_[1];
  LogMessage_Event event;
  LogMessage_EventType eventType;
  LogMessage_Level level;
  NSString *hostOs;
  NSString *clientVersion;
  NSString *uuid;
  NSString *etc;
  int64_t crtTimestamp;
} LogMessage__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "crtTimestamp",
        .dataTypeSpecific.className = NULL,
        .number = LogMessage_FieldNumber_CrtTimestamp,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(LogMessage__storage_, crtTimestamp),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeInt64,
      },
      {
        .name = "event",
        .dataTypeSpecific.enumDescFunc = LogMessage_Event_EnumDescriptor,
        .number = LogMessage_FieldNumber_Event,
        .hasIndex = 1,
        .offset = (uint32_t)offsetof(LogMessage__storage_, event),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldHasEnumDescriptor),
        .dataType = GPBDataTypeEnum,
      },
      {
        .name = "eventType",
        .dataTypeSpecific.enumDescFunc = LogMessage_EventType_EnumDescriptor,
        .number = LogMessage_FieldNumber_EventType,
        .hasIndex = 2,
        .offset = (uint32_t)offsetof(LogMessage__storage_, eventType),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom | GPBFieldHasEnumDescriptor),
        .dataType = GPBDataTypeEnum,
      },
      {
        .name = "level",
        .dataTypeSpecific.enumDescFunc = LogMessage_Level_EnumDescriptor,
        .number = LogMessage_FieldNumber_Level,
        .hasIndex = 3,
        .offset = (uint32_t)offsetof(LogMessage__storage_, level),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldHasEnumDescriptor),
        .dataType = GPBDataTypeEnum,
      },
      {
        .name = "hostOs",
        .dataTypeSpecific.className = NULL,
        .number = LogMessage_FieldNumber_HostOs,
        .hasIndex = 4,
        .offset = (uint32_t)offsetof(LogMessage__storage_, hostOs),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeString,
      },
      {
        .name = "clientVersion",
        .dataTypeSpecific.className = NULL,
        .number = LogMessage_FieldNumber_ClientVersion,
        .hasIndex = 5,
        .offset = (uint32_t)offsetof(LogMessage__storage_, clientVersion),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeString,
      },
      {
        .name = "uuid",
        .dataTypeSpecific.className = NULL,
        .number = LogMessage_FieldNumber_Uuid,
        .hasIndex = 6,
        .offset = (uint32_t)offsetof(LogMessage__storage_, uuid),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "etc",
        .dataTypeSpecific.className = NULL,
        .number = LogMessage_FieldNumber_Etc,
        .hasIndex = 7,
        .offset = (uint32_t)offsetof(LogMessage__storage_, etc),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[LogMessage class]
                                     rootClass:[ClientMessageRoot class]
                                          file:ClientMessageRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(LogMessage__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
#if !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    static const char *extraTextFormatInfo =
        "\004\001\014\000\003\t\000\005\006\000\006\r\000";
    [localDescriptor setupExtraTextInfo:extraTextFormatInfo];
#endif  // !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    #if defined(DEBUG) && DEBUG
      NSAssert(descriptor == nil, @"Startup recursed!");
    #endif  // DEBUG
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

int32_t LogMessage_Event_RawValue(LogMessage *message) {
  GPBDescriptor *descriptor = [LogMessage descriptor];
  GPBFieldDescriptor *field = [descriptor fieldWithNumber:LogMessage_FieldNumber_Event];
  return GPBGetMessageInt32Field(message, field);
}

void SetLogMessage_Event_RawValue(LogMessage *message, int32_t value) {
  GPBDescriptor *descriptor = [LogMessage descriptor];
  GPBFieldDescriptor *field = [descriptor fieldWithNumber:LogMessage_FieldNumber_Event];
  GPBSetInt32IvarWithFieldInternal(message, field, value, descriptor.file.syntax);
}

int32_t LogMessage_EventType_RawValue(LogMessage *message) {
  GPBDescriptor *descriptor = [LogMessage descriptor];
  GPBFieldDescriptor *field = [descriptor fieldWithNumber:LogMessage_FieldNumber_EventType];
  return GPBGetMessageInt32Field(message, field);
}

void SetLogMessage_EventType_RawValue(LogMessage *message, int32_t value) {
  GPBDescriptor *descriptor = [LogMessage descriptor];
  GPBFieldDescriptor *field = [descriptor fieldWithNumber:LogMessage_FieldNumber_EventType];
  GPBSetInt32IvarWithFieldInternal(message, field, value, descriptor.file.syntax);
}

int32_t LogMessage_Level_RawValue(LogMessage *message) {
  GPBDescriptor *descriptor = [LogMessage descriptor];
  GPBFieldDescriptor *field = [descriptor fieldWithNumber:LogMessage_FieldNumber_Level];
  return GPBGetMessageInt32Field(message, field);
}

void SetLogMessage_Level_RawValue(LogMessage *message, int32_t value) {
  GPBDescriptor *descriptor = [LogMessage descriptor];
  GPBFieldDescriptor *field = [descriptor fieldWithNumber:LogMessage_FieldNumber_Level];
  GPBSetInt32IvarWithFieldInternal(message, field, value, descriptor.file.syntax);
}

#pragma mark - Enum LogMessage_EventType

GPBEnumDescriptor *LogMessage_EventType_EnumDescriptor(void) {
  static _Atomic(GPBEnumDescriptor*) descriptor = nil;
  if (!descriptor) {
    static const char *valueNames =
        "EventNull\000Activated\000Inactivated\000ActionSt"
        "arted\000ActionDone\000SystemStart\000SystemStop\000"
        "FuncCalled\000FuncExit\000DetectThreat\000PolicyV"
        "iolation\000OperationRestrict\000MemoryFull\000Di"
        "skFull\000ConnectionError\000ValueChanged\000Devi"
        "ceRooting\000UnexpectedSystemHalt\000UnknownEr"
        "ror\000BlacklistDetection\000";
    static const int32_t values[] = {
        LogMessage_EventType_EventNull,
        LogMessage_EventType_Activated,
        LogMessage_EventType_Inactivated,
        LogMessage_EventType_ActionStarted,
        LogMessage_EventType_ActionDone,
        LogMessage_EventType_SystemStart,
        LogMessage_EventType_SystemStop,
        LogMessage_EventType_FuncCalled,
        LogMessage_EventType_FuncExit,
        LogMessage_EventType_DetectThreat,
        LogMessage_EventType_PolicyViolation,
        LogMessage_EventType_OperationRestrict,
        LogMessage_EventType_MemoryFull,
        LogMessage_EventType_DiskFull,
        LogMessage_EventType_ConnectionError,
        LogMessage_EventType_ValueChanged,
        LogMessage_EventType_DeviceRooting,
        LogMessage_EventType_UnexpectedSystemHalt,
        LogMessage_EventType_UnknownError,
        LogMessage_EventType_BlacklistDetection,
    };
    GPBEnumDescriptor *worker =
        [GPBEnumDescriptor allocDescriptorForName:GPBNSStringifySymbol(LogMessage_EventType)
                                       valueNames:valueNames
                                           values:values
                                            count:(uint32_t)(sizeof(values) / sizeof(int32_t))
                                     enumVerifier:LogMessage_EventType_IsValidValue];
    GPBEnumDescriptor *expected = nil;
    if (!atomic_compare_exchange_strong(&descriptor, &expected, worker)) {
      [worker release];
    }
  }
  return descriptor;
}

BOOL LogMessage_EventType_IsValidValue(int32_t value__) {
  switch (value__) {
    case LogMessage_EventType_EventNull:
    case LogMessage_EventType_Activated:
    case LogMessage_EventType_Inactivated:
    case LogMessage_EventType_ActionStarted:
    case LogMessage_EventType_ActionDone:
    case LogMessage_EventType_SystemStart:
    case LogMessage_EventType_SystemStop:
    case LogMessage_EventType_FuncCalled:
    case LogMessage_EventType_FuncExit:
    case LogMessage_EventType_DetectThreat:
    case LogMessage_EventType_PolicyViolation:
    case LogMessage_EventType_OperationRestrict:
    case LogMessage_EventType_MemoryFull:
    case LogMessage_EventType_DiskFull:
    case LogMessage_EventType_ConnectionError:
    case LogMessage_EventType_ValueChanged:
    case LogMessage_EventType_DeviceRooting:
    case LogMessage_EventType_UnexpectedSystemHalt:
    case LogMessage_EventType_UnknownError:
    case LogMessage_EventType_BlacklistDetection:
      return YES;
    default:
      return NO;
  }
}

#pragma mark - Enum LogMessage_Event

GPBEnumDescriptor *LogMessage_Event_EnumDescriptor(void) {
  static _Atomic(GPBEnumDescriptor*) descriptor = nil;
  if (!descriptor) {
    static const char *valueNames =
        "EventTypeNull\000Ui\000InputKeyboard\000InputMous"
        "e\000MultiMonitor\000DisplayResolution\000ShareFo"
        "lder\000ShareDragdrop\000ShareClipboard\000ShareP"
        "rinter\000UsbRedirection\000UsbFilter\000URLRedir"
        "ection\000SecureScreen\000SecureKeylogging\000Sec"
        "ureFiletampering\000SwUpgrade\000H264\000Policy\000L"
        "ogReport\000Auth\000System\000Connection\000Blacklis"
        "t\000";
    static const int32_t values[] = {
        LogMessage_Event_EventTypeNull,
        LogMessage_Event_Ui,
        LogMessage_Event_InputKeyboard,
        LogMessage_Event_InputMouse,
        LogMessage_Event_MultiMonitor,
        LogMessage_Event_DisplayResolution,
        LogMessage_Event_ShareFolder,
        LogMessage_Event_ShareDragdrop,
        LogMessage_Event_ShareClipboard,
        LogMessage_Event_SharePrinter,
        LogMessage_Event_UsbRedirection,
        LogMessage_Event_UsbFilter,
        LogMessage_Event_URLRedirection,
        LogMessage_Event_SecureScreen,
        LogMessage_Event_SecureKeylogging,
        LogMessage_Event_SecureFiletampering,
        LogMessage_Event_SwUpgrade,
        LogMessage_Event_H264,
        LogMessage_Event_Policy,
        LogMessage_Event_LogReport,
        LogMessage_Event_Auth,
        LogMessage_Event_System,
        LogMessage_Event_Connection,
        LogMessage_Event_Blacklist,
    };
    static const char *extraTextFormatInfo = "\001\014\003\353\000";
    GPBEnumDescriptor *worker =
        [GPBEnumDescriptor allocDescriptorForName:GPBNSStringifySymbol(LogMessage_Event)
                                       valueNames:valueNames
                                           values:values
                                            count:(uint32_t)(sizeof(values) / sizeof(int32_t))
                                     enumVerifier:LogMessage_Event_IsValidValue
                              extraTextFormatInfo:extraTextFormatInfo];
    GPBEnumDescriptor *expected = nil;
    if (!atomic_compare_exchange_strong(&descriptor, &expected, worker)) {
      [worker release];
    }
  }
  return descriptor;
}

BOOL LogMessage_Event_IsValidValue(int32_t value__) {
  switch (value__) {
    case LogMessage_Event_EventTypeNull:
    case LogMessage_Event_Ui:
    case LogMessage_Event_InputKeyboard:
    case LogMessage_Event_InputMouse:
    case LogMessage_Event_MultiMonitor:
    case LogMessage_Event_DisplayResolution:
    case LogMessage_Event_ShareFolder:
    case LogMessage_Event_ShareDragdrop:
    case LogMessage_Event_ShareClipboard:
    case LogMessage_Event_SharePrinter:
    case LogMessage_Event_UsbRedirection:
    case LogMessage_Event_UsbFilter:
    case LogMessage_Event_URLRedirection:
    case LogMessage_Event_SecureScreen:
    case LogMessage_Event_SecureKeylogging:
    case LogMessage_Event_SecureFiletampering:
    case LogMessage_Event_SwUpgrade:
    case LogMessage_Event_H264:
    case LogMessage_Event_Policy:
    case LogMessage_Event_LogReport:
    case LogMessage_Event_Auth:
    case LogMessage_Event_System:
    case LogMessage_Event_Connection:
    case LogMessage_Event_Blacklist:
      return YES;
    default:
      return NO;
  }
}

#pragma mark - Enum LogMessage_Level

GPBEnumDescriptor *LogMessage_Level_EnumDescriptor(void) {
  static _Atomic(GPBEnumDescriptor*) descriptor = nil;
  if (!descriptor) {
    static const char *valueNames =
        "LevelNull\000Debug\000Info\000Warn\000Error\000Fatal\000";
    static const int32_t values[] = {
        LogMessage_Level_LevelNull,
        LogMessage_Level_Debug,
        LogMessage_Level_Info,
        LogMessage_Level_Warn,
        LogMessage_Level_Error,
        LogMessage_Level_Fatal,
    };
    GPBEnumDescriptor *worker =
        [GPBEnumDescriptor allocDescriptorForName:GPBNSStringifySymbol(LogMessage_Level)
                                       valueNames:valueNames
                                           values:values
                                            count:(uint32_t)(sizeof(values) / sizeof(int32_t))
                                     enumVerifier:LogMessage_Level_IsValidValue];
    GPBEnumDescriptor *expected = nil;
    if (!atomic_compare_exchange_strong(&descriptor, &expected, worker)) {
      [worker release];
    }
  }
  return descriptor;
}

BOOL LogMessage_Level_IsValidValue(int32_t value__) {
  switch (value__) {
    case LogMessage_Level_LevelNull:
    case LogMessage_Level_Debug:
    case LogMessage_Level_Info:
    case LogMessage_Level_Warn:
    case LogMessage_Level_Error:
    case LogMessage_Level_Fatal:
      return YES;
    default:
      return NO;
  }
}

#pragma mark - ResourceMessage

@implementation ResourceMessage

@dynamic crtTimestamp;
@dynamic hostOs;
@dynamic hostOsVersion;
@dynamic clientVersion;
@dynamic cpuUsage;
@dynamic cpuType;
@dynamic memTotal;
@dynamic memUsed;
@dynamic networkIn;
@dynamic networkOut;
@dynamic diskTotal;
@dynamic diskUsed;
@dynamic latency;
@dynamic bandWidth;

typedef struct ResourceMessage__storage_ {
  uint32_t _has_storage_[1];
  int32_t cpuUsage;
  int32_t memTotal;
  int32_t memUsed;
  int32_t networkIn;
  int32_t networkOut;
  int32_t diskTotal;
  int32_t diskUsed;
  int32_t latency;
  int32_t bandWidth;
  NSString *hostOs;
  NSString *hostOsVersion;
  NSString *clientVersion;
  NSString *cpuType;
  int64_t crtTimestamp;
} ResourceMessage__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "crtTimestamp",
        .dataTypeSpecific.className = NULL,
        .number = ResourceMessage_FieldNumber_CrtTimestamp,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(ResourceMessage__storage_, crtTimestamp),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeInt64,
      },
      {
        .name = "hostOs",
        .dataTypeSpecific.className = NULL,
        .number = ResourceMessage_FieldNumber_HostOs,
        .hasIndex = 1,
        .offset = (uint32_t)offsetof(ResourceMessage__storage_, hostOs),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeString,
      },
      {
        .name = "hostOsVersion",
        .dataTypeSpecific.className = NULL,
        .number = ResourceMessage_FieldNumber_HostOsVersion,
        .hasIndex = 2,
        .offset = (uint32_t)offsetof(ResourceMessage__storage_, hostOsVersion),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeString,
      },
      {
        .name = "clientVersion",
        .dataTypeSpecific.className = NULL,
        .number = ResourceMessage_FieldNumber_ClientVersion,
        .hasIndex = 3,
        .offset = (uint32_t)offsetof(ResourceMessage__storage_, clientVersion),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeString,
      },
      {
        .name = "cpuUsage",
        .dataTypeSpecific.className = NULL,
        .number = ResourceMessage_FieldNumber_CpuUsage,
        .hasIndex = 4,
        .offset = (uint32_t)offsetof(ResourceMessage__storage_, cpuUsage),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeInt32,
      },
      {
        .name = "cpuType",
        .dataTypeSpecific.className = NULL,
        .number = ResourceMessage_FieldNumber_CpuType,
        .hasIndex = 5,
        .offset = (uint32_t)offsetof(ResourceMessage__storage_, cpuType),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeString,
      },
      {
        .name = "memTotal",
        .dataTypeSpecific.className = NULL,
        .number = ResourceMessage_FieldNumber_MemTotal,
        .hasIndex = 6,
        .offset = (uint32_t)offsetof(ResourceMessage__storage_, memTotal),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeInt32,
      },
      {
        .name = "memUsed",
        .dataTypeSpecific.className = NULL,
        .number = ResourceMessage_FieldNumber_MemUsed,
        .hasIndex = 7,
        .offset = (uint32_t)offsetof(ResourceMessage__storage_, memUsed),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeInt32,
      },
      {
        .name = "networkIn",
        .dataTypeSpecific.className = NULL,
        .number = ResourceMessage_FieldNumber_NetworkIn,
        .hasIndex = 8,
        .offset = (uint32_t)offsetof(ResourceMessage__storage_, networkIn),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeInt32,
      },
      {
        .name = "networkOut",
        .dataTypeSpecific.className = NULL,
        .number = ResourceMessage_FieldNumber_NetworkOut,
        .hasIndex = 9,
        .offset = (uint32_t)offsetof(ResourceMessage__storage_, networkOut),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeInt32,
      },
      {
        .name = "diskTotal",
        .dataTypeSpecific.className = NULL,
        .number = ResourceMessage_FieldNumber_DiskTotal,
        .hasIndex = 10,
        .offset = (uint32_t)offsetof(ResourceMessage__storage_, diskTotal),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeInt32,
      },
      {
        .name = "diskUsed",
        .dataTypeSpecific.className = NULL,
        .number = ResourceMessage_FieldNumber_DiskUsed,
        .hasIndex = 11,
        .offset = (uint32_t)offsetof(ResourceMessage__storage_, diskUsed),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeInt32,
      },
      {
        .name = "latency",
        .dataTypeSpecific.className = NULL,
        .number = ResourceMessage_FieldNumber_Latency,
        .hasIndex = 12,
        .offset = (uint32_t)offsetof(ResourceMessage__storage_, latency),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeInt32,
      },
      {
        .name = "bandWidth",
        .dataTypeSpecific.className = NULL,
        .number = ResourceMessage_FieldNumber_BandWidth,
        .hasIndex = 13,
        .offset = (uint32_t)offsetof(ResourceMessage__storage_, bandWidth),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeInt32,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[ResourceMessage class]
                                     rootClass:[ClientMessageRoot class]
                                          file:ClientMessageRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(ResourceMessage__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
#if !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    static const char *extraTextFormatInfo =
        "\r\001\014\000\002\006\000\003\r\000\004\r\000\005\010\000\006\007\000\007\010\000\010\007\000\t\t\000\n\n\000\013\t\000\014\010\000\016\t\000";
    [localDescriptor setupExtraTextInfo:extraTextFormatInfo];
#endif  // !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    #if defined(DEBUG) && DEBUG
      NSAssert(descriptor == nil, @"Startup recursed!");
    #endif  // DEBUG
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end


#pragma clang diagnostic pop

// @@protoc_insertion_point(global_scope)
