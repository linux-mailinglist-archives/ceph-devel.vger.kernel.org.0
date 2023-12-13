Return-Path: <ceph-devel+bounces-279-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C0EC810E7A
	for <lists+ceph-devel@lfdr.de>; Wed, 13 Dec 2023 11:32:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 563B41C2098E
	for <lists+ceph-devel@lfdr.de>; Wed, 13 Dec 2023 10:32:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB907224FE;
	Wed, 13 Dec 2023 10:32:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bXF80kuv"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-oo1-xc2a.google.com (mail-oo1-xc2a.google.com [IPv6:2607:f8b0:4864:20::c2a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BB4CAD
	for <ceph-devel@vger.kernel.org>; Wed, 13 Dec 2023 02:32:03 -0800 (PST)
Received: by mail-oo1-xc2a.google.com with SMTP id 006d021491bc7-5906e03a7a4so3814249eaf.1
        for <ceph-devel@vger.kernel.org>; Wed, 13 Dec 2023 02:32:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702463523; x=1703068323; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5yWU2XCqUySF+Acrhe1ODu57TWcdaAIi+LAWy67biIs=;
        b=bXF80kuv4rma4qjUlOfxQYCmpYRqKrc/pJ7TWfosFDhmqWcmYRsQM4xaaY2tsm74TK
         NMIsbj9uEd7A1TUCYN9J4niodlHm8R3zB/zJ+RWqqQ7t9M4Poe+W/jlcKrBgiOelL6oy
         q5R0eUeCbpaXBsDf2bdKM+Q645IL0VuVn96X9Zuq5l1/SvYbzx89Ww/yujJMAa6Dwc7A
         XkaRnn12VGegNDxX8BqhYF9yuI2Z5O1HgG8j3+yU0JMK0MOygoPGvS5lSx77Pl4xTOZI
         lUSe96nS2X9yHLfLJhcH83rWrS+L/SLjbAL/18C++OaHSnSmJ2y0+78YC17q/NpPGYwX
         HDRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702463523; x=1703068323;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5yWU2XCqUySF+Acrhe1ODu57TWcdaAIi+LAWy67biIs=;
        b=R/lXkQS0iytJcSgribC2UbQxKheW1Iwa0iGJTSsZyY05O6n5pTm+CPZsGOh/8Gsh9Y
         7Ti68bnwEqB4kCsho2OnqAe2hVeE+FvrZfqwM8i8MTZlR3B9BhfNSrRJcGtVVrooVCNn
         fGyqwArGpR+g1+vidp+0mEnVpz/mRrUJOG/peVwAR9697rNGSAIhWX6E/he4yCtO/6Rc
         pTT/tH/rGuTYl3eOJNv4wdwm5hXsdv1JpwBhgPa8rIi8i3FEQwI6zOYE0CcujbtrRq3u
         7emG8H++FWk4iMD8ly5uUgvKs9/i8s/V/da1rAgXTDR0PbzoCNdt/PYMLaApty+pjhjZ
         UZpw==
X-Gm-Message-State: AOJu0YyJiCiVkalIILnlg+/vByX1gnGYCKwuvvXd+3dTJcDtpLXSOGmm
	Ti7MaCAG0/lT0d52V1Q9BXNT16W2b+VSnR3a5uU14BYqb1I=
X-Google-Smtp-Source: AGHT+IEcKbq3hySW6fv5W7UPLJlyBB+q48t1isP8uedDGbnAKqAtDQMo8AUqDvxW2X01CLkOI2wHntDaNj/OrrBfLbw=
X-Received: by 2002:a4a:dfcf:0:b0:590:97ed:9d5c with SMTP id
 p15-20020a4adfcf000000b0059097ed9d5cmr5106082ood.14.1702463522692; Wed, 13
 Dec 2023 02:32:02 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231208160601.124892-1-xiubli@redhat.com> <20231208160601.124892-3-xiubli@redhat.com>
 <CAOi1vP8ft0nFh2qdQDRpGr7gPCj3HHDzY4Q7i69WQLiASPxNyw@mail.gmail.com> <af3d24bc-0a4f-4e30-ba3d-80d41a7fd94c@redhat.com>
In-Reply-To: <af3d24bc-0a4f-4e30-ba3d-80d41a7fd94c@redhat.com>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Wed, 13 Dec 2023 11:31:50 +0100
Message-ID: <CAOi1vP9EzGZM=U1jDzAnTwFvWD6fpZ+qMedgOQuK79qOodU+NQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] libceph: just wait for more data to be available
 on the socket
To: Xiubo Li <xiubli@redhat.com>
Cc: ceph-devel@vger.kernel.org, jlayton@kernel.org, vshankar@redhat.com, 
	mchangir@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 13, 2023 at 2:02=E2=80=AFAM Xiubo Li <xiubli@redhat.com> wrote:
>
>
> On 12/13/23 00:31, Ilya Dryomov wrote:
> > On Fri, Dec 8, 2023 at 5:08=E2=80=AFPM <xiubli@redhat.com> wrote:
> >> From: Xiubo Li <xiubli@redhat.com>
> >>
> >> The messages from ceph maybe split into multiple socket packages
> >> and we just need to wait for all the data to be availiable on the
> >> sokcet.
> >>
> >> This will add a new _FINISH state for the sparse-read to mark the
> >> current sparse-read succeeded. Else it will treat it as a new
> >> sparse-read when the socket receives the last piece of the osd
> >> request reply message, and the cancel_request() later will help
> >> init the sparse-read context.
> >>
> >> URL: https://tracker.ceph.com/issues/63586
> >> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> >> ---
> >>   include/linux/ceph/osd_client.h | 1 +
> >>   net/ceph/osd_client.c           | 6 +++---
> >>   2 files changed, 4 insertions(+), 3 deletions(-)
> >>
> >> diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/osd_=
client.h
> >> index 493de3496cd3..00d98e13100f 100644
> >> --- a/include/linux/ceph/osd_client.h
> >> +++ b/include/linux/ceph/osd_client.h
> >> @@ -47,6 +47,7 @@ enum ceph_sparse_read_state {
> >>          CEPH_SPARSE_READ_DATA_LEN,
> >>          CEPH_SPARSE_READ_DATA_PRE,
> >>          CEPH_SPARSE_READ_DATA,
> >> +       CEPH_SPARSE_READ_FINISH,
> >>   };
> >>
> >>   /*
> >> diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
> >> index 848ef19055a0..f1705b4f19eb 100644
> >> --- a/net/ceph/osd_client.c
> >> +++ b/net/ceph/osd_client.c
> >> @@ -5802,8 +5802,6 @@ static int prep_next_sparse_read(struct ceph_con=
nection *con,
> >>                          advance_cursor(cursor, sr->sr_req_len - end, =
false);
> >>          }
> >>
> >> -       ceph_init_sparse_read(sr);
> >> -
> >>          /* find next op in this request (if any) */
> >>          while (++o->o_sparse_op_idx < req->r_num_ops) {
> >>                  op =3D &req->r_ops[o->o_sparse_op_idx];
> >> @@ -5919,7 +5917,7 @@ static int osd_sparse_read(struct ceph_connectio=
n *con,
> >>                                  return -EREMOTEIO;
> >>                          }
> >>
> >> -                       sr->sr_state =3D CEPH_SPARSE_READ_HDR;
> >> +                       sr->sr_state =3D CEPH_SPARSE_READ_FINISH;
> >>                          goto next_op;
> > Hi Xiubo,
> >
> > This code appears to be set up to handle multiple (sparse-read) ops in
> > a single OSD request.  Wouldn't this break that case?
>
> Yeah, it will break it. I just missed it.
>
> > I think the bug is in read_sparse_msg_data().  It shouldn't be calling
> > con->ops->sparse_read() after the message has progressed to the footer.
> > osd_sparse_read() is most likely fine as is.
>
> Yes it is. We cannot tell exactly whether has it progressed to the
> footer IMO, such as when in case 'con->v1.in_base_pos =3D=3D

Hi Xiubo,

I don't buy this.  If the messenger is trying to read the footer, it
_has_ progressed to the footer.  This is definitive and irreversible,
not a "maybe".

> sizeof(con->v1.in_hdr)' the socket buffer may break just after finishing
> sparse-read and before reading footer or some where in sparse-read. For
> the later case then we should continue in the sparse reads.

The size of the data section of the message is always known.  The
contract is that read_partial_msg_data*() returns 1 and does nothing
else after the data section is consumed.  This is how the messenger is
told to move on to the footer.

read_partial_sparse_msg_data() doesn't adhere to this contract and
should be fixed.

>
>
> > Notice how read_partial_msg_data() and read_partial_msg_data_bounce()
> > behave: if called at that point (i.e. after the data section has been
> > processed, meaning that cursor->total_resid =3D=3D 0), they do nothing.
> > read_sparse_msg_data() should have a similar condition and basically
> > no-op itself.
>
> Correct, this what I want to do in the sparse-read code.

No, this needs to be done on the messenger side.  sparse-read code
should not be invoked after the messenger has moved on to the footer.

Thanks,

                Ilya

