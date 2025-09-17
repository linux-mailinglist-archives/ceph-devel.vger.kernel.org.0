Return-Path: <ceph-devel+bounces-3636-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DE4BEB7F4C6
	for <lists+ceph-devel@lfdr.de>; Wed, 17 Sep 2025 15:30:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 097043A454A
	for <lists+ceph-devel@lfdr.de>; Wed, 17 Sep 2025 09:32:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4392528002B;
	Wed, 17 Sep 2025 09:32:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WJl2H+4c"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 533CA225390
	for <ceph-devel@vger.kernel.org>; Wed, 17 Sep 2025 09:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758101553; cv=none; b=TI2/AGJv4AHW4YZS1DV8a9/b+SMEETJRZH+FemrxbwiTtGMc5NZ86K32dvcClJbGT4wBBlK0gMhI9NsDBD4KItpr/eS9CNQKQfOv5leAvikh5MlYld3QlTQyUrn+Eg2PdE7wV94d4el1dF5vvTXGtNaPUzKXH2cGV6g7FWyuFdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758101553; c=relaxed/simple;
	bh=VxOCEoRa3tuc/zHwNQZMF/xzuiG4VLERClAESVG1Mu4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Vgk/lN1eA6wFo573kPBKWEpp9U7wQiMu5JdENnMdIlnPr3TsfLt+ZfuZpSTv98h2Aq+t3hwz2r8+4LVUA6pqrhTUvJDLQMHa2R8K3u5tRyW5B2DG4zmx5+Da4YubE9+G9jyc3Ok2sJ0+VjuuW6hO2+vjnBtr1SNWAovcc6oCEqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WJl2H+4c; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-afcb78ead12so924757166b.1
        for <ceph-devel@vger.kernel.org>; Wed, 17 Sep 2025 02:32:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758101550; x=1758706350; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E6Y38ok0A2SbvnTsYmSUxqDrhx49IHHabOYZyBDsP60=;
        b=WJl2H+4cfom/AOKVJ01IThlfaBu88VHa0f1r1CHu/sKb20Pgyxzvejfsd1guRq3k/v
         H64CX4m2GbwHTXUuMInEJSk3jWLVvYk48sBkCLc6KBDBQzGxR7PwCsJSokjoFNTuCRIk
         WnxG2ji7QIn6sJh1e/RHGqE844j6D3V90iqo/eRebQdE1pa/PYnwZRZYs5GLvIpDBPTg
         jPY4m/OCQ4PGmUynu5rAiYwFQoHsMOWnmbve528wVgFwHkdwHhcc/zvVVfI4e1wOGuRR
         mnaSpWBXJ5Cy9i8qpWLaxX0DFWnzZxbnSHW1p21NcCVGn5y8eQBZE1zp6qoV02xxnow+
         0/ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758101550; x=1758706350;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=E6Y38ok0A2SbvnTsYmSUxqDrhx49IHHabOYZyBDsP60=;
        b=rOsq8rJ0uDX8Vm/lhGLvdHQpH+BvPjhcOEWllifcaKvgRZZ23Wc+TubRKLNshxdHSn
         g5lIwZoCxT+2YBDd+EVXVfxGMze8GD8zNvXOH23BKrE5YLjlmi63FdRkJZvyT3c8l4IH
         Z+KAFphanPILlMIvsjrDfqfhIbRJvMLcF7qbuBe6M6oN+O+//xWudtunBHmxLwG39UJn
         h+Z0AguJELPh9gIDJScVPRRntTgGljxSf1AorJy4FA6boMh3zeYe/+C7UvcPLvuLcPls
         qAS2lfIw8/dPtu1Jk/mSwfg2YRzymmJk9EHAN/SyIS0AZX8Kzbzq2PFCEMqyA1Eg4QHx
         m4GA==
X-Forwarded-Encrypted: i=1; AJvYcCXoc8gmxWPQ5QbxvHI5MWj7pzIBsRIj5SU5uOlRoV3ROP1b3pl+WC1wF9/PTI1fSD6rKLZ5gP4Bvrod@vger.kernel.org
X-Gm-Message-State: AOJu0YynEcPGPXvjQ1uv+P/V8A13NHDqbQztm6rGhx1qYQV5Ghn768vT
	4gi+KcDP8bSJOPY5C0VHGo+mIJRK7QHZ1Nt9BvH3LvIWg/E/hJSsSrxmlmwuLpVv1Mv4lz7JK1y
	IQvCM4SbLXNzWxJS2BQ5MBPiCyV6+zawRXAHW
X-Gm-Gg: ASbGncu7/HkSGVYYNpelnJ3XxodCFs+K4fNAvJY1Dpmut6bn0TZcWgjkWYBioJttnGd
	8+Cs5I+eWKfWfJiaTSNtGm2Bz7OJ5tDV0nJtl40njeVJHxL5nYg0expuuDFEhlXXHvrnLtnuSsX
	O7Mh/b2ebYw/EBbzy2jVK8MibZ5xi+Wva3sh1Y4MpjQrMbh5duAYjmmPktrYygIPRMFOcjNJ8Ke
	0MHtyV0GkuV8HKTIoMiy7d+Di2doPxDXsY1HXM=
X-Google-Smtp-Source: AGHT+IHZ61/20jk8xhbdyrEPlURkGzCcG7PoE5PC5oyd/JsxSNese3df+9o8L4SYyy0q9/Yanutk8Dmi6yRoW8WpYyg=
X-Received: by 2002:a17:907:2d1f:b0:b07:653d:56a8 with SMTP id
 a640c23a62f3a-b1bb086da5amr172521666b.5.1758101549373; Wed, 17 Sep 2025
 02:32:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAKPOu+-QRTC_j15=Cc4YeU3TAcpQCrFWmBZcNxfnw1LndVzASg@mail.gmail.com>
 <4z3imll6zbzwqcyfl225xn3rc4mev6ppjnx5itmvznj2yormug@utk6twdablj3>
 <CAKPOu+--m8eppmF5+fofG=AKAMu5K_meF44UH4XiL8V3_X_rJg@mail.gmail.com>
 <CAGudoHEqNYWMqDiogc9Q_s9QMQHB6Rm_1dUzcC7B0GFBrqS=1g@mail.gmail.com> <CAKPOu+_B=0G-csXEw2OshD6ZJm0+Ex9dRNf6bHpVuQFgBB7-Zw@mail.gmail.com>
In-Reply-To: <CAKPOu+_B=0G-csXEw2OshD6ZJm0+Ex9dRNf6bHpVuQFgBB7-Zw@mail.gmail.com>
From: Mateusz Guzik <mjguzik@gmail.com>
Date: Wed, 17 Sep 2025 11:32:16 +0200
X-Gm-Features: AS18NWChZehX_GB5YyUMrAb6NwperYSiuZ6bfFJLrhovC7_ZskfwcSsI8-Tvro0
Message-ID: <CAGudoHFNKkjjqR=JYQdFZ2cBgSnBsSnzX6njwDtmj40ZDxJ+jg@mail.gmail.com>
Subject: Re: Need advice with iput() deadlock during writeback
To: Max Kellermann <max.kellermann@ionos.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, 
	Linux Memory Management List <linux-mm@kvack.org>, ceph-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 17, 2025 at 11:20=E2=80=AFAM Max Kellermann
<max.kellermann@ionos.com> wrote:
>
> On Wed, Sep 17, 2025 at 10:59=E2=80=AFAM Mateusz Guzik <mjguzik@gmail.com=
> wrote:
> > > My idea was something like iput_safe() and that function would defer
> > > the actual iput() call if the reference counter is 1 (i.e. the caller
> > > is holding the last reference).
> > >
> >
> > That's the same as my proposal.
>
> The real difference (aside from naming) is that I wanted to change
> only callers in unsafe contexts to the new function. But I guess most
> people calling iput() are not aware of its dangers and if we look
> closer, more existing bugs may be revealed.
>

I noted iput() handling this is a possibility, but also that it would
be best avoided.

We are in agreement here mate.

> > Note  that vast majority of real-world calls to iput already come with
> > a count of 1, but it may be this is not true for ceph.
>
> Not my experience - I traced iput() and found that this was very rare
> - because the dcache is almost always holding a reference and inodes
> are only ever evicted if the dcache decides to drop them.
>

Most of the calls I had seen are from dcache. ;-)

> > I suspect the best short-term fix is to implement ceph-private async
> > iput with linkage coming from struct ceph_inode_info or whatever other
> > struct applicable.
>
> I had already started writing exactly this, very similar to your
> sketch. That's what I'm going to finish now - and it will produce a
> patch that will hopefully be appropriate for a stable backport. This
> Ceph deadlock bug appears to affect all Linux versions.
>

Sounds like a plan. After the inode_state_ accessor thing is sorted
out I'll add the diagnostics to catch unsafe iput() use.

So I had a look at inode layout with pahole and there is a pluggable
8-byte hole in it.

llist takes 8 bytes, so it can just fit right in without growing the
struct above what it is now.

Unfortunately task_work is 16 bytes, so embedding that sucker would
grow the struct but that's perhaps tolerable. Not my call.

If making sure to postpone the last unref there is no way to union
this with anything that I can see as the inode must remain safe to use
-- someone could have picked it up.

Maybe something could be figured out if iput_async already unrefs, but
this would require fuckery with flags to make sure nobody messes with
the inode.

> >         if (likely(!in_interrupt() && !(task->flags & PF_KTHREAD))) {
> >                 init_task_work(&ci->async_task_work, __ceph_iput_async)=
;
> >                 if (!task_work_add(task, &ci->async_task_work, TWA_RESU=
ME))
> >                         return;
> >         }
>
> This part isn't useful for inodes, is it? I suppose this code exists
> in fput() only to guarantee that all file handles are really closed
> before returning to userspace, right? And we don't need that for
> inodes?
>

No, the fput thing is to avoid a problem of a similar nature. As
*final* fput can start taking arbitrary locks, go to sleep or use a
lot of stack, it is woefully unsafe to be called from arbitrary
places. The current machinery guarantees anything other than an atomic
decrement is postponed to syscall boundary or a task queue if the
former is not possible so that these are not a factor.

Postponing to syscall boundary as opposed to blindly queueing up makes
the "right" thread do the work.

