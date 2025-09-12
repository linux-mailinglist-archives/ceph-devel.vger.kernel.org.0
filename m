Return-Path: <ceph-devel+bounces-3599-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 53090B543B5
	for <lists+ceph-devel@lfdr.de>; Fri, 12 Sep 2025 09:21:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 595D61C86A6A
	for <lists+ceph-devel@lfdr.de>; Fri, 12 Sep 2025 07:21:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 483652BF01D;
	Fri, 12 Sep 2025 07:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gms-tku-edu-tw.20230601.gappssmtp.com header.i=@gms-tku-edu-tw.20230601.gappssmtp.com header.b="SLbrUu2e"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0AEC28EA56
	for <ceph-devel@vger.kernel.org>; Fri, 12 Sep 2025 07:21:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757661685; cv=none; b=c/+FlAiTgLGDXiqsAeYubxWWdRXU1dSopptXkcy2JdYKaqxr6xU5yy9U9ljrlfTIh31+aB26fcxxD2DA57a80lGoM4Zte2WE80220vYMJRbj+D5BOiNXN+Y20tILokCL8oCFnAuRqs8YfsKv/AJyDc+IRvygAkzGOjwNXM8G4Cw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757661685; c=relaxed/simple;
	bh=RmEPEet/m6iV/s+8sMKLZiTG5PEHUzB94BN81w+YVIo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gTDiPOCc63gKud2MC0fWsyLeKjzaH3vg2DjRod2YJdfYWpXma9Q8QGCGuTmbtA9ZoEGY4yUhBZ9MEiGp7plj7ULlwvJiZSqfiqMNY88WZws/oix00cnqLvbj9U7DluxazTUzNC7zte6CYzj6rRJNHEPZJU2BWhoJ6BYxpRxKVd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gms.tku.edu.tw; spf=pass smtp.mailfrom=gms.tku.edu.tw; dkim=pass (2048-bit key) header.d=gms-tku-edu-tw.20230601.gappssmtp.com header.i=@gms-tku-edu-tw.20230601.gappssmtp.com header.b=SLbrUu2e; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gms.tku.edu.tw
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gms.tku.edu.tw
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-7722c8d2694so1670593b3a.3
        for <ceph-devel@vger.kernel.org>; Fri, 12 Sep 2025 00:21:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gms-tku-edu-tw.20230601.gappssmtp.com; s=20230601; t=1757661681; x=1758266481; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=M5oZoXTOHvumKEWamUzwLcembrDPdLNg+mCO4LLU1jc=;
        b=SLbrUu2eGLylKQH5fEk4M0NDJSbEauA5iUc0OcbsCCura4A8nK/V1hEncbV/BfrNxD
         I5hg9LwsvK982lzUV8oqfAhILuc4u7SyTv0rd6ejKhjIY5ALlXMhKHnUYmzToVEt99hY
         eTcUspNGBmOCItDDdz9Kbl4pPRTer7bAJPyP7g8YRVFlDZhWofCqh9KF5HwKeW7JiNft
         f2oGKBcN1R8GlxNgkb9kOgvwJdQnQKOPUUutIZbzHhLzSx3dbB2W5Iro2Ji3y+9BcdXE
         QKJ5J+xge+MZAMc6uA5nQp3nClAYNn8PWiA7HtoUrAHcBXDYrUSYnYh1RXxego8CDesM
         1vWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757661681; x=1758266481;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=M5oZoXTOHvumKEWamUzwLcembrDPdLNg+mCO4LLU1jc=;
        b=gLHX4orK6gvC0vamkRBgYOEuBdDJ+qo2cixC9wmYOPCQb5SaQSTkuhmkmHxnzNT7Q6
         9j8aLxtod3esekir33KyCDlmQbS0JhLM+2jwfFYNuJ4al4I8O0QJwhirp6p1Q7r5cGWQ
         FA65hK14Rsb4Es/venLntjsY1KBTYyj4Qtqc+nLrqcfxxP+SRPGMrNDaGCW+/snxfVj1
         sDtGNS7/5YrV71nSyUDAsW5kn0xhGLTzNP9mFQkZfYVGtN4xvy6lFdHdXXnycVllmYLL
         EFtrz1MWRf4ouUWwRqHYVCA0NE4CogVYRabCQ5et2wDMQgRi1h4iBIvppdPrDlcq3h6R
         53CA==
X-Forwarded-Encrypted: i=1; AJvYcCUraRagoQgcI57Foaul2Pam/CKGCmOynBtqsbc/dMfIgfwm2t8rWK1d4ccHit77aMxYF1WWEYgQuMJy@vger.kernel.org
X-Gm-Message-State: AOJu0YxNTWVO4Q0Kk7OH8xJ8bqosWzaX2O9zr9LH64RzVS6i7rotf/uM
	QjHe5US/dTY6AZ6w+kwyVfEbceu/xwjG/2IfOKvEU8rNBtWM4KDHKsSiRbd6GuhXSEM=
X-Gm-Gg: ASbGncs3+N+gNyjXhEma3YLhP2nvCbatDcCcrTKpGzCHI0OrypxSLb+SQUyD8ZSSkz3
	gjXAZmtVjIfApW1ZG+5cLjRPrlQb0HtU2Hhk5OjChMjBkYUpjziJQAi693Zfp9gF2sSFJ1GG8pk
	Z+EtodeRcncWt65tJapyjX4naqY438CYbmXd5j2r+TA/xeYHMDz+8jFX3zlSBR4mKWf3+rhHW77
	byAgg0ZefP8aQp3KPtt8dp0Ehex4Mpzeh4o0vvbwkX/JAYUHRC0hPMsSmtEoB6m578l/pXIOuBr
	xD92a8fdyzdcG9Oxf2Y//LZokvBgG5a8zXcsyhfgvedXcX4VRXN1PG2bjPHejvNYZsiagx5MB8B
	KCUVVUswNS3OSWHzFkvS/NR+Wr6uJQUB/wBafQUH3EQfTe3fl1vnRoDg=
X-Google-Smtp-Source: AGHT+IFeT099eWd52YzInRLYsyaUbbVCss4FV1M4mP31uAaRbmNE0jQGdKQvp6lvOgW2spcu35USBQ==
X-Received: by 2002:a05:6a00:1a0a:b0:776:153d:1d87 with SMTP id d2e1a72fcca58-776153d1e9fmr1411848b3a.3.1757661680901;
        Fri, 12 Sep 2025 00:21:20 -0700 (PDT)
Received: from wu-Pro-E500-G6-WS720T ([2001:288:7001:2703:9e14:1074:637d:9ff6])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7760793b4d0sm4358514b3a.2.2025.09.12.00.21.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Sep 2025 00:21:20 -0700 (PDT)
Date: Fri, 12 Sep 2025 15:21:15 +0800
From: Guan-Chun Wu <409411716@gms.tku.edu.tw>
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: akpm@linux-foundation.org, axboe@kernel.dk, ceph-devel@vger.kernel.org,
	ebiggers@kernel.org, hch@lst.de, home7438072@gmail.com,
	idryomov@gmail.com, jaegeuk@kernel.org, kbusch@kernel.org,
	linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-nvme@lists.infradead.org, sagi@grimberg.me, tytso@mit.edu,
	visitorckw@gmail.com, xiubli@redhat.com
Subject: Re: [PATCH v2 2/5] lib/base64: rework encoder/decoder with
 customizable support and update nvme-auth
Message-ID: <aMPJ60LCfK2wPlo6@wu-Pro-E500-G6-WS720T>
References: <20250911072925.547163-1-409411716@gms.tku.edu.tw>
 <20250911074159.656943-1-409411716@gms.tku.edu.tw>
 <CADUfDZpSjONx+KcATaH+JELbQy+1fq0JVvh9tNjDgABs4rhjbA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CADUfDZpSjONx+KcATaH+JELbQy+1fq0JVvh9tNjDgABs4rhjbA@mail.gmail.com>

Hi Caleb,

On Thu, Sep 11, 2025 at 08:59:26AM -0700, Caleb Sander Mateos wrote:
> On Thu, Sep 11, 2025 at 12:43 AM Guan-Chun Wu <409411716@gms.tku.edu.tw> wrote:
> >
> > Rework base64_encode() and base64_decode() with extended interfaces
> > that support custom 64-character tables and optional '=' padding.
> > This makes them flexible enough to cover both standard RFC4648 Base64
> > and non-standard variants such as base64url.
> >
> > The encoder is redesigned to process input in 3-byte blocks, each
> > mapped directly into 4 output symbols. Base64 naturally encodes
> > 24 bits of input as four 6-bit values, so operating on aligned
> > 3-byte chunks matches the algorithm's structure. This block-based
> > approach eliminates the need for bit-by-bit streaming, reduces shifts,
> > masks, and loop iterations, and removes data-dependent branches from
> > the main loop. Only the final 1 or 2 leftover bytes are handled
> > separately according to the standard rules. As a result, the encoder
> > achieves ~2.8x speedup for small inputs (64B) and up to ~2.6x
> > speedup for larger inputs (1KB), while remaining fully RFC4648-compliant.
> >
> > The decoder replaces strchr()-based lookups with direct table-indexed
> > mapping. It processes input in 4-character groups and supports both
> > padded and non-padded forms. Validation has been strengthened: illegal
> > characters and misplaced '=' padding now cause errors, preventing
> > silent data corruption.
> >
> > These changes improve decoding performance by ~12-15x.
> >
> > Benchmarks on x86_64 (Intel Core i7-10700 @ 2.90GHz, averaged
> > over 1000 runs, tested with KUnit):
> >
> > Encode:
> >  - 64B input: avg ~90ns -> ~32ns  (~2.8x faster)
> >  - 1KB input: avg ~1332ns -> ~510ns  (~2.6x faster)
> >
> > Decode:
> >  - 64B input: avg ~1530ns -> ~122ns   (~12.5x faster)
> >  - 1KB input: avg ~27726ns -> ~1859ns (~15x faster)
> >
> > Update nvme-auth to use the reworked base64_encode() and base64_decode()
> > interfaces, which now require explicit padding and table parameters.
> > A static base64_table is defined to preserve RFC4648 standard encoding
> > with padding enabled, ensuring functional behavior remains unchanged.
> >
> > While this is a mechanical update following the lib/base64 rework,
> > nvme-auth also benefits from the performance improvements in the new
> > encoder/decoder, achieving faster encode/decode without altering the
> > output format.
> >
> > The reworked encoder and decoder unify Base64 handling across the kernel
> > with higher performance, stricter correctness, and flexibility to support
> > subsystem-specific variants.
> >
> > Co-developed-by: Kuan-Wei Chiu <visitorckw@gmail.com>
> > Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
> > Co-developed-by: Yu-Sheng Huang <home7438072@gmail.com>
> > Signed-off-by: Yu-Sheng Huang <home7438072@gmail.com>
> > Signed-off-by: Guan-Chun Wu <409411716@gms.tku.edu.tw>
> > ---
> >  drivers/nvme/common/auth.c |   7 +-
> >  include/linux/base64.h     |   4 +-
> >  lib/base64.c               | 238 ++++++++++++++++++++++++++++---------
> >  3 files changed, 192 insertions(+), 57 deletions(-)
> >
> > diff --git a/drivers/nvme/common/auth.c b/drivers/nvme/common/auth.c
> > index 91e273b89..4d57694f8 100644
> > --- a/drivers/nvme/common/auth.c
> > +++ b/drivers/nvme/common/auth.c
> > @@ -161,6 +161,9 @@ u32 nvme_auth_key_struct_size(u32 key_len)
> >  }
> >  EXPORT_SYMBOL_GPL(nvme_auth_key_struct_size);
> >
> > +static const char base64_table[65] =
> > +       "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
> > +
> >  struct nvme_dhchap_key *nvme_auth_extract_key(unsigned char *secret,
> >                                               u8 key_hash)
> >  {
> > @@ -178,7 +181,7 @@ struct nvme_dhchap_key *nvme_auth_extract_key(unsigned char *secret,
> >         if (!key)
> >                 return ERR_PTR(-ENOMEM);
> >
> > -       key_len = base64_decode(secret, allocated_len, key->key);
> > +       key_len = base64_decode(secret, allocated_len, key->key, true, base64_table);
> >         if (key_len < 0) {
> >                 pr_debug("base64 key decoding error %d\n",
> >                          key_len);
> > @@ -663,7 +666,7 @@ int nvme_auth_generate_digest(u8 hmac_id, u8 *psk, size_t psk_len,
> >         if (ret)
> >                 goto out_free_digest;
> >
> > -       ret = base64_encode(digest, digest_len, enc);
> > +       ret = base64_encode(digest, digest_len, enc, true, base64_table);
> >         if (ret < hmac_len) {
> >                 ret = -ENOKEY;
> >                 goto out_free_digest;
> > diff --git a/include/linux/base64.h b/include/linux/base64.h
> > index 660d4cb1e..22351323d 100644
> > --- a/include/linux/base64.h
> > +++ b/include/linux/base64.h
> > @@ -10,7 +10,7 @@
> >
> >  #define BASE64_CHARS(nbytes)   DIV_ROUND_UP((nbytes) * 4, 3)
> >
> > -int base64_encode(const u8 *src, int len, char *dst);
> > -int base64_decode(const char *src, int len, u8 *dst);
> > +int base64_encode(const u8 *src, int len, char *dst, bool padding, const char *table);
> > +int base64_decode(const char *src, int len, u8 *dst, bool padding, const char *table);
> >
> >  #endif /* _LINUX_BASE64_H */
> > diff --git a/lib/base64.c b/lib/base64.c
> > index 9416bded2..b2bd5dab5 100644
> > --- a/lib/base64.c
> > +++ b/lib/base64.c
> > @@ -15,104 +15,236 @@
> >  #include <linux/string.h>
> >  #include <linux/base64.h>
> >
> > -static const char base64_table[65] =
> > -       "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
> > +#define BASE64_6BIT_MASK      0x3f /* Mask to extract lowest 6 bits */
> > +#define BASE64_BITS_PER_BYTE  8
> > +#define BASE64_CHUNK_BITS     6
> > +
> > +/* Output-char-indexed shifts: for output chars 0,1,2,3 respectively */
> > +#define BASE64_SHIFT_OUT0      (BASE64_CHUNK_BITS * 3) /* 18 */
> > +#define BASE64_SHIFT_OUT1      (BASE64_CHUNK_BITS * 2) /* 12 */
> > +#define BASE64_SHIFT_OUT2      (BASE64_CHUNK_BITS * 1) /* 6  */
> > +/* OUT3 uses 0 shift and just masks with BASE64_6BIT_MASK */
> > +
> > +/* For extracting bytes from the 24-bit value (decode main loop) */
> > +#define BASE64_SHIFT_BYTE0        (BASE64_BITS_PER_BYTE * 2) /* 16 */
> > +#define BASE64_SHIFT_BYTE1        (BASE64_BITS_PER_BYTE * 1) /* 8  */
> > +
> > +/* Tail (no padding) shifts to extract bytes */
> > +#define BASE64_TAIL2_BYTE0_SHIFT  ((BASE64_CHUNK_BITS * 2) - BASE64_BITS_PER_BYTE)       /* 4  */
> > +#define BASE64_TAIL3_BYTE0_SHIFT  ((BASE64_CHUNK_BITS * 3) - BASE64_BITS_PER_BYTE)       /* 10 */
> > +#define BASE64_TAIL3_BYTE1_SHIFT  ((BASE64_CHUNK_BITS * 3) - (BASE64_BITS_PER_BYTE * 2)) /* 2  */
> > +
> > +/* Extra: masks for leftover validation (no padding) */
> > +#define BASE64_MASK(n) ({        \
> > +       unsigned int __n = (n);  \
> > +       __n ? ((1U << __n) - 1U) : 0U; \
> > +})
> > +#define BASE64_TAIL2_UNUSED_BITS  (BASE64_CHUNK_BITS * 2 - BASE64_BITS_PER_BYTE)     /* 4 */
> > +#define BASE64_TAIL3_UNUSED_BITS  (BASE64_CHUNK_BITS * 3 - BASE64_BITS_PER_BYTE * 2) /* 2 */
> >
> >  static inline const char *find_chr(const char *base64_table, char ch)
> >  {
> >         if ('A' <= ch && ch <= 'Z')
> > -               return base64_table + ch - 'A';
> > +               return base64_table + (ch - 'A');
> >         if ('a' <= ch && ch <= 'z')
> > -               return base64_table + 26 + ch - 'a';
> > +               return base64_table + 26 + (ch - 'a');
> >         if ('0' <= ch && ch <= '9')
> > -               return base64_table + 26 * 2 + ch - '0';
> > -       if (ch == base64_table[26 * 2 + 10])
> > -               return base64_table + 26 * 2 + 10;
> > -       if (ch == base64_table[26 * 2 + 10 + 1])
> > -               return base64_table + 26 * 2 + 10 + 1;
> > +               return base64_table + 52 + (ch - '0');
> > +       if (ch == base64_table[62])
> > +               return &base64_table[62];
> > +       if (ch == base64_table[63])
> > +               return &base64_table[63];
> 
> All the changes in this function look cosmetic. Could you fold them
> into the patch that introduced the function to avoid touching the
> lines multiple times?
> 
> Best,
> Caleb
> 

You're right, these are just cosmetic changes. I'll fold them into the original patch.

Best regards,
Guan-chun

> >         return NULL;
> >  }
> >
> >  /**
> > - * base64_encode() - base64-encode some binary data
> > + * base64_encode() - base64-encode with custom table and optional padding
> >   * @src: the binary data to encode
> >   * @srclen: the length of @src in bytes
> > - * @dst: (output) the base64-encoded string.  Not NUL-terminated.
> > + * @dst: (output) the base64-encoded string. Not NUL-terminated.
> > + * @padding: whether to append '=' characters so output length is a multiple of 4
> > + * @table: 64-character encoding table to use (e.g. standard or URL-safe variant)
> >   *
> > - * Encodes data using base64 encoding, i.e. the "Base 64 Encoding" specified
> > - * by RFC 4648, including the  '='-padding.
> > + * Encodes data using the given 64-character @table. If @padding is true,
> > + * the output is padded with '=' as described in RFC 4648; otherwise padding
> > + * is omitted. This allows generation of both standard and non-standard
> > + * Base64 variants (e.g. URL-safe encoding).
> >   *
> >   * Return: the length of the resulting base64-encoded string in bytes.
> >   */
> > -int base64_encode(const u8 *src, int srclen, char *dst)
> > +int base64_encode(const u8 *src, int srclen, char *dst, bool padding, const char *table)
> >  {
> >         u32 ac = 0;
> > -       int bits = 0;
> > -       int i;
> >         char *cp = dst;
> >
> > -       for (i = 0; i < srclen; i++) {
> > -               ac = (ac << 8) | src[i];
> > -               bits += 8;
> > -               do {
> > -                       bits -= 6;
> > -                       *cp++ = base64_table[(ac >> bits) & 0x3f];
> > -               } while (bits >= 6);
> > -       }
> > -       if (bits) {
> > -               *cp++ = base64_table[(ac << (6 - bits)) & 0x3f];
> > -               bits -= 6;
> > +       while (srclen >= 3) {
> > +               ac = ((u32)src[0] << (BASE64_BITS_PER_BYTE * 2)) |
> > +                        ((u32)src[1] << (BASE64_BITS_PER_BYTE)) |
> > +                        (u32)src[2];
> > +
> > +               *cp++ = table[ac >> BASE64_SHIFT_OUT0];
> > +               *cp++ = table[(ac >> BASE64_SHIFT_OUT1) & BASE64_6BIT_MASK];
> > +               *cp++ = table[(ac >> BASE64_SHIFT_OUT2) & BASE64_6BIT_MASK];
> > +               *cp++ = table[ac & BASE64_6BIT_MASK];
> > +
> > +               src += 3;
> > +               srclen -= 3;
> >         }
> > -       while (bits < 0) {
> > -               *cp++ = '=';
> > -               bits += 2;
> > +
> > +       switch (srclen) {
> > +       case 2:
> > +               ac = ((u32)src[0] << (BASE64_BITS_PER_BYTE * 2)) |
> > +                    ((u32)src[1] << (BASE64_BITS_PER_BYTE));
> > +
> > +               *cp++ = table[ac >> BASE64_SHIFT_OUT0];
> > +               *cp++ = table[(ac >> BASE64_SHIFT_OUT1) & BASE64_6BIT_MASK];
> > +               *cp++ = table[(ac >> BASE64_SHIFT_OUT2) & BASE64_6BIT_MASK];
> > +               if (padding)
> > +                       *cp++ = '=';
> > +               break;
> > +       case 1:
> > +               ac = ((u32)src[0] << (BASE64_BITS_PER_BYTE * 2));
> > +               *cp++ = table[ac >> BASE64_SHIFT_OUT0];
> > +               *cp++ = table[(ac >> BASE64_SHIFT_OUT1) & BASE64_6BIT_MASK];
> > +               if (padding) {
> > +                       *cp++ = '=';
> > +                       *cp++ = '=';
> > +               }
> > +               break;
> >         }
> >         return cp - dst;
> >  }
> >  EXPORT_SYMBOL_GPL(base64_encode);
> >
> >  /**
> > - * base64_decode() - base64-decode a string
> > + * base64_decode() - base64-decode with custom table and optional padding
> >   * @src: the string to decode.  Doesn't need to be NUL-terminated.
> >   * @srclen: the length of @src in bytes
> >   * @dst: (output) the decoded binary data
> > + * @padding: when true, accept and handle '=' padding as per RFC 4648;
> > + *           when false, '=' is treated as invalid
> > + * @table: 64-character encoding table to use (e.g. standard or URL-safe variant)
> >   *
> > - * Decodes a string using base64 encoding, i.e. the "Base 64 Encoding"
> > - * specified by RFC 4648, including the  '='-padding.
> > + * Decodes a string using the given 64-character @table. If @padding is true,
> > + * '=' padding is accepted as described in RFC 4648; otherwise '=' is
> > + * treated as an error. This allows decoding of both standard and
> > + * non-standard Base64 variants (e.g. URL-safe decoding).
> >   *
> >   * This implementation hasn't been optimized for performance.
> >   *
> >   * Return: the length of the resulting decoded binary data in bytes,
> >   *        or -1 if the string isn't a valid base64 string.
> >   */
> > -int base64_decode(const char *src, int srclen, u8 *dst)
> > +static inline int base64_decode_table(char ch, const char *table)
> > +{
> > +       if (ch == '\0')
> > +               return -1;
> > +       const char *p = find_chr(table, ch);
> > +
> > +       return p ? (p - table) : -1;
> > +}
> > +
> > +static inline int decode_base64_block(const char *src, const char *table,
> > +                                     int *input1, int *input2,
> > +                                     int *input3, int *input4,
> > +                                     bool padding)
> > +{
> > +       *input1 = base64_decode_table(src[0], table);
> > +       *input2 = base64_decode_table(src[1], table);
> > +       *input3 = base64_decode_table(src[2], table);
> > +       *input4 = base64_decode_table(src[3], table);
> > +
> > +       /* Return error if any base64 character is invalid */
> > +       if (*input1 < 0 || *input2 < 0 || (!padding && (*input3 < 0 || *input4 < 0)))
> > +               return -1;
> > +
> > +       /* Handle padding */
> > +       if (padding) {
> > +               if (*input3 < 0 && *input4 >= 0)
> > +                       return -1;
> > +               if (*input3 < 0 && src[2] != '=')
> > +                       return -1;
> > +               if (*input4 < 0 && src[3] != '=')
> > +                       return -1;
> > +       }
> > +       return 0;
> > +}
> > +
> > +int base64_decode(const char *src, int srclen, u8 *dst, bool padding, const char *table)
> >  {
> > -       u32 ac = 0;
> > -       int bits = 0;
> > -       int i;
> >         u8 *bp = dst;
> > +       int input1, input2, input3, input4;
> > +       u32 val;
> >
> > -       for (i = 0; i < srclen; i++) {
> > -               const char *p = find_chr(base64_table, src[i]);
> > +       if (srclen == 0)
> > +               return 0;
> >
> > -               if (src[i] == '=') {
> > -                       ac = (ac << 6);
> > -                       bits += 6;
> > -                       if (bits >= 8)
> > -                               bits -= 8;
> > -                       continue;
> > +       /* Validate the input length for padding */
> > +       if (padding && (srclen & 0x03) != 0)
> > +               return -1;
> > +
> > +       while (srclen >= 4) {
> > +               /* Decode the next 4 characters */
> > +               if (decode_base64_block(src, table, &input1, &input2, &input3,
> > +                                       &input4, padding) < 0)
> > +                       return -1;
> > +               if (padding && srclen > 4) {
> > +                       if (input3 < 0 || input4 < 0)
> > +                               return -1;
> >                 }
> > -               if (p == NULL || src[i] == 0)
> > +               val = ((u32)input1 << BASE64_SHIFT_OUT0) |
> > +                     ((u32)input2 << BASE64_SHIFT_OUT1) |
> > +                     ((u32)((input3 < 0) ? 0 : input3) << BASE64_SHIFT_OUT2) |
> > +                     (u32)((input4 < 0) ? 0 : input4);
> > +
> > +               *bp++ = (u8)(val >> BASE64_SHIFT_BYTE0);
> > +
> > +               if (input3 >= 0)
> > +                       *bp++ = (u8)(val >> BASE64_SHIFT_BYTE1);
> > +               if (input4 >= 0)
> > +                       *bp++ = (u8)val;
> > +
> > +               src += 4;
> > +               srclen -= 4;
> > +       }
> > +
> > +       /* Handle leftover characters when padding is not used */
> > +       if (!padding && srclen > 0) {
> > +               switch (srclen) {
> > +               case 2:
> > +                       input1 = base64_decode_table(src[0], table);
> > +                       input2 = base64_decode_table(src[1], table);
> > +                       if (input1 < 0 || input2 < 0)
> > +                               return -1;
> > +
> > +                       val = ((u32)input1 << BASE64_CHUNK_BITS) | (u32)input2; /* 12 bits */
> > +                       if (val & BASE64_MASK(BASE64_TAIL2_UNUSED_BITS))
> > +                               return -1; /* low 4 bits must be zero */
> > +
> > +                       *bp++ = (u8)(val >> BASE64_TAIL2_BYTE0_SHIFT);
> > +                       break;
> > +               case 3:
> > +                       input1 = base64_decode_table(src[0], table);
> > +                       input2 = base64_decode_table(src[1], table);
> > +                       input3 = base64_decode_table(src[2], table);
> > +                       if (input1 < 0 || input2 < 0 || input3 < 0)
> > +                               return -1;
> > +
> > +                       val = ((u32)input1 << (BASE64_CHUNK_BITS * 2)) |
> > +                             ((u32)input2 << BASE64_CHUNK_BITS) |
> > +                             (u32)input3; /* 18 bits */
> > +
> > +                       if (val & BASE64_MASK(BASE64_TAIL3_UNUSED_BITS))
> > +                               return -1; /* low 2 bits must be zero */
> > +
> > +                       *bp++ = (u8)(val >> BASE64_TAIL3_BYTE0_SHIFT);
> > +                       *bp++ = (u8)((val >> BASE64_TAIL3_BYTE1_SHIFT) & 0xFF);
> > +                       break;
> > +               default:
> >                         return -1;
> > -               ac = (ac << 6) | (p - base64_table);
> > -               bits += 6;
> > -               if (bits >= 8) {
> > -                       bits -= 8;
> > -                       *bp++ = (u8)(ac >> bits);
> >                 }
> >         }
> > -       if (ac & ((1 << bits) - 1))
> > -               return -1;
> > +
> >         return bp - dst;
> >  }
> >  EXPORT_SYMBOL_GPL(base64_decode);
> > --
> > 2.34.1
> >
> >

