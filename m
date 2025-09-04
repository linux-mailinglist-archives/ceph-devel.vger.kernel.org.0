Return-Path: <ceph-devel+bounces-3517-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D1796B438A1
	for <lists+ceph-devel@lfdr.de>; Thu,  4 Sep 2025 12:24:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 88C30162510
	for <lists+ceph-devel@lfdr.de>; Thu,  4 Sep 2025 10:24:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C23A2EB854;
	Thu,  4 Sep 2025 10:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ca9nmzxM"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50C6522E3E9;
	Thu,  4 Sep 2025 10:24:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756981462; cv=none; b=Zc8qdDAByucfYW6P8Xg/NussXPCLVr+l/8fF81osECKFRgZCfcPfyeYRd2z6Sevz8UJX2MQZ8KHS83on76bnOk2/ZDqUniH3ftrK6Naj66w+GE3XTvp9YlyCO2BgC9fGKVzkYfXowQLL7mQSsXVlK1xcpo6frpi4+8sZyIRbqnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756981462; c=relaxed/simple;
	bh=c2gpxeWGrJmTuWMNi5PLcSU/Z+KrnMmz3jdOctjwprU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TtkZFx7V8egF2ojzQj/kXIgdr+ydnWqiIfKlbSlIZC/KYipiovUJBJlpMd2qvdSm80CdItmsUBAyKgPIsq7LiE/ZfJ9UBU0KDWDXEWoLqjI5LD81DVOHEa8O6R2/aI6bCLFJN3SMwVnCBfHchCA+PLglUG6w6O5P+u5s5rGOOwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ca9nmzxM; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-b49cf1d4f6fso590727a12.3;
        Thu, 04 Sep 2025 03:24:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756981460; x=1757586260; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8Fe9Vrd7TWrwfDgopYRzH6xudKvXJ+7N0vfpOqJW1Gs=;
        b=Ca9nmzxMFXems4idKtLDG84YKKwnFISNQOJ8emxJAFkPQzK9StM2Z/Q97isenyVolt
         wn4NBv1hDO/pyVWmh5UPnnEl/5W+xLdCHof7PLwhmUOKdF3fgNwJH8wc6b2W3bstW/Oo
         Tj1TGVfDBSXp5bjlHI7rEH0OefipVBCJy2lARNZtl2U35iGIUGuTHGvLRzcJpf5gd8Kg
         83sQECF2EvcrYsPgfxA0nizVHARIrT3zzpBRO7rge4Lm1r/u2yqjCwW1v0s3elQLPY9F
         EOUY5GOgUda85k2e0LiIU7XQErQ3Hr5qW4KfyZG8bz7bCJGzQ2dnQkaIG0jdYSinrVTc
         Qzqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756981460; x=1757586260;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8Fe9Vrd7TWrwfDgopYRzH6xudKvXJ+7N0vfpOqJW1Gs=;
        b=n9QdqeZKo0/K2DLejSqVN+Hon74e7qgQoEl8ikCI/z/VSJtM7ts8SeJuvyDdjyTynZ
         aRj/Cb7kzgDU/an6z5SFnG8zUb10fsxszUXxLLBdiEcapgxjn7ys51hPQUwA6KixtFZB
         TI318227aNcjQ/CF6c2DYgQPlqaFZpkOswmMTIj4IYvsKNR0IiqB8n7aWfk0YHmTSSv9
         Q2elSZ4zgre7oT/9ChsPkg1sogeyAkir82iUwgZA7AsheAdvc2a5bw1C9x0te6o4BreV
         GOUR/ZTAQ50D75V8e4+WrIbmSj5ExLE55tIxe89BbbggJDbvhCr/zeFzlDNetqtwQx2H
         K1IQ==
X-Forwarded-Encrypted: i=1; AJvYcCUH0do78B6Q0FpC8bq4eoF/Qwe5YKd2MOSQB0Pwybps83b5Aiil+4bzRncWat66v3iKfFQNRCskNp/LuD4=@vger.kernel.org, AJvYcCW+3RfRpeUBZlovbHIb0C1Xs+SuLGFO7m31uMa7/fh5oZKjXiLoZqhyF6BMU1ojRfyQH2Q53EZZq4+F6sY9@vger.kernel.org
X-Gm-Message-State: AOJu0YyR3v5tOQbU7/9TV10jbhZURDGWaA8XPLJMPRHvyecRMi/pAgSo
	HHRpcBGwrFY/pXmPXnNKm2DeNtIvHXfVEe7wPpraiKqMgY7L32qsasmOLuzfttRpqsY/MuFXqqw
	bgS8EQHZh5hIZWvIaWEnXJCbTrf3+J9aznZbt
X-Gm-Gg: ASbGncsL8s147Pgch7gjMp2TOVpWHFLYf07lJVG+mwLrcASYgFqYqoYGHdFvOiXv/qP
	GPHxutNLu3zUm5WPJ8nkJ2RE5lDlLASj2bVl1rs6BN1PrqI0xmNbHIB3jocs+Q3tFj1k6upgiMM
	Zd1KjY9vsyLzr/7UxJV0C/dqHLAFVtqLdTlB+kwVefY9zxNS2NBKcocTeTG2L5LP1fXSAW4lXz8
	wiu2DY=
X-Google-Smtp-Source: AGHT+IH9VpJBoSfgQBCfvbGtEx4wYfgn64e9slTSFU2ij5LeTLT1TqslheTZVnmVXilTg/N3w6YIGcjf5Bbu/LkEWFo=
X-Received: by 2002:a17:903:1b0e:b0:24c:b69f:e4ce with SMTP id
 d9443c01a7336-24cb69ffb36mr43092035ad.11.1756981460256; Thu, 04 Sep 2025
 03:24:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250731190227.16187-1-ebiggers@kernel.org>
In-Reply-To: <20250731190227.16187-1-ebiggers@kernel.org>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Thu, 4 Sep 2025 12:24:08 +0200
X-Gm-Features: Ac12FXy0ozdf-dNaaNLVwpGZ5ILF_7vcxieASaQ3Bfv0DQ4Tdi_TYnNZHpVReFg
Message-ID: <CAOi1vP9QRWKoQuYHynTXuupJ=VHhLLtN3s2FE6a+gG6gvrA6SQ@mail.gmail.com>
Subject: Re: [PATCH] libceph: Use HMAC-SHA256 library instead of crypto_shash
To: Eric Biggers <ebiggers@kernel.org>
Cc: ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 31, 2025 at 9:03=E2=80=AFPM Eric Biggers <ebiggers@kernel.org> =
wrote:
>
> Use the HMAC-SHA256 library functions instead of crypto_shash.  This is
> simpler and faster.
>
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>  include/linux/ceph/messenger.h |  4 +-
>  net/ceph/Kconfig               |  3 +-
>  net/ceph/messenger_v2.c        | 77 ++++++++++------------------------
>  3 files changed, 26 insertions(+), 58 deletions(-)
>
> diff --git a/include/linux/ceph/messenger.h b/include/linux/ceph/messenge=
r.h
> index 1717cc57cdacd..4b49592a738fc 100644
> --- a/include/linux/ceph/messenger.h
> +++ b/include/linux/ceph/messenger.h
> @@ -1,9 +1,10 @@
>  /* SPDX-License-Identifier: GPL-2.0 */
>  #ifndef __FS_CEPH_MESSENGER_H
>  #define __FS_CEPH_MESSENGER_H
>
> +#include <crypto/sha2.h>
>  #include <linux/bvec.h>
>  #include <linux/crypto.h>
>  #include <linux/kref.h>
>  #include <linux/mutex.h>
>  #include <linux/net.h>
> @@ -410,11 +411,12 @@ struct ceph_connection_v2_info {
>
>         struct ceph_frame_desc in_desc;
>         struct ceph_msg_data_cursor in_cursor;
>         struct ceph_msg_data_cursor out_cursor;
>
> -       struct crypto_shash *hmac_tfm;  /* post-auth signature */
> +       struct hmac_sha256_key hmac_key;  /* post-auth signature */
> +       bool hmac_key_set;
>         struct crypto_aead *gcm_tfm;  /* on-wire encryption */
>         struct aead_request *gcm_req;
>         struct crypto_wait gcm_wait;
>         struct ceph_gcm_nonce in_gcm_nonce;
>         struct ceph_gcm_nonce out_gcm_nonce;
> diff --git a/net/ceph/Kconfig b/net/ceph/Kconfig
> index 0aa21fcbf6ece..ea60e3ef08343 100644
> --- a/net/ceph/Kconfig
> +++ b/net/ceph/Kconfig
> @@ -4,12 +4,11 @@ config CEPH_LIB
>         depends on INET
>         select CRC32
>         select CRYPTO_AES
>         select CRYPTO_CBC
>         select CRYPTO_GCM
> -       select CRYPTO_HMAC
> -       select CRYPTO_SHA256
> +       select CRYPTO_LIB_SHA256
>         select CRYPTO
>         select KEYS
>         default n
>         help
>           Choose Y or M here to include cephlib, which provides the
> diff --git a/net/ceph/messenger_v2.c b/net/ceph/messenger_v2.c
> index 5483b4eed94e1..c54c8b5a65261 100644
> --- a/net/ceph/messenger_v2.c
> +++ b/net/ceph/messenger_v2.c
> @@ -707,11 +707,11 @@ static int setup_crypto(struct ceph_connection *con=
,
>         unsigned int noio_flag;
>         int ret;
>
>         dout("%s con %p con_mode %d session_key_len %d con_secret_len %d\=
n",
>              __func__, con, con->v2.con_mode, session_key_len, con_secret=
_len);
> -       WARN_ON(con->v2.hmac_tfm || con->v2.gcm_tfm || con->v2.gcm_req);
> +       WARN_ON(con->v2.hmac_key_set || con->v2.gcm_tfm || con->v2.gcm_re=
q);
>
>         if (con->v2.con_mode !=3D CEPH_CON_MODE_CRC &&
>             con->v2.con_mode !=3D CEPH_CON_MODE_SECURE) {
>                 pr_err("bad con_mode %d\n", con->v2.con_mode);
>                 return -EINVAL;
> @@ -721,26 +721,12 @@ static int setup_crypto(struct ceph_connection *con=
,
>                 WARN_ON(con->v2.con_mode !=3D CEPH_CON_MODE_CRC);
>                 WARN_ON(con_secret_len);
>                 return 0;  /* auth_none */
>         }
>
> -       noio_flag =3D memalloc_noio_save();
> -       con->v2.hmac_tfm =3D crypto_alloc_shash("hmac(sha256)", 0, 0);
> -       memalloc_noio_restore(noio_flag);
> -       if (IS_ERR(con->v2.hmac_tfm)) {
> -               ret =3D PTR_ERR(con->v2.hmac_tfm);
> -               con->v2.hmac_tfm =3D NULL;
> -               pr_err("failed to allocate hmac tfm context: %d\n", ret);
> -               return ret;
> -       }
> -
> -       ret =3D crypto_shash_setkey(con->v2.hmac_tfm, session_key,
> -                                 session_key_len);
> -       if (ret) {
> -               pr_err("failed to set hmac key: %d\n", ret);
> -               return ret;
> -       }
> +       hmac_sha256_preparekey(&con->v2.hmac_key, session_key, session_ke=
y_len);
> +       con->v2.hmac_key_set =3D true;
>
>         if (con->v2.con_mode =3D=3D CEPH_CON_MODE_CRC) {
>                 WARN_ON(con_secret_len);
>                 return 0;  /* auth_x, plain mode */
>         }
> @@ -791,42 +777,30 @@ static int setup_crypto(struct ceph_connection *con=
,
>                con_secret + CEPH_GCM_KEY_LEN + CEPH_GCM_IV_LEN,
>                CEPH_GCM_IV_LEN);
>         return 0;  /* auth_x, secure mode */
>  }
>
> -static int ceph_hmac_sha256(struct ceph_connection *con,
> -                           const struct kvec *kvecs, int kvec_cnt, u8 *h=
mac)
> +static void ceph_hmac_sha256(struct ceph_connection *con,
> +                            const struct kvec *kvecs, int kvec_cnt,
> +                            u8 hmac[SHA256_DIGEST_SIZE])
>  {
> -       SHASH_DESC_ON_STACK(desc, con->v2.hmac_tfm);  /* tfm arg is ignor=
ed */
> -       int ret;
> +       struct hmac_sha256_ctx ctx;
>         int i;
>
> -       dout("%s con %p hmac_tfm %p kvec_cnt %d\n", __func__, con,
> -            con->v2.hmac_tfm, kvec_cnt);
> +       dout("%s con %p hmac_key_set %d kvec_cnt %d\n", __func__, con,
> +            con->v2.hmac_key_set, kvec_cnt);
>
> -       if (!con->v2.hmac_tfm) {
> +       if (!con->v2.hmac_key_set) {
>                 memset(hmac, 0, SHA256_DIGEST_SIZE);
> -               return 0;  /* auth_none */
> +               return;  /* auth_none */
>         }
>
> -       desc->tfm =3D con->v2.hmac_tfm;
> -       ret =3D crypto_shash_init(desc);
> -       if (ret)
> -               goto out;
> -
> -       for (i =3D 0; i < kvec_cnt; i++) {
> -               ret =3D crypto_shash_update(desc, kvecs[i].iov_base,
> -                                         kvecs[i].iov_len);
> -               if (ret)
> -                       goto out;
> -       }
> -
> -       ret =3D crypto_shash_final(desc, hmac);
> -
> -out:
> -       shash_desc_zero(desc);
> -       return ret;  /* auth_x, both plain and secure modes */
> +       /* auth_x, both plain and secure modes */
> +       hmac_sha256_init(&ctx, &con->v2.hmac_key);
> +       for (i =3D 0; i < kvec_cnt; i++)
> +               hmac_sha256_update(&ctx, kvecs[i].iov_base, kvecs[i].iov_=
len);
> +       hmac_sha256_final(&ctx, hmac);
>  }
>
>  static void gcm_inc_nonce(struct ceph_gcm_nonce *nonce)
>  {
>         u64 counter;
> @@ -1453,21 +1427,18 @@ static int prepare_auth_request_more(struct ceph_=
connection *con,
>  }
>
>  static int prepare_auth_signature(struct ceph_connection *con)
>  {
>         void *buf;
> -       int ret;
>
>         buf =3D alloc_conn_buf(con, head_onwire_len(SHA256_DIGEST_SIZE,
>                                                   con_secure(con)));
>         if (!buf)
>                 return -ENOMEM;
>
> -       ret =3D ceph_hmac_sha256(con, con->v2.in_sign_kvecs,
> -                              con->v2.in_sign_kvec_cnt, CTRL_BODY(buf));
> -       if (ret)
> -               return ret;
> +       ceph_hmac_sha256(con, con->v2.in_sign_kvecs, con->v2.in_sign_kvec=
_cnt,
> +                        CTRL_BODY(buf));
>
>         return prepare_control(con, FRAME_TAG_AUTH_SIGNATURE, buf,
>                                SHA256_DIGEST_SIZE);
>  }
>
> @@ -2458,14 +2429,12 @@ static int process_auth_signature(struct ceph_con=
nection *con,
>         if (con->state !=3D CEPH_CON_S_V2_AUTH_SIGNATURE) {
>                 con->error_msg =3D "protocol error, unexpected auth_signa=
ture";
>                 return -EINVAL;
>         }
>
> -       ret =3D ceph_hmac_sha256(con, con->v2.out_sign_kvecs,
> -                              con->v2.out_sign_kvec_cnt, hmac);
> -       if (ret)
> -               return ret;
> +       ceph_hmac_sha256(con, con->v2.out_sign_kvecs, con->v2.out_sign_kv=
ec_cnt,
> +                        hmac);
>
>         ceph_decode_need(&p, end, SHA256_DIGEST_SIZE, bad);
>         if (crypto_memneq(p, hmac, SHA256_DIGEST_SIZE)) {
>                 con->error_msg =3D "integrity error, bad auth signature";
>                 return -EBADMSG;
> @@ -3812,14 +3781,12 @@ void ceph_con_v2_reset_protocol(struct ceph_conne=
ction *con)
>
>         con->v2.con_mode =3D CEPH_CON_MODE_UNKNOWN;
>         memzero_explicit(&con->v2.in_gcm_nonce, CEPH_GCM_IV_LEN);
>         memzero_explicit(&con->v2.out_gcm_nonce, CEPH_GCM_IV_LEN);
>
> -       if (con->v2.hmac_tfm) {
> -               crypto_free_shash(con->v2.hmac_tfm);
> -               con->v2.hmac_tfm =3D NULL;
> -       }
> +       memzero_explicit(&con->v2.hmac_key, sizeof(con->v2.hmac_key));
> +       con->v2.hmac_key_set =3D false;

Hi Eric,

Since we have hmac_key_set anyway, could the call to memzero_explicit()
be conditioned on it?

Thanks,

                Ilya

