Return-Path: <ceph-devel+bounces-3644-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0AAC4B7F862
	for <lists+ceph-devel@lfdr.de>; Wed, 17 Sep 2025 15:47:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6B1861892656
	for <lists+ceph-devel@lfdr.de>; Wed, 17 Sep 2025 13:42:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9817E31A7E6;
	Wed, 17 Sep 2025 13:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="WMHj4Kqu"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EA172EAB89
	for <ceph-devel@vger.kernel.org>; Wed, 17 Sep 2025 13:39:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758116394; cv=none; b=QaMsjDL+czl2c7bSBPk+m7YVptZ/Thlzh2U3CgdluVJEjI0bYixMj6wxh7YrprgoJMjePEH0d8hOtWP0M/nz7VgL+YaDnC7a7m24z/NWEAQuYMtkIT8nZh5k2jzRr0boRcivnbO968xlRW2wAT3x4bT3Rbeqotsq3b569Htw900=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758116394; c=relaxed/simple;
	bh=CBeHfXnYYlNYf7/y5kYqb3+gL7o7P/FRLBOn34fqRSY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=m3cYwFmVHaM7W/eHSlCDqUOuryMBsMNu2tohazQLanVMOELr3Oz10aUmAX8OF+cbAmiENRUCq22aOLyyEnzlGwUKYbGTE4wjwY1iQl+x0eT9I8EdrpPIpd0YW6D2IrRqBo2EYEW3pDu9zZk1N+EUtS5TpDXwC13u8O2DCJMkeCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=WMHj4Kqu; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-b149efbed4eso372847166b.1
        for <ceph-devel@vger.kernel.org>; Wed, 17 Sep 2025 06:39:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1758116391; x=1758721191; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CBeHfXnYYlNYf7/y5kYqb3+gL7o7P/FRLBOn34fqRSY=;
        b=WMHj4Kquf++/0XnW5YC9J7arXXohiQsxOYLXNSGWpEwSWxTZm3dA5ZfkRVvmrPMpxi
         OaHNNUiU4DJvvGYMqtj53GtqsEV5o90ZkfVzhh2J9olnk2AQ+nDUI6VtPii+JHT7an7z
         FU3Htq5MZlkeX878lHh43KqdqgUfAJnF+Z8Ilrin+oHGViB4Nd1nVMIFBDrW/NuJ6QWH
         /Kd1FroK9Ehdh4d+d5qQvKMxMf1ENpFNyqs65ZY8uGYv7JL299Lu0Idi5w1pLZibh22J
         vSijhuR40zd05xAkZdOiKk+Kp8Mp0cBX7F0nY3+Q6m1mJGHDDMbIlLLr/NOi6dOxm2ht
         6btg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758116391; x=1758721191;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CBeHfXnYYlNYf7/y5kYqb3+gL7o7P/FRLBOn34fqRSY=;
        b=ls55/kZl4A656+g+6/0PMJ07Ys14zagM1hask+K2DwFvVfWhfyxR4YQ0/bbLLvdCBI
         eC9pd0+BUotVYjjmab5VKQ6jk0J0CPisKcsnhO47zSusgcU+yCebAU5ES+inSOV0KrHi
         kn7kDVyYTsjR3cC60sNcNBQgRhvOOFSJ07gcDwzpNHgmS7yJJ0tmqUVmfEVAsEDnsVa4
         kvFAPR0/JCq/LlOx6QY2VzSObykW4BuqgOg0fdi2wa/y/usyv6gRkLhwOP30V9jalyvQ
         QLbeSlTffc8ttjJt7mhAckp9ETomL6rObHp9b5gl+aKmdXlmNc+U0adKNzrYj0PQ52sf
         u5ow==
X-Forwarded-Encrypted: i=1; AJvYcCXx//Zwwj2DiH3vmWQWqvVEUSgJI4upiffsm8JIOrqc5GI9KjwOqt4GsMC+1fGD0kOd3Gvd4AIXGuip@vger.kernel.org
X-Gm-Message-State: AOJu0YywYl6r+v5ZVGQ6T21eoM1gjzWGXBtcjDXTv9maFWjiYsaxGqRb
	rRmetXEvX3YsFgV/7D/6ZO17GFrUiPD25Cgymk9autHYPBaKrQQv3dc1eCE8ntBfvuLPLvHMEm1
	Oa/WacbF8QKSpVt0wP6w7nvsp8GXoqZeI0u0KG1W8iw==
X-Gm-Gg: ASbGncsj3l/ZwRnrKAG5GekEbgMdPpr6bt0gOp8NUWkl2yiDILH5NUbM6AdwSOpt/ob
	SgFTrztqgjRNUuaSCMl4dylRycaWz3cYwI5pKlO1MZ5FbDcY5EaB0YyARSgRVfc0NCU9gaOI9k7
	URz3Oq7vM4nMv7nb6pXOHoL9X5YUYAw/zEmzavbUfXiDKEc8Bk8786+r+egWf3pz0hicKXf1emQ
	jEmInk0YCvdqGxmKxfC4gCK7KIZBSsuaQue
X-Google-Smtp-Source: AGHT+IGqqKefXP8WxcN/+l1jwy9unDcdcYQ+LOIaW5Cks3BIj9V+aI0trws7o6JbFaSx8xHpY7sjGGzFBBSJONjxZms=
X-Received: by 2002:a17:907:9687:b0:aff:9906:e452 with SMTP id
 a640c23a62f3a-b1bbb0678f2mr302885666b.31.1758116390548; Wed, 17 Sep 2025
 06:39:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250917124404.2207918-1-max.kellermann@ionos.com> <CAGudoHHSpP_x8MN5wS+e6Ea9UhOfF0PHii=hAx9XwFLbv2EJsg@mail.gmail.com>
In-Reply-To: <CAGudoHHSpP_x8MN5wS+e6Ea9UhOfF0PHii=hAx9XwFLbv2EJsg@mail.gmail.com>
From: Max Kellermann <max.kellermann@ionos.com>
Date: Wed, 17 Sep 2025 15:39:39 +0200
X-Gm-Features: AS18NWCdr6GqUOQd4v8IrrCyA7jXtDhoQx-mp5NUMtPzl5TNlq5K2XQ23QjAEV8
Message-ID: <CAKPOu+9nLUhtVBuMtsTP=7cUR29kY01VedUvzo=GMRez0ZX9rw@mail.gmail.com>
Subject: Re: [PATCH] ceph: fix deadlock bugs by making iput() calls asynchronous
To: Mateusz Guzik <mjguzik@gmail.com>
Cc: slava.dubeyko@ibm.com, xiubli@redhat.com, idryomov@gmail.com, 
	amarkuze@redhat.com, ceph-devel@vger.kernel.org, netfs@lists.linux.dev, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 17, 2025 at 3:14=E2=80=AFPM Mateusz Guzik <mjguzik@gmail.com> w=
rote:
> Does the patch convert literally all iput calls within ceph into the
> async variant? I would be worried that mandatory deferral of literally
> all final iputs may be a regression from perf standpoint.

(Forgot to reply to this part)
No, I changed just the ones that are called from Writeback+Messenger.

I don't think this affects performance at all. It almost never happens
that the last reference gets dropped by somebody other than dcache
(which only happens under memory pressure).
It was very difficult to reproduce this bug:
- "echo 2 >drop_caches" in a loop
- a kernel patch that adds msleep() to several functions
- another kernel patch that allows me to disconnect the Ceph server via ioc=
tl
The latter was to free inode references that are held by Ceph caps.
For this deadlock to occur, all references other than
writeback/messenger must be gone already.
(It did happen on our production servers, crashing all of them a few
days ago causing a major service outage, but apparently in all these
years we're the first ones to observe this deadlock bug.)

(I don't know the iput() ordering on umount/shutdown - that might be
worth a closer look.)

