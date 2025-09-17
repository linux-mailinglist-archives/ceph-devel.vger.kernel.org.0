Return-Path: <ceph-devel+bounces-3647-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 066F0B7FF60
	for <lists+ceph-devel@lfdr.de>; Wed, 17 Sep 2025 16:27:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 04D4F1C254A1
	for <lists+ceph-devel@lfdr.de>; Wed, 17 Sep 2025 14:18:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DE862D3A9C;
	Wed, 17 Sep 2025 14:12:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gWqjDtYK"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5477F2D248F
	for <ceph-devel@vger.kernel.org>; Wed, 17 Sep 2025 14:12:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758118363; cv=none; b=BrO1Nh6cVI4qBlFbeLaGaLJCft372okpcVKoOW7UtI+4UVd2SzfjQkpghi+50KlxEdVPIzu9LmBMW/9Ji86SISxM6FUg6WTO+yloKQW0ZKnjSroY74ysBLthTRTZQFjT21w8lXSVkkAOZo9KX2+RUU612U1D/hAs8xoh4qMXTI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758118363; c=relaxed/simple;
	bh=vAYyAJ+N5WTUxHpW/2g+4xRdn898OyOEJIqpwPj9b/M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RQXw95PXm13OId1/mgOZe0ghfp0npuEvrKXevKESJUe70yePZU1COpyIG9bwB4LScUU4EVDhgrONDnmTwwi3yq92NKORlijzL0971t+2SnkI0PAoYDBD7CXGcQZw/SlGTG/I8SAxZQS4WmQuqdJQoYy6WCpOt6Z5ups+uCdLFlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gWqjDtYK; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-62f1987d4b2so8159030a12.2
        for <ceph-devel@vger.kernel.org>; Wed, 17 Sep 2025 07:12:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758118360; x=1758723160; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WvQvK494s3Wti/cOQyypkRIXGy03yU4MOudBoB5xafc=;
        b=gWqjDtYKZECXpoL15ydkDavMXNNUrgcroJ92oeqmnJahgeou3sqTIMw/IR4Ol69Gws
         Xe0nQgydGx1c4lN9VwCVJYWLjUSRUeQpV9UAqcAV6JF/QNSpwe+NC6OkyrOS6kYBE9Js
         7qeqZCLVidgNsx+l65NWdctxNpFII+qNR8T2a75KIak9Os8bPLfy2WAkFl6hjDgSIKNh
         AwQodrsyY67qeRvHv0hewe370P/v0/KN9KewGy/YVGKIlJmHolIPjpZwr+5ewL6H3+pl
         wxun/kUooymxpzTUGwf/2VtPX1m+jrYI2mmo/ptkYWpfymsCKvfsriWpgsWNxyPdJ8kl
         3QwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758118360; x=1758723160;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WvQvK494s3Wti/cOQyypkRIXGy03yU4MOudBoB5xafc=;
        b=enbU3mxHF96vj3A5e2kzchxL316W3v7RzDV9wschkoWv9YQsTMdJ8ZutS+cLAAON0U
         4KNeYatXC63mVOr5LTm610H2K0eWcVutunKq6KLL0TmCKmYwvOWDWJlJQ3VEpWayf2ud
         o32spK02aHRDqxu06iL35YsIIkaPYGrxQVDkQY/mC0kXCKn0z+DM7LvkeqG0WrP8uDYM
         FFg47pL7OijaQFMb1mZM6BVyWb/JlAcAQR95bonSW2Usxr1sU9SFtuqzXTbJ0tYDLVnF
         FphwYp4d1FhzFD7G+H8JHvpui4aNb7eBnAmCBZxhC3tXrb8N59X+hPMRjeR2iLkLjOiC
         LyLA==
X-Forwarded-Encrypted: i=1; AJvYcCWW1podBmlKTVupIkKUlfwcryFP1KuOUNlF9Og2TlZCyX/60gelzs+wo3ianc9epojWpToHmsHwHT63@vger.kernel.org
X-Gm-Message-State: AOJu0YyuQHq+3NpokADMbCdKkHXNgQ391NIJI36IkEYnkYIxdwzcvm/8
	riYNEbjDxxYk9wxvuL3JAsWV/O94tp504xBdT5+BUiTxlmd/LB6edCWB17pYk9NAuAHKn7+hyDk
	Q+LrXH0l1TW1cDSjws3BrHAOExXtgkCs=
X-Gm-Gg: ASbGnctS2Mp0moJL0aGbiVNnRwL1zrnOXmHaeumq1iLvSR2CvF8hKWsqRgphYBiJciI
	a1C10uaxOgQEl4vo90MEtEKodDjp8v9ZT7oHUWKlV/ewYy8Nt6/xld+51LqM71tOlx7aY1vRYQz
	wZt1hwAWm7IDbhWo+rdC8SSB5gNkY5oEuP8yik8IRIw3r7u+ohOYYl5LQ+TvyoTG5xtlwx3adPV
	MSJruPamdAXNGVZEL4m/KsfBAte0Pqne+Amq24=
X-Google-Smtp-Source: AGHT+IE9tr65JazvM/P627oMjCH4lIxKxEXEjsbR4TaPhmEPiMyOp6W2xKFTSemRXPP2tElpIwdULTqBUJpCrnwZP+8=
X-Received: by 2002:a05:6402:280a:b0:629:949c:a653 with SMTP id
 4fb4d7f45d1cf-62f8422dd27mr2681936a12.24.1758118359355; Wed, 17 Sep 2025
 07:12:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250917135907.2218073-1-max.kellermann@ionos.com>
In-Reply-To: <20250917135907.2218073-1-max.kellermann@ionos.com>
From: Mateusz Guzik <mjguzik@gmail.com>
Date: Wed, 17 Sep 2025 16:12:26 +0200
X-Gm-Features: AS18NWBVEzgWJelbyAZl8OravcOrQ3fPpZBJDvJxRNN-yXIAsbshHF34p8BX9gc
Message-ID: <CAGudoHF0+JfqxB_fQxeo7Pbadjq7UA1JFH4QmfFS1hDHunNmtw@mail.gmail.com>
Subject: Re: [PATCH v2] ceph: fix deadlock bugs by making iput() calls asynchronous
To: Max Kellermann <max.kellermann@ionos.com>
Cc: slava.dubeyko@ibm.com, xiubli@redhat.com, idryomov@gmail.com, 
	amarkuze@redhat.com, ceph-devel@vger.kernel.org, netfs@lists.linux.dev, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 17, 2025 at 3:59=E2=80=AFPM Max Kellermann <max.kellermann@iono=
s.com> wrote:
> +/**
> + * Queue an asynchronous iput() call in a worker thread.  Use this
> + * instead of iput() in contexts where evicting the inode is unsafe.
> + * For example, inode eviction may cause deadlocks in
> + * inode_wait_for_writeback() (when called from within writeback) or
> + * in netfs_wait_for_outstanding_io() (when called from within the
> + * Ceph messenger).
> + */
> +void ceph_iput_async(struct inode *inode)
> +{
> +       if (unlikely(!inode))
> +               return;
> +
> +       if (likely(atomic_add_unless(&inode->i_count, -1, 1)))
> +               /* somebody else is holding another reference -
> +                * nothing left to do for us
> +                */
> +               return;
> +

LGTM, I see the queue thing ends up issuing iput() so it's all good, thanks=
.

No idea about the other stuff it is doing concerning ceph flags so no comme=
nt.

> +       doutc(ceph_inode_to_fs_client(inode)->client, "%p %llx.%llx\n", i=
node, ceph_vinop(inode));
> +
> +       /* simply queue a ceph_inode_work() (donating the remaining
> +        * reference) without setting i_work_mask bit; other than
> +        * putting the reference, there is nothing to do
> +        */
> +       WARN_ON_ONCE(!queue_work(ceph_inode_to_fs_client(inode)->inode_wq=
,
> +                                &ceph_inode(inode)->i_work));
> +
> +       /* note: queue_work() cannot fail; it i_work were already
> +        * queued, then it would be holding another reference, but no
> +        * such reference exists
> +        */
> +}
> +

