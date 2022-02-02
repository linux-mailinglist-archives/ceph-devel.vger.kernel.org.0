Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EBBD4A7714
	for <lists+ceph-devel@lfdr.de>; Wed,  2 Feb 2022 18:48:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346349AbiBBRsF (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 2 Feb 2022 12:48:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239479AbiBBRsE (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 2 Feb 2022 12:48:04 -0500
Received: from mail-vk1-xa34.google.com (mail-vk1-xa34.google.com [IPv6:2607:f8b0:4864:20::a34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BE7EC061714
        for <ceph-devel@vger.kernel.org>; Wed,  2 Feb 2022 09:48:04 -0800 (PST)
Received: by mail-vk1-xa34.google.com with SMTP id v192so105108vkv.4
        for <ceph-devel@vger.kernel.org>; Wed, 02 Feb 2022 09:48:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YZcb1lRLVB022AxzuSWN0OrjZ/5GO0Qh/baoor83bUE=;
        b=GEe6jZo03VhGWGvedGLnZVlXPefcRGH+BIds6KG8oMLz3bYS5rhnuUUS63r5ual0Kx
         k3VySDvYWfLJb8kmZXAz5HWouI9J5I012dw00nJVRHWGEBO6EZ2VyZEDMNY6VQu43Xcr
         WJT5iSx0ZAvHNaBiFHweR+hRqUvfXrfsRG09DkY19zvP43kixnHAeVaKSCt1yJSYeTzR
         M8gnF0jm7H8rAUzAMYual6KGPbsukP5dgDeud221WyOfyZJUrJIPprXULP4TFtEbVCGf
         IGupCtZnKaRKt302PIu+HidSaM6TnGnEq6qG5OK5If/HVlewtUgq3Chl90385D1sMYWw
         N7zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YZcb1lRLVB022AxzuSWN0OrjZ/5GO0Qh/baoor83bUE=;
        b=Rr70rqWHsO/rxCqNIMjtqdAmGkn6TrSyVnHRbcGjee2EyquXFYbs7xYsire8kbplEb
         R5Qw/XE4ZoyHUK4rz4dZFvKMVvgGH/SmhZS9FLSlT6v2R6NlbgofpDRq7BdcTyOPDafC
         J5ERs2nhyr4y7ldxhIfc7ZRfJECKl4743Q4buKGH8DEShi7yqtdaPUdzv7UPzUyDDai1
         jkV8ktFSrU6bQAI/LIDQp5/nvoVFvXWQcEoZLn3Nr21Hps4cwSNVu5IIdJRFU6vCu8lg
         tl8jaW3l644G2bNtKE1cg/kFlkI5vcEe8EsVv9jnwHi9tXNDvp0DsGFDtGfXgpGtexhM
         udOA==
X-Gm-Message-State: AOAM531dZcrGlAfFCGrUtJQPnvoJKN5dDzJ0g6uE769pDzb1wUctmrnb
        ZXLEyX+sgg8CN3t4vq0l1nxoqA0dFhPVJPFGQX5JIr1WvLY=
X-Google-Smtp-Source: ABdhPJyQqnwcRlzsX6fkpw694MGplwgT7Ix7zPsm/s6K5n04s5/2YzV3HOnIQaRXOLtaWupIjlq5DZQObyQOTO3XQ8s=
X-Received: by 2002:a05:6122:91b:: with SMTP id j27mr13208220vka.32.1643824083197;
 Wed, 02 Feb 2022 09:48:03 -0800 (PST)
MIME-Version: 1.0
References: <20220131155846.32411-1-idryomov@gmail.com> <20220131155846.32411-2-idryomov@gmail.com>
In-Reply-To: <20220131155846.32411-2-idryomov@gmail.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Wed, 2 Feb 2022 18:48:16 +0100
Message-ID: <CAOi1vP-M-31yYUyuXD8tD74YAfkot=AW299hpbNX=LF3ozr20Q@mail.gmail.com>
Subject: Re: [PATCH 1/2] libceph: make recv path in secure mode work the same
 as send path
To:     Ceph Development <ceph-devel@vger.kernel.org>
Cc:     Jeff Layton <jlayton@kernel.org>
Content-Type: multipart/mixed; boundary="0000000000008d7d1405d70c9e61"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

--0000000000008d7d1405d70c9e61
Content-Type: text/plain; charset="UTF-8"

On Mon, Jan 31, 2022 at 4:58 PM Ilya Dryomov <idryomov@gmail.com> wrote:
>
> The recv path of secure mode is intertwined with that of crc mode.
> While it's slightly more efficient that way (the ciphertext is read
> into the destination buffer and decrypted in place, thus avoiding
> two potentially heavy memory allocations for the bounce buffer and
> the corresponding sg array), it isn't really amenable to changes.
> Sacrifice that edge and align with the send path which always uses
> a full-sized bounce buffer (currently there is no other way -- if
> the kernel crypto API ever grows support for streaming (piecewise)
> en/decryption for GCM [1], we would be able to easily take advantage
> of that on both sides).
>
> [1] https://lore.kernel.org/all/20141225202830.GA18794@gondor.apana.org.au/
>
> Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
> ---
>  include/linux/ceph/messenger.h |   4 +
>  net/ceph/messenger_v2.c        | 231 ++++++++++++++++++++++-----------
>  2 files changed, 162 insertions(+), 73 deletions(-)
>
> diff --git a/include/linux/ceph/messenger.h b/include/linux/ceph/messenger.h
> index ff99ce094cfa..6c6b6ea52bb8 100644
> --- a/include/linux/ceph/messenger.h
> +++ b/include/linux/ceph/messenger.h
> @@ -383,6 +383,10 @@ struct ceph_connection_v2_info {
>         struct ceph_gcm_nonce in_gcm_nonce;
>         struct ceph_gcm_nonce out_gcm_nonce;
>
> +       struct page **in_enc_pages;
> +       int in_enc_page_cnt;
> +       int in_enc_resid;
> +       int in_enc_i;
>         struct page **out_enc_pages;
>         int out_enc_page_cnt;
>         int out_enc_resid;
> diff --git a/net/ceph/messenger_v2.c b/net/ceph/messenger_v2.c
> index c4099b641b38..d34349f112b0 100644
> --- a/net/ceph/messenger_v2.c
> +++ b/net/ceph/messenger_v2.c
> @@ -57,8 +57,9 @@
>  #define IN_S_HANDLE_CONTROL_REMAINDER  3
>  #define IN_S_PREPARE_READ_DATA         4
>  #define IN_S_PREPARE_READ_DATA_CONT    5
> -#define IN_S_HANDLE_EPILOGUE           6
> -#define IN_S_FINISH_SKIP               7
> +#define IN_S_PREPARE_READ_ENC_PAGE     6
> +#define IN_S_HANDLE_EPILOGUE           7
> +#define IN_S_FINISH_SKIP               8
>
>  #define OUT_S_QUEUE_DATA               1
>  #define OUT_S_QUEUE_DATA_CONT          2
> @@ -1032,22 +1033,41 @@ static int decrypt_control_remainder(struct ceph_connection *con)
>                          padded_len(rem_len) + CEPH_GCM_TAG_LEN);
>  }
>
> -static int decrypt_message(struct ceph_connection *con)
> +static int decrypt_tail(struct ceph_connection *con)
>  {
> +       struct sg_table enc_sgt = {};
>         struct sg_table sgt = {};
> +       int tail_len;
>         int ret;
>
> +       tail_len = tail_onwire_len(con->in_msg, true);
> +       ret = sg_alloc_table_from_pages(&enc_sgt, con->v2.in_enc_pages,
> +                                       con->v2.in_enc_page_cnt, 0, tail_len,
> +                                       GFP_NOIO);
> +       if (ret)
> +               goto out;
> +
>         ret = setup_message_sgs(&sgt, con->in_msg, FRONT_PAD(con->v2.in_buf),
>                         MIDDLE_PAD(con->v2.in_buf), DATA_PAD(con->v2.in_buf),
>                         con->v2.in_buf, true);
>         if (ret)
>                 goto out;
>
> -       ret = gcm_crypt(con, false, sgt.sgl, sgt.sgl,
> -                       tail_onwire_len(con->in_msg, true));
> +       dout("%s con %p msg %p enc_page_cnt %d sg_cnt %d\n", __func__, con,
> +            con->in_msg, con->v2.in_enc_page_cnt, sgt.orig_nents);
> +       ret = gcm_crypt(con, false, enc_sgt.sgl, sgt.sgl, tail_len);
> +       if (ret)
> +               goto out;
> +
> +       WARN_ON(!con->v2.in_enc_page_cnt);
> +       ceph_release_page_vector(con->v2.in_enc_pages,
> +                                con->v2.in_enc_page_cnt);
> +       con->v2.in_enc_pages = NULL;
> +       con->v2.in_enc_page_cnt = 0;
>
>  out:
>         sg_free_table(&sgt);
> +       sg_free_table(&enc_sgt);
>         return ret;
>  }
>
> @@ -1737,8 +1757,7 @@ static void prepare_read_data(struct ceph_connection *con)
>  {
>         struct bio_vec bv;
>
> -       if (!con_secure(con))
> -               con->in_data_crc = -1;
> +       con->in_data_crc = -1;
>         ceph_msg_data_cursor_init(&con->v2.in_cursor, con->in_msg,
>                                   data_len(con->in_msg));
>
> @@ -1751,11 +1770,10 @@ static void prepare_read_data_cont(struct ceph_connection *con)
>  {
>         struct bio_vec bv;
>
> -       if (!con_secure(con))
> -               con->in_data_crc = ceph_crc32c_page(con->in_data_crc,
> -                                                   con->v2.in_bvec.bv_page,
> -                                                   con->v2.in_bvec.bv_offset,
> -                                                   con->v2.in_bvec.bv_len);
> +       con->in_data_crc = ceph_crc32c_page(con->in_data_crc,
> +                                           con->v2.in_bvec.bv_page,
> +                                           con->v2.in_bvec.bv_offset,
> +                                           con->v2.in_bvec.bv_len);
>
>         ceph_msg_data_advance(&con->v2.in_cursor, con->v2.in_bvec.bv_len);
>         if (con->v2.in_cursor.total_resid) {
> @@ -1766,21 +1784,100 @@ static void prepare_read_data_cont(struct ceph_connection *con)
>         }
>
>         /*
> -        * We've read all data.  Prepare to read data padding (if any)
> -        * and epilogue.
> +        * We've read all data.  Prepare to read epilogue.
>          */
>         reset_in_kvecs(con);
> -       if (con_secure(con)) {
> -               if (need_padding(data_len(con->in_msg)))
> -                       add_in_kvec(con, DATA_PAD(con->v2.in_buf),
> -                                   padding_len(data_len(con->in_msg)));
> -               add_in_kvec(con, con->v2.in_buf, CEPH_EPILOGUE_SECURE_LEN);
> +       add_in_kvec(con, con->v2.in_buf, CEPH_EPILOGUE_PLAIN_LEN);
> +       con->v2.in_state = IN_S_HANDLE_EPILOGUE;
> +}
> +
> +static void prepare_read_tail_plain(struct ceph_connection *con)
> +{
> +       struct ceph_msg *msg = con->in_msg;
> +
> +       if (!front_len(msg) && !middle_len(msg)) {
> +               WARN_ON(!data_len(msg));
> +               prepare_read_data(con);
> +               return;
> +       }
> +
> +       reset_in_kvecs(con);
> +       if (front_len(msg)) {
> +               WARN_ON(front_len(msg) > msg->front_alloc_len);
> +               add_in_kvec(con, msg->front.iov_base, front_len(msg));
> +               msg->front.iov_len = front_len(msg);
> +       } else {
> +               msg->front.iov_len = 0;
> +       }
> +       if (middle_len(msg)) {
> +               WARN_ON(middle_len(msg) > msg->middle->alloc_len);
> +               add_in_kvec(con, msg->middle->vec.iov_base, middle_len(msg));
> +               msg->middle->vec.iov_len = middle_len(msg);
> +       } else if (msg->middle) {
> +               msg->middle->vec.iov_len = 0;
> +       }
> +
> +       if (data_len(msg)) {
> +               con->v2.in_state = IN_S_PREPARE_READ_DATA;
>         } else {
>                 add_in_kvec(con, con->v2.in_buf, CEPH_EPILOGUE_PLAIN_LEN);
> +               con->v2.in_state = IN_S_HANDLE_EPILOGUE;
> +       }
> +}
> +
> +static void prepare_read_enc_page(struct ceph_connection *con)
> +{
> +       struct bio_vec bv;
> +
> +       dout("%s con %p i %d resid %d\n", __func__, con, con->v2.in_enc_i,
> +            con->v2.in_enc_resid);
> +       WARN_ON(!con->v2.in_enc_resid);
> +
> +       bv.bv_page = con->v2.in_enc_pages[con->v2.in_enc_i];
> +       bv.bv_offset = 0;
> +       bv.bv_len = min(con->v2.in_enc_resid, (int)PAGE_SIZE);
> +
> +       set_in_bvec(con, &bv);
> +       con->v2.in_enc_i++;
> +       con->v2.in_enc_resid -= bv.bv_len;
> +
> +       if (con->v2.in_enc_resid) {
> +               con->v2.in_state = IN_S_PREPARE_READ_ENC_PAGE;
> +               return;
>         }
> +
> +       /*
> +        * We are set to read the last piece of ciphertext (ending
> +        * with epilogue) + auth tag.
> +        */
> +       WARN_ON(con->v2.in_enc_i != con->v2.in_enc_page_cnt);
>         con->v2.in_state = IN_S_HANDLE_EPILOGUE;
>  }
>
> +static int prepare_read_tail_secure(struct ceph_connection *con)
> +{
> +       struct page **enc_pages;
> +       int enc_page_cnt;
> +       int tail_len;
> +
> +       tail_len = tail_onwire_len(con->in_msg, true);
> +       WARN_ON(!tail_len);
> +
> +       enc_page_cnt = calc_pages_for(0, tail_len);
> +       enc_pages = ceph_alloc_page_vector(enc_page_cnt, GFP_NOIO);
> +       if (IS_ERR(enc_pages))
> +               return PTR_ERR(enc_pages);
> +
> +       WARN_ON(con->v2.in_enc_pages || con->v2.in_enc_page_cnt);
> +       con->v2.in_enc_pages = enc_pages;
> +       con->v2.in_enc_page_cnt = enc_page_cnt;
> +       con->v2.in_enc_resid = tail_len;
> +       con->v2.in_enc_i = 0;
> +
> +       prepare_read_enc_page(con);
> +       return 0;
> +}
> +
>  static void __finish_skip(struct ceph_connection *con)
>  {
>         con->in_seq++;
> @@ -2589,46 +2686,13 @@ static int __handle_control(struct ceph_connection *con, void *p)
>         }
>
>         msg = con->in_msg;  /* set in process_message_header() */
> -       if (!front_len(msg) && !middle_len(msg)) {
> -               if (!data_len(msg))
> -                       return process_message(con);
> -
> -               prepare_read_data(con);
> -               return 0;
> -       }
> -
> -       reset_in_kvecs(con);
> -       if (front_len(msg)) {
> -               WARN_ON(front_len(msg) > msg->front_alloc_len);
> -               add_in_kvec(con, msg->front.iov_base, front_len(msg));
> -               msg->front.iov_len = front_len(msg);
> -
> -               if (con_secure(con) && need_padding(front_len(msg)))
> -                       add_in_kvec(con, FRONT_PAD(con->v2.in_buf),
> -                                   padding_len(front_len(msg)));
> -       } else {
> -               msg->front.iov_len = 0;
> -       }
> -       if (middle_len(msg)) {
> -               WARN_ON(middle_len(msg) > msg->middle->alloc_len);
> -               add_in_kvec(con, msg->middle->vec.iov_base, middle_len(msg));
> -               msg->middle->vec.iov_len = middle_len(msg);
> +       if (!front_len(msg) && !middle_len(msg) && !data_len(msg))
> +               return process_message(con);
>
> -               if (con_secure(con) && need_padding(middle_len(msg)))
> -                       add_in_kvec(con, MIDDLE_PAD(con->v2.in_buf),
> -                                   padding_len(middle_len(msg)));
> -       } else if (msg->middle) {
> -               msg->middle->vec.iov_len = 0;
> -       }
> +       if (con_secure(con))
> +               return prepare_read_tail_secure(con);

This isn't quite right: the front and/or middle iov_len isn't set in
secure mode.  In most cases it's irrelevant but it does cause issues
with code like:

    void *p = buf;
    void *end = buf + len;

    ...
    advance p
    ...

    if (p != end)
            goto bad;

I have folded in the attached incremental.

Thanks,

                Ilya

--0000000000008d7d1405d70c9e61
Content-Type: text/x-patch; charset="US-ASCII"; name="always-set-iov-len.diff"
Content-Disposition: attachment; filename="always-set-iov-len.diff"
Content-Transfer-Encoding: base64
Content-ID: <f_kz5uf16n0>
X-Attachment-Id: f_kz5uf16n0

ZGlmZiAtLWdpdCBhL25ldC9jZXBoL21lc3Nlbmdlcl92Mi5jIGIvbmV0L2NlcGgvbWVzc2VuZ2Vy
X3YyLmMKaW5kZXggOGExMDFmNWQ0YzIzLi5jODEzNzlmOTNhZDUgMTAwNjQ0Ci0tLSBhL25ldC9j
ZXBoL21lc3Nlbmdlcl92Mi5jCisrKyBiL25ldC9jZXBoL21lc3Nlbmdlcl92Mi5jCkBAIC0xODM0
LDE4ICsxODM0LDEyIEBAIHN0YXRpYyBpbnQgcHJlcGFyZV9yZWFkX3RhaWxfcGxhaW4oc3RydWN0
IGNlcGhfY29ubmVjdGlvbiAqY29uKQogCiAJcmVzZXRfaW5fa3ZlY3MoY29uKTsKIAlpZiAoZnJv
bnRfbGVuKG1zZykpIHsKLQkJV0FSTl9PTihmcm9udF9sZW4obXNnKSA+IG1zZy0+ZnJvbnRfYWxs
b2NfbGVuKTsKIAkJYWRkX2luX2t2ZWMoY29uLCBtc2ctPmZyb250Lmlvdl9iYXNlLCBmcm9udF9s
ZW4obXNnKSk7Ci0JCW1zZy0+ZnJvbnQuaW92X2xlbiA9IGZyb250X2xlbihtc2cpOwotCX0gZWxz
ZSB7Ci0JCW1zZy0+ZnJvbnQuaW92X2xlbiA9IDA7CisJCVdBUk5fT04obXNnLT5mcm9udC5pb3Zf
bGVuICE9IGZyb250X2xlbihtc2cpKTsKIAl9CiAJaWYgKG1pZGRsZV9sZW4obXNnKSkgewotCQlX
QVJOX09OKG1pZGRsZV9sZW4obXNnKSA+IG1zZy0+bWlkZGxlLT5hbGxvY19sZW4pOwogCQlhZGRf
aW5fa3ZlYyhjb24sIG1zZy0+bWlkZGxlLT52ZWMuaW92X2Jhc2UsIG1pZGRsZV9sZW4obXNnKSk7
Ci0JCW1zZy0+bWlkZGxlLT52ZWMuaW92X2xlbiA9IG1pZGRsZV9sZW4obXNnKTsKLQl9IGVsc2Ug
aWYgKG1zZy0+bWlkZGxlKSB7Ci0JCW1zZy0+bWlkZGxlLT52ZWMuaW92X2xlbiA9IDA7CisJCVdB
Uk5fT04obXNnLT5taWRkbGUtPnZlYy5pb3ZfbGVuICE9IG1pZGRsZV9sZW4obXNnKSk7CiAJfQog
CiAJaWYgKGRhdGFfbGVuKG1zZykpIHsKQEAgLTI3MTgsNiArMjcxMiwxOSBAQCBzdGF0aWMgaW50
IF9faGFuZGxlX2NvbnRyb2woc3RydWN0IGNlcGhfY29ubmVjdGlvbiAqY29uLCB2b2lkICpwKQog
CX0KIAogCW1zZyA9IGNvbi0+aW5fbXNnOyAgLyogc2V0IGluIHByb2Nlc3NfbWVzc2FnZV9oZWFk
ZXIoKSAqLworCWlmIChmcm9udF9sZW4obXNnKSkgeworCQlXQVJOX09OKGZyb250X2xlbihtc2cp
ID4gbXNnLT5mcm9udF9hbGxvY19sZW4pOworCQltc2ctPmZyb250Lmlvdl9sZW4gPSBmcm9udF9s
ZW4obXNnKTsKKwl9IGVsc2UgeworCQltc2ctPmZyb250Lmlvdl9sZW4gPSAwOworCX0KKwlpZiAo
bWlkZGxlX2xlbihtc2cpKSB7CisJCVdBUk5fT04obWlkZGxlX2xlbihtc2cpID4gbXNnLT5taWRk
bGUtPmFsbG9jX2xlbik7CisJCW1zZy0+bWlkZGxlLT52ZWMuaW92X2xlbiA9IG1pZGRsZV9sZW4o
bXNnKTsKKwl9IGVsc2UgaWYgKG1zZy0+bWlkZGxlKSB7CisJCW1zZy0+bWlkZGxlLT52ZWMuaW92
X2xlbiA9IDA7CisJfQorCiAJaWYgKCFmcm9udF9sZW4obXNnKSAmJiAhbWlkZGxlX2xlbihtc2cp
ICYmICFkYXRhX2xlbihtc2cpKQogCQlyZXR1cm4gcHJvY2Vzc19tZXNzYWdlKGNvbik7CiAK
--0000000000008d7d1405d70c9e61--
