public class MySQLCrypto2 {
    // 16 bytes of zeroes
    static Blob iv = EncodingUtil.convertFromHex('00000000000000000000000000000000');

    public class MySQLCryptoException extends Exception {
    }

    public class BlobSplitter {
        String hexEncoding;
        Integer bytes; // size of the hex encoding
        Integer ptr = 0; // offset into the base64 encoding

        public BlobSplitter(Blob b) {
            hexEncoding = EncodingUtil.convertToHex(b);
            bytes = hexEncoding.length();
        }

        public Blob getBlock() {
            if (ptr >= bytes) {
                return null;
            }

            Integer charsToConsume = Math.min(32, (bytes - ptr));
            String hexBlock = hexEncoding.substring(ptr, ptr + charsToConsume);
            ptr += charsToConsume;

            return EncodingUtil.convertFromHex(hexBlock);
        }
    }

    private static Blob joinBlocks(List<Blob> blocks) {
        String hexEncoded = '';
        for (Integer i = 0; i < blocks.size(); i++) {
            hexEncoded += EncodingUtil.convertToHex(blocks[i]);
        }
        return EncodingUtil.convertFromHex(hexEncoded);
    }

    public static Blob encrypt(String algorithmName, Blob privateKey, Blob plainText) {
        if (algorithmName != 'AES128') {
            throw new MySQLCryptoException('Algorithm '+algorithmName+' not supported');
        }

        BlobSplitter bs = new BlobSplitter(plainText);

        List<Blob> cipherTextBlocks = new List<Blob>();
        Integer i;
        Blob block;
        for (i = 0; (block = bs.getBlock()) != null; i++) {
            System.debug('PT: '+EncodingUtil.convertToHex(block));

            cipherTextBlocks.add(Crypto.encrypt('AES128', privateKey, iv, block));
            if (cipherTextBlocks[i].size() > 16) {
                BlobSplitter bsc = new BlobSplitter(cipherTextBlocks[i]);
                cipherTextBlocks[i] = bsc.getBlock();
            }

            System.debug('CT: '+EncodingUtil.convertToHex(cipherTextBlocks[i]).toUpperCase());
        }

        Blob cipherText = joinBlocks(cipherTextBlocks);

        // System.debug('XX: '+EncodingUtil.convertToHex(cipherText).toUpperCase());

        return cipherText;
    }
}