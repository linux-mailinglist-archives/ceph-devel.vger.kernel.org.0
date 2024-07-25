Return-Path: <ceph-devel+bounces-1561-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4369E93BF20
	for <lists+ceph-devel@lfdr.de>; Thu, 25 Jul 2024 11:31:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DDED11F22FBE
	for <lists+ceph-devel@lfdr.de>; Thu, 25 Jul 2024 09:31:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28E6C196DA4;
	Thu, 25 Jul 2024 09:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TnbI382N"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-oi1-f179.google.com (mail-oi1-f179.google.com [209.85.167.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 648532746C
	for <ceph-devel@vger.kernel.org>; Thu, 25 Jul 2024 09:31:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721899897; cv=none; b=Kd0ToVEOYAqzsA7abPvyGEMNncqqvWTp5wKNAZbeiog4wfkmm32fe67k/k9ymFO08ynV8e1bLH6Hk9Yw3bSFx+iAfcx9l3tDDkzRmbhp9E3viA0sg3QNOVs/EkzH2AexgizdmQkK2cstMnbIJsJLxkrkdVk4B2tCIkVYgFSKgHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721899897; c=relaxed/simple;
	bh=2psGS/Kq2y04OCmOaDGEuSk2F+t0xBGk/XxXJOqDzD4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WS0ff/QIfxmkHc41LhXVphy/hOcPPfSpJBgV/iAeaqUwYvGmgx3lBYM+oGN+YgcWs4i+eLl5EonG0INyWS9Q5033jBq0OUuCnN4+6lXr0+YOXEC0Oi8VOaSRhf0d41C4PgwTibOPFAvVYU75cZNMR6crgNbyw/Bt2nEH2mNaz3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TnbI382N; arc=none smtp.client-ip=209.85.167.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oi1-f179.google.com with SMTP id 5614622812f47-3d9de9f8c8dso424569b6e.1
        for <ceph-devel@vger.kernel.org>; Thu, 25 Jul 2024 02:31:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721899895; x=1722504695; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L63uLJ1OVayTKhoPVSWEeh9caApiPw1yVitNuh0+kqs=;
        b=TnbI382NpvssqxAHPAMvb2+4Gcm/ihkwWO0aTwaxLWGY7mKHiFlvjDQok7roEEXL0u
         pVpc6zkhsD9Wtme+7bX2Q5bJXAFCJcoydZjBEZP1wmeb4IGTJ4AWXWJQ9vntmE9UB0Ob
         bev46OKMo3wpOs1ejrCP909V/Tw1fmJh5QcNDHVuFxyzPeSgA2SnXAqQNhvMR+ZwpkQF
         Jn9bMOewFV2y7LBNDpT6jVbTEOFj4NCidWaBYsl6pr0sxpkCgGnFw8yulq7+33b0/8UI
         ACkoHLdVy3OGkfm8qTudluNdF+p6nmrdfajXclXDUZwIk1lFtXM5zmg7pod/A0uzwkqE
         ZM5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721899895; x=1722504695;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=L63uLJ1OVayTKhoPVSWEeh9caApiPw1yVitNuh0+kqs=;
        b=r2lW3GOhWmPUKLZIwww8sdV3OquRsrzeIdFT01YcxAbyZvk/Tkpbr4dWnJ3bXwLOku
         GtmIydrAS9ExwO/s55HVGOdJXV/f1bBlDHJr0xFB5GOrXXox9Bk26nwkeRgMwVgLB+N+
         4/aTAu7lsJXmMK3BWDSAzyldqn8xlI0ZKIyIzVeP+ugONsiTA6WVrc0LTF+isJfh+H7U
         u6DEV6wBWWgyGcB/JBmyOq7snwNr2Hr7oxw5wFtakl2QGoFrF3R+QbUXmtGt9MitxXgR
         k/KIClT68zOhr6LK7q64vpCNzuTdQJinjXhkMKgTDJzbvLRmb3p5Oj67IsOT/aJ4DT7W
         w7yw==
X-Gm-Message-State: AOJu0YxkvrM16EMilo79djoFUZtm4Dx368dffZRv2Irjt0mZTA9OcwRo
	dxx+atSiGXg/z3U9MkepDPeEbRFApXMEvXP5vo9X3xnGB8SapVsdOrsbQ6MvfEh4rkShdL8XO/J
	BRaLXTGTHG2rVpRqAqauW3QJi14dGlEJA
X-Google-Smtp-Source: AGHT+IEbmAk8CWvTONV7dwlEmsEEJKk5QKK6QA1PQ+VKQag6V0oje6MdlZCSxNvPluHz4gQyQBbkEx6dP8Vbw5t8xUI=
X-Received: by 2002:a05:6808:d4f:b0:3da:b074:95f4 with SMTP id
 5614622812f47-3db11040b9bmr2405334b6e.47.1721899895343; Thu, 25 Jul 2024
 02:31:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240724062914.667734-1-idryomov@gmail.com> <20240724062914.667734-4-idryomov@gmail.com>
 <9c6bdd62-58a4-e660-9e59-f2f999795d9b@linux.dev>
In-Reply-To: <9c6bdd62-58a4-e660-9e59-f2f999795d9b@linux.dev>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Thu, 25 Jul 2024 11:31:23 +0200
Message-ID: <CAOi1vP_wyoEhawoArdUmX4i0w1u37Ei7f7nbjy=_ub0gogRd4Q@mail.gmail.com>
Subject: Re: [PATCH 3/3] rbd: don't assume rbd_is_lock_owner() for exclusive mappings
To: Dongsheng Yang <dongsheng.yang@linux.dev>
Cc: ceph-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 25, 2024 at 10:45=E2=80=AFAM Dongsheng Yang
<dongsheng.yang@linux.dev> wrote:
>
>
>
> =E5=9C=A8 2024/7/24 =E6=98=9F=E6=9C=9F=E4=B8=89 =E4=B8=8B=E5=8D=88 2:29, =
Ilya Dryomov =E5=86=99=E9=81=93:
> > Expanding on the previous commit, assuming that rbd_is_lock_owner()
> > always returns true (i.e. that we are either in RBD_LOCK_STATE_LOCKED
> > or RBD_LOCK_STATE_QUIESCING) if the mapping is exclusive is wrong too.
> > In case ceph_cls_set_cookie() fails, the lock would be temporarily
> > released even if the mapping is exclusive, meaning that we can end up
> > even in RBD_LOCK_STATE_UNLOCKED.
> >
> > IOW, exclusive mappings are really "just" about disabling automatic
> > lock transitions (as documented in the man page), not about grabbing
> > the lock and holding on to it whatever it takes.
>
> Hi Ilya,
>         Could you explain more about "disabling atomic lock transitions"?=
 To be
> honest, I was thinking --exclusive means "grabbing
> the lock and holding on to it whatever it takes."

Hi Dongsheng,

Here are the relevant excerpts from the documentation [1]:

> To maintain multi-client access, the exclusive-lock feature
> implements automatic cooperative lock transitions between clients.
>
> Whenever a client that holds an exclusive lock on an RBD image gets
> a request to release the lock, it stops handling writes, flushes its
> caches and releases the lock.
>
> By default, the exclusive-lock feature does not prevent two or more
> concurrently running clients from opening the same RBD image and
> writing to it in turns (whether on the same node or not). In effect,
> their writes just get linearized as the lock is automatically
> transitioned back and forth in a cooperative fashion.
>
> To disable automatic lock transitions between clients, the
> RBD_LOCK_MODE_EXCLUSIVE flag may be specified when acquiring the
> exclusive lock. This is exposed by the --exclusive option for rbd
> device map command.

This is mostly equivalent to "grab the lock and hold on to it", but
it's not guaranteed that the lock would never be released.  If a watch
error occurs, the lock cookie needs to be updated after the watch is
reestablished.  If ceph_cls_set_cookie() fails, we have no choice but
to release the lock and immediately attempt to reacquire it because
otherwise the lock cookie would disagree with that of the new watch.

The code in question has always behaved this way.  Prior to commit
14bb211d324d ("rbd: support updating the lock cookie without releasing
the lock"), the lock was (briefly) released on watch errors
unconditionally.

[1] https://docs.ceph.com/en/latest/rbd/rbd-exclusive-locks/

Thanks,

                Ilya

