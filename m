Return-Path: <ceph-devel+bounces-1071-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0EF428A1DA1
	for <lists+ceph-devel@lfdr.de>; Thu, 11 Apr 2024 20:15:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B5CD4289D7D
	for <lists+ceph-devel@lfdr.de>; Thu, 11 Apr 2024 18:15:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 616FC1EE285;
	Thu, 11 Apr 2024 17:20:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W/hC85zL"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-oa1-f46.google.com (mail-oa1-f46.google.com [209.85.160.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 274D51EE28F
	for <ceph-devel@vger.kernel.org>; Thu, 11 Apr 2024 17:20:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712856018; cv=none; b=h33hRaaP1r7RpWAXi9F4bMmDbgREG6fTg9p44ygg4P0EyCvESPx92UaNNgp2LRibBcv7TR5ppannAKlpY8vioQUyQ0IsEAOlyUUHdbl4bzSDUOWjKRy+6pbvstqSisOcdBYgVdJPPVeCCaldLGhq9i3h+P4RTeh6nX/G7pmmpCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712856018; c=relaxed/simple;
	bh=iF2rHWPjvJ6EKggdoOTc8+Uk2cO8cQy3exFzNZhkUUY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mwtiOfk/+mPCO5Cmu0P2IkM+J7nAMw6kDzkWnm5MM5kcBbi3J+G2wWXn5UAVf6egWizc9sFLNNmATjh/b12r2htDlpOGj9O3tfp9ywdK5e3tKTnFTZ0mL784+sq8kvP9K5u3ZztzBv3paQyvT0HwPHsU9Oc0MyR01y8hzHaODJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=W/hC85zL; arc=none smtp.client-ip=209.85.160.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oa1-f46.google.com with SMTP id 586e51a60fabf-22efc6b8dc5so82438fac.0
        for <ceph-devel@vger.kernel.org>; Thu, 11 Apr 2024 10:20:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712856015; x=1713460815; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4R3cE0WWuvQw8P2xO92A3FlqnR+3vHMPpz/++uUthkE=;
        b=W/hC85zLzwNV5pv+eGcVOdtNk7S6jIPZRu9xszIdnHbw+Aq6zvYNNjcKkv/joZsecT
         cOEu6yOZ0jjmsp+TkorNhP4EaHbrxA8E5YkMQhqfqrR+gs+I/piC4qvoqbtW41RVax7K
         8YCoJPR6j0z76w1vlj7zOda/cd4j6W7mURwrm7bDsD+sfM1NcqMUPrCHbWjffFA9c5U9
         JyUsQu8DZONgYM0j+Iv3vrZBRNpXNETi7TAjo94M+yddDXOpTcWHUfuiNRkPhQ4Nz7VH
         X+a0vUxu7K/R75WUcukl/zAxzb2e47Bw8Si0kSyj8jJK2GJkoUJRuglrrSACGSbz6qVn
         ILXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712856015; x=1713460815;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4R3cE0WWuvQw8P2xO92A3FlqnR+3vHMPpz/++uUthkE=;
        b=RczmjJz65+wdNT0NapxDh2Ax5mvj8Rt/pnnrK/meuSqFeDb5qz73+xHQ7sWRWfIz2J
         rYsOxNs7WBSgNeuI7UOZkcxo4e9UiEQE2T7z20BKPQt9quI593CTGvaoRAndYwvS24CP
         03mk6XBNHznQ62FRoHN7ldc8JINe71dbWl1LX42Q3m3mXL+3hDOnHaJzTb5WETbQ2lEE
         mSt63eqosTVoKFLzWQ6460vdEQOhzMtL/nDikrYkppFtrcKVRKCDVggHxsHHQgP9+1S7
         LtmeW+3nI7/hDKpysyg+Mbmc0p5HhsN/Zo5CJ/6X7U54FAqQgoyr0vYy6EdBIr0NKGdV
         4LEA==
X-Gm-Message-State: AOJu0YyY8s0Nop9+DHFfj80GCSTe43fjDiWnXzSzK0SpgMR6ARRgZSyT
	oKKPRZxBb73VZSzz/YDxNUD87sWeyf8UM1FReKdwkVDmCRVzlesfsPnRiZxmbHuvV69pCIuTA0L
	zIXq7oFo9scptqYh02CH3FoxF6fg=
X-Google-Smtp-Source: AGHT+IFpl7melUBBOZZqOLkAFXLGrp5OO3QMKJ6+ZfpTuCOpQLfR8mcFbh16BrD/T48L4gG3QaiKUIUHCYA2tQW8+QY=
X-Received: by 2002:a05:6870:a907:b0:22a:4da3:b004 with SMTP id
 eq7-20020a056870a90700b0022a4da3b004mr188439oab.2.1712856015300; Thu, 11 Apr
 2024 10:20:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240409064943.1377026-1-xiubli@redhat.com>
In-Reply-To: <20240409064943.1377026-1-xiubli@redhat.com>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Thu, 11 Apr 2024 19:20:03 +0200
Message-ID: <CAOi1vP_+xrZ7TwgQeZL1XLt=di5HdRGxit+8kpMbYDCSpHEjdQ@mail.gmail.com>
Subject: Re: [PATCH] ceph: switch to use cap_delay_lock for the unlink delay list
To: xiubli@redhat.com
Cc: ceph-devel@vger.kernel.org, vshankar@redhat.com, mchangir@redhat.com, 
	Marc Ruhmann <ruhmann@luis.uni-hannover.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 9, 2024 at 8:52=E2=80=AFAM <xiubli@redhat.com> wrote:
>
> From: Xiubo Li <xiubli@redhat.com>
>
> The same list item will be used in both cap_delay_list and
> cap_unlink_delay_list, so it's buggy to use two different locks
> to protect them.
>
> Reported-by: Marc Ruhmann <ruhmann@luis.uni-hannover.de>
> Fixes: dbc347ef7f0c ("ceph: add ceph_cap_unlink_work to fire check_caps()=
 immediately")
> URL: https://lists.ceph.io/hyperkitty/list/ceph-users@ceph.io/thread/AODC=
76VXRAMXKLFDCTK4TKFDDPWUSCN5
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/caps.c       | 4 ++--
>  fs/ceph/mds_client.c | 9 ++++-----
>  fs/ceph/mds_client.h | 3 +--
>  3 files changed, 7 insertions(+), 9 deletions(-)
>
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index bfa8f72cd3cf..197cb383f829 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -4799,13 +4799,13 @@ int ceph_drop_caps_for_unlink(struct inode *inode=
)
>
>                         doutc(mdsc->fsc->client, "%p %llx.%llx\n", inode,
>                               ceph_vinop(inode));
> -                       spin_lock(&mdsc->cap_unlink_delay_lock);
> +                       spin_lock(&mdsc->cap_delay_lock);
>                         ci->i_ceph_flags |=3D CEPH_I_FLUSH;
>                         if (!list_empty(&ci->i_cap_delay_list))
>                                 list_del_init(&ci->i_cap_delay_list);
>                         list_add_tail(&ci->i_cap_delay_list,
>                                       &mdsc->cap_unlink_delay_list);
> -                       spin_unlock(&mdsc->cap_unlink_delay_lock);
> +                       spin_unlock(&mdsc->cap_delay_lock);
>
>                         /*
>                          * Fire the work immediately, because the MDS may=
be
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 639bde44ab23..494d80b3e41d 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -2532,7 +2532,7 @@ static void ceph_cap_unlink_work(struct work_struct=
 *work)
>         struct ceph_client *cl =3D mdsc->fsc->client;
>
>         doutc(cl, "begin\n");
> -       spin_lock(&mdsc->cap_unlink_delay_lock);
> +       spin_lock(&mdsc->cap_delay_lock);
>         while (!list_empty(&mdsc->cap_unlink_delay_list)) {
>                 struct ceph_inode_info *ci;
>                 struct inode *inode;
> @@ -2544,15 +2544,15 @@ static void ceph_cap_unlink_work(struct work_stru=
ct *work)
>
>                 inode =3D igrab(&ci->netfs.inode);
>                 if (inode) {
> -                       spin_unlock(&mdsc->cap_unlink_delay_lock);
> +                       spin_unlock(&mdsc->cap_delay_lock);
>                         doutc(cl, "on %p %llx.%llx\n", inode,
>                               ceph_vinop(inode));
>                         ceph_check_caps(ci, CHECK_CAPS_FLUSH);
>                         iput(inode);
> -                       spin_lock(&mdsc->cap_unlink_delay_lock);
> +                       spin_lock(&mdsc->cap_delay_lock);
>                 }
>         }
> -       spin_unlock(&mdsc->cap_unlink_delay_lock);
> +       spin_unlock(&mdsc->cap_delay_lock);
>         doutc(cl, "done\n");
>  }
>
> @@ -5538,7 +5538,6 @@ int ceph_mdsc_init(struct ceph_fs_client *fsc)
>         INIT_LIST_HEAD(&mdsc->cap_wait_list);
>         spin_lock_init(&mdsc->cap_delay_lock);
>         INIT_LIST_HEAD(&mdsc->cap_unlink_delay_list);
> -       spin_lock_init(&mdsc->cap_unlink_delay_lock);
>         INIT_LIST_HEAD(&mdsc->snap_flush_list);
>         spin_lock_init(&mdsc->snap_flush_lock);
>         mdsc->last_cap_flush_tid =3D 1;
> diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
> index 317a0fd6a8ba..80b310e33f2b 100644
> --- a/fs/ceph/mds_client.h
> +++ b/fs/ceph/mds_client.h
> @@ -481,9 +481,8 @@ struct ceph_mds_client {
>         struct delayed_work    delayed_work;  /* delayed work */
>         unsigned long    last_renew_caps;  /* last time we renewed our ca=
ps */
>         struct list_head cap_delay_list;   /* caps with delayed release *=
/
> -       spinlock_t       cap_delay_lock;   /* protects cap_delay_list */
>         struct list_head cap_unlink_delay_list;  /* caps with delayed rel=
ease for unlink */
> -       spinlock_t       cap_unlink_delay_lock;  /* protects cap_unlink_d=
elay_list */
> +       spinlock_t       cap_delay_lock;   /* protects cap_delay_list and=
 cap_unlink_delay_list */
>         struct list_head snap_flush_list;  /* cap_snaps ready to flush */
>         spinlock_t       snap_flush_lock;
>
> --
> 2.43.0
>

LGTM, queued up for 6.9-rc.

Thanks,

                Ilya

