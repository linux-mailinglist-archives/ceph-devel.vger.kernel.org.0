Return-Path: <ceph-devel+bounces-4252-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 856A5CF5A7E
	for <lists+ceph-devel@lfdr.de>; Mon, 05 Jan 2026 22:23:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9024130F2B85
	for <lists+ceph-devel@lfdr.de>; Mon,  5 Jan 2026 21:19:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE6E82DEA74;
	Mon,  5 Jan 2026 21:19:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZoPnV0G2"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 156C0280A52
	for <ceph-devel@vger.kernel.org>; Mon,  5 Jan 2026 21:19:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767647951; cv=none; b=rVqphBcLrjoGAIpdakHf30rgsr3fov8yuX/Yskqsn6iCDHtcxHd3zSKqjs8y/ETn4GBpSuMy01G6DBa3ys1oW6BS9e0JDoT01TTNLkjG7rPA21hVoM8jy9vnBPCR/1y/kZpO2q/v9pIN30E8AL/mbbKsw6DuVINrFIw68jMZV34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767647951; c=relaxed/simple;
	bh=j+Zl+WKqGh+1pyKe/m5/Zv9hA4Kxl5M+vfVqNhcnxBg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BzP3lPZRCiJl1b0A8fy5IfqM0JCiH64gl4DPbqWVQ2Eh5CM2DZKxn2cmoiCKDKv0KyPcJxKZQRhATsQ92BVrEAP1SF259mw6Fs/8f952wJemJIKodoGybDzDYMwuYYLpD/igqllGfIuUuu7llFDtzwJhBnrRSFhSPncz+JoxmTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZoPnV0G2; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2a0c20ee83dso3884205ad.2
        for <ceph-devel@vger.kernel.org>; Mon, 05 Jan 2026 13:19:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767647949; x=1768252749; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q+xWpCVbFcUIAos4hCcZSIieLsT8DT4Il6EiPgrSIxc=;
        b=ZoPnV0G23A5IolILI7zB2B0nMyK7+434eXwJhwkrXa6/tANRiwnbGZ6TyfUc8Gw9eD
         z1lw0ujHFjK/07DjTqXnogNWeq6j7EIZkJEsDC6S2MF6zEVxrc7m99ox263DqlfGUXti
         adYkDIRT2xM++CDofj47bI5QAfyTllOaxDH/cq1jKjU8P2Jbob+AKQ/HwDuqDgtTlsNn
         nYZ3HWb+qDRHUQyH+aGb87nys+4FWyI2JTyfQ5ZQCt7n/CyY9kPHoMEaaX5HQ7+9GxnJ
         HI54n4Vo8yT6/29Ze0yjjlfUj0P75ccyY+TsftqhVtdd6gu2BhO8ObWgqdAbvnmY50Hp
         126g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767647949; x=1768252749;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Q+xWpCVbFcUIAos4hCcZSIieLsT8DT4Il6EiPgrSIxc=;
        b=RIUo3aP7OybQE3SKzthrP7e/D3r7e/zfRt/4StjMAIBvqi35viv4t54X+dqtdxnqy2
         enF4pHlY92x/Bis1KUYinGJsEoISvRu7QooLt0uGdptCMYThibQ1KVm3vVvGM2yOQBa0
         eKvLgzcCfh3+BnAbvXTFKMXVdKHGLTUY7u5lswKyM8fuVE1O3vXxy0YwNozb7a1wSp+8
         IR7+rz3UVGIAQyfiiEneETmCSDC+kHbDrXCwh88j7J7f5D9ExtoHo28FlQKa/aFj3Jtm
         Xf2wewi6TYBtscI6YzUwDe2amkA8wXKMXCg0CpcReUYFjbQP7UF0x4hsHXtZt7t0KeoT
         zYFw==
X-Forwarded-Encrypted: i=1; AJvYcCUz1+ApiW+nGoCNn7W3OmqcEQGi8Y2nPm/JeMXq3ccevX6lxItYDXaKRHIh7oa7a0XNW0rIjMuYJXdm@vger.kernel.org
X-Gm-Message-State: AOJu0Yys6Rz0ccwtv7QseR4/rL4jn5dfgFLHv2reY9PM7SCCslBAttkn
	jjKV6kOtEz6OaL3IKbCAM9qKo5IHqH8SaTO+d3ktM7YvQhqEsPEIRkpXlKsky7acHCduelI6kWV
	H98gpXTnu6+EooL9uXn382eWdgLVCobM=
X-Gm-Gg: AY/fxX7H8RuOfHtZKNKXDLgqordlkzkUOfYvvK5ELAJ1Ty36qfr+MBS2IpcBt1aYggi
	QCn+9f92Lw/2Ycs9vZO9p0ka5xBelg70iUQchBjgYTtg7T3w788oS1sU2SDogHcOl0tVRs8dm2x
	3eAMpac/wyltRbI7KzsGw97WOJwKi2U0ILEIy0ylTR4tRgEP0mgKPuUsqnoh3VwDvCGvzYL72il
	5v9GjH8x1K6CG3QaXUiZe0gpTjF0YXQ30eU0eU6occAPVaap5zp91x7DgGZQkcgGZk2t0QJgj92
	90gK+A==
X-Google-Smtp-Source: AGHT+IEnV0Pd+oCC1C+p1z3dFnQJ4he51jvTEQ4hp8yUaH9cYps7VBIQxy/j6i/THCFYA60/2CXF0u2BGdkHWpzVIaM=
X-Received: by 2002:a05:7022:e998:b0:11b:40b3:c621 with SMTP id
 a92af1059eb24-121f18ea3e8mr698721c88.24.1767647949303; Mon, 05 Jan 2026
 13:19:09 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <36681e9d-fde6-4c5d-bf35-db9d85865900@tu-ilmenau.de>
 <CAOi1vP_8MXfbM=dncfNXvPXvUO2dXr-9rj1YVEMYPLjj-Ox4ng@mail.gmail.com> <52cefbfb-97bc-4a83-939d-1a832205df10@tu-ilmenau.de>
In-Reply-To: <52cefbfb-97bc-4a83-939d-1a832205df10@tu-ilmenau.de>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Mon, 5 Jan 2026 22:18:56 +0100
X-Gm-Features: AQt7F2qJSTUEbhzX4tDE2ok396-mHH_0IZ20PKah-m_IleSl1-ugngcrS-LTIbw
Message-ID: <CAOi1vP_ZRx76jpLXrRN18dBbrZP=XjsyaYLG2K6F-HKttQHtNQ@mail.gmail.com>
Subject: Re: [bug report] rbd unmap hangs after pausing and unpausing I/O
To: Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>
Cc: Xiubo Li <xiubli@redhat.com>, ceph-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 10, 2025 at 9:29=E2=80=AFAM Raphael Zimmer
<raphael.zimmer@tu-ilmenau.de> wrote:
>
>
>
> On 23.09.25 20:33, Ilya Dryomov wrote:
> > On Tue, Sep 23, 2025 at 12:38=E2=80=AFPM Raphael Zimmer
> > <raphael.zimmer@tu-ilmenau.de> wrote:
> >>
> >> Hello,
> >>
> >> I encountered an error with the kernel Ceph client (specifically using
> >> an RBD device) when pausing I/O on the cluster by setting and unsettin=
g
> >> pauserd and pausewr flags. An error was seen with two different setups=
,
> >> which I believe is due to the same problem.
> >
> > Hi Raphael,
> >
> > What is your use case for applying pauserd and pausewr?  I'm curious
> > because it's not something that I have seen used in normal operation
> > and most Ceph users probably aren't even aware of these flags.
> >
> >>
> >> 1) When pausing and later unpausing I/O on the cluster, everything see=
ms
> >> to work as expected until trying to unmap an RBD device from the kerne=
l.
> >> In this case, the rbd unmap command hangs and also can't be killed. To
> >> get back to a normally working state, a system reboot is needed. This
> >> behavior was observed on different systems (Debian 12 and 13) and coul=
d
> >> also be reproduced with an installation of the mainline kernel (v6.17-=
rc6).
> >>
> >> Steps to reproduce:
> >> - Connect kernel client to RBD device (rbd map)
> >> - Pause I/O on cluster (ceph osd pause)
> >> - Wait some time (3 minutes should be enough)
> >> - Unpause I/O on cluster
> >> - Try to unmap RBD device on client
> >>
> >>
> >> 2) When using an application that internally uses the kernel Ceph clie=
nt
> >> code, I observed the following behavior:
> >>
> >> Pausing I/O leads to a watch error after some time (same as with faili=
ng
> >> OSDs or e.g. when pool quota is reached). In rbd_watch_errcb
> >> (drivers/block/rbd.c), the watch_dwork gets scheduled, which leads to =
a
> >> call of rbd_reregister_watch -> __rbd_register_watch -> ceph_osdc_watc=
h
> >> (net/ceph/osd_client.c) -> linger_reg_commit_wait ->
> >> wait_for_completion_killable. At this point, it waits without any
> >> timeout for the completion. The normal behavior is to wait until the
> >> causing condition is resolved and then return. With pausing and
> >> unpausing I/O, wait_for_completion_killable does not return even after
> >> unpausing because no call to complete or complete_all happens. I would
> >> guess that on unpausing some call is missing so that committing the
> >> linger request never completes.
> >>
> >>   From what I am seeing, it seems like this missing completion in the
> >> second case is also the cause of the hanging rbd unmap with the
> >> unmodified kernel.
> >
> > You are pretty close ;)  The completion is indeed missing, but it's
> > more of a side effect than the root cause.  The root cause is that the
> > watch request doesn't get resubmitted on paused -> unpaused transitions
> > like it happens on e.g. full -> no-longer-full transitions -- the logic
> > around forming need_resend_linger list isn't quite right.  I'll try to
> > put together a fix in the coming days.
> >
> > Thanks,
> >
> >                  Ilya
>
> Hi Ilya,
> I haven't heard anything about this issue for quite a while. Have you
> made any progress with the fix you wanted to put together by now? Or can
> you estimate when a fix will be ready?

Hi Raphael,

Sorry, it's a small fix but it has fallen through the cracks.  I'll
send the patch to ceph-devel with you CCed in a few.

Thanks,

                Ilya

