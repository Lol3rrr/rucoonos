/// # Extensions
/// Extensions are similiar to Linux's kernel modules, in that they extend the Kernels capabilities
/// and aim to provide new functionality to all the Users of an OS without too much performance
/// losses
///
/// # Use-Case
/// Extensions are used for basically all Functions that are not absolutely critical to an OS,
/// so everything from Networking to Display to File-Systems will be implemented as an extension.
/// This also makes the OS highly configurable allowing you to easily choose what functionality you
/// need and what you can leave out or even what you can add yourself.
mod networking;
pub use networking::*;

pub mod logging;
