use core::fmt::Display;

/// The Level at which the Logs should actually be printed
///
/// This allows for as detailed of a log as you need, depending on your use-case
#[derive(Debug, Clone, Copy, PartialEq)]
pub enum LogLevel {
    /// The most verbose Level, which will output everything
    Trace,
    /// This does not output as much as Trace but still outputs a lot of information, especially
    /// useful for getting started with debugging
    Debug,
    /// Outputs some information about the system to allow you to follow its behaviour in a broader
    /// sense
    Info,
    /// Only logs warnings or errors generated
    Warn,
    /// Only logs errors generated
    Error,
}

impl PartialOrd for LogLevel {
    fn partial_cmp(&self, other: &Self) -> Option<core::cmp::Ordering> {
        match (self, other) {
            (s, o) if s == o => Some(core::cmp::Ordering::Equal),
            (Self::Trace, _) => Some(core::cmp::Ordering::Less),
            (Self::Debug, Self::Trace) => Some(core::cmp::Ordering::Greater),
            (Self::Debug, _) => Some(core::cmp::Ordering::Less),
            (Self::Info, Self::Trace) => Some(core::cmp::Ordering::Greater),
            (Self::Info, Self::Debug) => Some(core::cmp::Ordering::Greater),
            (Self::Info, _) => Some(core::cmp::Ordering::Less),
            (Self::Warn, Self::Trace) => Some(core::cmp::Ordering::Greater),
            (Self::Warn, Self::Debug) => Some(core::cmp::Ordering::Greater),
            (Self::Warn, Self::Info) => Some(core::cmp::Ordering::Greater),
            (Self::Warn, _) => Some(core::cmp::Ordering::Less),
            (Self::Error, Self::Trace) => Some(core::cmp::Ordering::Greater),
            (Self::Error, Self::Debug) => Some(core::cmp::Ordering::Greater),
            (Self::Error, Self::Info) => Some(core::cmp::Ordering::Greater),
            (Self::Error, Self::Warn) => Some(core::cmp::Ordering::Greater),
            (Self::Error, _) => Some(core::cmp::Ordering::Less),
            _ => None,
        }
    }
}

impl From<&tracing::Level> for LogLevel {
    fn from(other: &tracing::Level) -> Self {
        match other {
            &tracing::Level::DEBUG => Self::Debug,
            &tracing::Level::TRACE => Self::Trace,
            &tracing::Level::INFO => Self::Info,
            &tracing::Level::WARN => Self::Warn,
            &tracing::Level::ERROR => Self::Error,
        }
    }
}

impl Display for LogLevel {
    fn fmt(&self, f: &mut core::fmt::Formatter<'_>) -> core::fmt::Result {
        match self {
            Self::Debug => write!(f, "D"),
            Self::Trace => write!(f, "T"),
            Self::Info => write!(f, "I"),
            Self::Warn => write!(f, "W"),
            Self::Error => write!(f, "E"),
        }
    }
}
