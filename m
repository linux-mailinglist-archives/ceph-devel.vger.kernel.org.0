Return-Path: <ceph-devel+bounces-3657-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7EB23B81BF0
	for <lists+ceph-devel@lfdr.de>; Wed, 17 Sep 2025 22:23:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 00E771C26533
	for <lists+ceph-devel@lfdr.de>; Wed, 17 Sep 2025 20:23:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8857429BDBC;
	Wed, 17 Sep 2025 20:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dT/ZGqXP"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0A9B28504D
	for <ceph-devel@vger.kernel.org>; Wed, 17 Sep 2025 20:23:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758140596; cv=none; b=mGJ03dU9k2PjHY2Xyh1Jwb8ghBezdzzbTfayNo+nrMH1Os3Jywvx0G5VgzBrCmTfygP6XTXlEje5aMJbdwBOf5/zaHMv6O7K+gcb20VHeQ4F4DDRVRETJKyKe01gsw54UGfeqlYhGWRX1KXIxObFaoAx3tabwaVwlq6KyZcPFLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758140596; c=relaxed/simple;
	bh=/DINvktItkrVyCy+/DbG63bv8UKOnSJsd6RXd7PJOtI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AihZcrBwkgakFqlZw7ebZvv7gd5O4RgoBLdz2rBaUZI5+r9GJQttLaeuiboqfY/VU5o5jvmFGDsL9iXQ43pmatMHhXLRMwaKqzwRylyKQp9KndN2CGdsemVDM3kd3fPqQUtsEXjO1ZX8HEeWhSuBy5tWYG5zyn16e+bzwr08ncA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dT/ZGqXP; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-62f1987d446so246656a12.0
        for <ceph-devel@vger.kernel.org>; Wed, 17 Sep 2025 13:23:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758140593; x=1758745393; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FQYyUFKyIMwcbN0Oi1nix7mefhyosUBnMaKUMp/0Uhw=;
        b=dT/ZGqXPjLWFjfXucdmAD0qFEjYXdHvRPPoNhNh8PBFANRa2dHcAoOKvVxKCJYbHzC
         u12e8b3Rqi5T+a5MAEY5cUqkIT8CQMu1gDRFVxjw+TVp+fVS6oJ6eIIX6MZst7x+e6dD
         YKe7JXIt8UyYINQ4yyg9xGTTzqGSE7ovCOZM21dInfPxjWqQqcSrJ7JgUtw0+e/vsNiJ
         0+Ok5tnWr8Zf3AzyvehyU0rRIgIH0gq3SK7LAQs5y32tmePUaDnx87PKmgZBtX6QXZPb
         3pYGO4617bfzw7EVxQal9Hz2jhr1Z40WqYhYGtHzRgi4cOdrKOjjPDx2qAVdxA5ZdF9p
         D9tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758140593; x=1758745393;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FQYyUFKyIMwcbN0Oi1nix7mefhyosUBnMaKUMp/0Uhw=;
        b=b7gGlIVKe+aqXRygKegV5ELa+bGVcDvDKNsK9RiOUG51ceI9sq4oGp9ug8UatOmfR0
         afoxXncl5mqaoD1Ca2LZNSeDoJedtIKvJmgDBmLgVzATBpkH/PMXsCi0CCbKRBBKX1TL
         aXuRvlffxYA04l3Vrin5RDUUtttATKxdnZ73mKFE0GliydPc/4AFSJQrI6jJMEQGkOV7
         a6Ttd9G8DvLKLAWXiFuXZZxS0xMoNTrAoqCX6xF8no3+XkeuLLZOVhX90ybfufd0HW7U
         S2vpDs9gXou6XCC/YqPyFBTn22HVo/SgKM8sDf4gE7KwEY3WYaWAmBw+h+Q+ZNwVnC/W
         S++A==
X-Forwarded-Encrypted: i=1; AJvYcCWm2TQkpF3g9j65MuWWHa0jNLeBw6G+HsIESaduYAYD8mYHm8H8EXMzVRJO2pFfmfoFKe2GzKnjdLN2@vger.kernel.org
X-Gm-Message-State: AOJu0Ywcinrjz4hHoKKZqMzp2W/vyCqCG4khuUD8c/WgBs8olxusECSd
	DKw1yANj2FW09ZUmY6pYQnQxbWUqR28Q/ikQQs0Yb5kkYrUROuJdCM0ceu1icuj1AS0aAgQbsFo
	PKoy9753vHoyspvcMO6UrL1Qxx50tZbVVaQod
X-Gm-Gg: ASbGncvWucFveLF0x0I+vAaqKK2Ml2oOVHvQgDnEAdaV5Cuyr0xybQ4adtp4xwPI1pn
	+C3//NqemIVDgn2l6fXrMvAkzCKJ9zEWQUyjoB5E/T3vpYb+/LacbWOgKYrfitA8+0teFQt7fdt
	e4fV/zIzzLiO7hc4dlewtzu9xkyIIxVLPbAaVxKlmvBvo45EA0+fruHUa2iOWh1Ta3WanBK3Uei
	9H+tqnLfmJohkyfmJhQwR5FthjeGEkOLVBVPzHuKhbsRZWPs72yh52CgxheN/cBpnU3
X-Google-Smtp-Source: AGHT+IGbnxJUuKMIoax9837vUOwFa3uC5z5C8iuy02lVnujR8xNtpFbaO7bRafNJUiDUa0Pb4Cm8O1H0fKv6jLIS6Z0=
X-Received: by 2002:a05:6402:23cc:b0:61d:2096:1e92 with SMTP id
 4fb4d7f45d1cf-62f842255b5mr3411840a12.15.1758140592771; Wed, 17 Sep 2025
 13:23:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAKPOu+-QRTC_j15=Cc4YeU3TAcpQCrFWmBZcNxfnw1LndVzASg@mail.gmail.com>
 <4z3imll6zbzwqcyfl225xn3rc4mev6ppjnx5itmvznj2yormug@utk6twdablj3>
 <CAKPOu+--m8eppmF5+fofG=AKAMu5K_meF44UH4XiL8V3_X_rJg@mail.gmail.com>
 <CAGudoHEqNYWMqDiogc9Q_s9QMQHB6Rm_1dUzcC7B0GFBrqS=1g@mail.gmail.com> <20250917201408.GX39973@ZenIV>
In-Reply-To: <20250917201408.GX39973@ZenIV>
From: Mateusz Guzik <mjguzik@gmail.com>
Date: Wed, 17 Sep 2025 22:23:00 +0200
X-Gm-Features: AS18NWAwEK0xFf7I_pMfTz6YWIzdztaknH-Q6eCKdbOqKCEVDU2t6psEcsI1304
Message-ID: <CAGudoHFEE4nS_cWuc3xjmP=OaQSXMCg0eBrKCBHc3tf104er3A@mail.gmail.com>
Subject: Re: Need advice with iput() deadlock during writeback
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Max Kellermann <max.kellermann@ionos.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, 
	Linux Memory Management List <linux-mm@kvack.org>, ceph-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 17, 2025 at 10:14=E2=80=AFPM Al Viro <viro@zeniv.linux.org.uk> =
wrote:
>
> On Wed, Sep 17, 2025 at 10:59:23AM +0200, Mateusz Guzik wrote:
>
> > A sketch, incomplete:
> > static DECLARE_DELAYED_WORK(delayed_ceph_iput_work, delayed_ceph_iput);
> >
> > static void __ceph_iput_async(struct callback_head *work)
> > {
> >         struct ceph_inode_info *ci =3D container_of(work, struct
> > ceph_inode_info, async_task_work);
> >         iput(&ci->netfs.inode);
> > }
> >
> > void ceph_iput_async(struct ceph_inode_info *ci)
> > {
> >         struct inode *inode =3D &ci->netfs.inode;
> >
> >         if (atomic_add_unless(&inode->i_count, -1, 1))
> >                 return;
> >
> >         if (likely(!in_interrupt() && !(task->flags & PF_KTHREAD))) {
> >                 init_task_work(&ci->async_task_work, __ceph_iput_async)=
;
> >                 if (!task_work_add(task, &ci->async_task_work, TWA_RESU=
ME))
> >                         return;
> >         }
> >
> >         if (llist_add(&ci->async_llist, &delayed_ceph_iput_list))
> >                 schedule_delayed_work(&delayed_ceph_iput_work, 1);
> > }
>
> Looks rather dangerous - what do you do on fs shutdown?

Can you elaborate?

This should be equivalent to some random piece of code holding onto a
reference for a time.

I would expect whatever unmount/other teardown would proceed after it
gets rid of it.

Although for the queue at hand something can force flush it.

