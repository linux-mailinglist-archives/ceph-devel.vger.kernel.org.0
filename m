Return-Path: <ceph-devel+bounces-3667-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B8491B81EA1
	for <lists+ceph-devel@lfdr.de>; Wed, 17 Sep 2025 23:18:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3FE0D1C24599
	for <lists+ceph-devel@lfdr.de>; Wed, 17 Sep 2025 21:19:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 961DB22A4E5;
	Wed, 17 Sep 2025 21:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lUHYZlFg"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B258A1C3BFC
	for <ceph-devel@vger.kernel.org>; Wed, 17 Sep 2025 21:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758143928; cv=none; b=rFmWAokWKAsi1GWY5Suk/qtHC2AH+A4jKWEnPMMr13MyXM1BMQdwj9sUzpbxWE9OwutqegzmGNuxxsIE5Vcb9SrUFpQmyZPwps7jqqTXL4a/+ac29aPhiFHJE3x0uHt9qFs+8LJmnRnbcy758E+B4bmpJM1Gg0Jco07C/HiyMKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758143928; c=relaxed/simple;
	bh=CPPTbnKB9BzFY8MLjt3XnUuemDBlTd7IzD+SCi7UPv4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pE52ypQbnvKWLD+kk+WufCjSa9fRTbj9cqJePlEJHs28atq6cVLERm6AWBDlouhXy68RRp15hyD4jVgvtcijH5I5/ZH1lZL5lp/hlxlhA2MZBp/JEB+dfM3eJv4vccB+i+ElWtyG9iRrBGDZx063zb5Lqa/G7RPdvL2WkXC2wAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lUHYZlFg; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-628f29d68ecso375400a12.3
        for <ceph-devel@vger.kernel.org>; Wed, 17 Sep 2025 14:18:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758143925; x=1758748725; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I+4zDUZvcLkjNXzlt5Aq3+g1zpnB50vN9F3ZvcF1/wc=;
        b=lUHYZlFgrt9ZUFZyijeq7ya9wilU9P0huFPi71SZ88OR2Nc2/SxImsSBxl7JNlE1Fb
         RcJkzhxnrFWwImuUKtgkO7dUFvO6UOa1FvU1I0eF9F8W4EtWSpEyf1CVH9sO/5TQ7gzd
         En9rNFOlwnZgtZETV6+9J2qI5N+a9EZZtu8xI2B0VPo9qgHzfsvwyj3jszhxIJcrcnEi
         gIdttwiJARoLtm7mA1yVFZSSNV7d+O4ZkfX2C66zJI1MSjp2pjNT7ycnOhtBF/6MrDM3
         uI/ms/TucWjoFKCGptDfPv+wKC3+FCtVm0eTTSJ22d/xs1SzLWrtDU0VJ/z1L+MgFLJy
         S+bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758143925; x=1758748725;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=I+4zDUZvcLkjNXzlt5Aq3+g1zpnB50vN9F3ZvcF1/wc=;
        b=Y2nIr2sWg2wI4IvHzvxyjOTSVuDmWesZUJw8Z2px6yLR5CiaeYCcKNkal49M4W9+6+
         Dgfcsc7ECULKGJsmBD2EgqRX5dqSzQFEipwrkTQ/6xF5uXH9437wDJANJLeVHcsE1IJm
         rvj28VINcxdfhuPOq59n/wSVNm8DNes2cDkGidYlwTXORWuKWO6vK8C5NHuEFiCCAs8C
         VDNQRfmaiG5O0VlkJ15ACOFYngrZBzPmlxzO2+dz2OWCEhCZOZfWI1WSXSGVqwhi0yZZ
         ZtYHJuXju/8vQJ+dgIW+th8g3Sv4jQBbu5Yeo0yRoNHWzfXBWs24ngyhoYBmYdk7LfnK
         UVwQ==
X-Forwarded-Encrypted: i=1; AJvYcCVWGdVAOaXC+gt/ILFm9jIDyoCal4BPI/vWYxGq9Dhm46uKjbRUOAa95PRbIYmLlXSKN7LoDpj8JLpn@vger.kernel.org
X-Gm-Message-State: AOJu0YzN9lDuwXLZjtknLqU31XyfkSce7t01GIHr1N5bnsgRE8Q9B8l6
	lD10qet6JdfKlwQyRGi6yN+4wE4WSw62HIiOnTkE9RfZ05nTQicO8KmmHDoqjdM1owUh7tKhZWZ
	HkWuHFMWV4MQbZZFgXiOB0/VRE2D0Fj7zeEllvLs=
X-Gm-Gg: ASbGncvLIhs/dMye4R86LrBvVlu1dZzMtGKT7vJMoZrc4ZBik/PYG+8mKxIAJyYrGvR
	gG4QraF0pab01p+QN4ZwXpMcCNAuy8YJM+vWXdDyk1pleDLo1rQsSCBXbIRYqozXyQTlkRAjQ30
	p/WfOV6ZWUdGA4jJQSm6Z+22vyHkwm/OVGlENtoZxxWrCqYXjOxpIrg0Gg3GCOwvwsbavQA0bcj
	lkBSgdOyyyPMQma9CDohr00BnLHio+v0lT/uPDJwUdNISm4QWYV1a4E7ztCHC7bL5da
X-Google-Smtp-Source: AGHT+IGFkUjrPG1jXZau1U7BaKFkQzm7O6SgJWCgDvQsw2T7Ujvbun5mQ/1iWGF5UyEcyRSk+fAqmVZS/fniGxkTHIQ=
X-Received: by 2002:a05:6402:3496:b0:62f:391c:81d9 with SMTP id
 4fb4d7f45d1cf-62f84465dbdmr3588278a12.24.1758143924916; Wed, 17 Sep 2025
 14:18:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAKPOu+-QRTC_j15=Cc4YeU3TAcpQCrFWmBZcNxfnw1LndVzASg@mail.gmail.com>
 <4z3imll6zbzwqcyfl225xn3rc4mev6ppjnx5itmvznj2yormug@utk6twdablj3>
 <CAKPOu+--m8eppmF5+fofG=AKAMu5K_meF44UH4XiL8V3_X_rJg@mail.gmail.com>
 <CAGudoHEqNYWMqDiogc9Q_s9QMQHB6Rm_1dUzcC7B0GFBrqS=1g@mail.gmail.com>
 <20250917201408.GX39973@ZenIV> <CAGudoHFEE4nS_cWuc3xjmP=OaQSXMCg0eBrKCBHc3tf104er3A@mail.gmail.com>
 <20250917203435.GA39973@ZenIV> <CAGudoHGDW9yiROidHio8Ow-yZb8uY7wMBjx94fJ7zTkL+rVAFg@mail.gmail.com>
 <20250917210241.GD39973@ZenIV>
In-Reply-To: <20250917210241.GD39973@ZenIV>
From: Mateusz Guzik <mjguzik@gmail.com>
Date: Wed, 17 Sep 2025 23:18:32 +0200
X-Gm-Features: AS18NWCkia-Sx0-wjO0zxGoUs9dltKFlKpfhwDC2lrItr-gr9dXtrlhzF4HaAbI
Message-ID: <CAGudoHHnNpJViGU-HaYOKNw0EGqT3vHn819zDLOMJAoqkLUQwQ@mail.gmail.com>
Subject: Re: Need advice with iput() deadlock during writeback
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Max Kellermann <max.kellermann@ionos.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, 
	Linux Memory Management List <linux-mm@kvack.org>, ceph-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 17, 2025 at 11:02=E2=80=AFPM Al Viro <viro@zeniv.linux.org.uk> =
wrote:
>
> On Wed, Sep 17, 2025 at 10:39:22PM +0200, Mateusz Guzik wrote:
>
> > Linux has to have something of the sort for dentries, otherwise the
> > current fput stuff would not be safe. I find it surprising to learn
> > inodes are treated differently.
>
> If you are looking at vnode counterparts, dentries are closer to that.
> Inodes are secondary.
>
> And no, it's not a "wait for references to go away" - every file holds
> a _pair_ of references, one to mount and another to dentry.
>

That I know, I just blindly assumed inodes also stall teardown in some
way. That said I see generic_shutdown_super() and indeed it works as
you described and now as I assumed.

> Additional references to mount =3D> umount() gets -EBUSY, lazy umount()
> (with MNT_DETACH) gets the sucker removed from the mount tree, with
> shutdown deferred (at least) until the last reference to mount goes away.
>
> Once the mount refcount hits zero and the damn thing gets taken apart,
> an active reference to superblock (i.e. to filesystem instance) is
> dropped.
>
> If that was not the last one (e.g. it's mounted elsewhere as well), we
> are not waiting for anything.  If it *was* the last active ref, we
> shut the filesystem instance down; that's _it_ - once you are into
> ->kill_sb(), it's all over.
>

Ye I see. Thanks for the breakdown.

> Linux VFS is seriously different from Heidemann's-derived ones you'll fin=
d in
> BSD land these days.  Different taxonomy of objects, among other things..=
.

So I keep finding.

But in this case I have to mention btrfs has some hand-rolled delayed
iput (see btrfs_run_delayed_iputs et al), perhaps something you may
want to take look at if you had not.

More importantly though, that's 2 filesystems which would like to do
async iput. Would be nice(tm) if the layer provided a helper to do it
safely.

