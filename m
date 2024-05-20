Return-Path: <ceph-devel+bounces-1152-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F6AE8CA2DB
	for <lists+ceph-devel@lfdr.de>; Mon, 20 May 2024 21:48:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CF7F7281706
	for <lists+ceph-devel@lfdr.de>; Mon, 20 May 2024 19:48:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5F061D554;
	Mon, 20 May 2024 19:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HsBMTqxJ"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD1D318EBF
	for <ceph-devel@vger.kernel.org>; Mon, 20 May 2024 19:48:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716234527; cv=none; b=Eilnk8IGRIKPOT3a+Jy6XmU4xIUirOabRYxi+xhCED6Su/ClY6v+eVh2SWCxy8sIw1Z0Ipkiigdg3cisAxA7tnyi41Pt8KEkrePdxvwWZ7zhNnsuQSBsHr93Loztt4SCs+jjmmHqa9Kd2qMJBewgtSQdb0/+m0xQK84uTiSzIXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716234527; c=relaxed/simple;
	bh=wOh7qU7VhpZ2RQtzgWmyprkdHXACyOO8EQc4xmk8y+g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cy3FpwXOqAVVEsfeAyffILObq6Y82BS6d4edZ8kBtaA+bqGyJwFTCLtRVYU+FtxuDorL1l4PNIbgALsbeskSVpyJX3XYuVLnmcF85QMO8CQZFcrfJ5el2Rao5oFVNoOyf5XoQMf9L3LO3jlRwUQUN09aKu6s7Ngewdod9uocePA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HsBMTqxJ; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-350513d2c6aso2244148f8f.2
        for <ceph-devel@vger.kernel.org>; Mon, 20 May 2024 12:48:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716234524; x=1716839324; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zD6hmBMc+p55WtncPBuxs1EOCKG6h2Y9zxSM/TxDUg8=;
        b=HsBMTqxJJFmYWR2Mr9aMbD7CMHMJv997H8FfXDLF5lS2gBLpVt5ZwN3yQziK6lGZ1h
         iDNyaKLkQ0F4cMOAsLNi3CxmKwGXAdM29fVZFyhWwt/ks/3F7FG5oynXGsbpFsGGtJXV
         GX/ljEAQXvwVOcHpbt5RplbnoIl6rS2PZhb2ob4XD2KOGp+6vTxQC3dLfX+H85gNXV3F
         2jlTqSK/dbVB0G7Q9lI4rkBCYmujwaEMGEgS8H2xuQ3v5j6mQxahKLRr4puDRx+CZtI2
         PxPe7+uUbrt2RBXh02gUSkpvQ73mj7uLnCMbAwDXIZxQhK/jyIEdPFEn+wW/+JGF+byK
         0Ofw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716234524; x=1716839324;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zD6hmBMc+p55WtncPBuxs1EOCKG6h2Y9zxSM/TxDUg8=;
        b=DCm3KeH65Uy21HgT78n41/BF3vlkDQLYoTt2w0pvLms6MH4BNlOta7Kcu1KVhzgJTP
         QWaLq7QgoyhYE9mlqG88R+O0WAkhbyAXfVyU+yhG9byWw1SgSDmsFBeXHnoyqGNwe5pM
         3Bqj2EP1Zapp2/ZQieAo2MoIsJdVppojfj0aKfb2ortTuNQQ2FhdeRKEU9jMLsFnh9E9
         nrhtkF11vUAjML3L3sYrHd3Lf0c3dGyHWkIXMfSKk49ZtbOZonA5WQZzpie7QWwJa41i
         IW/ByNkr6d/V9PIw1tHonssxsQLwl2nHwDrYTBXfuqHzguMAhnktlbiU8T8Fr8M9glU3
         b2Yw==
X-Gm-Message-State: AOJu0YzsNQoGz1PfXpd7jZ2VDWyEpkdH0Ed0Z4HRQUaslhaX3CXxCWaI
	dx+YhEKHR153C/0cR1ik0/XrDBxlLhXkQCbptfm2ak7VGoJ65zHBEDFHJJcNeXUap68DD6gvgWM
	KaBD3z6XinOt2s2qXdoWHp9uLw1tfTUWFSXU=
X-Google-Smtp-Source: AGHT+IFTpJViDLUMI/9KvuhOfMuyw/YneTL6ZCHIRW+Plfr5ZwDI45sigMNiriP+t/hJtQwgU/mYVM2IQylhHMKeiFI=
X-Received: by 2002:a05:600c:310d:b0:41b:f979:e359 with SMTP id
 5b1f17b1804b1-41fead6dc04mr275455735e9.38.1716234523566; Mon, 20 May 2024
 12:48:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240321021536.64693-1-xiubli@redhat.com> <CAOi1vP-RdbfmBAku9j104osphc3tk4zgbG-=eQ5yTz1a9s4e=g@mail.gmail.com>
In-Reply-To: <CAOi1vP-RdbfmBAku9j104osphc3tk4zgbG-=eQ5yTz1a9s4e=g@mail.gmail.com>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Mon, 20 May 2024 21:48:29 +0200
Message-ID: <CAOi1vP8D5=cgumccKuywsLoZTCWeh8j1QbnkVS7RkvrEb3C4tw@mail.gmail.com>
Subject: Re: [PATCH] ceph: make the ceph-cap workqueue UNBOUND
To: xiubli@redhat.com
Cc: ceph-devel@vger.kernel.org, jlayton@kernel.org, vshankar@redhat.com, 
	mchangir@redhat.com, Stefan Kooman <stefan@bit.nl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, May 20, 2024 at 9:37=E2=80=AFPM Ilya Dryomov <idryomov@gmail.com> w=
rote:
>
> On Thu, Mar 21, 2024 at 3:18=E2=80=AFAM <xiubli@redhat.com> wrote:
> >
> > From: Xiubo Li <xiubli@redhat.com>
> >
> > There is not harm to mark the ceph-cap workqueue unbounded, just
> > like we do in ceph-inode workqueue.
> >
> > URL: https://www.spinics.net/lists/ceph-users/msg78775.html
> > URL: https://tracker.ceph.com/issues/64977
> > Reported-by: Stefan Kooman <stefan@bit.nl>
> > Signed-off-by: Xiubo Li <xiubli@redhat.com>
> > ---
> >  fs/ceph/super.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> > index 4dcbbaa297f6..0bfe4f8418fd 100644
> > --- a/fs/ceph/super.c
> > +++ b/fs/ceph/super.c
> > @@ -851,7 +851,7 @@ static struct ceph_fs_client *create_fs_client(stru=
ct ceph_mount_options *fsopt,
> >         fsc->inode_wq =3D alloc_workqueue("ceph-inode", WQ_UNBOUND, 0);
> >         if (!fsc->inode_wq)
> >                 goto fail_client;
> > -       fsc->cap_wq =3D alloc_workqueue("ceph-cap", 0, 1);
> > +       fsc->cap_wq =3D alloc_workqueue("ceph-cap", WQ_UNBOUND, 1);
>
> Hi Xiubo,
>
> You wrote that there is no harm in making ceph-cap workqueue unbound,
> but, if it's made unbound, it would be almost the same as ceph-inode
> workqueue.  The only difference would be that max_active parameter for
> ceph-cap workqueue is 1 instead of 0 (i.e. some default which is pretty
> high).  Given that max_active is interpreted as a per-CPU number even
> for unbound workqueues, up to $NUM_CPUS work items submitted to
> ceph-cap workqueue could still be active in a system.
>
> Does CephFS need/rely on $NUM_CPUS limit sowewhere?  If not, how about
> removing ceph-cap workqueue and submitting its work items to ceph-inode
> workqueue instead?

Related question: why ceph_force_reconnect() flushes only one of these
workqueues (ceph-inode) instead of both?  When invalidating everything,
aren't we concerned with potential stale work items from before the
session is recovered?

Thanks,

                Ilya

