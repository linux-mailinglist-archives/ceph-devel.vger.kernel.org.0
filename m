Return-Path: <ceph-devel+bounces-1151-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D3818CA2C5
	for <lists+ceph-devel@lfdr.de>; Mon, 20 May 2024 21:37:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B68F21F21EB4
	for <lists+ceph-devel@lfdr.de>; Mon, 20 May 2024 19:37:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4C5C19BBA;
	Mon, 20 May 2024 19:37:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JgakLSE8"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-oo1-f49.google.com (mail-oo1-f49.google.com [209.85.161.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BE6511CBD
	for <ceph-devel@vger.kernel.org>; Mon, 20 May 2024 19:37:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716233863; cv=none; b=D3D6ky/XgUgzZL/XhO0P0SOS0mmuSUFRaua8Xk54Dgjw5u5RB+B8R94ijhlrSbVsa4ePPKvP3HjuTFtR9ir7dn2My4vGOLAIVb4dh7l0Ym1TmEMk0bZT5jPL7CEbvACvI27wW8TLq7v39sksbJeGjM0I9WQ9sBb64wUajfC3zdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716233863; c=relaxed/simple;
	bh=lhc4Hhaxt+ne8454GzRL0E4HyEQzYoNh0/jfxE34BdQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tvSuR7IYgCLls3ec8xzSXzWElXTTtlUudvXRvj1vShNElYCWfoxVSFe/fdc7tPAxQPaHRIREOtdwa6a5dFizPWVpyUISld/+tQUzTpq2d1oh5xiMEPFkCcWw37ove4GvXMBO+N+BwY66TGo3ZcpkuUyLeTbH3+VC1S1dl28Q/dw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JgakLSE8; arc=none smtp.client-ip=209.85.161.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oo1-f49.google.com with SMTP id 006d021491bc7-5b273b9f1deso1951040eaf.3
        for <ceph-devel@vger.kernel.org>; Mon, 20 May 2024 12:37:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716233860; x=1716838660; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xSH3/q/it/EXxRr4A4hwsSfVakXqO4lNxFCX09pP3Tg=;
        b=JgakLSE8+q+0BnXOJJzIW12rL/8Uc8XdCiseHPaamWosINbQySaIB2cu+8f7IBXqOl
         AM/br7RmrZQOP5lK9KqCKcbDQQjDCAgcmF1XzXTEvB3gJJBU+jdd6OnWES22Aw9olDaB
         1snmHO2we3JjDlF/Ky6coYSZpyEaAwQKPIzJ2KyFkj0XnMALZz8y0BAYzfgCPtLdbt8A
         Hg5a1nV6yoLIaIETp/APhOtf/4+yHR+4XtXa7DQdgWbxAp4aTdly35a0YnbFywZkO+ON
         DjPUcoSgQEB35caNyybDTtzzRDOiN7YxaigOZ8CX/4qhabjT5NWNwSFceIVdl7ZdYm9e
         wJYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716233860; x=1716838660;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xSH3/q/it/EXxRr4A4hwsSfVakXqO4lNxFCX09pP3Tg=;
        b=UhNhd+7lHgO4wUOHyOzMqX+ROlyZEJc+ORb3hv0vyWTtvJWesAl1mHq56WtAXYmbR2
         Lr+dGJF25Hx/gjNjNptMvGhl0ByM6cc5G+dWbx+7p1iTS8yaXrqKlMSV6ovMja3v+Kon
         k0jG39vO6agtkkF2LU23hzo0WwkonzG/VsYbXuBmJlkVFI3hqAj7tvzdSaFkN7RpsANv
         gyaSx+a10uuiBcANM1EwFtyLrhs0RcdNZT/fLxA6szD5IjWEi9Xkdg0JrKR8AzQsQQiN
         Q4n4VNHxWBNz8HWugscLBtL4eCR6WB7gWNPp9Zx7D9T48/epvgwMYQzJ2p/DFQ69XwA8
         Q3BA==
X-Gm-Message-State: AOJu0Ywr2XIk23V4DWqOLoJ7rOQI2Ko7d4Hx+yOvQJjoXmFDMoK8IT9j
	HGIgBvx5ibQetF8ti8LlkY8f4Si7hIli9Euj1zmOd0eS4HmXe8v0yp5ridoNcPB8IZWyyqqBGja
	Yrn7gnWj41T22p22MUrtPATXBVLQ=
X-Google-Smtp-Source: AGHT+IGFPSEF0Uz18F50+ZM/y0DXNPUMHJOZQfaDKMmSsT4hA07eQveQKgZUfw9rMc1JGZaboe5H2NKqXtXHDKB7eSA=
X-Received: by 2002:a4a:ab86:0:b0:5b2:3782:7846 with SMTP id
 006d021491bc7-5b281956da7mr34135543eaf.4.1716233860632; Mon, 20 May 2024
 12:37:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240321021536.64693-1-xiubli@redhat.com>
In-Reply-To: <20240321021536.64693-1-xiubli@redhat.com>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Mon, 20 May 2024 21:37:28 +0200
Message-ID: <CAOi1vP-RdbfmBAku9j104osphc3tk4zgbG-=eQ5yTz1a9s4e=g@mail.gmail.com>
Subject: Re: [PATCH] ceph: make the ceph-cap workqueue UNBOUND
To: xiubli@redhat.com
Cc: ceph-devel@vger.kernel.org, jlayton@kernel.org, vshankar@redhat.com, 
	mchangir@redhat.com, Stefan Kooman <stefan@bit.nl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 21, 2024 at 3:18=E2=80=AFAM <xiubli@redhat.com> wrote:
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

Hi Xiubo,

You wrote that there is no harm in making ceph-cap workqueue unbound,
but, if it's made unbound, it would be almost the same as ceph-inode
workqueue.  The only difference would be that max_active parameter for
ceph-cap workqueue is 1 instead of 0 (i.e. some default which is pretty
high).  Given that max_active is interpreted as a per-CPU number even
for unbound workqueues, up to $NUM_CPUS work items submitted to
ceph-cap workqueue could still be active in a system.

Does CephFS need/rely on $NUM_CPUS limit sowewhere?  If not, how about
removing ceph-cap workqueue and submitting its work items to ceph-inode
workqueue instead?

Thanks,

                Ilya

