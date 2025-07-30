Return-Path: <ceph-devel+bounces-3333-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B2D6B1622A
	for <lists+ceph-devel@lfdr.de>; Wed, 30 Jul 2025 16:02:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 00C8F16AFFB
	for <lists+ceph-devel@lfdr.de>; Wed, 30 Jul 2025 14:02:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5FF52D94A9;
	Wed, 30 Jul 2025 14:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NLI+XP51"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA5FE23182B
	for <ceph-devel@vger.kernel.org>; Wed, 30 Jul 2025 14:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753884135; cv=none; b=bGn8qHEuxzUp4u8x3r7ya246ypL3n4SFahOrTXpTuC7ETLtKIUjbkMK9FWJIoBgMQNQZ6Q+R8mrBVrlVYq4bqow/NW0c1MuivSygdWrNn2CXclaAmMqLLYIDd6qVntOTfIPtRhXA54X2RMDFeMqaP6Qg/pnK6c5oB1p4ORxop7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753884135; c=relaxed/simple;
	bh=MmkWlN/uPwvX34CCCyRa4VBF+jL1KnRxT5B9XA2kXK8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mSfeRZwLwB4BU0X6fLokoTysbcNLIYWNfV3W02Vo5MWyXdJ1rzsNXsyQkNSgPHZfC5Fwspz/tn2baUgUQnPd2rYKvAwxLDZ4P3pzdvlgmGWLVa2cCjJDDz94T864ZLJHaiNKbi2tHHvzL9dyJq9XtF7a4/tY+wwPcdjQNOTVJvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NLI+XP51; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753884132;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ackfB6DBPYTuoV1XtuNoLny2V63xhrT1Odsd3+ASSwA=;
	b=NLI+XP51cIfkMVhU89OmOJrA6rqxrPCvrpwH0bar3hfYQqqn9896/9+uuTBorgvVfZseja
	CFLVmUtNIGrv3+WkVXiE2s5/mB/1MtXc/POum4hi9yhkrMuiT5cG7jL8tAtq2v5xS4A2au
	8D2g6ZLzEk0BFFPVYdJqb86A6vUmVRo=
Received: from mail-vk1-f199.google.com (mail-vk1-f199.google.com
 [209.85.221.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-76-f1_KvpFlNf-uyaiXxSLUng-1; Wed, 30 Jul 2025 10:02:11 -0400
X-MC-Unique: f1_KvpFlNf-uyaiXxSLUng-1
X-Mimecast-MFC-AGG-ID: f1_KvpFlNf-uyaiXxSLUng_1753884131
Received: by mail-vk1-f199.google.com with SMTP id 71dfb90a1353d-539111cdf58so2131627e0c.0
        for <ceph-devel@vger.kernel.org>; Wed, 30 Jul 2025 07:02:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753884131; x=1754488931;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ackfB6DBPYTuoV1XtuNoLny2V63xhrT1Odsd3+ASSwA=;
        b=HmCQMtCm9f5oqEITvBXRH/QC6k+VXip2rF/fjAQ5DGqSY5zc5Migp6hcpC7Kx/rWmR
         tWrp6s2+iXaAfxAiP0cDlsyF4HG/0z6Ur+r+tCGfLSqRXFCMjUnc1P9YtEiSE46h6bI/
         1JToVCFoMaseQdc7C4wx1Duv85B0I+go4UGr8XCQ+yDhwwQFkXYKRK2uwWuAWOvz8iND
         1pdgG01CdKZBKMDjA+FIdjL/TYgHFYiCFvWdmUiVu7DCRtGzzOKtZRlq+g9FR8a7LyaD
         vtoqxdzi+s2CvQviHbDy/ggXTmFpj8iD5SDByqWs8gJVwQMFeo7M+a5T3vRdORCGCaHe
         RY/w==
X-Forwarded-Encrypted: i=1; AJvYcCWIAePTTRT1DMm+RW+vRjxD5NNdT70p+JDlpfLed8D8Mlx5BsJjBWS2uylqD5fBXplCfYKd+HTiHnRm@vger.kernel.org
X-Gm-Message-State: AOJu0YyBtOQP7bcAUfLG4Mc1/Yh+muwbezjLMkbxNbgYpN1NL7swrf2P
	GAu+kYH8PenUGAWyGyexe27KxFAAfBEVJi6HbEZb4vSKUfkD84UMFsdTm/MzAltD0gayC/oqa5m
	BmD2xNWkVGvpUHs4UUItucUyDzfqsHFqn46mwQdB0dUVYlr6WGbq3b+MEsbfCCxP4TXE0KVMPx2
	1ysOp+q/Sn0n+wpEgbm010sCg0y3YST6/ExQ48YA==
X-Gm-Gg: ASbGncvXnf0WT0bh2Kf4UlfITk76gFUX6fGYOuKPDNkQcOtny0Q4lXV/W2YA+cyUMzH
	4J7FePlMwytzH9Yprt8xDxetIk5pa1EE5faykzf5x4vQKzneEWy4+lUIcB72rbO3JR6yC5SdsrC
	zDAVI+iHEQMmPEJy3i6OXvYa7NjgdXsV9sESAnrJk=
X-Received: by 2002:a05:6122:134b:b0:531:2afc:463e with SMTP id 71dfb90a1353d-5391ceddb5emr2222585e0c.5.1753884128927;
        Wed, 30 Jul 2025 07:02:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG9UpaCXloiF2L0Silo5dn/s3hztkBPLD/RFiad9HfOmHHxQjje001bqm1t58UA/YewleWPgB++VzGP1inIlZ0=
X-Received: by 2002:a05:6122:134b:b0:531:2afc:463e with SMTP id
 71dfb90a1353d-5391ceddb5emr2222394e0c.5.1753884127764; Wed, 30 Jul 2025
 07:02:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250730094123.30540-1-sunzhao03@kuaishou.com> <CAO8a2SioQ+iUgoC8+NiMkWS6Wj=2YwV7k9LWp5bfx2ZxpWJU+w@mail.gmail.com>
In-Reply-To: <CAO8a2SioQ+iUgoC8+NiMkWS6Wj=2YwV7k9LWp5bfx2ZxpWJU+w@mail.gmail.com>
From: Alex Markuze <amarkuze@redhat.com>
Date: Wed, 30 Jul 2025 18:01:56 +0400
X-Gm-Features: Ac12FXzmTccQXfizTPDEWz3XPMI0l4wu5M0WeJiqaXrq3_ESpkFyuaoYUj772T4
Message-ID: <CAO8a2Si4B3AqgfmD4-ngsSv0W-7fn_-Qm46SR4uQQ2ciUX3q2A@mail.gmail.com>
Subject: Re: [PATCH] ceph: fix deadlock in ceph_readdir_prepopulate
To: Zhao Sun <sunzhao03@kuaishou.com>
Cc: xiubli@redhat.com, idryomov@gmail.com, ceph-devel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I've taken another look, there is a much bigger issue here I'm not
entirely convinced its safe to release and re-acquire the lock:

The original design ensures that all snap context operations, both
reading and writing, happen under the same lock, guaranteeing
consistency. The patch breaks this invariant by creating a window
where snap contexts can change between the inode creation and the
subsequent ceph_fill_inode call.
Bottom line: The patch trades deadlock prevention for potential snap
context inconsistency, which could lead to data corruption or
incorrect file visibility in snapshots.

On Wed, Jul 30, 2025 at 4:45=E2=80=AFPM Alex Markuze <amarkuze@redhat.com> =
wrote:
>
> Hi,
>
> The patch correctly identifies and addresses the deadlock by releasing
> snap_rwsem before the blocking ceph_get_inode call.
>
> My Recommendation:
>
> Use down_read_killable: The current patch uses
> down_read(&mdsc->snap_rwsem) after calling ceph_get_inode.
> This is problematic because down_read is uninterruptible. If a signal
> (like SIGKILL or Ctrl+C) is sent to the process while it's waiting to
> re-acquire the snap_rwsem read lock (e.g., if another thread holds the
> write lock), the process will hang indefinitely and cannot be killed.
> Using down_read_killable(&mdsc->snap_rwsem) instead allows the lock
> acquisition to be interrupted by signals. If it fails (returns
> -EINTR), the error must be handled properly (e.g., release the inode
> reference obtained from ceph_get_inode and propagate the error) to
> ensure the process remains killable and doesn't hang.
>
> This change is essential to prevent potential system hangs.
>
> Best regards,
>
> On Wed, Jul 30, 2025 at 1:49=E2=80=AFPM Zhao Sun <sunzhao03@kuaishou.com>=
 wrote:
> >
> > When ceph_readdir_prepopulate calls ceph_get_inode while holding
> > mdsc->snap_rwsem, a deadlock may occur, blocking all subsequent
> > requests of the current session.
> >
> > Fix by release the mds->snap_rwsem read lock before calling the
> > ceph_get_inode function.
> >
> > Link: https://tracker.ceph.com/issues/72307
> > Signed-off-by: Zhao Sun <sunzhao03@kuaishou.com>
> > ---
> >  fs/ceph/inode.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> >
> > diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> > index 06cd2963e41e..3d7fb045ba76 100644
> > --- a/fs/ceph/inode.c
> > +++ b/fs/ceph/inode.c
> > @@ -1900,6 +1900,7 @@ static int fill_readdir_cache(struct inode *dir, =
struct dentry *dn,
> >  int ceph_readdir_prepopulate(struct ceph_mds_request *req,
> >                              struct ceph_mds_session *session)
> >  {
> > +       struct ceph_mds_client *mdsc =3D session->s_mdsc;
> >         struct dentry *parent =3D req->r_dentry;
> >         struct inode *inode =3D d_inode(parent);
> >         struct ceph_inode_info *ci =3D ceph_inode(inode);
> > @@ -2029,7 +2030,10 @@ int ceph_readdir_prepopulate(struct ceph_mds_req=
uest *req,
> >                 if (d_really_is_positive(dn)) {
> >                         in =3D d_inode(dn);
> >                 } else {
> > +                       /* Release mdsc->snap_rwsem in advance to avoid=
 deadlock */
> > +                       up_read(&mdsc->snap_rwsem);
> >                         in =3D ceph_get_inode(parent->d_sb, tvino, NULL=
);
> > +                       down_read(&mdsc->snap_rwsem);
> >                         if (IS_ERR(in)) {
> >                                 doutc(cl, "new_inode badness\n");
> >                                 d_drop(dn);
> > --
> > 2.39.2 (Apple Git-143)
> >
> >


