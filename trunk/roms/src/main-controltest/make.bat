:: params
@SET in=../src/ControlTest.as
@SET out=../deploy/ControlTest.swf
@SET dim=800,600
@SET bg=0x000000
@SET fps=30
@SET opt=-default-size=%dim% -default-background-color=%bg% -default-frame-rate=%fps% -optimize=true
@SET src=-source-path=../src
@SET lib=-library-path+=../lib -library-path+=../lib-external
@SET dbg=-verbose-stacktraces=true -link-report=links.xml -benchmark=true
REM @set ldr=..\romloader\RomLoader-fp09.exe

@SET ver=mxmlc -version
@SET cmd=mxmlc %in% -output=%out% %opt% %src% %lib% %dbg%


:: compilation
@ECHO.
@ECHO %in% compiling to %out%
@ECHO ^(%dim%^) at %fps%fps
@ECHO background color %bg%
@ECHO.
@ECHO.
@%ver%
@ECHO.
@ECHO %cmd%
@ECHO.

@cd %~dp0
@%cmd%
@IF NOT %ERRORLEVEL% == 0 GOTO fail
@GOTO pass


:: resolution
:pass
@ECHO.
@ECHO Success!
@START %ldr%
@GOTO exit

:fail
@ECHO Build Failed..
@GOTO exit

:exit
@PAUSE