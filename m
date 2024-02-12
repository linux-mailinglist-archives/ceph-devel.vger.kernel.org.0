Return-Path: <ceph-devel+bounces-843-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 36CA885174E
	for <lists+ceph-devel@lfdr.de>; Mon, 12 Feb 2024 15:51:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9AFB21F22C09
	for <lists+ceph-devel@lfdr.de>; Mon, 12 Feb 2024 14:51:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D8003BB3A;
	Mon, 12 Feb 2024 14:51:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ix9dkS4I"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 729233B781
	for <ceph-devel@vger.kernel.org>; Mon, 12 Feb 2024 14:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707749484; cv=none; b=fEwFetGsssFUrg4KunUunC6CNEsiqkJCvZ7xz+SCciB0WUMbef1pBr20cdmFjemtos7voN6eIuL9j/4SQA45vzdrguXoUvUkuGF/gihskndeDTjWl3h5m/fgq51Ls80obuoz4eJeTbwsEDgCD85V5BRiGd2HQDdSYOw09wwtzFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707749484; c=relaxed/simple;
	bh=3QwH4aeUOBGCYLaGhmaxA0tGgyInjDJ2ReQphC49UtU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=N+HkX7O6Yi0lvDLndSS/aG/uEGmw7xmSS/U3NNznOSmxvTukZDIAseBa73M8gITiaphvs4Mnp6oYE1d0ZRKfdFUwxaktCjHLoAKDMjLxeYOWt+QUKHo26hYZPOqdg3eyuGKo34RddA/SU/ZPtFgndjBPJSzE+GQT6yLAESH5E5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ix9dkS4I; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707749481;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9cf1mm9G7LlfBXvomjEBxQBa5R/uuwZoDdO7KN3qUrU=;
	b=Ix9dkS4IzOSvz/T1HL1ve9WxOk0szGOGixSHRj8971UadbjJKOLQLumvPYFwOEE1GUI+jB
	uR94nTLXzTuHYrbOc7DUgk3cN/C8MSqQEXEdKMYwKkUbVpXJthDz8ThMdQTyKaUnuW83Xf
	BRb7xL77alOyUrT7TtfTCNDqN8c5KsU=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-399-chBuy2xuM8KOB5NSEeK2lg-1; Mon, 12 Feb 2024 09:51:19 -0500
X-MC-Unique: chBuy2xuM8KOB5NSEeK2lg-1
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-a2f71c83b7eso255572166b.1
        for <ceph-devel@vger.kernel.org>; Mon, 12 Feb 2024 06:51:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707749478; x=1708354278;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9cf1mm9G7LlfBXvomjEBxQBa5R/uuwZoDdO7KN3qUrU=;
        b=Y1qYMvnPs733WOI72YGDO1odfjl2JR8O8gTozRWDUIKGNPErdOG2t/1hrEkxZH/rkW
         jruRwxRF2yoB/jAI5yAm9UsDmq9sHuXSf4D5LVK1mE0OEiY7uRdDVhWa7Ot5FHXVpOXB
         ozkfdC/EBnSsLYB6Dj/xGInhnrdwP5PmhKPquNm2wjtwqw7wh4vlDsaO4oUtdRr5kFXB
         XzhjqZ3kVrI/4I4TsRZcopnw5C3x8FffgVBK2Lp61Vze9FdUiLXgOEBgaAG3LunT/8UE
         ZCTC4UQkzYNDwV9HOLvuJpmcIokmYDO5Fb9QUjD0wFRRlxUYbCRA78ZlQypLkDgjXXEO
         7ovg==
X-Gm-Message-State: AOJu0Ywtwl0WQ2z4gN3JpEKxmDR0q+ZGA0hY4OhqeW9T5J0Mj8MD/MWU
	5e/m16Dz9Brqmq2sLYe7wVKejkaToBgjPAW2A7DLSTmU1dv7Ls9b9lmLbWAOrrM7EJynMM2gxdK
	uxQraytDgA0x0YV4tbPX/l3s49o+G2Arwzziv5jrpOU4ZJrl4OihuW/0W4hE2pPba8BjBxiYpyC
	8U/GdawIdhlYabAqclsornkdPvCFO/lGFuew==
X-Received: by 2002:a17:906:f9cf:b0:a3c:e37e:bbce with SMTP id lj15-20020a170906f9cf00b00a3ce37ebbcemr227878ejb.16.1707749478643;
        Mon, 12 Feb 2024 06:51:18 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFQ15BEUt70aISwAgkSi8RYGz3sxCy6JDLjjGp7+Hq9x2HE9yAzYhdHOtfPAbl5qoMdOxCqxxtqpmhtHkPO8GQ=
X-Received: by 2002:a17:906:f9cf:b0:a3c:e37e:bbce with SMTP id
 lj15-20020a170906f9cf00b00a3ce37ebbcemr227866ejb.16.1707749478221; Mon, 12
 Feb 2024 06:51:18 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240117042758.700349-1-xiubli@redhat.com> <20240117042758.700349-3-xiubli@redhat.com>
In-Reply-To: <20240117042758.700349-3-xiubli@redhat.com>
From: Venky Shankar <vshankar@redhat.com>
Date: Mon, 12 Feb 2024 20:20:40 +0530
Message-ID: <CACPzV1nnEdHjRcq4QuPNQp2fbvQjhAut2XeTv+jXNRADXqtRtA@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] ceph: add ceph_cap_unlink_work to fire
 check_caps() immediately
To: xiubli@redhat.com
Cc: ceph-devel@vger.kernel.org, idryomov@gmail.com, jlayton@kernel.org, 
	mchangir@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 17, 2024 at 10:00=E2=80=AFAM <xiubli@redhat.com> wrote:
>
> From: Xiubo Li <xiubli@redhat.com>
>
> When unlinking a file the check caps could be delayed for more than
> 5 seconds, but in MDS side it maybe waiting for the clients to
> release caps.
>
> This will use the cap_wq work queue and a dedicated list to help
> fire the check_caps() and dirty buffer flushing immediately.
>
> URL: https://tracker.ceph.com/issues/50223
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/caps.c       | 17 +++++++++++++++-
>  fs/ceph/mds_client.c | 48 ++++++++++++++++++++++++++++++++++++++++++++
>  fs/ceph/mds_client.h |  5 +++++
>  3 files changed, 69 insertions(+), 1 deletion(-)
>
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index c0db0e9e82d2..ba94ad6d45fe 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -4785,7 +4785,22 @@ int ceph_drop_caps_for_unlink(struct inode *inode)
>                 if (__ceph_caps_dirty(ci)) {
>                         struct ceph_mds_client *mdsc =3D
>                                 ceph_inode_to_fs_client(inode)->mdsc;
> -                       __cap_delay_requeue_front(mdsc, ci);
> +
> +                       doutc(mdsc->fsc->client, "%p %llx.%llx\n", inode,
> +                             ceph_vinop(inode));
> +                       spin_lock(&mdsc->cap_unlink_delay_lock);
> +                       ci->i_ceph_flags |=3D CEPH_I_FLUSH;
> +                       if (!list_empty(&ci->i_cap_delay_list))
> +                               list_del_init(&ci->i_cap_delay_list);
> +                       list_add_tail(&ci->i_cap_delay_list,
> +                                     &mdsc->cap_unlink_delay_list);
> +                       spin_unlock(&mdsc->cap_unlink_delay_lock);
> +
> +                       /*
> +                        * Fire the work immediately, because the MDS may=
be
> +                        * waiting for caps release.
> +                        */
> +                       ceph_queue_cap_unlink_work(mdsc);
>                 }
>         }
>         spin_unlock(&ci->i_ceph_lock);
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 29295041b7b4..e2352e94c5bc 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -2512,6 +2512,50 @@ void ceph_reclaim_caps_nr(struct ceph_mds_client *=
mdsc, int nr)
>         }
>  }
>
> +void ceph_queue_cap_unlink_work(struct ceph_mds_client *mdsc)
> +{
> +       struct ceph_client *cl =3D mdsc->fsc->client;
> +       if (mdsc->stopping)
> +               return;
> +
> +        if (queue_work(mdsc->fsc->cap_wq, &mdsc->cap_unlink_work)) {
> +                doutc(cl, "caps unlink work queued\n");
> +        } else {
> +                doutc(cl, "failed to queue caps unlink work\n");
> +        }
> +}
> +
> +static void ceph_cap_unlink_work(struct work_struct *work)
> +{
> +       struct ceph_mds_client *mdsc =3D
> +               container_of(work, struct ceph_mds_client, cap_unlink_wor=
k);
> +       struct ceph_client *cl =3D mdsc->fsc->client;
> +
> +       doutc(cl, "begin\n");
> +       spin_lock(&mdsc->cap_unlink_delay_lock);
> +       while (!list_empty(&mdsc->cap_unlink_delay_list)) {
> +               struct ceph_inode_info *ci;
> +               struct inode *inode;
> +
> +               ci =3D list_first_entry(&mdsc->cap_unlink_delay_list,
> +                                     struct ceph_inode_info,
> +                                     i_cap_delay_list);
> +               list_del_init(&ci->i_cap_delay_list);
> +
> +               inode =3D igrab(&ci->netfs.inode);
> +               if (inode) {
> +                       spin_unlock(&mdsc->cap_unlink_delay_lock);
> +                       doutc(cl, "on %p %llx.%llx\n", inode,
> +                             ceph_vinop(inode));
> +                       ceph_check_caps(ci, CHECK_CAPS_FLUSH);
> +                       iput(inode);
> +                       spin_lock(&mdsc->cap_unlink_delay_lock);
> +               }
> +       }
> +       spin_unlock(&mdsc->cap_unlink_delay_lock);
> +       doutc(cl, "done\n");
> +}
> +
>  /*
>   * requests
>   */
> @@ -5493,6 +5537,8 @@ int ceph_mdsc_init(struct ceph_fs_client *fsc)
>         INIT_LIST_HEAD(&mdsc->cap_delay_list);
>         INIT_LIST_HEAD(&mdsc->cap_wait_list);
>         spin_lock_init(&mdsc->cap_delay_lock);
> +       INIT_LIST_HEAD(&mdsc->cap_unlink_delay_list);
> +       spin_lock_init(&mdsc->cap_unlink_delay_lock);
>         INIT_LIST_HEAD(&mdsc->snap_flush_list);
>         spin_lock_init(&mdsc->snap_flush_lock);
>         mdsc->last_cap_flush_tid =3D 1;
> @@ -5501,6 +5547,7 @@ int ceph_mdsc_init(struct ceph_fs_client *fsc)
>         spin_lock_init(&mdsc->cap_dirty_lock);
>         init_waitqueue_head(&mdsc->cap_flushing_wq);
>         INIT_WORK(&mdsc->cap_reclaim_work, ceph_cap_reclaim_work);
> +       INIT_WORK(&mdsc->cap_unlink_work, ceph_cap_unlink_work);
>         err =3D ceph_metric_init(&mdsc->metric);
>         if (err)
>                 goto err_mdsmap;
> @@ -5931,6 +5978,7 @@ void ceph_mdsc_close_sessions(struct ceph_mds_clien=
t *mdsc)
>         ceph_cleanup_global_and_empty_realms(mdsc);
>
>         cancel_work_sync(&mdsc->cap_reclaim_work);
> +       cancel_work_sync(&mdsc->cap_unlink_work);
>         cancel_delayed_work_sync(&mdsc->delayed_work); /* cancel timer */
>
>         doutc(cl, "done\n");
> diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
> index 65f0720d1671..317a0fd6a8ba 100644
> --- a/fs/ceph/mds_client.h
> +++ b/fs/ceph/mds_client.h
> @@ -482,6 +482,8 @@ struct ceph_mds_client {
>         unsigned long    last_renew_caps;  /* last time we renewed our ca=
ps */
>         struct list_head cap_delay_list;   /* caps with delayed release *=
/
>         spinlock_t       cap_delay_lock;   /* protects cap_delay_list */
> +       struct list_head cap_unlink_delay_list;  /* caps with delayed rel=
ease for unlink */
> +       spinlock_t       cap_unlink_delay_lock;  /* protects cap_unlink_d=
elay_list */
>         struct list_head snap_flush_list;  /* cap_snaps ready to flush */
>         spinlock_t       snap_flush_lock;
>
> @@ -495,6 +497,8 @@ struct ceph_mds_client {
>         struct work_struct cap_reclaim_work;
>         atomic_t           cap_reclaim_pending;
>
> +       struct work_struct cap_unlink_work;
> +
>         /*
>          * Cap reservations
>          *
> @@ -597,6 +601,7 @@ extern void ceph_flush_cap_releases(struct ceph_mds_c=
lient *mdsc,
>                                     struct ceph_mds_session *session);
>  extern void ceph_queue_cap_reclaim_work(struct ceph_mds_client *mdsc);
>  extern void ceph_reclaim_caps_nr(struct ceph_mds_client *mdsc, int nr);
> +extern void ceph_queue_cap_unlink_work(struct ceph_mds_client *mdsc);
>  extern int ceph_iterate_session_caps(struct ceph_mds_session *session,
>                                      int (*cb)(struct inode *, int mds, v=
oid *),
>                                      void *arg);
> --
> 2.43.0
>

Tested-by: Venky Shankar <vshankar@redhat.com>

--=20
Cheers,
Venky


