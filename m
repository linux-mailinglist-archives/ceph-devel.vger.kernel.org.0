Return-Path: <ceph-devel+bounces-3672-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A545B82376
	for <lists+ceph-devel@lfdr.de>; Thu, 18 Sep 2025 00:59:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 670603A72BB
	for <lists+ceph-devel@lfdr.de>; Wed, 17 Sep 2025 22:58:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 891A830FC0F;
	Wed, 17 Sep 2025 22:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hWM9xtQI"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A70B30EF67
	for <ceph-devel@vger.kernel.org>; Wed, 17 Sep 2025 22:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758149935; cv=none; b=OGNqKub9mJW2OMZzEmrew42KnrOTLUageohZDTJDDT6vwius2j877BUBsx0VcmT2u8r7TC3YamskMDN2kpI55RMh3eKCts2hLsBIRTCiBT4nb5SpKDzIySum08dlwLm4yXHhCvI2GZMT54MnFVJOyoDAHsq/dJSrBkXfVkNQHtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758149935; c=relaxed/simple;
	bh=IOOEuCzwU/igj7JGu+xvf0xOgf+56/p3/Y92ibzkIqY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=f5lpJCtbfvZiFhHnMXO0TD8vGGmJrodBI3UHyqF3YB16+gwyYmK8l2NUqwF9LqcyNTmaZxSYWMis+9vLMRycMoRC7dGTryks/rKtgx0heZguCQboJYWVBg/rdNM8CR+zO7sJaKWKL+vQdm3hW2tQwGfC3MnuqyLX+0EwWIqtEms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hWM9xtQI; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-62f0411577aso568038a12.1
        for <ceph-devel@vger.kernel.org>; Wed, 17 Sep 2025 15:58:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758149932; x=1758754732; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=it0hw7STF0VKiuKn78g4szyYtwsB+CgMo5LILw/Kbs0=;
        b=hWM9xtQIwFG1wV4HY6dDMwLX4kOKsVZWGZSlvh8BkW9fYDKridKMl83N3naNd+jG+k
         RXZZfXYXUmBtjWMGmdN0++ax46/tcOTPFfJ4JyEIT+dlgarIfSq3GYx+4RUAE8F9Ef0q
         s4+8VpWwtWw6zEfxWaNzgPc6oBv0XnLn4d5Xc4p2Kp2Vdkoi2pLsVOu5jqrlPgzIKCzi
         /54QnEbH8jVUwWV+jZPCq0kTElBlUViyfyQtb4SF6DX505fWjuei5IWhvyhUdQRR0kCP
         dCaceJINB+fPdUxTtFE7lyY062lYVu9KbOcTdajyoX6HgmEulSgNh6xFahm7ieuiVh1A
         ekSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758149932; x=1758754732;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=it0hw7STF0VKiuKn78g4szyYtwsB+CgMo5LILw/Kbs0=;
        b=vb9tdMuN6rka5PA11cLRez0rOVrHmbi6pgv82x5W9KhqDQ8TJIvG+Tcq3gQZqX4zat
         /Niw1Wcgnq3dwzOztBAtvr+Pg7iPls0jrQiNkujlqJhz3/PVyVBcteTSPxsckla95Jbo
         +d1fC+ujpvRno83KT8lUVMFhv8h0/DqSDBQD+CRat1Lv1UrGhg5uUzOyFMWgAFXDx9uG
         vHYigmT4u8ePDOJWoomddmpojFqqsViqc4ONCDfPGWWp7SgU4Hrnk52r+JmU7m+4/KhD
         dXEJii3Po+RXf5+YuDtJBuE4ccJZ9j4d3OtUAxfL5aHX95SnjKAREexDPClLF37VujO9
         9T+A==
X-Forwarded-Encrypted: i=1; AJvYcCUHS8Gd3TMZk9PAxASxr8aPz1am+1i4/Ilm0IADXjKZ2vd89I+BSwA70dY/KXLUUqIlxmVUqlxyJeXR@vger.kernel.org
X-Gm-Message-State: AOJu0YwkHgzdvenLON6w7CWccmdNI3t8ZZfUNjdqMdd0ZWNMcww4nZez
	4qU429dz1j9XkL6ttm9HbjVMuB/2hol43LhhwT9tpOiR4TPzjh5oX8Mp65Qf84qvZDp3egVo6fC
	bfkP1ZiZeSZn11kXtKzcHiVR0GwmOfW8=
X-Gm-Gg: ASbGncvvaBr7OSUMlfGS5zuoy0VsYD6EvjEuTgjpxKVN/Ba7l3+YbTTYEB4EfFr3kmQ
	OiKQSK/cVdjn1FTmujJ+8pGKRwsOaqjd8yxau69crRQzXPamTtNoPgGNS6qnHqKigvZzbkiuu7i
	Iw7n4BP7xb3zQgV8Bnx5FBi5CgT+nT50SwSLeGVucnO0P9g4Jz81ZjiglgyfhAvcrPlO+Ot5pNW
	oKwwTgu1P7sq9GD/8cuAmrS3h+c3MnWMhBMow4roLScYQA+GwhK49th2A==
X-Google-Smtp-Source: AGHT+IF5Oo0BBvrA+aww1rEutWij2SvX5Gh4f+3J9obY0bllBpPQD0meffz5TJgyN0dgQ74slyUif+t8TL+R1MHOPhY=
X-Received: by 2002:a05:6402:a0c1:b0:61d:249a:43fe with SMTP id
 4fb4d7f45d1cf-62f842322cbmr3728400a12.24.1758149931621; Wed, 17 Sep 2025
 15:58:51 -0700 (PDT)
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
 <20250917210241.GD39973@ZenIV> <20250917214229.GF39973@ZenIV>
In-Reply-To: <20250917214229.GF39973@ZenIV>
From: Mateusz Guzik <mjguzik@gmail.com>
Date: Thu, 18 Sep 2025 00:58:39 +0200
X-Gm-Features: AS18NWA2xDDd90TP4hQffjy7fu0y29jV2cuqbrh0s-lIAc7yHea5fW1K7iRdEx8
Message-ID: <CAGudoHHzZ1DEEg2YHT4_+48-Y1gc7=uW_gOe3c0o6wsm7pWEXQ@mail.gmail.com>
Subject: Re: Need advice with iput() deadlock during writeback
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Max Kellermann <max.kellermann@ionos.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, 
	Linux Memory Management List <linux-mm@kvack.org>, ceph-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 17, 2025 at 11:42=E2=80=AFPM Al Viro <viro@zeniv.linux.org.uk> =
wrote:
>
> On Wed, Sep 17, 2025 at 10:02:41PM +0100, Al Viro wrote:
> > On Wed, Sep 17, 2025 at 10:39:22PM +0200, Mateusz Guzik wrote:
> >
> > > Linux has to have something of the sort for dentries, otherwise the
> > > current fput stuff would not be safe. I find it surprising to learn
> > > inodes are treated differently.
> >
> > If you are looking at vnode counterparts, dentries are closer to that.
> > Inodes are secondary.
> >
> > And no, it's not a "wait for references to go away" - every file holds
> > a _pair_ of references, one to mount and another to dentry.
> >
> > Additional references to mount =3D> umount() gets -EBUSY, lazy umount()
> > (with MNT_DETACH) gets the sucker removed from the mount tree, with
> > shutdown deferred (at least) until the last reference to mount goes awa=
y.
> >
> > Once the mount refcount hits zero and the damn thing gets taken apart,
> > an active reference to superblock (i.e. to filesystem instance) is
> > dropped.
> >
> > If that was not the last one (e.g. it's mounted elsewhere as well), we
> > are not waiting for anything.  If it *was* the last active ref, we
> > shut the filesystem instance down; that's _it_ - once you are into
> > ->kill_sb(), it's all over.
> >
> > Linux VFS is seriously different from Heidemann's-derived ones you'll f=
ind in
> > BSD land these days.  Different taxonomy of objects, among other things=
...
>
> FWIW, the basic overview of objects:
>
> super_block: filesystem instance.  Two refcounts (passive and active, hav=
ing
> positive active refcount counts as one passive reference).  Shutdown when
> active refcount gets to zero; freeing of in-core struct super_block - whe=
n
> passive gets there.
>
> mount: a subtree of an active filesystem.  Most of them are in mount tree=
(s),
> but they might exist on their own - e.g. pipefs one, etc.  Has a refcount=
,
> bears an active reference to fs instance (super_block) *and* a reference =
to
> a dentry belonging to that instance - root of the (sub)tree visible in
> it.  Shutdown when refcount hits zero.  Being in mount tree contributes
> to refcount; that contribution goes away when it's detached from the tree
> (on umount, normally).  Refcount is responsible for -EBUSY from non-lazy
> umount; lazy one (umount -l, umount2(path, MNT_DETACH)) dissolves the ent=
ire
> subtree that used to be mounted at that point and shuts down everything
> that had refcounts reach zero, leaving the rest until their refcounts dro=
p
> to zero too.  Shutdown drops the superblock and root dentry refs.
>
> inode & dentry: that's what vnodes map onto.  Dentry is the main object,
> inode is secondary.  Each belongs to a specific fs instance for the entir=
e
> lifetime.  Dentries form a forest; inodes are attached to some of them.
> Details are a lot more involved than anything that would fit into a short
> overview.  Both are refcounted, attaching dentry to an inode contributes
> 1 to inode's refcount.  Child dentry contributes 1 to refcount of parent.
> Shutdown does *not* happen until the dentry refcount hits zero; once it's
> zero, the normal policy is "keep it around if it's still hashed", but
> filesystem may say "no point keeping it".  Memory pressure =3D> kill the
> ones with zero refcount (and if their parents had been pinned only by
> those children, take the parents out as well, etc.).  Filesystem shutdown=
 =3D>
> kick out everything with zero refcount, complain if anything's left after
> that (shrink_dcache_for_umount() does it, so if filesystem kept anything
> pinned internally, it would better drop those before we get to that
> point).  evict_inodes() does the same to inodes.
>
> file: the usual; open IO channel, as on any Unix.  Carries a reference to
> dentry and to mount.  Shutdown happens when refcount goes to zero, normal=
ly
> delayed until return to userland, when we are on shallow stack and withou=
t
> any locks held.  Incidentally, sockets and pipes come with those as well =
-
> none of the "sockets don't have a vnode" headache.
>
> cwd (and process's root as well): a pair of mount and dentry references.

I groked most of it from my prior poking around, thanks for the write up th=
ough.

The real question though is how can a filesystem safely manage keeping
extra refs on inodes vs unmount. Per your explanation the usual safety
net does not apply. Frankly it makes igrab/iput sound very dangerous
in their own right.

