Return-Path: <ceph-devel+bounces-530-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9933D82EC79
	for <lists+ceph-devel@lfdr.de>; Tue, 16 Jan 2024 11:01:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6765F1C22B6A
	for <lists+ceph-devel@lfdr.de>; Tue, 16 Jan 2024 10:01:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1408E1B7F7;
	Tue, 16 Jan 2024 10:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AljnCxbg"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-oo1-f54.google.com (mail-oo1-f54.google.com [209.85.161.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 415621B7ED
	for <ceph-devel@vger.kernel.org>; Tue, 16 Jan 2024 10:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oo1-f54.google.com with SMTP id 006d021491bc7-598dfed6535so1447675eaf.0
        for <ceph-devel@vger.kernel.org>; Tue, 16 Jan 2024 02:00:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705399218; x=1706004018; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fseC8UXBuADa/pKJIdDQ0qJOUNGx5GVC4FkOhJYySFI=;
        b=AljnCxbgjir0fKAvj7FJjXPYpXOo7VMGdjCMbjfGLQ4PBAGGjHNzZriP9gWaOmv6K3
         prXKY9eisaHae17EFFlebbjxcqzSfZJlwAYYYCpWGTt6QL2V3CL0fMz96Gt39XgLrZXD
         +wVXiUPAx5ICusLNdzrw1rwmhPFpAlo7DKArx88l2NdYg2ryb9wzQorxcXXIXc09MmqC
         9w1GiuHLhuwGHDMVqij9eZZpHjWZ3qrXmau8VNOdjXdw5ElV2YtbKO3ud6odRPJqkYjG
         6KKp+vvnngRTZ5ZAn7qq2/PwCJsnD6iPQbV8cwB7CE2BAJpI50iw0kRmDAkSFxiCer+U
         K5yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705399218; x=1706004018;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fseC8UXBuADa/pKJIdDQ0qJOUNGx5GVC4FkOhJYySFI=;
        b=O8Ww1W/sXjgNCwSvNBMqwPHMmEmrNGGjRkkwuqtDlT3ndSODH0gK7QXvh3+LRBHglF
         373Mk3qZHO9zDkcm6A2boP3bL5x2bFuFfuG64f1HHhs3zTidUYgm/9ZpUfavcCBJ373+
         VJazs0kYiF606whcjjxkZ4I6zU9nckwPz/nGxXwptnzc34xVslqm5A+TYZgWR851d/VU
         YE04ezsHmBOoTYB7w+kXItHCIQTkRQGpHsLaO+97TgCtuhKgMsNXszw/S5cpBXiopuap
         4dFus/qB0f6k9S+t6yZrqB5vW+cLskq3Y5fnaAl62nHvNfnXRdAcfnqaoRBEVQBIhH+F
         3ehg==
X-Gm-Message-State: AOJu0Yyy7zJOJN86S8PZ/62FH0N5kNEl5SkCVRJLzTgZpyU6QexEsp+2
	bpyYWseqeYwCdnvGmazPkaJ7LSE0QE1PTgcNp9Mqn6t3HeE=
X-Google-Smtp-Source: AGHT+IFkyU1u51HleZwIYjjqma4ceGWCP/ndCJtQ7LYORAzzd/drxAs2W4nLtncPXfvrbmbMi+RiNfjPKnJmCMroTD8=
X-Received: by 2002:a4a:ac89:0:b0:598:4160:406e with SMTP id
 b9-20020a4aac89000000b005984160406emr3626364oon.0.1705399218271; Tue, 16 Jan
 2024 02:00:18 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231215002034.205780-1-xiubli@redhat.com> <20231215002034.205780-4-xiubli@redhat.com>
 <CAOi1vP9ZOyNVC4yquNK6QUFWDr6z+M1e9M2St7uPhRkhfL7QPA@mail.gmail.com> <a1d6e998-f496-4408-9d76-3671ee73e054@redhat.com>
In-Reply-To: <a1d6e998-f496-4408-9d76-3671ee73e054@redhat.com>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Tue, 16 Jan 2024 11:00:05 +0100
Message-ID: <CAOi1vP8xOFA4QgMwjGyzTJuAC6T6+XDypXW3Dhhin0RnUh-ZAQ@mail.gmail.com>
Subject: Re: [PATCH v3 3/3] libceph: just wait for more data to be available
 on the socket
To: Xiubo Li <xiubli@redhat.com>
Cc: ceph-devel@vger.kernel.org, jlayton@kernel.org, vshankar@redhat.com, 
	mchangir@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 16, 2024 at 5:09=E2=80=AFAM Xiubo Li <xiubli@redhat.com> wrote:
>
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

Hi Xiubo,

I addressed that in the previous message:

    ... and invoke con->ops->sparse_read() for the first time elsewhere,
    likely in prepare_message_data().  The rationale is that the state
    machine inside con->ops->sparse_read() is conceptually a cursor and
    prepare_message_data() is where the cursor is initialized for normal
    reads.

The benefit is that no additional state would be needed.

> The 'cursor->sr_total_resid', which is similar with 'cursor->total_resid'=
, will just record the total data length for current sparse-read request an=
d will determine whether should we skip parsing the "(page) data" in 'read_=
partial_message()'.

I understand the intent behind cursor->sr_total_resid, but it would be
nice to do without it because of its inherent redundancy.

Did you try calling con->ops->sparse_read() for the first time exactly
where cursor->sr_total_resid is initialized in your patch?

Thanks,

                Ilya

