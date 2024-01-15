Return-Path: <ceph-devel+bounces-526-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A37382E2AC
	for <lists+ceph-devel@lfdr.de>; Mon, 15 Jan 2024 23:39:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 95BF91F22E27
	for <lists+ceph-devel@lfdr.de>; Mon, 15 Jan 2024 22:39:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E01581B5BB;
	Mon, 15 Jan 2024 22:38:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H5OG/58I"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-oo1-f46.google.com (mail-oo1-f46.google.com [209.85.161.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22D6F1B5B8
	for <ceph-devel@vger.kernel.org>; Mon, 15 Jan 2024 22:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oo1-f46.google.com with SMTP id 006d021491bc7-595ac2b6c59so5438239eaf.2
        for <ceph-devel@vger.kernel.org>; Mon, 15 Jan 2024 14:38:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705358333; x=1705963133; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+rAAD5/OdC4L7T0ffszDNaQQHw/cQYt1kgGVLYndClI=;
        b=H5OG/58I5dGE62pVwec5hF9Bq6TdlkIGW+vguuaN7qsVQ21IUg+ZuI7K9XQqAzoAQj
         Yukz+CtWY13hH1ULgaPGFVA9PyMNHTED8D+BPX5h8jsILzunAEdvCkqagHqPNcJE2Bmi
         OuUzvqLNywOOtpB7SAxBaGGd53FXY0QP/gP4A6/8PF31RSN1asB/zZdXDjKFtB3V4HwZ
         Bp8lbO4NzOTEKZLgBwXU5zoqZaKG/DbCCnbHKvuApZiCVE7uJ3qm5Ob/fuEv0wmCrDxz
         8081ZxIlhiXIXWj96YaTDKeBQpLW0szYNqxWI6RKW9PVM+eL54YJ1CwMtGiBJ9q1qfdt
         U1Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705358333; x=1705963133;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+rAAD5/OdC4L7T0ffszDNaQQHw/cQYt1kgGVLYndClI=;
        b=LOsySKIRJozAy3rN9GhwnFDAHoFV4Aukq9sdKeX8bsB/gqBX9UegVowuqgQE6JWf8j
         V8GjLPfe44L+5MZq6dqeFF7pGl8n8xW0Ml2TO42fEOSkob7F8168QF0WhJzt3BoMvmty
         TJ1kkQdszYDXPpwtM5lL/Qw19GwkCkfSrzftAUZxCnHr2szIaB5xgN8JcSNaM3or5yR0
         M/Q+djeUT2aSzsc0pJq4IaicXyr+IQjXmyEtb18bFkJbAhlV9vYUmEKmEqOVNb8ZO8XQ
         E+jrkw6GEpN6BVZRYffGx1ylUk40UzNwDg2D2/DqqN+PgPIvTuC3A04TUmovaVD1VzSA
         DHmw==
X-Gm-Message-State: AOJu0Yx12a2tq8Fw/oxHz+T4nOe6vP10HUehPMBZb8cH5fLMzrX4wwy5
	wb+vB92ZQbjFnKdYGltr0mJwSu0rBUJuDwW0I6HcaVH/hDw=
X-Google-Smtp-Source: AGHT+IEAeW6+lnSXtX0yPJit0IbcIFWnWXPYDL0m+RVU5h+07vV5P79XMZF+hthIUTzMWIcFt+bttmPfBlumlrwutyQ=
X-Received: by 2002:a4a:3119:0:b0:598:c216:1c70 with SMTP id
 k25-20020a4a3119000000b00598c2161c70mr3188268ooa.17.1705358333081; Mon, 15
 Jan 2024 14:38:53 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231215002034.205780-1-xiubli@redhat.com> <20231215002034.205780-4-xiubli@redhat.com>
In-Reply-To: <20231215002034.205780-4-xiubli@redhat.com>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Mon, 15 Jan 2024 23:38:40 +0100
Message-ID: <CAOi1vP9ZOyNVC4yquNK6QUFWDr6z+M1e9M2St7uPhRkhfL7QPA@mail.gmail.com>
Subject: Re: [PATCH v3 3/3] libceph: just wait for more data to be available
 on the socket
To: xiubli@redhat.com
Cc: ceph-devel@vger.kernel.org, jlayton@kernel.org, vshankar@redhat.com, 
	mchangir@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 15, 2023 at 1:22=E2=80=AFAM <xiubli@redhat.com> wrote:
>
> From: Xiubo Li <xiubli@redhat.com>
>
> The messages from ceph maybe split into multiple socket packages
> and we just need to wait for all the data to be availiable on the
> sokcet.
>
> This will add 'sr_total_resid' to record the total length for all
> data items for sparse-read message and 'sr_resid_elen' to record
> the current extent total length.
>
> URL: https://tracker.ceph.com/issues/63586
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  include/linux/ceph/messenger.h |  2 ++
>  net/ceph/messenger.c           |  1 +
>  net/ceph/messenger_v1.c        | 21 ++++++++++++++++-----
>  net/ceph/osd_client.c          |  1 +
>  4 files changed, 20 insertions(+), 5 deletions(-)
>
> diff --git a/include/linux/ceph/messenger.h b/include/linux/ceph/messenge=
r.h
> index 2eaaabbe98cb..05e9b39a58f8 100644
> --- a/include/linux/ceph/messenger.h
> +++ b/include/linux/ceph/messenger.h
> @@ -231,10 +231,12 @@ struct ceph_msg_data {
>
>  struct ceph_msg_data_cursor {
>         size_t                  total_resid;    /* across all data items =
*/
> +       size_t                  sr_total_resid; /* across all data items =
for sparse-read */
>
>         struct ceph_msg_data    *data;          /* current data item */
>         size_t                  resid;          /* bytes not yet consumed=
 */
>         int                     sr_resid;       /* residual sparse_read l=
en */
> +       int                     sr_resid_elen;  /* total sparse_read elen=
 */

Hi Xiubo,

Is adding yet another sparse-read field to the cursor really needed?
Would making read_partial_sparse_msg_extent() decrement sr_total_resid
as it goes just like sr_resid is decremented work?

>         bool                    need_crc;       /* crc update needed */
>         union {
>  #ifdef CONFIG_BLOCK
> diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
> index 3c8b78d9c4d1..eafd592af382 100644
> --- a/net/ceph/messenger.c
> +++ b/net/ceph/messenger.c
> @@ -1073,6 +1073,7 @@ void ceph_msg_data_cursor_init(struct ceph_msg_data=
_cursor *cursor,
>         cursor->total_resid =3D length;
>         cursor->data =3D msg->data;
>         cursor->sr_resid =3D 0;
> +       cursor->sr_resid_elen =3D 0;
>
>         __ceph_msg_data_cursor_init(cursor);
>  }
> diff --git a/net/ceph/messenger_v1.c b/net/ceph/messenger_v1.c
> index 4cb60bacf5f5..7425fa26e4c3 100644
> --- a/net/ceph/messenger_v1.c
> +++ b/net/ceph/messenger_v1.c
> @@ -160,7 +160,9 @@ static size_t sizeof_footer(struct ceph_connection *c=
on)
>  static void prepare_message_data(struct ceph_msg *msg, u32 data_len)
>  {
>         /* Initialize data cursor if it's not a sparse read */
> -       if (!msg->sparse_read)
> +       if (msg->sparse_read)
> +               msg->cursor.sr_total_resid =3D data_len;
> +       else
>                 ceph_msg_data_cursor_init(&msg->cursor, msg, data_len);
>  }
>
> @@ -1032,18 +1034,25 @@ static int read_partial_sparse_msg_data(struct ce=
ph_connection *con)
>         bool do_datacrc =3D !ceph_test_opt(from_msgr(con->msgr), NOCRC);
>         u32 crc =3D 0;
>         int ret =3D 1;
> +       int len;
>
>         if (do_datacrc)
>                 crc =3D con->in_data_crc;
>
> -       do {
> -               if (con->v1.in_sr_kvec.iov_base)
> +       while (cursor->sr_total_resid && ret > 0) {
> +               len =3D 0;
> +               if (con->v1.in_sr_kvec.iov_base) {
>                         ret =3D read_partial_message_chunk(con,
>                                                          &con->v1.in_sr_k=
vec,
>                                                          con->v1.in_sr_le=
n,
>                                                          &crc);
> -               else if (cursor->sr_resid > 0)
> +                       if (ret =3D=3D 1)
> +                               len =3D con->v1.in_sr_len;
> +               } else if (cursor->sr_resid > 0) {
>                         ret =3D read_partial_sparse_msg_extent(con, &crc)=
;
> +                       if (ret =3D=3D 1)
> +                               len =3D cursor->sr_resid_elen;
> +               }

I was waiting for Jeff's review since this is his code, but it's been
a while so I'll just comment.

To me, it's a sign of suboptimal structure that you needed to add new
fields to the cursor just to be able tell whether this function is done
with the message, because it's something that is already tracked but
gets lost between the loops here.

Currently this function is structured as:

    do {
        if (set up for kvec)
           read as much as possible into kvec
        else if (set up for pages)
           read as much as possible into pages

        if (short read)
            bail, will be called again later

         invoke con->ops->sparse_read() for processing the thing what
         was read and setting up the next read OR setting up the initial
         read
    } until (con->ops->sparse_read() returns "done")

If it was me, I would pursue refactoring this to:

    do {
        if (set up for kvec)
           read as much as possible into kvec
        else if (set up for pages)
           read as much as possible into pages
        else
           bail

        if (short read)
            bail, will be called again later

         invoke con->ops->sparse_read() for processing the thing that
         was read and setting up the next read
    } until (con->ops->sparse_read() returns "done")

... and invoke con->ops->sparse_read() for the first time elsewhere,
likely in prepare_message_data().  The rationale is that the state
machine inside con->ops->sparse_read() is conceptually a cursor and
prepare_message_data() is where the cursor is initialized for normal
reads.  This way no additional state should be needed.

Thanks,

                Ilya

