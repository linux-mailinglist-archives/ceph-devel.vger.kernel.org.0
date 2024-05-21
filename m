Return-Path: <ceph-devel+bounces-1154-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 950D18CA91C
	for <lists+ceph-devel@lfdr.de>; Tue, 21 May 2024 09:40:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9D0A41C21214
	for <lists+ceph-devel@lfdr.de>; Tue, 21 May 2024 07:40:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CA1850A77;
	Tue, 21 May 2024 07:40:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ajKZnEZJ"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-oo1-f54.google.com (mail-oo1-f54.google.com [209.85.161.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31A4B256A
	for <ceph-devel@vger.kernel.org>; Tue, 21 May 2024 07:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716277205; cv=none; b=nGGlAce+lyMHQwi2VDR+7VgpPEKRjA69Noxrk460S/DQO81/8HLrrdjDQjF/ngvl0ePzBnaBwemPXg991qSY0TvUSd5VtDFsajY0qe2VFTbO9XoNEW+L0sQOzo8Xw50YSYJzIgtzD0Fv6kA4JQYj7IIGc74MQs/YIgRFkgF3J0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716277205; c=relaxed/simple;
	bh=Xgth9OsRTPBxQms0epM5WIqZxH+SiJBXlWIUn/JDvLM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cHJIoXY4EIsbqb4y0g+fGwKCviTo9oDGPQzLdjW9IWxAq+gYUHluMxFDV8egCdbFkwF4Pn0OzZ2xwGm3umBhNJqYWaTUc+p0lksRVwXj3f7PktTE93PByriF+YbhFtmkNN0U2bk6drX6ir/xGkVd9nJ4a4+7JEkdUkDbdnRBhlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ajKZnEZJ; arc=none smtp.client-ip=209.85.161.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oo1-f54.google.com with SMTP id 006d021491bc7-5b295d6b7fbso1975540eaf.0
        for <ceph-devel@vger.kernel.org>; Tue, 21 May 2024 00:40:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716277203; x=1716882003; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u4RfUTXeodUW36BUFLENmjcG2F8W969D7logiOjUKn8=;
        b=ajKZnEZJG22+w89KDw00vRMWkKXbQ17Cmta/6hiQk07EcwkYy9B+IrpWOZk55ic71p
         F9D+LDa0kl4L0t2P6/aZ0Lmp31TvV+XT3m4LYQig9GpXrZa/z2knEdRj781LoAJ5aIgg
         Py0CDsa5C7bwnY7Pf3kR29n0FM1cp3rSd1L8ADQBSynGd46iS3Eu/UtfH/rvKsdU9LMs
         YRXzr2X5XwDI2cAXlu39g1DdFDiqrFwhWC3sWeDvXnu0yjdEpfjfPxGm5UjcnBj9FqNA
         04vnDZp0a5n17h/Kyz3AG0MshfJ6lVcYgYkxVIy6GwEar05C8DnAU0xOeJPQayzIfIix
         NhNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716277203; x=1716882003;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=u4RfUTXeodUW36BUFLENmjcG2F8W969D7logiOjUKn8=;
        b=Z7SaN7nbONWPw9fNeHhiiW07mGMmY4nuYZ0K5w/4E983X2zB1XkCRW/+chyqnKUUW9
         ugFIx/noJhbHGu+nrEVD7SeB/5vh3bVCF3d0GXzM3GftqCWeHCz0Vl8wZTVT0aZTwLkY
         GyG1VtOZY5CCAsfCwG1IaO1fnne5/irztYQz9cqR1e2HS7v0dQ3UQ1+DngvMNMV1S+8f
         B0Yl9Wi702BPRTaIAbXEBd3tq7LjWkWsW+RFbIXBS/ts86MDczilCS2LzTBwsbAUz1/E
         r3ARpKXDOrpZHk1HUDRMWqx2R/cyq9KcSS8BwicOjr8q9LEQtRt14Ao352Kb2xKTRzH6
         7f8Q==
X-Gm-Message-State: AOJu0YwM8uZmNAkrb9sAPSB9TGb3FEnhtG9aYallkEP0iOzg7LCw8sum
	CSTpDtbAf4fGA2/P+eFiDpAsOKj0yZpTG4BH6EXkKdhAdAtI9S6ZWzSJKau6eDhC+qIS2+BeLQG
	+z30zieYCqPIkeRhMtNZlPOS7bpA=
X-Google-Smtp-Source: AGHT+IGqp+PgKbCo5ndz8BlQ1uaQNdYIRZRDLWVYOETC7uFaTTSB3FP+beXr7tvbxmK35lZIUyNHNyn0yt52maUOKWM=
X-Received: by 2002:a4a:5507:0:b0:5b1:beb0:8320 with SMTP id
 006d021491bc7-5b2815c5e3emr30060412eaf.0.1716277203130; Tue, 21 May 2024
 00:40:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240321021536.64693-1-xiubli@redhat.com> <CAOi1vP-RdbfmBAku9j104osphc3tk4zgbG-=eQ5yTz1a9s4e=g@mail.gmail.com>
 <56c20af2-bf22-4cc2-b0db-637a51511c12@redhat.com>
In-Reply-To: <56c20af2-bf22-4cc2-b0db-637a51511c12@redhat.com>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Tue, 21 May 2024 09:39:51 +0200
Message-ID: <CAOi1vP9V0hnoFnH_yKxPnPTHqZdxX=Y--QkGr_28C7075pMxFQ@mail.gmail.com>
Subject: Re: [PATCH] ceph: make the ceph-cap workqueue UNBOUND
To: Xiubo Li <xiubli@redhat.com>
Cc: ceph-devel@vger.kernel.org, jlayton@kernel.org, vshankar@redhat.com, 
	mchangir@redhat.com, Stefan Kooman <stefan@bit.nl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 21, 2024 at 5:37=E2=80=AFAM Xiubo Li <xiubli@redhat.com> wrote:
>
>
> On 5/21/24 03:37, Ilya Dryomov wrote:
>
> On Thu, Mar 21, 2024 at 3:18=E2=80=AFAM <xiubli@redhat.com> wrote:
>
> From: Xiubo Li <xiubli@redhat.com>
>
> There is not harm to mark the ceph-cap workqueue unbounded, just
> like we do in ceph-inode workqueue.
>
> URL: https://www.spinics.net/lists/ceph-users/msg78775.html
> URL: https://tracker.ceph.com/issues/64977
> Reported-by: Stefan Kooman <stefan@bit.nl>
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/super.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> index 4dcbbaa297f6..0bfe4f8418fd 100644
> --- a/fs/ceph/super.c
> +++ b/fs/ceph/super.c
> @@ -851,7 +851,7 @@ static struct ceph_fs_client *create_fs_client(struct=
 ceph_mount_options *fsopt,
>         fsc->inode_wq =3D alloc_workqueue("ceph-inode", WQ_UNBOUND, 0);
>         if (!fsc->inode_wq)
>                 goto fail_client;
> -       fsc->cap_wq =3D alloc_workqueue("ceph-cap", 0, 1);
> +       fsc->cap_wq =3D alloc_workqueue("ceph-cap", WQ_UNBOUND, 1);
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
>
> Checked it again and found that an UNBOUND and max_active=3D=3D1 combo ha=
s a special meaning:
>
> Some users depend on the strict execution ordering of ST wq. The combinat=
ion of @max_active of 1 and WQ_UNBOUND is used to achieve this behavior. Wo=
rk items on such wq are always queued to the unbound worker-pools and only =
one work item can be active at any given time thus achieving the same order=
ing property as ST wq.

This hasn't been true for 10 years, see commit

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?=
id=3D3bc1e711c26bff01d41ad71145ecb8dcb4412576

Thanks,

                Ilya

