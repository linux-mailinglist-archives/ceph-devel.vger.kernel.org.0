Return-Path: <ceph-devel+bounces-532-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9906B82EEB2
	for <lists+ceph-devel@lfdr.de>; Tue, 16 Jan 2024 13:07:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 42F9C285425
	for <lists+ceph-devel@lfdr.de>; Tue, 16 Jan 2024 12:07:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 861391B961;
	Tue, 16 Jan 2024 12:07:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FevBUEyr"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-oo1-f47.google.com (mail-oo1-f47.google.com [209.85.161.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C29F31B96B
	for <ceph-devel@vger.kernel.org>; Tue, 16 Jan 2024 12:07:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oo1-f47.google.com with SMTP id 006d021491bc7-59914f58a5aso472019eaf.1
        for <ceph-devel@vger.kernel.org>; Tue, 16 Jan 2024 04:07:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705406824; x=1706011624; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Jo6cMmWjDP8vTsTwvXOFG9BuF5m5XWBGmlvIY57uU4g=;
        b=FevBUEyrGuz14u/TRRJ3ZtfKy1BTYqoITHe6E3tlWotPMj1VIhK7o9TV6cg0l3R+eI
         /Jgm+xkDleYo0N2tHuf10fQ8ipr/NPm0f6aFD+0AX2MkZgql37n+gNOlgQiMVi+khzps
         SkfStlgNxf45qVtCE7vA/QAMpgMrAX/rNmaMAK0sLu0m2QAobZrEtY1s4kEqzTo4WrOK
         QpFTec6nln+fxHqiDu9Ttkk0M3zbsqLAPZsulyYBWk1M1CP0aOogV1ZOEBj92GLkVbQ6
         EOxcSU4CiSZe6HyatlykM1RQrer9bkdXOJ1nCtvV5KxjHPm3B4QgUsFlgz5KVwS/O634
         z2BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705406824; x=1706011624;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Jo6cMmWjDP8vTsTwvXOFG9BuF5m5XWBGmlvIY57uU4g=;
        b=NAhL73p93GdxxzRo4VmGNoVJK6Kc5SatL8MRw8rMqqT3+48C20MtzY3AkgPNm8vOrT
         GrUjyq7zKEpKElP2Q/EnM7XRvbNRWevKbpS1WjolPpu9Z0Twdn8r154s34eCpFOnnHIF
         e00fvL4eyfQIcg1H2Af0D4IqLruoO3w5u5CiYqin+7Lehu0Ss43qafvRqdQ0U9KkGYAM
         jhJBoEotpxmRLhkUdEVow9vBGLXyEc+ckXfiQNJ+bd+Q5tQ3PKB32ooofVtsRHFjI+/2
         qjgAVKzXRrKRVCpe98JEJRQy+eXUqHyS8Nm055cSco1GtwH5jCFcTQsaffrmGZsTOnU5
         b8Fw==
X-Gm-Message-State: AOJu0Yz7m7NKuvAHWJsimu0uFR176v8YnSIwqwmbn5ECJ+gb72EpTMUc
	K4hJiQOBwIcV1rxeGouZg4UDheMJ4mTLpYr1jSkHD1YkZUo=
X-Google-Smtp-Source: AGHT+IGxmS2z8PgcX9e3t/X9EOnk1iZi6ckEJUdksEcg/q8uESnz1VCNWPo2c6Bx6zEq6wPQ83yyY+nVdRM1c6DBwFc=
X-Received: by 2002:a05:6820:171:b0:597:9fc3:254d with SMTP id
 k17-20020a056820017100b005979fc3254dmr1000351ood.2.1705406823763; Tue, 16 Jan
 2024 04:07:03 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231215002034.205780-1-xiubli@redhat.com> <20231215002034.205780-4-xiubli@redhat.com>
 <CAOi1vP9ZOyNVC4yquNK6QUFWDr6z+M1e9M2St7uPhRkhfL7QPA@mail.gmail.com>
 <a1d6e998-f496-4408-9d76-3671ee73e054@redhat.com> <CAOi1vP8xOFA4QgMwjGyzTJuAC6T6+XDypXW3Dhhin0RnUh-ZAQ@mail.gmail.com>
 <35849fda-29b2-47ad-bf49-f2715efc7b8c@redhat.com>
In-Reply-To: <35849fda-29b2-47ad-bf49-f2715efc7b8c@redhat.com>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Tue, 16 Jan 2024 13:06:51 +0100
Message-ID: <CAOi1vP8KSboFmLJdhiM06zNnx7LZiaLt3x=psP6VaOiuXZ5uRQ@mail.gmail.com>
Subject: Re: [PATCH v3 3/3] libceph: just wait for more data to be available
 on the socket
To: Xiubo Li <xiubli@redhat.com>
Cc: ceph-devel@vger.kernel.org, jlayton@kernel.org, vshankar@redhat.com, 
	mchangir@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 16, 2024 at 11:45=E2=80=AFAM Xiubo Li <xiubli@redhat.com> wrote=
:
>
>
> On 1/16/24 18:00, Ilya Dryomov wrote:
>
> On Tue, Jan 16, 2024 at 5:09=E2=80=AFAM Xiubo Li <xiubli@redhat.com> wrot=
e:
>
> On 1/16/24 06:38, Ilya Dryomov wrote:
>
> On Fri, Dec 15, 2023 at 1:22=E2=80=AFAM <xiubli@redhat.com> wrote:
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
>
> Hi Xiubo,
>
> Is adding yet another sparse-read field to the cursor really needed?
> Would making read_partial_sparse_msg_extent() decrement sr_total_resid
> as it goes just like sr_resid is decremented work?
>
> This can be improved by removing it. Let me fix it.
>
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
>
> I was waiting for Jeff's review since this is his code, but it's been
> a while so I'll just comment.
>
> To me, it's a sign of suboptimal structure that you needed to add new
> fields to the cursor just to be able tell whether this function is done
> with the message, because it's something that is already tracked but
> gets lost between the loops here.
>
> Currently this function is structured as:
>
>     do {
>         if (set up for kvec)
>            read as much as possible into kvec
>         else if (set up for pages)
>            read as much as possible into pages
>
>         if (short read)
>             bail, will be called again later
>
>          invoke con->ops->sparse_read() for processing the thing what
>          was read and setting up the next read OR setting up the initial
>          read
>     } until (con->ops->sparse_read() returns "done")
>
> If it was me, I would pursue refactoring this to:
>
>     do {
>         if (set up for kvec)
>            read as much as possible into kvec
>         else if (set up for pages)
>            read as much as possible into pages
>         else
>            bail
>
> Why bail here ? For the new sparse read both the 'kvec' and 'pages' shoul=
dn't be set, so the following '->sparse_read()' will set up them and contin=
ue.
>
> Or you just want the 'read_partial_sparse_msg_data()' to read data but no=
t the first time to trigger the '->sparse_read()' ? Before I tried a simila=
r approach and it was not as optional as this one as I do.
>
> Hi Xiubo,
>
> I addressed that in the previous message:
>
>     ... and invoke con->ops->sparse_read() for the first time elsewhere,
>     likely in prepare_message_data().  The rationale is that the state
>     machine inside con->ops->sparse_read() is conceptually a cursor and
>     prepare_message_data() is where the cursor is initialized for normal
>     reads.
>
> The benefit is that no additional state would be needed.
>
> Sorry, which state do you mean here ?  Is the 'sr_total_resid' ?

Yes.

                Ilya

