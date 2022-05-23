// https://de.wikipedia.org/wiki/KISS_(Zufallszahlengenerator)

pub struct Kiss {
    x: u64,
    y: u64,
    z: u64,
    c: u64,
}

impl Kiss {
    pub fn new(seed: u64, y: u64, z: u64, c: u64) -> Result<Self, ()> {
        Ok(Self { x: seed, y, z, c })
    }

    pub fn rand(&mut self) -> u64 {
        // Linearer Kongruenzgenerator
        self.x = (6906969069u64.wrapping_mul(self.x)).wrapping_add(1234567);

        // Xorshift
        self.y ^= self.y << 13;
        self.y ^= self.y >> 17;
        self.y ^= self.y << 43;

        // Multiply-with-carry
        let t = (self.z << 58) + self.c;
        self.c = self.z >> 6;
        self.z = self.z.wrapping_add(t);
        self.c += if self.z < t { 1 } else { 0 };

        return self.x.wrapping_add(self.y).wrapping_add(self.z);
    }
}
