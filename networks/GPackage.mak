MICROPHYSICS_UTIL_PATH := $(MICROPHYSICS_DIR)/util

FINCLUDE_LOCATIONS += $(MICROPHYSICS_UTIL_PATH)
VPATH_LOCATIONS    += $(MICROPHYSICS_UTIL_PATH)

include $(MICROPHYSICS_UTIL_PATH)/Make.package

ifeq ($(USE_REACT), TRUE)

  INTEGRATION_PATH := $(MICROPHYSICS_DIR)/integration
  
  FINCLUDE_LOCATIONS    += $(INTEGRATION_PATH)
  VPATH_LOCATIONS       += $(INTEGRATION_PATH)
  EXTERN_PARAMETER_DIRS += $(INTEGRATION_PATH)

  include $(INTEGRATION_PATH)/GPackage.mak

endif

ifeq ($(USE_RATES), TRUE)

  RATE_PATH := $(MICROPHYSICS_DIR)/rates

  INCLUDE_LOCATIONS     += $(RATE_PATH)
  VPATH_LOCATIONS       += $(RATE_PATH)
  EXTERN_PARAMETER_DIRS += $(RATE_PATH)

  include $(RATE_PATH)/GPackage.mak

endif

ifeq ($(USE_SCREENING), TRUE)

  SCREEN_PATH := $(MICROPHYSICS_DIR)/screening

  INCLUDE_LOCATIONS     += $(SCREEN_PATH)
  VPATH_LOCATIONS       += $(SCREEN_PATH)
  EXTERN_PARAMETER_DIRS += $(SCREEN_PATH)

  include $(SCREEN_PATH)/GPackage.mak

endif