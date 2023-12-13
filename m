Return-Path: <ceph-devel+bounces-281-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 79357811097
	for <lists+ceph-devel@lfdr.de>; Wed, 13 Dec 2023 12:55:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AC83F1C20B19
	for <lists+ceph-devel@lfdr.de>; Wed, 13 Dec 2023 11:55:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B147E28DB3;
	Wed, 13 Dec 2023 11:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="b+oqP1iv"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-oo1-xc2c.google.com (mail-oo1-xc2c.google.com [IPv6:2607:f8b0:4864:20::c2c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91C5CEA
	for <ceph-devel@vger.kernel.org>; Wed, 13 Dec 2023 03:55:02 -0800 (PST)
Received: by mail-oo1-xc2c.google.com with SMTP id 006d021491bc7-59082c4aadaso3485625eaf.0
        for <ceph-devel@vger.kernel.org>; Wed, 13 Dec 2023 03:55:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702468502; x=1703073302; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u5WXzR7LLLdxjntEC9TYFXuoFZOwiYq/9qChFJQrGzQ=;
        b=b+oqP1ivOuqjrm6/TkWwcUURmJDDm8mkPGogPrE8Y1YiCPNhvwok6S6WhxGzTM40d6
         gbHLdG8hTItLZ1uZxKJtp8gT7pImPiL6dUTtvB75ekis/25if5UoxR2VnU475xd9KFfG
         Bg7GYoBZLAkvd96n1gjTQFT2DSM/F3dPLnNTSdx766wEa7mauL+c9LDrOHgVuqRK2Gjt
         msfD5ZZwfwIyivCSbpbdCAYGiOst2IVeiVH0261y9JUmtPrEOtnk4e1xtkMpkM6FqsEu
         rsN2kyw4ivloX7N/pAg3ufpNDmG7TZI9RxguvWMiBX5XrzENgb5CHog1e17LgEntb5Cw
         BVLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702468502; x=1703073302;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=u5WXzR7LLLdxjntEC9TYFXuoFZOwiYq/9qChFJQrGzQ=;
        b=DE4awTEagaJ20eeFCaJl75YWxWtCLOpqRII7dnrQzSKSMST8rqvXAuVCbfb4f6hHT8
         aOW8DRQnpbDMK6JLZ4vdx+G5Uj04zSN2v17bNpYD8LvIAR0n61ewmxWkGvKoCKNx9AZl
         ovtWrV1/dHqxOlYjKtkljbLWHMzSEd3cT1DLSHfm1gnFQP7NWzKlSNrSTgsyGT8wpE17
         5i1wJ/TYQ8M5bzHF7LbNbSmB8r9WUnHlrwCWilnAO7QixtoV2XyWY6DYZiO23agE+qpo
         OVx8T1lJnYcho5241U7jqqMd3DPf2s5jv/tZlZyOWf1CQBGbjK23VVi08L6LBRAUqStI
         hC2Q==
X-Gm-Message-State: AOJu0YzT7cPn2eHm4dY4bPtuTka0uH+syZTT8v4CZyZTBnygsSKi/Qmd
	TW95+xrSzZf/NyOPpg755CyN00I6OAgvv4HYXeIVwQR+MKA=
X-Google-Smtp-Source: AGHT+IHo8abN/E44vaOktsGe86flZFnzR5SCWbsT7HdE/jk4aJaQT0wuQs3ypJSlyoX0VOxAVDXUsEdmRZOkaSWP/rE=
X-Received: by 2002:a4a:620d:0:b0:590:6c9b:1190 with SMTP id
 x13-20020a4a620d000000b005906c9b1190mr4763952ooc.18.1702468501801; Wed, 13
 Dec 2023 03:55:01 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231208160601.124892-1-xiubli@redhat.com> <20231208160601.124892-3-xiubli@redhat.com>
 <CAOi1vP8ft0nFh2qdQDRpGr7gPCj3HHDzY4Q7i69WQLiASPxNyw@mail.gmail.com>
 <af3d24bc-0a4f-4e30-ba3d-80d41a7fd94c@redhat.com> <CAOi1vP9EzGZM=U1jDzAnTwFvWD6fpZ+qMedgOQuK79qOodU+NQ@mail.gmail.com>
 <008fe687-9df0-45d2-929c-168a10222b2f@redhat.com>
In-Reply-To: <008fe687-9df0-45d2-929c-168a10222b2f@redhat.com>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Wed, 13 Dec 2023 12:54:49 +0100
Message-ID: <CAOi1vP9yYkv+cxazfwbrKD0g2LcS9Pa0PLF33kAf4uKvDXgoLQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] libceph: just wait for more data to be available
 on the socket
To: Xiubo Li <xiubli@redhat.com>
Cc: ceph-devel@vger.kernel.org, jlayton@kernel.org, vshankar@redhat.com, 
	mchangir@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 13, 2023 at 12:03=E2=80=AFPM Xiubo Li <xiubli@redhat.com> wrote=
:
>
>
> On 12/13/23 18:31, Ilya Dryomov wrote:
> > On Wed, Dec 13, 2023 at 2:02=E2=80=AFAM Xiubo Li <xiubli@redhat.com> wr=
ote:
> >>
> >> On 12/13/23 00:31, Ilya Dryomov wrote:
> >>> On Fri, Dec 8, 2023 at 5:08=E2=80=AFPM <xiubli@redhat.com> wrote:
> >>>> From: Xiubo Li <xiubli@redhat.com>
> >>>>
> >>>> The messages from ceph maybe split into multiple socket packages
> >>>> and we just need to wait for all the data to be availiable on the
> >>>> sokcet.
> >>>>
> >>>> This will add a new _FINISH state for the sparse-read to mark the
> >>>> current sparse-read succeeded. Else it will treat it as a new
> >>>> sparse-read when the socket receives the last piece of the osd
> >>>> request reply message, and the cancel_request() later will help
> >>>> init the sparse-read context.
> >>>>
> >>>> URL: https://tracker.ceph.com/issues/63586
> >>>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> >>>> ---
> >>>>    include/linux/ceph/osd_client.h | 1 +
> >>>>    net/ceph/osd_client.c           | 6 +++---
> >>>>    2 files changed, 4 insertions(+), 3 deletions(-)
> >>>>
> >>>> diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/os=
d_client.h
> >>>> index 493de3496cd3..00d98e13100f 100644
> >>>> --- a/include/linux/ceph/osd_client.h
> >>>> +++ b/include/linux/ceph/osd_client.h
> >>>> @@ -47,6 +47,7 @@ enum ceph_sparse_read_state {
> >>>>           CEPH_SPARSE_READ_DATA_LEN,
> >>>>           CEPH_SPARSE_READ_DATA_PRE,
> >>>>           CEPH_SPARSE_READ_DATA,
> >>>> +       CEPH_SPARSE_READ_FINISH,
> >>>>    };
> >>>>
> >>>>    /*
> >>>> diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
> >>>> index 848ef19055a0..f1705b4f19eb 100644
> >>>> --- a/net/ceph/osd_client.c
> >>>> +++ b/net/ceph/osd_client.c
> >>>> @@ -5802,8 +5802,6 @@ static int prep_next_sparse_read(struct ceph_c=
onnection *con,
> >>>>                           advance_cursor(cursor, sr->sr_req_len - en=
d, false);
> >>>>           }
> >>>>
> >>>> -       ceph_init_sparse_read(sr);
> >>>> -
> >>>>           /* find next op in this request (if any) */
> >>>>           while (++o->o_sparse_op_idx < req->r_num_ops) {
> >>>>                   op =3D &req->r_ops[o->o_sparse_op_idx];
> >>>> @@ -5919,7 +5917,7 @@ static int osd_sparse_read(struct ceph_connect=
ion *con,
> >>>>                                   return -EREMOTEIO;
> >>>>                           }
> >>>>
> >>>> -                       sr->sr_state =3D CEPH_SPARSE_READ_HDR;
> >>>> +                       sr->sr_state =3D CEPH_SPARSE_READ_FINISH;
> >>>>                           goto next_op;
> >>> Hi Xiubo,
> >>>
> >>> This code appears to be set up to handle multiple (sparse-read) ops i=
n
> >>> a single OSD request.  Wouldn't this break that case?
> >> Yeah, it will break it. I just missed it.
> >>
> >>> I think the bug is in read_sparse_msg_data().  It shouldn't be callin=
g
> >>> con->ops->sparse_read() after the message has progressed to the foote=
r.
> >>> osd_sparse_read() is most likely fine as is.
> >> Yes it is. We cannot tell exactly whether has it progressed to the
> >> footer IMO, such as when in case 'con->v1.in_base_pos =3D=3D
> > Hi Xiubo,
> >
> > I don't buy this.  If the messenger is trying to read the footer, it
> > _has_ progressed to the footer.  This is definitive and irreversible,
> > not a "maybe".
> >
> >> sizeof(con->v1.in_hdr)' the socket buffer may break just after finishi=
ng
> >> sparse-read and before reading footer or some where in sparse-read. Fo=
r
> >> the later case then we should continue in the sparse reads.
> > The size of the data section of the message is always known.  The
> > contract is that read_partial_msg_data*() returns 1 and does nothing
> > else after the data section is consumed.  This is how the messenger is
> > told to move on to the footer.
> >
> > read_partial_sparse_msg_data() doesn't adhere to this contract and
> > should be fixed.
> >
> >>
> >>> Notice how read_partial_msg_data() and read_partial_msg_data_bounce()
> >>> behave: if called at that point (i.e. after the data section has been
> >>> processed, meaning that cursor->total_resid =3D=3D 0), they do nothin=
g.
> >>> read_sparse_msg_data() should have a similar condition and basically
> >>> no-op itself.
> >> Correct, this what I want to do in the sparse-read code.
> > No, this needs to be done on the messenger side.  sparse-read code
> > should not be invoked after the messenger has moved on to the footer.
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

This is correct.

>
> Did I miss something ?

No, it's how the messenger is set up to work.  The problem is that
read_sparse_msg_data() doesn't fit this model, so it should be fixed
and renamed to read_partial_sparse_msg_data().

Thanks,

                Ilya

