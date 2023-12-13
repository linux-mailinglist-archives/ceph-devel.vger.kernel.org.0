Return-Path: <ceph-devel+bounces-282-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DEAE7811286
	for <lists+ceph-devel@lfdr.de>; Wed, 13 Dec 2023 14:08:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 96009281D78
	for <lists+ceph-devel@lfdr.de>; Wed, 13 Dec 2023 13:08:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F04882C854;
	Wed, 13 Dec 2023 13:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QOJEKtk5"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19D29B2
	for <ceph-devel@vger.kernel.org>; Wed, 13 Dec 2023 05:07:53 -0800 (PST)
Received: by mail-ot1-x335.google.com with SMTP id 46e09a7af769-6d9ac148ca3so4898861a34.0
        for <ceph-devel@vger.kernel.org>; Wed, 13 Dec 2023 05:07:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702472872; x=1703077672; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eGfqngPBj5cqJbRswaQhJWcEvmCpEYTdkxXyTjhLvSg=;
        b=QOJEKtk5xaReE6MJ1APhHb0oBfruhBcNzPTM4E07oZFhUitWZ3xtLKZuNXleWEH3d/
         aW++HrXOzGDN0dxA7j73+pOEKT8Ag9eLUVjvuFR4QZRC7ToIlEjAGTl4kKX/Wx/HSgkZ
         zDB4ZtGJtCOtiOY+7bBGPFYo/60sdblxmBe2DaC5fR1Ty0rxHqiVBPSxGDpK4Wo0uQpg
         uIYuRTv3ImBtM0apNCtzrqEzXqNfKf3W6kdHx650IvZmYWXbC7lVDhq1NZqFcOSX9qyS
         Zy0Mz/tI78u/8U77oTFoAetvX1m3y7YUOT6r5tdXuUpa3B6GDyWGfn33qeTJOmNNtiS4
         6O7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702472872; x=1703077672;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eGfqngPBj5cqJbRswaQhJWcEvmCpEYTdkxXyTjhLvSg=;
        b=iurQH2YrUNEnYkPqJiR22cWrR6451ha1CeKvVWne3OQADc2KGzDACzrTdg+6C36p2J
         UaZhtvGVATg41VDB0You//SoRMNdE72L0gORZzAsqm9tA9wS3UdTCN6shjuS+fpfp3EQ
         MIQCOIX71r+22Dsz0HKjS7KsLhNKiz9enHtMht60z2dsjp08m60upUe7xaPhjt06BIkO
         6gKVZGS8MHl6o6xs1ZRZyzED9sed7GleXDSdrjMVoQT6otkg2s6Ue+IQ6mJIdr4wz82H
         ABXuR64GRidhflzrkljB9PPhK26aEML4/ygVFvRZCHx4Al+2mR1gW+3tcwZe7PP3sfDi
         P0XQ==
X-Gm-Message-State: AOJu0YzUb9184T7J0bxgr0gYUo0QuKJmDU1As8neN3aWfnS6Ki3YRrnp
	YRGR3G8YA2y59zs6eVFR/cVX/EnJs+sgo22Y16M=
X-Google-Smtp-Source: AGHT+IGihuWvIXau6Me6uZOL/zYSHTJzFxuQNZuHB50jgGBnqA554p2L6lbhnvDgaFkKYA9usWI2PzIP+nRANyo2Mnc=
X-Received: by 2002:a9d:7511:0:b0:6d9:f53d:f745 with SMTP id
 r17-20020a9d7511000000b006d9f53df745mr7175513otk.15.1702472872267; Wed, 13
 Dec 2023 05:07:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231208160601.124892-1-xiubli@redhat.com> <20231208160601.124892-3-xiubli@redhat.com>
 <CAOi1vP8ft0nFh2qdQDRpGr7gPCj3HHDzY4Q7i69WQLiASPxNyw@mail.gmail.com>
 <af3d24bc-0a4f-4e30-ba3d-80d41a7fd94c@redhat.com> <CAOi1vP9EzGZM=U1jDzAnTwFvWD6fpZ+qMedgOQuK79qOodU+NQ@mail.gmail.com>
 <008fe687-9df0-45d2-929c-168a10222b2f@redhat.com> <CAOi1vP9yYkv+cxazfwbrKD0g2LcS9Pa0PLF33kAf4uKvDXgoLQ@mail.gmail.com>
 <9115452a-0ca0-4760-9407-bcc3146134ff@redhat.com>
In-Reply-To: <9115452a-0ca0-4760-9407-bcc3146134ff@redhat.com>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Wed, 13 Dec 2023 14:07:40 +0100
Message-ID: <CAOi1vP-NLswzoSFjctyJdXW2qHetLPn89pLeHtiP=tQeGBXvfg@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] libceph: just wait for more data to be available
 on the socket
To: Xiubo Li <xiubli@redhat.com>
Cc: ceph-devel@vger.kernel.org, jlayton@kernel.org, vshankar@redhat.com, 
	mchangir@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 13, 2023 at 1:05=E2=80=AFPM Xiubo Li <xiubli@redhat.com> wrote:
>
>
> On 12/13/23 19:54, Ilya Dryomov wrote:
>
> On Wed, Dec 13, 2023 at 12:03=E2=80=AFPM Xiubo Li <xiubli@redhat.com> wro=
te:
>
> On 12/13/23 18:31, Ilya Dryomov wrote:
>
> On Wed, Dec 13, 2023 at 2:02=E2=80=AFAM Xiubo Li <xiubli@redhat.com> wrot=
e:
>
> On 12/13/23 00:31, Ilya Dryomov wrote:
>
> On Fri, Dec 8, 2023 at 5:08=E2=80=AFPM <xiubli@redhat.com> wrote:
>
> From: Xiubo Li <xiubli@redhat.com>
>
> The messages from ceph maybe split into multiple socket packages
> and we just need to wait for all the data to be availiable on the
> sokcet.
>
> This will add a new _FINISH state for the sparse-read to mark the
> current sparse-read succeeded. Else it will treat it as a new
> sparse-read when the socket receives the last piece of the osd
> request reply message, and the cancel_request() later will help
> init the sparse-read context.
>
> URL: https://tracker.ceph.com/issues/63586
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>    include/linux/ceph/osd_client.h | 1 +
>    net/ceph/osd_client.c           | 6 +++---
>    2 files changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/osd_cli=
ent.h
> index 493de3496cd3..00d98e13100f 100644
> --- a/include/linux/ceph/osd_client.h
> +++ b/include/linux/ceph/osd_client.h
> @@ -47,6 +47,7 @@ enum ceph_sparse_read_state {
>           CEPH_SPARSE_READ_DATA_LEN,
>           CEPH_SPARSE_READ_DATA_PRE,
>           CEPH_SPARSE_READ_DATA,
> +       CEPH_SPARSE_READ_FINISH,
>    };
>
>    /*
> diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
> index 848ef19055a0..f1705b4f19eb 100644
> --- a/net/ceph/osd_client.c
> +++ b/net/ceph/osd_client.c
> @@ -5802,8 +5802,6 @@ static int prep_next_sparse_read(struct ceph_connec=
tion *con,
>                           advance_cursor(cursor, sr->sr_req_len - end, fa=
lse);
>           }
>
> -       ceph_init_sparse_read(sr);
> -
>           /* find next op in this request (if any) */
>           while (++o->o_sparse_op_idx < req->r_num_ops) {
>                   op =3D &req->r_ops[o->o_sparse_op_idx];
> @@ -5919,7 +5917,7 @@ static int osd_sparse_read(struct ceph_connection *=
con,
>                                   return -EREMOTEIO;
>                           }
>
> -                       sr->sr_state =3D CEPH_SPARSE_READ_HDR;
> +                       sr->sr_state =3D CEPH_SPARSE_READ_FINISH;
>                           goto next_op;
>
> Hi Xiubo,
>
> This code appears to be set up to handle multiple (sparse-read) ops in
> a single OSD request.  Wouldn't this break that case?
>
> Yeah, it will break it. I just missed it.
>
> I think the bug is in read_sparse_msg_data().  It shouldn't be calling
> con->ops->sparse_read() after the message has progressed to the footer.
> osd_sparse_read() is most likely fine as is.
>
> Yes it is. We cannot tell exactly whether has it progressed to the
> footer IMO, such as when in case 'con->v1.in_base_pos =3D=3D
>
> Hi Xiubo,
>
> I don't buy this.  If the messenger is trying to read the footer, it
> _has_ progressed to the footer.  This is definitive and irreversible,
> not a "maybe".
>
> sizeof(con->v1.in_hdr)' the socket buffer may break just after finishing
> sparse-read and before reading footer or some where in sparse-read. For
> the later case then we should continue in the sparse reads.
>
> The size of the data section of the message is always known.  The
> contract is that read_partial_msg_data*() returns 1 and does nothing
> else after the data section is consumed.  This is how the messenger is
> told to move on to the footer.
>
> read_partial_sparse_msg_data() doesn't adhere to this contract and
> should be fixed.
>
> Notice how read_partial_msg_data() and read_partial_msg_data_bounce()
> behave: if called at that point (i.e. after the data section has been
> processed, meaning that cursor->total_resid =3D=3D 0), they do nothing.
> read_sparse_msg_data() should have a similar condition and basically
> no-op itself.
>
> Correct, this what I want to do in the sparse-read code.
>
> No, this needs to be done on the messenger side.  sparse-read code
> should not be invoked after the messenger has moved on to the footer.
>
>  From my reading, even the messenger has moved on to the 'footer', it
> will always try to invoke to parse the 'header':
>
> read_partial(con, end, size, &con->v1.in_hdr);
>
> But it will do nothing and just returns.
>
> And the same for 'front', 'middle' and '(page) data', then the last for
> 'footer'.
>
> This is correct.
>
> Did I miss something ?
>
> No, it's how the messenger is set up to work.  The problem is that
> read_sparse_msg_data() doesn't fit this model, so it should be fixed
> and renamed to read_partial_sparse_msg_data().
>
> Okay, let me try.
>
> Did you see my new patch in last mail ? Will that work ?
>
> If not I will try to fix it in read_partial_sparse_msg_data().

It might work around the problem, but it's not the right fix.  Think
about it: what business does code in the OSD client have being called
when the messenger is 14 bytes into reading the footer (number taken
from the log in the cover letter)?  All data is read at that point and
the last op in a multi-op OSD request may not even be sparse-read...

Thanks,

                Ilya

