public class CRC32Util {
    private static final Integer[] TABLE = buildTable();

    public static String computeCRC32(Blob blobData) {
        String content = blobData.toString();
        Long crc = 4294967295L;

        for (Integer i = 0; i < content.length(); i++) {
            Integer b = content.charAt(i) & 255;
            Integer index = (Integer)((crc ^ b) & 255);
            crc = (crc >>> 8) ^ (TABLE[index] & 4294967295L);
        }

        crc ^= 4294967295L;
        return toFixedHex(crc);
    }

    private static Integer[] buildTable() {
        Integer[] table = new Integer[256];
        Long poly = 3988292384L;

        for (Integer i = 0; i < 256; i++) {
            Long c = (Long)i;
            for (Integer j = 0; j < 8; j++) {
                if ((c & 1) != 0) {
                    c = (c >>> 1) ^ poly;
                } else {
                    c = c >>> 1;
                }
            }
            table[i] = c.intValue();
        }

        return table;
    }

    private static String toFixedHex(Long value) {
        String hex = '';
        Long v = value;

        while (v > 0 || hex.length() < 8) {
            Integer d = (Integer)Math.mod(v, 16);
            hex = '0123456789ABCDEF'.substring(d, d + 1) + hex;
            v = v / 16;
        }

        return hex;
    }
}