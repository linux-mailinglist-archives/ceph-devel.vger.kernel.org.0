Return-Path: <ceph-devel+bounces-58-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 14E257E21CA
	for <lists+ceph-devel@lfdr.de>; Mon,  6 Nov 2023 13:35:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8FB7DB20DFD
	for <lists+ceph-devel@lfdr.de>; Mon,  6 Nov 2023 12:35:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC10B156FF;
	Mon,  6 Nov 2023 12:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IzCPuBV0"
X-Original-To: ceph-devel@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAAC2210E2
	for <ceph-devel@vger.kernel.org>; Mon,  6 Nov 2023 12:35:29 +0000 (UTC)
Received: from mail-oo1-xc35.google.com (mail-oo1-xc35.google.com [IPv6:2607:f8b0:4864:20::c35])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC64E10C8
	for <ceph-devel@vger.kernel.org>; Mon,  6 Nov 2023 04:35:15 -0800 (PST)
Received: by mail-oo1-xc35.google.com with SMTP id 006d021491bc7-5875c300becso2608324eaf.0
        for <ceph-devel@vger.kernel.org>; Mon, 06 Nov 2023 04:35:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699274115; x=1699878915; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EjPJg0Txa0RUGlKyBH4aIxqKX+FwiyRyZJDde8ZHHB0=;
        b=IzCPuBV01oyaDTnGbChtBetSlWToCNfbn3qu1PrzEgsK7EEw7ZzjUdGZDNdeECqzZk
         BDJeTAi7rbwODfKt+b56jemYO/D2tnmOTdflIHnhXAPnm8bYMIk7epVa+UGCy9EecA2k
         9tUY8GywEcszXLhSybIeobaXMRPzr0pZhNe0NxzCmU/4rcP+z5m2cCO4zVP8tmqbUA++
         2ow+HP3cINyzZRnLmEZuq0I4i4daziNpaFLQ1amAER2ymtTbQ7AqIG1bURhzZnQWqFEg
         ojC8nHoXRzkTPGGV238ZTOKyYpgHhyECRLOJ8ZxVQPF3IND33NC9eoo8y1xnAtKYbMJA
         ZoZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699274115; x=1699878915;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EjPJg0Txa0RUGlKyBH4aIxqKX+FwiyRyZJDde8ZHHB0=;
        b=puGg2Q2+v1lAoe5mOqC0pyJDRmdxgh5rMGi3xq0INHzFsPt/cmxYnaKcRjnIo7w+Ai
         +bw9Rz3zyxTmFa9D69NBEglGKlDBaa1K7SsGmfYKkmiNWomTzZ3sva6LxtDGuq8ylPBR
         VGE3ghjVuMYuMPcCyw4HS81ecvfFY1MwA5ByPSpbjyXF4IabAVqIFS0oFpIsgBANoSyH
         s7xr5dGPvX7SM5ApfchgewHs24oJvV4ywPvqhnU3rRqWszYA/GISx9glmI5PAdgeEtrh
         8dLVlOpeGucPoWH2sCsRYUteMIJ6d8mLn0QhUana4MPed9tcqVAmLUo4pMCOwlE51PqH
         9yfw==
X-Gm-Message-State: AOJu0YyJ4vFf+BkqeuB8n2oUMk6pt6IKgNAEDCnBQH4BcCVWYwYBDn1l
	sMx7/Rh74w8+kpP93GvaLtjoeR6SNc9fCytZ/+RL0Yx73mQ=
X-Google-Smtp-Source: AGHT+IH/fJ6s73euX/t8aBT+3Rhff1v4jKqnUv1zwhCAB6nZOlwzv+Ci50xDiOgbMsTP7RUyPELSCyu+COMbHYDgRv0=
X-Received: by 2002:a05:6820:200e:b0:57b:469d:8af6 with SMTP id
 by14-20020a056820200e00b0057b469d8af6mr31363793oob.4.1699274114958; Mon, 06
 Nov 2023 04:35:14 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231106010300.247597-1-xiubli@redhat.com> <CAOi1vP-knSTdi5OxG=Yv5cGVJOQ7f5qhS41rhcRj-NQXhqnrtQ@mail.gmail.com>
 <b23e8296-ca61-6be5-e07f-f0e184ac3c55@redhat.com>
In-Reply-To: <b23e8296-ca61-6be5-e07f-f0e184ac3c55@redhat.com>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Mon, 6 Nov 2023 13:35:03 +0100
Message-ID: <CAOi1vP8cD4K7-sjofz+5D4L4GXAgrGD4Z1Ftpk+qtyq8-W-shg@mail.gmail.com>
Subject: Re: [PATCH v2] libceph: increase the max extents check for sparse read
To: Xiubo Li <xiubli@redhat.com>
Cc: ceph-devel@vger.kernel.org, jlayton@kernel.org, vshankar@redhat.com, 
	mchangir@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 6, 2023 at 1:20=E2=80=AFPM Xiubo Li <xiubli@redhat.com> wrote:
>
>
> On 11/6/23 19:46, Ilya Dryomov wrote:
> > On Mon, Nov 6, 2023 at 2:05=E2=80=AFAM <xiubli@redhat.com> wrote:
> >> From: Xiubo Li <xiubli@redhat.com>
> >>
> >> There is no any limit for the extent array size and it's possible
> >> that we will hit 4096 limit just after a lot of random writes to
> >> a file and then read with a large size. In this case the messager
> >> will fail by reseting the connection and keeps resending the inflight
> >> IOs infinitely.
> >>
> >> Just increase the limit to a larger number and then warn it to
> >> let user know that allocating memory could fail with this.
> >>
> >> URL: https://tracker.ceph.com/issues/62081
> >> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> >> ---
> >>
> >> V2:
> >> - Increase the MAX_EXTENTS instead of removing it.
> >> - Do not return an errno when hit the limit.
> >>
> >>
> >>   net/ceph/osd_client.c | 15 +++++++--------
> >>   1 file changed, 7 insertions(+), 8 deletions(-)
> >>
> >> diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
> >> index c03d48bd3aff..050dc39065fb 100644
> >> --- a/net/ceph/osd_client.c
> >> +++ b/net/ceph/osd_client.c
> >> @@ -5850,7 +5850,7 @@ static inline void convert_extent_map(struct cep=
h_sparse_read *sr)
> >>   }
> >>   #endif
> >>
> >> -#define MAX_EXTENTS 4096
> >> +#define MAX_EXTENTS (16*1024*1024)
> > I don't think this is a sensible limit -- see my other reply.
>
> Ilya,
>
> As I mentioned in that thread, the sparse read could be enabled in
> non-fscrypt case. If so the "64M (CEPH_MSG_MAX_DATA_LEN) / 4K =3D 16384"
> still won't be enough.

I have just replied in the other thread.  Let's continue this
discussion there ;)

Thanks,

                Ilya

