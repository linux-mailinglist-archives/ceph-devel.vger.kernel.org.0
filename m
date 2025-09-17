Return-Path: <ceph-devel+bounces-3635-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A919B7EE62
	for <lists+ceph-devel@lfdr.de>; Wed, 17 Sep 2025 15:05:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CB0991891A46
	for <lists+ceph-devel@lfdr.de>; Wed, 17 Sep 2025 09:21:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 943C32E9EDD;
	Wed, 17 Sep 2025 09:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="d52FgUFz"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35D912D879A
	for <ceph-devel@vger.kernel.org>; Wed, 17 Sep 2025 09:20:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758100848; cv=none; b=Qb4Zg3fKaBFot1S4TlyMiDzGxbwNYncZS9yN0A6nwb5e8oKOvdc9gSvShjOvqYSh+ErAE+7TmwGxXQnvDglwlm+g0kzMetBsv1ece4cAG0Rkd5884lVSyZzup6xZOUdkQqqeJ6YA210JBzjN2RO1ulUEhw4SmFN94kbEaRV3HeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758100848; c=relaxed/simple;
	bh=tbSJkIij2c0zcGKXfLRJg+LHmV+4oS0vVsJc36lMj/4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=S3rrr7FPa+excRCrojE44DRPp0LxAw4ceVm2F1GOb6QKGmuEl9uNvH/WI2MuJaxSSdUduEqfUBWegF23u9qKb37GqJ5mOQkXzhDmlrfFV6TBhOLBFmitU68Eo/SOOnfH38xJPxJN6sJYykl02PT1+GzNaPgMXwCSWBdgi4kRAZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=d52FgUFz; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-b0415e03e25so816704766b.0
        for <ceph-devel@vger.kernel.org>; Wed, 17 Sep 2025 02:20:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1758100844; x=1758705644; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Mfy72Mb7ZknB0z0xXbtqc/r/yzrvqlFzmLASJN5p7Tc=;
        b=d52FgUFztRr/4cxBj/gphtly4pye/j68ubyHKwV5Mqr7Q8QWzQMTrPt7cflhYtY+Gc
         nptEPaWNdMSQtYm+XFi6oDXK1+1gQAMbaG/iuAhEFEh8gcaNET8uQ60MJ7qXnfdhLBal
         /hi7YAi2NNwQ6vbIjl8kFhjilXCIjTLVnNy2cwiw+brRpWQJfJsvuh19BENxV09dTOJu
         UIlwHIm2abEYfAWxx6YtTKB9QcC+RCv5ZhXMXSbjXt22TvP5kUNOfIT5mkzMEB2B7ZZ3
         +UCHT3nvFHNyuMXc+/I/UcAvCdQz+Ne0dZVBbqsM2hky/NTeBQ20fRJY1Tk8I3Tzd4VN
         7XUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758100844; x=1758705644;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Mfy72Mb7ZknB0z0xXbtqc/r/yzrvqlFzmLASJN5p7Tc=;
        b=JEIQIgSGnsxxn4KBZZ/OliXoLJv9OL5RyAS0s0D3z3lwz/N8zkXGMXPhFVFbpHHJDp
         Lna5U6aUhgwoZaKJGS3eApyoh4aFRm+bNYcAb1QRsCD7U4YjHflaUE0YtGh9bC2KQogz
         ysDxyGEFEVGl2KRQSonELol+MTvxaLovUz+aLpsU8QNeWjeOnh+TPc0kTP2oP7OFsV6v
         eiKq5SSheOqc1X6dBQImf71eyrSW/2d8zAz6Bv2tbFy/G+ZFAQbyd4iCkwK+9FV/Egl/
         jo+hkJIutXiJrDY8RhO4h57e4DombNcNEbZCDOMrCg1rtK5fbzCP0KfxMdrFE3L5618W
         CssQ==
X-Forwarded-Encrypted: i=1; AJvYcCUfhVjRqVA3S2v0+UN05lcQ09tfWriiLNaNHWbz9xDALSTPv1lhn2AP95goFRlnua3FshDb2l2BUN01@vger.kernel.org
X-Gm-Message-State: AOJu0Yytey33Fu5Eb9uHtDFHAAYyV7AraaJSN1HFYeLTrsqjX7fgvU8t
	GO38W5SzoOEzNcq/nznX+8dyWlnHUE9465BNU5k1Y/prw8z7vg2mWfH8VmN7bA/YYaoHK3l8N2m
	HlrFHh+WeS7TNF/EmCNLvhpb1gSgpyjMK9rIZIZnMzw==
X-Gm-Gg: ASbGncuSSGfJiXCUS8M0s8tsPBMGhg+9suTIrWEDlIsdOX6t/2lInBqNscuh8CCzvhm
	uTlD/NdV3OO9hjE9EBnv0UkKrnbxzgThbpMi7dmEmFJAcEgo1n5Et2QImH1/W1ljYMM2SPPvKR3
	yQ9hmK66Ov246vHefSlSjqJxmiPr3ds3p+zKlRP7ZtTIdJglsi83x8Y0QUpT2KU8zYs74XRgSFm
	3ShEoKh60+9l8c5tP4PHzp6ZGt+Kk51396yCegWyErbfRk=
X-Google-Smtp-Source: AGHT+IEuwtAHMUHjO1x3ENSlxdOmbju+xnSnCyHh4cRztllkF7bNH5RwzXT8gyIuvTUrZr4/rmjjgYdEHERK/tIiwXE=
X-Received: by 2002:a17:907:94c3:b0:b14:53a0:5c61 with SMTP id
 a640c23a62f3a-b1bb4337342mr176847366b.12.1758100844320; Wed, 17 Sep 2025
 02:20:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAKPOu+-QRTC_j15=Cc4YeU3TAcpQCrFWmBZcNxfnw1LndVzASg@mail.gmail.com>
 <4z3imll6zbzwqcyfl225xn3rc4mev6ppjnx5itmvznj2yormug@utk6twdablj3>
 <CAKPOu+--m8eppmF5+fofG=AKAMu5K_meF44UH4XiL8V3_X_rJg@mail.gmail.com> <CAGudoHEqNYWMqDiogc9Q_s9QMQHB6Rm_1dUzcC7B0GFBrqS=1g@mail.gmail.com>
In-Reply-To: <CAGudoHEqNYWMqDiogc9Q_s9QMQHB6Rm_1dUzcC7B0GFBrqS=1g@mail.gmail.com>
From: Max Kellermann <max.kellermann@ionos.com>
Date: Wed, 17 Sep 2025 11:20:33 +0200
X-Gm-Features: AS18NWB7XvnaQ-WcvFZZGW6kOLpaf69Y5rLJa_6Q1pxrO9zJ4eZ1OfMv2xVqu3c
Message-ID: <CAKPOu+_B=0G-csXEw2OshD6ZJm0+Ex9dRNf6bHpVuQFgBB7-Zw@mail.gmail.com>
Subject: Re: Need advice with iput() deadlock during writeback
To: Mateusz Guzik <mjguzik@gmail.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, 
	Linux Memory Management List <linux-mm@kvack.org>, ceph-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 17, 2025 at 10:59=E2=80=AFAM Mateusz Guzik <mjguzik@gmail.com> =
wrote:
> There happens to be a temporarily inactive discussion related to it, see:
> https://lore.kernel.org/linux-fsdevel/cover.1756222464.git.josef@toxicpan=
da.com/
>
> but also the followup:
> https://lore.kernel.org/linux-fsdevel/eeu47pjcaxkfol2o2bltigfjvrz6eecdjwt=
ilnmnprqh7dhdn7@rqi35ya5ilmv/
>
> The patchset posted there retains inode_wait_for_writeback().

That is indeed a very interesting thread tackling a very similar
problem. I guess I can learn a bit from the discussion.

> > My idea was something like iput_safe() and that function would defer
> > the actual iput() call if the reference counter is 1 (i.e. the caller
> > is holding the last reference).
> >
>
> That's the same as my proposal.

The real difference (aside from naming) is that I wanted to change
only callers in unsafe contexts to the new function. But I guess most
people calling iput() are not aware of its dangers and if we look
closer, more existing bugs may be revealed.

For example, the Ceph bugs only occur under memory pressure (via
memcg) - only when the dcache happens to be flushed and the process
doing the writes had already exited, thus nobody else was still
holding a reference to the inode. These are rare circumstances for
normal people, but on our servers, that happens all the time.

> Note  that vast majority of real-world calls to iput already come with
> a count of 1, but it may be this is not true for ceph.

Not my experience - I traced iput() and found that this was very rare
- because the dcache is almost always holding a reference and inodes
are only ever evicted if the dcache decides to drop them.

> I suspect the best short-term fix is to implement ceph-private async
> iput with linkage coming from struct ceph_inode_info or whatever other
> struct applicable.

I had already started writing exactly this, very similar to your
sketch. That's what I'm going to finish now - and it will produce a
patch that will hopefully be appropriate for a stable backport. This
Ceph deadlock bug appears to affect all Linux versions.

>         if (likely(!in_interrupt() && !(task->flags & PF_KTHREAD))) {
>                 init_task_work(&ci->async_task_work, __ceph_iput_async);
>                 if (!task_work_add(task, &ci->async_task_work, TWA_RESUME=
))
>                         return;
>         }

This part isn't useful for inodes, is it? I suppose this code exists
in fput() only to guarantee that all file handles are really closed
before returning to userspace, right? And we don't need that for
inodes?

Thanks for your helpful advice, Mateusz!

Max

