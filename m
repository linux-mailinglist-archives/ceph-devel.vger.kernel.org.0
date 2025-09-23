Return-Path: <ceph-devel+bounces-3716-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E656B97357
	for <lists+ceph-devel@lfdr.de>; Tue, 23 Sep 2025 20:33:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 19F2D19C2BF1
	for <lists+ceph-devel@lfdr.de>; Tue, 23 Sep 2025 18:33:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BA382FFFB4;
	Tue, 23 Sep 2025 18:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="El6i3ZW0"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53BC62FC034
	for <ceph-devel@vger.kernel.org>; Tue, 23 Sep 2025 18:33:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758652395; cv=none; b=FWS+UHGzISJFE0jjw1l1SKt2WPCRDFP1qXvsZA/K11idAEdpvDbc1NaSOuAWxfs2f0C9cj2cZ3PC1PJQb6gfsueu3d2R0NFkKzR+/TETqZ7I4fXJPGnofWgUn+kCJFeBXq6SyVUwMN+pYPaIOFPijsSJTmfJNlAs3qJ/vShJ7DU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758652395; c=relaxed/simple;
	bh=FfCTMfFY5Ecd5/hhtbPWeot4Dm9laoadRnoAXn9vCwQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tsblV1+vg4MVq8fLFFnn1cOa2LeBKc77a4jjnfAcg7fQawCqZYxXJ8vedtTOPpeyQsnRu6c9Yb/ceX23JLTqb88JSJAkqFw1vli94gupxis+HMx9VJFknbHRIXX0tKZXxRwsOAvzgNkQhwMWBWRSPbeB4XVorzhmW9xpIgsFxbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=El6i3ZW0; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-77f605f22easo590381b3a.2
        for <ceph-devel@vger.kernel.org>; Tue, 23 Sep 2025 11:33:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758652393; x=1759257193; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zRWvpeGmEKncsdXNbj6idg8q2ctEKL5deBnGJt/MKlM=;
        b=El6i3ZW0VKirAtplNvZ8Etdo1ivlqLBSd5yA94kCR4TF60mkSWA/OEom0ywuKXXNWi
         jGBlgNt+Pu+nHCpsmBGdFTwtPR33J+3Sh0y0ncXexUPj3IwEoj/+XcJapSfeULkfboY5
         tQkU/Z6caJkYnzDVP9yr4alqB82jqITAlKeK2i7Nb8UM9OzEq7ZqcRSAjxcCX7WaA1k5
         kS8f8XbAZmeBkSHChca7shZg35nKONy8tyITJ/6F7q0HtWIR5YclbbbXbqTAvsQTic/+
         AchbBrmryyvTIa3Hl17DcRc1X4ICXNQvpCwpspluwN8vqoqbC4bpsPbddSY2DOAmbmvC
         2L2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758652393; x=1759257193;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zRWvpeGmEKncsdXNbj6idg8q2ctEKL5deBnGJt/MKlM=;
        b=XW+fYv5sg1DGe3URnrAYHo5BnWtL0NnhjXHJw4srFLsRwtgW7s/o/JcdF9SobyGJfJ
         6zIwcfdl+r/d5PPh2IPVP6nK1Ei7QZrgITl2nrKGybFgpgPSFjk9ugNwTX+ieNZGyb4M
         EMxA3bfk2MelYz5sk10Z7PW/yZUkD/P8//ZE5z6uPPtZyiDNJYioZcP2AwcNEnfVoZvP
         B+LRlTklhrY4yvESo7jPgiVwas37+mOakE08rSZF1VoIdskkwnBPDXsDjPwX3kk6C4T5
         OGkN1pk2DAd2uB/90j7gwP8djnyTsasCsrShgaxuFbxHmwAQeK/OvBfxl8/6OXkcafpS
         xktg==
X-Forwarded-Encrypted: i=1; AJvYcCVgxkxPSObE72iwTLeYHQE8G0/PanoXVDOpOUpEgedI6L+6Y7lzejyR9B8wnE1ND6SPuJgpHDxuw6tI@vger.kernel.org
X-Gm-Message-State: AOJu0YwPzOR25kCJdfzxzwdvZQ0BpyMVsgju4UUVS3gbiuWUqN9UBmXF
	POEjlUr99H6gXlH/rBK/41AuSYn+431bIF7ClcRiM1pS+KZKPkcb2rboQYgxAiDflK23KKFq7eR
	saxa6kzE/s+W5xtf+SUYb+WpJleNWamM=
X-Gm-Gg: ASbGnctKxAjw50mnOwtVwjoE146elzB6QUO7xSJLUOc/aDBhLDjuiMFRqvld8wG7SW8
	rAec+BI4E3ox91hXWCYFcuvLN/vPWhLn9ofz9MzKfal+nXOy+q5xjNo4h6KZDpLXPHbpOizVZaD
	ufGf4RvRTIFZmCGy7vi4GNW8u5sTjd5zYttnBZAKI8O28NTBJxKKMcKRnFWnWiQmKIvC3MWaGOb
	tvyfzY=
X-Google-Smtp-Source: AGHT+IF+7/DOHzhWw62X+nRX/tWt/I6eNPbBg5ZXCB+rwUqGcHoNbzj3Jc/bLK4m8+ZK17vyfU8rvFp9Og6hJtCvcxo=
X-Received: by 2002:a17:903:2f4c:b0:269:936c:88da with SMTP id
 d9443c01a7336-27cc5fcc0femr42352135ad.41.1758652393416; Tue, 23 Sep 2025
 11:33:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <36681e9d-fde6-4c5d-bf35-db9d85865900@tu-ilmenau.de>
In-Reply-To: <36681e9d-fde6-4c5d-bf35-db9d85865900@tu-ilmenau.de>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Tue, 23 Sep 2025 20:33:01 +0200
X-Gm-Features: AS18NWA-BdyoDpx_tl3w6wy4oodeGewac7r-au-mOqoYkzh-U97qGfF2EWFYbh8
Message-ID: <CAOi1vP_8MXfbM=dncfNXvPXvUO2dXr-9rj1YVEMYPLjj-Ox4ng@mail.gmail.com>
Subject: Re: [bug report] rbd unmap hangs after pausing and unpausing I/O
To: Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>
Cc: Xiubo Li <xiubli@redhat.com>, ceph-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 23, 2025 at 12:38=E2=80=AFPM Raphael Zimmer
<raphael.zimmer@tu-ilmenau.de> wrote:
>
> Hello,
>
> I encountered an error with the kernel Ceph client (specifically using
> an RBD device) when pausing I/O on the cluster by setting and unsetting
> pauserd and pausewr flags. An error was seen with two different setups,
> which I believe is due to the same problem.

Hi Raphael,

What is your use case for applying pauserd and pausewr?  I'm curious
because it's not something that I have seen used in normal operation
and most Ceph users probably aren't even aware of these flags.

>
> 1) When pausing and later unpausing I/O on the cluster, everything seems
> to work as expected until trying to unmap an RBD device from the kernel.
> In this case, the rbd unmap command hangs and also can't be killed. To
> get back to a normally working state, a system reboot is needed. This
> behavior was observed on different systems (Debian 12 and 13) and could
> also be reproduced with an installation of the mainline kernel (v6.17-rc6=
).
>
> Steps to reproduce:
> - Connect kernel client to RBD device (rbd map)
> - Pause I/O on cluster (ceph osd pause)
> - Wait some time (3 minutes should be enough)
> - Unpause I/O on cluster
> - Try to unmap RBD device on client
>
>
> 2) When using an application that internally uses the kernel Ceph client
> code, I observed the following behavior:
>
> Pausing I/O leads to a watch error after some time (same as with failing
> OSDs or e.g. when pool quota is reached). In rbd_watch_errcb
> (drivers/block/rbd.c), the watch_dwork gets scheduled, which leads to a
> call of rbd_reregister_watch -> __rbd_register_watch -> ceph_osdc_watch
> (net/ceph/osd_client.c) -> linger_reg_commit_wait ->
> wait_for_completion_killable. At this point, it waits without any
> timeout for the completion. The normal behavior is to wait until the
> causing condition is resolved and then return. With pausing and
> unpausing I/O, wait_for_completion_killable does not return even after
> unpausing because no call to complete or complete_all happens. I would
> guess that on unpausing some call is missing so that committing the
> linger request never completes.
>
>  From what I am seeing, it seems like this missing completion in the
> second case is also the cause of the hanging rbd unmap with the
> unmodified kernel.

You are pretty close ;)  The completion is indeed missing, but it's
more of a side effect than the root cause.  The root cause is that the
watch request doesn't get resubmitted on paused -> unpaused transitions
like it happens on e.g. full -> no-longer-full transitions -- the logic
around forming need_resend_linger list isn't quite right.  I'll try to
put together a fix in the coming days.

Thanks,

                Ilya

